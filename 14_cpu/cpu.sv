module cpu (
    input logic clk,
    input logic reset,
    output logic [7:0] out_data,
    output logic       out_valid    
);



logic [7:0]  pc_current;
logic [7:0]  pc_next;

logic [15:0] instruction;

logic [3:0] opcode;
logic [2:0] rd;
logic [2:0] rs1;
logic [2:0] rs2;
logic [7:0] immediate;
logic [7:0] address;

logic [3:0] alu_op;
logic       reg_write;
logic       mem_read;
logic       mem_write;
logic [1:0] writeback_sel;
logic [1:0] pc_src;
logic       out_write;
logic       halt;

logic [7:0] reg_data1;
logic [7:0] reg_data2;
logic [7:0] writeback_data;

logic [7:0] alu_result;
logic       alu_carry;
logic alu_zero;

logic zero_flag;
logic carry_flag;
logic current_carry;
logic flag_write;

logic [7:0] memory_data;

logic [7:0] pc_plus_1;
logic [7:0] jump_target;
logic [7:0] branch_target;

logic [1:0] effective_pc_src;


program_counter pc_unit (
    .clk(clk),
    .reset(reset),
    .enable(!halt),
    .next_pc(pc_next),
    .pc(pc_current)
);

instruction_memory imem (
    .address(pc_current),
    .instruction(instruction)
);

instruction_decoder decoder (
    .instruction(instruction),
    .opcode(opcode),
    .rd(rd),
    .rs1(rs1),
    .rs2(rs2),
    .immediate(immediate),
    .address(address)
);

control_unit control (
    .opcode(opcode),
    .alu_op(alu_op),
    .reg_write(reg_write),
    .mem_read(mem_read),
    .mem_write(mem_write),
    .writeback_sel(writeback_sel),
    .pc_src(pc_src),
    .out_write(out_write),
    .halt(halt),
    .flag_write(flag_write)
);

register_file regs (
    .clk(clk),
    .write_en(reg_write),
    .write_addr(rd),
    .write_data(writeback_data),
    .read_addr1(rs1),
    .read_data1(reg_data1),
    .read_addr2(rs2),
    .read_data2(reg_data2)
);

alu alu_unit (
    .a(reg_data1),
    .b(reg_data2),
    .op(alu_op),
    .result(alu_result),
    .carry_out(alu_carry)
);


flag flags (
    .result(alu_result),
    .carry_out(alu_carry),
    .zero(alu_zero),
    .carry(current_carry)
);

data_memory data_mem (
    .clk(clk),
    .address(address),
    .write_data(reg_data1),
    .mem_read(mem_read),
    .mem_write(mem_write),
    .read_data(memory_data)
);

writeback wb (
    .alu_result(alu_result),
    .memory_data(memory_data),
    .immediate(immediate),
    .register_data(reg_data1),
    .writeback_sel(writeback_sel),
    .writeback_data(writeback_data)
);

assign pc_plus_1    = pc_current + 1;
assign jump_target  = address;
assign branch_target = address;


next_pc nextpc(
    .pc_plus_1(pc_plus_1),
    .jump_target(jump_target),
    .branch_target(branch_target),
    .pc_src(effective_pc_src),
    .next_pc(pc_next)
);

always_ff @(posedge clk) begin
    if (reset) begin
        zero_flag  <= 1'b0;
        carry_flag <= 1'b0;
    end
    else if (flag_write) begin
        zero_flag  <= alu_zero;
        carry_flag <= current_carry;
    end
end

always_comb begin

    effective_pc_src = 2'b00;

    if (pc_src == 2'b01)
        effective_pc_src = 2'b01;

    else if (pc_src == 2'b10 && zero_flag)
        effective_pc_src = 2'b10;
    
    else if (pc_src == 2'b10 && !zero_flag)
        effective_pc_src = 2'b00;

    else if (pc_src == 2'b11 && carry_flag)
        effective_pc_src = 2'b11;

    else if (pc_src == 2'b11 && !carry_flag)
        effective_pc_src = 2'b00;

end


always_ff @(posedge clk) begin
    if (reset) begin
        out_data  <= 8'b0;
        out_valid <= 1'b0;
    end
    else begin
        out_valid <= 1'b0;

        if (out_write) begin
            out_data  <= reg_data1;
            out_valid <= 1'b1;
        end
    end
end

endmodule