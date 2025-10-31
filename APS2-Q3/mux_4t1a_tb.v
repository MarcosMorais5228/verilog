`timescale 1ns/1ps
`include "lib.v"

module mux_4t1a_tb;
    reg A, B, C, D;
    reg [1:0] Sel;
    wire F;

    mux_4t1a uut (F, A, B, C, D, Sel);

    initial begin
        $dumpfile("mux_4t1a_tb.vcd");
        $dumpvars(0, mux_4t1a_tb);

        A = 0; B = 1; C = 0; D = 1;
        Sel = 2'b00; #10;  
        Sel = 2'b01; #10;  
        Sel = 2'b10; #10;  
        Sel = 2'b11; #10;  

        A = 1; B = 0; C = 1; D = 0;
        Sel = 2'b00; #10;
        Sel = 2'b01; #10;
        Sel = 2'b10; #10;
        Sel = 2'b11; #10;

    end
endmodule
