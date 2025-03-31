

module MACV2(
    input clk,
    input rst,

    input logic [31:0] A_in, Bin,

    output logic [31:0] C_out
);
    logic [31:0]  accumulate;

    always_ff @(posedge clk) begin
        if (rst) begin 
            accumulate = 'b0;
            C_out = 'b0;
        end        
    end
    
    
endmodule
