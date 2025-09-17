FROM python:3.10-slim

# Cài thư viện hệ thống cần thiết
RUN apt-get update && apt-get install -y \
    build-essential \
    libpq-dev \
    gcc \
    wget \
    unzip \
    xvfb \
    tesseract-ocr \
    libgl1 \
    libglib2.0-0 \
    libsm6 \
    libxext6 \
    libxrender1 \
    firefox-esr \
    && rm -rf /var/lib/apt/lists/*

# Cài đặt geckodriver
RUN wget -q https://github.com/mozilla/geckodriver/releases/download/v0.34.0/geckodriver-v0.34.0-linux64.tar.gz && \
    tar -xzf geckodriver-v0.34.0-linux64.tar.gz && \
    mv geckodriver /usr/local/bin && \
    rm geckodriver-v0.34.0-linux64.tar.gz

# Tạo thư mục làm việc
WORKDIR /app

# Sao chép code vào container
COPY . /app

# Sao chép requirements.txt
COPY requirements.txt .

# Cài Python dependencies (với phiên bản torch phù hợp)
RUN pip install --upgrade pip && \
    pip install --no-cache-dir torch==2.0.1 torchvision==0.15.2 torchaudio==2.0.2 --index-url https://download.pytorch.org/whl/cpu && \
    pip install --no-cache-dir -r requirements.txt

# Trong Dockerfile:
RUN python3 -c "import easyocr; easyocr.Reader(['en','vi'], gpu=False)"


CMD ["python", "scheduler.py"]
