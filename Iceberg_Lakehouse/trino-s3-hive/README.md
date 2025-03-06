**Iceberg Lakehouse on Docker**

This repository contains a Docker-based setup for deploying an Iceberg Lakehouse using Trino, MinIO, Hive Metastore, and PostgreSQL. It serves as a demonstration environment for working with Apache Iceberg, allowing you to experiment with modern data management approaches.

**Project Components**

1. Trino – a SQL query engine for data analytics.
2. MinIO – an S3-compatible object storage for storing files.
3. Hive Metastore – a metadata catalog for managing Iceberg table metadata.
4. PostgreSQL – a database for storing Hive Metastore metadata.

**Features**

Deploy a local Iceberg Lakehouse using docker-compose.
Store and process data in Parquet format.
Query data using Trino.
Connect to MinIO via the S3 API.
Support for positional deletes and snapshot management in Iceberg.

**Installation & Setup**
1. Clone the repository.
2. Start the containers:
   ```sh
   docker-compose up -d
   ```
4. Verify that all services are running:
 - Trino is available at http://localhost:8080
 - MinIO is available at http://localhost:9000
 - Hive Metastore uses PostgreSQL for metadata storage.

**Usage**

Once the setup is running, you can connect to Trino and run SQL queries against Iceberg tables by running trino CLI:

```sh
docker exec -it trino trino
```

```sql
SHOW SCHEMAS FROM datalake;

CREATE TABLE datalake.default.customers (
    id integer,
    customer_name varchar
    )
 WITH (
    format = 'PARQUET',
    location='s3a://datalake/trino/hive_catalog/customers')
 ;
 
SELECT * FROM datalake.default.customers;
```
