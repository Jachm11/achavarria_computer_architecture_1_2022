ISA = {
    "summare": {
        "opcode": "000",
        "dir": "00",
        "type": "00",
        "operands": ["rd", "rx", "ry"],         
    },
    "subtrahere": {
        "opcode": "001",
        "dir": "00",
        "type": "00",
        "operands": ["rd", "rx", "ry"],  
    },
    "multiplicare": {
        "opcode": "010",
        "dir": "00",
        "type": "00",
        "operands": ["rd", "rx", "ry"],  
    },
    "dividere": {
        "opcode": "011",
        "dir": "00",
        "type": "00",
        "operands": ["rd", "rx", "ry"],  
    },
    "modularizare": {
        "opcode": "100",
        "dir": "00",
        "type": "00",
        "operands": ["rd", "rx", "ry"],  
    },
    "summare_immediatus": {
        "opcode": "000",
        "dir": "01",
        "type": "00",
        "operands": ["rd", "rx", "ry"],  
        "immediate_size": 15
    },
    "transferre_sinistra_immediatus": {
        "opcode": "001",
        "dir": "01",
        "type": "00",
        "operands": ["rd","rx", "immediate"],  
        "immediate_size": 15
    },
    "transferre_dextra_immediatus": {
        "opcode": "010",
        "dir": "01",
        "type": "00",
        "operands": ["rd","rx", "immediate"],  
        "immediate_size": 15
    },
    "conservare_octo": {
        "opcode": "000",
        "dir": "01",
        "type": "01",
        "operands": ["rx", "immediate/ry"],  
        "immediate_size": 15
    },
    "onerare_octo_ss": {
        "opcode": "001",
        "dir": "01",
        "type": "01",
        "operands": ["rx", "immediate/ry" ],  
        "immediate_size": 15
    },
    "onerare_sedecim_ss": {
        "opcode": "010",
        "dir": "01",
        "type": "01",
        "operands": ["rx", "immediate/ry"],  
        "immediate_size": 15
    },
    "onerare_sedecim": {
        "opcode": "011",
        "dir": "01",
        "type": "01",
        "operands": ["rx", "immediate/ry"],  
        "immediate_size": 15
    },
    "saltare_ligare_r": {
        "opcode": "000",
        "dir": "01",
        "type": "10",
        "operands": ["rd", "rx", "immediate"],  
        "immediate_size": 15
    },
    "ramos_facere_aequalis": {
        "opcode": "001",
        "dir": "01",
        "type": "10",
        "operands": [ "rx", "ry", "label"],  
        "immediate_size": 15
    },
    "ramos_facere_no_aequalis": {
        "opcode": "010",
        "dir": "01",
        "type": "10",
        "operands": [ "rx", "ry", "label"],  
        "immediate_size": 15
    },
    "ramos_facere_minor_aequalis": {
        "opcode": "011",
        "dir": "01",
        "type": "10",
        "operands": [ "rx", "ry", "label"],  
        "immediate_size": 15
    },
    "ramos_facere_minor": {
        "opcode": "100",
        "dir": "01",
        "type": "10",
        "operands": [ "rx", "ry", "label"],  
        "immediate_size": 15,
    },
    "onerare_ss_immediatus": {
        "opcode": "000",
        "dir": "10",
        "type": "00",
        "operands": ["rd", "label"],  
        "immediate_size": 20
    },
    "saltare_ligare": {
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