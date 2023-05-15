ISA = {
    "add": {
        "opcode": "000",
        "dir": "00",
        "type": "00",
        "operands": ["rd", "rx", "ry"],         
    },
    "sub": {
        "opcode": "001",
        "dir": "00",
        "type": "00",
        "operands": ["rd", "rx", "ry"],  
    },
    "mul": {
        "opcode": "010",
        "dir": "00",
        "type": "00",
        "operands": ["rd", "rx", "ry"],  
    },
    "div": {
        "opcode": "011",
        "dir": "00",
        "type": "00",
        "operands": ["rd", "rx", "ry"],  
    },
    "mod": {
        "opcode": "100",
        "dir": "00",
        "type": "00",
        "operands": ["rd", "rx", "ry"],  
    },
    "addi": {
        "opcode": "000",
        "dir": "01",
        "type": "00",
        "operands": ["rd", "rx", "ry"],  
        "immediate_size": 15
    },
    "slli": {
        "opcode": "001",
        "dir": "01",
        "type": "00",
        "operands": ["rd","rx", "immediate"],  
        "immediate_size": 15
    },
    "srli": {
        "opcode": "010",
        "dir": "01",
        "type": "00",
        "operands": ["rd","rx", "immediate"],  
        "immediate_size": 15
    },
    "sb": {
        "opcode": "000",
        "dir": "01",
        "type": "01",
        "operands": ["rx", "immediate/ry"],  
        "immediate_size": 15
    },
    "lbu": {
        "opcode": "001",
        "dir": "01",
        "type": "01",
        "operands": ["rx", "immediate/ry" ],  
        "immediate_size": 15
    },
    "lhu": {
        "opcode": "010",
        "dir": "01",
        "type": "01",
        "operands": ["rx", "immediate/ry"],  
        "immediate_size": 15
    },
    "lh": {
        "opcode": "011",
        "dir": "01",
        "type": "01",
        "operands": ["rx", "immediate/ry"],  
        "immediate_size": 15
    },
    "jalr": {
        "opcode": "000",
        "dir": "01",
        "type": "10",
        "operands": ["rd", "rx", "immediate"],  
        "immediate_size": 15
    },
    "beq": {
        "opcode": "001",
        "dir": "01",
        "type": "10",
        "operands": [ "rx", "ry", "label"],  
        "immediate_size": 15
    },
    "bne": {
        "opcode": "010",
        "dir": "01",
        "type": "10",
        "operands": [ "rx", "ry", "label"],  
        "immediate_size": 15
    },
    "ble": {
        "opcode": "011",
        "dir": "01",
        "type": "10",
        "operands": [ "rx", "ry", "label"],  
        "immediate_size": 15
    },
    "blt": {
        "opcode": "100",
        "dir": "01",
        "type": "10",
        "operands": [ "rx", "ry", "label"],  
        "immediate_size": 15,
    },
    "lui": {
        "opcode": "000",
        "dir": "10",
        "type": "00",
        "operands": ["rd", "label"],  
        "immediate_size": 20
    },
    "jal": {
        "opcode": "001",
        "dir": "10",
        "type": "10",
        "operands": ["rd", "label"],  
        "immediate_size": 20
    },
    "nop": {
        "dir": "special",
        "encoding": "100"
    }
}