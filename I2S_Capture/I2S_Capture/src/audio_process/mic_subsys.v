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
    ,input           PAD_DATA
    ,input           PAD_KEY1
    ,input           PAD_KEY2
    ,output          PAD_CLK_MIC
    ,output          PAD_LCK_WS
    ,output          PAD_LCTL
    ,output          PAD_TXD
);

wire signed [24-1:0]    I2S_L_Data;
wire signed [24-1:0]    I2S_R_Data;
wire signed [16-1:0]    Fifo_out;
wire                    WrEn_i;
wire                    RdEn_i;
wire                    clk_ref;
wire                    fifo_empty;

i2s_decoder#(
	 .DATAWIDTH         (24)
)
u_i2s_decoder(
	 .clk_mic           (o_mic_sclk) //i
	,.rst_mic_n         (i_rst_n) //i
	,.WS                (o_mic_ws) //i
	,.DATA              (i_mic_data) //i
	,.L_DATA            (I2S_L_Data) //o[DATAWIDTH - 1: 0]
	,.R_DATA            (I2S_R_Data) //o[DATAWIDTH - 1: 0]
	,.recv_over         (WrEn_i) //o
);

FIFO_HS_Top u_FIFO_HS_Top(
    .Data               (I2S_L_Data[24- 1: 8]), //input [15:0] Data
    .WrClk              (o_mic_ws), //input WrClk
    .RdClk              (i_clk), //input RdClk
    .WrEn               (!key1), //input WrEn
    .RdEn               (RdEn_i), //input RdEn
    .Wnum               (), //output [14:0] Wnum
    .Rnum               (), //output [14:0] Rnum
    .Almost_Empty       (), //output Almost_Empty
    .Almost_Full        (), //output Almost_Full
    .Q                  (Fifo_out), //output [15:0] Q
    .Empty              (fifo_empty), //output Empty
    .Full               () //output Full
);

//fifo_top u_fifo_top(
//     .Data               (I2S_L_Data[16- 1: 0]) //input [15:0] Data
//    ,.WrClk              (o_mic_ws) //input WrClk
//    ,.RdClk              (i_clk) //input RdClk
//    ,.WrEn               (!key1) //input WrEn
//    ,.RdEn               (RdEn_i) //input RdEn
//    ,.Almost_Empty       () //output Almost_Empty
//    ,.Almost_Full        () //output Almost_Full
//    ,.Q                  (Fifo_out) //output [15:0] Q
//    ,.Empty              (fifo_empty) //output Empty
//    ,.Full               () //output Full
//);

uart_top u_uart_top
(
	 .sys_clk		    (i_clk)//i
	,.sys_rst_n		    (i_rst_n)//i
	,.data	            (Fifo_out)//i[16- 1: 0]
    ,.uart_ena          ((!key2)&(!fifo_empty))//i
	,.uart_ready	    (RdEn_i)//o
	,.uart_txd		    (o_mic_txd)//o	
);

clk_div#(
    .SCALER             (9)
)
u_clk_div_9
(
     .clk_in         (i_clk)
    ,.rst_n          (i_rst_n)
    ,.clk_out        (o_mic_sclk)//3MHz
);

clk_div#(
   .SCALER             (64)
)
u_clk_div_64
(
    .clk_in         (!o_mic_sclk)
   ,.rst_n          (i_rst_n)
   ,.clk_out        (o_mic_ws)//46875Hz
);

gao_clk u_gao_clk(
    .clkout(clk_ref), //output clkout
    .reset(!i_rst_n), //input reset
    .clkin(i_clk) //input clkin
);


assign key1         = PAD_KEY1;
assign key2         = PAD_KEY2;
assign i_clk        = PAD_CLK;
assign i_rst_n      = PAD_RST_N;
assign i_mic_data   = PAD_DATA;
assign PAD_CLK_MIC  = o_mic_sclk;
assign PAD_LCK_WS   = o_mic_ws;
assign PAD_TXD      = o_mic_txd;
assign PAD_LCTL     = 1'b0;

endmodule