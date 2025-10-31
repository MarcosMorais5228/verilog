`timescale 1ns/1ps
`include "lib.v"

module and8b_tb;
    reg [7:0] A, B;
    wire [7:0] F;

    and8b uut (F, A, B);

    initial begin
        $dumpfile("and8b_tb.vcd");
        $dumpvars(0, and8b_tb);

        A = 8'b11111111; B = 8'b00000000; #10;
        A = 8'b10101010; B = 8'b01010101; #10;
        A = 8'b11110000; B = 8'b00001111; #10;
        A = 8'b11111111; B = 8'b11111111; #10;

    end
endmodule
