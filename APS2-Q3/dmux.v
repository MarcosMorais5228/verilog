`timescale 1ps/1ps

module dmux8b(
    output wire [7:0] F, G,
    input wire [7:0] A,
    input wire Sel
);

    wire [7:0] Sel8, Sel8n;

    assign Sel8 = {Sel, Sel, Sel, Sel, Sel, Sel, Sel, Sel};
    not8bit inv(Sel8n, Sel8);

    and8b andF(F, A, Sel8n);
    and8b andG(G, A, Sel8);

endmodule

module dmux8_1to4b(
    output wire [7:0] W, X, Y, Z,
    input wire [7:0] A,
    input wire [1:0] Sel
);

    wire [7:0] F0, F1;

    dmux8b dmux1(F0, F1, A, Sel[1]);
    dmux8b dmux2(W, X, F0, Sel[0]);
    dmux8b dmux3(Y, Z, F1, Sel[0]);

endmodule