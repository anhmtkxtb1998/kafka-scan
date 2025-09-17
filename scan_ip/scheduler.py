import schedule, time, subprocess, sys, json
import os

# Lấy thư mục hiện tại chứa file schedule.py
BASE_DIR = os.path.dirname(os.path.abspath(__file__))
SCAN_SCRIPT = os.path.join(BASE_DIR, "scan_ip.py")

def run_producer():
    print("▶️ Run scan_ip")
    subprocess.run([sys.executable, SCAN_SCRIPT], check=True)

def schedule_job():
    try:
        interval = json.load(open(os.path.join(BASE_DIR, "schedule_config.json"))).get("interval_minutes", 10)
    except Exception as e:
        print(f"⚠️ Load config failed: {e}")
        interval = 10

    schedule.clear()
    schedule.every(interval).minutes.do(run_producer)
    print(f"🕒 every {interval} min (blocking, no overlap)")

if __name__ == "__main__":
    run_producer()          
    schedule_job()

    while True:
        schedule.run_pending() 
        time.sleep(1)
