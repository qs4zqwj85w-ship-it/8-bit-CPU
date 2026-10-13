module next_pc_tb;

    logic [7:0] pc_plus_1;
    logic [7:0] jump_target;
    logic [7:0] branch_target;
    logic [1:0] pc_src;
    logic [7:0] next_pc;

    integer failures;

    next_pc dut (
        .pc_plus_1(pc_plus_1),
        .jump_target(jump_target),
        .branch_target(branch_target),
        .pc_src(pc_src),
        .next_pc(next_pc)
    );

    task check(
        input logic [1:0] test_pc_src,
        input logic [7:0] expected_next_pc
    );

        begin
            pc_src = test_pc_src;
            #1;

            if (next_pc !== expected_next_pc) begin

                $display("FAIL:");
                $display("  pc_src     = %b", pc_src);
                $display("  next_pc    = %d (expected %d)",
                         next_pc, expected_next_pc);

                failures = failures + 1;
            end
            else begin
                $display("PASS: pc_src = %b, next_pc = %d",
                         pc_src, next_pc);
            end
        end

    endtask

    initial begin

        failures = 0;

        // Give each possible source a distinct value
        pc_plus_1     = 8'd10;
        jump_target   = 8'd20;
        branch_target = 8'd30;

        // Normal sequential PC
        check(
            2'b00,
            8'd10
        );

        // JMP
        check(
            2'b01,
            8'd20
        );

        // JZ
        check(
            2'b10,
            8'd30
        );

        // JC
        check(
            2'b11,
            8'd30
        );

        if (failures == 0)
            $display("ALL NEXT-PC TESTS PASSED.");
        else
            $display("NEXT-PC TESTING COMPLETE: %0d failures.", failures);

        $finish;

    end

endmodule