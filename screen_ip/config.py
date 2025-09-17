import os
from typing import Final

# Kafka
KAFKA_BOOTSTRAP_SERVERS: Final[str] = os.getenv("KAFKA_BOOTSTRAP_SERVERS", "192.168.170.41:9092")
TOPIC_CHECK_PORT: Final[str] = os.getenv("TOPIC_CHECK_PORT", "scan-check-port")
TOPIC_CHECK_PORT_RESULTS: Final[str] = os.getenv("TOPIC_CHECK_PORT_RESULTS", "checkport-results")

# Postgres
PGHOST: Final[str] = os.getenv("PGHOST", "127.0.0.1")
PGPORT: Final[int] = int(os.getenv("PGPORT", "5432"))
PGDATABASE: Final[str] = os.getenv("PGDATABASE", "scanner")
PGUSER: Final[str] = os.getenv("PGUSER", "postgres")
PGPASSWORD: Final[str] = os.getenv("PGPASSWORD", "postgres")

# Screenshots folder
SCREENSHOT_DIR: Final[str] = os.getenv("SCREENSHOT_DIR", os.path.join(os.getcwd(), "screenshots"))
