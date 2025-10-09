module XOR(input A, B, output F);
    wire An, Bn, f1, f2;

    nand(An, A, A);
    nand(Bn, B, B);

    nand(f1, An, B);
    nand(f2, A, Bn);

    nand(F, f1, f2);

endmodule