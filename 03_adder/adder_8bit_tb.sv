module adder_8bit_tb;

    logic [7:0] a;
    logic [7:0] b;
    logic carry_in;
    logic [7:0] sum;
    logic carry_out;

    logic [8:0] expected;

    adder_8bit dut (
        .a(a),
        .b(b),
        .carry_in(carry_in),
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
                    carry_in = k[0];

                    #1;

                    expected = a + b + carry_in;

                    if ({carry_out, sum} != expected)
                        $display("FAIL: a=%d b=%d carry_in=%b sum=%d carry_out=%b expected=%d",
                                 a, b, carry_in, sum, carry_out, expected);

                end
            end
        end

        $display("Testing complete.");
        $finish;
    end

endmodule