module mux_tb;

    logic a;
    logic b;
    logic sel;
    logic y;

    mux dut (
        .a(a),
        .b(b),
        .y(y),
        .sel(sel)
    );

    initial begin
        a = 1;
        b = 0;
        sel = 0;
        #10;
        $display("a=%b b=%b sel=%b y=%b", a, b, sel, y);

        a = 1;
        b = 0;
        sel = 1;
        #10;
        $display("a=%b b=%b sel=%b y=%b", a, b, sel, y);


        $finish;
    end

endmodule