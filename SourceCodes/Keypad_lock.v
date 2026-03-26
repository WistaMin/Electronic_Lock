`timescale 1ns / 1ps

module Keypad_lock(
    input clk,
    input reset,
    input [3:0] din_key,
    input din_pressed,
    output reg [3:0] dout_key,
    output reg dout_pressed
        );
    
    reg lock;
    reg [31:0] silence_timer;
    
    parameter SILENCE_LIMIT = 10000000;
    
    always @(posedge clk) begin
        if(reset) begin
            dout_key <= 0;
            dout_pressed <= 0;
            lock <= 0;
            silence_timer <= 0;
        end
        else begin
            dout_pressed <= 0;
            
            if(din_pressed) begin
                silence_timer <= 0;
                
                if(!lock) begin
                    dout_key <= din_key;
                    dout_pressed <= 1;
                    lock <= 1;
                end
            end
            else begin
                if (lock) begin
                    silence_timer <= silence_timer + 1;
                    
                    if (silence_timer > SILENCE_LIMIT) begin
                        lock <= 0;
                    end
                end
            end
        end
    end
endmodule
