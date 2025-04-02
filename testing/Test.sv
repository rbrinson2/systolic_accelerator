

module Test(
    input clk,
    input rst,

    input logic [31:0] A_in, B_in,

    output logic [31:0] A_out, B_out, C_out_1, C_out_2
);
   
    logic [31:0] A, B;

test_mac #(
    .DATA_WIDTH(32)
) tm_1 (
    .clk(clk),
    .rst(rst),
    .A_in(A_in),
    .B_in(B_in),
    .A_out(A),
    .B_out(B),
    .C_out(C_out_1)
);


test_mac #(
    .DATA_WIDTH(32)
) tm_2 (
    .clk(clk),
    .rst(rst),
    .A_in(A),
    .B_in(B),
    .A_out(A_out),
    .B_out(B_out),
    .C_out(C_out_2)
);


// ---------------------------------------------------- Tracing
initial begin
    $display("[%0t] Tracing to logs/vlt_dump.vcd...\n", $time);
    $dumpfile("logs/top_dump.vcd");
    $dumpvars();
    $display("[%0t] Model running...\n", $time);
end
endmodule
