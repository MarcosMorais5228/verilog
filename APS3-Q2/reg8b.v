`timescale 1ns/1ps

module reg8b (output reg [7:0] Reg_Out, 
              input wire clk, res, EN,
              input wire [7:0] Reg_In);
  
  always @ (posedge clk or negedge res)
  	begin: REGISTER	  	
  		if (!res)
  			Reg_Out <= 8'h00;
  		else if (EN)
  			Reg_Out <= Reg_In;
  		
  	end
  
endmodule