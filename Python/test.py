# word frequency
"""
words = ["apple","banana","apple","orange","banana","apple","grape","banana","banana","orange"]

def remove_duplicates(w):
    uniq_l = []
    for i in w:
        if i not in uniq_l:
            uniq_l.append(i)
    return uniq_l

print(words)

print(remove_duplicates(words))

def word_freq(w):
    uniq_l = remove_duplicates(w)
    for i in uniq_l:
        count = 0
        for j in w:
            if i == j:
                count = count + 1
        print(i, count)

word_freq(words)
"""

# reverse a string
"""
word = "mountain"

def str_reverse(w):
    return w[::-1]

print(word, str_reverse(word))
"""

# process 20 gb file using generator func
"""
file_path = "D:\\Documents\\Learning\\projects-and-essentials\\Python\\process_20_gb_file\\Apache_2k.log"

def read_logs(fp):
    with open(fp, "r") as f:
        for line in f:
            yield line

log_line = read_logs(file_path)

count = 0
for line in log_line:
    if "218.207.61.7" in line:
        print(count, line)
    count += 1

"""

# Detect Prime numbers in a given list
"""
numbers = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20]

def is_prime(n):

    if n < 2:
        return False

    for i in range(2, int(n**0.5) + 1):
        if n % i == 0:
            return False
    return True

print(numbers)

for n in numbers:
    if is_prime(n):
        print(n, "is prime")
    else:
        print(n, "is not prime")

"""

# Check given string is palindrome
"""
word = "Racecar"

def is_palindrome(w):
    w = w.replace(" ", "").lower()

    return w == w[::-1]

if is_palindrome(word):
    print(word, "is palindrome")
else:
    print(word, "is not palindrome")

"""

# Find the largest element in a list
"""
sample_l = [10, 9, 12, 11, 22, 77, 43, 76]

def find_largest_num(l):
    largest_num = l[0]

    for num in l:
        if num > largest_num:
            largest_num = num
    return largest_num

largest_n = find_largest_num(sample_l)

print(sample_l)
print(largest_n)

"""

# Find factorial of given number
"""
number = 32

def find_factorial(n):

    if n==0:
        return 1

    factorial = 1
    for i in range(1, n+1):
        factorial = factorial * i

    return factorial

def find_factorial_using_recursion(n):

    if n==0:
        return 1

    return n * find_factorial_using_recursion(n-1)

print("Factorial of", number, "is", find_factorial(number))

print("Factorial of", number, "is", find_factorial_using_recursion(number))

"""

# Find common elements among two lists
"""
list_a = [1, 2, 3, 4, 5, 6]
list_b = [4, 5, 6, 7, 8, 9]

def common_elements(l1, l2):
    common = []
    for i in l1:
        if i in l2:
            common.append(i)
    
    return common

print(list_a,"\n",list_b)

c = common_elements(list_a, list_b)

print("Common elements: ",c)

"""