
module test_control
#(
    parameter N = 2, M = 2
)
(
    // ----------------------------------------------------- Module Inputs
    input clk, rst,
    input finished,

    // ----------------------------------------------------- Module Outputs
    output reg [N - 1:0] A_start_en,
    output reg [M - 1:0] B_start_en,
    output reg load
);
    // ----------------------------------------------------- FSM Variables
    localparam RESET = 'b00, LOAD_WAIT = 'b01, LOAD = 'b10, FINISH = 'B11;
    reg [1:0] current_state, next_state;

    // ----------------------------------------------------- Module variables
    reg [N - 1:0] A_start;
    reg [M - 1:0] B_start;

    integer unsigned momentum;
    reg mom_en;

    // ----------------------------------------------------- FSM 
    // Has built in momentum so that as finish goes high the
    // FSM doesn't just stop but will continue to output
    // a load signal depending on the size of the MAC
    // array.
    always @(posedge clk) begin
        if (rst) current_state <= RESET;
        else current_state <= next_state;
    end

    always @(*) begin
        mom_en = 'b0;
        load = 'b0;
        case (current_state)
            RESET : begin
                if (rst) next_state = RESET;
                else next_state = LOAD_WAIT;
            end
            LOAD_WAIT : begin
                if (finished) next_state = FINISH;
                else next_state = LOAD;
            end
            LOAD : begin    
                load = 'b1;
                if (finished) next_state = FINISH;
                else next_state = LOAD_WAIT;
            end
            FINISH : begin
                if (finished) begin
                    if (momentum > 0) begin 
                        mom_en = 'b1;
                        next_state = LOAD;
                    end
                    else next_state = FINISH;
                end
                else next_state = LOAD_WAIT;
            end
            default : next_state = RESET; 
        endcase
    end
    
    always @(mom_en) begin
        if (rst) begin  
            momentum = N + M; 
        end
        if (mom_en) momentum = momentum - 1;
    end
    // ----------------------------------------------------- Start assignment
    always @(negedge clk) begin
        if (rst) begin
            A_start = 'b0;
            B_start = 'b0;
        end
        else if (load & finished) begin
            A_start = {A_start[N - 2:0], 1'b0};
            B_start = {B_start[M - 2:0], 1'b0};
        end
        else if (load & !finished) begin
            A_start = {A_start[N - 2:0], 1'b1};
            B_start = {B_start[M - 2:0], 1'b1};
        end
    end
    

    always @(A_start) A_start_en <= A_start;
    always @(B_start) B_start_en <= B_start;

endmodule
