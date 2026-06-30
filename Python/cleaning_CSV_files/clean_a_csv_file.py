import csv


def clean_csv_file(file_path):
    """
    Cleans a CSV file by removing bad records.

    Args:
        file_path (str): The path to the CSV file to be cleaned.
    """
    cleaned_rows = []

    with open(file_path, mode='r', encoding='utf-8') as f:
        reader_l = csv.reader(f)
        header = next(reader_l)  # Read the header row
        cleaned_rows.append(header)  # Add the header row to the cleaned data

        for line_num, row in enumerate(reader_l, start=2):
            # Check if the row has the same number of columns as the header
            if len(row) != len(header):
                print("Skipping line ",line_num, ": Expected ",len(header), "columns but found ",len(row))
                continue

            # If the row is valid, add it to the cleaned data
            cleaned_rows.append(row)

        print(cleaned_rows)
        return 0
    
path_to_file = 'D:\\Codesk\\projects-and-essentials\\Cleaning_CSV_files\\currency-test-incorrect.csv'

clean_csv_file(path_to_file)  # Replace with the actual path to your CSV file