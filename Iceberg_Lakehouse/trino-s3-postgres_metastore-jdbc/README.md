### **Iceberg Lakehouse Deployment with Trino, MinIO, and PostgreSQL as Metastore**  

This deployment provides a containerized environment for working with **Apache Iceberg**, using **Trino** as the SQL query engine, **MinIO** as an S3-compatible storage, and **PostgreSQL** as the metastore via JDBC.  

#### **Components of the Deployment:**  
1. **Trino** – A distributed SQL engine for analytical queries.  
2. **MinIO** – An object storage solution that emulates Amazon S3.  
3. **PostgreSQL** – Serves as the metastore for Iceberg.  
4. **Iceberg** – Stores data files in MinIO and metadata in PostgreSQL.  

#### **How It Works:**  
- PostgreSQL stores metadata about Iceberg tables (schemas, snapshots, and metadata).  
- MinIO is used for storing data files and metadata files.  
- Trino interacts with Iceberg via `pg_catalog.properties`, using PostgreSQL as the metastore.  


#### **How to Start:**  
```sh
docker-compose up -d
```

```sh
docker exec -it trino trino
```

```sql
create schema pg_catalog.datalake;

create table pg_catalog.datalake.customers (
    id integer,
    customer_name varchar
    );

select * from pg_catalog.datalake.customers;
```

#### **Demo Queries** 

The `demo/` folder contains practical SQL scripts that demonstrate key Iceberg features in Trino. Each script focuses on a specific capability:

| File                           | Description                                                                                             |
| ------------------------------ | ------------------------------------------------------------------------------------------------------- |
| `1_getting_started.sql`        | Create your first Iceberg table and insert initial data. Great starting point for newcomers.            |
| `2_schema_evolution.sql`       | Show how Iceberg handles **schema changes** (add, update, delete columns and rows).                     |
| `3_time_travel.sql`            | Explore **time travel** with snapshots: query old data and roll back to previous states.                |
| `4_table_maintenance.sql`      | Perform **table maintenance**: compaction, snapshot cleanup, and orphan file removal.                   |
| `5_partition_pruning.sql`     | Demonstrate **partitioning** and how Iceberg supports **partition pruning** for fast scans.             |
| `6_query_plans_and_joins.sql`  | Compare **join strategies** (broadcast vs. partitioned) and analyze Trino query plans.                  |

Run these queries via Trino and psql CLI or your favorite SQL editor (e.g., DBeaver).