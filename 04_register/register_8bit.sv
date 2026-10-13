module register_8bit (
    input  logic [7:0] d,
    input  logic clk,
    input  logic en,
    output logic [7:0] q
);

    logic [7:0] stored;

    always_ff @(posedge clk) begin
        if (en)
            stored <= d;
    end

    assign q = stored;

endmodule