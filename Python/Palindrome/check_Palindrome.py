
def check_palindrome(str):
    # Remove spaces and convert to lowercase
    str = str.replace(" ", "").lower()
    
    # Check if the string is equal to its reverse
    return str == str[::-1]

# Example usage
input_str = input("Enter any word: ")
if check_palindrome(input_str):
    print(input_str + " is a palindrome.")
else:
    print(input_str + " is not a palindrome.")


