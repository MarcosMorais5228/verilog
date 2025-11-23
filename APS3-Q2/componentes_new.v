`timescale 1ps/1ps

module dlatch (output reg Q,Qn, 
               input wire C,D);
  
  always @ (C or D)
  	begin
  		if (C==1'b1)
  			begin
  				Q <= D;
  				Qn <= ~D;
  	    	end
  	end
  
endmodule

module dflipflop (output reg Q,Qn, 
                  input wire Clock, Reset, Preset, D);
  
  always @ (posedge Clock or negedge Reset or negedge Preset)
  	begin
	  	if (!Reset)
  			begin
  				Q <= 1'b0;
  				Qn <= 1'b1;
  			end
  		else if (!Preset)
  			begin
  				Q <= 1'b1;
  				Qn <= 1'b0;
  			end
  		else
  			begin
  				Q <= D;
  				Qn <= ~D;
  			end
  	end
endmodule