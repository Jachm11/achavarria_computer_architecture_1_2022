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


    argv = sys.argv
    filename = argv[1]
    output_filename = argv[2]

    if not output_filename:
        output_filename = 'out'

    output_file = open(output_filename + '.mem', "w")

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

                case "special":
                    encodedInstruction = metadata['encoding']

        except Exception as error: 
            raise Exception("Invalid instruction: {}: {}".format(instruction['instruction'], str(error)))
        
        else: 
            if dir != 'special':
                encodedInstruction = encodedInstruction + metadata['opcode'] + metadata['dir'] + metadata['type']
            
            encodedInstructionHex = fill(hex(int(encodedInstruction, 2))[2:], 8, "0")
            output_file.write(encodedInstructionHex + "\n")


    
    output_file.close()

if __name__ == "__main__":
    main()







