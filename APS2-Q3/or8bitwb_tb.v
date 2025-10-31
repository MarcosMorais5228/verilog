`timescale 1ns/1ps
`include "lib.v"

`timescale 1ns/1ps
module or8bitwb_tb;
    reg [7:0] A;
    wire F;

    or8bitwb uut (F, A);

    initial begin
        $dumpfile("or8bitwb_tb.vcd");
        $dumpvars(0, or8bitwb_tb);

        A = 8'b00000000; #10;
        A = 8'b00001111; #10;
        A = 8'b01000000; #10;
        A = 8'b11111111; #10;

    end
endmodule
