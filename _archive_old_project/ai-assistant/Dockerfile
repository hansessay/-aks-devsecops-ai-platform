FROM python:3.11-slim

WORKDIR /app

RUN apt-get update && apt-get install -y curl ca-certificates && \
    curl -LO "https://dl.k8s.io/release/v1.33.0/bin/linux/amd64/kubectl" && \
    install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl && \
    rm kubectl && \
    pip install flask && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

COPY app.py .

EXPOSE 5000

CMD ["python", "app.py"]