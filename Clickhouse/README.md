# ClickHouse Docker Setup with Persistent Volume and DBeaver Access

This repository contains a minimal ClickHouse Docker Compose setup with:

- Persistent volume for storing data
- Custom user creation for external tools (e.g., DBeaver)
- Simple role-based access control

## How to Run

Clone the repository and start ClickHouse:

```bash
docker-compose up -d
````

## User & Role Setup

After starting the container, run the following commands to create a user and assign permissions:

```bash
docker exec -it clickhouse bash
/etc/clickhouse-client
```

When prompted, use:

```
Login: default
Password: password
```

Inside the ClickHouse client:

```sql
CREATE ROLE 'admin';
GRANT ALL ON *.* TO admin WITH GRANT OPTION;

CREATE USER my_user IDENTIFIED WITH plaintext_password BY 'password';
GRANT admin TO my_user;
```

You now have a user `my_user` with full access rights.

## Connect with DBeaver

To connect using [DBeaver](https://dbeaver.io/):

* **Driver**: ClickHouse
* **Host**: `localhost`
* **Port**: `8123`
* **User**: `my_user`
* **Password**: `password`
* **Database**: `default` (or any you create)

## Data Persistence

ClickHouse stores data in a Docker volume named `clickhouse_data_volume`. This ensures your data is preserved across container restarts and can be reused or backed up.

## Contents

* `docker-compose.yml` — Defines the ClickHouse container and mounts volumes
* `config/users.xml` — Configures default and custom users