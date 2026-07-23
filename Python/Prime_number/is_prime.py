
def is_prime(n):
    """Check if a number is prime.

    Args:
        n (int): The number to check.

    Returns:
        bool: True if the number is prime, False otherwise.
    """
    if n < 2:
        return False
    for i in range(2, int(n**0.5) + 1):
        if n % i == 0:
            return False
    return True

# Test the function
test_numbers = [1, 2, 3, 4, 5, 16, 17, 18, 19, 20]
for number in test_numbers:
    result = is_prime(number)
    print(f"{number} is prime: {result}")