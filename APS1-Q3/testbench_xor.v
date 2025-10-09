`timescale 1ns/1ps
`include "XOR.v"
`include "xorb.v"
module comp_tb;

  // Inputs
  reg A, B;

  // Outputs
  wire F_sys1, F_sys2;

  // Instantiate the two implementations
  xora DUT(.A(A), .B(B), .F(F_sys1));  // Structural Model = Developer's File
  xorb REF(.A(A), .B(B), .F(F_sys2));  // Behavioral Model = Architect's File
  
  // Stimulus generation
  initial begin
    $display("A B | F - Test");
    
    A = 0; B = 0; // Initialize inputs
    #10; // Wait a bit
    $write("%b %b | %b", A, B, F_sys1);
    if(F_sys1 == F_sys2) $display(" - PASS"); else $display(" FAIL");

    // Test Case 1
    A = 1; B = 0;
    #10; // Wait a bit
    $write("%b %b | %b", A, B, F_sys1);
    if(F_sys1 == F_sys2) $display(" - PASS"); else $display(" FAIL");

    // Test Case 2
    A = 0; B = 1;
    #10; // Wait a bit
    $write("%b %b | %b", A, B, F_sys1);
    if(F_sys1 == F_sys2) $display(" - PASS"); else $display(" FAIL");


    // Test Case 3
    A = 1; B = 1;
    #10; // Wait a bit
    $write("%b %b | %b", A, B, F_sys1);
    if(F_sys1 == F_sys2) $display(" - PASS"); else $display(" FAIL");

    // End simulation
    $finish;
  end
    
endmodule