from airflow.sdk import dag
from datetime import datetime
from airflow.providers.common.sql.operators.sql import SQLExecuteQueryOperator

@dag(dag_id="SQL-DAG-Taskflow-api",
     start_date=datetime(2026,9,30),
     schedule="@daily",
     catchup=False)
def my_dag():

    postgresql_query_1 = """CREATE TABLE IF NOT EXISTS employee (
    id SERIAL PRIMARY KEY,
    username VARCHAR(50) UNIQUE NOT NULL,
    email VARCHAR(100) NOT NULL,
    created_at TIMESTAMPTZ DEFAULT NOW()
    );"""

    postgresql_query_2 = """INSERT INTO employee (username, email)
    VALUES 
    ('alice_green', 'alice@example.com'),
    ('bob_smith', 'bob@example.com'),
    ('charlie_brown', 'charlie@example.com'),
    ('dana_white', 'dana@example.com');"""

    mysql_query_1 = """CREATE TABLE IF NOT EXISTS employee (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
    );"""

    mysql_query_2 = """INSERT INTO employee (name, email)
    VALUES
        ('Bob Jones', 'bob@example.com'),
        ('Charlie Brown', 'charlie@example.com'),
        ('Diana Prince', 'diana@example.com');"""


    task1 = SQLExecuteQueryOperator(task_id="Create_postgresql_table",
                                    sql=postgresql_query_1,
                                    conn_id="PostgreSQL-Connection")

    task2 = SQLExecuteQueryOperator(task_id="Populate_postgresql_table",
                                    sql=postgresql_query_2,
                                    conn_id="PostgreSQL-Connection")

    task3 = SQLExecuteQueryOperator(task_id="Create_mysql_table",
                                    sql=mysql_query_1,
                                    conn_id="MySQLconnection")

    task4 = SQLExecuteQueryOperator(task_id="Populate_mysql_table",
                                    sql=mysql_query_2,
                                    conn_id="MySQLconnection")

    task1 >> task2 >> task3 >> task4

my_dag()