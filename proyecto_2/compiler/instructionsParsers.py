
from compiler.compiler import getOperation
from registers import *
from utils import *

#       __________________________________-
#______/ General purpose functions 

def getOperands(instruction): 
    operands = instruction[1:]
    return operands


def findLabelRefence(labels, label):
    
    for i in range(len(labels)):
        current_label = labels[i]
        if(current_label['label'] == label):
            return current_label['reference']
    raise Exception('Label "{}" not found: '.format(label) )

def encodeImmediate(immediate, size):

    try:
        if(isHex(str(immediate))):
            immediate = hexToDec(immediate)

        if(int(immediate) < 0): 
            print(computeMask(size))
            two_complement = bin(int(immediate) & int(computeMask(size), 2))[2:]
            return fill(two_complement, size, "1")

        binary = toBinary(int(immediate))
        return fill(binary, size, "0")
    except: 
        raise Exception("Invalid immediate {}".format(immediate))



def calculateNewPc(labels, label, current_pc, size):
    reference = findLabelRefence(labels, label)
    new_pc = reference - current_pc
    return encodeImmediate(new_pc, size)


def computeMask(size): 
    mask = ["1"] * size
    return "0b" + ''.join(mask)


#       __________________________________-
#______/ Dir parsers

# 
# Parses instructions with dir 00
#
def parseDir00(instruction):

    operands = getOperands(instruction)

    rd = getEncodedRegister(operands[0])
    rx = getEncodedRegister(operands[1])
    ry = getEncodedRegister(operands[2])
    return ry + rx + rd


# 
# Parses instructions with dir 01
#
def parseDir01(instruction, metadata, labels, current_pc):

    type = metadata['type']
    operands = getOperands(instruction)
    

    match type: 

        case "00":
            rd = getEncodedRegister(operands[0])
            rx = getEncodedRegister(operands[1])
            immediate = encodeImmediate(operands[2], metadata['immediate_size'])
            return immediate + rx + rd

        case "01":
            rd = getEncodedRegister(operands[0])
            result = re.match(r"(?P<immediate>-?[0-9])\((?P<register>.*)\)", operands[1])
            rx = getEncodedRegister(result.group('register'))
            immediate = result.group('immediate')
            immediate = encodeImmediate(immediate, metadata['immediate_size'])
            return immediate + rx + rd

        case "10":
            rx = getEncodedRegister(operands[0])
            ry = getEncodedRegister(operands[1])

            size = metadata['immediate_size']
            if(metadata['operands'][2] == "immediate"):
                immediate = encodeImmediate(operands[2], size)
            else:
                immediate = calculateNewPc(labels, operands[2], current_pc, size)

            operation = getOperation(instruction)
            if(operation == 'jalr'):
                return immediate + ry + rx
            return immediate + rx + ry

# 
# Parses instructions with dir 10
#
def parseDir10(instruction, metadata, labels, current_pc):

    type = metadata['type']
    operands = getOperands(instruction)
    match type: 

        case "00":
            rd = getEncodedRegister(operands[0])
            immediate = encodeImmediate(operands[1], metadata['immediate_size'])
            return immediate + rd
        
        case "10":
            rd  = getEncodedRegister(operands[0])
            immediate = calculateNewPc(labels, operands[1], current_pc, metadata['immediate_size'])
            return immediate + rd
