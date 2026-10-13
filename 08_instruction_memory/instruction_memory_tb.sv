module instruction_memory_tb;

    logic [7:0]  address;
    logic [15:0] instruction;
    logic [15:0] expected;

    instruction_memory dut (
        .address(address),
        .instruction(instruction)
    );

    initial begin

        // Address 0: NOP
        address = 8'd0;
        #1;
        expected = 16'b0000000000000000;

        if (instruction != expected)
            $display("FAIL: address=%d instruction=%b expected=%b",
                     address, instruction, expected);
        else
            $display("PASS: address=%d instruction=%b",
                     address, instruction);


        // Address 1: LDI R1, 42
        address = 8'd1;
        #1;
        expected = 16'b0111001001010100;

        if (instruction != expected)
            $display("FAIL: address=%d instruction=%b expected=%b",
                     address, instruction, expected);
        else
            $display("PASS: address=%d instruction=%b",
                     address, instruction);


        // Address 2: LDI R2, 10
        address = 8'd2;
        #1;
        expected = 16'b0111010000010100;

        if (instruction != expected)
            $display("FAIL: address=%d instruction=%b expected=%b",
                     address, instruction, expected);
        else
            $display("PASS: address=%d instruction=%b",
                     address, instruction);


        // Address 3: ADD R3, R1, R2
        address = 8'd3;
        #1;
        expected = 16'b0001011001010000;

        if (instruction != expected)
            $display("FAIL: address=%d instruction=%b expected=%b",
                     address, instruction, expected);
        else
            $display("PASS: address=%d instruction=%b",
                     address, instruction);


        // Address 4: HLT
        address = 8'd4;
        #1;
        expected = 16'b1111000000000000;

        if (instruction != expected)
            $display("FAIL: address=%d instruction=%b expected=%b",
                     address, instruction, expected);
        else
            $display("PASS: address=%d instruction=%b",
                     address, instruction);


        // Address 10 was not explicitly programmed,
        // so it should contain the default NOP.
        address = 8'd10;
        #1;
        expected = 16'b0000000000000000;

        if (instruction != expected)
            $display("FAIL: address=%d instruction=%b expected=%b",
                     address, instruction, expected);
        else
            $display("PASS: address=%d instruction=%b",
                     address, instruction);


        $display("Instruction memory testing complete.");
        $finish;
    end

endmodule