`timescale 1ns / 1ps

module Lock_operation(
    input clk,
    input reset,
    input pressed,
    input [3:0] digit,
    input set_password,
    output [15:0] number_out,   
    output reg closed,
    output reg is_opened 
    );
    
    reg [2:0] counter = 0;
    reg [15:0] code_buffer;
    reg [15:0] password = 16'h2208;
    reg [2:0] block_counter = 0;
    
    parameter 
        IDLE = 0, 
        VERIFY = 1,
        OPEN = 2,
        ERROR = 3,
        SET_PASSWORD = 4,
        BLOCKED = 5;
    
    
    parameter OPEN_TIME = 300000000;
    
    reg [2:0] state = IDLE;
    reg [31:0] state_time = 0;

    always @(posedge clk) begin
        if (reset) begin
            counter <= 0;
            state <= IDLE;
            closed <= 0;
            is_opened <= 0;
            code_buffer <= 0;
            state_time <= 0;
            block_counter <=0;
        end
        else begin
            case (state) 
                IDLE : begin
                    closed <= 1;
                    is_opened <=0;
                    if (pressed) begin
                        if (digit == 4'b1111) begin // Przycisk "ACCEPT"
                            if (set_password) begin
                                password <= code_buffer;
                                state_time <= 0;
                                state <= SET_PASSWORD;
                            end
                            else begin
                                state <= VERIFY; 
                            end
                        end
                        else begin
                            if (digit == 4'hC) begin //PRZYCISK "KASUJ"
                                counter <= 0;
                                code_buffer <= 0;
                            end
                            else begin
                                case (counter)
                                3'd0 : code_buffer[15:12] <= digit;
                                3'd1 : code_buffer[11:8]  <= digit;
                                3'd2 : code_buffer[7:4]   <= digit;
                                3'd3 : code_buffer[3:0]   <= digit;
                                endcase
                                counter <= counter + 1;
                           end
                       end
                    end
                end
                VERIFY : begin
                    state_time <= 0;
                    if (code_buffer == password) begin
                       state <= OPEN; 
                    end
                    else begin
                        if (block_counter < 4) begin
                            block_counter <= block_counter + 1;
                            state <= ERROR;
                        end    
                        else begin
                            state <= BLOCKED;
                        end
                    end
                end
                OPEN : begin 
                    is_opened <=1;
                    closed <=0;
                    block_counter <= 0;
                    code_buffer <= 0;
                    counter <= 0;
                    if (state_time >= OPEN_TIME) begin
                        state <= IDLE;
                    end
                    else begin
                        state_time <= state_time + 1;
                    end
                end
                ERROR : begin
                    closed <= 1;
                    is_opened <=0;
                    code_buffer <= 0;
                    counter <= 0;
                    if (state_time >= OPEN_TIME) begin
                        state <= IDLE;
                    end
                    else begin
                        state_time <= state_time + 1;
                    end
                end
                SET_PASSWORD : begin
                    code_buffer <= 0;
                    counter <= 0;
                    if (state_time >= OPEN_TIME) begin
                        state <= IDLE;               
                    end
                    else begin
                        state_time <= state_time + 1;
                    end
                end
                BLOCKED : begin
                    code_buffer <= 0;   
                    closed <= 1;
                    is_opened <= 0; 
                end
            endcase
        end
    end
assign number_out = (state == OPEN) ? 16'h00FE : 
                    (state == ERROR) ? 16'hCD05 :
                    (state == SET_PASSWORD) ? 16'h5ABE :
                    (state == BLOCKED) ? 16'h8D0C :
                    code_buffer;
    
endmodule
