

module MAC 
#(
    parameter DATA_WIDTH = 32
)
    
(
    input                      clk, rst,


    input [DATA_WIDTH - 1:0]  A_in,
    input                     A_in_waiting,
    input                     A_in_finished,
    output reg                A_in_ready,

    input  [DATA_WIDTH - 1:0]  B_in,
    input                      B_in_waiting,
    input                      B_in_finished,
    output reg                 B_in_ready,

    // output  [DATA_WIDTH - 1:0]  A_out,
    output reg                     A_out_waiting,
    output reg                     A_out_finished,
    // input                       A_out_ready,

    // output  [DATA_WIDTH - 1:0]  B_out,
    output reg                     B_out_waiting,
    output reg                     B_out_finished,
    // input                       B_out_ready,


    output reg [DATA_WIDTH - 1:0]  C_out
);


    // ---------------------------------------------- Accumulator
    reg [DATA_WIDTH - 1:0]    accumulate;
    reg                        accum_sig;

    always @(posedge clk) begin
        if (rst) begin
            accumulate = 'b0;
            C_out = 'b0;
        end
        else begin
            if (accum_sig) accumulate = accumulate + A_in * B_in;
            if (A_in_finished & B_in_finished) C_out = accumulate;
        end
    end
    
    // ---------------------------------------------- FSM Variables
    localparam RESET = 3'b000, IN_WAIT = 3'b001, OUT_WAIT = 3'b010, ACCUM = 3'b011, OUT = 3'b100;
    
    reg [2:0] curr_state, next_state;
    // ---------------------------------------------- FSM
    always @(posedge clk) begin
        if (rst) curr_state = RESET;
        else curr_state = next_state;
    end

    always @(posedge clk) begin
        case (curr_state)
            RESET       : if (!rst) next_state = IN_WAIT else next_state = RESET;
            IN_WAIT     : if (A_in_waiting & B_in_waiting) next_state = ACCUM;
                          else if (A_in_finished & B_in_finished) next_state = OUT;
            ACCUM       : next_state = OUT_WAIT;
            OUT_WAIT    : if (A_out_waiting & B_out_waiting) next_state = IN_WAIT;  
            OUT         : next_state = IN_WAIT;
            default     : next_state = IN_WAIT;
        endcase
        
    end
    
    
    always @* begin
        case (curr_state)
            RESET : {
                A_in_ready,
                B_in_ready,
                A_out_waiting,
                B_out_waiting,
                A_out_finished,
                B_out_finished,
                accum_sig
            } = 'b0000000;
            IN_WAIT : {
                A_in_ready,
                B_in_ready,
                A_out_waiting,
                B_out_waiting,
                A_out_finished,
                B_out_finished,
                accum_sig
            } = 'b1100000;
            ACCUM : {
                A_in_ready,
                B_in_ready,
                A_out_waiting,
                B_out_waiting,
                A_out_finished,
                B_out_finished,
                accum_sig
            } = 'b0000001;
            OUT_WAIT : {
                A_in_ready,
                B_in_ready,
                A_out_waiting,
                B_out_waiting,
                A_out_finished,
                B_out_finished,
                accum_sig
            } = 'b0011000;
            OUT : {
                A_in_ready,
                B_in_ready,
                A_out_waiting,
                B_out_waiting,
                A_out_finished,
                B_out_finished,
                accum_sig
            } = 'b0000110;
            default : {
                A_in_ready,
                B_in_ready,
                A_out_waiting,
                B_out_waiting,
                A_out_finished,
                B_out_finished,
                accum_sig
            } = 'b0000000;
        endcase
    end
    



 initial begin
    $display("[%0t] Tracing to logs/vlt_dump.vcd...\n", $time);
    $dumpfile("logs/vlt_dump.vcd");
    $dumpvars();
    $display("[%0t] Model running...\n", $time);
 end

    
endmodule
