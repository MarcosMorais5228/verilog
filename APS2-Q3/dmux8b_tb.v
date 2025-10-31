`timescale 1ns/1ps
`include "lib.v"

module dmux8b_tb;
    reg [7:0] A;
    reg Sel;
    wire [7:0] F, G;

    dmux8b uut (F, G, A, Sel);

    initial begin
        $dumpfile("dmux8b_tb.vcd");
        $dumpvars(0, dmux8b_tb);

        A = 8'b11111111; Sel = 0; #10;
        A = 8'b11111111; Sel = 1; #10;
        A = 8'b10101010; Sel = 0; #10;

    end
endmodule
