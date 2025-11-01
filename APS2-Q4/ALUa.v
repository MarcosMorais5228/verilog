`timescale 1ps/1ps

module alua(
    output wire [7:0] Result,
    output wire [3:0] NZVC,
    input wire [7:0] A, B,
    input wire [2:0] ALU_Sel
);

    wire [7:0] sumAB, sumA1, subAB, subA1;
    wire CoutSumAB, CoutSumA1, CoutSubAB, CoutSubA1;
    wire [7:0] notB, one8b;
    wire [7:0] op0, op1;

    assign one8b = 8'b00000001;

    not8b u_notB(notB, B);

    adder8b u_addAB(sumAB, CoutSumAB, A, B, 1'b0);
    adder8b u_addA1(sumA1, CoutSumA1, A, one8b, 1'b0);
    adder8b u_subAB(subAB, CoutSubAB, A, notB, 1'b1);
    adder8b u_subA1(subA1, CoutSubA1, A, 8'b11111111, 1'b1);

    wire [7:0] andAB, orAB, xorAB, notA;
    and8b u_and(andAB, A, B);

    or8b u_or(orAB, A, B);
    xor8b u_xor(xorAB, A, B);
    not8b u_notA(notA, A);

    mux8_4to1b u_muxLow(op0, sumAB, sumA1, subAB, subA1, ALU_Sel[1:0]);
    mux8_4to1b u_muxHigh(op1, andAB, orAB, xorAB, notA, ALU_Sel[1:0]);
    mux8b u_muxResult(Result, op0, op1, ALU_Sel[2]);

    assign NZVC[3] = Result[7];

    wire zeroTemp;

    or8bitwb u_orZero(zeroTemp, Result);
    NOT zeroFlag(NZVC[2], zeroTemp);

    wire [7:0] carryMux0, carryMux1;

    mux8b u_carryMux0(carryMux0, {8{CoutSumAB}}, {8{CoutSumA1}}, ALU_Sel[0]);
    mux8b u_carryMux1(carryMux1, {8{CoutSubAB}}, {8{CoutSubA1}}, ALU_Sel[0]);
    mux8b u_carryFinal({NZVC[0],NZVC[0],NZVC[0],NZVC[0],NZVC[0],NZVC[0],NZVC[0],NZVC[0]}, carryMux0, carryMux1, ALU_Sel[1]);

    wire nA7, nB7, nR7;
    wire ov1, ov2;

    NOT u_nA7(nA7, A[7]);
    NOT u_nB7(nB7, B[7]);
    NOT u_nR7(nR7, Result[7]);

    AND u_and1(ov1, A[7], B[7]);
    AND u_and2(ov1, ov1, nR7);
    AND u_and3(ov2, nA7, nB7);
    AND u_and4(ov2, ov2, Result[7]);

    OR u_orOv(NZVC[1], ov1, ov2);

endmodule
