import socket
import json
import os
from confluent_kafka import Consumer, Producer
try:
    from screen_ip.config import KAFKA_BOOTSTRAP_SERVERS, TOPIC_CHECK_PORT, TOPIC_CHECK_PORT_RESULTS
except Exception:
    from config import KAFKA_BOOTSTRAP_SERVERS, TOPIC_CHECK_PORT, TOPIC_CHECK_PORT_RESULTS
def is_ssh_open(host, port=22, timeout=2):
    try:
        with socket.create_connection((host, port), timeout=timeout):
            return True
    except:
        return False

# Kafka consumer
def create_kafka_consumer():
    conf = {
        'bootstrap.servers': KAFKA_BOOTSTRAP_SERVERS,
        'group.id': 'ssh-check-group',
        'auto.offset.reset': 'earliest'
    }
    consumer = Consumer(conf)
    consumer.subscribe([TOPIC_CHECK_PORT])
    return consumer

# Kafka producer
def create_kafka_producer():
    conf = {
        'bootstrap.servers': KAFKA_BOOTSTRAP_SERVERS
    }
    return Producer(conf)

def send_result(producer, ip, port, status):
    message = {
        'ip': ip,
        'port': port,
        'detail_port': {
            'ssh_status': status
        }
    }
    try:
        producer.produce(TOPIC_CHECK_PORT_RESULTS, json.dumps(message).encode('utf-8'))
        producer.flush()
        print(f"Gửi kết quả lên topic {TOPIC_CHECK_PORT_RESULTS}: {message}")
    except Exception as e:
        print(f"Lỗi khi gửi Kafka message: {e}")

def main():
    consumer = create_kafka_consumer()
    producer = create_kafka_producer()
    print(f"Lắng nghe topic {TOPIC_CHECK_PORT} và gửi kết quả SSH lên 'checkport-results'...")

    try:
        while True:
            msg = consumer.poll(1.0)
            if msg is None:
                continue
            if msg.error():
                print(f'Kafka error: {msg.error()}')
                continue

            try:
                data = json.loads(msg.value().decode('utf-8'))
                ip = data.get('ip', '').strip()
                port = int(data.get('port', 0))

                if not ip or port != 22:
                    continue  # Chỉ kiểm tra port 22

                print(f"🔍 Kiểm tra SSH: {ip}:{port}")
                is_open = is_ssh_open(ip)
                status = "open" if is_open else "closed"
                print(f"{'[+]' if is_open else '[-]'} {ip} is {status}")

                send_result(producer, ip, port, status)

            except json.JSONDecodeError as je:
                print(f"❌ JSON decode lỗi: {je}")
            except Exception as e:
                print(f"❌ Lỗi xử lý message: {e}")

    except KeyboardInterrupt:
        print("\n🛑 Dừng bởi người dùng.")
    finally:
        consumer.close()

if __name__ == "__main__":
    main()
