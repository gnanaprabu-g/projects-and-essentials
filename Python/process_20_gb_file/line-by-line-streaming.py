
file_path = 'D:\\Codesk\\projects-and-essentials\\process_20_gb_file\\Apache_2k.log'

with open(file_path, "r") as file:
    for line in file:
        print(line)  # Memory usage remains at a few kilobytes
    