

module MACV2
#(
    parameter DATA_WIDTH = 32
)    
(
    input clk,
    input rst,

    // ---------------------------------------------------- Inputs
    input logic [DATA_WIDTH - 1:0] A_in, B_in,
    input logic A_in_finished, B_in_finished,
    input logic A_in_waiting, B_in_waiting,
    input logic A_out_ready, B_out_ready,
    
    // ---------------------------------------------------- Outputs
    output logic [DATA_WIDTH - 1:0] A_out, B_out, C_out,
    output logic A_in_ready, B_in_ready,
    output logic A_out_waiting, B_out_waiting,
    output logic A_out_finished, B_out_finished
);


    // ---------------------------------------------------- Module Variables
    logic [DATA_WIDTH - 1:0]  accumulate;
    logic accum_en;
    logic out_en;
    logic pass_en;

    // ---------------------------------------------------- FSM Variables
    typedef enum {RESET, IN_WAIT, LOAD, ACCUM, PASS, OUT, FINISHED} state_t;
    state_t current_state, next_state;
    logic [DATA_WIDTH - 1:0] A, B;
    logic load_en;

    // ---------------------------------------------------- FSM 
    always @(posedge clk) begin
        if (rst) current_state = RESET;
        else current_state = next_state;
    end

    always @(current_state) begin
        case (current_state)
            RESET : next_state = IN_WAIT;
            IN_WAIT : begin 
                if (A_in_finished & B_in_finished) next_state = OUT;
                else if (A_in_waiting & B_in_waiting) next_state = LOAD;
                else next_state = IN_WAIT;
            end
            LOAD : begin 
                if(A_in_waiting & B_in_waiting) next_state = ACCUM;
                else next_state = LOAD;
            end
            ACCUM : next_state = PASS;
            PASS : begin 
                if (A_out_ready & B_out_ready) next_state = IN_WAIT;
                else next_state = PASS;
            end
            OUT : next_state = FINISHED;
            FINISHED : begin 
                if (A_in_waiting & B_in_waiting) next_state = IN_WAIT; 
                else next_state = FINISHED;
            end
            default : next_state = RESET;
        endcase
    end

    always @(current_state) begin
        A_in_ready = 'b0;
        B_in_ready = 'b0;
        A_out_waiting = 'b0;
        B_out_waiting = 'b0;
        A_out_finished = 'b0;
        B_out_finished = 'b0;
        load_en = 'b0;
        accum_en = 'b0;
        out_en = 'b0;
        pass_en = 'b0;

        case (current_state)
            RESET : ;
            IN_WAIT : begin
                A_in_ready = 'b1;
                B_in_ready = 'b1;
            end
            ACCUM : accum_en = 'b1;
            PASS : begin 
                A_out_waiting = 'b1;
                B_out_waiting = 'b1;
                pass_en = 'b1;
            end
            LOAD : load_en = 'b1;
            OUT : out_en = 'b1;
            FINISHED : begin
                A_out_finished = 1'b1;
                B_out_finished = 1'b1;
            end
            default : ;
        endcase
    end

    always @(load_en, rst) begin
        if (rst) begin
            A = 'b0;
            B = 'b0;
        end
        else if (load_en) begin
            A = A_in;
            B = B_in;
        end
        
    end
    
    

    // ---------------------------------------------------- Accumulate
    always @(accum_en, rst) begin
        if (rst) accumulate = 'b0;
        else if(accum_en) accumulate = accumulate + A * B;        
    end

    // ---------------------------------------------------- C output
    always @(out_en, rst) begin
        if (rst) C_out = 'b0;
        else if (out_en) C_out = accumulate;
    end

    // ---------------------------------------------------- A and B output
    always @(pass_en, rst) begin
        if (rst) begin
            A_out = 'b0;
            B_out = 'b0;
        end
        else if (pass_en) begin
            if (A_out_ready & B_out_ready) begin
                A_out = A;
                B_out = B;
            end
        end
    end
    


    // ---------------------------------------------------- Tracing
    initial begin
        $display("[%0t] Tracing to logs/vlt_dump.vcd...\n", $time);
        $dumpfile("logs/macv2_dump.vcd");
        $dumpvars();
        $display("[%0t] Model running...\n", $time);
    end

endmodule
