module cpu_tb2;

    logic clk;
    logic reset;

    cpu dut (
        .clk(clk),
        .reset(reset)
    );

    always #5 clk = ~clk;

    initial begin

        clk = 0;
        reset = 1;

        // Reset
        @(posedge clk);
        #1;

        if (dut.pc_current !== 8'd0)
            $display("FAIL: PC reset = %d, expected 0", dut.pc_current);
        else
            $display("PASS: PC reset to 0");

        reset = 0;

        // PC = 0 : NOP
        force dut.instruction = 16'b0000000000000000;

        @(posedge clk);
        #1;

        if (dut.pc_current !== 8'd1)
            $display("FAIL: PC after NOP = %d, expected 1", dut.pc_current);
        else
            $display("PASS: NOP");

        // PC = 1 : LDI R1, 42
        force dut.instruction = 16'b0111001001010100;

        @(posedge clk);
        #1;

        if (dut.regs.registers[1] !== 8'd42)
            $display(
                "FAIL: R1 = %d, expected 42",
                dut.regs.registers[1]
            );
        else
            $display("PASS: LDI R1, 42");

        // ST R1, 20
        force dut.instruction = 16'b1001001000101000;

        @(posedge clk);
        #1;

        if (dut.data_mem.memory[20] !== 8'd42)
            $display(
                "FAIL: memory[20] = %d, expected 42",
                dut.data_mem.memory[20]
            );
        else
            $display("PASS: ST R1, 20");

        // LD R2, 20
        force dut.instruction = 16'b1000010000101000;

        @(posedge clk);
        #1;

        if (dut.regs.registers[2] !== 8'd42)
            $display(
                "FAIL: R2 = %d, expected 42",
                dut.regs.registers[2]
            );
        else
            $display("PASS: LD R2, 20");

        // PC = 4 : HLT
        force dut.instruction = 16'b1111000000000000;

        #1;

        if (dut.halt !== 1'b1)
            $display("FAIL: HLT did not assert halt");
        else
            $display("PASS: HLT");

        $display("");
        $display("Final values:");
        $display("R1 = %d", dut.regs.registers[1]);
        $display("R2 = %d", dut.regs.registers[2]);
        $display("memory[20] = %d", dut.data_mem.memory[20]);

        release dut.instruction;

        $finish;

    end

endmodule