`timescale 1ns/1ps
`include "ALUa.v"
`include "ALUb.v"
`include "lib.v"

module comp_tb;

  // Inputs
  reg [7:0] A, B;
  reg [2:0] ALU_Sel;

  // Outputs
  wire [3:0] F_sys1, F_sys2;
  wire [7:0] R_sys1, R_sys2;

  // Instantiate the two implementations
  alub DUT(.Result(R_sys1), .NZVC(F_sys1), .A(A), .B(B), .ALU_Sel(ALU_Sel));  // Structural Model = Developer's File
  alub REF(.Result(R_sys2), .NZVC(F_sys2), .A(A), .B(B), .ALU_Sel(ALU_Sel));  // Behavioral Model = Architect's File
  
  // Stimulus generation
  initial begin
    $display("A 	 B  	  Sel | Result   NZVC - Test");
    //Number range -128 to 127
    
    A = 0; B = 0; ALU_Sel = 0; // Initialize inputs
    #10; // Wait a bit
    $write("%b %b %b | %b %b", A, B, ALU_Sel, R_sys1, F_sys1);
    if(F_sys1 == F_sys2) $display(" - PASS"); else $display(" FAIL");

    // Test Case 1: Adder
    A = 1; B = 5; ALU_Sel = 0;
    #10; // Wait a bit
    $write("%b %b %b | %b %b", A, B, ALU_Sel, R_sys1, F_sys1);
    if(F_sys1 == F_sys2) $display(" - PASS"); else $display(" FAIL");
    
    // Test Case 2: Adder
    A = 100; B = 30; ALU_Sel = 0;
    #10; // Wait a bit
    $write("%b %b %b | %b %b", A, B, ALU_Sel, R_sys1, F_sys1);
    if(F_sys1 == F_sys2) $display(" - PASS"); else $display(" FAIL");
    
    // Test Case 3: Adder
    A = 100; B = -120; ALU_Sel = 0;
    #10; // Wait a bit
    $write("%b %b %b | %b %b", A, B, ALU_Sel, R_sys1, F_sys1);
    if(F_sys1 == F_sys2) $display(" - PASS"); else $display(" FAIL");
    
    // Test Case 4: Increment
    A = 100; B = 0; ALU_Sel = 1;
    #10; // Wait a bit
    $write("%b %b %b | %b %b", A, B, ALU_Sel, R_sys1, F_sys1);
    if(F_sys1 == F_sys2) $display(" - PASS"); else $display(" FAIL");
    
    // Test Case 5: Increment
    A = 127; B = 0; ALU_Sel = 1;
    #10; // Wait a bit
    $write("%b %b %b | %b %b", A, B, ALU_Sel, R_sys1, F_sys1);
    if(F_sys1 == F_sys2) $display(" - PASS"); else $display(" FAIL");
    
    // Test Case 6: Increment
    A = -1; B = 0; ALU_Sel = 1;
    #10; // Wait a bit
    $write("%b %b %b | %b %b", A, B, ALU_Sel, R_sys1, F_sys1);
    if(F_sys1 == F_sys2) $display(" - PASS"); else $display(" FAIL");
    
    // Test Case 7: Increment
    A = -10; B = 0; ALU_Sel = 1;
    #10; // Wait a bit
    $write("%b %b %b | %b %b", A, B, ALU_Sel, R_sys1, F_sys1);
    if(F_sys1 == F_sys2) $display(" - PASS"); else $display(" FAIL");
    
    // Test Case 8: Subtractor
    A = 17; B = 40; ALU_Sel = 2;
    #10; // Wait a bit
    $write("%b %b %b | %b %b", A, B, ALU_Sel, R_sys1, F_sys1);
    if(F_sys1 == F_sys2) $display(" - PASS"); else $display(" FAIL");
    
    // Test Case 9: Subtractor
    A = 73; B = 40; ALU_Sel = 2;
    #10; // Wait a bit
    $write("%b %b %b | %b %b", A, B, ALU_Sel, R_sys1, F_sys1);
    if(F_sys1 == F_sys2) $display(" - PASS"); else $display(" FAIL");
    
    // Test Case 10: Subtractor
    A = 73; B = -40; ALU_Sel = 2;
    #10; // Wait a bit
    $write("%b %b %b | %b %b", A, B, ALU_Sel, R_sys1, F_sys1);
    if(F_sys1 == F_sys2) $display(" - PASS"); else $display(" FAIL");
    
    // Test Case 11: Subtractor
    A = 73; B = -93; ALU_Sel = 2;
    #10; // Wait a bit
    $write("%b %b %b | %b %b", A, B, ALU_Sel, R_sys1, F_sys1);
    if(F_sys1 == F_sys2) $display(" - PASS"); else $display(" FAIL");
    
    // Test Case 12: Subtractor
    A = -9; B = -93; ALU_Sel = 2;
    #10; // Wait a bit
    $write("%b %b %b | %b %b", A, B, ALU_Sel, R_sys1, F_sys1);
    if(F_sys1 == F_sys2) $display(" - PASS"); else $display(" FAIL");
    
    // Test Case 13: Decrement
    A = -61; B = 0; ALU_Sel = 3;
    #10; // Wait a bit
    $write("%b %b %b | %b %b", A, B, ALU_Sel, R_sys1, F_sys1);
    if(F_sys1 == F_sys2) $display(" - PASS"); else $display(" FAIL");
    
    // Test Case 14: Decrement
    A = 1; B = 0; ALU_Sel = 3;
    #10; // Wait a bit
    $write("%b %b %b | %b %b", A, B, ALU_Sel, R_sys1, F_sys1);
    if(F_sys1 == F_sys2) $display(" - PASS"); else $display(" FAIL");
    
    // Test Case 15: Decrement
    A = 7; B = 0; ALU_Sel = 3;
    #10; // Wait a bit
    $write("%b %b %b | %b %b", A, B, ALU_Sel, R_sys1, F_sys1);
    if(F_sys1 == F_sys2) $display(" - PASS"); else $display(" FAIL");
    
    // Test Case 16: Decrement
    A = -128; B = 0; ALU_Sel = 3;
    #10; // Wait a bit
    $write("%b %b %b | %b %b", A, B, ALU_Sel, R_sys1, F_sys1);
    if(F_sys1 == F_sys2) $display(" - PASS"); else $display(" FAIL");
    
    // Test Case 17: AND
    A = 78; B = 121; ALU_Sel = 4;
    #10; // Wait a bit
    $write("%b %b %b | %b %b", A, B, ALU_Sel, R_sys1, F_sys1);
    if(F_sys1 == F_sys2) $display(" - PASS"); else $display(" FAIL");
    
    // Test Case 18: AND
    A = 0; B = -1; ALU_Sel = 4;
    #10; // Wait a bit
    $write("%b %b %b | %b %b", A, B, ALU_Sel, R_sys1, F_sys1);
    if(F_sys1 == F_sys2) $display(" - PASS"); else $display(" FAIL");
    
    // Test Case 19: OR
    A = 78; B = 121; ALU_Sel = 5;
    #10; // Wait a bit
    $write("%b %b %b | %b %b", A, B, ALU_Sel, R_sys1, F_sys1);
    if(F_sys1 == F_sys2) $display(" - PASS"); else $display(" FAIL");
    
    // Test Case 20: OR
    A = 0; B = -1; ALU_Sel = 5;
    #10; // Wait a bit
    $write("%b %b %b | %b %b", A, B, ALU_Sel, R_sys1, F_sys1);
    if(F_sys1 == F_sys2) $display(" - PASS"); else $display(" FAIL");
    
    // Test Case 21: XOR
    A = 78; B = 121; ALU_Sel = 6;
    #10; // Wait a bit
    $write("%b %b %b | %b %b", A, B, ALU_Sel, R_sys1, F_sys1);
    if(F_sys1 == F_sys2) $display(" - PASS"); else $display(" FAIL");
    
    // Test Case 22: XOR
    A = 0; B = -1; ALU_Sel = 6;
    #10; // Wait a bit
    $write("%b %b %b | %b %b", A, B, ALU_Sel, R_sys1, F_sys1);
    if(F_sys1 == F_sys2) $display(" - PASS"); else $display(" FAIL");
    
    // Test Case 23: NOT
    A = 78; B = 0; ALU_Sel = 7;
    #10; // Wait a bit
    $write("%b %b %b | %b %b", A, B, ALU_Sel, R_sys1, F_sys1);
    if(F_sys1 == F_sys2) $display(" - PASS"); else $display(" FAIL");
    
    // Test Case 24: NOT
    A = -1; B = 0; ALU_Sel = 7;
    #10; // Wait a bit
    $write("%b %b %b | %b %b", A, B, ALU_Sel, R_sys1, F_sys1);
    if(F_sys1 == F_sys2) $display(" - PASS"); else $display(" FAIL");

    // End simulation
    $finish;
  end
    
endmodule