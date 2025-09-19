import json
from scan_vuln.config import create_kafka_consumer, TOPIC_VULN_SCAN, TOPIC_VULN_RESULT, producer, delivery_report
from scan_vuln.scan_vuln import run_nmap_on_targets
from write_results.config import TOPIC_SCAN_RESULTS


def worker():
    consumer = create_kafka_consumer(TOPIC_VULN_SCAN, 'vuln-worker')
    print(f"📥 Listening for vuln tasks on {TOPIC_VULN_SCAN}...")

    try:
        while True:
            msg = consumer.poll(timeout=1.0)
            if msg is None:
                continue
            if msg.error():
                print(f"❌ Kafka Error: {msg.error()}")
                continue

            try:
                task = json.loads(msg.value().decode('utf-8'))
                ip = task.get('ip')
                ports = task.get('ports') or []
                ip_range_id = task.get('ip_range_id')

                targets = [f"{ip}"]
                extra_args = ''
                if ports:
                    port_list = ','.join(str(int(p)) for p in ports if p is not None)
                    extra_args = f"-p {port_list}"

                res = run_nmap_on_targets(targets, extra_args=extra_args)

                # Publish into the common scan-results topic so existing writer can consume
                # For backward compatibility include one message per open port detected
                for host in res.get('hosts', []):
                    ip_addr = host.get('ip')
                    # publish each port as a separate record matching existing write_results format
                    for p in host.get('ports', []):
                        payload = {
                            'ip_range_id': ip_range_id,
                            'ip': ip_addr,
                            'port': p.get('port'),
                            'status_port': p.get('state'),
                            'first_detect': None,
                            'last_scan': res.get('scanned_at'),
                            'os': {},
                            'detail_port': host.get('scripts', [])
                        }
                        producer.produce(TOPIC_SCAN_RESULTS, json.dumps(payload).encode('utf-8'), callback=delivery_report)
                producer.flush()
            except Exception as e:
                print(f"❗ Worker error: {e}")
    except KeyboardInterrupt:
        print("🛑 Stopping vuln worker")
    finally:
        consumer.close()


if __name__ == '__main__':
    worker()
