`timescale 1ns / 1ps

module Debouncer(
    input clk,
    input reset,
    input [3:0] raw_key,
    input raw_pressed,
    output reg [3:0] clean_key,
    output reg pressed
    );
    
    reg [3:0] last_key;
    reg [31:0] stable_timer;
    parameter STABLE_TIME = 500000;
    
    always @(posedge clk or posedge reset) begin 
        if (reset) begin
            clean_key <= 0;
            pressed <= 0;
            last_key <= 0;
            stable_timer <= 0;
        end
        else begin
            pressed <= 0;
            if (raw_key != last_key || raw_pressed == 0) begin
                stable_timer <= 0;
                last_key <= raw_key;
            end
            else begin 
                if (stable_timer < STABLE_TIME) begin
                    stable_timer <= stable_timer + 1;
                end
                if (stable_timer == STABLE_TIME) begin
                    clean_key <=raw_key;
                    pressed <=1 ;
                end
            end
        end
    end                   
endmodule
