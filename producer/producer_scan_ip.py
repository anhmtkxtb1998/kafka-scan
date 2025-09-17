from producer.config import producer, delivery_report, get_db_connection
import json
try:
    from producer.config import TOPIC_SCAN
except Exception:
    from config import TOPIC_SCAN
def ip_range_producer():
    print("📤 [ip_ranges → scan-topic] Bắt đầu gửi...")
    with get_db_connection() as conn:
        with conn.cursor() as cur:
            cur.execute(
                """
                SELECT id, parent_unit_name, unit_name, ip_range
                FROM ip_ranges
                WHERE last_scan IS NULL
                   OR last_scan < (NOW() - INTERVAL '2 days')
                """
            )
            for row in cur.fetchall():
                ip_range_id, parent_unit, unit, cidr = row
                data = {
                    'ip_range_id': ip_range_id,
                    'parent_unit_name': parent_unit,
                    'unit_name': unit,
                    'cidr': cidr
                }
                producer.produce(TOPIC_SCAN, json.dumps(data).encode('utf-8'), callback=delivery_report)
    producer.flush()
if __name__ == "__main__":
    ip_range_producer()