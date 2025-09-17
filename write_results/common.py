import json
import psycopg2
from confluent_kafka import Consumer

try:
    from write_results.config import KAFKA_BOOTSTRAP_SERVERS, DB_CONFIG
    from write_results.config import TOPIC_CHECK_PORT_RESULTS, TOPIC_SCAN_FULL_RESULT, TOPIC_SCAN_RESULTS
except Exception:
    # fallback when running from folder directly
    from config import KAFKA_BOOTSTRAP_SERVERS, DB_CONFIG
    from config import TOPIC_CHECK_PORT_RESULTS, TOPIC_SCAN_FULL_RESULT, TOPIC_SCAN_RESULTS


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
