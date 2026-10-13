module alu_tb;

    logic [7:0] a;
    logic [7:0] b;
    logic [3:0] op;
    logic [7:0] result;
    logic [7:0] expected;

    logic       carry_out;
    logic       expected_carry;

    integer i;
    integer j;
    integer k;
    integer failures;

    alu dut (
        .a(a),
        .b(b),
        .op(op),
        .result(result),
        .carry_out(carry_out)
    );

    initial begin
        failures = 0;

        // Test all 9 valid operations
        for (k = 0; k < 9; k = k + 1) begin
            for (i = 0; i < 256; i = i + 1) begin
                for (j = 0; j < 256; j = j + 1) begin

                    a = i[7:0];
                    b = j[7:0];
                    op = k[3:0];

                    #1;

                    expected = 8'b00000000;
                    expected_carry = 1'b0;

                    case (op)
                        4'b0000: begin
                            expected = a + b;
                            expected_carry = ((a + b) > 255);
                        end

                        4'b0001: begin
                            expected = a - b;
                            // We'll verify SUB carry separately
                        end

                        4'b0010: expected = a & b;
                        4'b0011: expected = a | b;
                        4'b0100: expected = a ^ b;
                        4'b0101: expected = ~a;
                        4'b0110: expected = 8'b00000000;

                        4'b0111: begin
                            expected = a + 1;
                            expected_carry = (a == 8'hFF);
                        end

                        4'b1000: begin
                            expected = a - 1;
                            // We'll verify DEC carry separately
                        end

                        default: begin
                            expected = 8'b00000000;
                        end
                    endcase

                    if (result != expected) begin
                        $display(
                            "FAIL RESULT: a=%d b=%d op=%b result=%d expected=%d",
                            a, b, op, result, expected
                        );

                        failures = failures + 1;
                    end

                    // Check carry for ADD and INC
                    if (op == 4'b0000 || op == 4'b0111) begin
                        if (carry_out != expected_carry) begin
                            $display(
                                "FAIL CARRY: a=%d b=%d op=%b carry=%b expected=%b",
                                a, b, op, carry_out, expected_carry
                            );

                            failures = failures + 1;
                        end
                    end

                    // Logical operations and CLR should have no carry
                    if (op == 4'b0010 ||
                        op == 4'b0011 ||
                        op == 4'b0100 ||
                        op == 4'b0101 ||
                        op == 4'b0110) begin

                        if (carry_out != 1'b0) begin
                            $display(
                                "FAIL CARRY: a=%d b=%d op=%b carry=%b expected=0",
                                a, b, op, carry_out
                            );

                            failures = failures + 1;
                        end
                    end

                end
            end
        end

        // Test unused opcodes
        for (k = 9; k < 16; k = k + 1) begin
            op = k[3:0];
            a = 8'b10101010;
            b = 8'b01010101;

            #1;

            if (result != 8'b00000000) begin
                $display(
                    "FAIL: unused op=%b result=%d expected=0",
                    op, result
                );

                failures = failures + 1;
            end

            if (carry_out != 1'b0) begin
                $display(
                    "FAIL: unused op=%b carry=%b expected=0",
                    op, carry_out
                );

                failures = failures + 1;
            end
        end

        if (failures == 0)
            $display("ALL ALU TESTS PASSED.");
        else
            $display("TESTING COMPLETE: %0d failures.", failures);

        $finish;
    end

endmodule