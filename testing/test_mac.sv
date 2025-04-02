

module test_mac
#(
    parameter DATA_WIDTH = 32
)
(
    input clk, rst,

    input [DATA_WIDTH - 1:0] A_in, B_in,

    output [DATA_WIDTH - 1:0] A_out, B_out, C_out
);
    integer A, B, C;

    always @(posedge clk) begin
        if (rst) begin
            A <= 'b0;
            B <= 'b0;
            C <= 'b0; 
        end
        else begin
            A <= A_in;
            B <= B_in;

            C <= A + B;

            A_out <= A;
            B_out <= B;

            C_out <= C;
        end
    end
    
endmodule
