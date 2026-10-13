module program_counter (
    input  logic       clk,
    input  logic       reset,
    input  logic       enable,
    input  logic [7:0] next_pc,
    output logic [7:0] pc
);

    always_ff @(posedge clk) begin
        if (reset)            
                pc <= 0;
        else
            if (enable)
                pc <= next_pc;
            else
                pc <= pc;
    end

endmodule