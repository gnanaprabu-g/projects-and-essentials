from airflow.sdk import dag, task
from datetime import datetime

@dag(dag_id="First_DAG_Taskflow-API",
     start_date=datetime(2026,9,30),
     schedule="@daily",
     catchup=False)
def first_dag():

    @task
    def Task1():
        print("Hello from Task-1")

    @task
    def Task2():
        print("Hello from Task2")

    Task1() >> Task2()

first_dag()