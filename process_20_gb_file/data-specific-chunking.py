import pandas as pd

file_path = 'D:\\Codesk\\projects-and-essentials\\process_20_gb_file\\Apache_2k.log'

for chunk in pd.read_csv(file_path, chunksize=100000):
    print(type(chunk))  
    print(chunk)  # Each chunk is a standard Pandas DataFrame