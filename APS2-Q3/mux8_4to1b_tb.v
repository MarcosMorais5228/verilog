`timescale 1ns/1ps
`include "lib.v"

module mux8_4to1b_tb;
    reg [7:0] A, B, C, D;
    reg [1:0] Sel;
    wire [7:0] F;

    mux8_4to1b uut (F, A, B, C, D, Sel);

    initial begin
        $dumpfile("mux8_4to1b_tb.vcd");
        $dumpvars(0, mux8_4to1b_tb);


        A = 8'b10101010; B = 8'b01010101; 
        C = 8'b11110000; D = 8'b00001111;
        Sel = 2'b00; #10;
        Sel = 2'b01; #10;
        Sel = 2'b10; #10;
        Sel = 2'b11; #10;

    end
endmodule
