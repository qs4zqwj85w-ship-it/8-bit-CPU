module cpu_tb6;

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
        // 0: LDI R1, 255
        // 1: LDI R2, 1
        // 2: ADD R1, R2       -> R1 = 0, Carry = 1
        // 3: JC 6             -> should jump
        // 4: LDI R3, 99       -> should be skipped
        // 5: HLT              -> should be skipped
        // 6: LDI R3, 42
        // 7: HLT
        // ------------------------------------------------

        dut.imem.memory[0] = {4'b0111, 3'b001, 8'd255, 1'b0};
        // LDI R1, 255

        dut.imem.memory[1] = {4'b0111, 3'b010, 8'd1, 1'b0};
        // LDI R2, 1

        dut.imem.memory[2] = {4'b0001, 3'b001, 3'b001, 3'b010, 3'b000};
        // ADD R1, R1, R2

        dut.imem.memory[3] = {4'b1100, 8'd6, 4'b0000};
        // JC address 6

        dut.imem.memory[4] = {4'b0111, 3'b011, 8'd99, 1'b0};
        // LDI R3, 99 -- should NOT execute

        dut.imem.memory[5] = 16'b1111000000000000;
        // HLT -- should NOT execute

        dut.imem.memory[6] = {4'b0111, 3'b011, 8'd42, 1'b0};
        // LDI R3, 42

        dut.imem.memory[7] = 16'b1111000000000000;
        // HLT

        // Let CPU run
        #120;

        // ------------------------------------------------
        // Checks
        // ------------------------------------------------

        if (dut.regs.registers[1] == 8'd0)
            $display("PASS: ADD produced 0 with carry");
        else
            $display("FAIL: R1 = %d, expected 0",
                     dut.regs.registers[1]);

        if (dut.regs.registers[3] == 8'd42)
            $display("PASS: JC taken");
        else
            $display("FAIL: JC not taken, R3 = %d, expected 42",
                     dut.regs.registers[3]);

        $display("");
        $display("Final values:");
        $display("R1 = %d", dut.regs.registers[1]);
        $display("R2 = %d", dut.regs.registers[2]);
        $display("R3 = %d", dut.regs.registers[3]);

        $finish;
    end

endmodule