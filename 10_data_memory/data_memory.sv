module data_memory (
    input  logic [7:0] address,
    input  logic [7:0] write_data,
    input  logic       mem_read,
    input  logic       mem_write,
    input  logic       clk,

    output logic [7:0] read_data
);

    logic [7:0] memory [0:255];

    always_ff @(posedge clk) begin
        if (mem_write)
            memory[address] <= write_data;
    end

    assign read_data = mem_read ? memory[address] : 8'b0;


endmodule




