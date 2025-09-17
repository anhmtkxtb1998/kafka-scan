import json
from datetime import datetime
from write_results.config import get_db_connection, create_kafka_consumer, TOPIC_WRITE_IP_RANGES
# TOPIC_WRITE_IP_RANGES is imported above

def update_ip_range_scan_status(entry):
    """
    Cập nhật bảng ip_ranges với thời gian quét cuối.
    """
    ip_range_id = entry.get('ip_range_id')
    last_scanned_at = entry.get('last_scanned')

    if not ip_range_id or not last_scanned_at:
        print("⚠️ Thiếu ip_range_id hoặc last_scanned trong message.")
        return

    try:
        last_scanned_at_dt = datetime.fromisoformat(last_scanned_at)
    except Exception as e:
        print(f"❗ Lỗi định dạng thời gian: {e}")
        return

    conn = get_db_connection()
    cur = conn.cursor()

    try:
        cur.execute("""
            UPDATE ip_ranges
            SET last_scan = %s
            WHERE id = %s
        """, (last_scanned_at_dt, ip_range_id))

        conn.commit()
        print(f"✅ Cập nhật thành công ip_range_id={ip_range_id} | {last_scanned_at}")
    except Exception as e:
        print(f"❗ Lỗi khi cập nhật DB: {e}")
    finally:
        cur.close()
        conn.close()

def consumer_worker():
    consumer = create_kafka_consumer(TOPIC_WRITE_IP_RANGES, group_id='writer-ip-ranges')
    print("📥 Đang nghe topic `write_ip_ranges`...")

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
                update_ip_range_scan_status(entry)
            except Exception as e:
                print(f"❗ Lỗi xử lý message: {e}")
    except KeyboardInterrupt:
        print("🛑 Dừng consumer.")
    finally:
        consumer.close()

if __name__ == "__main__":
    consumer_worker()
