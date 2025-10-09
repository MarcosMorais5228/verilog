`include "OR.v"

module OR_tb;

    reg A, B;
    wire F;

    OR OR_gate(.A(A), .B(B), .F(F));

    initial begin
        $dumpfile("OR.vcd");
        $dumpvars(0, OR_tb);

        A = 0; B = 0;
        #5;

        A = 0; B = 1;
        #5;

        A = 1; B = 0;
        #5;

        A = 1; B = 1;
        #5;

    end


endmodule