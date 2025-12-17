`timescale 1ns / 1ps
`include "control_unit.v"

module control_unit_tb;

    // --- Sinais internos para o Testbench ---
    reg Clk;
    reg Reset;
    // IR_tb será usado para simular tanto o Opcode quanto o Dado/Endereço
    reg [7:0] IR_tb;         
    reg [3:0] CCR_Result_tb; 

    // --- Sinais de Saída da Unidade de Controle (DUT) ---
    wire IR_Load, MAR_Load;
    wire PC_Load, PC_Inc;
    wire A_Load, B_Load;
    wire CCR_Load;
    wire [2:0] ALU_Sel;
    wire [1:0] Bus1_Sel, Bus2_Sel;
    wire write;

    // --- Parâmetros de Opcodes ---
    parameter [7:0] BRZ_DIR = 8'h30; 
    
    // --- Instanciação da Unidade de Controle (DUT) ---
    control_unit DUT (
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
        .IR(IR_tb),
        .CCR_Result(CCR_Result_tb),
        .Clk(Clk),
        .Reset(Reset)
    );

    // --- Memória Simulada ---
    reg [7:0] instruction_stream [0:255]; 
    reg [7:0] PC_sim;
    
    // --- Gerador de Clock ---
    parameter CLK_PERIOD = 10;
    initial begin
        Clk = 0;
        forever #(CLK_PERIOD / 2) Clk = ~Clk;
    end

    // --- Lógica de Simulação Principal (Setup) ---
    initial begin
        // --- Programa de Teste na Memória Simulada ---
        instruction_stream[8'h00] = 8'h01; // LDA_IMM
        instruction_stream[8'h01] = 8'hAA; 
        instruction_stream[8'h02] = 8'h11; // ADD_IMM
        instruction_stream[8'h03] = 8'h05;
        instruction_stream[8'h04] = 8'h03; // STA_DIR
        instruction_stream[8'h05] = 8'h01; 
        instruction_stream[8'h06] = 8'h50; 
        instruction_stream[8'h07] = 8'h30; // BRZ_DIR
        instruction_stream[8'h08] = 8'h00; // Endereço Alto (ignoramos)
        instruction_stream[8'h09] = 8'h80; // Endereço Baixo/Destino do Salto
        instruction_stream[8'h80] = 8'hFF; // END (Novo Destino)

        $dumpfile("control_unit_tb.vcd");
        $dumpvars(0, control_unit_tb);
        
        // Reset
        Reset = 0;
        IR_tb = 8'hFF;
        CCR_Result_tb = 4'b0000;
        PC_sim = 8'h00; 

        #10 Reset = 1; 
        #20; 
        
        $display("--- Start Simulation ---");
        
        repeat (50) @(posedge Clk);
        
        $display("--- End Simulation ---");
        $finish;
    end
    
    // --- Lógica Corrigida para simular a busca de instrução/operando ---
    always @(posedge Clk) begin
        
        // --- Leitura do Dado/Instrução da Memória para o Barramento/IR_tb ---
        // Bus2_Sel == 2'b10 (0x2) significa que a memória está colocando um dado no barramento
        // (Este dado precisa ser capturado pelo IR_tb para ser usado pelo PC_Load ou B_Load)
        if (Bus2_Sel == 2'b10) begin
             // Se a memória está lendo, o IR_tb recebe o dado no PC atual.
             IR_tb <= instruction_stream[PC_sim];
        end

        // 1. Carga e Incremento do PC (Prioridade PC_Load > PC_Inc)
        if (PC_Load) begin
            // PC_Load ativo (S6_BRZ_DIR): PC carrega o valor lido da memória (que está no IR_tb)
            PC_sim <= IR_tb; 
        end else if (PC_Inc) begin
            PC_sim <= PC_sim + 1;
        end
        
        // 2. Configurar CCR para teste de BRZ (PC=08, IR=30)
        // Forçamos Z=1 no momento em que o opcode BRZ (30) está no IR_tb e PC=08
        if (PC_sim == 8'h08 && IR_tb == BRZ_DIR) begin
             CCR_Result_tb <= 4'b0100; // Z=1 (Desvio Tomado)
        end else begin
             CCR_Result_tb <= 4'b0000;
        end
        
        $display("Time: %0d | PC: %h | IR: %h | IR_Load: %b | B_Load: %b | PC_Load: %b | PC_Inc: %b | write: %b | CCR_Z: %b",
            $time, PC_sim, IR_tb, IR_Load, B_Load, PC_Load, PC_Inc, write, CCR_Result_tb[2]);
    end

endmodule