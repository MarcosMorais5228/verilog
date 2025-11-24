`timescale 1ps/1ps

module semaforo (
    input wire clk,
    input wire res, 
    input wire CAR,
    input wire TIMEOUT,
    output wire VERDE,
    output wire AMARELO,
    output wire VERMELHO
);

    wire Q0, Q1;
    wire D0, D1;
    wire Q0n, Q1n;

    dflipflop ff0(.Q(Q0), .Qn(Q0n), .Clock(clk), .Reset(res), .Preset(1'b1), .D(D0));
    dflipflop ff1(.Q(Q1), .Qn(Q1n), .Clock(clk), .Reset(res), .Preset(1'b1), .D(D1));
    
    wire notQ0, notQ1;
    NOT inv0(notQ0, Q0);
    NOT inv1(notQ1, Q1);
    
    wire notTIMEOUT;
    NOT invTIMEOUT(notTIMEOUT, TIMEOUT);
    
    wire is_verde;
    AND and_verde_state(is_verde, notQ1, notQ0); 
    
    wire is_amarelo;
    AND and_amarelo_state(is_amarelo, notQ1, Q0); 

    wire is_vermelho;   
    AND and_vermelho_state(is_vermelho, Q1, notQ0); 
    
    wire D0_expr;
    AND and_D0(D0_expr, is_verde, CAR);
    assign D0 = D0_expr;
    
    wire D1_term1;
    wire D1_term2;
    wire D1_expr;
    
    assign D1_term1 = is_amarelo; 
    
    AND and_D1_term2(D1_term2, is_vermelho, notTIMEOUT);
    
    OR or_D1(D1_expr, D1_term1, D1_term2);
    assign D1 = D1_expr;

    assign VERDE = is_verde;
    assign AMARELO = is_amarelo;
    assign VERMELHO = is_vermelho;

endmodule