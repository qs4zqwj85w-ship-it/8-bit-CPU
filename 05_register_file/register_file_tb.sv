module register_file_tb;

    logic       clk;
    logic       write_en;
    logic [2:0] write_addr;
    logic [7:0] write_data;
    logic [2:0] read_addr1;
    logic [7:0] read_data1;

    logic [2:0] read_addr2;
    logic [7:0] read_data2;

    register_file dut (
        .clk(clk),
        .write_en(write_en),
        .write_addr(write_addr),
        .write_data(write_data),
        .read_addr1(read_addr1),
        .read_data1(read_data1),
        .read_addr2(read_addr2),
        .read_data2(read_data2)
    );

    // Clock: 10 time units per cycle
    always #5 clk = ~clk;

    initial begin
        clk = 0;
        write_en = 0;
        write_addr = 0;
        write_data = 0;
        read_addr1 = 0;
        read_addr2 = 0;

        // Write 10101010 to register 3
        write_en = 1;
        write_addr = 3'b011;
        write_data = 8'b10101010;

        @(posedge clk);
        #1;
        write_en = 0;

        // Read register 3
        read_addr1 = 3'b011;
        read_addr2 = 3'b011;
        #1;

        $display("Read R3 through port 1: %b", read_data1);
        $display("Read R3 through port 2: %b", read_data2);

        // Write 11110000 to register 6
        write_en = 1;
        write_addr = 3'b110;
        write_data = 8'b11110000;

        @(posedge clk);
        #1;
        write_en = 0;

        // Read register 6
        // Read register 6
        read_addr1 = 3'b110;
        read_addr2 = 3'b110;
        #1;

        $display("Read R6 through port 1: %b", read_data1);
        $display("Read R6 through port 2: %b", read_data2);

        // Make sure R3 still contains its old value
        read_addr1 = 3'b011;
        read_addr2 = 3'b011;
        #1;

        $display("Read R3 again through port 1: %b", read_data1);
        $display("Read R3 again through port 2: %b", read_data2);

        // Read another register that was never written
        read_addr1 = 3'b001;
        read_addr2 = 3'b001;
        #1;

        $display("Read R1 through port 1: %b", read_data1);
        $display("Read R1 through port 2: %b", read_data2);

        $finish;
    end

endmodule