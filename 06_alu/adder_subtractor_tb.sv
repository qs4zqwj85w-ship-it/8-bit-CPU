module adder_subtractor_tb;

    logic [7:0] a;
    logic [7:0] b;
    logic sub;
    logic [7:0] sum;
    logic carry_out;

    logic [7:0] expected;

    adder_subtractor dut (
        .a(a),
        .b(b),
        .sub(sub),
        .sum(sum),
        .carry_out(carry_out)
    );

    integer i;
    integer j;
    integer k;

    initial begin

        for (i = 0; i < 256; i = i + 1) begin
            for (j = 0; j < 256; j = j + 1) begin
                for (k = 0; k < 2; k = k + 1) begin

                    a = i[7:0];
                    b = j[7:0];
                    sub = k[0];

                    #1;


                    if (sub)
                        expected = a - b;
                    else
                        expected = a + b;
        

                    if (sum != expected)
                        $display("FAIL: a=%d b=%d sub=%b sum=%d carry_out=%b expected=%d",
                                 a, b, sub, sum, carry_out, expected);

                end
            end
        end

        $display("Testing complete.");
        $finish;
    end

endmodule