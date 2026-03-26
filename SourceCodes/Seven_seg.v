`timescale 1ns / 1ps

module Seven_seg(
    input clk,
    input [15:0] number,
    output reg [6:0] seg,
    output reg [7:0] an
    );
    
    reg [19:0] refresh_counter = 0;
    always @(posedge clk) begin
        refresh_counter <= refresh_counter + 1;
    end

    wire [1:0] digit_select = refresh_counter[19:18];
    reg [3:0] digit;
    always @(*) begin
        an = 8'b11111111;
        case(digit_select)
            2'b00: begin
                an = 8'b11111110;
                digit = number[3:0];    
            end
            2'b01: begin
                an = 8'b11111101;
                digit = number[7:4];    
            end
            2'b10: begin
                an = 8'b11111011;
                digit = number[11:8];    
            end
            2'b11: begin    
                an = 8'b11110111;
                digit = number[15:12];    
            end
        endcase
    end

    always @(*) begin
        case(digit)
            4'b0000: seg = 7'b1000000; // 0
            4'b0001: seg = 7'b1111001; // 1
            4'b0010: seg = 7'b0100100; // 2
            4'b0011: seg = 7'b0110000; // 3
            4'b0100: seg = 7'b0011001; // 4
            4'b0101: seg = 7'b0010010; // 5
            4'b0110: seg = 7'b0000010; // 6
            4'b0111: seg = 7'b1111000; // 7
            4'b1000: seg = 7'b0000000; // 8
            4'b1001: seg = 7'b0010000; // 9
            4'b1010: seg = 7'b0001000; // A 
            4'b1011: seg = 7'b1000001; // b (U)
            4'b1100: seg = 7'b1000110; // C
            4'b1101: seg = 7'b1000111; // d (L)
            4'b1110: seg = 7'b0000110; // E
            4'b1111: seg = 7'b0001100; // F (P)
            default: seg = 7'b1111111; // off
        endcase       
    end
        

endmodule
