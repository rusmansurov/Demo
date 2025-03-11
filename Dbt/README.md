On GitHub Pages you can find dbt docs from this project:
https://rusmansurov.github.io/Demo/#!/overview


!!! In this prokect is using local Postgres instance. But you can use other local or cloud database solution.


## **Before dbt running:**
1. Install Postgres Database:

```bash
docker run --name pg -p 5432:5432 -e POSTGRES_USER=postgres -e POSTGRES_PASSWORD=password -d postgres:latest
```

2. Run scripts shared in Demo/Dbt/scripts folder in consequence: step_1_create_schemas_and_tables.sql -> step_2_insert_data.sql

3. Create new folder for project:
```bash
mkdir ~/<your>/<path>/Dbt
```

## Start project in VSCode
*Make sure you have Python at your machine.
Open Dbt project in VSCode by opening Dbt folder you made (File -> Open Folder).


## Install dbt and VENV

MacOS

```bash
python3 -m venv venv
source venv/bin/activate
```

Windows:

```bash
python3 -m venv venv
source venv/bin/Activate.ps1
```

Install dbt for Postgress

```bash
python -m pip install dbt-core dbt-postgres
```

Create `requirements.txt` file:

```bash
pip freeze -l > requirements.txt
```

Check if we have dbt

```bash
dbt --version
```

## Create new dbt project

```bash
dbt init
```
```
Enter a name for your project (letters, digits, underscore): *dbt_demo*

Which database would you like to use?
[1] postgres
Enter a number: *1*

host (hostname for the instance): *localhost*
port [5432]:
user (dev username): *postgres*
pass (dev password): *password*
dbname (default database that dbt will build objects in): *postgres*
schema (default schema that dbt will build objects in): *dev*
threads (1 or more) [1]: 1
```
After that you can find profile for dbt project using local postgres instanse /<you_wrorking_dir/.dbt>/profiles.yml

```
dbt_demo:
  outputs:
    dev:
      dbname: postgres
      host: localhost
      pass: password
      port: 5432
      schema: dev
      threads: 1
      type: postgres
      user: postgres
  target: dev
```

*We can us ENV variables to avoid putting password into profile. But in this project we skip this step.

Finally, we will move all content from `dbt_demo` into the root directory: ~/<your>/<path>/Dbt/dbt_demo -> ~/<your>/<path>/Dbt.


## Build dbt model

1. From models folder remove examle folder with all content.

2. In models folder create folder `staging` with subfolders `jaffle_shop` and `stripe`

3. Add file `models/jaffle_shop/_jaffle_shop_sources.yml`

```yaml
version: 2

sources:
  - name: jaffle_shop
    description: Jaffle Shop
    loader: Manual
    database: postgres
    schema: jaffle_shop
    tables:
      - name: customers
      - name: orders
```

3. Add staging jaffle_shop customers query using source: `models/staging/jaffle_shop/stg_jaffle_shop__customers.sql`

```sql
select
    id as customer_id,
    first_name,
    last_name

from {{ source('jaffle_shop', 'customers') }}
```

4. Add staging jaffle_shop orders query using source: `models/staging/jaffle_shop/stg_jaffle_shop__orders.sql`

```sql
select
    id as order_id,
    user_id as customer_id,
    order_date,
    status

from {{ source('jaffle_shop', 'orders') }}
```

5. Add stripe source:  `stripe/_stripe_sources.yml`

```yml
version: 2

sources:
  - name: stripe
    database: postgres
    schema: stripe
    tables:
      - name: payment
```

6. Add stripe model: `stripe/stg_stripe__payments.sql`

```sql
select
    id as payment_id,
    orderid as order_id,
    paymentmethod as payment_method,
    status,
    amount / 100 as amount,
    created as created_at
from {{ source('stripe', 'payment') }}
```


## Data docs and data tests for our models

- `models/staging/jaffle_shop/stg_jaffle_shop__customers.yml`

```yaml
version: 2

models:
  - name: stg_jaffle_shop__customers
    description: This model cleans up customer data
    columns:
      - name: customer_id
        description: Primary key
        data_tests:
          - unique
          - not_null
```

- `models/staging/jaffle_shop/stg_jaffle_shop__orders.yml`
* Check constraints, data values and freshnes 

```yml
version: 2

models:
  - name: stg_jaffle_shop__orders
    description: This model cleans up order data
    loaded_at_field: _etl_loaded_at
    freshness:
      warn_after: {count: 12, period: hour}
      error_after: {count: 24, period: hour}
    columns:
      - name: order_id
        description: Primary key
        tests:
        - unique
        - not_null
      - name: status
        tests:
          - accepted_values:
              values: ['placed', 'shipped', 'completed', 'return_pending', 'returned']
      - name: customer_id
        tests:
          - not_null
          - relationships:
              to: ref('stg_jaffle_shop__customers')
              field: customer_id
```

