module register_8bit_tb;

    logic [7:0] d;
    logic clk;
    logic en;
    logic [7:0] q;

    register_8bit dut (
        .d(d),
        .clk(clk),
        .en(en),
        .q(q)
    );

    always #5 clk = ~clk;

    initial begin
        clk = 0;
        d = 8'b00000000;
        en = 0;

        // Enable off: q should stay 0
        #7;
        d = 8'b10101010;

        // Enable on: q should capture d
        #3;
        en = 1;

        #7;
        d = 8'b11001100;

        // Disable: q should hold 10101010
        #3;
        en = 0;

        #7;
        d = 8'b11111111;

        // Enable again: q should capture 11111111
        #3;
        en = 1;

        #7;
        $finish;
    end

    always @(posedge clk) begin
        #1;
        $display("time=%0t en=%b d=%b q=%b",
                 $time, en, d, q);
    end

endmodule