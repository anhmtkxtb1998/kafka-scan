import csv
import os
import time
import re
import json
import requests
from bs4 import BeautifulSoup
from requests.exceptions import RequestException
from selenium import webdriver
from selenium.webdriver.firefox.options import Options
from selenium.webdriver.firefox.service import Service
from kafka import KafkaConsumer  # Import KafkaConsumer from kafka-python
from threading import Thread
try:
    from screen_ip.config import KAFKA_BOOTSTRAP_SERVERS, TOPIC_CHECK_PORT
except Exception:
    from config import KAFKA_BOOTSTRAP_SERVERS, TOPIC_CHECK_PORT
    # no common import needed; config provides required constants

# ================== Setup ==================
headers = {
    'User-Agent': 'Mozilla/5.0 (Windows NT 10.0; Win64; x64)'
}

firefox_options = Options()
firefox_options.headless = False
geckodriver_path = '/usr/local/bin/geckodriver'
service = Service(geckodriver_path)

def create_consumer():
    return KafkaConsumer(
        TOPIC_CHECK_PORT,  # Subscribe to the topic
        bootstrap_servers=KAFKA_BOOTSTRAP_SERVERS,
        group_id='screen_consumer',
        auto_offset_reset='earliest',
        enable_auto_commit=True,
        value_deserializer=lambda x: json.loads(x.decode('utf-8'))
    )

def sanitize_filename(name):
    return re.sub(r'[^a-zA-Z0-9_\-\.]', '_', name)

def slugify(text):
    return re.sub(r'[^\w]+', '_', text.strip()).lower()

def extract_title(html):
    try:
        soup = BeautifulSoup(html, 'html.parser')
        return soup.title.string.strip() if soup.title else ''
    except:
        return ''

def detect_system(html, response_headers):
    html = html.lower()
    server = response_headers.get("Server", "").lower()
    if "cisco" in html or "asa" in html or "firepower" in html or "cisco" in server:
        return "Cisco"
    elif "esxi" in html or "vmware" in html or "vmware" in server:
        return "VMware ESXi"
    elif "fortinet" in html or "fortigate" in html or "fortigate" in server:
        return "Fortinet Firewall"
    elif "nginx" in server:
        return "Nginx"
    elif "apache" in server:
        return "Apache"
    elif "firewall" in html or "firewall" in server:
        return "Generic Firewall"
    elif "<html" in html:
        return "Web UI (Unknown)"
    else:
        return "Unknown"

def check_https(ip_or_host):
    try:
        response = requests.get(f'https://{ip_or_host}', headers=headers, timeout=10, verify=False, allow_redirects=True)
        html = response.text
        return True, response.status_code, detect_system(html, response.headers), extract_title(html)
    except RequestException:
        return False, None, '', ''

def check_http(ip_or_host):
    try:
        response = requests.get(f'http://{ip_or_host}', headers=headers, timeout=10, verify=False, allow_redirects=True)
        html = response.text
        return True, response.status_code, detect_system(html, response.headers), extract_title(html)
    except RequestException:
        return False, None, '', ''

def take_screenshot(driver, url, filename):
    try:
        driver.get(url)
        time.sleep(2)
        folder = os.path.dirname(filename)
        os.makedirs(folder, exist_ok=True)
        safe_path = os.path.join(folder, sanitize_filename(filename))
        driver.save_screenshot(safe_path)
        print(f'📸 Đã chụp ảnh: {safe_path}')
        return safe_path
    except Exception as e:
        print(f'❌ Lỗi khi chụp ảnh {url}: {e}')
        return ''

# ================== Consumer Worker ==================
def consumer_worker():
    consumer = create_consumer()
    driver = webdriver.Firefox(service=service, options=firefox_options)
    screenshot_folder = os.path.join(os.getcwd(), 'screenshots')
    output_file = os.path.join(screenshot_folder, 'screenshot_results.csv')

    # Nếu là thư mục (bị mount sai) thì cảnh báo
    if os.path.isdir(output_file):
        raise RuntimeError(f"❌ {output_file} là thư mục, không phải file. Kiểm tra docker volume mount!")

    # Tạo thư mục nếu chưa tồn tại
    os.makedirs(screenshot_folder, exist_ok=True)

    # Xác định có cần ghi header không
    write_header = not os.path.exists(output_file)
    with open(output_file, 'a', newline='', encoding='utf-8-sig') as outfile:
        writer = csv.writer(outfile)
        writer.writerow(['IP', 'Port', 'Accessible', 'HTTP Status', 'Detected System', 'Title', 'Screenshot Path'])

        print(f"🚦 Consumer screen_ip đang lắng nghe topic `{TOPIC_CHECK_PORT}`...")

        try:
            for msg in consumer:  # Iterate over messages
                data = msg.value
                ip = data.get('ip')
                port = data.get('port')

                if port not in (80, 443):
                    continue

                print(f"[📡 Đang xử lý: {ip}:{port}")

                accessible, status_code, detected, title = check_https(ip)
                protocol = ''
                url = ''

                if accessible:
                    protocol = 'HTTPS'
                    url = f'https://{ip}'
                else:
                    accessible, status_code, detected, title = check_http(ip)
                    if accessible:
                        protocol = 'HTTP'
                        url = f'http://{ip}'

                screenshot_path = ''
                if accessible and status_code == 200:
                    filename = f'{ip.replace(":", "_")}_{port}.png'
                    screenshot_path = take_screenshot(driver, url, os.path.join(screenshot_folder, filename))

                http_status = f"{protocol} {status_code}" if status_code else ''
                writer.writerow([ip, port, accessible, http_status, detected, title, screenshot_path])
                outfile.flush()

        except KeyboardInterrupt:
            print(f"\n🛑 Consumer dừng bởi người dùng.")
        finally:
            consumer.close()
            driver.quit()

# ================== Main ==================
if __name__ == "__main__":
    print("🚀 Khởi động consumer screen_ip để chụp ảnh IP...")
    consumer_worker()
