`timescale 1ps/1ps

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