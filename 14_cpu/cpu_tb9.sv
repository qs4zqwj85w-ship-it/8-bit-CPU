
module cpu_tb9;

    logic clk = 0;
    logic reset = 1;
    logic [7:0] out_data;
    logic out_valid;

    cpu dut (
        .clk(clk),
        .reset(reset),
        .out_data(out_data),
        .out_valid(out_valid)
    );

    always #5 clk = ~clk;

    initial begin : test_sequence
        repeat (2) @(posedge clk);
        #1 reset = 0;

        repeat (100) begin
            @(negedge clk);

            if (out_valid) begin
                if (out_data == 8'd42)
                    $display("PASS: multiplication result = %0d", out_data);
                else
                    $display("FAIL: expected 42, got %0d", out_data);

                disable test_sequence;
            end
        end

        $display("FAIL: timeout; CPU did not produce output");
        disable test_sequence;
    end

    initial begin
        wait (out_valid);
        #1;
        $finish;
    end

endmodule
