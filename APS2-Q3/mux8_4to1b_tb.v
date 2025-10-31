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


        A=8'hAA; B=8'h55; C=8'hF0; D=8'h0F;
        Sel=2'b00; #10;
        Sel=2'b01; #10;
        Sel=2'b10; #10;
        Sel=2'b11; #10;

    end
endmodule
