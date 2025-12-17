// `include "control_unit_meu.v"
`include "control_unit_marcos.v"
`include "data_path.v"

module cpu 
	(output reg [7:0] address,
	 output reg [7:0] to_memory,
	 output reg write,
	 input wire [7:0] from_memory, 
     input wire clk, reset);
             
  	// Complement the module
	wire [7:0] IR_data;
	wire [2:0] ALU_signal;
	wire [1:0] Bus1_signal, Bus2_signal;
	wire IR_signal, MAR_signal, PC_signal, A_signal, B_signal, CCR_signal, PC_Inc_signal;
	wire [3:0] CCR_data;

	control_unit Unidade_Controle (
		.A_Load(A_signal),
		.B_Load(B_signal),
		.IR_Load(IR_signal),
		.MAR_Load(MAR_signal),
		.PC_Load(PC_signal),
		.PC_Inc(PC_Inc_signal),
		.CCR_Load(CCR_signal),
		.ALU_Sel(ALU_signal),
		.Bus1_Sel(Bus1_signal),
		.Bus2_Sel(Bus2_signal),
		.write(write),
		.IR(IR_data),
		.CCR_Result(CCR_data),
		.Clk(clk),
		.Reset(reset)
	);

	data_path Caminho_Dados (
		.address(address),
		.to_memory(to_memory),
		.IR_out(IR_data),
		.CCR_Result(CCR_data),
		.from_memory(from_memory),
		.ALU_Sel(ALU_signal),
		.Bus1_Sel(Bus1_signal),
		.Bus2_Sel(Bus2_signal),
		.IR_Load(IR_signal),
		.MAR_Load(MAR_signal),
		.PC_Load(PC_signal),
		.PC_Inc(PC_Inc_signal),
		.A_Load(A_signal),
		.B_Load(B_signal),
		.CCR_Load(CCR_signal),
		.Clk(clk),
		.Reset(reset)
	);
endmodule