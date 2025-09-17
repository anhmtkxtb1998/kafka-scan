import os
import sys
import json
import time
import nmap
import ipaddress
import threading
from datetime import datetime
from threading import Thread, Lock
from concurrent.futures import ThreadPoolExecutor
from kafka import KafkaConsumer, KafkaProducer
# ===================== Redis (realtime config) =====================
import redis
try:
    from scan_ip.redis_utils import make_redis_clients
    from scan_ip.config import CONFIG_CHANNEL, BOT_KIND, DEFAULT_SCAN_ARGS
    from scan_ip.config import KAFKA_BOOTSTRAP_SERVERS, TOPIC_SCAN, TOPIC_SCAN_RESULT, TOPIC_WRITE_IP_RANGE
except Exception:
    # fallback if executing from the folder directly
    from redis_utils import make_redis_clients
    from config import CONFIG_CHANNEL, BOT_KIND, DEFAULT_SCAN_ARGS
    from config import KAFKA_BOOTSTRAP_SERVERS, TOPIC_SCAN, TOPIC_SCAN_RESULT, TOPIC_WRITE_IP_RANGE

_rds_cmd, _rds_pub = make_redis_clients(BOT_KIND)

CONFIG = {'args': DEFAULT_SCAN_ARGS}
CONFIG_LOCK = Lock()

def _set_args(new_args: str):
    if not new_args:
        return
    with CONFIG_LOCK:
        if CONFIG.get('args') != new_args:
            print(f"🔄 Cập nhật args → {new_args}")
        CONFIG['args'] = new_args

def load_current_args() -> bool:
    """Đọc key cfg:<BOT_KIND>:current từ Redis để nạp args hiện hành."""
    if not _rds_cmd:
        return False
    key = f"cfg:{BOT_KIND}:current"
    try:
        doc = _rds_cmd.get(key)
        if not doc:
            print(f"ℹ️ Redis chưa có {key}. Dùng DEFAULT_SCAN_ARGS.")
            return False
        data = json.loads(doc)
        args = data.get('args')
        if args:
            _set_args(args)
            return True
        print(f"ℹ️ Key {key} không có 'args'.")
    except Exception as e:
        print(f"⚠️ Lỗi load_current_args(): {e}")
    return False

def pubsub_listener(stop_event: threading.Event | None = None):
    """
    Lắng nghe CONFIG_CHANNEL bền bỉ:
    - Dùng get_message(timeout=30) để tránh socket timeout.
    - Gửi ping keepalive định kỳ, auto-reconnect khi lỗi.
    """
    if not _rds_pub:
        return
    while True:
        try:
            p = _rds_pub.pubsub()
            p.subscribe(CONFIG_CHANNEL)
            print(f"📡 Subscribed Redis Pub/Sub channel: {CONFIG_CHANNEL}")
            last_ping = time.time()
            while True:
                if stop_event and stop_event.is_set():
                    p.close()
                    return
                msg = p.get_message(ignore_subscribe_messages=True, timeout=30.0)
                if msg is None:
                    # keepalive ping qua client command
                    if _rds_cmd and (time.time() - last_ping >= 25):
                        try:
                            _rds_cmd.ping()
                        except Exception as e:
                            raise e
                        last_ping = time.time()
                    continue

                data = msg.get('data')
                try:
                    evt = json.loads(data) if isinstance(data, str) else json.loads(data or "{}")
                except Exception:
                    evt = {}
                # lọc theo bot_kind nếu có
                if evt.get('bot_kind') and evt['bot_kind'] != BOT_KIND:
                    continue
                load_current_args()

        except (redis.exceptions.ConnectionError, redis.exceptions.TimeoutError) as e:
            print(f"⚠️ Pub/Sub bị ngắt ({e}). Thử kết nối lại sau 2s...")
            time.sleep(2)
            continue
        except Exception as e:
            print(f"⚠️ Pub/Sub error: {e}. Reconnect sau 2s...")
            time.sleep(2)
            continue

def get_scan_args() -> str:
    """Lấy args mới nhất (realtime) cho mỗi IP."""
    with CONFIG_LOCK:
        return CONFIG['args'] or DEFAULT_SCAN_ARGS

# ===================== Kafka =====================
KAFKA_BOOTSTRAP_SERVERS = os.getenv('KAFKA_BOOTSTRAP_SERVERS', '192.168.89.138:9092')
TOPIC_SCAN = os.getenv('TOPIC_SCAN', 'scan-topic')
TOPIC_SCAN_RESULT = os.getenv('TOPIC_SCAN_RESULT', 'scan-results')
TOPIC_WRITE_IP_RANGE = os.getenv('TOPIC_WRITE_IP_RANGE', 'write_ip_ranges')

def create_kafka_consumer():
    return KafkaConsumer(
        TOPIC_SCAN,
        bootstrap_servers=KAFKA_BOOTSTRAP_SERVERS,
        group_id='scan_group',
        value_deserializer=lambda m: json.loads(m.decode('utf-8')),
        auto_offset_reset='earliest',
        enable_auto_commit=True
    )

def create_kafka_producer():
    return KafkaProducer(
        bootstrap_servers=KAFKA_BOOTSTRAP_SERVERS,
        value_serializer=lambda v: json.dumps(v).encode('utf-8')
    )

