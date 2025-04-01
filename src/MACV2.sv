

module MACV2(
    input clk,
    input rst,

    input logic [31:0] A_in, B_in,
    input logic A_in_finished, B_in_finished,
    input logic A_in_waiting, B_in_waiting,
    
    output logic [31:0] C_out,
    output logic A_in_ready, B_in_ready
);
    logic [31:0]  accumulate;
    logic accum_sig;
    logic out_sig;

    typedef enum {RESET, IN_WAIT, ACCUM, OUT} state_t;
    state_t current_state, next_state;

    always @(posedge clk) begin
        if (rst) current_state = RESET;
        else current_state = next_state;
    end

    always @(current_state) begin
        case (current_state)
            RESET : next_state = IN_WAIT;
            IN_WAIT : begin 
                if (A_in_finished & B_in_finished) next_state = OUT;
                else if (A_in_waiting & B_in_waiting) next_state = ACCUM;
            end
            ACCUM : next_state = IN_WAIT;
            OUT : if (!A_in_finished & !B_in_finished) next_state = IN_WAIT;
            default : next_state = RESET;
        endcase
    end

    always @(current_state) begin
        A_in_ready = 'b0;
        B_in_ready = 'b0;
        accum_sig = 'b0;
        out_sig = 'b0;

        case (current_state)
            RESET : begin
                A_in_ready = 0;
                B_in_ready = 0;
            end
            IN_WAIT : begin
                A_in_ready = 1;
                B_in_ready = 1;
            end
            ACCUM : begin
                accum_sig = 1;
            end
            OUT : out_sig = 1;
        endcase
    end
    

    always @(accum_sig, rst) begin
        if (rst) accumulate = 'b0;
        else if(accum_sig) accumulate = accumulate + A_in * B_in;        
    end

    always @(out_sig, rst) begin
        if (rst) C_out = 'b0;
        else if (out_sig) C_out = accumulate;
    end
    
    
        
    

    // always_ff @(posedge clk) begin
    //     if (rst) begin 
    //         accumulate = 'b0;
    //         A_in_ready = 'b0;
    //         B_in_ready = 'b0;
    //         C_out = 'b0;

    //     end  
    //     else if (A_in_finished & B_in_finished) begin
    //         C_out = accumulate;
    //     end
    //     else begin
    //         A_in_ready = 'b1;
    //         B_in_ready = 'b1;
    //         accumulate = accumulate + A_in * B_in;
    //     end      
    // end

    initial begin
        $display("[%0t] Tracing to logs/vlt_dump.vcd...\n", $time);
        $dumpfile("logs/vlt_dump.vcd");
        $dumpvars();
        $display("[%0t] Model running...\n", $time);
    end

endmodule
