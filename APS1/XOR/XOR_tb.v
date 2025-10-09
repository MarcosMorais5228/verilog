`include "XOR.v"

module XOR_tb;

    reg A, B;
    wire F;

    XOR XOR_gate(.A(A), .B(B), .F(F));

    initial begin
        $dumpfile("XOR_tb.vcd");
        $dumpvars(0, XOR_tb);

        A = 0; B= 0;
        #5;

        A = 0; B= 1;
        #5;

        A = 1; B= 0;
        #5;

        A = 1; B= 1;
        #5;
    end


endmodule