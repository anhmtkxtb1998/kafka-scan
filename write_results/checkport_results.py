from write_results.config import get_db_connection, create_kafka_consumer, TOPIC_CHECK_PORT_RESULTS
import json
from threading import Thread
from datetime import datetime
import os
# other helpers are imported explicitly from write_results.config if needed

def write_result_from_checkport(entry):
    conn = get_db_connection()
    cur = conn.cursor()

    ip = entry['ip']
    port = entry['port']
    detail = entry.get('detail_port', {})

    now = datetime.now()

    cur.execute("""
        SELECT id FROM scan_results 
        WHERE ip = %s AND port = %s
    """, (ip, port))
    existing = cur.fetchone()

    if existing:
        cur.execute("""
            UPDATE scan_results 
            SET detail_port = %s, last_scan = %s 
            WHERE id = %s
        """, (json.dumps(detail), now, existing[0]))

    conn.commit()
    cur.close()
    conn.close()

def consumer_worker():
    consumer = create_kafka_consumer(TOPIC_CHECK_PORT_RESULTS, 'writer-checkport-results')
    print("📥 Đang nghe topic `checkport-results`...")

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
                write_result_from_checkport(entry)
                print(f"✅ Ghi thành công {entry['ip']}:{entry['port']}")
            except Exception as e:
                print(f"❗ Lỗi xử lý message: {e}")
    except KeyboardInterrupt:
        print("🛑 Dừng consumer.")
    finally:
        consumer.close()

if __name__ == "__main__":
    consumer_worker()
