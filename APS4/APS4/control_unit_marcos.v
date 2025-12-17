module control_unit 
(
    output reg IR_Load, MAR_Load, PC_Load, PC_Inc, 
    output reg A_Load, B_Load, CCR_Load,
    output reg [2:0] ALU_Sel,
    output reg [1:0] Bus1_Sel, Bus2_Sel,
    output reg write, 
    input wire [7:0] IR, 
    input wire [3:0] CCR_Result,
    input wire Clk, Reset
);

    reg [7:0] current_state, next_state;

    // Flags de condição
    wire N = CCR_Result[3]; wire Z = CCR_Result[2];
    wire V = CCR_Result[1]; wire C = CCR_Result[0];

    // --- OPCODES ---
    parameter [7:0] 
        LDA_IMM = 8'h86, 
        LDA_DIR = 8'h87, 
        LDB_IMM = 8'h88, 
        LDB_DIR = 8'h89, 
        STA_DIR = 8'h96, 
        STB_DIR = 8'h97, 
        ADD_AB = 8'h42, 
        BRA = 8'h20,
        BEQ = 8'h23, 
        BNE = 8'h24;

    // --- ESTADOS REORGANIZADOS PARA SINCRONISMO ---
    parameter 
        S0_FETCH       = 8'h00, 
        S1_FETCH_WAIT  = 8'h01, 
        S2_FETCH_DONE  = 8'h02, 
        S3_DECODE      = 8'h03,
        S4_LDR_IMM_MAR = 8'h04, 
        S5_LDR_IMM_WT  = 8'h05, 
        S6_LDR_IMM_LD  = 8'h06,
        S4_DIR_ADDR_RD = 8'h07, 
        S5_DIR_ADDR_WT = 8'h08, 
        S6_DIR_ADDR_LD = 8'h09,
        S7_DIR_RW_OP   = 8'h0A, 
        S8_DIR_RW_WT   = 8'h0B, 
        S9_DIR_RW_DONE = 8'h0C,
        S4_ALU         = 8'h0D,
        S4_BR_ADDR     = 8'h0E, 
        S5_BR_WAIT     = 8'h0F, 
        S6_BR_DONE     = 8'h10;

    // --- MEMÓRIA DE ESTADO ---
    always @(posedge Clk or negedge Reset) begin
        if (!Reset) current_state <= S0_FETCH;
        else current_state <= next_state;
    end

    // --- LÓGICA DE PRÓXIMO ESTADO ---
    always @(*) begin
        next_state = S0_FETCH;
        case (current_state)
            // Fetch do Opcode
            S0_FETCH:      next_state = S1_FETCH_WAIT;
            S1_FETCH_WAIT: next_state = S2_FETCH_DONE;
            S2_FETCH_DONE: next_state = S3_DECODE;

            S3_DECODE: begin
                case (IR)
                    LDA_IMM, LDB_IMM : next_state = S4_LDR_IMM_MAR;
                    LDA_DIR, LDB_DIR, 
                    STA_DIR, STB_DIR : next_state = S4_DIR_ADDR_RD;
                    ADD_AB           : next_state = S4_ALU;
                    BRA, BEQ, BNE    : next_state = S4_BR_ADDR;
                    default          : next_state = S0_FETCH;
                endcase
            end

            // Fluxo Imediato (LDR_IMM)
            S4_LDR_IMM_MAR: next_state = S5_LDR_IMM_WT;
            S5_LDR_IMM_WT:  next_state = S6_LDR_IMM_LD;
            S6_LDR_IMM_LD:  next_state = S0_FETCH;

            // Fluxo Direto (LDR_DIR / STR_DIR)
            S4_DIR_ADDR_RD: next_state = S5_DIR_ADDR_WT;
            S5_DIR_ADDR_WT: next_state = S6_DIR_ADDR_LD;
            S6_DIR_ADDR_LD: next_state = S7_DIR_RW_OP;
            S7_DIR_RW_OP:   next_state = S8_DIR_RW_WT;
            S8_DIR_RW_WT:   next_state = S9_DIR_RW_DONE;
            S9_DIR_RW_DONE: next_state = S0_FETCH;

            // ALU e Branch
            S4_ALU:         next_state = S0_FETCH;
            S4_BR_ADDR:     next_state = S5_BR_WAIT;
            S5_BR_WAIT:     next_state = S6_BR_DONE;
            S6_BR_DONE:     next_state = S0_FETCH;

            default:        next_state = S0_FETCH;
        endcase
    end

    // --- LÓGICA DE SAÍDA (CONTROL SIGNALS) ---
    always @(*) begin
        // Valores Padrão
        {IR_Load, MAR_Load, PC_Load, PC_Inc, A_Load, B_Load, CCR_Load, write} = 8'b0;
        ALU_Sel = 3'b000; Bus1_Sel = 2'b00; Bus2_Sel = 2'b00;

        case (current_state)
            // FETCH: Busca o Opcode
            S0_FETCH: begin 
                MAR_Load = 1; Bus1_Sel = 2'b00; Bus2_Sel = 2'b01; // MAR <- PC
            end
            S1_FETCH_WAIT: ; // Espera ROM Síncrona
            S2_FETCH_DONE: begin 
                IR_Load = 1; PC_Inc = 1; Bus2_Sel = 2'b10; // IR <- Mem[MAR], PC++
            end

            // EXECUÇÃO IMEDIATA (Ex: LDA #$10)
            S4_LDR_IMM_MAR: begin 
                MAR_Load = 1; Bus1_Sel = 2'b00; Bus2_Sel = 2'b01; // MAR <- PC
            end
            S5_LDR_IMM_WT: ; // Espera ROM carregar o dado imediato
            S6_LDR_IMM_LD: begin
                Bus2_Sel = 2'b10; PC_Inc = 1;
                if (IR == LDA_IMM) A_Load = 1; else B_Load = 1;
            end

            // EXECUÇÃO DIRETA (Ex: LDA $F0 ou STA $80)
            S4_DIR_ADDR_RD: begin
                MAR_Load = 1; Bus1_Sel = 2'b00; Bus2_Sel = 2'b01; // MAR <- PC (onde está o endereço)
            end
            S5_DIR_ADDR_WT: ; // Espera endereço sair da ROM
            S6_DIR_ADDR_LD: begin
                MAR_Load = 1; Bus2_Sel = 2'b10; PC_Inc = 1; // MAR <- Mem[PC] (Pega o endereço real)
            end
            S7_DIR_RW_OP: ; // Espera ROM buscar o dado no endereço carregado
            S8_DIR_RW_WT: begin
                if (IR == LDA_DIR || IR == LDB_DIR) begin
                    Bus2_Sel = 2'b10; // Memória -> Barramento
                    if (IR == LDA_DIR) A_Load = 1; else B_Load = 1;
                end else begin
                    write = 1; // Escrita na memória
                    Bus1_Sel = (IR == STA_DIR) ? 2'b01 : 2'b10; // A ou B -> Bus1 -> RAM
                end
            end
            S9_DIR_RW_DONE: ;

            // ALU (Execução em 1 ciclo interno)
            S4_ALU: begin
                CCR_Load = 1; Bus2_Sel = 2'b00; // ALU -> Bus2
                if (IR == ADD_AB) begin A_Load = 1; ALU_Sel = 3'b000; Bus1_Sel = 2'b01; end
                // Adicione outros ALU_Sel aqui conforme seu hardware
            end

            // BRANCH
            S4_BR_ADDR: begin
                MAR_Load = 1; Bus1_Sel = 2'b00; Bus2_Sel = 2'b01; // MAR <- PC (onde está o destino)
            end
            S5_BR_WAIT: ; // Espera ROM entregar endereço de destino
            S6_BR_DONE: begin
                if (IR == BRA || (IR == BEQ && Z) || (IR == BNE && !Z)) begin
                    PC_Load = 1; Bus2_Sel = 2'b10; // PC <- Mem[MAR]
                end else begin
                    PC_Inc = 1; // Apenas ignora o endereço se a condição falhar
                end
            end
        endcase
    end
endmodule