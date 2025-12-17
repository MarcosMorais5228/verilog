`timescale 1ns/1ps
`default_nettype none

module tb_memory;
    reg clk, reset, write;
    reg [7:0] address;
    reg [7:0] data_in;

    reg [7:0] port_in_00, port_in_01, port_in_02, port_in_03;
    reg [7:0] port_in_04, port_in_05, port_in_06, port_in_07;
    reg [7:0] port_in_08, port_in_09, port_in_10, port_in_11;
    reg [7:0] port_in_12, port_in_13, port_in_14, port_in_15;

    wire [7:0] data_out;

    wire [7:0] port_out_00, port_out_01, port_out_02, port_out_03;
    wire [7:0] port_out_04, port_out_05, port_out_06, port_out_07;
    wire [7:0] port_out_08, port_out_09, port_out_10, port_out_11;
    wire [7:0] port_out_12, port_out_13, port_out_14, port_out_15;

    memory u_memory (
        .reset      (reset),
        .clk        (clk),
        .write      (write),
        .address    (address),
        .data_in    (data_in),
        .data_out   (data_out),
        .port_out_00(port_out_00), .port_out_01(port_out_01), .port_out_02(port_out_02), .port_out_03(port_out_03),
        .port_out_04(port_out_04), .port_out_05(port_out_05), .port_out_06(port_out_06), .port_out_07(port_out_07),
        .port_out_08(port_out_08), .port_out_09(port_out_09), .port_out_10(port_out_10), .port_out_11(port_out_11),
        .port_out_12(port_out_12), .port_out_13(port_out_13), .port_out_14(port_out_14), .port_out_15(port_out_15),

        .port_in_00(port_in_00), .port_in_01(port_in_01), .port_in_02(port_in_02), .port_in_03(port_in_03),
        .port_in_04(port_in_04), .port_in_05(port_in_05), .port_in_06(port_in_06), .port_in_07(port_in_07),
        .port_in_08(port_in_08), .port_in_09(port_in_09), .port_in_10(port_in_10), .port_in_11(port_in_11),
        .port_in_12(port_in_12), .port_in_13(port_in_13), .port_in_14(port_in_14), .port_in_15(port_in_15)
    );

    localparam CLK_PERIOD = 10;
    always #(CLK_PERIOD/2) clk = ~clk;

    initial begin
        $dumpfile("tb_memory.vcd");
        $dumpvars(0, tb_memory);

        clk = 0;
        reset = 1;
        write = 0;
        address = 0;
        data_in = 0;
        port_in_00 = 0; port_in_01 = 0; port_in_02 = 0; port_in_03 = 0;

        #(CLK_PERIOD*2);
        reset = 0;
        #(CLK_PERIOD);

        // --- CASO DE USO (i): Escrita na RAM (Endereço 0x80) ---
        $display("[Time %0t] Teste RAM: Escrevendo 0x55 no endereco 0x80", $time);
        address = 8'h80;   
        data_in = 8'h55;   
        write   = 1;       
        @(posedge clk);    
        write   = 0;       
        
        // --- CASO DE USO (ii): Leitura da RAM ---
        address = 8'h00; 
        @(posedge clk);
        address = 8'h80; 
        @(posedge clk);
        #10; 

        // --- CASO DE USO (iii): Escrita em Porta de Saída (Endereço IO: ex 0xE0) ---
        $display("[Time %0t] Teste IO Saida: Escrevendo 0xAA na Port_Out_00 (Addr 0xE0)", $time);
        address = 8'hE0;
        data_in = 8'hAA;
        write   = 1;
        @(posedge clk);
        write   = 0;
        #10;

        // --- Teste IO Entrada (Leitura da Port_In_00 via endereço 0xF0) ---
        $display("[Time %0t] Teste IO Entrada: Lendo Port_In_00 (Addr 0xF0)", $time);
        port_in_00 = 8'hF1; 
        address    = 8'hF0; 
        write      = 0;
        @(posedge clk);
        #10;
        
        repeat(5) @(posedge clk);
        $finish;
    end

endmodule
`default_nettype wire