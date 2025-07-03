# Apache Iceberg Lakehouse with Spark, MinIO, and PostgreSQL (JDBC Catalog)

This project sets up a full-featured Lakehouse environment based on Apache Spark and Apache Iceberg using:

- **PostgreSQL** as the JDBC catalog for Iceberg
- **MinIO** as the S3-compatible object storage
- **Spark 3.5.6** (with a custom `my-spark` image) for running data processing jobs
- A demo script `advanced_iceberg_demo.py` to showcase Iceberg table operations

---

## Quick Start

### 1. Build the Spark image

```bash
docker build -t my-spark:3.5.6 .
```

### 2. Launch the environment

```bash
docker compose up -d
```

This will start:

* PostgreSQL (metadata catalog)
* Spark Master, 2 Workers, Spark History Server, Spark Submit client
* MinIO with preconfigured users and policies

### 3. Access the UIs

* Spark UI: [http://localhost:8080](http://localhost:8080)
* Spark History Server: [http://localhost:18080](http://localhost:18080)
* MinIO UI: [http://localhost:9001](http://localhost:9001)
  Username/password: `minioadmin` / `minioadmin`

---

## Project Structure

```
.
├── docker-compose.yaml
├── Dockerfile
├── entrypoint.sh
├── log4j.properties
├── lspark-defaults.conf
├── spark-app/
│   └── advanced_iceberg_demo.py
└── minio/
    └── dlh-policy.json
```

---

## Manual Test Case for `spark-submit`

You can manually test the cluster by running the demo script `advanced_iceberg_demo.py` using the `spark-submit` container.

### Steps to run the test

1. Ensure the cluster is up:

```bash
docker compose up -d
```

2. Run the demo script:

```bash
docker exec -it spark-submit spark-submit /opt/spark/app/advanced_iceberg_demo.py
```

### Expected output

In the console you should see messages indicating:

* Successful creation of the `demo` database
* Creation of the `demo.test_advanced_write` table partitioned by `event_date`
* Initial data insert
* Overwrite of the June 1 partition
* Insert of the June 2 partition
* `MERGE INTO` with new and updated rows
* Viewing table snapshots
* Rollback to a previous snapshot
* Final table contents

### Sample output snippet

```text
Final table contents:

+---+---------------+----------+
|id |name           |event_date|
+---+---------------+----------+
|1  |Alice_Updated  |2025-06-01|
|3  |Charlie_Updated|2025-06-01|
|4  |Diana          |2025-06-02|
|5  |Eve            |2025-06-03|
+---+---------------+----------+

Rolling back to snapshot ID: 241992009447305872

Table after rollback:

+---+-------------+-----------+
|id |name         |event_date|
+---+-------------+-----------+
|1  |Alice_Updated|2025-06-01|
|3  |Charlie      |2025-06-01|
|4  |Diana        |2025-06-02|
+---+-------------+-----------+
```

---

## 🔍 What `advanced_iceberg_demo.py` Does

This script demonstrates key Iceberg features:

* Creating a database and a partitioned Iceberg table
* Writing and overwriting partitioned data
* `MERGE INTO` for upserts
* Retrieving the table’s history (`snapshots`)
* Rolling back to a previous snapshot via `CALL rollback_to_snapshot(...)`

---

## 📦 Configuration Overview

| Component  | Configuration                                                |
| ---------- | ------------------------------------------------------------ |
| PostgreSQL | `iceberg:iceberg` in `metastore_db`                          |
| MinIO      | User `lakehouseuser`, password `lakehousepass`, bucket `dlh` |
| Spark      | Custom image `my-spark:3.5.6` with Iceberg and S3 support    |

---

## Stop and Clean Up

```bash
docker compose down -v
```

This will remove all volumes, including PostgreSQL and MinIO data.