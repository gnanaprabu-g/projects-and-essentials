from datetime import datetime
from airflow.sdk import dag, task

@dag(dag_id="my_first_pipeline",
     schedule="@daily",
     start_date=datetime(2026, 8, 1))

def first_pipeline():

    @task
    def training_model_a():
        return 1

    @task 
    def training_model_b():
        return 2

    @task 
    def training_model_c():
        return 3

    @task.branch
    def choose_best_model(accuracy):
        if max(accuracy) > 2:
            return "accurate"
        return "inaccurate"

    @task.bash
    def accurate():
        return "echo 'accurate'"

    @task.bash
    def inaccurate():
        return "echo 'inaccurate'"

    accuracy = [training_model_a(),training_model_b(), training_model_c()]
    choose_best_model(accuracy) >> [accurate(), inaccurate()]


first_pipeline()