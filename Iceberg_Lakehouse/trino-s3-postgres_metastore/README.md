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