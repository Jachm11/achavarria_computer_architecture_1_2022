import sys
from enum import Enum;
from utils import * 
from ISA import *
from instructionsParsers import *

def getOperation(instruction):
    return instruction[:1][0]

def parseInstruction(line): 
    return line['instruction'].replace(',', '').split(" ")

def main():


    memory_file = open("memory.txt", "w")
    argv = sys.argv
    filename = argv[1]

    rawCode = getFileContent(filename)
    (instructions, labels) = getInstructions(rawCode)

    for instruction in instructions:

        parsedInstruction = parseInstruction(instruction) 
        operation = getOperation(parsedInstruction)
        metadata = ISA.get(operation)

        if not metadata:
            raise(Exception("Invalid instruction: " + operation))

        print("--------------------------------")
        print("instruction: ", instruction)

        dir = metadata['dir']
        encodedInstruction = ""  
        try:       
            match dir:
                case "00":
                    encodedInstruction = parseDir00(parsedInstruction)

                case "01":
                    encodedInstruction = parseDir01(parsedInstruction, metadata, labels, instruction['pc'])

                case "10":
                    encodedInstruction = parseDir10(parsedInstruction, metadata, labels, instruction['pc'])

        except Exception as error: 
            raise Exception("Invalid instruction: {}: {}".format(instruction['instruction'], str(error)))
        
        else: 
            print("encode instruction: ", encodedInstruction )
            encodedInstruction = encodedInstruction + metadata['opcode'] + metadata['dir'] + metadata['type']
            encodedInstructionHex = fill(hex(int(encodedInstruction, 2))[2:], 8, "0")
            memory_file.write(encodedInstructionHex + "\n")


    
    memory_file.close()

if __name__ == "__main__":
    main()







