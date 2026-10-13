module next_pc(
    input  [7:0]    pc_plus_1,   // ALU result
    input  [7:0]    jump_target,
    input  [7:0]    branch_target,
    input  [1:0]    pc_src,
    output logic [7:0]    next_pc
);

always_comb begin 
    if (pc_src == 2'b00)
        next_pc = pc_plus_1;
    else if (pc_src == 2'b01)
        next_pc = jump_target;
    else if (pc_src == 2'b10)
        next_pc = branch_target;
    else
        next_pc = branch_target;

end



endmodule