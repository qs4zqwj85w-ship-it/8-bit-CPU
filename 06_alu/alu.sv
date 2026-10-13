module alu(
    input  logic [7:0] a,
    input  logic [7:0] b,
    input  logic [3:0] op,
    output logic [7:0] result,
    output logic       carry_out
);

    logic sub;
    logic [7:0] arithmetic_b;
    logic [7:0] arithmetic_result;
    logic arithmetic_carry;
    logic [7:0] and_result;
    logic [7:0] or_result;
    logic [7:0] xor_result;
    logic [7:0] not_result;

    // arithmetic unit
    adder_subtractor arithmetic_unit (
        .a(a),
        .b(arithmetic_b),
        .sub(sub),
        .sum(arithmetic_result),
        .carry_out(arithmetic_carry)
    );

    // Decide whether the arithmetic unit should ADD or SUB
    always_comb begin
    // defaults
    arithmetic_b = b;
    sub = 1'b0;


    case (op)
        4'b0000: begin
            // ADD: A + B
            arithmetic_b = b;
            sub = 1'b0;
        end

        4'b0001: begin
            // SUB: A - B
            arithmetic_b = b;
            sub = 1'b1;
        end

        4'b0111: begin
            // INC: A + 1
            arithmetic_b = 8'b00000001;
            sub = 1'b0;
        end

        4'b1000: begin
            // DEC: A - 1
            arithmetic_b = 8'b00000001;
            sub = 1'b1;
        end
        default: begin
        arithmetic_b = b;
        sub = 1'b0;
        end

    endcase
end

    assign and_result = a & b;
    assign or_result = a | b;
    assign xor_result = a ^ b;
    assign not_result = ~a;
    



    // Decide what the ALU output should be
    always_comb begin
        // garantee the result have smt to hold so it stays stable
        result = 8'b00000000;
        carry_out = 1'b0;

        case (op)
            4'b0000: begin result = arithmetic_result; carry_out = arithmetic_carry; end // ADD
            4'b0001: begin result = arithmetic_result; carry_out = arithmetic_carry; end // SUB
            4'b0010: result = and_result; 
            4'b0011: result = or_result; 
            4'b0100: result = xor_result; 
            4'b0101: result = not_result; 
            4'b0110: result = 0; 
            4'b0111: begin result = arithmetic_result; carry_out = arithmetic_carry; end
            4'b1000: begin result = arithmetic_result; carry_out = arithmetic_carry; end
            

            default: result = 8'b00000000;
        endcase
    end

endmodule