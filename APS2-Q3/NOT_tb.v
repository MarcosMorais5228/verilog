`timescale 1ns/1ps
`include "lib.v"

module NOT_tb;
    reg fio1;
    wire fio3;

    NOT NOT_gate(.F(fio3), .A(fio1));

    initial begin
        $dumpfile("NOT.vcd");
        $dumpvars (0,NOT_tb);
        
        fio1 = 1; 
        #5;

        fio1 = 0;
        #5;
    end
endmodule