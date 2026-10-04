from airflow import DAG
from datetime import datetime
from airflow.operators.bash import BashOperator

dag1 = DAG(dag_id="bash-dag-airflow-2.11",
           start_date=datetime(2026,9,30),
           schedule="@daily",
           catchup=False)

task1 = BashOperator(task_id="Task-1",
                     bash_command="date",
                     dag=dag1)