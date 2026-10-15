# Instruction Set Architecture (ISA)

## 1. Overview

This CPU implements a custom instruction set architecture (ISA) using 16-bit instructions and an 8-bit datapath. 
Choice was made as I realised a 8 bit instruction would be very limiting on the instruction types, likely only be able to do 3 bit of instruction opcode instead of 4, while also challenging to do operation with more than 2 register address.

The ISA defines the operations the processor can execute, how instructions are encoded, and how the processor interacts with registers, memory, and control flow.

The instruction set includes arithmetic, bitwise logic, data movement, memory access, conditional branching, output, and program termination.

## 2. Instruction Encoding

Each instruction is 16 bits wide.

The primary opcode occupies bits `[15:12]`, identifying the instruction to execute. The remaining bits are interpreted according to the instruction format.

| Field | Bits | Description |
|---|---|---|
| Opcode | `[15:12]` | Selects the instruction |
| Destination register (`rd`) | `[11:9]` | Identifies a destination register where applicable |
| Source register (`rs1`) | `[8:6]` | Identifies a source register where applicable |
| Source register (`rs2`) | `[5:3]` | Identifies a second source register where applicable |
| Immediate/address fields | Instruction-dependent | Encode constants, memory addresses, or branch targets |

Not every instruction uses every field. The decoder interprets the instruction according to its opcode and format, and they are hard coded into the decoder manually.

## 3. Instruction Set

The following table defines the processor's opcode assignments.

| Opcode | Mnemonic | Description |
|---|---|---|
| `0x0` | NOP | Performs no operation |
| `0x1` | ADD | Adds two register operands |
| `0x2` | SUB | Subtracts one register operand from another |
| `0x3` | AND | Performs bitwise AND |
| `0x4` | OR | Performs bitwise OR |
| `0x5` | XOR | Performs bitwise XOR |
| `0x6` | NOT | Performs bitwise inversion |
| `0x7` | LDI | Loads an immediate value |
| `0x8` | LD | Loads data from memory |
| `0x9` | ST | Stores data to memory |
| `0xA` | JMP | Performs an unconditional jump |
| `0xB` | JZ | Jumps when the zero condition is satisfied |
| `0xC` | JC | Jumps when the carry condition is satisfied |
| `0xD` | MOV | Copies data between registers |
| `0xE` | OUT | Outputs a value |
| `0xF` | HLT | Halts program execution |

## 4. Instruction Categories

### Arithmetic and Logical Operations
#these are sent to the ALU.
- `ADD`: Adds two operands.
- `SUB`: Subtracts the second operand from the first.
- `AND`, `OR`, `XOR`: Perform bitwise logical operations.
- `NOT`: Inverts the bits of an operand.

Arithmetic and logical operations operate on 8-bit values.

### Data Movement and Memory Access
#these are direct operations done to the registers and data
- `LDI`: Loads an immediate constant into a register.
- `MOV`: Copies a value between registers.
- `LD`: Reads data from data memory.
- `ST`: Writes data to data memory.

### Control Flow
#these are common control instructions used to skip or jump operations
- `JMP`: Transfers execution to a specified target.
- `JZ`: Transfers execution when the zero condition is satisfied.
- `JC`: Transfers execution when the carry condition is satisfied.
- `NOP`: Performs no operation.
- `HLT`: Terminates execution.

### Output
#simple output operation
- `OUT`: Sends a value to the processor's output mechanism.

## 5. Example Program

The following assembly program loads two values, adds them, and halts.

```asm
LDI R1, 42
LDI R2, 10
ADD R3, R1, R2
HLT
```

Expected result:

- `R1 = 42`
- `R2 = 10`
- `R3 = 52`

This example demonstrates immediate loading, register-based arithmetic, and program termination.

## 6. Implementation Notes

The instruction decoder interprets machine instructions, while the control unit generates the signals required to execute them.

The ISA specification should be kept consistent with the actual SystemVerilog implementation and Python assembler.

Instruction-specific field layouts, flag behavior, memory addressing, branch target semantics, and output behavior should be documented explicitly based on the implemented hardware.
