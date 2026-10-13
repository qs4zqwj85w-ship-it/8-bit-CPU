module d_flip_flop_tb;

    logic d;
    logic clk;
    logic en;
    logic q;

    d_flip_flop dut (
        .d(d),
        .clk(clk),
        .en(en),
        .q(q)
    );

    always #5 clk = ~clk;

    initial begin
        clk = 0;
        d = 0;
        en = 0;

        // en = 0: q should NOT change
        #7;
        d = 1;

        // en = 1: q should capture d at next rising edge
        #3;
        en = 1;

        #7;
        d = 0;

        // en = 0: q should hold its current value
        #3;
        en = 0;

        #7;
        d = 1;

        // en = 1: q should capture d again
        #3;
        en = 1;

        #7;
        $finish;
    end

    always @(posedge clk) begin
        #1;
        $display("time=%0t clk=%b en=%b d=%b q=%b",
                 $time, clk, en, d, q);
    end

endmodule