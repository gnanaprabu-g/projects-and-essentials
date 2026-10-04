Put the above dag files in "airflow/dags/" folder to create a DAG in Airflow UI.  

# Apache Airflow Setup  

1. Setup virtual environment using python3  
```bash
sudo apt install python3-venv
mkdir workspace_folder
cd workspace_folder
python3 -m venv airflow-venv
ls -lart
source airflow-venv/bin/activate
```
2. `pip install "apache-airflow"`  
3. Start all components in a single lightweight process.  
4. `airflow standalone`  
        (or)  
5. `nohup airflow standalone > airflow.log 2>&1 &`  
6.  Hit `http://localhost:8080` and then login credentials will be generated in below file,  
7. `cat ~/airflow/simple_auth_manager_passwords.json.generated`  
8. Stop the airflow standalone running in the background,  
9. `pkill --signal 9 -u root airflow`  
10. Check if all the process stopped,  
11. `ps -ef | grep airflow`  
12. Add below line to `/etc/fstab` file. This will bind mount the custom os directory to airflow/dags directory
13. `/mnt/d/Documents/Learning/projects-and-essentials/Airflow/dags  /root/airflow/dags  none  defaults,bind,nofail  0  0`


# PostgreSQL container Setup  
```bash  
# Navigate to below directory, if not present then create it.  
cd ~/Docker/PostgreSQL/  

# Create a folder to store postgresql data
mkdir postgresql_data  

# Change user:group ownership to UUID 999 for above folder
chown -R 999:999 ./postgresql_data  

# Spin up a container with image postgres
docker run -itd --name local-postgresql -e POSTGRES_USER=admin -e POSTGRES_PASSWORD=Admin@123 -e POSTGRES_DB=demo_pg_db -p 5432:5432 -v ./postgresql_data:/var/lib/postgresql postgres  

# List all containers
docker ps -a  

# Tunnel into container "local-postgresql"
docker exec -it local-postgresql /bin/bash  

# Change directory
cd /var/lib/postgresql  

# login to postgresql with port, user and db name
psql -h localhost -p 5432 -U admin -d demo_pg_db  

# list the postgresql DBs
\l  

# create employee table
CREATE TABLE employees (  
    id serial PRIMARY KEY,  
    name VARCHAR(100),  
    joined_date DATE  
);  

# list the postgresql tables
\dt  

# insert records into employee table
INSERT INTO employees (name, joined_date)  
VALUES  
    ('Bob Jones', '2026-08-15'),  
    ('Charlie Brown', '2026-09-01'),  
    ('Diana Prince', '2026-10-01');  

# view records
select * from employees;  

# delte employee table
drop table employees;  

exit;  
```

# MySQL container Setup  
```bash  
# Navigate to below directory, if not present then create it.
cd ~/Docker/MySQL  

# Create a folder to store mysql data
mkdir mysql_data  

# Change user:group ownership to UUID 999 for above folder
chown -R 999:999 ./mysql_data/  

# Spin up a container with image mysql
docker run -itd --name local-mysql -e MYSQL_ROOT_PASSWORD=Admin@root -e MYSQL_USER=admin -e MYSQL_PASSWORD=Admin@123 -e MYSQL_DATABASE=demo_ms_db -p 3306:3306 -v ./mysql_data:/var/lib/mysql mysql  

# List all containers
docker ps -a  

# Tunnel into container "local-mysql"
docker exec -it local-mysql /bin/bash  

# login to mysql with user and password prompt
mysql -u admin -p  

# list mysql DBs
SHOW DATABASES;  

# select mysql DB
USE database_name;  

# Create table in mysql DB
CREATE TABLE users (  
    id INT AUTO_INCREMENT PRIMARY KEY,  
    name VARCHAR(100) NOT NULL,  
    email VARCHAR(100) UNIQUE NOT NULL,  
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP  
);  

# List tables in mysql DB
SHOW TABLES;  

# Insert records into users table
INSERT INTO users (name, email)  
VALUES  
    ('Bob Jones', 'bob@example.com'),  
    ('Charlie Brown', 'charlie@example.com'),  
    ('Diana Prince', 'diana@example.com');  

# View records
SELECT * FROM users;  

# delete user table in mysql DB
DROP TABLE users;  

EXIT;  
```