

module Top 
#(
    parameter DATA_WIDTH = 32
) 
(
    input clk, rst,

    // ---------------------------------------------------- Inputs
    input logic [DATA_WIDTH - 1:0] A_in, B_in_11, B_in_12,
    input logic A_in_finished, B_in_finished_11, B_in_finished_12,
    input logic A_in_waiting, B_in_waiting_11, B_in_waiting_12,
    input logic A_out_ready, B_out_ready_11, B_out_ready_12,
    
    // ---------------------------------------------------- Outputs
    output logic [DATA_WIDTH - 1:0] A_out, B_out_11, B_out_12, C_out_11, C_out_12,
    output logic A_in_ready, B_in_ready_11, B_in_ready_12,
    output logic A_out_waiting, B_out_waiting_11, B_out_waiting_12,
    output logic A_out_finished, B_out_finished_11, B_out_finished_12
);

    logic [DATA_WIDTH - 1: 0] A_11_12;
    logic A_ready_11_12; 
    logic A_waiting_11_12;
    logic A_finished_11_12;

    MACV2 #(
        .DATA_WIDTH(DATA_WIDTH)
    ) MACV2_11 (
        .clk(clk),
        .rst(rst),
        .A_in(A_in),
        .B_in(B_in_11),
        .A_in_finished(A_in_finished),
        .B_in_finished(B_in_finished_11),
        .A_in_waiting(A_in_waiting),
        .B_in_waiting(B_in_waiting_11),
        .A_out_ready(A_ready_11_12),
        .B_out_ready(B_out_ready_11),
        .A_out(A_11_12),
        .B_out(B_out_11),
        .C_out(C_out_11),
        .A_in_ready(A_in_ready),
        .B_in_ready(B_in_ready_11),
        .A_out_waiting(A_waiting_11_12),
        .B_out_waiting(B_out_waiting_11),
        .A_out_finished(A_finished_11_12),
        .B_out_finished(B_out_finished_11)
    );
    
    MACV2 #(
        .DATA_WIDTH(DATA_WIDTH)
    ) MACV2_12 (
        .clk(clk),
        .rst(rst),
        .A_in(A_11_12),
        .B_in(B_in_12),
        .A_in_finished(A_finished_11_12),
        .B_in_finished(B_in_finished_12),
        .A_in_waiting(A_waiting_11_12),
        .B_in_waiting(B_in_waiting_12),
        .A_out_ready(A_out_ready),
        .B_out_ready(B_out_ready_12),
        .A_out(A_out),
        .B_out(B_out_12),
        .C_out(C_out_12),
        .A_in_ready(A_ready_11_12),
        .B_in_ready(B_in_ready_12),
        .A_out_waiting(A_out_waiting),
        .B_out_waiting(B_out_waiting_12),
        .A_out_finished(A_out_finished),
        .B_out_finished(B_out_finished_12)
    );
    


    // ---------------------------------------------------- Tracing
    initial begin
        $display("[%0t] Tracing to logs/vlt_dump.vcd...\n", $time);
        $dumpfile("logs/macv2_dump.vcd");
        $dumpvars();
        $display("[%0t] Model running...\n", $time);
    end
endmodule
