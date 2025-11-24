`timescale 1ps/1ps

module count8fsm (
    output wire [7:0] CNT,
    input  wire clk,
    input  wire res,
    input  wire EN,
    input  wire load,
    input  wire [7:0] CNT_In
);

    wire [7:0] state;
    wire [7:0] next_state;

    dflipflop ff0(.Q(state[0]), .Qn(), .Clock(clk), .Reset(res), .Preset(1'b1), .D(next_state[0]));
    dflipflop ff1(.Q(state[1]), .Qn(), .Clock(clk), .Reset(res), .Preset(1'b1), .D(next_state[1]));
    dflipflop ff2(.Q(state[2]), .Qn(), .Clock(clk), .Reset(res), .Preset(1'b1), .D(next_state[2]));
    dflipflop ff3(.Q(state[3]), .Qn(), .Clock(clk), .Reset(res), .Preset(1'b1), .D(next_state[3]));
    dflipflop ff4(.Q(state[4]), .Qn(), .Clock(clk), .Reset(res), .Preset(1'b1), .D(next_state[4]));
    dflipflop ff5(.Q(state[5]), .Qn(), .Clock(clk), .Reset(res), .Preset(1'b1), .D(next_state[5]));
    dflipflop ff6(.Q(state[6]), .Qn(), .Clock(clk), .Reset(res), .Preset(1'b1), .D(next_state[6]));
    dflipflop ff7(.Q(state[7]), .Qn(), .Clock(clk), .Reset(res), .Preset(1'b1), .D(next_state[7]));

    wire [7:0] inc_value;
    wire [7:0] after_EN;
    wire Cout;

    adder8b adder1(.S(inc_value),.Cout(Cout),.A(state),.B(8'b00000001),.Cin(1'b0));

    mux8b mux_en(.F(after_EN),.A(state),.B(inc_value),.Sel(EN));
    mux8b mux_load(.F(next_state),.A(after_EN),.B(CNT_In),.Sel(load));

    assign CNT = state;

endmodule
