`timescale 1ns/1ps

module xorb
	(output wire F,
	input wire A,B);
	
	assign F = A^B;

endmodule