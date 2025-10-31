`timescale 1ns/1ps
`include "lib.v"

module not8b_tb;
    reg  [7:0] A;
    wire [7:0] F;

    not8b uut (F, A);

    initial begin
        $dumpfile("not8b_tb.vcd");
        $dumpvars(0, not8b_tb);

        A = 8'b00000000; #10;
        A = 8'b11111111; #10;
        A = 8'b10101010; #10;
        A = 8'b11001100; #10;
    end
endmodule
