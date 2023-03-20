import random

n = 307200  # change this to the number of 3-digit numbers you want
filename = "numbers.txt"

with open(filename, "w") as file:
    for i in range(n):
        number = str(random.randint(1, 255))  # generate a random 3-digit number
        file.write(number + " ")  # write the number to the file, followed by a space
