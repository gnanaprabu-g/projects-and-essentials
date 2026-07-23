
def find_factorial():
    """
    This function calculates the factorial of a given non-negative integer.
    
    Returns:
        int: The factorial of the input number.
    """
    num = int(input("Enter a non-negative integer: "))
    
    if num < 0:
        return "Factorial is not defined for negative numbers."
    
    factorial = 1
    for i in range(1, num + 1):
        factorial *= i
        
    return factorial

print("Factorial: " + str(find_factorial()))