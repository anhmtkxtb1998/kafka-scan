from write_results.config import get_db_connection, create_kafka_consumer, TOPIC_SCAN_FULL_RESULT
import json
from threading import Thread
from datetime import datetime
import os
# other helpers are imported explicitly from write_results.config if needed

def write_result_to_scan_full_results(entry):
    conn = get_db_connection()
    cur = conn.cursor()

    cur.execute("""
        SELECT id FROM scan_results 
        WHERE ip = %s AND port = %s AND ip_range_id = %s
    """, (entry['ip'], entry['port'], entry['ip_range_id']))
    existing = cur.fetchone()

    if existing:
        cur.execute("""
            UPDATE scan_results
            SET last_scan = %s, os = %s
            WHERE id = %s
        """, (entry['last_scan'], json.dumps(entry['os']), existing[0]))
    else:
        cur.execute("""
            INSERT INTO scan_results (
                ip_range_id, ip, port, status_port, first_detect, last_scan, os, detail_port
            ) VALUES (%s, %s, %s, %s, %s, %s, %s, %s)
        """, (
            entry['ip_range_id'],
            entry['ip'],
            entry['port'],
            entry['status_port'],
            entry['first_detect'],
            entry['last_scan'],
            json.dumps(entry['os']),
            json.dumps(entry['detail_port'])
        ))

    conn.commit()
    cur.close()
    conn.close()

def consumer_worker():
    consumer = create_kafka_consumer(TOPIC_SCAN_FULL_RESULT, 'writer-scan-full-results')
    print("📥 Đang nghe topic `scan-full-results`...")

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
                write_result_to_scan_full_results(entry)
                print(f"✅ Ghi thành công {entry['ip']}:{entry['port']}")
            except Exception as e:
                print(f"❗ Lỗi xử lý message: {e}")
    except KeyboardInterrupt:
        print("🛑 Dừng consumer.")
    finally:
        consumer.close()

if __name__ == "__main__":
    consumer_worker()
