module instruction_decoder_tb;

    logic [15:0] instruction;

    logic [3:0] opcode;
    logic [2:0] rd;
    logic [2:0] rs1;
    logic [2:0] rs2;
    logic [7:0] immediate;
    logic [7:0] address;

    integer failures;

    instruction_decoder dut (
        .instruction(instruction),
        .opcode(opcode),
        .rd(rd),
        .rs1(rs1),
        .rs2(rs2),
        .immediate(immediate),
        .address(address)
    );

    task check(
        input logic [15:0] test_instruction,
        input logic [3:0] expected_opcode,
        input logic [2:0] expected_rd,
        input logic [2:0] expected_rs1,
        input logic [2:0] expected_rs2,
        input logic [7:0] expected_immediate,
        input logic [7:0] expected_address
    );

        begin
            instruction = test_instruction;
            #1;

            if (opcode !== expected_opcode ||
                rd !== expected_rd ||
                rs1 !== expected_rs1 ||
                rs2 !== expected_rs2 ||
                immediate !== expected_immediate ||
                address !== expected_address) begin

                $display("FAIL:");
                $display("  instruction = %b", instruction);
                $display("  opcode      = %b (expected %b)", opcode, expected_opcode);
                $display("  rd          = %b (expected %b)", rd, expected_rd);
                $display("  rs1         = %b (expected %b)", rs1, expected_rs1);
                $display("  rs2         = %b (expected %b)", rs2, expected_rs2);
                $display("  immediate   = %d (expected %d)", immediate, expected_immediate);
                $display("  address     = %d (expected %d)", address, expected_address);

                failures = failures + 1;
            end
            else begin
                $display("PASS: instruction = %b", instruction);
            end
        end
    endtask


    initial begin

        failures = 0;

        // ------------------------------------------------
        // NOP
        // ------------------------------------------------
        check(
            16'b0000000000000000,
            4'b0000,
            3'b000,
            3'b000,
            3'b000,
            8'b00000000,
            8'b00000000
        );

        // ------------------------------------------------
        // ADD R3, R1, R2
        // opcode = 0001
        // rd     = 011
        // rs1    = 001
        // rs2    = 010
        // ------------------------------------------------
        check(
            16'b0001011001010000,
            4'b0001,
            3'b011,
            3'b001,
            3'b010,
            8'b00000000,
            8'b00000000
        );

        // SUB R4, R6, R2
        check(
            {4'b0010, 3'b100, 3'b110, 3'b010, 3'b000},
            4'b0010,
            3'b100,
            3'b110,
            3'b010,
            8'd0,
            8'd0
        );

        // AND R2, R5, R7
        check(
            {4'b0011, 3'b010, 3'b101, 3'b111, 3'b000},
            4'b0011,
            3'b010,
            3'b101,
            3'b111,
            8'd0,
            8'd0
        );

        // XOR R7, R4, R0
        check(
            {4'b0101, 3'b111, 3'b100, 3'b000, 3'b000},
            4'b0101,
            3'b111,
            3'b100,
            3'b000,
            8'd0,
            8'd0
        );

        // LD R4, [37]
        check(
            {4'b1000, 3'b100, 8'd37, 1'b0},
            4'b1000,
            3'b100,
            3'b000,
            3'b000,
            8'd0,
            8'd37
        );

        // ST R4, [37]
        check(
            {4'b1001, 3'b100, 8'd37, 1'b0},
            4'b1001,
            3'b000,
            3'b100,
            3'b000,
            8'd0,
            8'd37
        );

        if (failures == 0)
            $display("ALL DECODER TESTS PASSED.");
        else
            $display("DECODER TESTING COMPLETE: %0d failures.", failures);

        $finish;
    end

endmodule