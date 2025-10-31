`timescale 1ns/1ps
`include "lib.v"

module or8b_tb;
    reg [7:0] A, B;
    wire [7:0] F;

    or8b uut (F, A, B);

    initial begin
        $dumpfile("or8b_tb.vcd");
        $dumpvars(0, or8b_tb);

        A = 8'h00; B = 8'h00; #10;
        A = 8'h0F; B = 8'hF0; #10;
        A = 8'hAA; B = 8'h55; #10;

    end
endmodule
