`timescale 1ns / 1ps

module Keypad_TB();

reg clk;
reg reset;
reg [3:0] column;
wire [3:0] row;
wire [3:0] key_code;
wire key_pressed;

Keypad UUT(
    .clk(clk),
    .reset(reset),
    .column(column),
    .row(row),
    .key_code(key_code),
    .key_pressed(key_pressed));
    
initial
    begin : CLOCK_STIM
        clk = 1'b0;
        forever #5 clk = ~clk;
    end

initial
    begin : RESET_STIM
        #100    //100
        reset = 1'b1;
        #100    //200
        reset = 1'b0;
    end
    
initial 
    begin : colum1_STIM
        #200    //200
        column = 4'b1110;
        #400    //600
        column = 4'b1101;
        #400    //1000
        column = 4'b1011;
        #400    //1400
        column = 4'b0111;
        #400    //1800
        column = 4'b1111;
    end
    
initial 
    begin : colum2_STIM
        #2200    //2200
        column = 4'b1110;
        #400    //2600
        column = 4'b1101;
        #400    //3000
        column = 4'b1011;
        #400    //3400
        column = 4'b0111;
        #400    //3800
        column = 4'b1111;
    end
    
initial 
    begin : colum3_STIM
        #4200    //4200
        column = 4'b1110;
        #400    //4600
        column = 4'b1101;
        #400    //5000
        column = 4'b1011;
        #400    //5400
        column = 4'b0111;
        #400    //5800
        column = 4'b1111;
    end
    
initial 
    begin : colum4_STIM
        #6200    //6200
        column = 4'b1110;
        #400    //6600
        column = 4'b1101;
        #400    //7000
        column = 4'b1011;
        #400    //7400
        column = 4'b0111;
        #400    //7800
        column = 4'b1111;
    end    
endmodule
