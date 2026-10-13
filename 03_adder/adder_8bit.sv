module adder_8bit (
    input  logic [7:0] a,
    input  logic [7:0] b,
    input  logic carry_in,
    output logic [7:0] sum,
    output logic carry_out
);

    logic [8:0] carry;


full_adder FA0 (
    .a(a[0]),
    .b(b[0]),
    .carry_in(carry[0]),
    .sum(sum[0]),
    .carry_out(carry[1])
);

full_adder FA1 (
    .a(a[1]),
    .b(b[1]),
    .carry_in(carry[1]),
    .sum(sum[1]),
    .carry_out(carry[2])
);

full_adder FA2 (
    .a(a[2]),
    .b(b[2]),
    .carry_in(carry[2]),
    .sum(sum[2]),
    .carry_out(carry[3])
);

full_adder FA3 (
    .a(a[3]),
    .b(b[3]),
    .carry_in(carry[3]),
    .sum(sum[3]),
    .carry_out(carry[4])
);

full_adder FA4 (
    .a(a[4]),
    .b(b[4]),
    .carry_in(carry[4]),
    .sum(sum[4]),
    .carry_out(carry[5])
);

full_adder FA5 (
    .a(a[5]),
    .b(b[5]),
    .carry_in(carry[5]),
    .sum(sum[5]),
    .carry_out(carry[6])
);

full_adder FA6 (
    .a(a[6]),
    .b(b[6]),
    .carry_in(carry[6]),
    .sum(sum[6]),
    .carry_out(carry[7])
);

full_adder FA7 (
    .a(a[7]),
    .b(b[7]),
    .carry_in(carry[7]),
    .sum(sum[7]),
    .carry_out(carry[8])
);

assign carry[0] = carry_in;
assign carry_out = carry[8];

endmodule