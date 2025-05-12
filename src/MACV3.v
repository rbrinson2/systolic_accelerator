

module MACV3
#(
    parameter DATA_WIDTH = 32
)
(
    input clk, rst,

    // ---------------------------------------------------- Module Inputs
    input [DATA_WIDTH - 1:0] A_in, B_in,
    input load,

    // ---------------------------------------------------- Module Outputs
    output reg [DATA_WIDTH - 1:0] A_out, B_out, C_out
);

    // ---------------------------------------------------- Module Variables
    reg [DATA_WIDTH - 1:0] A, B;
    reg [DATA_WIDTH - 1:0] accumulate;

    // ---------------------------------------------------- MAC Operation
    // The MAC will do nothing if either input from A or B
    // is 0, otherwise it will accumulate each time load 
    // goes high
    always @(posedge clk) begin
        if (rst) begin
            A = 'b0;
            B = 'b0;
            A_out = 'b0;
            B_out = 'b0;
            C_out = 'b0;
            accumulate = 'b0;
        end
        else if(load) begin
            if (A_in == 'b0 || B_in == 'b0) begin
                A = 'b0;
                B = 'b0;
            end
            else begin
                A = A_in;
                B = B_in;
                accumulate = accumulate + A * B;
            end
        end
        else begin
            C_out = accumulate;
            A_out = A;
            B_out = B;
        end
    end
    
   
    // ---------------------------------------------------- Tracing
    initial begin
        $dumpvars();
    end
    
    
endmodule
