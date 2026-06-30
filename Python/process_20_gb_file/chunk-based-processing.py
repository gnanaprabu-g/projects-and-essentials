
file_path = 'D:\\Codesk\\projects-and-essentials\\process_20_gb_file\\Apache_2k.log'

chunk_size = 64 * 1024  # 64 KB
n = 1
with open(file_path, "rb") as file:
    while True:
        chunk = file.read(chunk_size)
        if not chunk:
            break
        print("Chunk ", n, ": ", chunk, "\n")
        n += 1