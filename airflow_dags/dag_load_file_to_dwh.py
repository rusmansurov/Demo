from airflow import DAG
from airflow.utils.dates import days_ago
from airflow.operators.python import PythonOperator
import requests
from airflow.providers.postgres.hooks.postgres import PostgresHook
import os


def extract_data(path, tmp_file, **kwargs):
    resp = requests.get(path)
    # save data into temp file
    with open(tmp_file, 'w') as f:
        f.write(resp.content.decode('utf-8'))

def load_data(tmp_file, schema, table_name, **kwargs):
    postgres_hook = PostgresHook(postgres_conn_id='postgres_db')
    postgres_hook.run(f"truncate {schema}.{table_name}")
    conn = postgres_hook.get_conn()
    curr = conn.cursor()
    curr.execute(f'SET search_path TO {schema}')
    # CSV loading to table.
    with open(tmp_file, 'r') as f:
        next(f)
        curr.copy_from(f, f'{table_name}', sep=',')
        conn.commit()

    # Removing temp file
    if os.path.exists(tmp_file):
        os.remove(tmp_file)

        

dag = DAG(dag_id='dag_load_file_to_dwh',
         default_args={'owner': 'airflow'},
         schedule_interval='@once',
         start_date=days_ago(1)
)

extract_op = PythonOperator(task_id='extract_data', python_callable=extract_data,
            op_kwargs={
            'path': 'https://github.com/datablist/sample-csv-files/raw/main/files/products/products-1000.csv',
            'tmp_file': '/opt/airflow/tmp/file.csv'},
            dag=dag)

load_op = PythonOperator(task_id='load_data',
                        python_callable=load_data,
                        op_kwargs={'tmp_file': '/opt/airflow/tmp/file.csv',
                                    'database': 'my_db',
                                    'schema': 'my_schema',
                                    'table_name': 'my_table'},
                        dag=dag
                        )


extract_op >> load_op
