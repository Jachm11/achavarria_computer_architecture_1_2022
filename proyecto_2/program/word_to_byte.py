def separate_lines(input_file, output_file_even, output_file_odd):
    with open(input_file, 'r') as file:
        lines = file.readlines()

    even_lines = lines[::2]  # Select every second line (starting from index 0)
    odd_lines = lines[1::2]  # Select every second line (starting from index 1)

    with open(output_file_even, 'w') as file_even:
        file_even.writelines(even_lines)

    with open(output_file_odd, 'w') as file_odd:
        file_odd.writelines(odd_lines)

def words_to_bytes(input_file,output_file):
    with open(input_file, 'r') as file:
        content = file.read()

    # Remove newlines
    content = content.replace('\n', '')

    output = [content[i:i+2] for i in range(0, len(content), 2)]
    formatted_output = '\n'.join(output)

    with open(output_file, 'w') as file:
        file.write(formatted_output)

def convert_endianness(value):
    # Split the input value into groups of two characters
    groups = [value[i:i+2] for i in range(0, len(value), 2)]
    
    # Reverse the order of the groups and join them
    reversed_value = ''.join(reversed(groups))
    
    return reversed_value

def convert_file_endianness(input_file, output_file):
    with open(input_file, 'r') as file:
        lines = file.readlines()
        
    converted_lines = [convert_endianness(line.strip()) for line in lines]
    
    with open(output_file, 'w') as file:
        file.write('\n'.join(converted_lines))
        
# Example usage
input_file = 'initial_data.txt'
correct_endianess = 'correct_endianess.txt'
output_file = 'ram.mem'
output_file_even = 'even_ram.mem'
output_file_odd = 'odd_ram.mem'
convert_file_endianness(input_file,correct_endianess)
words_to_bytes(correct_endianess,output_file)
separate_lines(output_file, output_file_even, output_file_odd)


        
