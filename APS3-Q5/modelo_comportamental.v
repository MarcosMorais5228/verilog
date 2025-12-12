`timescale 1ps/1ps

module semaforo (
    input  wire clk,
    input  wire res,
    input  wire CAR,
    output reg VERDE,
    output reg AMARELO,
    output reg VERMELHO
);

    parameter S_VERDE    = 2'b00;
    parameter S_AMARELO  = 2'b01;
    parameter S_VERMELHO = 2'b10;
	 parameter TAMARELO = 50000000; 
	 parameter TVERMELHO = 750000000;

    reg [1:0] state, next_state;
	 reg [32:0] counter_red;
	 reg [32:0] counter_yellow;
	 

    // Atualiza o estado na borda do clock
    always @(posedge clk or negedge res) begin
        if (!res)
            state <= S_VERDE;
        else
            state <= next_state;
    end

    // Define a lógica de transição de estados
    always @(posedge clk) begin
        case(state)
            S_VERDE: next_state = (CAR) ? S_AMARELO : S_VERDE;
            
				S_AMARELO:   
				if (counter_yellow >= TAMARELO) begin
					next_state = S_VERMELHO;
					counter_yellow = 0;
				end else begin
					counter_yellow = counter_yellow + 1;
				end
				
				S_VERMELHO:
				if (counter_red >= TVERMELHO) begin
					next_state = S_VERDE;
					counter_red = 0;
				end else begin	
					counter_red = counter_red + 1;
				end
            
				default: next_state = S_VERDE;
        endcase
    end

    // Atualiza as saídas sincronizadas com o estado
    always @(posedge clk or negedge res) begin
        if(!res) begin
            VERDE    <= 1;
            AMARELO  <= 0;
            VERMELHO <= 0;
        end else begin
            case(next_state)
                S_VERDE: begin VERDE <= 1; AMARELO <= 0; VERMELHO <= 0; end
                S_AMARELO: begin VERDE <= 0; AMARELO <= 1; VERMELHO <= 0; end
                S_VERMELHO: begin VERDE <= 0; AMARELO <= 0; VERMELHO <= 1; end
            endcase
        end
    end
endmodule