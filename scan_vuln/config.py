import os
from typing import Final

# Nmap options tuned to be low-intensity to reduce firewall/IDS detection
# These defaults aim to be cautious. Adjust via env `VULN_SCAN_ARGS` if needed.
VULN_SCAN_ARGS: Final[str] = os.getenv('VULN_SCAN_ARGS', '-sS -Pn -T2 --max-retries 1 --min-rate 50')
# Scripts to run - default to vuln category
VULN_SCRIPTS: Final[str] = os.getenv('VULN_SCRIPTS', 'vuln')
# Output format temporary file prefix
TMP_OUTPUT_PREFIX: Final[str] = os.getenv('VULN_TMP_PREFIX', '/tmp/scan_vuln')

# Kafka + DB settings to integrate with existing pipeline
KAFKA_BOOTSTRAP_SERVERS: Final[str] = os.getenv('KAFKA_BOOTSTRAP_SERVERS', '192.168.89.138:9092')
TOPIC_VULN_SCAN: Final[str] = os.getenv('TOPIC_VULN_SCAN', 'vuln-scan')
TOPIC_VULN_RESULT: Final[str] = os.getenv('TOPIC_VULN_RESULT', 'vuln-results')

# Database (use same conventions as other modules)
DB_CONFIG = {
	'dbname': os.getenv('DB_NAME', 'postgres'),
	'user': os.getenv('DB_USER', 'postgres'),
	'password': os.getenv('DB_PASSWORD', '123456'),
	'host': os.getenv('DB_HOST', 'localhost'),
	'port': os.getenv('DB_PORT', '5432')
}

import psycopg2
from confluent_kafka import Producer, Consumer


def get_db_connection():
	return psycopg2.connect(**DB_CONFIG)


# Provide a shared producer for convenience
producer = Producer({'bootstrap.servers': KAFKA_BOOTSTRAP_SERVERS})


def create_kafka_consumer(topic_name, group_id):
	conf = {
		'bootstrap.servers': KAFKA_BOOTSTRAP_SERVERS,
		'group.id': group_id,
		'auto.offset.reset': 'earliest'
	}
	c = Consumer(conf)
	c.subscribe([topic_name])
	return c


def delivery_report(err, msg):
	if err:
		print(f"❌ Kafka send error: {err}")
	else:
		print(f"✅ Sent {msg.topic()} | Offset: {msg.offset()}")
