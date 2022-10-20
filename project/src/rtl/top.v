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
    ,input              PAD_MIC12_DA
    ,input              PAD_MIC34_DA
    ,input              PAD_MIC56_DA
    ,output             PAD_WS
    ,output             PAD_CLK_MIC
    ,output             PAD_UART_TX
);

wire                    clk_60MHz;
wire                    clk_20MHz;
wire                    clk_2MHz;
wire                    rst_mic_n;
wire [4 - 1: 0]         mic_data_in;
wire [6 - 1: 0]         lag_diff [6 - 1: 0];
wire [32- 1: 0]         x_2d;
wire [32- 1: 0]         y_2d;
wire                    done;

clock_manage U_CLOCK_MANAGE(
     .ext_clk           (ext_clk            ) //i
    ,.rst_n             (rst_n              ) //i
    ,.clk_60MHz         (clk_60MHz          ) //o
    ,.clk_20MHz         (clk_20MHz          ) //o
    ,.clk_2MHz          (clk_2MHz           ) //o
    ,.clk_WS            (clk_WS             ) //o
    ,.rst_mic_n         (rst_mic_n          ) //o
);

// mic_subsys#(
//     .LAGNUM             (16                 )
// )
// U_MIC_SUBSYS
// (
//      .clk_60MHz         (clk_60MHz          ) //i
//     ,.clk_mic           (clk_2MHz           ) //i
//     ,.clk_WS            (clk_WS             ) //i
//     ,.rst_n             (rst_n              ) //i
//     ,.rst_mic_n         (rst_mic_n          ) //i
//     ,.mic0_data_in      (mic0_data_in       ) //i
//     ,.mic1_data_in      (mic1_data_in       ) //i
//     ,.subsys_start      (subsys_start       ) //i
//     ,.subsys_done       (subsys_done        ) //o
//     ,.lag_diff          (lag_diff           ) //o[6 - 1: 0]
// );

mic_subsys#(
    .LAGNUM                 (16                 )
)
U_MIC_SUBSYS
(
     .clk                   (clk_20MHz          ) //input                         
    ,.clk_mic               (clk_2MHz           ) //input                         
    ,.clk_WS                (clk_WS             ) //input                         
    ,.rst_n                 (rst_n              ) //input                             
    ,.rst_mic_n             (rst_mic_n          ) //input                             
    ,.mic_data_in           (mic_data_in        ) //input [4 - 1: 0]      
    ,.subsys_start          (subsys_start       ) //input                         
    ,.subsys_done           (subsys_done        ) //output reg                    
    ,.lag_diff_0            (lag_diff[0]        ) //output  signed   [6 - 1: 0]    
    ,.lag_diff_1            (lag_diff[1]        ) //output  signed   [6 - 1: 0]    
    ,.lag_diff_2            (lag_diff[2]        ) //output  signed   [6 - 1: 0]    
    ,.lag_diff_3            (lag_diff[3]        ) //output  signed   [6 - 1: 0]    
    ,.lag_diff_4            (lag_diff[4]        ) //output  signed   [6 - 1: 0]    
    ,.lag_diff_5            (lag_diff[5]        ) //output  signed   [6 - 1: 0]    
);

// bi_microphone U_BI_MIC(
//      .clk_60MHz         (clk_60MHz          ) //i                             
//     ,.rst_n             (rst_n              ) //i     
//     ,.ena               (subsys_done        ) //i            
//     ,.lag_diff          (lag_diff           ) //i[6 - 1: 0]                     
//     ,.angel             (angel              ) //o[16 - 1: 0]
//     ,.done              (done               ) //o        
// );

cal_position U_CAL_POSITION(
     .clk                   (clk_20MHz          ) //input                         
    ,.rst_n                 (rst_n              ) //input                                  
    ,.ena                   (subsys_done        ) //input                                      
    ,.lag_diff_in_0         (lag_diff[0]        ) //input  signed [6 - 1: 0]
    ,.lag_diff_in_1         (lag_diff[1]        ) //input  signed [6 - 1: 0]
    ,.lag_diff_in_2         (lag_diff[2]        ) //input  signed [6 - 1: 0]
    ,.lag_diff_in_3         (lag_diff[3]        ) //input  signed [6 - 1: 0]
    ,.lag_diff_in_4         (lag_diff[4]        ) //input  signed [6 - 1: 0]
    ,.lag_diff_in_5         (lag_diff[5]        ) //input  signed [6 - 1: 0]
    ,.x_position            () //output signed [32- 1: 0]                   
    ,.y_position            () //output signed [32- 1: 0]                   
    ,.z_position            () //output        [16- 1: 0]               
    ,.x_2d                  (x_2d               ) //output reg    [32- 1: 0]               
    ,.y_2d                  (y_2d               ) //output reg    [32- 1: 0]           
    ,.done                  (done               ) //output reg                         
);

uart_top U_UART_TOP
(
	 .sys_clk		        (clk_60MHz          )//i
	,.sys_rst_n		        (rst_n              )//i
	,.data	                (x_2d               )//i[16- 1: 0]
    ,.uart_ena              (done               )//i
	,.uart_ready	        ()//o
	,.uart_txd		        (uart_txd           )//o	
);

assign ext_clk          = PAD_CLK;
assign rst_n            = PAD_RST_N;
assign mic_data_in[0]   = PAD_MIC0_DA;
assign mic_data_in[1]   = PAD_MIC12_DA;
assign mic_data_in[2]   = PAD_MIC34_DA;
assign mic_data_in[3]   = PAD_MIC56_DA;
assign subsys_start     = !PAD_XC_EN;
assign PAD_WS           = clk_WS;
assign PAD_CLK_MIC      = clk_2MHz;
assign PAD_UART_TX      = uart_txd;

endmodule