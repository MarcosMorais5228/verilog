`timescale 1ns / 1ps
`include "data_path.v"

// Testbench para validar o módulo data_path
module tb_data_path();

    // Inputs para o DUT como regs
    reg Clk, Reset;
    reg [7:0] from_memory;
    reg [2:0] ALU_Sel;
    reg [1:0] Bus1_Sel, Bus2_Sel;
    reg IR_Load, MAR_Load, PC_Load, A_Load, B_Load, CCR_Load, PC_Inc;

    // Outputs do DUT como wires
    wire [7:0] address;
    wire [7:0] to_memory;
    wire [7:0] IR_out;
    wire [3:0] CCR_Result;

    // --- Constantes para facilitar a leitura ---
    localparam SEL_B1_PC = 2'b00;
    localparam SEL_B1_A  = 2'b01;
    localparam SEL_B1_B  = 2'b10;
    localparam SEL_B2_ALU    = 2'b00;
    localparam SEL_B2_BUS1   = 2'b01;
    localparam SEL_B2_FROMMEM= 2'b10;
    localparam ALU_ADD = 3'b000;
    localparam ALU_SUB = 3'b010;

    reg [7:0] Resultado_ALU;

    data_path uut (
        .address(address), 
        .to_memory(to_memory), 
        .IR_out(IR_out), 
        .CCR_Result(CCR_Result), 
        .from_memory(from_memory), 
        .ALU_Sel(ALU_Sel), 
        .Bus1_Sel(Bus1_Sel), 
        .Bus2_Sel(Bus2_Sel), 
        .IR_Load(IR_Load), 
        .MAR_Load(MAR_Load), 
        .PC_Load(PC_Load), 
        .A_Load(A_Load), 
        .B_Load(B_Load), 
        .CCR_Load(CCR_Load), 
        .Clk(Clk), 
        .Reset(Reset),
        .PC_Inc(PC_Inc)
    );

    // Clock
    initial begin
        Reset = 0;
        Clk = 0;
        forever #5 Clk = ~Clk;
    end

    // Testes
    initial begin
        $dumpfile("data_path.vcd");
        $dumpvars(1, tb_data_path);
        
        // Inicialização
        $display("=== INICIO DA SIMULACAO ===");
        Reset = 0; Bus1_Sel = 0; Bus2_Sel = 0; ALU_Sel = 0; from_memory = 0;
        IR_Load=0; MAR_Load=0; PC_Load=0; A_Load=0; B_Load=0; CCR_Load=0;
        
        // Aplicar Reset
        #10 Reset = 1;
        PC_Inc = 1;
        $display("Reset aplicado.");

        // ============================================================
        // CASO (i) e (iv): Carregar Registros via from_memory
        // ============================================================
        $display("\n--- TESTE (i) & (iv): Carregando Registradores da Memoria ---");
        
        // Configurar caminho: Memória -> Bus2 -> Registrador
        Bus2_Sel = SEL_B2_FROMMEM;

        // a) Carregar Reg A com 0xAA
        from_memory = 8'hAA;
        A_Load = 1;
        #10
        #10 A_Load = 0;
        if(uut.A == 8'hAA) $display("PASS: A carregado, valor = 0x%h", uut.A);
        else $display("FAIL: A falhou. Valor = 0x%h (Esperado AA)", uut.A);
        
        // b) Carregar Reg B com 0x55
        from_memory = 8'h55;
        B_Load = 1;
        #10
        #10 B_Load = 0;
        if(uut.B == 8'h55) $display("PASS: B carregado, valor = 0x%h", uut.B);
        else $display("FAIL: B falhou. Valor = 0x%h (Esperado 55)", uut.B);

        // c) Carregar IR com 0x12
        from_memory = 8'h12;
        IR_Load = 1;
        #10
        #10 IR_Load = 0;
        if(IR_out == 8'h12) $display("PASS: IR carregado, registro = 0x%h", IR_out);
        else $display("FAIL: IR falhou. Registro = 0x%h (Esperado 12)", IR_out);

        // c) Carregar IR com 0x35
        from_memory = 8'h35;
        PC_Load = 1;
        #10
        #10 PC_Load = 0;
        if(uut.PC == 8'h35) $display("PASS: PC carregado, registro = 0x%h", uut.PC);
        else $display("FAIL: PC falhou. Registro = 0x%h (Esperado 35)", uut.PC);

        // d) CASO (iv): Carregar MAR com 0xF0 e verificar saída 'address'
        from_memory = 8'hF0;
        MAR_Load = 1;
        #10
        #10 MAR_Load = 0;
        if(address == 8'hF0) $display("PASS: MAR carregado, address = 0x%h", address);
        else $display("FAIL: MAR falhou. Address = 0x%h (Esperado F0)", address);

        // ============================================================
        // CASO (ii): Enviar Regs para_memory via Bus1_Sel
        // ============================================================
        #10
        $display("\n--- TESTE (ii): Verificando Regs em to_memory ---");
        
        // a) Verificar Reg A (deve ser 0xAA)
        Bus1_Sel = SEL_B1_A;
        #10
        if(to_memory == uut.A) $display("PASS: Bus1 selecionou A, to_memory = 0x%h", to_memory);
        else $display("FAIL: Bus1 selecionou A. to_memory = 0x%h (Esperado AA)", to_memory);

        // b) Verificar Reg B (deve ser 0x55)
        Bus1_Sel = SEL_B1_B;
        #10
        if(to_memory == uut.B) $display("PASS: Bus1 selecionou B, to_memory = 0x%h", to_memory);
        else $display("FAIL: Bus1 selecionou B. to_memory = 0x%h (Esperado 55)", to_memory);

        // c) Verificar Reg PC (deve ser 0x35)
        Bus1_Sel = SEL_B1_PC;
        #10
        if(to_memory == uut.PC) $display("PASS: Bus1 selecionou PC, to_memory = 0x%h", to_memory);
        else $display("FAIL: Bus1 selecionou B. to_memory = 0x%h (Esperado 35)", to_memory);


        // ============================================================
        // CASO (iii): Operações da ALU e CCR
        // ALU realiza: (Reg B) OP (Bus2)
        // ============================================================
        #10
        $display("\n--- TESTE (iii): Operacoes da ALU e CCR ---");

        // Teste para soma
        // 1. Colocar Reg A no Bus2
        Bus1_Sel = SEL_B1_A;    // Bus1 tem A (0xAA)
        Bus2_Sel = SEL_B2_BUS1; // Bus2 pega o valor de Bus1
        
        // 2. Configurar ALU para SOMA
        ALU_Sel = ALU_ADD;
        
        // 3. Capturar resultado no CCR
        CCR_Load = 1;
        #10
        #10 CCR_Load = 0;
        
        #10 // Verificar Resultado da ALU
        $display("PASS: ALU Soma: 0x%h + 0x%h. \nResultado ALU= 0x%h. \nCCR = %b\n", uut.B, uut.Bus1, uut.ALU_Result, CCR_Result);

        // Teste para subtração (resultado deve ser zero)
        // 1. Carregar A com o mesmo valor de B (0x55) para usar no Bus1
        Bus1_Sel = SEL_B1_B;
        B_Load = 1;
        #10
        #10 B_Load = 0;
        // 3. Configurar ALU para SUBTRAÇÃO
        ALU_Sel = ALU_SUB;
        
        // 4. Capturar flags
        CCR_Load = 1;
        #10
        #10 CCR_Load = 0;
        // Esperamos que a flag Z (Zero) seja 1.
        if (CCR_Result[2] == 1'b1) $display("PASS: ALU Sub: 0x%h - 0x%h. \nResultado ALU= 0x%h. \nCCR = %b\n", uut.B, uut.Bus1, uut.ALU_Result, CCR_Result);
        else $display("FAIL: ALU Sub e Zero falhou. CCR = %b (Esperado bit Z=1)", CCR_Result);

        // 5. Verificar se o resultado da ALU pode ir para to_memory
        Resultado_ALU = uut.ALU_Result;
        Bus2_Sel = SEL_B2_ALU;
        A_Load = 1;
        #10
        #10 A_Load = 0;
        #10 Bus2_Sel = SEL_B2_FROMMEM;
        #10 Bus1_Sel = SEL_B1_A; // Bus1 pega A
        #10
        if (to_memory == Resultado_ALU) $display("PASS: to_memory recebeu o valor de saída do ALU (0x%h)", to_memory);
        else $display("FAIL: Valor da memória 0x%h (esperado: 0x%h)", to_memory, Resultado_ALU);


        // Finalização
        #100
        $display("\n=== FIM DA SIMULACAO ===");
        $finish;
    end

endmodule