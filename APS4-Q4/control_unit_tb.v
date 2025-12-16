`timescale 1ns / 1ps
`include "ALUb.v"
`include "control_unit.v"
`include "count8b.v"
`include "reg8b.v"

module control_unit_tb;

    // --- SINAIS DE CONTROLE (OUTPUTS do UDC, DECLARADOS COMO WIRE AQUI) ---
    // O módulo 'control_unit' dirige esses sinais (driver).
    wire IR_Load, MAR_Load, PC_Load, PC_Inc, A_Load, B_Load, CCR_Load, write;
    wire [2:0] ALU_Sel;
    wire [1:0] Bus1_Sel, Bus2_Sel;

    // --- SINAIS DE ENTRADA do UDC (DECLARADOS COMO REG AQUI) ---
    // O Testbench dirige esses sinais.
    reg  [7:0] IR;
    reg  [3:0] CCR_Result; // Flags: [3]=N, [2]=Z, [1]=V, [0]=C
    reg  Clk, Reset;

    // --- Instanciação do Módulo de Controle (UDC) ---
    control_unit UDC_Inst (
        .IR_Load(IR_Load), 
        .MAR_Load(MAR_Load), 
        .PC_Load(PC_Load), 
        .PC_Inc(PC_Inc), 
        .A_Load(A_Load), 
        .B_Load(B_Load),
        .CCR_Load(CCR_Load),
        .ALU_Sel(ALU_Sel),
        .Bus1_Sel(Bus1_Sel), 
        .Bus2_Sel(Bus2_Sel),
        .write(write), 
        .IR(IR), 
        .CCR_Result(CCR_Result), 
        .Clk(Clk), 
        .Reset(Reset)
    );

    // --- Clock Generator ---
    parameter CLK_PERIOD = 10;
    initial begin
        Clk = 0;
        forever #(CLK_PERIOD / 2) Clk = ~Clk;
    end

    // --- Main Test Sequence ---
    initial begin
        // Valores iniciais
        Reset = 1;
        IR = 8'h00;
        CCR_Result = 4'b0000; // N, Z, V, C = 0

        // 1. Reset (Ciclo 0)
        $display("-----------------------------------------");
        $display("START TESTBENCH: INITIAL RESET");
        Reset = 0;
        @(posedge Clk);
        Reset = 1;
        $display("RESET CONCLUIDO. Estado atual: S0_FETCH");
        $display("-----------------------------------------");

        // --- TESTE 1: INSTRUÇÃO LDA_IMM (Immediate Load) ---
        // Sequência: S0 -> S1 -> S2 -> S3 (LDA_IMM) -> S4_LDR_IMM -> S5_LDR_IMM -> S6_LDR_IMM -> S0
        $display("--- TESTE 1: LDA_IMM (8'h86) ---");
        
        // S0_FETCH: MAR <- PC 
        @(posedge Clk);

        // S1_FETCH: IR <- Mem, PC++
        IR = 8'h86; // LDA_IMM
        @(posedge Clk);
        $display("IR carregado: %h. Estado: S2_FETCH", IR);

        // S2_FETCH: MAR <- PC (PC incrementado para o endereço do operando)
        @(posedge Clk);
        
        // S3_DECODE: (Decodifica para S4_LDR_IMM)
        @(posedge Clk);
        $display("Estado: S4_LDR_IMM (Leitura do Operando)");

        // S4_LDR_IMM: B <- Mem[PC], PC++
        // Simula a leitura do dado (Operando = 0xFF). (O IR é reutilizado para simular o dado lido)
        IR = 8'hFF; 
        @(posedge Clk);
        $display("Dado (0xFF) lido. Estado: S5_LDR_IMM");

        // S5_LDR_IMM: A <- B, CCR_Load (LDA_IMM)
        @(posedge Clk);
        $display("Registrador A e CCR carregados. Estado: S6_LDR_IMM");

        // S6_LDR_IMM: NOP (Volta para S0)
        @(posedge Clk);
        $display("Fim da instrução. Próximo estado: S0_FETCH");
        $display("-----------------------------------------");


        // --- TESTE 2: INSTRUÇÃO ADD_AB (ALU Operation) ---
        // Sequência: S0 -> S1 -> S2 -> S3 (ADD_AB) -> S4_ALU_OP -> S5_ALU_OP -> S0
        $display("--- TESTE 2: ADD_AB (8'h42) ---");

        // S0_FETCH: MAR <- PC
        @(posedge Clk);

        // S1_FETCH: IR <- Mem, PC++
        IR = 8'h42; // ADD_AB
        @(posedge Clk);
        $display("IR carregado: %h. Estado: S2_FETCH", IR);

        // S2_FETCH: MAR <- PC (Endereço do próximo operando, mas desnecessário para ADD_AB)
        @(posedge Clk);

        // S3_DECODE: (Decodifica para S4_ALU_OP)
        @(posedge Clk);
        $display("Estado: S4_ALU_OP (Execução da ALU)");

        // S4_ALU_OP: A <- A+B, CCR_Load
        @(posedge Clk);
        $display("ALU executada. Registrador A e CCR carregados. Estado: S5_ALU_OP");

        // S5_ALU_OP: NOP (Volta para S0)
        @(posedge Clk);
        $display("Fim da instrução. Próximo estado: S0_FETCH");
        $display("-----------------------------------------");

        
        // --- TESTE 3: INSTRUÇÃO BEQ (Branch Condicional) - Tomado (Z=1) ---
        // Sequência: S0 -> S1 -> S2 -> S3 (BEQ) -> S4_BR -> S5_BR -> S6_BR -> S0
        $display("--- TESTE 3: BEQ (8'h23) - TOMADO (Z=1) ---");
        
        // Simula Z=1 para que o branch seja tomado
        CCR_Result = 4'b0100; // Z=1

        // S0_FETCH: MAR <- PC
        @(posedge Clk);

        // S1_FETCH: IR <- Mem, PC++
        IR = 8'h23; // BEQ
        @(posedge Clk);
        $display("IR carregado: %h. Estado: S2_FETCH", IR);

        // S2_FETCH: MAR <- PC (Endereço do operando alto do branch)
        @(posedge Clk);

        // S3_DECODE: (Decodifica para S4_BR)
        @(posedge Clk);
        $display("Estado: S4_BR (Leitura do endereço alto)");

        // S4_BR: MAR_H <- Mem[PC], PC++
        @(posedge Clk);

        // S5_BR: MAR_L <- Mem[PC], PC++. Condicional (Z=1) -> S6_BR
        @(posedge Clk);
        $display("Condição (Z=1) satisfeita. Próximo estado: S6_BR");

        // S6_BR: PC <- Endereço do Branch (Simula PC_Load=1)
        @(posedge Clk);
        $display("PC carregado com endereço de branch. Próximo estado: S0_FETCH");

        // Fim da simulação
        @(posedge Clk);
        $display("-----------------------------------------");
        $display("FIM DA SIMULAÇÃO.");
        $stop;
    end

endmodule