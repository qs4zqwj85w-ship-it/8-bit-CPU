module instruction_memory (
    input  logic [7:0]  address,
    output logic [15:0] instruction
);

    logic [15:0] memory [0:255];

    initial begin

        // Fill all memory with NOP
        for (int i = 0; i < 256; i = i + 1)
            memory[i] = 16'b0000000000000000;

        $readmemb("program.mem", memory);
    end

    // Read instruction at the current address
    assign instruction = memory[address];

endmodule