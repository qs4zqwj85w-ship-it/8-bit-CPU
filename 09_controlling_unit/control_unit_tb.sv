
module control_unit_tb;

    logic [3:0] opcode;
    logic [3:0] alu_op;
    logic       reg_write;
    logic       mem_read;
    logic       mem_write;
    logic [1:0] writeback_sel;
    logic [1:0] pc_src;
    logic       out_write;
    logic       halt;
    logic       flag_write;
    integer     failures;

control_unit dut (
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

task check(
    input logic [3:0] test_opcode,
    input logic [3:0] expected_alu_op,
    input logic       expected_reg_write,
    input logic       expected_mem_read,
    input logic       expected_mem_write,
    input logic [1:0] expected_writeback_sel,
    input logic [1:0] expected_pc_src,
    input logic       expected_out_write,
    input logic       expected_halt,
    input logic       expected_flag_write
);

    begin
        opcode = test_opcode;
        #1;

        if (alu_op !== expected_alu_op ||
            reg_write !== expected_reg_write ||
            mem_read !== expected_mem_read ||
            mem_write !== expected_mem_write ||
            writeback_sel !== expected_writeback_sel ||
            pc_src !== expected_pc_src ||
            out_write !== expected_out_write ||
            halt !== expected_halt ||
            flag_write !== expected_flag_write) begin

            $display("FAIL:");
            $display("  opcode        = %b", opcode);
            $display("  alu_op        = %b (expected %b)", alu_op, expected_alu_op);
            $display("  reg_write     = %b (expected %b)", reg_write, expected_reg_write);
            $display("  mem_read      = %b (expected %b)", mem_read, expected_mem_read);
            $display("  mem_write     = %b (expected %b)", mem_write, expected_mem_write);
            $display("  writeback_sel = %b (expected %b)", writeback_sel, expected_writeback_sel);
            $display("  pc_src        = %b (expected %b)", pc_src, expected_pc_src);
            $display("  out_write     = %b (expected %b)", out_write, expected_out_write);
            $display("  halt          = %b (expected %b)", halt, expected_halt);
            $display("  flag_write    = %b (expected %b)", flag_write, expected_flag_write);

            failures = failures + 1;
        end
        else begin
            $display("PASS: opcode = %b", opcode);
        end
    end

endtask

initial begin

    failures = 0;

    check(
        4'b0001,
        4'b0000,
        1'b1,
        1'b0,
        1'b0,
        2'b00,
        2'b00,
        1'b0,
        1'b0,
        1'b1
    );

    if (failures == 0)
        $display("ALL CONTROL UNIT TESTS PASSED.");
    else
        $display("CONTROL UNIT TESTING COMPLETE: %0d failures.", failures);

    $finish;

end

endmodule