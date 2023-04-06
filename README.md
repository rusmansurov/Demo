***Folders***:
1) airflow_dags. Folder contains DAG demo scripts.
2) docker. Folder contains Airflow, PostgreSQL and DBeaver instances used in current Demo porject.

---
***Main goals:***
1. Demonstrate different Airflow technics and solutions.
2. Show some interesting momemns.
---

***Used services, solutions and languages:***
1) Airflow
2) Docker
3) PostgreSQL
4) Bash
5) Python
6) SQL
___

## Results for DAGs presented in "airflow_dags" folder:
***1. dag_load_file_to_dwh.py:***<br />
This example show how to get file with data from the web and load into specified DWH.
In below screenshot you may find successfully loaded data into Postgres DWH.
![alt text](https://github.com/rusmansurov/Demo/blob/main/airflow_dags/Results/dag_load_file_to_dwh.png)

***2. dag_fail_telegram_message.py:***<br />
Airflow supports different notifications including messangers.
In this case we had generated fail in ETL processe on purpose. This fail called Telegram message with fail notification for specified Telegarm channel.
It might be usefull for any business and IT departments.
![alt text](https://github.com/rusmansurov/Demo/blob/main/airflow_dags/Results/dag_fail_telegram_message.jpg)

***3. dag_sales.py:***<br />
In this case we have sales data downloaded into DWH, aggregated there and uploaded to the external folder. Airflow supports generation files aggregated in DWH data and uploading them into different external sources (Cloud, S3, ftp)
![alt text](https://github.com/rusmansurov/Demo/blob/main/airflow_dags/Results/dag_sales.png)


***4. dag_branches.py:***<br />
Airflow supports branches. It brings to ETL proccesses to be flexiblity. We can build 1 proccess with different ETL ways depends on conditions.<br />
In below attached part of script you may find that ETL proccess are oriented on external variable brought by using xcom instrument (one of internal and useful Airflow opportunity). As total our ETL proccess have to choose what branch will be done: ___higher___ or ___lower___.<br />
In attached below screenshot you can see my result.
```python
def branch(**kwargs):
    rand_value = kwargs['ti'].xcom_pull(key='rand', task_ids='random_number')
    if rand_value > 5:
        return 'higher' 
    else:
        return 'lower'
```
![alt text](https://github.com/rusmansurov/Demo/blob/main/airflow_dags/Results/dag_branches.png)

___
<br />
***In each folder you may find demo with description in "README.md" file***<br /><br />

Enjoy<br />
***Rustam***
