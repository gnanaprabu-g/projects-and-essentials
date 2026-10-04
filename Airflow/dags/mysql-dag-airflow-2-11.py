from airflow import DAG
from datetime import datetime
from airflow.providers.common.sql.operators.sql import SQLExecuteQueryOperator

dag1 = DAG(dag_id="mysql-dag-airflow-2.11",
           start_date=datetime(2026,9,30),
           schedule="@daily",
           catchup=False) 

query1 = """CREATE TABLE IF NOT EXISTS employee (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);"""

query2 = """INSERT INTO employee (name, email)
    VALUES
        ('Bob Jones', 'bob@example.com'),
        ('Charlie Brown', 'charlie@example.com'),
        ('Diana Prince', 'diana@example.com');"""

task1 = SQLExecuteQueryOperator(task_id="Task-1",
                                sql=query1,
                                conn_id="MySQLconnection",
                                dag=dag1)

task2 = SQLExecuteQueryOperator(task_id="Task-2",
                                sql=query2,
                                conn_id="MySQLconnection",
                                dag=dag1)

task1 >> task2