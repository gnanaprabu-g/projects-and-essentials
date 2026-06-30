

file_path = 'D:\\Codesk\\projects-and-essentials\\process_20_gb_file\\Apache_2k.log'


def read_large_file(file_path):
    """Generator to lazily read a file line by line."""
    with open(file_path, "r", encoding="utf-8") as file:
        for line in file:
            yield line  # Suspends execution and returns the line


# --- How to consume the generator ---
log_stream = read_large_file(file_path)

for line in log_stream:
    if "error" in line:
        print(line.strip())  # Process the data immediately