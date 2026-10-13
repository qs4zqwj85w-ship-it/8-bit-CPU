module flag_tb;

    logic [7:0] result;
    logic       carry_out;
    logic       zero;
    logic       carry;

    integer failures;

    flag dut (
        .result(result),
        .carry_out(carry_out),
        .zero(zero),
        .carry(carry)
    );

    task check(
        input logic [7:0] test_result,
        input logic       test_carry_out,
        input logic       expected_zero,
        input logic       expected_carry
    );

        begin
            result = test_result;
            carry_out = test_carry_out;
            #1;

            if (zero !== expected_zero ||
                carry !== expected_carry) begin

                $display("FAIL:");
                $display("  result     = %b", result);
                $display("  carry_out  = %b", carry_out);
                $display("  zero       = %b (expected %b)",
                         zero, expected_zero);
                $display("  carry      = %b (expected %b)",
                         carry, expected_carry);

                failures = failures + 1;
            end
            else begin
                $display("PASS: result = %b, carry_out = %b",
                         result, carry_out);
            end
        end

    endtask

    initial begin

        failures = 0;

        // Zero result, no carry
        check(
            8'b00000000,
            1'b0,
            1'b1,
            1'b0
        );

        // Nonzero result, no carry
        check(
            8'b00000001,
            1'b0,
            1'b0,
            1'b0
        );

        // Zero result, carry
        check(
            8'b00000000,
            1'b1,
            1'b1,
            1'b1
        );

        // Nonzero result, carry
        check(
            8'b00000001,
            1'b1,
            1'b0,
            1'b1
        );

        if (failures == 0)
            $display("ALL FLAG TESTS PASSED.");
        else
            $display("FLAG TESTING COMPLETE: %0d failures.", failures);

        $finish;

    end

endmodule