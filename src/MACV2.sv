

module MACV2(
    input clk,
    input rst,

    input logic [31:0] A_in, B_in,
    input logic A_in_finished, B_in_finished,
    
    output logic [31:0] C_out,
    output logic A_in_ready, B_in_ready
);
    logic [31:0]  accumulate;

    always_ff @(posedge clk) begin
        if (rst) begin 
            accumulate = 'b0;
            C_out = 'b0;
        end  
        else if (A_in_finished & B_in_finished) begin
            C_out = accumulate;
        end
        else begin
            accumulate = accumulate + A_in * B_in;
        end      
    end

    initial begin
        $display("[%0t] Tracing to logs/vlt_dump.vcd...\n", $time);
        $dumpfile("logs/vlt_dump.vcd");
        $dumpvars();
        $display("[%0t] Model running...\n", $time);
    end


    
    
endmodule
