`timescale 1ns/1ps

module alub
	(output reg [7:0] Result,
	output reg [3:0] NZVC, //Flags: Negative, Zero, Overflow, Carry
	input wire [7:0] A, B,
	input wire [2:0] ALU_Sel);

	always @ (A, B, ALU_Sel)
		begin
			case (ALU_Sel)
				3'b000: begin
							{NZVC[0], Result} = A + B;
							NZVC[3] = Result[7];
							if (Result==0)
								NZVC[2] = 1;
							else
								NZVC[2] = 0;
							if (A[7]==0 && B[7]==0 && Result[7]==1) 
								NZVC[1] = 1;
							else if (A[7]==1 && B[7]==1 && Result[7]==0)
								NZVC[1] = 1;
							else
								NZVC[1] = 0;
						end
				3'b001: begin
							{NZVC[0], Result} = A + 1;
							NZVC[3] = Result[7];
							if (Result==0)
								NZVC[2] = 1;
							else
								NZVC[2] = 0;
							if (A[7]==0 && Result[7]==1) 
								NZVC[1] = 1;
							else
								NZVC[1] = 0;
						end	
				3'b010: begin
							{NZVC[0], Result} = A - B;
							NZVC[3] = Result[7];
							if (Result==0)
								NZVC[2] = 1;
							else
								NZVC[2] = 0;
							if (A[7]==0 && B[7]==1 && Result[7]==1) 
								NZVC[1] = 1;
							else if (A[7]==1 && B[7]==0 && Result[7]==0)
								NZVC[1] = 1;
							else 
								NZVC[1] = 0;
						end
				3'b011: begin
							{NZVC[0], Result} = A - 1;
							NZVC[3] = Result[7];
							if (Result==0)
								NZVC[2] = 1;
							else
								NZVC[2] = 0;
							if (A[7]==1 && Result[7]==0) 
								NZVC[1] = 1;
							else 
								NZVC[1] = 0;          
						end	
				3'b100: begin
							Result = A & B;
							NZVC[3] = Result[7];
							if (Result==0)
								NZVC[2] = 1;
							else
								NZVC[2] = 0;
							NZVC[1] = 0;
							NZVC[0] = 0;
						end
				3'b101: begin
							Result = A | B;
							NZVC[3] = Result[7];
							if (Result==0)
								NZVC[2] = 1;
							else
								NZVC[2] = 0;
							NZVC[1] = 0;
							NZVC[0] = 0;
						end
				3'b110: begin
							Result = A ^ B;
							NZVC[3] = Result[7];
							if (Result==0)
								NZVC[2] = 1;
							else
								NZVC[2] = 0;
							NZVC[1] = 0;
							NZVC[0] = 0;
						end
				3'b111: begin
							Result = ~A;
							NZVC[3] = Result[7];
							if (Result==0)
								NZVC[2] = 1;
							else
								NZVC[2] = 0;
							NZVC[1] = 0;
							NZVC[0] = 0;
						end	
				default: begin
							Result = 8'hXX;
							NZVC = 4'hX; 
						end
				endcase	
		end	
	
endmodule