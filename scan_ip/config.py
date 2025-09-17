import os
from typing import Final

# Redis
REDIS_URL: Final[str] = os.getenv('REDIS_URL', 'redis://localhost:6379/0')
REDIS_PASSWORD: Final[str | None] = os.getenv('REDIS_PASSWORD', '123456')
REDIS_USERNAME: Final[str | None] = os.getenv('REDIS_USERNAME', 'default')

# Runtime config / channels
CONFIG_CHANNEL: Final[str] = os.getenv('CONFIG_CHANNEL', 'scan.config')
BOT_KIND: Final[str] = os.getenv('BOT_KIND', 'basic')
DEFAULT_SCAN_ARGS: Final[str] = os.getenv('DEFAULT_SCAN_ARGS', '-sT -T4 -p 20,21,22,23,80,443,1433,3389,8080')

# Kafka
KAFKA_BOOTSTRAP_SERVERS: Final[str] = os.getenv('KAFKA_BOOTSTRAP_SERVERS', '192.168.89.138:9092')
TOPIC_SCAN: Final[str] = os.getenv('TOPIC_SCAN', 'scan-topic')
TOPIC_SCAN_RESULT: Final[str] = os.getenv('TOPIC_SCAN_RESULT', 'scan-results')
TOPIC_WRITE_IP_RANGE: Final[str] = os.getenv('TOPIC_WRITE_IP_RANGE', 'write_ip_ranges')
