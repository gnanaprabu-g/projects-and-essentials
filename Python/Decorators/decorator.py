# Syntax
def Decorator(func):
    def wrapper():
        print("Before executing the function")
        func()
        print("After executing the function")
    return wrapper

@Decorator
def greet():
    print("Hello World!")




# Output
"""
Before executing the function
Hello World!
After executing the function
"""