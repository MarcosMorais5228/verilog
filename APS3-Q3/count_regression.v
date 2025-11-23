`timescale 1ns/1ps
`include "count8a.v"
`include "count8b.v"
`include "lib.v"
`include "componentes_new.v"

module count_tb;

	// Inputs
	reg [7:0] CNT_In_TB;
	reg clk_TB, res_TB, EN_TB, load_TB;
	
	// Outputs
    wire [7:0] CNT1_TB, CNT2_TB;
	
	integer i;

	// count8b is provided by "The Architect", count8a by "The Developer Teams" 
    count8a DUT(.CNT(CNT1_TB), .clk(clk_TB), .res(res_TB), .EN(EN_TB), .load(load_TB), .CNT_In(CNT_In_TB));
	count8b REF(.CNT(CNT2_TB), .clk(clk_TB), .res(res_TB), .EN(EN_TB), .load(load_TB), .CNT_In(CNT_In_TB));


  	initial
        begin
   			$display("Res EN Load CNT_In   | CNT      - Test");
        end
  
	initial
		begin     
            //$dumpfile("count_tb.vcd");
			//$dumpvars(0,count_tb);
          
			clk_TB=1'b0;
          	#2; // Wait a bit
         	$write("%b   %b   %b   %b | %b", res_TB, EN_TB, load_TB, CNT_In_TB, CNT1_TB);
          	if(CNT1_TB == CNT2_TB) $display(" - PASS"); else $display(" FAIL");
          	
          	for (i=0; i<22; i=i+1)
				begin
					#18 clk_TB = ~clk_TB;
                  	#2; // Wait a bit
         			$write("%b   %b   %b   %b | %b", res_TB, EN_TB, load_TB, CNT_In_TB, CNT1_TB);
          			if(CNT1_TB == CNT2_TB) $display(" - PASS"); else $display(" FAIL");
				end
		end
  
  	initial
		begin        		      
				 res_TB=0; EN_TB=1; load_TB=0; CNT_In_TB = 8'h00;
            #4   res_TB = 1; 
			#95  load_TB=1; CNT_In_TB = 8'h11;
          	#40  load_TB=0; CNT_In_TB = 8'h00;
          	#60  EN_TB = 0;
          	#100 EN_TB = 1; 
		end

endmodule