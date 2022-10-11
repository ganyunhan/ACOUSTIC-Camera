`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Create Date: 27.08.2022
// Designer : Hank.Gan
// Design Name: top
// Description: Top layer of the ACOUSTIC Camera
// Dependencies: Semi dual-port Block RAM 
// Revision 1.0
// Additional Comments: 
//////////////////////////////////////////////////////////////////////////////////
module top (
     input              PAD_CLK
    ,input              PAD_RST_N
    ,input              PAD_XC_EN
    ,input              PAD_MIC0_DA
    ,input              PAD_MIC1_DA
    ,output             PAD_LR0
    ,output             PAD_LR1
    ,output             PAD_WS0
    ,output             PAD_WS1
    ,output             PAD_CLK_MIC0
    ,output             PAD_CLK_MIC1
    ,output             PAD_UART_TX
);

wire                    clk_60MHz;
wire                    clk_2MHz;
wire                    rst_mic_n;
wire signed [16- 1: 0]  angel;
wire                    done;
wire [6 - 1: 0]         lag_diff;
wire [16-1:   0]        lagdiff_16;
clock_manage U_CLOCK_MANAGE(
     .ext_clk           (ext_clk            ) //i
    ,.rst_n             (rst_n              ) //i
    ,.clk_60MHz         (clk_60MHz          ) //o
    ,.clk_2MHz          (clk_2MHz           ) //o
    ,.clk_WS            (clk_WS             ) //o
    ,.rst_mic_n         (rst_mic_n          ) //o
);

mic_subsys#(
    .LAGNUM             (16                 )
)
U_MIC_SUBSYS
(
     .clk_60MHz         (clk_60MHz          ) //i
    ,.clk_mic           (clk_2MHz           ) //i
    ,.clk_WS            (clk_WS             ) //i
    ,.rst_n             (rst_n              ) //i
    ,.rst_mic_n         (rst_mic_n          ) //i
    ,.mic0_data_in      (mic0_data_in       ) //i
    ,.mic1_data_in      (mic1_data_in       ) //i
    ,.subsys_start      (subsys_start       ) //i
    ,.subsys_done       (subsys_done        ) //o
    ,.lag_diff          (lag_diff           ) //o[6 - 1: 0]
);

bi_microphone U_BI_MIC(
     .clk_60MHz         (clk_60MHz          ) //i                             
    ,.rst_n             (rst_n              ) //i     
    ,.ena               (subsys_done        ) //i            
    ,.lag_diff          (lag_diff           ) //i[6 - 1: 0]                     
    ,.angel             (angel              ) //o[16 - 1: 0]
    ,.done              (done               ) //o        
);

uart_top U_UART_TOP
(
	 .sys_clk		    (clk_60MHz          )//i
	,.sys_rst_n		    (rst_n              )//i
	,.data	            (angel        )//i[16- 1: 0]
    ,.uart_ena          (done               )//i
	,.uart_ready	    ()//o
	,.uart_txd		    (uart_txd           )//o	
);

assign ext_clk      = PAD_CLK;
assign rst_n        = PAD_RST_N;
assign mic0_data_in = PAD_MIC0_DA;
assign mic1_data_in = PAD_MIC1_DA;
assign subsys_start = !PAD_XC_EN;
assign PAD_WS0      = clk_WS;
assign PAD_WS1      = clk_WS;
assign PAD_CLK_MIC0 = clk_2MHz;
assign PAD_CLK_MIC1 = clk_2MHz;
assign PAD_LR0      = 1'b0;
assign PAD_LR1      = 1'b0;
assign PAD_UART_TX  = uart_txd;
//assign lagdiff_16[6-1:0]=lag_diff;
//assign lagdiff_16[16-1]=lag_diff[6-1];
//assign lagdiff_16[15-1:6]=9'b0;
assign lagdiff_16=16'd13;

endmodule