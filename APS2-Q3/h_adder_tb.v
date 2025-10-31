`timescale 1ns/1ps
`include "lib.v"

`timescale 1ns/1ps
module h_adder_tb;
    reg A, B;
    wire S, C;

    h_adder uut (S, C, A, B);

    initial begin
        $dumpfile("h_adder_tb.vcd");
        $dumpvars(0, h_adder_tb);

        A = 0; B = 0; #10;
        A = 0; B = 1; #10;
        A = 1; B = 0; #10;
        A = 1; B = 1; #10;

    end
endmodule
