import os
from typing import Final

# Kafka
KAFKA_BOOTSTRAP_SERVERS: Final[str] = os.getenv('KAFKA_BOOTSTRAP_SERVERS','192.168.89.138:9092')
TOPIC_CHECK_PORT_RESULTS: Final[str] = os.getenv('TOPIC_CHECK_PORT_RESULTS','scan-check-port')
TOPIC_SCAN_FULL_RESULT: Final[str] = os.getenv('TOPIC_SCAN_FULL_RESULT','scan-full-results')
TOPIC_SCAN_RESULTS: Final[str] = os.getenv('TOPIC_SCAN_RESULT','scan-results')
TOPIC_WRITE_IP_RANGES: Final[str] = os.getenv('TOPIC_WRITE_IP_RANGE','write_ip_ranges')

# Database (fallback defaults - consider using env vars)
DB_CONFIG = {
    "dbname": os.getenv('DB_NAME', 'postgres'),
    "user": os.getenv('DB_USER', 'postgres'),
    "password": os.getenv('DB_PASSWORD', '123456'),
    "host": os.getenv('DB_HOST', 'localhost'),
    "port": os.getenv('DB_PORT', '5432')
}

import psycopg2
from confluent_kafka import Consumer


def get_db_connection():
    return psycopg2.connect(**DB_CONFIG)


def create_kafka_consumer(topic_name, group_id):
    conf = {
        'bootstrap.servers': KAFKA_BOOTSTRAP_SERVERS,
        'group.id': group_id,
        'auto.offset.reset': 'earliest'
    }
    consumer = Consumer(conf)
    consumer.subscribe([topic_name])
    return consumer
