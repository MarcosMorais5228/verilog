`timescale 1ns/1ps
`include "lib.v"

module OR_tb;

    reg A, B;
    wire F;

    OR OR_gate(.F(F), .A(A), .B(B));

    initial begin
        $dumpfile("OR.vcd");
        $dumpvars(0, OR_tb);

        A = 0; B = 0;
        #5;

        A = 0; B = 1;
        #5;

        A = 1; B = 0;
        #5;

        A = 1; B = 1;
        #5;

    end


endmodule