`models/staging/stripe/stg_stripe__payments.yml`

```yml
version: 2

models:
  - name: stg_stripe__payments
    description: Stripe payments
    columns:
      - name: payment_id
        description: Primary key
        data_tests:
          - unique
          - not_null
```

## Additional Data Quality test for our example:

`tests/assert_positive_total_for_payments.sql`

```sql
-- Refunds have a negative amount, so the total amount should always be >= 0.
-- Therefore return records where this isn't true to make the test fail.
select
    order_id,
    sum(amount) as total_amount
from {{ ref('stg_stripe__payments') }}
group by 1
having sum(amount) > 0
```


## Adding Marts

Add new files

- `models/mart/dim_customers.sql`

```sql
with
    customers as (select * from {{ ref('stg_jaffle_shop__customers') }}),

    orders as (select * from {{ ref('stg_jaffle_shop__orders') }}),

    customer_orders as (

        select
            customer_id,

            min(order_date) as first_order_date,
            max(order_date) as most_recent_order_date,
            count(order_id) as number_of_orders

        from orders

        group by 1

    ),

    final as (

        select
            customers.customer_id,
            customers.first_name,
            customers.last_name,
            customer_orders.first_order_date,
            customer_orders.most_recent_order_date,
            coalesce(customer_orders.number_of_orders, 0) as number_of_orders

        from customers

        left join customer_orders using (customer_id)

    )

select *
from final
```

- `models/mart/fct_orders.sql`

```sql
with
    orders as (select * from {{ ref ('stg_jaffle_shop__orders' ) }}),

    payments as (select * from {{ ref ('stg_stripe__payments') }}),

    order_payments as (
        select order_id, sum(case when status = 'success' then amount end) as amount

        from payments
        group by 1
    ),

    final as (

        select
            orders.order_id,
            orders.customer_id,
            orders.order_date,
            coalesce(order_payments.amount, 0) as amount

        from orders
        left join order_payments using (order_id)
    )

select *
from final
```

Documentation for Mart models

- `models/mart/dim_customers.yml`

```yml
version: 2

models:
  - name: dim_customers
    description: "Aggregates customer information with their order statistics."

    columns:
      - name: customer_id
        description: "Unique identifier for each customer."
        data_tests:
          - unique
          - not_null

      - name: first_name
        description: "Customer's first name."

      - name: last_name
        description: "Customer's last name."

      - name: first_order_date
        description: "The date of the customer's first order."

      - name: most_recent_order_date
        description: "The date of the customer's most recent order."

      - name: number_of_orders
        description: "The total number of orders placed by the customer."
```

- `models/mart/fct_orders.yml`

```yml
version: 2

models:
  - name: fct_orders
    description: "Combines order and payment information, summarizing successful payment amounts for each order."
    columns:
      - name: order_id
        description: "Unique identifier for each order."
        data_tests:
          - not_null
      - name: customer_id
        description: "Unique identifier for the customer who placed the order."
        data_tests:
          - not_null
      - name: order_date
        description: "The date when the order was placed."
        data_tests:
          - not_null
      - name: amount
        description: "The total amount of successful payments for the order. Defaults to 0 if no successful payments exist."
    data_tests:
      - dbt_utils.unique_combination_of_columns:
          combination_of_columns:
            - order_id
            - customer_id
            - order_date

```


## Final steps

Add `packages.yml` file in root path 

```yaml
packages:
  - package: dbt-labs/dbt_utils
    version: 1.3.0
  - package: calogica/dbt_expectations
    version: 0.10.4
  - package: calogica/dbt_date
    version: 0.10.1
```
And install packages

```bash
dbt deps
```

Update `dbt_project.yml` file:

```yml
models:
  dbtworkshop:
    # Config indicated by + and applies to all files under models/example/
    staging:
      +materialized: view
      +tags: staging
    mart:
      +materialized: view
      +tags: mart
```

We can run the models

```bash
dbt build --select tag:mart
```

## Addi macro with ETL timestamp

Add file with macro `macros/add_etl_timestamp.sql`

```sql
{% macro add_etl_timestamp() %}
    CURRENT_TIMESTAMP as etl_timestamp_utc
{% endmacro %}
```

Add `macros/add_etl_timestamp.YML` documentation:

```yml
version: 2

macros:
  - name: add_etl_timestamp
    description: |
      This macro generates a UTC timestamp representing the current date and time when executed.
      It is useful for tracking ETL processes by adding a standardized `etl_timestamp_utc` column
      in transformation queries.
    arguments: []
```

And we can add this marco into existing models:

```sql
select id as customer_id, first_name, last_name, {{ add_etl_timestamp() }}
from {{ source('jaffle_shop', 'customers') }}
```


## Checking the dbt docs

```bash
 dbt docs generate
 dbt docs serve --host localhost --port 8091
 ```

 Open in browser `http://localhost:8091/#!/overview`.
