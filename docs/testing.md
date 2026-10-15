# Testing

## 1. Overview

Testing is important because a CPU can compile successfully and still execute instructions incorrectly, (I know, shocking). 

The goal is to verify that each part of the processor behaves as expected, from instruction encoding to execution and the final results.

I use a combination of focused tests and complete-program tests to catch bugs early and make sure new changes do not break previously working functionality. 

Also, some test benches for systemverilog are above my current skill levels, so AI was used in this part in order to help with debugging and writing test benches, though which section to test bench was decided entirely by me.

## 2. Testing Strategy

Testing is divided into several stages:

1. **Assembler testing:** Check that assembly instructions are converted into the correct machine-code encodings.
2. **Instruction testing:** Verify that individual instructions produce the expected results.
3. **Control-flow testing:** Check that jumps, branches, and the program counter behave correctly.
4. **Integration testing:** Run complete programs to verify that the different CPU components work together.
5. **Regression testing:** Rerun previously passing tests after making changes to catch new bugs.

Each stage focuses on a different type of failure, making it easier to identify where something went wrong.

Each test benches are accessible in each folder, like CPU test bench will be within the folder 14_cpu, and are labeled like cpu_tb1.sv - cpu_tb8.sv.

## 3. Assembler Tests

The assembler should be tested independently from the CPU.

For each supported instruction, its generated machine code should match the expected RISC-V encoding.

Tests should cover valid instructions, register operands, immediate values, and instruction-specific encoding rules. Invalid instructions or operands should also be tested if the assembler implements error checking.

This helps distinguish assembler bugs from CPU execution bugs.

## 4. Instruction Tests

Individual instruction tests verify that the processor performs the operations specified by the ISA.

Examples include:

- Arithmetic instructions produce the expected results.
- Logical instructions produce the correct bitwise outputs.
- Load and store instructions access the correct memory locations.
- Immediate instructions handle their operands correctly.
- Instructions that modify registers update the correct destination.

Tests should include normal inputs as well as boundary cases, such as zero, negative values where applicable, and values near the limits of the supported data width.

## 5. Control-Flow Tests

Control-flow instructions require separate testing because an incorrect program counter can cause the processor to execute the wrong instruction even when the instruction itself is decoded correctly.

Tests should cover:

- Sequential instruction execution.
- Taken and not-taken conditional branches.
- Unconditional jumps.
- Branch offsets and target addresses.
- Jump and branch behavior at relevant address boundaries.

The expected execution path should be checked against the actual sequence of instructions executed by the processor.

## 6. Integration Tests

After individual instructions and components are tested, complete programs can be used to verify that the CPU works as a whole.

Integration tests should exercise interactions between instruction fetching, decoding, execution, register updates, memory access, and control flow.

Each test program should have a known expected result. The simulation output or final processor state can then be compared with that result.

## 7. Regression Testing

Whenever the CPU or assembler is modified, previously passing tests should be rerun.

A change that fixes one instruction can accidentally break another part of the processor. Keeping a collection of repeatable tests makes it easier to detect these problems early.

As the project grows, the test suite should expand alongside the supported instruction set.

## 8. Simulation and Hardware Validation

Simulation allows the processor's behavior to be checked without requiring a physical FPGA for every test.

However, passing simulation tests does not guarantee that the design will work correctly on actual hardware. FPGA validation also depends on synthesis, timing constraints, hardware interfaces, and the behavior of the implemented design.

Hardware results should therefore be documented separately from simulation results.

## 9. Test Results and Limitations

Test results should be recorded based on actual observations rather than assumed behavior.

For each test, document the instruction or functionality being tested, the expected result, the observed result, and whether the test passed.

Any unsupported instructions, known bugs, untested edge cases, or incomplete hardware validation should also be recorded.

Testing will remain an ongoing part of the project as more instructions and features are implemented.

#Hopefully eventually, I will be fluent enough in systemverilog that I can fully write the test benches myself and customise everything I want to test myself.
