with open("test.txt", "r") as input_file:
    with open("test.bin", "wb") as output_file:
        for line in input_file:
            hex_number = line.strip()
            for number in hex_number:
                if number != ' ':
                    binary_number = int(number, 16)
                    output_file.write(bytes([binary_number]))