`timescale 1ps/1ps

module mux_4t1a 
        (output wire F, 
        input wire A, B, C, D, 
        input wire [1:0] Sel);

    wire I0i, I1i, I2i, I3i, I0, I1, I2, I3, F1, F2;
    wire Sel0n, Sel1n;

    NOT inv1 (Sel0n, Sel[0]);
    NOT inv2 (Sel1n, Sel[1]);

    AND and1 (I0i, A, Sel0n);
    AND and2 (I0, I0i, Sel1n);

    AND and3 (I1i, B, Sel[0]);
    AND and4 (I1, I1i, Sel1n);

    AND and5 (I2i, C, Sel0n);
    AND and6 (I2, I2i, Sel[1]);

    AND and7 (I3i, D, Sel[0]);
    AND and8 (I3, I3i, Sel[1]);

    OR or1 (F1, I0, I1);
    OR or2 (F2, F1, I2);
    OR or3 (F, F2, I3);

endmodule

module mux8b(
    output wire [7:0] F,
    input wire [7:0] A, B,
    input wire Sel
);

    mux_4t1a mux1(F[0], A[0], B[0], 1'b0, 1'b0, {1'b0, Sel});
    mux_4t1a mux2(F[1], A[1], B[1], 1'b0, 1'b0, {1'b0, Sel});
    mux_4t1a mux3(F[2], A[2], B[2], 1'b0, 1'b0, {1'b0, Sel});
    mux_4t1a mux4(F[3], A[3], B[3], 1'b0, 1'b0, {1'b0, Sel});
    mux_4t1a mux5(F[4], A[4], B[4], 1'b0, 1'b0, {1'b0, Sel});
    mux_4t1a mux6(F[5], A[5], B[5], 1'b0, 1'b0, {1'b0, Sel});
    mux_4t1a mux7(F[6], A[6], B[6], 1'b0, 1'b0, {1'b0, Sel});
    mux_4t1a mux8(F[7], A[7], B[7], 1'b0, 1'b0, {1'b0, Sel});

endmodule

module mux8_4to1b(
    output wire [7:0] F,
    input wire [7:0] A, B, C, D,
    input wire [1:0] Sel
);

    wire [7:0] F1, F2;

    mux8b mux0(F1, A, B, Sel[0]);
    mux8b mux1(F2, C, D, Sel[0]);

    mux8b mux2(F, F1, F2, Sel[1]);

endmodule