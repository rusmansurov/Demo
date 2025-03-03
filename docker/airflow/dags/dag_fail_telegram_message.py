from airflow import DAG
from airflow.operators.python_operator import PythonOperator
from datetime import datetime
from airflow.exceptions import AirflowException
from airflow.providers.telegram.operators.telegram import TelegramOperator


def fail_message(**context):
    send_message = TelegramOperator(
        task_id='fail_msg',
        telegram_conn_id='<Enter your connection id>',
        chat_id='<Enter your chat_id>}',
        text='Congratulation - FAIL message is here!',
        dag=dag)
    send_message.execute(context)


def raiese_exception(**context):
    raise AirflowException


dag = DAG(
    'dag_fail_telegram_message',
    start_date=datetime(2015, 12, 1),
    schedule_interval='@daily',
    max_active_runs=1)

fail_task = PythonOperator(
    task_id='raise_fail',
    python_callable=raiese_exception,
    dag=dag
)

fail_message = PythonOperator(
    task_id='fail_message',
    python_callable=fail_message,
    trigger_rule='one_failed'
)

fail_task >> fail_message