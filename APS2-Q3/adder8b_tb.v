`timescale 1ns/1ps
`include "lib.v"

module adder8b_tb;
    reg [7:0] A, B;
    reg Cin;
    wire [7:0] S;
    wire Cout;

    adder8b uut (S, Cout, A, B, Cin);

    initial begin
        $dumpfile("adder8b_tb.vcd");
        $dumpvars(0, adder8b_tb);

        A=8'd10; B=8'd5; Cin=0; #10;
        A=8'd127; B=8'd1; Cin=0; #10;
        A=8'd200; B=8'd100; Cin=1; #10;
        A=8'hFF; B=8'h01; Cin=0; #10;

    end
endmodule
