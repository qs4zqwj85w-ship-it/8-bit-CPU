module cpu_tb;

    logic clk;
    logic reset;

    cpu dut (
        .clk(clk),
        .reset(reset)
    );

    // 10 time units per clock cycle
    always #5 clk = ~clk;

    initial begin

        clk = 0;
        reset = 1;

        // First clock: reset the CPU
        @(posedge clk);
        #1;

        if (dut.pc_current !== 8'd0)
            $display("FAIL: PC did not reset to 0. PC = %d", dut.pc_current);
        else
            $display("PASS: PC reset to 0");

        // Release reset
        reset = 0;

        // Force instruction to NOP
        // This lets us test the CPU datapath without depending
        // on the current contents of instruction memory.
        force dut.instruction = 16'b0000000000000000;

        // First NOP
        @(posedge clk);
        #1;

        if (dut.pc_current !== 8'd1)
            $display("FAIL: PC should be 1. PC = %d", dut.pc_current);
        else
            $display("PASS: PC advanced to 1");

        // Second NOP
        @(posedge clk);
        #1;

        if (dut.pc_current !== 8'd2)
            $display("FAIL: PC should be 2. PC = %d", dut.pc_current);
        else
            $display("PASS: PC advanced to 2");

        // Third NOP
        @(posedge clk);
        #1;

        if (dut.pc_current !== 8'd3)
            $display("FAIL: PC should be 3. PC = %d", dut.pc_current);
        else
            $display("PASS: PC advanced to 3");

        release dut.instruction;

        $finish;

    end

endmodule