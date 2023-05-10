def create_mem_file(depth, width, filename):
    with open(filename, 'w') as f:
        for i in range(depth):
            for j in range(width):
                f.write("0")
            f.write("\n")


create_mem_file(512, 32, 'memory.mem')