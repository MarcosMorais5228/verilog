`timescale 1ps/1ps

module not8b
	(output wire [7:0] F,
	input wire [7:0] A);

	NOT not1 (F[0], A[0]);
    NOT not2 (F[1], A[1]);
    NOT not3 (F[2], A[2]);
    NOT not4 (F[3], A[3]);
    NOT not5 (F[4], A[4]);
    NOT not6 (F[5], A[5]);
    NOT not7 (F[6], A[6]);
    NOT not8 (F[7], A[7]);
	
endmodule

module or8bitwb
	(output wire F,
	input wire [7:0] A);

	wire F1, F2, F3, F4, F5, F6;

    OR or1 (F1, A[0], A[1]);
    OR or2 (F2, A[2], A[3]);
    OR or3 (F3, A[4], A[5]);
    OR or4 (F4, A[6], A[7]);

    OR or5 (F5, F1, F2);
    OR or6 (F6, F3, F4);

    OR or7 (F, F5, F6);
	
endmodule

module and8b
	(output wire [7:0] F,
	input wire [7:0] A,B);

    AND and1 (F[0], A[0], B[0]);
    AND and2 (F[1], A[1], B[1]);
    AND and3 (F[2], A[2], B[2]);
    AND and4 (F[3], A[3], B[3]);
    AND and5 (F[4], A[4], B[4]);
    AND and6 (F[5], A[5], B[5]);
    AND and7 (F[6], A[6], B[6]);
    AND and8 (F[7], A[7], B[7]);
	
endmodule

module or8b
	(output wire [7:0] F,
	input wire [7:0] A, B);

	OR or1 (F[0], A[0], B[0]);
    OR or2 (F[1], A[1], B[1]);
    OR or3 (F[2], A[2], B[2]);
    OR or4 (F[3], A[3], B[3]);
    OR or5 (F[4], A[4], B[4]);
    OR or6 (F[5], A[5], B[5]);
    OR or7 (F[6], A[6], B[6]);
    OR or8 (F[7], A[7], B[7]);

endmodule

module xor8b (
    output wire [7:0] F,
    input wire [7:0] A, B
);

    XOR xor1 (F[0], A[0], B[0]);
    XOR xor2 (F[1], A[1], B[1]);
    XOR xor3 (F[2], A[2], B[2]);
    XOR xor4 (F[3], A[3], B[3]);
    XOR xor5 (F[4], A[4], B[4]);
    XOR xor6 (F[5], A[5], B[5]);
    XOR xor7 (F[6], A[6], B[6]);
    XOR xor8 (F[7], A[7], B[7]);

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


module h_adder  
	(output wire S, C,
	input wire A, B);

	XOR xor1 (S, A, B);
    AND and1 (C, A, B);
	
endmodule

module f_adder
	(output wire S, Cout,
	 input wire A, B, Cin);

	wire S1, C1, C2;

    h_adder ha1 (S1, C1, A, B);
    h_adder ha2 (S, C2, S1, Cin);
    OR or1 (Cout, C1, C2);

endmodule

module adder8b
	(output wire [7:0] S, 
	 output wire Cout,
	input wire [7:0] A, B,
    input wire Cin);

    wire [7:0] C;

	f_adder adder1 (S[0], C[0], A[0], B[0], Cin); 
    f_adder adder2 (S[1], C[1], A[1], B[1], C[0]);
    f_adder adder3 (S[2], C[2], A[2], B[2], C[1]);
    f_adder adder4 (S[3], C[3], A[3], B[3], C[2]);
    f_adder adder5 (S[4], C[4], A[4], B[4], C[3]);
    f_adder adder6 (S[5], C[5], A[5], B[5], C[4]);
    f_adder adder7 (S[6], C[6], A[6], B[6], C[5]);
    f_adder adder8 (S[7], Cout, A[7], B[7], C[6]);
	
endmodule

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

module NOT (output wire F, input wire A);
    nand(F,A,A);
    
endmodule

module AND (output wire F, input wire A, B);
    wire Fn;

    nand(Fn, A, B);
    nand(F, Fn, Fn);

endmodule

module OR (output wire F, input wire A, B);
    wire f1, f2;

    nand(f1, A, A);
    nand(f2, B, B);
    nand(F, f1, f2);

endmodule

module XOR (output wire F, input wire A, B);
    wire An, Bn, f1, f2;

    nand(An, A, A);
    nand(Bn, B, B);

    nand(f1, An, B);
    nand(f2, A, Bn);

    nand(F, f1, f2);

endmodule