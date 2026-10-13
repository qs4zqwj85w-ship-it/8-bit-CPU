module full_adder (
    input  logic a,
    input  logic b,
    input  logic carry_in,
    output logic sum,
    output logic carry_out
);

    logic sum1;
    logic carry1;
    logic carry2;

    // First half adder
    assign sum1 = a ^ b;
    assign carry1 = a & b;

    // Second half adder
    assign sum = sum1 ^ carry_in;
    assign carry2 = sum1 & carry_in;

    // Combine the carries
    assign carry_out = carry1 | carry2;

endmodule