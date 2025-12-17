module rom_128x8_sync
	(output reg [7:0] data_out,
	 input wire [7:0] address,
	 input wire clk);
	 
	 reg[7:0] ROM[0:127];
	 reg EN;
	 
	 // Mnemonics of Instruction Set
	 // Feel free to add other
	 
	 // Loads and Stores
	 parameter LDA_IMM = 8'h86; // 10000110 Load Register A (Immediate Addressing) 
	 parameter LDA_DIR = 8'h87; // 10000111 Load Register A from memory (RAM or IO) (Direct Addressing)
	 parameter LDB_IMM = 8'h88; // 10001000 Load Register B (Immediate Addressing)
	 parameter LDB_DIR = 8'h89; // 10001001 Load Register B from memory (RAM or IO) (Direct Addressing)
	 parameter STA_DIR = 8'h96; // 10010110 Store Register A to memory (RAM or IO)
	 parameter STB_DIR = 8'h97; // 10010111 Store Register B to memory (RAM or IO)
	 
	 // Data Manipulations
	 parameter ADD_AB  = 8'h42; // 01000010 A <= A + B
	 parameter SUB_AB  = 8'h43; // 01000011 A <= A - B
	 parameter AND_AB  = 8'h44; // 01000100 A <= A & B
	 parameter OR_AB   = 8'h45; // 01000101 A <= A | B
	 parameter INCA    = 8'h46; // 01000110 A <= A + 1
	 parameter INCB    = 8'h47; // 01000111 B <= B + 1
	 parameter DECA	   = 8'h48; // 01001000 A <= A - 1
	 parameter DECB    = 8'h49; // 01001001 B <= B - 1
	 parameter XOR_AB  = 8'h4A; // 01001010 A <= A ^ B
	 parameter NOTA	   = 8'h4B; // 01001011 A <= ~A
	 parameter NOTB    = 8'h4C; // 01001100 B <= ~B
	 
	 // Branches
	 parameter BRA     = 8'h20; // 00100000 Branch Always    to (ROM) Address
	 parameter BMI     = 8'h21; // 00100001 Branch if N == 1 to (ROM) Address
	 parameter BPL     = 8'h22; // 00100010 Branch if N == 0 to (ROM) Address
	 parameter BEQ     = 8'h23; // 00100011 Branch if Z == 1 to (ROM) Address
	 parameter BNE	   = 8'h24; // 00100100 Branch if Z == 0 to (ROM) Address
	 parameter BVS	   = 8'h25; // 00100101 Branch if V == 1 to (ROM) Address 
	 parameter BVC     = 8'h26; // 00100110 Branch if V == 0 to (ROM) Address
	 parameter BCS     = 8'h27; // 00100111 Branch if C == 1 to (ROM) Address
	 parameter BCC     = 8'h28; // 00101000 Branch if C == 0 to (ROM) Address
	 
	 
	 
	 
	 initial
	 	begin
	 		ROM[0] = LDA_DIR; 	// Load the value from address 7 to A
	 		ROM[1] = 8'hF0;		// Address (port_in_0)
	 		ROM[2] = LDB_IMM;	// Load the value 10 to LDB
	 		ROM[3] = 8'h0A;		// Data
	 		ROM[4] = ADD_AB;	// ADD A and B
	 		ROM[5] = STA_DIR;	// Store the sum in address 7
			ROM[6] = 8'h82;		// Address 130
	 	end
	 
	 always @ (address) 
	 	begin
		if ( (address >= 0) && (address <= 127) ) 
			EN = 1'b1;
		else
			EN = 1'b0;
		end
	 	
	 always @ (posedge clk)
	 	if (EN)
		 	data_out = ROM[address];
	 		
endmodule