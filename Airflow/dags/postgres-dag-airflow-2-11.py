from airflow import DAG
from datetime import datetime
from airflow.providers.common.sql.operators.sql import SQLExecuteQueryOperator

dag1 = DAG(dag_id="postgres-dag-airflow-2.11",
           start_date=datetime(2026,9,30),
           schedule="@daily",
           catchup=False)

query1 = """CREATE TABLE IF NOT EXISTS employee (
    id SERIAL PRIMARY KEY,
    username VARCHAR(50) UNIQUE NOT NULL,
    email VARCHAR(100) NOT NULL,
    created_at TIMESTAMPTZ DEFAULT NOW()
);"""

query2 = """INSERT INTO employee (username, email)
VALUES 
    ('alice_green', 'alice@example.com'),
    ('bob_smith', 'bob@example.com'),
    ('charlie_brown', 'charlie@example.com'),
    ('dana_white', 'dana@example.com');"""

task1 = SQLExecuteQueryOperator(task_id="Create_Table", 
                         sql=query1,
                         conn_id="PostgreSQL-Connection",
                         dag=dag1)

task2 = SQLExecuteQueryOperator(task_id="Insert_Records",
                         sql=query2,
                         conn_id="PostgreSQL-Connection",
                         dag=dag1)

task1 >> task2