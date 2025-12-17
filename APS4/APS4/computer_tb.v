`timescale 1ns / 1ps
`include "computer.v"

module computer_tb;

    reg clk;
    reg reset;
    
    reg [7:0] port_in_00, port_in_01, port_in_02, port_in_03;
    reg [7:0] port_in_04, port_in_05, port_in_06, port_in_07;
    reg [7:0] port_in_08, port_in_09, port_in_10, port_in_11;
    reg [7:0] port_in_12, port_in_13, port_in_14, port_in_15;

    wire [7:0] port_out_00, port_out_01, port_out_02, port_out_03;
    wire [7:0] port_out_04, port_out_05, port_out_06, port_out_07;
    wire [7:0] port_out_08, port_out_09, port_out_10, port_out_11;
    wire [7:0] port_out_12, port_out_13, port_out_14, port_out_15;

    computer DUT (
        
        .port_out_00(port_out_00), .port_out_01(port_out_01), .port_out_02(port_out_02), .port_out_03(port_out_03),
        .port_out_04(port_out_04), .port_out_05(port_out_05), .port_out_06(port_out_06), .port_out_07(port_out_07),
        .port_out_08(port_out_08), .port_out_09(port_out_09), .port_out_10(port_out_10), .port_out_11(port_out_11),
        .port_out_12(port_out_12), .port_out_13(port_out_13), .port_out_14(port_out_14), .port_out_15(port_out_15),
        
        .port_in_00(port_in_00), .port_in_01(port_in_01), .port_in_02(port_in_02), .port_in_03(port_in_03),
        .port_in_04(port_in_04), .port_in_05(port_in_05), .port_in_06(port_in_06), .port_in_07(port_in_07),
        .port_in_08(port_in_08), .port_in_09(port_in_09), .port_in_10(port_in_10), .port_in_11(port_in_11),
        .port_in_12(port_in_12), .port_in_13(port_in_13), .port_in_14(port_in_14), .port_in_15(port_in_15),
        
        .clk(clk),
        .reset(reset)
    );

   
    always #5 clk = ~clk;

   
    initial begin
        $dumpfile("computer.vcd");
        $dumpvars(0, computer_tb);
        clk = 0;
        reset = 0; 

        port_in_00 = 8'h0E; port_in_01 = 0; port_in_02 = 0; port_in_03 = 0;
        port_in_04 = 0; port_in_05 = 0; port_in_06 = 0; port_in_07 = 0;
        port_in_08 = 0; port_in_09 = 0; port_in_10 = 0; port_in_11 = 0;
        port_in_12 = 0; port_in_13 = 0; port_in_14 = 0; port_in_15 = 0;

        
        #10 reset = 1; 
        $display("Sistema resetado. Iniciando execução...");

        #400; 
        
        $display("Fim da simulação.");
        $finish;
    end
    
endmodule