## Iceberg Lakehouse on Docker**

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

## Quick start

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

The `demo/` folder contains practical SQL scripts that demonstrate key Iceberg features in Trino. Each script focuses on a specific capability:

| File                           | Description                                                                                             |
| ------------------------------ | ------------------------------------------------------------------------------------------------------- |
| `1_getting_started.sql`        | Create your first Iceberg table and insert initial data. Great starting point for newcomers.            |
| `2_schema_evolution.sql`       | Show how Iceberg handles **schema changes** (add, update, delete columns and rows).                     |
| `3_time_travel.sql`            | Explore **time travel** with snapshots: query old data and roll back to previous states.                |
| `4_table_maintenance.sql`      | Perform **table maintenance**: compaction, snapshot cleanup, and orphan file removal.                   |
| `5_partition_pruning.sql`     | Demonstrate **partitioning** and how Iceberg supports **partition pruning** for fast scans.             |
| `6_query_plans_and_joins.sql`  | Compare **join strategies** (broadcast vs. partitioned) and analyze Trino query plans.                  |
| `7_catalog_under_the_hood.sql` | Peek under the hood: see how Iceberg integrates with **Hive Metastore**, **PostgreSQL**, and **MinIO**. |

Run these queries via Trino and psql CLI or your favorite SQL editor (e.g., DBeaver).