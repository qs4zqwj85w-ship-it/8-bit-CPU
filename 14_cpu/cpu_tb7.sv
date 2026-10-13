
module cpu_tb7;
    logic clk;
    logic reset;

    logic [7:0] out_data;
    logic out_valid;

    logic output_seen;
    logic test_passed;

    // Instantiate the complete CPU
    cpu dut (
        .clk(clk),
        .reset(reset),
        .out_data(out_data),
        .out_valid(out_valid)
    );

    // 10 ns clock period
    always #5 clk = ~clk;

    initial begin
        clk = 0;
        reset = 1;

        output_seen = 0;
        test_passed = 0;

        // Hold reset for one clock cycle
        #10;
        reset = 0;

        // Wait for the CPU to execute the assembled program.
        // Check the OUT instruction whenever out_valid is asserted.
        repeat (30) begin
            @(posedge clk);

            // Sample after nonblocking assignments have updated.
            #1;

            if (out_valid) begin
                output_seen = 1;

                $display("CPU OUT: %0d (0x%02h)",
                         out_data, out_data);

                if (out_data == 8'd52) begin
                    $display("PASS: 42 + 10 = 52");
                    test_passed = 1;
                end
                else begin
                    $error("FAIL: Expected 52, received %0d",
                           out_data);
                end
            end
        end

        if (!output_seen) begin
            $error("FAIL: CPU never asserted out_valid");
        end
        else if (test_passed) begin
            $display("CPU TEST PASSED");
        end

        $finish;
    end

endmodule


