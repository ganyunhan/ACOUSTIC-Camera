`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Create Date: 26.08.2022
// Last Modified : Hank.Gan 26.08.2022
// Designer : Hank.Gan
// Design Name: mic_subsys
// Description: Microphone Array processing sub-system
// Dependencies: i2s_decoder/
// Revision 1.0
// Additional Comments: 
//////////////////////////////////////////////////////////////////////////////////
module mic_subsys#(
    parameter       LAGNUM = 10
)
(
     input                      clk_60MHz
    ,input                      clk_mic
    ,input                      clk_WS
    ,input                      rst_n
    ,input                      rst_mic_n
    ,input                      mic0_data_in
    ,input                      mic1_data_in
    ,input                      xcorr_start
    ,output reg     [6 - 1: 0]  lag_diff
);

wire                            mic0_data_en;
wire                            mic1_data_en;
wire signed [16- 1: 0]          mic0_data;
wire signed [16- 1: 0]          mic1_data;
wire signed [16- 1: 0]          mic0_fifo_data;
wire signed [16- 1: 0]          mic1_fifo_data;
wire signed [33- 1: 0]          abs_xcorr_data;
wire signed [33- 1: 0]          xcorr_data;
wire                            xcorr_done;
wire signed [17- 1: 0]          series_x;
wire signed [17- 1: 0]          series_y;

//Measuring the number of the biggest xcorr_data
reg signed [6 - 1: 0]   lag;
reg signed [33- 1: 0]   max_xcorr_data;

assign cr_xcorr_bigger = (abs_xcorr_data >= max_xcorr_data) ? 1'b1 : 1'b0;

always @(posedge clk_60MHz or negedge rst_n) begin
    if (!rst_n) begin
        lag <= -LAGNUM;
        max_xcorr_data <= 33'b0;
    end else if (xcorr_done) begin
        lag <= lag + 1'b1;
        lag_diff <= (cr_xcorr_bigger ? lag : lag_diff);
        max_xcorr_data <= (cr_xcorr_bigger ? abs_xcorr_data : max_xcorr_data);
    end else begin
        lag <= lag;
        lag_diff <= lag_diff;
        max_xcorr_data <= max_xcorr_data;
    end
end

abs U_XCORR_ABS(
	 .datai              (xcorr_data        ) //i[32- 1: 0]
    ,.datao              (abs_xcorr_data    ) //o[32- 1: 0]
);

i2s_decoder#(
	 .DATAWIDTH         (24)
)
U_I2S_DECODER_0(
	 .clk_mic           (clk_mic            ) //i
	,.rst_mic_n         (rst_mic_n          ) //i
	,.WS                (clk_WS             ) //i
	,.DATA              (mic0_data_in       ) //i
	,.L_DATA            (mic0_data          ) //o[DATAWIDTH - 1: 0]
	,.R_DATA            () //o[DATAWIDTH - 1: 0]
    ,.L_Sel             () //o
    ,.R_Sel             () //o
	,.recv_over         (mic0_data_en       ) //o
);

i2s_decoder#(
	 .DATAWIDTH         (24)
)
U_I2S_DECODER_1(
	 .clk_mic           (clk_mic            ) //i
	,.rst_mic_n         (rst_mic_n          ) //i
	,.WS                (clk_WS             ) //i
	,.DATA              (mic1_data_in       ) //i
	,.L_DATA            (mic1_data          ) //o[DATAWIDTH - 1: 0]
	,.R_DATA            () //o[DATAWIDTH - 1: 0]
    ,.L_Sel             () //o
    ,.R_Sel             () //o
	,.recv_over         (mic1_data_en       ) //o
);

fifo_mic U_FIFO_MIC0(
    .WrClk              (clk_WS             ), //input WrClk
    .WrEn               (mic0_data_en       ), //input WrEn
    .Data               (mic0_data          ), //input [15:0] Data
    .RdClk              (clk_60MHz          ), //input RdClk
    .RdEn               (xcorr_start        ), //input RdEn
    .Q                  (mic0_fifo_data     ), //output [15:0] Q
    .Almost_Empty       (), //output Almost_Empty
    .Almost_Full        (), //output Almost_Full
    .Empty              (), //output Empty
    .Full               () //output Full
);

fifo_mic U_FIFO_MIC1(
    .WrClk              (clk_WS             ), //input WrClk
    .WrEn               (mic1_data_en       ), //input WrEn
    .Data               (mic1_data          ), //input [15:0] Data
    .RdClk              (clk_60MHz          ), //input RdClk
    .RdEn               (xcorr_start        ), //input RdEn
    .Q                  (mic1_fifo_data     ), //output [15:0] Q
    .Almost_Empty       (), //output Almost_Empty
    .Almost_Full        (), //output Almost_Full
    .Empty              (), //output Empty
    .Full               () //output Full
);

signExtension#(
   .INPUT_WIDTH         (16)
  ,.OUTPUT_WIDTH        (17)
)
U_SIGN_EXTENSION_X(
  .input_number         (mic0_fifo_data), //input  wire signed [INPUT_WIDTH-1  : 0] 
  .output_number        (series_x)  //output wire signed [OUTPUT_WIDTH-1 : 0] 
);

signExtension#(
   .INPUT_WIDTH         (16)
  ,.OUTPUT_WIDTH        (17)
)
U_SIGN_EXTENSION_Y(
  .input_number         (mic1_fifo_data), //input  wire signed [INPUT_WIDTH-1  : 0] 
  .output_number        (series_y)  //output wire signed [OUTPUT_WIDTH-1 : 0] 
);

XCORR_Top U_XCORR_Top(
    .clk                (clk_60MHz          ), //input clk
    .rst                (rst_n              ), //input rst
    .series_x           (series_x           ), //input [15:0] series_x
    .series_y           (series_y           ), //input [15:0] series_y
    .start              (xcorr_start        ), //input start
    .result             (xcorr_data         ), //output [31:0] result
    .complete           (xcorr_done         ), //output complete
    .delay              () //output [9:0] delay
);

endmodule