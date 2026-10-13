module instruction_decoder (
    input  logic [15:0] instruction,
    output logic [3:0] opcode,
    output logic [2:0] rd,
    output logic [2:0] rs1,
    output logic [2:0] rs2,
    output logic [7:0] immediate,
    output logic [7:0] address

);

    assign opcode = instruction[15:12];
    always_comb begin
        rd        = 3'b000;
        rs1       = 3'b000;
        rs2       = 3'b000;
        immediate = 8'b00000000;
        address   = 8'b00000000;


        case(opcode)
            4'b0001, 4'b0010, 4'b0011, 4'b0100, 4'b0101: begin
                rd = instruction[11:9];
                rs1 = instruction[8:6];
                rs2 = instruction[5:3];
            end

            4'b0110, 4'b1101: begin
                rd  = instruction[11:9];
                rs1 = instruction[8:6];
            end

            // Immediate: LDI
            4'b0111: begin
                rd        = instruction[11:9];
                immediate = instruction[8:1];
            end

            // Memory: LD
            4'b1000: begin
                rd      = instruction[11:9];
                address = instruction[8:1];
            end

            // Memory: ST
            4'b1001: begin
                rs1     = instruction[11:9];
                address = instruction[8:1];
            end

            // Control flow: JMP, JZ, JC
            4'b1010, 4'b1011, 4'b1100: begin
                address = instruction[11:4];
            end

            // OUT
            4'b1110: begin
                rs1 = instruction[11:9];
            end

            // NOP, HLT
            4'b0000, 4'b1111: begin
                // No operands
            end

            default: begin
                // Defaults already applied
            end

        endcase
    end

endmodule
        
