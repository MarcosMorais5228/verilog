`timescale 1ps/1ps

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