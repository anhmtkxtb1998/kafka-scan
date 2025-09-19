from write_results.config import get_db_connection, create_kafka_consumer, TOPIC_WRITE_IP_RANGES
from scan_vuln.config import TOPIC_VULN_RESULT
import json
from datetime import datetime


def write_vuln_result(entry):
    # Expect payload: { ip_range_id, ip, port, scanned_at, result }
    ip_range_id = entry.get('ip_range_id')
    ip = entry.get('ip')
    port = entry.get('port')
    scanned_at = entry.get('scanned_at')
    result = entry.get('result')

    conn = get_db_connection()
    cur = conn.cursor()

    # Ensure table exists - best-effort (user likely manages schema)
    try:
        cur.execute("""
        CREATE TABLE IF NOT EXISTS vuln_results (
            id SERIAL PRIMARY KEY,
            ip_range_id INTEGER,
            ip TEXT,
            port INTEGER,
            scanned_at TIMESTAMP,
            result JSONB,
            created_at TIMESTAMP DEFAULT NOW()
        )
        """)
        conn.commit()
    except Exception:
        conn.rollback()

    try:
        cur.execute(
            "INSERT INTO vuln_results (ip_range_id, ip, port, scanned_at, result) VALUES (%s, %s, %s, %s, %s)",
            (ip_range_id, ip, port, scanned_at, json.dumps(result))
        )
        conn.commit()
        print(f"✅ Saved vuln result {ip}:{port}")
    except Exception as e:
        conn.rollback()
        print(f"❌ Failed to save vuln result: {e}")

    cur.close()
    conn.close()


def consumer_worker():
    consumer = create_kafka_consumer(TOPIC_VULN_RESULT, 'writer-vuln-results')
    print(f"📥 Listening for vuln results on {TOPIC_VULN_RESULT}...")
    try:
        while True:
            msg = consumer.poll(timeout=1.0)
            if msg is None:
                continue
            if msg.error():
                print(f"❌ Kafka Error: {msg.error()}")
                continue

            try:
                entry = json.loads(msg.value().decode('utf-8'))
                write_vuln_result(entry)
            except Exception as e:
                print(f"❗ Error processing message: {e}")
    except KeyboardInterrupt:
        print("🛑 Stopping vuln results writer")
    finally:
        consumer.close()


if __name__ == '__main__':
    consumer_worker()
