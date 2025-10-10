`timescale 1ps/1ps

module OR4(input A, B, C, D, output F);

    wire An, Bn, Cn, Dn;
    
    NOT inv1(A, An);
    NOT inv2(B, Bn);
    NOT inv3(C, Cn);
    NOT inv4(D, Dn);

    nand(F, An, Bn, Cn, Dn);


endmodule