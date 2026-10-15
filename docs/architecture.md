# CPU Architecture

## 1. Overview

This project implements a custom 8-bit processor using SystemVerilog. It uses a 16-bit instruction format, a Python assembler, and Verilator for simulation.

The processor follows a fetch-decode-execute workflow. Instructions are stored in instruction memory, decoded into operations and operands, executed by the relevant hardware components, and used to update registers, memory, control flow, or simulation output.

Unlike a general-purpose processor that can run compiled C or C++ programs, this CPU currently uses a custom instruction set. Programs must be written in the assembly language supported by the project's Python assembler. which is therefore going to be somewhat simple unfortunately :(

## 2. Program Assembly

The execution process begins with a user-written assembly program.

The programmer writes instructions using supported mnemonics, such as `LDI`, `ADD`, `SUB`, `JMP`, and `OUT`. The Python assembler parses each instruction, identifies its operands, and encodes it into a 16-bit machine instruction according to the CPU's instruction format.

The resulting machine code is written to `program.mem`, which is loaded into instruction memory when the simulation initializes.

The assembler acts as a translation layer between human-readable assembly instructions and the binary instructions understood by the hardware.

## 3. Instruction Fetch

The **program counter (PC)** holds the address of the instruction to execute next.

Instruction memory uses this address to provide the corresponding 16-bit instruction. The PC and other sequential state are updated in response to the clock, while the instruction-memory output follows the selected address.

Under normal sequential execution, the PC advances to the next instruction. Jump and branch instructions can instead select a different address, changing the program's execution path.

This I believe is fairly standard procedure for modern cpu, at least that is what my research results are telling me, so the PC counter practically came with specs and I just had to write them out with systemverilog, run test benches, and basically complete with this part.

## 4. Instruction Decode and Control

The instruction decoder interprets the fetched 16-bit instruction by extracting fields such as:

- **Opcode:** identifies the requested operation.
- **Register fields:** identify source and destination registers when required.
- **Immediate or address fields:** provide constants or memory/control-flow addresses for applicable instructions.

The decoded instruction information is passed to the control unit. The control unit interprets the opcode and generates control signals that coordinate the processor's components.

Depending on the instruction, these signals can select an ALU operation, enable register writes, control data-memory reads or writes, select the writeback source, update the PC, trigger output, or halt execution.

## 5. Execution and Datapath

The processor's datapath contains the components responsible for operating on data and moving results through the system.

### Register File

The register file stores the processor's general-purpose 8-bit values. Instructions can read source registers and, when appropriate, write results to a destination register.

The instruction format uses 3-bit register indices, allowing eight register addresses.

### Arithmetic Logic Unit (ALU)

The ALU performs arithmetic and logical operations selected by the control unit. Supported operations include addition, subtraction, AND, OR, XOR, and NOT.

The ALU's result can be written back to a register. Relevant operations can also update the processor's flags.

### Data Memory

Data memory provides storage separate from instruction memory. Load instructions read data from memory, while store instructions write register data to a specified memory address.

The control unit determines when memory operations occur.

### Flags

The flag logic maintains status information used by conditional control flow. The current design includes zero and carry flags.

For example, `JZ` uses the zero condition to determine whether to branch, while `JC` uses the carry condition.

### Writeback

The writeback logic selects the value that should be written to the destination register. Depending on the instruction, the value can come from the ALU, data memory, an immediate constant, or another register.

Not every instruction writes a register. Stores, jumps, output operations, and halt instructions serve different purposes.

## 6. Control Flow

The next-PC logic determines which instruction address the processor should use next.

During ordinary execution, the processor proceeds sequentially. Jump instructions select a specified address, while conditional branches use flag information to decide whether to jump or continue. 

The processor supports the following control-flow instructions:

- `JMP`: unconditional jump.
- `JZ`: jump when the zero condition is satisfied.
- `JC`: jump when the carry condition is satisfied.
- `HLT`: halt execution by preventing the PC from advancing.

These instructions allow programs to implement loops and conditional behavior instead of executing every instruction exactly once in sequence.

## 7. Simulation Output

The `OUT` instruction sends the value of a selected register to the CPU's simulation output.

The top-level CPU captures the output value and asserts an output-valid signal when an output operation occurs. The testbench monitors this signal and prints the result in decimal and hexadecimal.

The `HLT` instruction allows a program to stop executing. The simulation runner also has a timeout to detect programs that fail to halt within the allowed number of cycles. Currently its set to 10000 cycles I believe, so it doesn't indefinitely run when something is wrong.

## 8. Complete Execution Flow

The processor's overall workflow can be summarized as follows:

1. Write an assembly program.
2. Run the Python assembler to generate machine code.
3. Load the machine code into instruction memory.
4. Use the PC to select the instruction to fetch.
5. Decode the instruction and generate control signals.
6. Execute the operation using the register file, ALU, memory, or control-flow logic.
7. Write results back to the appropriate destination when required.
8. Update the PC and continue execution until the program halts or the simulation times out.

## 9. Design Scope

This project is an educational processor designed to explore digital logic and computer architecture. Its instruction set, datapath width, and execution behavior are defined by the custom hardware implementation.

The current workflow uses assembly programs and simulation rather than a general-purpose compiler or a physical processor implementation. In the future, further development will focus on validating instruction behavior, improving automated testing, and exploring possible hardware implementation. Moreover, this project was a great introduction for me to chip architecture design, as it took a lot of research and understanding, and it will definitely help me when I eventually try to design a more conventional 32 or 64 bit CPU.
