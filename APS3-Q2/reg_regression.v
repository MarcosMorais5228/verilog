`timescale 1ns/1ps
`include "reg8a.v"
`include "reg8b.v"
`include "componentes_new.v"
`include "lib.v"

module reg_tb;

	// Input
	reg [7:0] Reg_In_TB;
	reg clk_TB, res_TB, EN_TB;
	
	// Output
	wire [7:0] Reg1_Out_TB, Reg2_Out_TB;
	
	integer i;

	// reg8b is provided by "The Architect", reg8a by "The Developer Teams" 
    reg8a DUT(.Reg_Out(Reg1_Out_TB), .clk(clk_TB), .res(res_TB), .EN(EN_TB), .Reg_In(Reg_In_TB));
    reg8b REF(.Reg_Out(Reg2_Out_TB), .clk(clk_TB), .res(res_TB), .EN(EN_TB), .Reg_In(Reg_In_TB));


	initial
        begin
   			$display("Res EN Reg_In   | Reg_Out      - Test");
        end

	initial
		begin     
          //$dumpfile("reg_tb.vcd");
          //$dumpvars(0,reg_tb);
          
			clk_TB=1'b0;
			#2; // Wait a bit
         	$write("%b   %b   %b | %b", res_TB, EN_TB, Reg_In_TB, Reg1_Out_TB);
          	if(Reg1_Out_TB == Reg2_Out_TB) $display(" - PASS"); else $display(" FAIL");
          	
            for (i=0; i<16; i=i+1)
				begin
					#8 clk_TB = ~clk_TB;
					#2; // Wait a bit
         			$write("%b   %b   %b | %b", res_TB, EN_TB, Reg_In_TB, Reg1_Out_TB);
          			if(Reg1_Out_TB == Reg2_Out_TB) $display(" - PASS"); else $display(" FAIL");
				end
		end
  
  	initial
		begin
				 res_TB=0; EN_TB=0; Reg_In_TB = 8'h00;
            #4   res_TB = 1; 
			#95  EN_TB=1; Reg_In_TB = 8'h77;
          	#20  EN_TB=0; Reg_In_TB = 8'h00;	
		end

endmodule