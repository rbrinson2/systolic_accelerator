

module MAC 
#(
    parameter DATA_WIDTH = 32
)
    
(
    input logic clk, rst,
    input logic [DATA_WIDTH - 1:0] A_in, B_in,

    output logic [DATA_WIDTH - 1:0] C_out
);

always_ff @(posedge clk) begin
    if (rst) C_out <= 'b0;
    else C_out <= A_in + B_in;
end

initial begin
    if ($test$plusargs("trace") != 0) begin
        $display("[%0t] Tracing to logs/vlt_dump,vcd...\n", $time);
        $dumpfile("logs/vlt_dump.vcd");
        $dumpvars();
    end
    $display("[%0t] Model running...\n", $time);

end

    
endmodule
