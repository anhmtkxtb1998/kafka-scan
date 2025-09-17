import schedule
import time
import subprocess
import threading
import sys
import json

CONFIG_PATH = "schedule_config.json"

def load_config():
    with open(CONFIG_PATH, "r") as f:
        return json.load(f)

def run_producer(script_name):
    print(f"▶️ Running {script_name}...")
    try:
        result = subprocess.run(
            [sys.executable, script_name],
            stdout=subprocess.PIPE,
            stderr=subprocess.PIPE,
            text=True,
            check=True
        )
        print(result.stdout)
    except subprocess.CalledProcessError as e:
        print(f"❌ {script_name} failed:\n{e.stderr}")

def schedule_producer(name, script, interval):
    # Chạy lần đầu
    run_producer(script)
    # Thiết lập lịch
    schedule.every(interval).minutes.do(lambda: run_producer(script))
    print(f"🕒 [{name}] scheduled every {interval} minutes.")

    while True:
        schedule.run_pending()
        time.sleep(1)

def main():
    config = load_config()

    threads = []
    for name, cfg in config.items():
        script = cfg.get("script")
        interval = cfg.get("interval_minutes", 60)
        t = threading.Thread(target=schedule_producer, args=(name, script, interval), daemon=True)
        t.start()
        threads.append(t)

    # Giữ main thread sống
    try:
        for t in threads:
            t.join()
    except KeyboardInterrupt:
        print("🛑 Đã dừng scheduler.")

if __name__ == "__main__":
    main()
