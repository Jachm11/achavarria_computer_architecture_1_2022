import sys
import os

registers = {
    "zero":"r0",
    "ra":"r1",
    "sp":"r2",
    "gp":"r3",
    "tp":"r4",
    "t0":"r5",
    "t1":"r6",
    "t2":"r7",
    "s0":"r8",
    "a0":"r10",
    "a1":"r11",
    "a2":"r12",
    "a3":"r13",
    "a4":"r14",
    "a5":"r15",
    "a6":"r16",
    "a7":"r17",
    "s2":"r18",
    "s3":"r19",
    "s4":"r20",
    "s5":"r21",
    "s6":"r22",
    "s7":"r23",
    "s8":"r24",
    "s9":"r25",
    "s10":"r26",
    "s11":"r27",
    "s1":"r9",
    "t3":"r28",
    "t4":"r29",
    "t5":"r30",
    "t6":"r31"
}



def main():

    argv = sys.argv
    filename = argv[1]
    
    file_output = open(os.path.splitext(filename)[0] + '-AIS.asm', 'w')

    print(file_output)
    with open(filename) as file_in:
        for line in file_in:

            for register in registers:
                if(line.find(register) != -1):
                    line = line.replace(register, registers[register])

            file_output.write(line)

    file_output.close()
    file_in.close()
            









if __name__ == "__main__":
    main()




