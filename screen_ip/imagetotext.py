# imagetotext_update_db.py
import os
import re
import json
import easyocr
import psycopg2
import psycopg2.extras as pg_extras
from datetime import datetime

try:
    from screen_ip.config import PGHOST, PGPORT, PGDATABASE, PGUSER, PGPASSWORD, SCREENSHOT_DIR
except Exception:
    from config import PGHOST, PGPORT, PGDATABASE, PGUSER, PGPASSWORD, SCREENSHOT_DIR

DSN = f"host={PGHOST} port={PGPORT} dbname={PGDATABASE} user={PGUSER} password={PGPASSWORD}"

def get_conn():
    return psycopg2.connect(DSN)

def extract_ip_port_from_filename(filename: str):
    """
    Hỗ trợ:
      - IPv4:  1.2.3.4_80.png
      - IPv6 (được screen_ip thay ':' thành '_'): 2001_db8__5_443.png
    """
    base = os.path.splitext(filename)[0]
    # IPv4 trước
    m4 = re.match(r'^(?P<ip>\d+\.\d+\.\d+\.\d+)_(?P<port>\d+)$', base)
    if m4:
        return m4.group("ip"), int(m4.group("port"))
    # fallback: lấy mọi thứ trước dấu '_' cuối là IP-part
    m = re.match(r'^(?P<ip_part>.+)_(?P<port>\d+)$', base)
    if m:
        ip_part = m.group("ip_part")
        # khôi phục IPv6: '_' -> ':'
        ip_guess = ip_part.replace('_', ':')
        return ip_guess, int(m.group("port"))
    return None, None

def extract_text_easyocr(image_path, reader):
    results = reader.readtext(image_path)
    lines = [text for (_, text, conf) in results if conf > 0.4]
    return ';'.join(lines).strip()

def update_detail_port_by_latest(ip: str, port: int, patch: dict):
    """
    Cập nhật vào bản ghi có last_scan mới nhất cho (ip, port).
    Merge JSON: detail_port = detail_port || patch
    """
    if not patch:
        return
    with get_conn() as conn, conn.cursor() as cur:
        cur.execute(
            """
            WITH latest AS (
                SELECT ip_range_id, ip, port
                FROM public.scan_results
                WHERE ip = %s AND port = %s
                ORDER BY last_scan DESC
                LIMIT 1
            )
            UPDATE public.scan_results AS t
            SET detail_port = COALESCE(t.detail_port, '{}'::jsonb) || %s::jsonb
            FROM latest
            WHERE t.ip_range_id = latest.ip_range_id
              AND t.ip = latest.ip
              AND t.port = latest.port
            """,
            (ip, port, pg_extras.Json(patch))
        )
        conn.commit()

def process_images_folder(input_folder):
    reader = easyocr.Reader(['vi', 'en'], gpu=False)
    total = 0
    updated = 0

    for filename in os.listdir(input_folder):
        if not filename.lower().endswith(('.png', '.jpg', '.jpeg', '.bmp')):
            continue

        total += 1
        print(f"🔍 Đang xử lý ảnh: {filename}")
        ip, port = extract_ip_port_from_filename(filename)
        if not ip or not port:
            print(f"⚠️ Không parse được IP/Port từ tên file: {filename}")
            continue

        path = os.path.join(input_folder, filename)
        try:
            text = extract_text_easyocr(path, reader)
            print(f"📝 OCR ({ip}:{port}): {text[:120]}{'...' if len(text) > 120 else ''}")
            if text:
                update_detail_port_by_latest(ip, port, {"text_image": text})
                print(f"✅ Cập nhật DB: detail_port.text_image cho {ip}:{port}")
                updated += 1
            else:
                print("ℹ️ OCR rỗng, bỏ qua cập nhật.")
        except Exception as e:
            print(f"❌ Lỗi OCR {filename}: {e}")

    print(f"🎯 Đã xử lý {total} ảnh, cập nhật DB {updated} bản ghi.")

def main():
    folder = SCREENSHOT_DIR
    if not os.path.isdir(folder):
        print(f"⚠️ Không tìm thấy thư mục ảnh: {folder}")
        return
    process_images_folder(folder)

if __name__ == "__main__":
    main()
