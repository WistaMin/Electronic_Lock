module Top(
    input clk,
    input reset,
    input set_password,
    input [3:0] COL,
    output [3:0] ROW,
    output [1:0] LED,
    output [6:0] seg,
    output [7:0] an
);
    //kable klawiatrura - debouncer
    wire [3:0] raw_key;
    wire raw_pressed;

    //kable debouncer - lock_key
    wire [3:0] deb_key;
    wire deb_pressed;

    //kable lock_key - lock_operation
    wire [3:0] final_key;
    wire final_pressed;

    //kable lock_operation - seven_seg
    wire [15:0] number_to_display;
    wire lock_closed;
    wire lock_is_opened;

    Keypad keypad (
        .clk(clk),
        .reset(reset),
        .column(COL),
        .row(ROW),
        .key_code(raw_key),
        .key_pressed(raw_pressed)
    );

    Debouncer debouncer (
        .clk(clk),
        .reset(reset),
        .raw_key(raw_key),
        .raw_pressed(raw_pressed),
        .clean_key(deb_key),
        .pressed(deb_pressed)
    );

    Keypad_lock lock(
        .clk(clk),
        .reset(reset),
        .din_key(deb_key),
        .din_pressed(deb_pressed),
        .dout_key(final_key),
        .dout_pressed(final_pressed)
    );
    
    Lock_operation lock_operation(
        .clk(clk),
        .reset(reset),
        .set_password(set_password),
        .pressed(final_pressed),
        .digit(final_key),
        .number_out(number_to_display),
        .closed(lock_closed),
        .is_opened(lock_is_opened)
    );
    
    Seven_seg seven_seg(
        .clk(clk),
        .number(number_to_display),
        .seg(seg),
        .an(an)
    );
    
    assign LED[0] = lock_closed;
    assign LED[1] = lock_is_opened;
endmodule