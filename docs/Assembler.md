# Assembler

## 1. Overview

The assembler converts human-readable assembly instructions into machine code that the CPU can execute.

Instead of manually writing binary instructions, a programmer can write assembly using instruction names, registers, and operands. The assembler translates this source into the instruction encoding expected by the processor.

Clearly, no one is casually coding in assembly language now days because that is very slow and inefficient, you also probably need a brain capacity of Einstein to pull of anything useful as assembly instructions are so low level. So currently, my CPU's main function can only be used as a somewhat programable calculator as I am not skilled enough to program a custom compiler for higher level languages.

This project targets a RISC-V CPU. Each supported instruction must be encoded according to the instruction format implemented by the processor.

## 2. Input and Output

**Input:** An assembly program containing instructions and their operands.

**Output:** Machine-code instructions that can be loaded into the CPU's instruction memory or used by the simulation environment.

The exact output format depends on the assembler implementation.

After knowing the input and output specs, it was just a ton of python research on how to pull this off as I am not very fluent in this programming language yet. (I've done python before here and there but nothing significant, and definitely did not use commands related to binary.)

## 3. Assembly-to-Machine-Code Workflow

The assembler follows these general steps:

1. **Read the source:** Load the assembly program and process its lines.
2. **Parse instructions:** Identify each instruction mnemonic, its operands, and any labels.
3. **Select the instruction format:** Determine the encoding format required by the instruction.
4. **Encode the instruction:** Convert the mnemonic and operands into the appropriate machine-code fields.
5. **Generate output:** Write the encoded instructions in the format expected by the CPU or simulator.

The actual implementation may combine some of these steps or handle additional cases.

## 4. RISC-V Instruction Encoding

RISC-V instructions contain fields that specify the operation, source and destination registers, and, when applicable, immediate values or control-flow offsets.

For example, the encoding of an instruction depends on its instruction format, such as R-type, I-type, S-type, B-type, U-type, or J-type.

The assembler must place each field in the correct bit positions and handle immediate values according to the relevant instruction encoding.

## 5. Example

Consider the following assembly instruction:

```asm
addi x1, x0, 5
```

This instruction adds the immediate value `5` to the value in register `x0` and writes the result to register `x1`.

In standard RISC-V, `x0` always reads as zero. Therefore, the instruction writes the value `5` into `x1`.

The assembler converts this human-readable instruction into its corresponding machine-code representation.

## 6. Implementation Notes

The assembler and the CPU decoder must agree on the instruction encoding. If the assembler places a field in the wrong bit positions, the CPU may decode the instruction incorrectly.

The assembler's supported instructions, operand syntax, label handling, error checking, and output format should be documented according to the actual implementation.

As the CPU develops, the assembler should be updated alongside the instruction decoder and the ISA documentation.
