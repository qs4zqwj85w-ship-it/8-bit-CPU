module writeback_tb;

    logic [7:0] alu_result;
    logic [7:0] memory_data;
    logic [7:0] immediate;
    logic [7:0] register_data;
    logic [1:0] writeback_sel;
    logic [7:0] writeback_data;

    integer failures;

    writeback dut (
        .alu_result(alu_result),
        .memory_data(memory_data),
        .immediate(immediate),
        .register_data(register_data),
        .writeback_sel(writeback_sel),
        .writeback_data(writeback_data)
    );

    task check(
        input logic [1:0] test_writeback_sel,
        input logic [7:0] expected_writeback_data
    );

        begin
            writeback_sel = test_writeback_sel;
            #1;

            if (writeback_data !== expected_writeback_data) begin

                $display("FAIL:");
                $display("  writeback_sel  = %b", writeback_sel);
                $display("  writeback_data = %d (expected %d)",
                         writeback_data, expected_writeback_data);

                failures = failures + 1;
            end
            else begin
                $display("PASS: writeback_sel = %b, writeback_data = %d",
                         writeback_sel, writeback_data);
            end
        end

    endtask

    initial begin

        failures = 0;

        // Give every possible source a different value
        alu_result    = 8'd10;
        memory_data   = 8'd20;
        immediate     = 8'd30;
        register_data = 8'd40;

        // ALU result
        check(
            2'b00,
            8'd10
        );

        // Memory data
        check(
            2'b01,
            8'd20
        );

        // Immediate
        check(
            2'b10,
            8'd30
        );

        // Register data
        check(
            2'b11,
            8'd40
        );

        if (failures == 0)
            $display("ALL WRITEBACK TESTS PASSED.");
        else
            $display("WRITEBACK TESTING COMPLETE: %0d failures.", failures);

        $finish;

    end

endmodule