# ===================== Quét mạng =====================
def expand_cidr_to_ips(cidr_range):
    try:
        network = ipaddress.IPv4Network(cidr_range, strict=False)
        return [str(ip) for ip in network.hosts()]
    except Exception as e:
        print(f"⚠️ CIDR không hợp lệ ({cidr_range}): {e}")
        return []

def scan_single_ip(scanner, ip, ip_range_id, scan_args):
    results = []
    print(f'🔎 Scan {ip} với args: {scan_args}')
    try:
        scanner.scan(hosts=ip, arguments=scan_args)
        if ip in scanner.all_hosts():
            host = scanner[ip]
            status = (host.get('status') or {}).get('state')
            tcp = host.get('tcp')
            if tcp:
                for port, port_data in tcp.items():
                    if port_data.get('state') == 'open':
                        results.append({
                            'ip_range_id': ip_range_id,
                            'ip': ip,
                            'port': port,
                            'status_port': 'open',
                            'first_detect': str(datetime.now()),
                            'last_scan': str(datetime.now()),
                            'os': {},
                            'detail_port': {}
                        })
            elif status == 'up':
                # liveness mode (vd: -sn)
                results.append({
                    'ip_range_id': ip_range_id,
                    'ip': ip,
                    'port': None,
                    'status_port': 'alive',
                    'first_detect': str(datetime.now()),
                    'last_scan': str(datetime.now()),
                    'os': {},
                    'detail_port': {}
                })
    except Exception as e:
        print(f"⚠️ Lỗi khi quét {ip} với args='{scan_args}': {e}")
    return results

def scan_ip_group(ip_range_id, parent_name, unit_name, ips, producer=None):
    print(f"🔍 Đang quét {len(ips)} IP (args sẽ lấy realtime từng IP)")
    results = []

    # Chia 2 chunk đơn giản để song song nhẹ
    if len(ips) <= 1:
        chunks = [ips]
    else:
        mid = len(ips) // 2
        chunks = [ips[:mid], ips[mid:]]

    def worker(ip_chunk):
        local_results = []
        scanner = nmap.PortScanner()
        last_args_shown = None
        for ip in ip_chunk:
            current_args = get_scan_args()  # 🔄 realtime trước MỖI IP
            if current_args != last_args_shown:
                print(f"🧭 Args hiện hành: {current_args}")
                last_args_shown = current_args
            local_results += scan_single_ip(scanner, ip, ip_range_id, current_args)
        return local_results

    with ThreadPoolExecutor(max_workers=2) as executor:
        futures = [executor.submit(worker, chunk) for chunk in chunks if chunk]
        for f in futures:
            results.extend(f.result())

    # ✅ Thông báo đã quét xong dải
    if producer:
        update_msg = {"ip_range_id": ip_range_id, "last_scanned_at": datetime.utcnow().isoformat()}
        producer.send(TOPIC_WRITE_IP_RANGE, update_msg)
        producer.flush()
        print(f"📌 Đã gửi thông báo quét xong dải IP ID={ip_range_id} lên topic {TOPIC_WRITE_IP_RANGE}.")

    return results

# ===================== Task Handler =====================
def handle_task(task, producer, index):
    try:
        ip_range_id = task['ip_range_id']
        parent_name = task.get('parent_unit_name')
        unit_name = task.get('unit_name')
        cidr = task['cidr']

        print(f"\n🚀 [Consumer #{index}] Task: {parent_name} / {unit_name} | CIDR: {cidr}")
        ips = expand_cidr_to_ips(cidr)
        if not ips:
            print(f"⚠️ CIDR {cidr} không hợp lệ hoặc không có IP.")
            return

        results = scan_ip_group(ip_range_id, parent_name, unit_name, ips, producer)

        if results:
            print(f"📤 [Consumer #{index}] Gửi {len(results)} kết quả...")
            for entry in results:
                producer.send(TOPIC_SCAN_RESULT, entry)
            producer.flush()
            print(f"✅ [Consumer #{index}] Đã gửi toàn bộ kết quả.")
        else:
            print(f"⚠️ [Consumer #{index}] Không tìm thấy port mở hoặc host alive.")

    except Exception as e:
        print(f"❗ [Consumer #{index}] Lỗi xử lý task: {e}")

# ===================== Consumer worker =====================
def consumer_worker(index):
    consumer = create_kafka_consumer()
    producer = create_kafka_producer()
    print(f"📡 Consumer #{index} khởi động và đang lắng nghe...")

    try:
        for message in consumer:
            task = message.value
            handle_task(task, producer, index)
    except KeyboardInterrupt:
        print(f"\n🛑 Consumer #{index} dừng bởi người dùng.")
    finally:
        consumer.close()

# ===================== Main =====================
if __name__ == "__main__":
    # Nạp args lần đầu từ Redis (nếu có)
    load_current_args()

    # Bật Pub/Sub để realtime đổi tham số
    stop_evt = None
    if _rds_pub:
        stop_evt = threading.Event()
        t_cfg = threading.Thread(target=pubsub_listener, args=(stop_evt,), daemon=True)
        t_cfg.start()

    print("🚀 Khởi động 2 consumer song song...")
    threads = []
    for i in range(2):
        t = Thread(target=consumer_worker, args=(i+1,), daemon=True)
        t.start()
        threads.append(t)

    try:
        for t in threads:
            t.join()
    except KeyboardInterrupt:
        print("\n🛑 Tắt toàn bộ consumer do KeyboardInterrupt.")
        if stop_evt:
            stop_evt.set()
        sys.exit(0)
