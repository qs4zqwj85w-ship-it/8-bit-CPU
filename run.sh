
#!/bin/bash
set -e

# Always run from the project root
cd "$(dirname "$0")"

echo "=== Assembling program ==="
(
    cd 15.python_assembly
    python3 assembler.py
)

# Instruction memory reads program.mem from the project root
cp 15.python_assembly/program.mem program.mem

echo "=== Compiling CPU simulator ==="
verilator --binary --timing \
  --top-module cpu_runner_tb \
  05_register_file/*.sv \
  06_alu/*.sv \
  07_PC/*.sv \
  08_instruction_memory/*.sv \
  09_controlling_unit/*.sv \
  10_data_memory/*.sv \
  11_flags/*.sv \
  12_next_pc/*.sv \
  13_writeback/*.sv \
  14_cpu/cpu.sv \
  14_cpu/cpu_runner_tb.sv

echo "=== Running program ==="
./obj_dir/Vcpu_runner_tb
