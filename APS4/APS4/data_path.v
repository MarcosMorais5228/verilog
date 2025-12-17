`include "ALU.v"
`include "registers.v"
`include "count8.v"

module data_path 
	(output reg [7:0] address,
	 output reg [7:0] to_memory,
	 output reg [7:0] IR_out,
	 output reg [3:0] CCR_Result, 
	 input wire [7:0] from_memory,
	 input wire [2:0] ALU_Sel,
	 input wire [1:0] Bus1_Sel, Bus2_Sel,
	 input wire IR_Load, MAR_Load, PC_Load, A_Load, B_Load, CCR_Load,  
     input wire Clk, Reset,
	 input wire PC_Inc);
     
     reg [7:0] Bus1, Bus2;
     wire [7:0] PC, MAR, A, B, ALU_Result;
     
     always @ (Bus1_Sel, PC, A, B) 
     	begin: MUX_BUS1
			case (Bus1_Sel)
				2'b00 : Bus1 = PC;
				2'b01 : Bus1 = A;
				2'b10 : Bus1 = B; 
				default : Bus1 = 8'hXX;
			endcase 
		end
		
	 always @ (Bus2_Sel, ALU_Result, Bus1, from_memory) 
		begin: MUX_BUS2
			case (Bus2_Sel)
				2'b00 : Bus2 = ALU_Result;
				2'b01 : Bus2 = Bus1;
				2'b10 : Bus2 = from_memory; 
				default : Bus2 = 8'hXX;
			endcase 
		end	
		
	 always @ (Bus1, MAR) 
	 	begin
			to_memory = Bus1;
			address = MAR; 
		end
  
	// Complement the module
	wire [7:0] IR_val;
	wire [3:0] CCR_valF;

	// < --- Instâncias dos registradores IR, MAR, PC, A, B --- >
	reg8 IR_Reg (.Reg_Out(IR_val), .Reg_In(Bus2), .res(Reset), .EN(IR_Load), .clk(Clk));
	reg8 MAR_Reg (.Reg_Out(MAR), .Reg_In(Bus2), .res(Reset), .EN(MAR_Load), .clk(Clk));
	// reg8 PC_Reg (.Reg_Out(PC), .Reg_In(Bus2), .res(Reset), .EN(PC_Load), .clk(Clk));
	count8 PC_Count (.CNT(PC), .CNT_In(Bus2), .res(Reset), .load(PC_Load), .inc(PC_Inc), .clk(Clk));
	reg8 A_Reg (.Reg_Out(A), .Reg_In(Bus2), .res(Reset), .EN(A_Load), .clk(Clk));
	reg8 B_Reg (.Reg_Out(B), .Reg_In(Bus2), .res(Reset), .EN(B_Load), .clk(Clk));

	// < --- ALU --- >
	wire [3:0] CCR_val;

	alu ALU (
		.Result(ALU_Result),
		.NZVC(CCR_val),
		.A(A),
		.B(B),
		.ALU_Sel(ALU_Sel)
	);

	// < --- CCR --- >
	reg4 CCR_Reg (.Reg_Out(CCR_valF), .Reg_In(CCR_val), .res(Reset), .EN(CCR_Load), .clk(Clk));

	always @ (*) begin
		CCR_Result = CCR_valF;
		IR_out = IR_val;
	end

  
endmodule