
module cpu_runner_tb;

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

    initial begin
        repeat (2) @(posedge clk);
        #1 reset = 0;
    end

    
    initial begin : run_cpu
        repeat (10000) begin
            @(negedge clk);

            if (out_valid)
                $display("OUT: %0d (0x%02h)", out_data, out_data);

            if (dut.halt) begin
                $display("CPU halted.");
                disable run_cpu;
            end
        end

        $display("ERROR: Simulation timeout.");
        $finish;
    end

    final begin
        $display("Simulation finished.");
    end


endmodule
