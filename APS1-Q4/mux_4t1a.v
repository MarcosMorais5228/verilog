`timescale 1ps/1ps

module mux_4t1a(
    input A, B,C ,D,
    input [1:0] Sel,
    output F
);
    assign s1 = Sel[1];
    assign s0 = Sel[0];

    wire f1, f2, f3, f4, s1n, s0n;

    NOT inv3(s1, s1n);
    NOT inv4(s0, s0n);

    AND3 and1(A, s1n, s0n, f1);
    AND3 and2(B, s1n, s0, f2);
    AND3 and3(C, s1, s0n, f3);
    AND3 and4(D, s1, s0, f4);


    OR4 or1(f1, f2, f3, f4, F);


endmodule