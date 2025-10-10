`timescale 1ns/1ps
`include "mux_4t1a.v"
`include "mux_4t1b.v"

module comp_tb;

  // Inputs
  reg A_TB, B_TB, C_TB, D_TB;
  reg [1:0] Sel_TB;

  // Outputs
  wire F_sys1, F_sys2;

  // Instantiate the two implementations
  mux_4t1a DUT(.F(F_sys1), .A(A_TB), .B(B_TB), .C(C_TB), .D(D_TB), .Sel(Sel_TB));  // Structural Model = Developer's File
  mux_4t1b REF(.F(F_sys2), .A(A_TB), .B(B_TB), .C(C_TB), .D(D_TB), .Sel(Sel_TB));  // Behavioral Model = Architect's File
  
  // Stimulus generation
  initial begin
    $display("A B C D | S1 S0 | F - Test");
    
    A_TB = 0; B_TB = 1; C_TB=0; D_TB=1; // Initialize inputs
    Sel_TB = 2'b00;
    #4; // Wait a bit
    $write("%b %b %b %b | %b   %b | %b", A_TB, B_TB, C_TB, D_TB, Sel_TB[1], Sel_TB[0], F_sys1);
    if(F_sys1 == F_sys2) $display(" - PASS"); else $display(" FAIL");

    // Test Case 1
    Sel_TB = 2'b01;
    #4; // Wait a bit
    $write("%b %b %b %b | %b   %b | %b", A_TB, B_TB, C_TB, D_TB, Sel_TB[1], Sel_TB[0], F_sys1);
    if(F_sys1 == F_sys2) $display(" - PASS"); else $display(" FAIL");

    // Test Case 2
    Sel_TB = 2'b10;
    #4; // Wait a bit
    $write("%b %b %b %b | %b   %b | %b", A_TB, B_TB, C_TB, D_TB, Sel_TB[1], Sel_TB[0], F_sys1);
    if(F_sys1 == F_sys2) $display(" - PASS"); else $display(" FAIL");


    // Test Case 3
    Sel_TB = 2'b11;
    #4; // Wait a bit
    $write("%b %b %b %b | %b   %b | %b", A_TB, B_TB, C_TB, D_TB, Sel_TB[1], Sel_TB[0], F_sys1);
    if(F_sys1 == F_sys2) $display(" - PASS"); else $display(" FAIL");

    // End simulation
    $finish;
  end
    
endmodule