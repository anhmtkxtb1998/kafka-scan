import os
import json
import nmap
from datetime import datetime
from kafka import KafkaConsumer, KafkaProducer
from threading import Thread
from dotenv import load_dotenv
import sys

load_dotenv()

try:
    from scan_full_port.config import KAFKA_BOOTSTRAP_SERVERS, TOPIC_IN, TOPIC_OUT
except Exception:
    from config import KAFKA_BOOTSTRAP_SERVERS, TOPIC_IN, TOPIC_OUT

# ================= Kafka =================
def create_consumer():
    return KafkaConsumer(
        TOPIC_IN,
        bootstrap_servers=KAFKA_BOOTSTRAP_SERVERS,
        group_id='scan_full_consumer',
        auto_offset_reset='earliest',
        value_deserializer=lambda x: json.loads(x.decode('utf-8'))
    )

def create_producer():
    return KafkaProducer(
        bootstrap_servers=KAFKA_BOOTSTRAP_SERVERS,
        value_serializer=lambda x: json.dumps(x, ensure_ascii=False).encode('utf-8')
    )

def delivery_report(err, msg):
    if err:
        print(f"❌ Gửi thất bại: {err}")
    else:
        print(f"✅ Gửi đến {msg.topic()} [{msg.partition()}] offset {msg.offset()}")

# ================= Scan logic =================
def scan_single_ip(ip, ip_range_id):
    results = []
    scanner = nmap.PortScanner()
    try:
        scanner.scan(hosts=ip, arguments='-sT -T4 --min-rate 1500 --max-retries 2 -O -p 20-65535')
        os_guess = "Không xác định"
        if ip in scanner.all_hosts():
            if 'osmatch' in scanner[ip] and scanner[ip]['osmatch']:
                os_guess = scanner[ip]['osmatch'][0]['name']
            if 'tcp' in scanner[ip]:
                for port, port_data in scanner[ip]['tcp'].items():
                    results.append({
                        'ip_range_id': ip_range_id,
                        'ip': ip,
                        'port': port,
                        'status_port': port_data.get('state', 'unknown'),
                        'first_detect': str(datetime.now()),
                        'last_scan': str(datetime.now()),
                        'os': os_guess,
                        'detail_port': {}
                    })
    except Exception as e:
        print(f"⚠️ Lỗi quét IP {ip}: {e}")
    return results

# ================= Consumer worker =================
def consumer_worker(index):
    consumer = create_consumer()
    producer = create_producer()
    print(f"📡 Consumer FullPort #{index} khởi động và đang lắng nghe...")

    try:
        for msg in consumer:
            try:
                data = msg.value
                ip = data['ip']
                ip_range_id = data['ip_range_id']
                print(f"🔍 [Consumer #{index}] Nhận task quét IP: {ip}")

                # Quét một IP duy nhất trong 1 luồng
                result = scan_single_ip(ip, ip_range_id)

                # Chỉ gửi kết quả duy nhất (tránh gửi trùng nếu 2 luồng quét cùng IP)
                unique_results = {(r['port'], r['ip']): r for r in result}.values()

                for result in unique_results:
                    producer.send(
                        topic=TOPIC_OUT,
                        value=result,
                        on_delivery=delivery_report
                    )
                producer.flush()

                print(f"✅ [Consumer #{index}] Đã gửi {len(unique_results)} kết quả full-port.")
            except Exception as e:
                print(f"❌ [Consumer #{index}] Lỗi xử lý message: {e}")
    except KeyboardInterrupt:
        print(f"\n🛑 Consumer #{index} dừng bởi người dùng.")
    finally:
        consumer.close()

# ================= Main =================
if __name__ == "__main__":

    print("🚀 Khởi động 2 consumer, mỗi cái chạy 1 luồng quét IP...")

    threads = []
    for i in range(2):  # 2 consumers song song
        t = Thread(target=consumer_worker, args=(i + 1,), daemon=True)
        t.start()
        threads.append(t)

    try:
        for t in threads:
            t.join()
    except KeyboardInterrupt:
        print("\n🛑 Tắt tất cả consumer do KeyboardInterrupt.")
        sys.exit(0)
