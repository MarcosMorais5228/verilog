module control_unit 
    (output reg IR_Load, 
     output reg MAR_Load, 
     output reg PC_Load, PC_Inc, 
     output reg A_Load, B_Load,
     output reg CCR_Load,
     output reg [2:0] ALU_Sel,
     output reg [1:0] Bus1_Sel, Bus2_Sel,
     output reg write, 
     input wire [7:0] IR, 
     input wire [3:0] CCR_Result,
     input wire Clk, Reset);
                 
    reg [7:0] current_state, next_state;

    // --- Definições de Estados ---
    parameter S0_FETCH = 8'h00, S1_FETCH = 8'h01, S2_FETCH = 8'h02,
              S3_DECODE = 8'h03,
              S4_LDA_IMM = 8'h04, S5_LDA_IMM = 8'h05, S6_LDA_IMM = 8'h06,
              S4_LDA_DIR = 8'h07, S5_LDA_DIR = 8'h08, S6_LDA_DIR = 8'h09,
              S7_LDA_DIR = 8'h0A, S8_LDA_DIR = 8'h0B,
              // NOVOS ESTADOS INSERIDOS
              S4_ADD_IMM = 8'h0C, S5_ADD_IMM = 8'h0D, S6_ADD_IMM = 8'h0E,
              S4_STA_DIR = 8'h0F, S5_STA_DIR = 8'h10, S6_STA_DIR = 8'h11,
              S7_STA_DIR = 8'h12,
              S4_BRZ_DIR = 8'h13, S5_BRZ_DIR = 8'h14, S6_BRZ_DIR = 8'h15;

    // --- Definições de Opcodes ---
    parameter [7:0] LDA_IMM = 8'h01; 
    parameter [7:0] LDA_DIR = 8'h02; 
    parameter [7:0] ADD_IMM = 8'h11; // Adicionado
    parameter [7:0] STA_DIR = 8'h03; // Adicionado
    parameter [7:0] BRZ_DIR = 8'h30; // Adicionado
               
    // --- Inicialização ---
    initial begin
        current_state = S0_FETCH;
        next_state = S0_FETCH;
        // Reinicializando todos os sinais corretamente
        {IR_Load, MAR_Load, PC_Load, PC_Inc, A_Load, B_Load, CCR_Load, write} = 8'b0;
        ALU_Sel = 3'b000;
        Bus1_Sel = 2'b00;
        Bus2_Sel = 2'b00; // Valor de reset mais seguro
    end
  

    // --- 1. STATE_MEMORY (Lógica Sequencial) ---
    always @ (posedge Clk or negedge Reset)
        begin: STATE_MEMORY
            if (!Reset)
                current_state <= S0_FETCH;
            else
                current_state <= next_state;
        end
    
    // --- 2. NEXT_STATE_LOGIC (Lógica do Próximo Estado) ---
    always @ (current_state, IR, CCR_Result)
        begin: NEXT_STATE_LOGIC
            next_state = S0_FETCH; 
            
            case (current_state)
                S0_FETCH : next_state = S1_FETCH;
                S1_FETCH : next_state = S2_FETCH;
                S2_FETCH : next_state = S3_DECODE;
                
                S3_DECODE : begin
                    case (IR)
                        LDA_IMM : next_state = S4_LDA_IMM;
                        LDA_DIR : next_state = S4_LDA_DIR;
                        ADD_IMM : next_state = S4_ADD_IMM; // Adicionado
                        STA_DIR : next_state = S4_STA_DIR; // Adicionado
                        BRZ_DIR : next_state = S4_BRZ_DIR; // Adicionado
                        default: next_state = S0_FETCH;
                    endcase
                end
            
                // --- EXECUTE: LDA_IMM ---
                S4_LDA_IMM : next_state = S5_LDA_IMM; 
                S5_LDA_IMM : next_state = S6_LDA_IMM; 
                S6_LDA_IMM : next_state = S0_FETCH;
                
                // --- EXECUTE: ADD_IMM ---
                S4_ADD_IMM : next_state = S5_ADD_IMM; 
                S5_ADD_IMM : next_state = S6_ADD_IMM;
                S6_ADD_IMM : next_state = S0_FETCH; 

                // --- EXECUTE: LDA_DIR ---
                S4_LDA_DIR : next_state = S5_LDA_DIR;
                S5_LDA_DIR : next_state = S6_LDA_DIR;
                S6_LDA_DIR : next_state = S7_LDA_DIR;
                S7_LDA_DIR : next_state = S8_LDA_DIR;
                S8_LDA_DIR : next_state = S0_FETCH;
                
                // --- EXECUTE: STA_DIR ---
                S4_STA_DIR : next_state = S5_STA_DIR;
                S5_STA_DIR : next_state = S6_STA_DIR;
                S6_STA_DIR : next_state = S7_STA_DIR;
                S7_STA_DIR : next_state = S0_FETCH;
                
                // --- EXECUTE: BRZ_DIR ---
                S4_BRZ_DIR : next_state = S5_BRZ_DIR;
                S5_BRZ_DIR : begin 
                    if (CCR_Result[2]) // Se Zero Flag (Z) é 1
                        next_state = S6_BRZ_DIR; 
                    else
                        next_state = S0_FETCH;  
                end
                S6_BRZ_DIR : next_state = S0_FETCH; 

                default : next_state = S0_FETCH;
            endcase
        end
    
    // --- 3. OUTPUT_LOGIC (Lógica de Saída) ---
    always @ (current_state)
        begin: OUTPUT_LOGIC
            // Reset de Sinais no início de cada estado
            {IR_Load, MAR_Load, PC_Load, PC_Inc, A_Load, B_Load, CCR_Load, write} = 8'b0;
            ALU_Sel = 3'b000; // Padrão ADD
            Bus1_Sel = 2'b00; // Padrão PC
            Bus2_Sel = 2'b00; // Padrão ALU
            
            case (current_state)
                // --- Ciclo FETCH (S0, S1, S2) ---
                S0_FETCH : begin // PC -> MAR
                    MAR_Load = 1;
                    Bus1_Sel = 2'b00; // PC -> Bus1
                    Bus2_Sel = 2'b01; // Bus1 -> MAR
                end
                S1_FETCH : begin // Mem -> IR, PC++
                    IR_Load = 1;
                    PC_Inc = 1;
                    ALU_Sel = 3'b001; // PC + 1
                    Bus2_Sel = 2'b10; // Memória -> IR
                end
                S2_FETCH : begin // PC -> MAR (Endereço do Operando)
                    MAR_Load = 1;
                    Bus1_Sel = 2'b00; // PC -> Bus1
                    Bus2_Sel = 2'b01; // Bus1 -> MAR
                end
                S3_DECODE : ; // Nenhum sinal ativo
                
                // --- EXECUTE: LDA_IMM ---
                S4_LDA_IMM : begin // B <- Memoria, PC++
                    B_Load = 1;      // Carrega dado imediato lido
                    PC_Inc = 1;
                    ALU_Sel = 3'b001; // PC + 1
                    Bus2_Sel = 2'b10; // Memória -> B
                end
                S5_LDA_IMM : begin // A <- B, CCR_Load
                    A_Load = 1;
                    CCR_Load = 1;
                    Bus1_Sel = 2'b10; // B -> Bus1
                    Bus2_Sel = 2'b01; // Bus1 -> A
                end
                S6_LDA_IMM : ; 

                // --- EXECUTE: ADD_IMM ---
                S4_ADD_IMM : begin // B <- Memoria, PC++
                    B_Load = 1;      // Carrega dado imediato lido
                    PC_Inc = 1;
                    ALU_Sel = 3'b001; // PC + 1
                    Bus2_Sel = 2'b10; // Memória -> B
                end
                S5_ADD_IMM : begin // A <- A + B, CCR_Load
                    A_Load = 1;
                    CCR_Load = 1;
                    Bus1_Sel = 2'b01; // A -> Bus1 (para ALU)
                    Bus2_Sel = 2'b00; // ALU -> A
                    ALU_Sel = 3'b000; // A + B
                end
                S6_ADD_IMM : ;
                
                // --- EXECUTE: STA_DIR ---
                S7_STA_DIR : begin // Escrita A -> Memória
                    write = 1;
                    Bus1_Sel = 2'b01; // A (Dado) -> Barramento
                end
                
                // --- EXECUTE: BRZ_DIR ---
                S4_BRZ_DIR : begin // MAR <- PC (Endereço Alto), PC++
                    MAR_Load = 1;
                    PC_Inc = 1;
                    ALU_Sel = 3'b001;
                    Bus2_Sel = 2'b10; // Memória -> MAR
                end
                S5_BRZ_DIR : begin // MAR <- PC (Endereço Baixo)
                    MAR_Load = 1; 
                    Bus1_Sel = 2'b00; 
                    Bus2_Sel = 2'b01; 
                end
                S6_BRZ_DIR : begin // PC <- Endereço de Desvio (Apenas se desvio tomado)
                    PC_Load = 1;
                    Bus2_Sel = 2'b10; // Memória (Dado de Endereço) -> PC
                end
                
                default: ;
            endcase
        end
endmodule
