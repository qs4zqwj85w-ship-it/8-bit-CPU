Forewords:

Hello, this is my first major independent digital hardware project, built to explore how a processor works from the hardware level up. After experimenting with basic digital circuits, including building a D flip-flop and a full adder from discrete transistors, I wanted to take the next step and design a programmable processor of my own.
I am just a normal college freshman who wish to pursue a degree in electrical engineer, with interest toward IC design, so this is my first attempt to do something related to my dream :)

I chose to implement the CPU in SystemVerilog, build a custom Python assembler, and use Verilator to simulate programs running on the processor.

This project is a work in progress, and I'm using it to strengthen my understanding of digital logic and hardware design.

# 8-Bit CPU

A custom 8-bit processor designed in **SystemVerilog**, with a Python assembler and a Verilator-based simulation workflow.

This project explores processor architecture from the ground up, including instruction decoding, register operations, arithmetic and logic, control flow, memory access, and program execution.

## Project Overview

The processor uses an 8-bit datapath and 16-bit instructions. Its hardware is described in SystemVerilog, while a custom Python assembler translates human-readable assembly instructions into machine code for simulation.
Initially I thought I would do everything in 8 bit. However, when I got to the instruction part, I realised for my chip to be educational and somewhat functional without touching more advanced cpu instruction technique to minimise bits, 8 bit would be very limiting, thus I switched to a 16 bit instruction set.

The project is developed and tested locally using Verilator.

### Key Specifications

| Component | Specification |
|---|---|
| Datapath width | 8 bits |
| Instruction width | 16 bits |
| Opcode width | 4 bits |
| General-purpose registers | 8 registers |
| Instruction memory | 256 × 16-bit words |
| Data memory | 256 × 8-bit locations |
| Hardware description | SystemVerilog |
| Assembler | Python |
| Simulation | Verilator |

## Features

The processor design includes:

- **Arithmetic and logic:** addition, subtraction, AND, OR, XOR, and NOT.
- **Register operations:** immediate loading, register-to-register moves, and register-file access.
- **Memory operations:** load and store instructions.
- **Control flow:** unconditional jumps and conditional branches based on processor flags.
- **Processor flags:** zero and carry flags.
- **Output instruction:** sends a register value to the simulation output.
- **Halt instruction:** stops further instruction execution by holding the program counter.
- **Custom assembler:** translates assembly programs into 16-bit machine instructions.

## Verified Demonstrations

The following behaviors have been demonstrated in simulation:

- Arithmetic instructions produce the expected results.
- The output instruction correctly reports a register value.
- The halt instruction prevents the program counter from advancing.
- Conditional branching and unconditional jumping have been exercised.
- A multiplication program using repeated addition produces the expected result of 42.

Additional instruction-level and integration testing is ongoing. Implemented features should not be considered fully validated until their relevant test cases pass.

## Project Structure

```text
8-bit-CPU/
├── 05_register_file/
├── 06_alu/
├── 07_PC/
├── 08_instruction_memory/
├── 09_controlling_unit/
├── 10_data_memory/
├── 11_flags/
├── 12_next_pc/
├── 13_writeback/
├── 14_cpu/
│   ├── cpu.sv
│   └── cpu_runner_tb.sv
├── 15.python_assembly/
│   ├── assembler.py
│   ├── program.asm
│   └── program.mem
├── run.sh
└── README.md
```

The numbered directories organize the processor's hardware modules. The assembler directory contains the software tools and assembly input, while the CPU directory contains the integrated processor and simulation runner.

## Requirements

- Python 3
- Verilator with SystemVerilog simulation support
- A Unix-like shell environment, such as macOS Terminal
- And a happy me :)

## Running a Program

1. Clone the repository and enter its directory:

   ```bash
   git clone https://github.com/qs4zqwj85w-ship-it/8-bit-CPU.git
   cd 8-bit-CPU
   ```

2. Edit `15.python_assembly/program.asm` to define the program you want to execute.

3. Run the build-and-simulation script:

   ```bash
   ./run.sh
   ```

The script assembles the program, prepares the instruction-memory file, compiles the processor with Verilator, and runs the simulation. Output instructions print their values in decimal and hexadecimal.

## Instruction Set

The processor uses a custom instruction set with 16 opcode values. Supported instruction mnemonics include:

`NOP`, `ADD`, `SUB`, `AND`, `OR`, `XOR`, `NOT`, `LDI`, `LD`, `ST`, `JMP`, `JZ`, `JC`, `MOV`, `OUT`, and `HLT`.

See the instruction-set documentation for operand formats, encoding details, and instruction semantics.

Project Goals

The goal is to develop a deeper understanding of digital logic and computer architecture through hands-on implementation. Future work includes expanding automated test coverage, validating memory and flag behavior, improving the assembler, and exploring hardware implementation.

In the future, I hope to implement the 8 bit CPU on to a FPGA board and run it physically instead of virtually simulate it. I understand to do so will come with its own challenges but that is what this project is for I guess, for my personal growth and understanding of computer architecture so I can hopefully be a better engineer and not blow someone's computer up :). Additionally, after completing this project I plan to shift to building a more conventional and standard 32 bit RISC-V CPU, as then I would be able to use the standard open source instruction set, assembly, and compiler to implement it on to FPGA and run more sophisticated programs on there, without the need of writing a whole compiler by myself (Thats also above my current skill level and would be a whole independent project it self :(, hopefully I'll eventually get that good).

Tools

SystemVerilog

Python

Verilator

Git and GitHub



AI Usage:

Though this is an educational personal project so I try to minimise the use of AI, it is still used as a helper to help me debug some code and write test benches as some systemverilog test benches are beyond my current capabilities. Also, despite test benches are written by AI, I explicitly asked for the specific workflow to be tested, and understood the majority of the test bench code. Main chip design and architecture choices however were made entirely by me, with AI only serving as a tool instead of the main lead of the project.
