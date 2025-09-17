import os
from typing import Final

# Kafka
KAFKA_BOOTSTRAP_SERVERS: Final[str] = os.getenv("KAFKA_BOOTSTRAP_SERVERS", "192.168.170.41:9092")
TOPIC_IN: Final[str] = os.getenv('TOPIC_FULL', 'scan-full-topic')
TOPIC_OUT: Final[str] = os.getenv('TOPIC_SCAN_FULL_RESULT', 'scan-full-results')
