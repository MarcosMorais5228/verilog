`timescale 1ns/1ps
`include "lib.v"

module f_adder_tb;
    reg A, B, Cin;
    wire S, Cout;

    f_adder uut (S, Cout, A, B, Cin);

    initial begin
        $dumpfile("f_adder_tb.vcd");
        $dumpvars(0, f_adder_tb);

        A=0; B=0; Cin=0; #10;
        A=0; B=0; Cin=1; #10;
        A=0; B=1; Cin=0; #10;
        A=0; B=1; Cin=1; #10;
        A=1; B=0; Cin=0; #10;
        A=1; B=0; Cin=1; #10;
        A=1; B=1; Cin=0; #10;
        A=1; B=1; Cin=1; #10;

    end
endmodule
