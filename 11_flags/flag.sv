module flag(
    input  [7:0]    result,   // ALU result
    input           carry_out,
    output logic    zero,
    output logic    carry
);

always_comb begin 
    if (result == 8'b00000000)
        zero = 1'b1;
    else
        zero = 1'b0;

end

    assign carry = carry_out;


endmodule