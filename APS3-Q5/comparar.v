`timescale 1ns/1ps
`include "modelo_comportamental.v"
`include "semaforo.v"
`include "lib.v"
`include "componentes_new.v"

module tb_semaforo;

    reg clk, res, CAR, TIMEOUT;
    wire VERDE_s, AMARELO_s, VERMELHO_s;
    wire VERDE_c, AMARELO_c, VERMELHO_c;

    // Instancia do semáforo arquitetural
    semaforo semaforo(.clk(clk), .res(res), .CAR(CAR), .TIMEOUT(TIMEOUT),
                  .VERDE(VERDE_s), .AMARELO(AMARELO_s), .VERMELHO(VERMELHO_s));

    // Instancia do modelo comportamental
    modelo_comportamental modelo_comportamental(.clk(clk), .res(res), .CAR(CAR), .TIMEOUT(TIMEOUT),
                               .VERDE(VERDE_c), .AMARELO(AMARELO_c), .VERMELHO(VERMELHO_c));

    // Clock 10ps
    initial clk = 0;
    always #5 clk = ~clk;

    // Sequência de estímulos
    initial begin
        res = 0; CAR = 0; TIMEOUT = 0;
        #12 res = 1;

        // Verde -> Amarelo
        #20 CAR = 1;
        #10 CAR = 0;
        #20;

        // Amarelo -> Vermelho
        #20;

        // Vermelho -> Verde
        #20 TIMEOUT = 1;
        #20 TIMEOUT = 0;
        #20;

        // Novo ciclo
        #20 CAR = 1;
        #20 CAR = 0;
        #20 TIMEOUT = 1;
        #20 TIMEOUT = 0;

        #50 $finish;
    end

    // Monitor
    initial begin
        $display("Time | CAR TIMEOUT | VERDE_s VERDE_c | AMARELO_s AMARELO_c | VERMELHO_s VERMELHO_c");
        $monitor("%4t | %b %b | %b %b | %b %b | %b %b",
                 $time, CAR, TIMEOUT,
                 VERDE_s, VERDE_c,
                 AMARELO_s, AMARELO_c,
                 VERMELHO_s, VERMELHO_c);
    end

    // Geração de ondas
    initial begin
        $dumpfile("tb_semaforo.vcd");
        $dumpvars(0, tb_semaforo);
    end
endmodule

