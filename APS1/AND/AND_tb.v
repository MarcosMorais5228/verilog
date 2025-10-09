`include "AND.v"

module AND_tb();

    reg fio1, fio2;
    wire fio3;

    AND AND_gate(.A(fio1), .B(fio2), .F(fio3));

    initial begin
        $dumpfile("AND.vcd");
        $dumpvars (0,AND_tb);

        fio1 = 0; fio2 = 0;
        #5

        fio1 = 0; fio2 = 1;
        #5
        
        fio1 = 1; fio2 = 0;
        #5

        fio1 = 1; fio2 = 1;
        #5

    end


endmodule