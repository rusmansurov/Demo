# Demonstration Apache Spark 4.0 in Docker with MinIO Cloud storage

This repository contains a demonstration Apache Spark Docker cluster that simulates distributed computing as it would work in real-world production systems. The cluster includes:

- **Spark Master**
- **Two Spark Workers**
- **Spark History Server**
- **MinIO Cloud storage**

## Features
- Simulation of distributed computing
- Support for Python
- Logging and job history viewing via Spark History Server
- Easy setup and launch with Docker Compose

## Components
- **Apache Spark 4.0.0** (Scala 2.13, Java 17, Ubuntu)
- **Python 3**
- **Spark Master, two Workers, and History Server**
- **Preconfigured settings and entrypoint.sh**

## Getting Started
### 1. Clone the Repository

### 2. Build the Docker Image
```sh
docker build -t my-spark:4.0.0 .
```

### 3. Start the Cluster
```sh
docker-compose up -d
```

### 4. Access Web Interfaces
- **Spark Master UI:** http://localhost:8080
- **Spark Worker 1 UI:** http://localhost:9091
- **Spark Worker 2 UI:** http://localhost:9092
- **Spark History Server:** http://localhost:18080
- **MinIO WebUI:** http://localhost:9001

## Submit Example job
```sh
docker exec -it spark-master spark-submit app/write_to_minio.py
```

**Find data in your local MinIO spark-demo bucket**
- open MinIO WebUI in your browser: http://localhost:9001
`Login: minioadmin`
`Password: minioadmin`



