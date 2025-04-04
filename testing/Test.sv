

module Test
(
    input clk,
    input rst,

    input [DATA_WIDTH - 1:0] A_in, B_in,

    output reg [DATA_WIDTH * (N * M) - 1:0] C_out
);
    localparam DATA_WIDTH = 32, N = 3, M = 3;
    
    wire [DATA_WIDTH - 1:0] A_pipe [N * M - 1:0], B_pipe [N * M - 1:0];
    reg [DATA_WIDTH - 1:0] C_reg [N * M - 1:0], A_reg [N - 1:0], B_reg[N - 1:0];

    genvar i, j;
    generate
        for (i = 0; i < N; i = i + 1) begin : MAC_rows
            for (j = 0; j < M; j = j + 1) begin : MAC_cols
                test_mac #(
                    .DATA_WIDTH(DATA_WIDTH)
                ) tm_int (
                    .clk(clk),
                    .rst(rst),
                    .A_in(j == 0 ? A_in : A_pipe[N*i + j - 1] ),
                    .B_in(i == 0 ? B_in : B_pipe[(N * i - 1) + j]),
                    .A_out(A_pipe[N * i + j]),
                    .B_out(B_pipe[N * i + j]),
                    .C_out(C_reg[N * i + j])
                );

                if ((N * i + j) == (N * i + (M - 1))) assign A_reg[i] = A_pipe[N * i + (M - 1)];
                if ((N * i + j) == (N * (N - 1) + j)) assign B_reg[j] = B_pipe[N * (N - 1) + j];
            end
        end
    endgenerate


    genvar k;
    generate
        for (k = 0; k < N * M; k = k + 1) begin
            assign C_out [DATA_WIDTH*(k + 1) - 1 : DATA_WIDTH * (k + 1) - DATA_WIDTH] = C_reg[k]; 
        end
    endgenerate
    

// ---------------------------------------------------- Tracing
initial begin
    $display("[%0t] Tracing to logs/vlt_dump.vcd...\n", $time);
    $dumpfile("logs/top_dump.vcd");
    $dumpvars();
    $display("[%0t] Model running...\n", $time);
end
endmodule
