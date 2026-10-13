module control_unit (
    input  logic [3:0] opcode,

    output logic [3:0] alu_op,
    output logic       reg_write,
    output logic       mem_read,
    output logic       mem_write,
    output logic [1:0] writeback_sel,
    output logic [1:0] pc_src,
    output logic       out_write,
    output logic       halt,
    output logic       flag_write
);


    always_comb begin

        // Default values
        alu_op        = 4'b0000;
        reg_write     = 1'b0;
        mem_read      = 1'b0;
        mem_write     = 1'b0;
        writeback_sel = 2'b00;
        pc_src        = 2'b00;
        out_write     = 1'b0;
        halt          = 1'b0;
        flag_write    = 1'b0;

        case (opcode)

            // NOP
            4'b0000: begin
                // skip
            end

            // ADD
            4'b0001: begin
                alu_op        = 4'b0000;
                reg_write     = 1'b1;
                writeback_sel = 2'b00;
                flag_write = 1'b1;
            end

            // SUB
            4'b0010: begin
                alu_op        = 4'b0001;
                reg_write     = 1'b1;
                writeback_sel = 2'b00;
                flag_write = 1'b1;
            end

            // AND
            4'b0011: begin
                alu_op        = 4'b0010;
                reg_write     = 1'b1;
                writeback_sel = 2'b00;
                flag_write = 1'b1;
            end

            // OR
            4'b0100: begin
                alu_op        = 4'b0011;
                reg_write     = 1'b1;
                writeback_sel = 2'b00;
                flag_write = 1'b1;
            end

            // XOR
            4'b0101: begin
                alu_op        = 4'b0100;
                reg_write     = 1'b1;
                writeback_sel = 2'b00;
                flag_write = 1'b1;
            end

            // NOT
            4'b0110: begin
                alu_op        = 4'b0101;
                reg_write     = 1'b1;
                writeback_sel = 2'b00;
                flag_write = 1'b1;
            end

            // LDI
            4'b0111: begin
                reg_write     = 1'b1;
                writeback_sel = 2'b10;
                
            end

            // LD
            4'b1000: begin
                mem_read      = 1'b1;
                reg_write     = 1'b1;
                writeback_sel = 2'b01;
            end

            // ST
            4'b1001: begin
                mem_write = 1'b1;
            end

            // JMP
            4'b1010: begin
                pc_src = 2'b01;
            end

            // JZ
            4'b1011: begin
                pc_src = 2'b10;
            end

            // JC
            4'b1100: begin
                pc_src = 2'b11;
            end

            // MOV
            4'b1101: begin
                reg_write     = 1'b1;
                writeback_sel = 2'b11;
            end

            // OUT
            4'b1110: begin
                out_write = 1'b1;
            end

            // HLT
            4'b1111: begin
                halt = 1'b1;
            end

            default: begin
                // Keep defaults
            end

        endcase
    end

endmodule