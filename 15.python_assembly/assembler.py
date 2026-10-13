def parse_assembly_file(file_path):
    instructions = []

    with open(file_path, "r", encoding="utf-8") as file:
        for line in file:

            stripped = line.strip()

            if not stripped or stripped.startswith("#"):
                continue

            parts = stripped.split(maxsplit=1)
            mnemonic = parts[0]

            if len(parts) == 1:
                operands = []
            else:
                operands = [op.strip() for op in parts[1].split(",")]

            instructions.append({
                "mnemonic": mnemonic,
                "operands": operands
            })

    return instructions


OPCODE_TABLE = {
    "NOP": 0,
    "ADD": 1,
    "SUB": 2,
    "AND": 3,
    "OR": 4,
    "XOR": 5,
    "NOT": 6,
    "LDI": 7,
    "LD": 8,
    "ST": 9,
    "JMP": 10,
    "JZ": 11,
    "JC": 12,
    "MOV": 13,
    "OUT": 14,
    "HLT": 15
}


def get_opcode(mnemonic):
    mnemonic = mnemonic.upper()
    return OPCODE_TABLE.get(mnemonic, None)


def encode_ldi(instruction):
    mnemonic = instruction["mnemonic"]
    operands = instruction["operands"]
    opcode = get_opcode(mnemonic)
    rd = int(operands[0][1:])
    immediate = int(operands[1])
    machine_code = (
        (opcode << 12)
        | (rd << 9)
        | (immediate << 1)
    )
    return machine_code

def encode_one_register(instruction):
    mnemonic = instruction["mnemonic"]
    operands = instruction["operands"]
    opcode = get_opcode(mnemonic)
    rs1 = int(operands[0][1:])
    machine_code = (opcode << 12) | (rs1 << 9)
    return machine_code

def encode_two_register(instruction):
    mnemonic = instruction["mnemonic"]
    operands = instruction["operands"]
    opcode = get_opcode(mnemonic)
    rd = int(operands[0][1:])
    rs = int(operands[1][1:])
    machine_code = (opcode << 12) | (rd << 9)| (rs << 6)
    return machine_code


def encode_three_register(instruction):
    mnemonic = instruction["mnemonic"]
    operands = instruction["operands"]
    opcode = get_opcode(mnemonic)
    rd = int(operands[0][1:])
    rs1 = int(operands[1][1:])
    rs2 = int(operands[2][1:])
    machine_code = (
        (opcode << 12)
        | (rd << 9)
        | (rs1 << 6)
        | (rs2 << 3)
    )
    return machine_code

def encode_no_operand(instruction):
    mnemonic = instruction["mnemonic"]
    opcode = get_opcode(mnemonic)
    machine_code = (opcode << 12)
    return machine_code

def encode_load(instruction):
    mnemonic = instruction["mnemonic"]
    operands = instruction["operands"]
    opcode = get_opcode(mnemonic)
    rd = int(operands[0][1:])
    address = int(operands[1])
    machine_code = (opcode << 12) | (rd << 9) | (address << 1)
    return machine_code

def encode_control_flow(instruction):
    mnemonic = instruction["mnemonic"]
    operands = instruction["operands"]
    opcode = get_opcode(mnemonic)
    address = int(operands[0])
    machine_code = (opcode << 12) | (address << 4)
    return machine_code

def encode_store(instruction):
    mnemonic = instruction["mnemonic"]
    operands = instruction["operands"]
    opcode = get_opcode(mnemonic)
    rs1 = int(operands[0][1:])
    address = int(operands[1])
    machine_code = (opcode << 12) |(rs1 << 9)| (address << 1)
    return machine_code

def encode_dispatcher(instruction):
    mnemonic = instruction["mnemonic"]
    mnemonic = mnemonic.upper()
    if mnemonic == "LDI":
        return encode_ldi(instruction)
    elif mnemonic == "OUT":
        return encode_one_register(instruction)
    elif mnemonic in ["ADD", "SUB", "AND", "OR", "XOR"]:
        return encode_three_register(instruction)
    elif mnemonic in ["NOT", "MOV"]:
        return encode_two_register(instruction)
    elif mnemonic == "LD":
        return encode_load(instruction)
    elif mnemonic == "ST":
        return encode_store(instruction)
    elif mnemonic in ["JMP", "JZ", "JC"]:
        return encode_control_flow(instruction)
    elif mnemonic in ["NOP", "HLT"]:
        return encode_no_operand(instruction)
    else:
        raise ValueError(f"failed mnemonic: {mnemonic}")




# the actual code to run the functions and write the machine code for each instruction in the file

if __name__ == "__main__":
    instructions = parse_assembly_file("program.asm")

    with open("program.mem", "w", encoding="utf-8") as output_file:
        for instruction in instructions:
            machine_code = encode_dispatcher(instruction)
            output_file.write(f"{machine_code:016b}\n")

    print(f"Assembled {len(instructions)} instructions into program.mem")
