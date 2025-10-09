module AND(input A, B, output F);
    
    wire Fn;

    nand(Fn, A, B);
    nand(F, Fn, Fn);

endmodule