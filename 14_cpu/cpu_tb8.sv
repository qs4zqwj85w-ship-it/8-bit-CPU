
module cpu_tb8;
    logic clk;
    logic reset;

    logic [7:0] out_data;
    logic out_valid;

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

        // Hold reset, then start the CPU
        #10;
        reset = 0;

        // Allow enough time for the program to execute
        repeat (20) @(posedge clk);
        #1;

        // Check that HLT was reached
        if (dut.halt !== 1'b1) begin
            $error("FAIL: CPU did not reach HLT");
            $finish;
        end

        // Check that the PC stopped advancing
        begin
            logic [7:0] halted_pc;
            halted_pc = dut.pc_current;

            repeat (5) @(posedge clk);
            #1;

            if (dut.pc_current !== halted_pc) begin
                $error("FAIL: PC changed after HLT");
            end
            else begin
                $display("PASS: PC remains at %0d after HLT",
                         halted_pc);
            end
        end

        $finish;
    end
endmodule
