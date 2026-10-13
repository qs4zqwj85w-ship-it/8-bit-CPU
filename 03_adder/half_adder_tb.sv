module full_adder_tb;

    logic a;
    logic b;
    logic carry_in;
    logic sum;
    logic carry_out;

    full_adder dut (
        .a(a),
        .b(b),
        .carry_in(carry_in),
        .sum(sum),
        .carry_out(carry_out)
        
    );

    initial begin
        a = 0;
        b = 0;
        carry_in = 0; 
        #10;
        $display("a=%b b=%b carry_in=%b sum=%b carry_out=%b",
         a, b, carry_in, sum, carry_out);

        a = 1;
        b = 0;
        carry_in = 0; 
        #10;
        $display("a=%b b=%b carry_in=%b sum=%b carry_out=%b",
         a, b, carry_in, sum, carry_out);

        a = 0;
        b = 1;
        carry_in = 0; 
        #10;
        $display("a=%b b=%b carry_in=%b sum=%b carry_out=%b",
         a, b, carry_in, sum, carry_out);


        a = 1;
        b = 1;
        carry_in = 0; 
        #10;
        $display("a=%b b=%b carry_in=%b sum=%b carry_out=%b",
         a, b, carry_in, sum, carry_out);

        a = 0;
        b = 0;
        carry_in = 1; 
        #10;
        $display("a=%b b=%b carry_in=%b sum=%b carry_out=%b",
         a, b, carry_in, sum, carry_out);


        a = 1;
        b = 0;
        carry_in = 1; 
        #10;
        $display("a=%b b=%b carry_in=%b sum=%b carry_out=%b",
         a, b, carry_in, sum, carry_out);

        a = 0;
        b = 1;
        carry_in = 1; 
        #10;
        $display("a=%b b=%b carry_in=%b sum=%b carry_out=%b",
         a, b, carry_in, sum, carry_out);

        a = 1;
        b = 1;
        carry_in = 1; 
        #10;
        $display("a=%b b=%b carry_in=%b sum=%b carry_out=%b",
         a, b, carry_in, sum, carry_out);


        $finish;
    end

endmodule