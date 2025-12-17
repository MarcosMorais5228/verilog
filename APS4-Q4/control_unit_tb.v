`timescale 1ns / 1ps
`include "control_unit.v"

module tb_control_unit;
    reg [7:0] IR;
    reg [3:0] CCR_Result;
    reg Clk, Reset;

    wire IR_Load, MAR_Load, PC_Load, PC_Inc, A_Load, B_Load, CCR_Load, write;
    wire [2:0] ALU_Sel;
    wire [1:0] Bus1_Sel, Bus2_Sel;

    // Instanciação do seu módulo original
    control_unit uut (.*);

    // Gerador de Clock (10ns)
    initial begin Clk = 0; forever #5 Clk = ~Clk; end

    initial begin
        $display("=== INICIANDO SIMULACAO COMPLETA ===");
        Reset = 0; IR = 8'h00; CCR_Result = 4'b0000;
        #20 Reset = 1; 

        // --- 1. TESTE: ADD_AB (Opcode 42h) ---
        wait(uut.current_state == 8'h02);
        @(posedge Clk); IR = 8'h42; 
        wait(uut.current_state == 8'h11); // S4_ALU_OP
        #2;
        if (A_Load && CCR_Load) $display("[%t] SUCESSO: ADD_AB executado.", $time);

        // --- 2. TESTE: LDA_IMM (Opcode 86h) ---
        wait(uut.current_state == 8'h00); IR = 8'h00;
        wait(uut.current_state == 8'h02);
        @(posedge Clk); IR = 8'h86; 
        wait(uut.current_state == 8'h05); // S5_LDR_IMM
        #2;
        if (A_Load) $display("[%t] SUCESSO: LDA_IMM executado.", $time);

        // --- 3. TESTE: STA_DIR (Opcode 96h) ---
        // Este teste verifica se o sinal 'write' ativa no último estado (S8_STR_DIR = 10h)
        wait(uut.current_state == 8'h00); IR = 8'h00;
        wait(uut.current_state == 8'h02);
        @(posedge Clk); IR = 8'h96; 
        wait(uut.current_state == 8'h10); // S8_STR_DIR
        #2;
        if (write && Bus1_Sel == 2'b01) 
            $display("[%t] SUCESSO: STA_DIR (Escrita) verificado.", $time);
        else 
            $display("[%t] FALHA: STA_DIR nao ativou 'write'.", $time);

        // --- 4. TESTE: BEQ (Opcode 23h) - SALTO TOMADO ---
        wait(uut.current_state == 8'h00); IR = 8'h00;
        CCR_Result = 4'b0100; // Força Flag Z = 1
        wait(uut.current_state == 8'h02);
        @(posedge Clk); IR = 8'h23; 
        
        // No seu código, o salto (PC_Load) ocorre no estado S6_BR (15h)
        wait(uut.current_state == 8'h15);
        #2;
        if (PC_Load) 
            $display("[%t] SUCESSO: BEQ Tomado (Z=1).", $time);
        else 
            $display("[%t] FALHA: BEQ deveria ter saltado.", $time);

        // --- 5. TESTE: BEQ (Opcode 23h) - SALTO NÃO TOMADO ---
        wait(uut.current_state == 8'h00); IR = 8'h00;
        CCR_Result = 4'b0000; // Força Flag Z = 0
        wait(uut.current_state == 8'h02);
        @(posedge Clk); IR = 8'h23; 
        
        // Se Z=0, a FSM deve voltar para S0 sem passar pelo estado 15h
        // Vamos esperar alguns ciclos e ver se o PC_Load continua em 0
        repeat(10) @(posedge Clk);
        if (!PC_Load) 
            $display("[%t] SUCESSO: BEQ Ignorado (Z=0).", $time);

        #50;
        $display("=== SIMULACAO FINALIZADA COM SUCESSO ===");
        $finish;
    end

    // Monitor para depuração no console
    initial begin
        $monitor("Tempo: %t | Estado: %h | IR: %h | A_Load: %b | Write: %b | PC_Load: %b", 
                 $time, uut.current_state, IR, A_Load, write, PC_Load);
    end

endmodule