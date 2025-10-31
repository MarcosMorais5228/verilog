`timescale 1ns/1ps
`include "lib.v"

module and8b_tb;
    reg [7:0] A, B;
    wire [7:0] F;

    and8b uut (F, A, B);

    initial begin
        $dumpfile("and8b_tb.vcd");
        $dumpvars(0, and8b_tb);

        A = 8'hFF; B = 8'h00; #10;
        A = 8'hAA; B = 8'h55; #10;
        A = 8'hF0; B = 8'h0F; #10;
        A = 8'hFF; B = 8'hFF; #10;

    end
endmodule
