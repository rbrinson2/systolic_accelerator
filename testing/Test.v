

module Test
(
    input clk,
    input rst,


    // ----------------------------------------------------- Module Inputs
    input finished,
    input [DATA_WIDTH - 1:0] A_in, A_in_1, A_in_2, B_in, B_in_1, B_in_2,

    // ----------------------------------------------------- Module OUtputs
    output [2:0] A_read_en, B_read_en,
    output C_write_en,
    output load_out

);

    // ----------------------------------------------------- Local params
    localparam DATA_WIDTH = 32, N = 3, M = 3;

    // ----------------------------------------------------- Module Variables
    // ----- Pipe signals
    wire [DATA_WIDTH - 1:0] A_pipe [N * M - 1:0], B_pipe [N * M - 1:0];

    // ----- Mux control signals
    wire [N - 1:0] A_start_en;
    wire [M - 1:0] B_start_en;

    // ----- Mux output signals
    wire [DATA_WIDTH - 1:0] A_mux [N - 1:0];
    wire [DATA_WIDTH - 1:0] B_mux [M - 1:0];

    // ----- A, B, and C registers
    reg [DATA_WIDTH - 1:0] C_reg [N * M - 1:0], A_reg [N - 1:0], B_reg[N - 1:0];


    // ----- Data load signal for the MACs
    reg load;
    
    // ----------------------------------------------------- Load Signal Output
    assign load_out = load;
    
    // ----------------------------------------------------- 
    assign A_read_en  = A_start_en;
    assign A_mux[0] = A_start_en[0] == 0 ? 'b0 : A_in;
    assign A_mux[1] = A_start_en[1] == 0 ? 'b0 : A_in_1;
    assign A_mux[2] = A_start_en[2] == 0 ? 'b0 : A_in_2;

    assign B_read_en   = B_start_en;
    assign B_mux[0] = B_start_en[0] == 0 ? 'b0 : B_in;
    assign B_mux[1] = B_start_en[1] == 0 ? 'b0 : B_in_1;
    assign B_mux[2] = B_start_en[2] == 0 ? 'b0 : B_in_2;


    // ----------------------------------------------------- Module Instantiations
    test_control #(
        .N(N), .M(M)
    ) tci (
        .clk(clk),
        .rst(rst),
        .A_start_en(A_start_en),
        .B_start_en(B_start_en),
        .finished(finished),
        .C_write_en(C_write_en),
        .load(load)
    );


    // ----- Auto generating connections between MACs
    genvar i, j;
    generate
        for (i = 0; i < N; i = i + 1) begin : MAC_rows
            for (j = 0; j < M; j = j + 1) begin : MAC_cols
                test_mac #(
                    .DATA_WIDTH(DATA_WIDTH)
                ) tm_int (
                    .clk(clk),
                    .rst(rst),
                    .A_in(j == 0 ? A_mux[i] : A_pipe[N * i + (j - 1)] ),
                    .B_in(i == 0 ? B_mux[j] : B_pipe[(N * (i - 1)) + j]),
                    .A_out(A_pipe[N * i + j]),
                    .B_out(B_pipe[N * i + j]),
                    .C_out(C_reg[N * i + j]),
                    .load(load)
                );

                if ((N * i + j) == (N * i + (M - 1))) always @(posedge clk) A_reg[i] = A_pipe[N * i + (M - 1)];
                if ((N * i + j) == (N * (N - 1) + j)) always @(posedge clk) B_reg[j] = B_pipe[N * (N - 1) + j];

            end
        end
    endgenerate

    
    
    // ----------------------------------------------------- Tracing
initial begin
    $display("[%0t] Tracing to logs/vlt_dump.vcd...\n", $time);
    $dumpfile("logs/top_dump.vcd");
    $dumpvars();
    $display("[%0t] Model running...\n", $time);
end
endmodule
