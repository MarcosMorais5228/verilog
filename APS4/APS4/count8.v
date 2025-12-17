`timescale 1ns/1ps

module count8 (output reg [7:0] CNT, 
                input wire clk, res, load, inc,
                input wire [7:0] CNT_In);
  
  always @ (posedge clk or negedge res)
  	begin: COUNTER	  	
  		if (!res)
  			CNT <= 8'h00;
  		else
  			if (load)
  				CNT <= CNT_In;	
  			else
  				CNT <= CNT + inc;
  	end
  
endmodule