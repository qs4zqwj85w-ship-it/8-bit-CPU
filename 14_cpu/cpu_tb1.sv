module cpu_tb1;

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

        // Reset CPU
        @(posedge clk);
        #1;

        if (dut.pc_current !== 8'd0)
            $display("FAIL: PC reset = %d, expected 0", dut.pc_current);
        else
            $display("PASS: PC reset to 0");

        reset = 0;

        // -------------------------
        // Address 0: NOP
        // -------------------------
        @(posedge clk);
        #1;

        if (dut.pc_current !== 8'd1)
            $display("FAIL: After NOP, PC = %d, expected 1", dut.pc_current);
        else
            $display("PASS: NOP");

        // -------------------------
        // Address 1: LDI R1, 42
        // -------------------------
        @(posedge clk);
        #1;

        if (dut.regs.registers[1] !== 8'd42)
            $display(
                "FAIL: R1 = %d, expected 42",
                dut.regs.registers[1]
            );
        else
            $display("PASS: LDI R1, 42");

        // -------------------------
        // Address 2: LDI R2, 10
        // -------------------------
        @(posedge clk);
        #1;

        if (dut.regs.registers[2] !== 8'd10)
            $display(
                "FAIL: R2 = %d, expected 10",
                dut.regs.registers[2]
            );
        else
            $display("PASS: LDI R2, 10");

        // -------------------------
        // Address 3: ADD R3, R1, R2
        // -------------------------
        @(posedge clk);
        #1;

        if (dut.regs.registers[3] !== 8'd52)
            $display(
                "FAIL: R3 = %d, expected 52",
                dut.regs.registers[3]
            );
        else
            $display("PASS: ADD R3, R1, R2");

        // -------------------------
        // Address 4: HLT
        // -------------------------
        @(posedge clk);
        #1;

        if (dut.halt !== 1'b1)
            $display("FAIL: HLT did not assert halt");
        else
            $display("PASS: HLT");

        $display("");
        $display("Final register values:");
        $display("R1 = %d", dut.regs.registers[1]);
        $display("R2 = %d", dut.regs.registers[2]);
        $display("R3 = %d", dut.regs.registers[3]);

        $finish;

    end

endmodule