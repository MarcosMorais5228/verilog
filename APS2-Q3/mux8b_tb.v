`timescale 1ns/1ps
`include "lib.v"

module mux8b_tb;
    reg [7:0] A, B;
    reg Sel;
    wire [7:0] F;

    mux8b uut (F, A, B, Sel);

    initial begin
        $dumpfile("mux8b_tb.vcd");
        $dumpvars(0, mux8b_tb);

        A = 8'b10101010; B = 8'b01010101;
        Sel = 0; #10;
        Sel = 1; #10;
        A = 8'b11110000; B = 8'b00001111;
        Sel = 0; #10;
        Sel = 1; #10;

    end
endmodule
