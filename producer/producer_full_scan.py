from producer.config import producer, delivery_report, get_db_connection
import json
try:
    from producer.config import TOPIC_FULL
except Exception:
    from config import TOPIC_FULL
def full_scan_producer():
    print("📤 [scan_results → scan-full-topic] Bắt đầu gửi...")
    with get_db_connection() as conn:
        with conn.cursor() as cur:
            cur.execute("SELECT DISTINCT ip, ip_range_id FROM scan_results")
            for ip, ip_range_id in cur.fetchall():
                data = {
                    "ip": ip,
                    "ip_range_id": ip_range_id
                }
                producer.produce(TOPIC_FULL, json.dumps(data).encode('utf-8'), callback=delivery_report)
    producer.flush()

if __name__ == "__main__":
    full_scan_producer()