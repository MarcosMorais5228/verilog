`timescale 1ns/1ps
`include "lib.v"

module dmux8_1to4b_tb;
    reg [7:0] A;
    reg [1:0] Sel;
    wire [7:0] W, X, Y, Z;

    dmux8_1to4b uut (W, X, Y, Z, A, Sel);

    initial begin
        $dumpfile("dmux8_1to4b_tb.vcd");
        $dumpvars(0, dmux8_1to4b_tb);

        A = 8'hFF;
        Sel = 2'b00; #10;
        Sel = 2'b01; #10;
        Sel = 2'b10; #10;
        Sel = 2'b11; #10;

    end
endmodule
