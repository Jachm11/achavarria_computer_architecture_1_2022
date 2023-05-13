import re
from uuid import *

LABEL_REGEX = '.*:'
COMMENT_REGEX = '\#.*'


def getLabels(rawCode, instructions):
    labels = []
    for i in range(len(rawCode)):
        line = rawCode[i]
        if(re.search(LABEL_REGEX, line)):
            labels.append({"instruction_id": instructions[i+1], "label": line.replace(':', '')})
    return labels

def isLabel(line):
    return re.search(LABEL_REGEX, line['instruction'])


def removeLabels(instructions):
    return (list(filter(lambda instruction: not re.search(LABEL_REGEX, instruction['instruction']), instructions)))

def parseLine(line):
    line = line.replace('\n', '')
    line = re.sub(COMMENT_REGEX, '', line)
    return line.strip()

def cleanLines(lines):
    lines = list(filter(lambda line: line != '\n', lines))
    lines = list(map(parseLine, lines))
    return lines
    
def getFileContent(filename):
    file = open(filename, 'r')
    fileContent = list(filter(lambda line: line != '\n', file.readlines()))
    fileContent = list(map(lambda line: line.strip(), fileContent))
    fileContent = list(filter(lambda line: line != '', cleanLines(fileContent)))
    file.close()
    return fileContent

def fill(value, size, filled):
    while(len(value) < size):
        value = filled + value

    return value

def getInstructions(rawCode):
    instructions = []
    labels = []
    pc = 0
    for i in range(len(rawCode)):
        if(re.search(LABEL_REGEX,  rawCode[i])):
            labels.append({'reference': pc, 'label': rawCode[i].replace(":", "")})
            continue
        instructions.append({'pc': pc, 'instruction': rawCode[i]})
        pc += 1
    return (instructions, labels)

def isHex(value): 
    return value.find("0x") != -1


def hexToBin(value):
    value = value.replace("0x", '')
    valueDec = int(value, 16)
    return bin(valueDec)

def toBinary(value): 
    return bin(value)[2:]


def hexToDec(value):
    value = value.replace("0x", '')
    return int(value, 16)
