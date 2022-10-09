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

module mic_subsys (
     input           PAD_CLK
    ,input           PAD_RST_N
    ,input           PAD_KEY1
    ,input           PAD_KEY2
    ,input           PAD_MIC0_DA
    ,input           PAD_MIC1_DA
    ,output          PAD_WS0
    ,output          PAD_WS1
    ,output          PAD_CLK_MIC0
    ,output          PAD_CLK_MIC1
    ,output          PAD_TXD
);

wire signed [24-1:0]    I2S_L_Data;
wire signed [24-1:0]    I2S_R_Data;
wire signed [16-1:0]    Fifo_out_L;
wire signed [16-1:0]    Fifo_out_R;
wire                    RdEn_i;
wire                    clk_ref;
wire                    fifo_empty;
wire                    clk_60MHz;
wire        [32- 1: 0]  Fifo_data;

assign Fifo_data = {Fifo_out_L,Fifo_out_R};

i2s_decoder#(
	 .DATAWIDTH         (24)
)
u_i2s_decoder0(
	 .clk_mic           (o_mic_sclk) //i
	,.rst_mic_n         (i_rst_n) //i
	,.WS                (o_mic_ws) //i
	,.DATA              (i_mic_data_l) //i
	,.L_DATA            (I2S_L_Data) //o[DATAWIDTH - 1: 0]
	,.R_DATA            () //o[DATAWIDTH - 1: 0]
    ,.L_Sel             ()
	,.R_Sel             ()
	,.recv_over         () //o
);

i2s_decoder#(
	 .DATAWIDTH         (24)
)
u_i2s_decoder1(
	 .clk_mic           (o_mic_sclk) //i
	,.rst_mic_n         (i_rst_n) //i
	,.WS                (o_mic_ws) //i
	,.DATA              (i_mic_data_r) //i
	,.L_DATA            (I2S_R_Data) //o[DATAWIDTH - 1: 0]
	,.R_DATA            () //o[DATAWIDTH - 1: 0]
    ,.L_Sel             ()
	,.R_Sel             ()
	,.recv_over         () //o
);

FIFO_HS_Top u_FIFO_L_Top(
    .Data               (I2S_L_Data[24- 1: 8]), //input [15:0] Data
    .WrClk              (o_mic_ws), //input WrClk
    .RdClk              (clk_60MHz), //input RdClk
    .WrEn               (!key1), //input WrEn
    .RdEn               (RdEn_i), //input RdEn
    .Wnum               (), //output [14:0] Wnum
    .Rnum               (), //output [14:0] Rnum
    .Almost_Empty       (), //output Almost_Empty
    .Almost_Full        (), //output Almost_Full
    .Q                  (Fifo_out_L), //output [15:0] Q
    .Empty              (), //output Empty
    .Full               () //output Full
);

FIFO_HS_Top u_FIFO_R_Top(
    .Data               (I2S_R_Data[24- 1: 8]), //input [15:0] Data
    .WrClk              (o_mic_ws), //input WrClk
    .RdClk              (clk_60MHz), //input RdClk
    .WrEn               (!key1), //input WrEn
    .RdEn               (RdEn_i), //input RdEn
    .Wnum               (), //output [14:0] Wnum
    .Rnum               (), //output [14:0] Rnum
    .Almost_Empty       (), //output Almost_Empty
    .Almost_Full        (), //output Almost_Full
    .Q                  (Fifo_out_R), //output [15:0] Q
    .Empty              (fifo_empty), //output Empty
    .Full               () //output Full
);

uart_top u_uart_top
(
	 .sys_clk		    (clk_60MHz)//i
	,.sys_rst_n		    (i_rst_n)//i
	,.data	            (Fifo_data)//i[16- 1: 0]
    ,.uart_ena          ((!key2)&(!fifo_empty))//i
	,.uart_ready	    (RdEn_i)//o
	,.uart_txd		    (o_mic_txd)//o	
);

clk_div#(
    .SCALER             (20)
)
u_clk_div_9
(
     .clk_in         (clk_60MHz)
    ,.rst_n          (i_rst_n)
    ,.clk_out        (o_mic_sclk)//3MHz
);

clk_div#(
   .SCALER           (64)
)
u_clk_div_64
(
    .clk_in         (!o_mic_sclk)
   ,.rst_n          (i_rst_n)
   ,.clk_out        (o_mic_ws)//46875Hz
);

gao_clk u_gao_clk(
    .clkout         (clk_60MHz), //output clkout
    .reset          (!i_rst_n), //input reset
    .clkin          (i_clk) //input clkin
);


assign key1         = PAD_KEY1;
assign key2         = PAD_KEY2;
assign i_clk        = PAD_CLK;
assign i_rst_n      = PAD_RST_N;
assign i_mic_data_l = PAD_MIC0_DA;
assign i_mic_data_r = PAD_MIC1_DA;
assign PAD_WS0      = o_mic_ws;
assign PAD_WS1      = o_mic_ws;
assign PAD_CLK_MIC0 = o_mic_sclk;
assign PAD_CLK_MIC1 = o_mic_sclk;
assign PAD_LR0      = 1'b0;
assign PAD_LR1      = 1'b0;
assign PAD_TXD      = o_mic_txd;
endmodule