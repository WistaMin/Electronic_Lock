`timescale 1ns / 1ps

module Top_TB;

    //DO POPRAWNEGO DZIAŁANIA NALEŻY USTAWIĆ TIMERY NA:
    //DEBOUNCER.V - STABLE_TIME = 500000 -> 5
    //KEYPAD.V - SCANTIMER = 2000000 -> 20
    //KEYPAD_LOCK.V - SILENCE_LIMIT = 10000000 -> 100
    //LOCK_OPERATION.v - OPEN_TIME = 300000000 -> 200 


    // Wejścia do FPGA (Symulowane)
    reg clk;
    reg reset;
    wire [3:0] COL;

    // Wyjścia z FPGA (Obserwowane)
    wire [3:0] ROW;
    wire [1:0] LED;
    wire [6:0] seg;
    wire [3:0] an;

    Top UUT (
        .clk(clk),
        .reset(reset),
        .COL(COL),
        .ROW(ROW),
        .LED(LED),
        .seg(seg),
        .an(an)
    );


    initial begin
        clk = 0;
        forever #0.01 clk = ~clk;
    end

    reg [3:0] key_pressed;
    reg is_pressed;
    reg [3:0] col_state;

    always @(*) begin
        col_state = 4'b1111;
        
        if (is_pressed) begin
            case (key_pressed)
                // First row
                4'h1: if(ROW[0] == 0) col_state[0] = 0;
                4'h2: if(ROW[0] == 0) col_state[1] = 0;
                4'h3: if(ROW[0] == 0) col_state[2] = 0;
                4'hA: if(ROW[0] == 0) col_state[3] = 0;
                // Second row
                4'h4: if(ROW[1] == 0) col_state[0] = 0;
                4'h5: if(ROW[1] == 0) col_state[1] = 0;
                4'h6: if(ROW[1] == 0) col_state[2] = 0;
                4'hB: if(ROW[1] == 0) col_state[3] = 0;
                // Third row
                4'h7: if(ROW[2] == 0) col_state[0] = 0;
                4'h8: if(ROW[2] == 0) col_state[1] = 0;
                4'h9: if(ROW[2] == 0) col_state[2] = 0;
                4'hC: if(ROW[2] == 0) col_state[3] = 0;
                // Fourth row
                4'h0: if(ROW[3] == 0) col_state[0] = 0;
                4'hF: if(ROW[3] == 0) col_state[1] = 0;
                4'hE: if(ROW[3] == 0) col_state[2] = 0;
                4'hD: if(ROW[3] == 0) col_state[3] = 0;
            endcase
        end
    end

    assign COL = col_state;

    task press_key(input [3:0] key);
    begin
        key_pressed = key;
        is_pressed = 1;
        #2000; 
        is_pressed = 0;
        #500; 
    end
    endtask

    initial begin
        is_pressed = 0;
        key_pressed = 4'b0000;
        reset = 1;
        #100;
        reset = 0;
        #1000;

        //przykładowe naciśnięcie klawiszy  
        press_key(4'h1);
        press_key(4'h2);
        press_key(4'h3);
        press_key(4'h4);    
        press_key(4'hF); 
        #100;

        #5000;

        //zła kombinacja
        press_key(4'h5);
        press_key(4'h6);
        press_key(4'h7);
        press_key(4'h8);
        press_key(4'hF); 
        #100;
        #5000;
        $finish;     
    end
endmodule