module register_file (
    input  logic       clk,

    input  logic       write_en,
    input  logic [2:0] write_addr,
    input  logic [7:0] write_data,

    input  logic [2:0] read_addr1,
    output logic [7:0] read_data1,

    input  logic [2:0] read_addr2,
    output logic [7:0] read_data2
);

    logic [7:0] registers [0:7];

    always_ff @(posedge clk) begin
        if (write_en)
            registers[write_addr] <= write_data;
    end

    assign read_data1 = registers[read_addr1];
    assign read_data2 = registers[read_addr2];

endmodule