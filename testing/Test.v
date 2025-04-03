

module Test
#(
    parameter N = 2
)    
(
    input clk,
    input rst,

    input [31:0] A_in, B_in,

    output reg [31:0] A_out, B_out, C_out [N:0]
);
    
    reg [31:0] A_pipe [N:0], B_pipe [N:0];
    genvar i;
    generate
        for (i = 0; i <= N; i = i + 1) begin
            test_mac #(
                .DATA_WIDTH(32)
            ) tm_i (
                .clk(clk),
                .rst(rst),
                .A_in(i == 0 ? A_in : A_pipe[i - 1]),
                .B_in(i == 0 ? B_in : B_pipe[i - 1]),
                .A_out(A_pipe[i]),
                .B_out(B_pipe[i]),
                .C_out(C_out[i])
            );
        end
    endgenerate


    always @(posedge clk) begin
        if (rst) begin
            A_out <= 32'b0;
            B_out <= 32'b0;

            for (integer i = 0; i <= N; i = i + 1) begin
                C_out[i] <= 32'b0;
            end
            
        end
        else begin
            A_out <= A_pipe[N];
            B_out <= B_pipe[N];
        end
            
    end
    
    
    

// ---------------------------------------------------- Tracing
initial begin
    $display("[%0t] Tracing to logs/vlt_dump.vcd...\n", $time);
    $dumpfile("logs/top_dump.vcd");
    $dumpvars();
    $display("[%0t] Model running...\n", $time);
end
endmodule
