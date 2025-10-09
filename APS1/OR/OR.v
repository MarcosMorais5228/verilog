module OR(input A, B, output F);
    wire f1, f2;

    nand(f1, A, A);
    nand(f2, B, B);
    nand(F, f1, f2);


endmodule