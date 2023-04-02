import pandas as pd
from airflow import DAG
from airflow.utils.dates import days_ago
from airflow.operators.python_operator import PythonOperator
from airflow.providers.postgres.operators.postgres import PostgresOperator
from airflow.providers.postgres.hooks.postgres import PostgresHook
from airflow.providers.amazon.aws.sensors.s3 import S3KeySensor
import requests
import os
import logging


def load_sales_file(url, tmp_file, **context):
    req = requests.get(url)
    url_content = req.content
    with open(tmp_file, 'wb') as f:
        f.write(url_content)
        context['ti'].xcom_push(key='sales_file', value='{}'.format(tmp_file))


def db_load_data(schema, table_name, **context):
    pg_hook = PostgresHook(postgres_conn_id='postgres_db', supports_autocommit=True)
    logging.info(f"Clearing Postgres table {schema}.{table_name}")
    pg_hook.run(f"truncate {schema}.{table_name}")
    tmp_file = context['ti'].xcom_pull(task_ids='extract_data', key='sales_file')

    logging.info(f"Loading CSV {tmp_file} into Postgres table {schema}.{table_name}")

    query = "COPY {}.{} FROM STDIN WITH CSV HEADER DELIMITER ',' ".format(schema, table_name)

    conn = pg_hook.get_conn()
    pg_cursor = conn.cursor()
    pg_cursor.copy_expert(sql=query, file=open(tmp_file, 'r'))
    conn.commit()


def sales_data_analisys_to_csv(**context):
    sales_file = context['ti'].xcom_pull(task_ids='extract_data', key='sales_file')
    pg_hook = PostgresHook(postgres_conn_id='postgres_db')
    query = """
                COPY (
                    select payment, date_trunc('month', date)::date "month", round(sum(total), 2) revenue
                    from my_schema.sales
                    group by 1,2
                    order by 1,2
                    )
                TO STDOUT WITH CSV HEADER
                """
    
    pg_hook.copy_expert(query, sales_file)


def remove_temp_file(**context):
    tmp_file = context['ti'].xcom_pull(task_ids='extract_data', key='sales_file')
    if os.path.exists(tmp_file):
        os.remove(tmp_file)
        logging.info(f"The following was removed: {tmp_file}")
    else:
        logging.info("The file does not exist")


with DAG(dag_id='dag_sales',
         default_args={'owner': 'airflow'},
         schedule_interval='@daily',
         start_date=days_ago(1)
    ) as dag:

    extract_data_op = PythonOperator(
        task_id='extract_data',
        python_callable=load_sales_file,
        op_kwargs={
            'url': 'https://github.com/plotly/datasets/raw/master/supermarket_Sales.csv',
            'tmp_file': '/opt/airflow/tmp/Sales.csv'}
    )

    load_sales_data_to_dwh_op = PythonOperator(
        task_id='file_to_db',
        # provide_context=True,
        python_callable=db_load_data,
        op_kwargs={'database': 'my_db',
                   'schema': 'my_schema',
                   'table_name': 'sales'},
                   )
    
    remove_temp_file_op = PythonOperator(
        task_id='removing_temp_file',
        python_callable=remove_temp_file,
    )

    prepare_csv_sales_data_op = PythonOperator(
        task_id='sales_data_analisys_to_csv',
        python_callable=sales_data_analisys_to_csv
    )


    extract_data_op >> load_sales_data_to_dwh_op >> remove_temp_file_op >> prepare_csv_sales_data_op