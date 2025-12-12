`timescale 1ns/1ps

module count8b (output reg [7:0] CNT, 
                input wire clk, res, EN, load,
                input wire [7:0] CNT_In);
  
  always @ (posedge clk or negedge res)
  	begin: COUNTER	  	
  		if (!res)
  			CNT <= 8'h00;
  		else if (EN)
  			if (load)
  				CNT <= CNT_In;	
  			else
  				CNT <= CNT + 1; 		
  	end
  
endmodule