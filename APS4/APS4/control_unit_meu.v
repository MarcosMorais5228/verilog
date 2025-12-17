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
    parameter S0_FETCH      = 8'h00, 
              S1_FETCH      = 8'h01, 
              S2_FETCH      = 8'h02,
              S3_DECODE     = 8'h03,
              
              // Estados de Execução
              S4_LDA_IMM    = 8'h04, S5_LDA_IMM = 8'h05,
              S4_LDA_DIR    = 8'h06, S5_LDA_DIR = 8'h07, S6_LDA_DIR = 8'h08, S7_LDA_DIR = 8'h09,
              S4_STA_DIR    = 8'h0A, S5_STA_DIR = 8'h0B, S6_STA_DIR = 8'h0C,
              S4_BRA        = 8'h0D, S5_BRA     = 8'h0E;

    // --- Definições de Opcodes (Sincronizados com a ROM) ---
    parameter [7:0] LDA_IMM = 8'h86; // Load A Immediate
    parameter [7:0] LDA_DIR = 8'h87; // Load A Direct
    parameter [7:0] STA_DIR = 8'h96; // Store A Direct
    parameter [7:0] BRA     = 8'h20; // Branch Always
    // Adicione outros conforme necessário (ex: ADD_AB = 8'h42)
                
    // --- Inicialização ---
    initial begin
        current_state = S0_FETCH;
        next_state = S0_FETCH;
        {IR_Load, MAR_Load, PC_Load, PC_Inc, A_Load, B_Load, CCR_Load, write} = 8'b0;
        ALU_Sel = 3'b000;
        Bus1_Sel = 2'b00;
        Bus2_Sel = 2'b00; 
    end
   
    // --- 1. STATE_MEMORY (Sequencial) ---
    always @ (posedge Clk or negedge Reset)
        begin: STATE_MEMORY
            if (!Reset)
                current_state <= S0_FETCH;
            else
                current_state <= next_state;
        end
    
    // --- 2. NEXT_STATE_LOGIC (Combinacional) ---
    always @ (current_state, IR, CCR_Result)
        begin: NEXT_STATE_LOGIC
            next_state = S0_FETCH; 
            
            case (current_state)
                // Ciclo de Busca (Fetch) Padrão
                S0_FETCH : next_state = S1_FETCH;
                S1_FETCH : next_state = S2_FETCH;
                S2_FETCH : next_state = S3_DECODE;
                
                S3_DECODE : begin
                    case (IR)
                        LDA_IMM : next_state = S4_LDA_IMM;
                        LDA_DIR : next_state = S4_LDA_DIR;
                        STA_DIR : next_state = S4_STA_DIR;
                        BRA     : next_state = S4_BRA;
                        default : next_state = S0_FETCH; // Instrução inválida reinicia
                    endcase
                end
            
                // --- LDA_IMM ---
                S4_LDA_IMM : next_state = S0_FETCH; // Já carregou, volta pro início
                
                // --- LDA_DIR ---
                S4_LDA_DIR : next_state = S5_LDA_DIR;
                S5_LDA_DIR : next_state = S6_LDA_DIR;
                S6_LDA_DIR : next_state = S0_FETCH;
                
                // --- STA_DIR ---
                S4_STA_DIR : next_state = S5_STA_DIR;
                S5_STA_DIR : next_state = S0_FETCH;
                
                // --- BRA (Branch Always) ---
                S4_BRA     : next_state = S0_FETCH;

                default : next_state = S0_FETCH;
            endcase
        end
    
    // --- 3. OUTPUT_LOGIC (Saídas) ---
    always @ (current_state)
        begin: OUTPUT_LOGIC
            // Reset dos sinais para evitar latches indesejados
            {IR_Load, MAR_Load, PC_Load, PC_Inc, A_Load, B_Load, CCR_Load, write} = 8'b0;
            ALU_Sel = 3'b000; 
            Bus1_Sel = 2'b00; 
            Bus2_Sel = 2'b00; 
            
            case (current_state)
                // --- Fetch Cycle ---
                S0_FETCH : begin // PC -> MAR
                    MAR_Load = 1;
                    Bus1_Sel = 2'b00; // PC
                    Bus2_Sel = 2'b01; // Bus1 -> Bus2
                end
                S1_FETCH : begin // Mem -> IR, PC++
                    IR_Load = 1;
                    PC_Inc = 1;
                    Bus2_Sel = 2'b10; // Memória
                end
                S2_FETCH : begin // PC -> MAR (Atualiza MAR para o próximo operando, se houver)
                    MAR_Load = 1;
                    Bus1_Sel = 2'b00; // PC
                    Bus2_Sel = 2'b01; // Bus1 -> Bus2
                end
                S3_DECODE : ; // Apenas decisão, sem sinais ativos

                // --- LDA_IMM (0x86) ---
                // O MAR já aponta para o operando (graças ao S2_FETCH)
                S4_LDA_IMM : begin 
                    A_Load = 1;       // Carrega dado da memória direto em A
                    PC_Inc = 1;       // Aponta para próxima instrução
                    Bus2_Sel = 2'b10; // Memória -> Bus2
                    // Nota: Se quiser atualizar flags (CCR), ative CCR_Load aqui e passe pela ALU
                end

                // --- STA_DIR (0x96) ---
                // Passo 1: Ler o endereço onde vamos salvar o dado
                S4_STA_DIR : begin 
                    MAR_Load = 1;     // O dado da memória é um endereço. Vai para MAR.
                    PC_Inc = 1;       // Avança PC para próxima instrução
                    Bus2_Sel = 2'b10; // Memória -> Bus2
                end
                // Passo 2: Escrever o registrador A na memória
                S5_STA_DIR : begin
                    write = 1;        // Habilita escrita na memória
                    Bus1_Sel = 2'b01; // A -> Bus1 (Data Bus para memória)
                    // Endereço já está no MAR (definido em S4)
                end

                // --- BRA (0x20) ---
                // Ler o endereço de destino e jogar no PC
                S4_BRA : begin
                    PC_Load = 1;      // Sobrescreve PC com o destino
                    Bus2_Sel = 2'b10; // Memória (Destino) -> Bus2 -> PC
                    // NÃO incrementa PC aqui, pois acabamos de pular
                end

                default: ;
            endcase
        end
endmodule