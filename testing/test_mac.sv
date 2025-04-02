

module test_mac
#(
    parameter DATA_WIDTH = 32
)
(
    input clk, rst,

    input [DATA_WIDTH - 1:0] A_in, B_in,

    output [DATA_WIDTH - 1:0] A_out, B_out, C_out
);


    assign C_out = A_in + B_in;
    assign A_out = A_in;
    assign B_out = B_in;
    
    
endmodule
