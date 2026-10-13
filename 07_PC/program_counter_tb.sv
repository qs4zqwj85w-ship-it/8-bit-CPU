module program_counter_tb;

    logic       clk;
    logic       reset;
    logic       enable;
    logic [7:0] next_pc;
    logic [7:0] pc;

    program_counter dut (
        .clk(clk),
        .reset(reset),
        .enable(enable),
        .next_pc(next_pc),
        .pc(pc)
    );

    // 10 time-unit clock
    always #5 clk = ~clk;

    initial begin
        // Initial values
        clk = 0;
        reset = 1;
        enable = 0;
        next_pc = 0;

        // Reset: PC should become 0
        @(posedge clk);
        #1;
        $display("Reset:    reset=%b enable=%b next_pc=%d pc=%d",
                 reset, enable, next_pc, pc);

        // Load 10 into PC
        reset = 0;
        enable = 1;
        next_pc = 10;

        @(posedge clk);
        #1;
        $display("Load 10:  reset=%b enable=%b next_pc=%d pc=%d",
                 reset, enable, next_pc, pc);

        // Load 25 into PC
        next_pc = 25;

        @(posedge clk);
        #1;
        $display("Load 25:  reset=%b enable=%b next_pc=%d pc=%d",
                 reset, enable, next_pc, pc);

        // Disable: PC should hold 25
        enable = 0;
        next_pc = 100;

        @(posedge clk);
        #1;
        $display("Hold:     reset=%b enable=%b next_pc=%d pc=%d",
                 reset, enable, next_pc, pc);

        // Reset should override enable
        reset = 1;
        enable = 1;
        next_pc = 200;

        @(posedge clk);
        #1;
        $display("Priority: reset=%b enable=%b next_pc=%d pc=%d",
                 reset, enable, next_pc, pc);

        $finish;
    end

endmodule