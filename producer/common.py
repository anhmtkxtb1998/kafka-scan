import json
import psycopg2
from confluent_kafka import Producer
from dotenv import load_dotenv

load_dotenv()

try:
    from producer.config import DB_CONFIG, KAFKA_BOOTSTRAP_SERVERS
except Exception:
    from config import DB_CONFIG, KAFKA_BOOTSTRAP_SERVERS


def get_db_connection():
    return psycopg2.connect(**DB_CONFIG)


producer = Producer({'bootstrap.servers': KAFKA_BOOTSTRAP_SERVERS})


def delivery_report(err, msg):
    if err:
        print(f"❌ Lỗi gửi Kafka: {err}")
    else:
        print(f"✅ Gửi {msg.topic()} | Offset: {msg.offset()}")
