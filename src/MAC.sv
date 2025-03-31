

module MAC 
#(
    parameter DATA_WIDTH = 32
)
    
(
    input logic                     clk, rst,


    input logic [DATA_WIDTH - 1:0]  A_in,
    input logic                     A_in_waiting,
    input logic                     A_in_finished,
    output logic                    A_in_ready,

    input logic [DATA_WIDTH - 1:0]  B_in,
    input logic                     B_in_waiting,
    input logic                     B_in_finished,
    output logic                    B_in_ready,

    // output logic [DATA_WIDTH - 1:0]  A_out,
    output logic                     A_out_waiting,
    output logic                     A_out_finished,
    // input logic                      A_out_ready,

    // output logic [DATA_WIDTH - 1:0]  B_out,
    output logic                     B_out_waiting,
    output logic                     B_out_finished,
    // input logic                      B_out_ready,


    output logic [DATA_WIDTH - 1:0]  C_out
);


    // ---------------------------------------------- Accumulator
    logic [DATA_WIDTH - 1:0]    accumulate;
    logic                       accum_sig;

    always_latch begin
        if (rst) accumulate = 'b0;
        else begin
            if (accum_sig) accumulate += A_in * B_in;
            if (A_in_finished & B_in_finished) C_out = accumulate;
        end
    end
    
    // ---------------------------------------------- FSM Variables
    typedef enum {
        RESET, IN_WAIT, OUT_WAIT, ACCUM, OUT
    } states_t;

    states_t                    curr_state, next_state;
    // ---------------------------------------------- FSM
    always_ff @(posedge clk) begin
        if (rst) curr_state <= RESET;
        else curr_state <= next_state;
    end

    always_comb begin
        case (curr_state)
            RESET       : next_state = IN_WAIT;
            IN_WAIT     : if (A_in_waiting & B_in_waiting) next_state = ACCUM;
                          else if (A_in_finished & B_in_finished) next_state = OUT;
            ACCUM       : next_state = OUT_WAIT;
            OUT_WAIT    : if (A_out_waiting & B_out_waiting) next_state = IN_WAIT;  
            OUT         : next_state = IN_WAIT;
            default     : next_state = IN_WAIT;
        endcase
        
    end
    
    
    always_comb begin
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
    if ($test$plusargs("trace") != 0) begin
        $display("[%0t] Tracing to logs/vlt_dump.vcd...\n", $time);
        $dumpfile("logs/vlt_dump.vcd");
        $dumpvars();
    end
    $display("[%0t] Model running...\n", $time);

end

    
endmodule
