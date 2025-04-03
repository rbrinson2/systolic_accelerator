

module test_mac
#(
    parameter DATA_WIDTH = 32
)
(
    input clk, rst,

    input [DATA_WIDTH - 1:0] A_in, B_in,

    output reg [DATA_WIDTH - 1:0] A_out, B_out, C_out
);

    always @(posedge clk) begin
        if (rst) begin
            A_out = 'b0;
            B_out = 'b0;
            C_out = 'b0;
        end
        else begin
            C_out = A_in + B_in;
            A_out = A_in;
            B_out = B_in;
        end
    end
    
   
    initial begin
        $dumpvars();
    end
    
    
endmodule
