`timescale 1ns / 1ps

module Keypad(
    input clk,
    input reset,
    input [3:0] column,
    output reg [3:0] row,
    output reg [3:0] key_code,
    output reg key_pressed
    );
    
    reg [31:0] scan_timer;
    reg [1:0] current_row;
    
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            scan_timer <= 0;
            current_row <=0;
            row <= 4'b1111;
            key_code <= 0;
            key_pressed <= 0;
        end 
        else begin
            if (scan_timer >= 2000000) begin
                scan_timer <= 0;
                current_row <= current_row + 1;
            end
            else begin
                scan_timer <= scan_timer + 1;
            end
            
            case (current_row)
                0: row <= 4'b1110;
                1: row <= 4'b1101;
                2: row <= 4'b1011;
                3: row <= 4'b0111;
            endcase

            key_pressed = 0;
        
            case (current_row)
                0: begin
                    if (column[0] == 0) begin key_code = 4'h1; key_pressed = 1; end
                    if (column[1] == 0) begin key_code = 4'h2; key_pressed = 1; end
                    if (column[2] == 0) begin key_code = 4'h3; key_pressed = 1; end
                    if (column[3] == 0) begin key_code = 4'ha; key_pressed = 1; end
                end
                1: begin
                    if (column[0] == 0) begin key_code = 4'h4; key_pressed = 1; end
                    if (column[1] == 0) begin key_code = 4'h5; key_pressed = 1; end
                    if (column[2] == 0) begin key_code = 4'h6; key_pressed = 1; end
                    if (column[3] == 0) begin key_code = 4'hb; key_pressed = 1; end
                end
                2: begin
                    if (column[0] == 0) begin key_code = 4'h7; key_pressed = 1; end
                    if (column[1] == 0) begin key_code = 4'h8; key_pressed = 1; end
                    if (column[2] == 0) begin key_code = 4'h9; key_pressed = 1; end
                    if (column[3] == 0) begin key_code = 4'hc; key_pressed = 1; end
                end
                3: begin
                    if (column[0] == 0) begin key_code = 4'h0; key_pressed = 1; end
                    if (column[1] == 0) begin key_code = 4'hf; key_pressed = 1; end
                    if (column[2] == 0) begin key_code = 4'he; key_pressed = 1; end
                    if (column[3] == 0) begin key_code = 4'hd; key_pressed = 1; end
                end
            endcase
        end
    end
endmodule
