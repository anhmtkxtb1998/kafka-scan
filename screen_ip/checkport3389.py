import socket
import json
import os

from confluent_kafka import Consumer, Producer
try:
    from screen_ip.config import KAFKA_BOOTSTRAP_SERVERS, TOPIC_CHECK_PORT, TOPIC_CHECK_PORT_RESULTS
except Exception:
    from config import KAFKA_BOOTSTRAP_SERVERS, TOPIC_CHECK_PORT, TOPIC_CHECK_PORT_RESULTS


def check_rdp(ip, port=3389, timeout=3):
    try:
        with socket.socket(socket.AF_INET, socket.SOCK_STREAM) as s:
            s.settimeout(timeout)
            s.connect((ip, port))

            # Gửi gói RDP NegReq để kiểm tra phản hồi
            rdp_request = bytes.fromhex("030000130ee000000000000100080000000000")
            s.sendall(rdp_request)

            response = s.recv(1024)
            if response and response.startswith(b'\x03\x00'):
                return True
    except:
        pass
    return False

def create_kafka_consumer():
    conf = {
        'bootstrap.servers': KAFKA_BOOTSTRAP_SERVERS,
        'group.id': 'rdp-check-group',
        'auto.offset.reset': 'earliest'
    }
    consumer = Consumer(conf)
    consumer.subscribe([TOPIC_CHECK_PORT])
    return consumer

def create_kafka_producer():
    conf = {
        'bootstrap.servers': KAFKA_BOOTSTRAP_SERVERS
    }
    return Producer(conf)

def send_result(producer, ip, port, status):
    message = {
        "ip": ip,
        "port": port,
        "detail_port": {
            "rdp_status": status
        }
    }
    try:
        producer.produce(TOPIC_CHECK_PORT_RESULTS, json.dumps(message).encode("utf-8"))
        producer.flush()
        print(f"📤 Gửi kết quả lên topic {TOPIC_CHECK_PORT_RESULTS}: {message}")
    except Exception as e:
        print(f"❌ Lỗi khi gửi Kafka message: {e}")

def main():
    consumer = create_kafka_consumer()
    producer = create_kafka_producer()
    print(f"Đang lắng nghe Kafka topic {TOPIC_CHECK_PORT} để kiểm tra RDP...")

    try:
        while True:
            msg = consumer.poll(1.0)
            if msg is None:
                continue
            if msg.error():
                print(f"Kafka error: {msg.error()}")
                continue

            try:
                data = json.loads(msg.value().decode("utf-8"))
                ip = data.get("ip", "").strip()
                port = int(data.get("port", 0))

                if not ip or port != 3389:
                    continue  # Bỏ qua nếu không phải port 3389

                print(f"🔍 Kiểm tra RDP: {ip}:{port}")
                is_open = check_rdp(ip)
                status = "open" if is_open else "closed"
                print(f"{'[+]' if is_open else '[-]'} {ip} RDP is {status}")

                send_result(producer, ip, port, status)

            except Exception as e:
                print(f"❌ Lỗi xử lý message: {e}")

    except KeyboardInterrupt:
        print("\n🛑 Dừng bởi người dùng.")
    finally:
        consumer.close()

if __name__ == "__main__":
    main()
