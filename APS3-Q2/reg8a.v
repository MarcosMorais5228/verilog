`timescale 1ps/1ps

module reg8a (
    input  wire clk,
    input  wire res,
    input  wire EN,
    input  wire [7:0] Reg_In,
    output wire [7:0] Reg_Out
);

    wire [7:0] D_in;

    mux8b mux_data(D_in, Reg_Out, Reg_In, EN);

    dflipflop ff0 (.Q(Reg_Out[0]), .Qn(), .Clock(clk), .Reset(res), .Preset(1'b1), .D(D_in[0]));
    dflipflop ff1 (.Q(Reg_Out[1]), .Qn(), .Clock(clk), .Reset(res), .Preset(1'b1), .D(D_in[1]));
    dflipflop ff2 (.Q(Reg_Out[2]), .Qn(), .Clock(clk), .Reset(res), .Preset(1'b1), .D(D_in[2]));
    dflipflop ff3 (.Q(Reg_Out[3]), .Qn(), .Clock(clk), .Reset(res), .Preset(1'b1), .D(D_in[3]));
    dflipflop ff4 (.Q(Reg_Out[4]), .Qn(), .Clock(clk), .Reset(res), .Preset(1'b1), .D(D_in[4]));
    dflipflop ff5 (.Q(Reg_Out[5]), .Qn(), .Clock(clk), .Reset(res), .Preset(1'b1), .D(D_in[5]));
    dflipflop ff6 (.Q(Reg_Out[6]), .Qn(), .Clock(clk), .Reset(res), .Preset(1'b1), .D(D_in[6]));
    dflipflop ff7 (.Q(Reg_Out[7]), .Qn(), .Clock(clk), .Reset(res), .Preset(1'b1), .D(D_in[7]));

endmodule

