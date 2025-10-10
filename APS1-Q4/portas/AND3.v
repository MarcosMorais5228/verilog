`timescale 1ps/1ps

module AND3(input A, B, C, output F);

    wire f1;

    nand(f1, A, B, C);
    nand(F, f1, f1);

endmodule