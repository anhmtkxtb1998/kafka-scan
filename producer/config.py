import os
from typing import Final

# Database
DB_CONFIG = {
    'dbname': os.getenv('DB_NAME', 'postgres'),
    'user': os.getenv('DB_USER', 'postgres'),
    'password': os.getenv('DB_PASSWORD', '123456'),
    'host': os.getenv('DB_HOST', 'localhost'),
    'port': os.getenv('DB_PORT', '5432')
}

# Kafka
KAFKA_BOOTSTRAP_SERVERS: Final[str] = os.getenv("KAFKA_BOOTSTRAP_SERVERS", "192.168.89.138:9092")
TOPIC_SCAN: Final[str] = os.getenv("TOPIC_SCAN", "scan-topic")
TOPIC_FULL: Final[str] = os.getenv("TOPIC_FULL", "scan-full-topic")
TOPIC_CHECK_PORT: Final[str] = os.getenv("TOPIC_CHECK_PORT", "scan-check-port")

import psycopg2
from confluent_kafka import Producer


def get_db_connection():
    return psycopg2.connect(**DB_CONFIG)


# Shared Kafka producer instance
producer = Producer({'bootstrap.servers': KAFKA_BOOTSTRAP_SERVERS})


def delivery_report(err, msg):
    if err:
        print(f"❌ Lỗi gửi Kafka: {err}")
    else:
        print(f"✅ Gửi {msg.topic()} | Offset: {msg.offset()}")
