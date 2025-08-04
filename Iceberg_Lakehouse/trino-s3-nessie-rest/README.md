### **Iceberg Lakehouse Deployment with Trino, MinIO, and Nessie as Metastore**  

This deployment provides a containerized environment for working with **Apache Iceberg**, using **Trino** as the SQL query engine, **MinIO** as an S3-compatible storage, and **Project Nessie** as the metastore via REST.  

---

### **1. Iceberg REST (Modern Approach)**  
#### **How It Works?**  
- **Iceberg provides a REST API** for managing metadata.  
- **Metadata is stored in S3 (or MinIO),** while the REST service handles access.  
- **Trino, Spark, and other systems** can connect to the REST service without the complexity of setting up a database.  

---

#### **Components of the Deployment:**  
1. **Trino** – A distributed SQL engine for analytical queries.  
2. **MinIO** – An object storage solution that emulates Amazon S3.  
3. **Project Nessie** – Serves as the metastore for Iceberg, enabling version control for table metadata.  
4. **Iceberg** – Stores data files (Parquet) in MinIO and metadata in Nessie.  


---

#### **How It Works:**  
- **Nessie** acts as a versioned metastore, storing Iceberg metadata.  
- **MinIO** is used for storing Iceberg data files and metadata files.  
- **Trino** interacts with Iceberg via `dlh.properties`, using Nessie as the catalog.  


---

#### **Key Configuration Files:**  
1. **Trino (`dlh.properties`)**  
2. **Docker Compose (`docker-compose.yml`)**


---

#### **How to Start:**  
```sh
docker-compose up -d
```
Once started, you can connect to Trino CLI and create Iceberg tables. Nessie allows managing metadata versions, enabling features like time-travel queries and branching.

```sql
CREATE SCHEMA dlh.my_schema
WITH (location = 's3://dlh/my_schema/');

CREATE TABLE dlh.my_schema.customers (
    id integer,
    customer_name varchar
    );

SELECT * FROM dlh.my_schema.customers;
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