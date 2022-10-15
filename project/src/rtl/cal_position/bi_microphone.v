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
    ,output reg                 done
);

localparam FREQ = 93750; // fs = 46875Hz
localparam MIC_DIS = 6; // mic_dis = 0.06m
localparam AVG_NUM = 16;

reg signed [32- 1: 0] distance_diff    =   32'b0;
reg [32- 1: 0] address_latch    =   32'b0;
reg [16- 1: 0] angel_tab        =   16'b0;

always @(*) begin
    distance_diff = (lag_diff *1000 * 340*135) / (FREQ);
    address_latch = (distance_diff / (MIC_DIS) ) + 999;
end

wire        [16- 1: 0] abs_angel;
reg signed  [16- 1: 0] angel_r;
reg                    ena_r;
reg                    ena_rr;
always @(posedge clk_60MHz or negedge rst_n) begin
    if (!rst_n) begin
        ena_r <= 1'b0;
        ena_rr <= 1'b0;
        angel_r <= 16'b0;
    end else if (ena) begin
        // if (lag_diff < 0) begin
        //     angel_r <= -abs_angel;
        // end else begin
            ena_r <= 1'b1;
            ena_rr <= ena_r;
            angel_r <= abs_angel;
        // end
    end else begin
        ena_r <=1'b0;
        ena_rr <= ena_r;
        angel_r <= angel_r;
    end
end

//average 16 times
reg [5 - 1: 0] cnt              = 5'b0;
always @(posedge clk_60MHz or negedge rst_n) begin
    if (!rst_n) begin
        angel_tab <= 16'b0;
        cnt <= 5'b0;
    end else if (cnt < AVG_NUM && ena_r) begin
        angel_tab <= angel_tab + angel_r;
        cnt = cnt + 1'b1; 
    end else if (cnt == AVG_NUM && ena_r) begin
        angel_tab <= 16'b0;
        cnt <= 0;
    end else begin
        cnt <= cnt;
    end
end

reg [16- 1: 0] angel_avg        = 16'b0;
always @(posedge clk_60MHz or negedge rst_n) begin
    if (!rst_n) begin
        done <= 1'b0;
    end else if (cnt < AVG_NUM && ena_rr) begin
        done <= 1'b0;
    end else if (cnt == AVG_NUM && ena_rr) begin
        angel_avg <= angel_tab / AVG_NUM;
        done <= 1'b1;
    end else if (cnt == AVG_NUM)begin
        done <= 1'b0;
    end else begin
        angel_avg <= angel_avg;
        done <= done;
    end
end

assign angel = angel_avg;

acos_rom U_ACOS_ROM(
    .clk            (clk_60MHz      ), //input clk
    .reset          (!rst_n         ), //input reset
    .oce            (1'b1           ), //input oce
    .ce             (1'b1           ), //input ce  
    .ad             (address_latch  ), //input [10:0] ad
    .dout           (abs_angel      )  //output [15:0] dout
);

endmodule //bi_microphone
