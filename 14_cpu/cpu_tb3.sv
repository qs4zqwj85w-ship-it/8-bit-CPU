module cpu_tb3;

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

        reset = 0;

        // --------------------------------
        // PC 0: LDI R1, 5
        // --------------------------------
        force dut.instruction = 16'b0111001000001010;
        // 0111 | 001 | 00001010 | 0
        // LDI R1, 5

        @(posedge clk);
        #1;

        if (dut.regs.registers[1] !== 8'd5)
            $display("FAIL: R1 = %d, expected 5", dut.regs.registers[1]);
        else
            $display("PASS: LDI R1, 5");

        // --------------------------------
        // PC 1: LDI R2, 5
        // --------------------------------
        force dut.instruction = 16'b0111010000001010;
        // LDI R2, 5

        @(posedge clk);
        #1;

        if (dut.regs.registers[2] !== 8'd5)
            $display("FAIL: R2 = %d, expected 5", dut.regs.registers[2]);
        else
            $display("PASS: LDI R2, 5");

        // --------------------------------
        // PC 2: SUB R3, R1, R2
        // --------------------------------
        force dut.instruction = 16'b0010011001010000;
        // 0010 | 011 | 001 | 010 | 000
        // SUB R3, R1, R2

        @(posedge clk);
        #1;

        if (dut.regs.registers[3] !== 8'd0)
            $display("FAIL: R3 = %d, expected 0", dut.regs.registers[3]);
        else
            $display("PASS: SUB R3, R1, R2");

        if (dut.zero_flag !== 1'b1)
            $display("FAIL: zero_flag = %b, expected 1", dut.zero_flag);
        else
            $display("PASS: Zero flag set");

        // --------------------------------
        // PC 3: JZ 5
        // --------------------------------
        force dut.instruction = 16'b1011000001010000;
        // 1011 | 00000101 | 0000
        // JZ 5

        @(posedge clk);
        #1;

        if (dut.pc_current !== 8'd5)
            $display(
                "FAIL: JZ did not jump. PC = %d, expected 5",
                dut.pc_current
            );
        else
            $display("PASS: JZ taken");

        // --------------------------------
        // PC 5: HLT
        // --------------------------------
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
        $display("R3 = %d", dut.regs.registers[3]);
        $display("PC = %d", dut.pc_current);

        release dut.instruction;

        $finish;

    end

endmodule