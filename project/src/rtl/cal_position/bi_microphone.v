`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Create Date: 28.09.2022
// Last Modified : Hank.Gan 28.09.2022
// Designer : Hank.Gan
// Design Name: bi_microphone
// Description: bi_microphone calculate angle system
// Dependencies: none
// Revision 1.0
// Additional Comments: 
//////////////////////////////////////////////////////////////////////////////////
module bi_microphone (
     input                      clk_60MHz
    ,input                      rst_n
    ,input                      ena
    ,input signed [6 - 1: 0]    lag_diff
    ,output signed [16 - 1: 0]  angel
);

localparam FREQ = 3125; // fs = 31250Hz
localparam MIC_DIS = 6; // mic_dis = 0.06m

reg [32- 1: 0] distance_diff    =   32'b0;
reg [32- 1: 0] angel_latch      =   32'b0;

always @(*) begin
    distance_diff = (lag_diff *10000 * 340) / FREQ;
    angel_latch = (distance_diff / (MIC_DIS * 2) ) + 999;
end

wire        [16- 1: 0] abs_angel;
reg signed  [16- 1: 0] angel_r;
always @(posedge clk_60MHz or negedge rst_n) begin
    if (!rst_n) begin
        angel_r <= 16'b0;
    end else if (lag_diff < 0) begin
        angel_r <= -abs_angel;
    end else begin
        angel_r <= abs_angel;
    end
end

assign angel = angel_r;

acos_rom U_ACOS_ROM(
    .clk            (clk_60MHz      ), //input clk
    .reset          (!rst_n         ), //input reset
    .oce            (1'b1           ), //input oce
    .ce             (1'b1            ), //input ce  
    .ad             (angel_latch    ), //input [10:0] ad
    .dout           (abs_angel      )  //output [15:0] dout
);

endmodule //bi_microphone