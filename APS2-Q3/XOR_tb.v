`timescale 1ns/1ps
`include "lib.v"

module XOR_tb;

    reg A, B;
    wire F;

    XOR XOR_gate(.F(F), .A(A), .B(B));

    initial begin
        $dumpfile("XOR_tb.vcd");
        $dumpvars(0, XOR_tb);

        A = 0; B= 0;
        #5;

        A = 0; B= 1;
        #5;

        A = 1; B= 0;
        #5;

        A = 1; B= 1;
        #5;
    end


endmodule