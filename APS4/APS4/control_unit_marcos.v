module control_unit 
(
    output reg IR_Load, 
    output reg MAR_Load, 
    output reg PC_Load, PC_Inc, 
    output reg A_Load, B_Load,
    output reg CCR_Load,
    output reg [2:0] ALU_Sel,
    output reg [1:0] Bus1_Sel, Bus2_Sel,
    output reg write, 
    input wire [7:0] IR, 
    input wire [3:0] CCR_Result, // Flags: [3]=N, [2]=Z, [1]=V, [0]=C
    input wire Clk, Reset
);

    reg [7:0] current_state, next_state;

    // Flags
    wire N = CCR_Result[3];
    wire Z = CCR_Result[2];
    wire V = CCR_Result[1];
    wire C = CCR_Result[0];

    // --- OPCODES ---
    parameter [7:0] 
        LDA_IMM = 8'h86, 
        LDA_DIR = 8'h87, 
        LDB_IMM = 8'h88, 
        LDB_DIR = 8'h89, 
        STA_DIR = 8'h96, 
        STB_DIR = 8'h97,
        ADD_AB  = 8'h42, 
        SUB_AB  = 8'h43, 
        AND_AB = 8'h44, 
        OR_AB  = 8'h45,
        INCA = 8'h46, 
        INCB = 8'h47, 
        DECA = 8'h48, 
        DECB = 8'h49,
        XOR_AB = 8'h4A, 
        NOTA = 8'h4B, 
        NOTB = 8'h4C,
        BRA  = 8'h20, 
        BMI  = 8'h21, 
        BPL  = 8'h22, 
        BEQ  = 8'h23,
        BNE  = 8'h24, 
        BVS  = 8'h25, 
        BVC  = 8'h26, 
        BCS  = 8'h27, 
        BCC  = 8'h28;

    // --- ESTADOS ---
    parameter 
        S0_FETCH    = 8'h00,
        S1_FETCH    = 8'h01,
        S2_FETCH    = 8'h02,
        S3_DECODE   = 8'h03,
        S4_LDR_IMM  = 8'h04, 
        S5_LDR_IMM  = 8'h05, 
        S6_LDR_IMM  = 8'h06,
        S4_LDR_DIR  = 8'h07, 
        S5_LDR_DIR  = 8'h08, 
        S6_LDR_DIR  = 8'h09,
        S7_LDR_DIR  = 8'h0A, 
        S8_LDR_DIR  = 8'h0B,
        S4_STR_DIR  = 8'h0C, 
        S5_STR_DIR  = 8'h0D, 
        S6_STR_DIR  = 8'h0E,
        S7_STR_DIR  = 8'h0F, 
        S8_STR_DIR  = 8'h10,
        S4_ALU_OP   = 8'h11, 
        S5_ALU_OP   = 8'h12,
        S4_BR       = 8'h13, 
        S5_BR       = 8'h14, 
        S6_BR       = 8'h15;

    // --- STATE MEMORY ---
    always @(posedge Clk or negedge Reset) begin
        if (!Reset)
            current_state <= S0_FETCH;
        else
            current_state <= next_state;
    end

    // --- NEXT STATE LOGIC ---
    always @(current_state or IR or CCR_Result) begin
        next_state = S0_FETCH;
        case (current_state)
            S0_FETCH : next_state = S1_FETCH;
            S1_FETCH : next_state = S2_FETCH;
            S2_FETCH : next_state = S3_DECODE;

            S3_DECODE : begin
                case (IR)
                    LDA_IMM, LDB_IMM : next_state = S4_LDR_IMM;
                    LDA_DIR, LDB_DIR : next_state = S4_LDR_DIR;
                    STA_DIR, STB_DIR : next_state = S4_STR_DIR;
                    ADD_AB, SUB_AB, AND_AB, OR_AB, XOR_AB,
                    INCA, INCB, DECA, DECB, NOTA, NOTB :
                        next_state = S4_ALU_OP;
                    BRA, BMI, BPL, BEQ, BNE, BVS, BVC, BCS, BCC :
                        next_state = S4_BR;
                    default : next_state = S0_FETCH;
                endcase
            end

            S4_LDR_IMM : next_state = S5_LDR_IMM;
            S5_LDR_IMM : next_state = S6_LDR_IMM;
            S6_LDR_IMM : next_state = S0_FETCH;

            S4_ALU_OP  : next_state = S5_ALU_OP;
            S5_ALU_OP  : next_state = S0_FETCH;

            S4_LDR_DIR : next_state = S5_LDR_DIR;
            S5_LDR_DIR : next_state = S6_LDR_DIR;
            S6_LDR_DIR : next_state = S7_LDR_DIR;
            S7_LDR_DIR : next_state = S8_LDR_DIR;
            S8_LDR_DIR : next_state = S0_FETCH;

            S4_STR_DIR : next_state = S5_STR_DIR;
            S5_STR_DIR : next_state = S6_STR_DIR;
            S6_STR_DIR : next_state = S7_STR_DIR;
            S7_STR_DIR : next_state = S8_STR_DIR;
            S8_STR_DIR : next_state = S0_FETCH;

            S4_BR : next_state = S5_BR;
            S5_BR : begin
                if (IR == BRA)                     next_state = S6_BR;
                else if (IR == BEQ && Z)           next_state = S6_BR;
                else if (IR == BNE && !Z)          next_state = S6_BR;
                else if (IR == BMI && N)           next_state = S6_BR;
                else if (IR == BPL && !N)          next_state = S6_BR;
                else if (IR == BVS && V)           next_state = S6_BR;
                else if (IR == BVC && !V)          next_state = S6_BR;
                else if (IR == BCS && C)           next_state = S6_BR;
                else if (IR == BCC && !C)          next_state = S6_BR;
                else                               next_state = S0_FETCH;
            end
            S6_BR : next_state = S0_FETCH;

            default : next_state = S0_FETCH;
        endcase
    end

    // --- OUTPUT LOGIC ---
    always @(current_state or IR) begin // Adicionado 'or IR' para usar IR em alguns casos de estado
        // Inicialização padrão
        {IR_Load, MAR_Load, PC_Load, PC_Inc, A_Load, B_Load, CCR_Load, write} = 8'b0;
        ALU_Sel  = 3'b000;
        Bus1_Sel = 2'b00;
        Bus2_Sel = 2'b00;

        case (current_state)
            // --- CICLO BÁSICO ---
            S0_FETCH : begin // MAR <- PC
                MAR_Load = 1;
                Bus1_Sel = 2'b00; // PC -> Bus1
                Bus2_Sel = 2'b01; // Bus1 -> MAR
            end
            S1_FETCH : begin // IR <- Mem, PC++
                IR_Load = 1;
                PC_Inc  = 1;
                Bus2_Sel = 2'b10; // Memória -> IR
            end
            S2_FETCH : begin // MAR <- PC (Endereço do operando/destino)
                MAR_Load = 1;
                Bus1_Sel = 2'b00; // PC -> Bus1
                Bus2_Sel = 2'b01; // Bus1 -> MAR
            end
            S3_DECODE : ;

            // --- EXECUTE: LDR_IMM (LDA_IMM, LDB_IMM) ---
            // No bloco OUTPUT_LOGIC da control_unit.v
            S4_LDR_IMM : begin
                PC_Inc = 1;       // Incrementa para passar pelo dado (ROM[3])
                if (IR == LDA_IMM) A_Load = 1;
                if (IR == LDB_IMM) B_Load = 1; 
                Bus2_Sel = 2'b10; // Busca dado da ROM
            end
            S5_LDR_IMM : begin
                // Mantém os sinais por mais um ciclo para garantir a escrita no registrador
                if (IR == LDA_IMM) A_Load = 1;
                if (IR == LDB_IMM) B_Load = 1;
                Bus2_Sel = 2'b10;
            end
            S6_LDR_IMM : ; 

            // --- EXECUTE: ALU_OP (ADD, SUB, NOT, INC, etc.) ---
            S4_ALU_OP : begin // Dest <- f(A,B), CCR_Load
                CCR_Load = 1;
                Bus2_Sel = 2'b00; // ALU -> Bus2
                
                case (IR)
                    ADD_AB : begin A_Load = 1; Bus1_Sel = 2'b01; ALU_Sel = 3'b000; end // A+B -> A
                    SUB_AB : begin A_Load = 1; Bus1_Sel = 2'b01; ALU_Sel = 3'b010; end // A-B -> A
                    AND_AB : begin A_Load = 1; Bus1_Sel = 2'b01; ALU_Sel = 3'b011; end // A&B -> A
                    OR_AB  : begin A_Load = 1; Bus1_Sel = 2'b01; ALU_Sel = 3'b100; end // A|B -> A
                    XOR_AB : begin A_Load = 1; Bus1_Sel = 2'b01; ALU_Sel = 3'b101; end // A^B -> A

                    INCA : begin A_Load = 1; Bus1_Sel = 2'b01; ALU_Sel = 3'b001; end // A+1 -> A
                    DECA : begin A_Load = 1; Bus1_Sel = 2'b01; ALU_Sel = 3'b110; end // A-1 -> A
                    NOTA : begin A_Load = 1; Bus1_Sel = 2'b01; ALU_Sel = 3'b111; end // ~A -> A
                    
                    INCB : begin B_Load = 1; Bus1_Sel = 2'b10; ALU_Sel = 3'b001; end // B+1 -> B
                    DECB : begin B_Load = 1; Bus1_Sel = 2'b10; ALU_Sel = 3'b110; end // B-1 -> B
                    NOTB : begin B_Load = 1; Bus1_Sel = 2'b10; ALU_Sel = 3'b111; end // ~B -> B
                endcase
            end
            S5_ALU_OP : ; 

            // --- EXECUTE: LDR_DIR (LDA_DIR, LDB_DIR) ---
            S4_LDR_DIR : begin // MAR_H <- Mem[PC], PC++
                MAR_Load = 1; PC_Inc = 1; ALU_Sel = 3'b001; Bus2_Sel = 2'b10; 
            end
            S5_LDR_DIR : ; 
            S6_LDR_DIR : begin // MAR_L <- Mem[PC], PC++
                ALU_Sel = 3'b001; Bus2_Sel = 2'b10; 
            end
            S7_LDR_DIR : ; 
            S8_LDR_DIR : begin // A/B <- Mem[MAR_completo], CCR
                CCR_Load = 1;
                Bus2_Sel = 2'b10; // Memória -> Bus2
                if (IR == LDA_DIR) A_Load = 1;
                if (IR == LDB_DIR) B_Load = 1;
            end

            // --- EXECUTE: STR_DIR (STA_DIR, STB_DIR) ---
            S4_STR_DIR : begin // MAR_H <- Mem[PC], PC++
                PC_Inc = 1; ALU_Sel = 3'b001; Bus2_Sel = 2'b10; 
            end
            S5_STR_DIR : ; 
            S6_STR_DIR : begin // MAR_L <- Mem[PC], PC++
                PC_Inc = 1; ALU_Sel = 3'b001; Bus2_Sel = 2'b10; 
            end
            S7_STR_DIR : ; 
            S8_STR_DIR : begin // Mem[MAR] <- A/B, write=1
                write = 1;
                if (IR == STA_DIR) Bus1_Sel = 2'b01; // A -> Barramento
                if (IR == STB_DIR) Bus1_Sel = 2'b10; // B -> Barramento
            end
            
            // --- EXECUTE: BRANCHES (BRA, BEQ, etc.) ---
            S4_BR : begin // MAR_H <- Mem[PC], PC++
                MAR_Load = 1; PC_Inc = 1; ALU_Sel = 3'b001; Bus2_Sel = 2'b10; 
            end
            S5_BR : begin // MAR_L <- Mem[PC], PC++
                MAR_Load = 1; PC_Inc = 1; ALU_Sel = 3'b001; Bus2_Sel = 2'b10; 
            end
            S6_BR : begin // PC <- Endereço (Se o branch foi tomado em S5_BR)
                PC_Load = 1;
                Bus2_Sel = 2'b10; // Memória -> PC
            end
            
            // default (já tratado no reset dos sinais)
        endcase
    end
endmodule

