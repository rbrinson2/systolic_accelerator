

module test_mac
#(
    parameter DATA_WIDTH = 32
)
(
    input clk, rst,

    input [DATA_WIDTH - 1:0] A_in, B_in,
    input load,

    output reg [DATA_WIDTH - 1:0] A_out, B_out, C_out
);

    reg [DATA_WIDTH - 1:0] A, B;
    reg [DATA_WIDTH - 1:0] accumulate;

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
            if (A_in == 'b0 || B_in == 'b0) ;
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
    
   
    initial begin
        $dumpvars();
    end
    
    
endmodule
