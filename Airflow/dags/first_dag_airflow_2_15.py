from airflow import DAG
from datetime import datetime
from airflow.operators.python import PythonOperator

dag1 = DAG(dag_id="First_DAG_airflow-2.15", 
           start_date=datetime(2016,9,30), 
           schedule="@daily", 
           catchup=False)

def hello():
    print("Hello from Task-1")

def hello2():
    print("Hello from Task-2")

task1 = PythonOperator(task_id="Task-1", 
                       python_callable=hello, 
                       dag=dag1)

task2 = PythonOperator(task_id="Task-2", 
                       python_callable=hello2, 
                       dag=dag1)

task1 >> task2
