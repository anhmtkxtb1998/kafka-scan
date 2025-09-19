from scan_vuln.config import producer, delivery_report, get_db_connection, TOPIC_VULN_SCAN
import json
from collections import defaultdict
from datetime import datetime


def vuln_producer(days_back: int = 7, limit: int | None = None):
    """Query DB for open ports, group by IP and publish scan tasks to Kafka.

    Each message contains: ip_range_id, ip, ports (list), last_scan
    Grouping reduces number of nmap processes and allows focused -p scans.
    """
    print("📤 [vuln producer] Starting to publish grouped vuln scan tasks...")
    q = "SELECT ip_range_id, ip, port, last_scan FROM scan_results WHERE status_port = 'open'"
    if days_back is not None:
        q += f" AND (last_scan IS NULL OR last_scan < (NOW() - INTERVAL '{int(days_back)} days'))"
    if limit:
        q += f" LIMIT {int(limit)}"

    groups = defaultdict(lambda: {"ports": [], "ip_range_id": None, "last_scan": None})

    with get_db_connection() as conn:
        with conn.cursor() as cur:
            cur.execute(q)
            for row in cur.fetchall():
                ip_range_id, ip, port, last_scan = row
                key = ip
                groups[key]["ip_range_id"] = ip_range_id
                groups[key]["ports"].append(int(port) if port is not None else None)
                groups[key]["last_scan"] = groups[key]["last_scan"] or last_scan

    for ip, info in groups.items():
        msg = {
            'ip_range_id': info['ip_range_id'],
            'ip': ip,
            'ports': [p for p in info['ports'] if p is not None],
            'last_scan': str(info['last_scan']) if info['last_scan'] is not None else None
        }
        producer.produce(TOPIC_VULN_SCAN, json.dumps(msg).encode('utf-8'), callback=delivery_report)

    producer.flush()


if __name__ == '__main__':
    vuln_producer()
