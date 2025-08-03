**Iceberg Lakehouse on Docker**

This repository contains a Docker-based setup for deploying an Iceberg Lakehouse using Trino, MinIO, Hive Metastore, and PostgreSQL. It serves as a demonstration environment for working with Apache Iceberg, allowing you to experiment with modern data management approaches.

**Project Components**

| Component          | Purpose                                        |
| ------------------ | ---------------------------------------------- |
| **Trino**          | SQL engine for distributed analytics           |
| **MinIO**          | S3-compatible object storage for Parquet files |
| **Hive Metastore** | Catalog for managing Iceberg table metadata    |
| **PostgreSQL**     | Stores Hive Metastore metadata                 |

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

**Quick start**

Once the setup is running, you can connect to Trino and run SQL queries against Iceberg tables by running trino CLI:

```sh
docker exec -it trino trino
```

```sql
SHOW SCHEMAS FROM iceberg;

CREATE TABLE iceberg.default.customers (
    id integer,
    customer_name varchar
    )
 WITH (
    format = 'PARQUET',
    location='s3a://dlh/customers')
 ;

 INSERT INTO iceberg.default.customers (id, customer_name) VALUES
      (1, 'John'), 
      (2, 'Rachel')
 ;
 
SELECT * FROM iceberg.default.customers;
```

## Demo Queries

Explore the `demo/` folder — it contains 7 well-documented SQL files demonstrating:

1. **Table creation and querying**
2. **Snapshot isolation**
3. **Schema evolution**
4. **Positional deletes**
5. **Partitioned tables and partition pruning**
6. **Metadata inspection**
7. **Rollback to snapshot**

Run these queries via Trino and psql CLI or your favorite SQL editor (e.g., DBeaver).