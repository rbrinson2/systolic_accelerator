
module test_control
#(
    parameter N = 2, M = 2
)
(
    input clk, rst,

    output reg [N - 1:0] A_start_en,
    output reg [M - 1:0] B_start_en,
    output reg load
);
    localparam RESET = 2'b00, LOAD_WAIT = 2'b01, LOAD = 2'b10;
    reg [1:0] current_state, next_state;

    reg [N - 1:0] A_start;
    reg [M - 1:0] B_start;

    always @(posedge clk) begin
        if (rst) current_state <= RESET;
        else current_state <= next_state;
    end

    always @(*) begin
        load = 'b0;
        case (current_state)
            RESET : begin
                if (rst) begin
                    next_state = RESET;
                end
                else next_state = LOAD_WAIT;
            end
            LOAD_WAIT : begin
                next_state = LOAD;
            end
            LOAD : begin    
                load = 'b1;
                next_state = LOAD_WAIT;
            end
            default : next_state = RESET; 
        endcase
    end
   
    always @(posedge clk) begin
        if (rst) begin
            A_start = 'b0;
            B_start = 'b0;
        end
        else if (load) begin
            A_start = {A_start[N - 2:0], 1'b1};
            B_start = {B_start[M - 2:0], 1'b1};
        end
    end
    

    always @(A_start) A_start_en <= A_start;
    always @(B_start) B_start_en <= B_start;

endmodule
