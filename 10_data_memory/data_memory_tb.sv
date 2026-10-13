module data_memory_tb;

    logic       clk;
    logic [7:0] address;
    logic [7:0] write_data;
    logic       mem_read;
    logic       mem_write;
    logic [7:0] read_data;

    data_memory dut (
        .clk(clk),
        .address(address),
        .write_data(write_data),
        .mem_read(mem_read),
        .mem_write(mem_write),
        .read_data(read_data)
    );


    always #5 clk = ~clk;

    initial begin
        address    = 8'd10;
        write_data = 8'd42;
        mem_write  = 1;

        @(posedge clk);
   
        #1;
        mem_write = 0;
        mem_read = 1;
        address    = 8'd10;

        #1;
        $display("read_data = %d", read_data);

        $finish;
    end

endmodule