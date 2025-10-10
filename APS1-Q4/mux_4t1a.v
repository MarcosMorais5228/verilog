`timescale 1ps/1ps

module mux_4t1a(
    input A, B,C ,D,
    input [1:0] Sel,
    output F
);
    assign s1 = Sel[1];
    assign s0 = Sel[0];

    wire f1, f2, f3, f4, f5, An, Cn, s1n, s0n;

    nand(An, A, A);
    nand(Cn, C, C);

    nand(s1n, s1, s1);
    nand(s0n, s0, s0);

    nand(f1, An, s1n, s0n);
    nand(f2, B, s1n, s0);
    nand(f3, Cn, s1, s0n);
    nand(f4, D, s1, s0);

    nand(f5, f1, f3);

    nand(F, f2, f4, f5);


endmodule