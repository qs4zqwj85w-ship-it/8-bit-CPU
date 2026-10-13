module cpu_tb4;

    logic clk;
    logic reset;

    cpu dut (
        .clk(clk),
        .reset(reset)
    );

    // Clock: 10 ns period
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
        // 1: LDI R2, 3
        // 2: SUB R1, R2       -> R1 = 7, Z = 0
        // 3: JZ 6             -> NOT taken
        // 4: LDI R3, 99       -> should execute
        // 5: HLT
        // 6: LDI R3, 42       -> should NOT execute
        // ------------------------------------------------

        dut.imem.memory[0] = {4'b0111, 3'b001, 8'd10, 1'b0};  // LDI R1, 10
        dut.imem.memory[1] = {4'b0111, 3'b010, 8'd3,  1'b0};  // LDI R2, 3

        dut.imem.memory[2] = {4'b0010, 3'b001, 3'b001, 3'b010, 3'b000};
        // SUB R1, R1, R2

        dut.imem.memory[3] = {4'b1011, 8'd6, 4'b0000};
        // JZ address 6

        dut.imem.memory[4] = {4'b0111, 3'b011, 8'd99, 1'b0};
        // LDI R3, 99

        dut.imem.memory[5] = 16'b1111000000000000;
        // HLT

        dut.imem.memory[6] = {4'b0111, 3'b011, 8'd42, 1'b0};
        // LDI R3, 42 -- should NOT execute

        // Let CPU run
        #100;

        // ------------------------------------------------
        // Checks
        // ------------------------------------------------

        if (dut.regs.registers[1] == 8'd7)
            $display("PASS: SUB produced 7");
        else
            $display("FAIL: R1 = %d, expected 7",
                     dut.regs.registers[1]);

        if (dut.regs.registers[3] == 8'd99)
            $display("PASS: JZ not taken");
        else
            $display("FAIL: JZ incorrectly taken, R3 = %d, expected 99",
                     dut.regs.registers[3]);

        $display("");
        $display("Final values:");
        $display("R1 = %d", dut.regs.registers[1]);
        $display("R2 = %d", dut.regs.registers[2]);
        $display("R3 = %d", dut.regs.registers[3]);

        $finish;
    end

endmodule