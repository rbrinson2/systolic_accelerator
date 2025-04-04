
module test_control(
    input clk, rst,

    output reg load
);
    localparam RESET = 2'b00, LOAD_WAIT = 2'b01, LOAD = 2'b10;
    reg [1:0] current_state, next_state;

    always @(posedge clk) begin
        if (rst) current_state <= RESET;
        else current_state <= next_state;
    end

    always @(*) begin
        load = 'b0;

        case (current_state)
            RESET : begin
                if (rst) next_state = RESET;
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
    

endmodule
