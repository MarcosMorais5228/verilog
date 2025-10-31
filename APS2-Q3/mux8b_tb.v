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

        A = 8'hAA; B = 8'h55;
        Sel = 0; #10;
        Sel = 1; #10;
        A = 8'hF0; B = 8'h0F;
        Sel = 0; #10;
        Sel = 1; #10;

    end
endmodule
