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

        A=8'b00001010; B=8'b00000101; Cin=0; #10;
        A=8'b01111111; B=8'b00000001; Cin=0; #10;
        A=8'b11001000; B=8'b01100100; Cin=1; #10;
        A=8'b11111111; B=8'b00000001; Cin=0; #10;

    end
endmodule
