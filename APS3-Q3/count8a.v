`timescale 1ps/1ps

module count8a (
    output wire [7:0] CNT,
    input  wire clk,
    input  wire res,
    input  wire EN,
    input  wire load,
    input  wire [7:0] CNT_In
);

    wire [7:0] CNT_m1;
    wire [7:0] D_en;
    wire [7:0] D_in;
    wire Cout;

    adder8b adder(.S(CNT_m1),.Cout(Cout),.A(CNT),.B(8'b00000001),.Cin(1'b0));

    mux8b mux_en(D_en, CNT, CNT_m1, EN);

    mux8b mux_load(D_in, D_en, CNT_In, load);

    dflipflop ff0(.Q(CNT[0]), .Qn(), .Clock(clk), .Reset(res), .Preset(1'b1), .D(D_in[0]));
    dflipflop ff1(.Q(CNT[1]), .Qn(), .Clock(clk), .Reset(res), .Preset(1'b1), .D(D_in[1]));
    dflipflop ff2(.Q(CNT[2]), .Qn(), .Clock(clk), .Reset(res), .Preset(1'b1), .D(D_in[2]));
    dflipflop ff3(.Q(CNT[3]), .Qn(), .Clock(clk), .Reset(res), .Preset(1'b1), .D(D_in[3]));
    dflipflop ff4(.Q(CNT[4]), .Qn(), .Clock(clk), .Reset(res), .Preset(1'b1), .D(D_in[4]));
    dflipflop ff5(.Q(CNT[5]), .Qn(), .Clock(clk), .Reset(res), .Preset(1'b1), .D(D_in[5]));
    dflipflop ff6(.Q(CNT[6]), .Qn(), .Clock(clk), .Reset(res), .Preset(1'b1), .D(D_in[6]));
    dflipflop ff7(.Q(CNT[7]), .Qn(), .Clock(clk), .Reset(res), .Preset(1'b1), .D(D_in[7]));

endmodule
