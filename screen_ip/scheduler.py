import schedule
import time
import subprocess
import sys
import json
import os
from threading import Thread

# Lấy thư mục hiện tại chứa file schedule.py
BASE_DIR = os.path.dirname(os.path.abspath(__file__))

# Các script
CHECK_22_SCRIPT = os.path.join(BASE_DIR, "checkport22.py")
CHECK_3389_SCRIPT = os.path.join(BASE_DIR, "checkport3389.py")
SCREEN_SCRIPT = os.path.join(BASE_DIR, "screen_ip.py")
GETTEXT_SCRIPT = os.path.join(BASE_DIR, "imagetotext.py")

def run_script(path, label, use_xvfb=False):
    print(f"▶️ Đang chạy {label}")
    try:
        if use_xvfb:
            subprocess.run(["xvfb-run", "-a", "python3", path], check=True)


        else:
            subprocess.run([sys.executable, path], check=True)
    except subprocess.CalledProcessError as e:
        print(f"❌ Lỗi khi chạy {label}: {e}")

def run_checkport22():
    run_script(CHECK_22_SCRIPT, "checkport22.py")

def run_checkport3389():
    run_script(CHECK_3389_SCRIPT, "checkport3389.py")

def run_screen_and_gettext():
    run_script(SCREEN_SCRIPT, "screen_ip.py", use_xvfb=True)
    run_script(GETTEXT_SCRIPT, "imagetotext.py")

def run_producer():
    print("🚀 Bắt đầu quét các cổng và giao diện web...")

    t1 = Thread(target=run_checkport22)
    t2 = Thread(target=run_checkport3389)
    t3 = Thread(target=run_screen_and_gettext)

    t1.start()
    t2.start()
    t3.start()

    # Đợi các luồng hoàn tất (nếu cần blocking)
    t1.join()
    t2.join()
    t3.join()

    print("✅ Hoàn thành quét và phân tích ảnh.")

def schedule_job():
    try:
        interval = json.load(open(os.path.join(BASE_DIR, "schedule_config.json"))).get("interval_minutes", 10)
    except Exception as e:
        print(f"⚠️ Load config failed: {e}")
        interval = 10

    schedule.clear()
    schedule.every(interval).minutes.do(run_producer)
    print(f"🕒 Lên lịch mỗi {interval} phút")

if __name__ == "__main__":
    run_producer()  # chạy lần đầu ngay lập tức
    schedule_job()

    while True:
        schedule.run_pending()
        time.sleep(1)
