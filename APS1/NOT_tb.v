`include "NOT.v"

module NOT_tb;
    reg fio1, fio2;
    wire fio3;

    NOT_tb NOT(A.(fio1), .A(fio2), .F(fio3));

    initial begin
        $dumpfile("NOT.vcd");
        $dumpvars (0,NOT_tb);
        
        A = 1; 
        #5;

        A = 0;
        #5;
    end
endmodule