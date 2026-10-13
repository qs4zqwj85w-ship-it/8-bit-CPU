module writeback(
    input logic [7:0] alu_result,
    input logic [7:0] memory_data,
    input logic [7:0] immediate,
    input logic [7:0] register_data,
    input logic [1:0] writeback_sel,
    output logic [7:0] writeback_data
);

always_comb begin 
    if (writeback_sel == 2'b00)
        writeback_data = alu_result;
    else if (writeback_sel == 2'b01)
        writeback_data = memory_data;
    else if (writeback_sel == 2'b10)
        writeback_data = immediate;
    else
        writeback_data = register_data;

end



endmodule