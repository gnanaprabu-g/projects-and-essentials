import os
 
app_name = os.getenv("APP_NAME")
app_env = os.getenv("APP_ENV")
app_port = os.getenv("APP_PORT")
db_host = os.getenv("DB_HOST")
 
print("Application:", app_name)
print("Environment:", app_env)
print("Port:", app_port)
print("Database Host:", db_host)