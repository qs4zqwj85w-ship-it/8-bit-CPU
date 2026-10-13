module cpu_tb5;

    logic clk;
    logic reset;

    cpu dut (
        .clk(clk),
        .reset(reset)
    );

    // 10 ns clock
    always #5 clk = ~clk;

    initial begin
        clk = 0;
        reset = 1;

        // Reset CPU
        #10;
        reset = 0;

        // ------------------------------------------------
        // Program:
        //
        // 0: LDI R1, 10
        // 1: JMP 4
        // 2: LDI R1, 99       <- should be skipped
        // 3: HLT              <- should be skipped
        // 4: LDI R1, 42
        // 5: HLT
        // ------------------------------------------------

        dut.imem.memory[0] = {4'b0111, 3'b001, 8'd10, 1'b0};
        // LDI R1, 10

        dut.imem.memory[1] = {4'b1010, 8'd4, 4'b0000};
        // JMP address 4

        dut.imem.memory[2] = {4'b0111, 3'b001, 8'd99, 1'b0};
        // LDI R1, 99 -- should NOT execute

        dut.imem.memory[3] = 16'b1111000000000000;
        // HLT -- should NOT execute

        dut.imem.memory[4] = {4'b0111, 3'b001, 8'd42, 1'b0};
        // LDI R1, 42

        dut.imem.memory[5] = 16'b1111000000000000;
        // HLT

        // Let CPU run
        #100;

        // ------------------------------------------------
        // Check result
        // ------------------------------------------------

        if (dut.regs.registers[1] == 8'd42)
            $display("PASS: JMP successfully skipped instructions");
        else
            $display("FAIL: R1 = %d, expected 42",
                     dut.regs.registers[1]);

        $display("");
        $display("Final values:");
        $display("R1 = %d", dut.regs.registers[1]);

        $finish;
    end

endmodule