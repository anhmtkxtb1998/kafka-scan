from producer.config import producer, delivery_report, get_db_connection
import json
try:
    from producer.config import TOPIC_CHECK_PORT
except Exception:
    from config import TOPIC_CHECK_PORT
def port_check_producer():
    print("📤 [scan_results → scan-check-port] Bắt đầu gửi...")
    with get_db_connection() as conn:
        with conn.cursor() as cur:
            cur.execute("SELECT ip, port FROM scan_results WHERE port IN (80, 443, 22, 3389)")
            for ip, port in cur.fetchall():
                data = {
                    "ip": ip,
                    "port": port
                }
                producer.produce(TOPIC_CHECK_PORT, json.dumps(data).encode('utf-8'), callback=delivery_report)
    producer.flush()

if __name__ == "__main__":
    port_check_producer()
