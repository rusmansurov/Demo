# Demonstration Apache Spark in Docker

This repository contains a demonstration Apache Spark Docker cluster that simulates distributed computing as it would work in real-world production systems. The cluster includes:

- **Spark Master**
- **Two Spark Workers**
- **Spark History Server** (for viewing completed jobs)

## Features
- Simulation of distributed computing
- Support for Python
- Logging and job history viewing via Spark History Server
- Easy setup and launch with Docker Compose

## Components
- **Apache Spark 3.5.1** (Scala 2.12, Java 11, Ubuntu)
- **Python 3 and pip**
- **Spark Master, two Workers, and History Server**
- **Preconfigured settings and entrypoint.sh**

## Getting Started
### 1. Clone the Repository

### 2. Build the Docker Image
```sh
docker build -t my-custom-spark .
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

## Submit Example job
```sh
docker exec -it spark-master bin/spark-submit --master spark://spark-master:7077 --deploy-mode client /opt/spark/apps/example.py
```

**Please find data in your local folder**: ./data



