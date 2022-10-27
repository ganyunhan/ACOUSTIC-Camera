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
    // ,output             PAD_UART_TX
    ,output             PAD_LCD_DCLK	
	,output             PAD_LCD_HS            //lcd horizontal synchronization
	,output             PAD_LCD_VS            //lcd vertical synchronization        
	,output             PAD_LCD_DE            //lcd data enable     
	,output[4:0]        PAD_LCD_R             //lcd red
	,output[5:0]        PAD_LCD_G             //lcd green
	,output[4:0]        PAD_LCD_B	          //lcd blue
);

wire                    clk_60MHz;
wire                    clk_20MHz;
wire                    clk_9MHz;
wire                    clk_6MHz;

wire                    rst_mic_n;

wire [4 - 1: 0]         mic_data_in;
wire [6 - 1: 0]         lag_diff [6 - 1: 0];
wire [32- 1: 0]         x_2d;
wire [32- 1: 0]         y_2d;
wire                    done;

wire                    syn_off0_hs;
wire                    syn_off0_vs;
wire                    out_de; 
wire                    syn_off0_re;
wire  [16- 1: 0]        thd_rgb_data;

clock_manage U_CLOCK_MANAGE(
     .ext_clk           (ext_clk            ) //i
    ,.rst_n             (rst_n              ) //i
    ,.clk_60MHz         (clk_60MHz          ) //o
    ,.clk_20MHz         (clk_20MHz          ) //o
    ,.clk_9MHz          (clk_9MHz           ) //o
    ,.clk_6MHz          (clk_6MHz           ) //o
    ,.clk_WS            (clk_WS             ) //o
    ,.rst_mic_n         (rst_mic_n          ) //o
);

mic_subsys#(
    .LAGNUM                 (16                 )
)
U_MIC_SUBSYS
(
     .clk                   (clk_20MHz          ) //input                         
    ,.clk_mic               (clk_6MHz           ) //input                         
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
    ,.clk_pix               (clk_9MHz           ) //input                     
    ,.rst_n                 (rst_n              ) //input                                  
    // ,.ena                   (1'b1        ) //input 
    ,.ena                   (subsys_done        ) //input                                       
    ,.lag_diff_in_0         (lag_diff[0]        ) //input  signed [6 - 1: 0]
    ,.lag_diff_in_1         (lag_diff[1]        ) //input  signed [6 - 1: 0]
    ,.lag_diff_in_2         (lag_diff[2]        ) //input  signed [6 - 1: 0]
    ,.lag_diff_in_3         (lag_diff[3]        ) //input  signed [6 - 1: 0]
    ,.lag_diff_in_4         (lag_diff[4]        ) //input  signed [6 - 1: 0]
    ,.lag_diff_in_5         (lag_diff[5]        ) //input  signed [6 - 1: 0]
    // ,.lag_diff_in_0         (-1        ) //input  signed [6 - 1: 0]
    // ,.lag_diff_in_1         (-6        ) //input  signed [6 - 1: 0]
    // ,.lag_diff_in_2         (-6       ) //input  signed [6 - 1: 0]
    // ,.lag_diff_in_3         (2       ) //input  signed [6 - 1: 0]
    // ,.lag_diff_in_4         (5        ) //input  signed [6 - 1: 0]
    // ,.lag_diff_in_5         (5        ) //input  signed [6 - 1: 0]             
    ,.x_2d                  (x_2d               ) //output reg    [32- 1: 0]               
    ,.y_2d                  (y_2d               ) //output reg    [32- 1: 0]           
    ,.done                  (done               ) //output reg                         
);

// uart_top U_UART_TOP
// (
// 	 .sys_clk		        (clk_60MHz          )//i
// 	,.sys_rst_n		        (rst_n              )//i
// 	,.data	                (x_2d               )//i[16- 1: 0]
//  ,.uart_ena              (done               )//i
// 	,.uart_ready	        ()//o
// 	,.uart_txd		        (uart_tx            )//o	
// );

thd_show U_THD_SHOW(
     .clk_pix               (clk_9MHz           ) //input             
    ,.rst_n                 (rst_n              ) //input
    ,.ena                   (done               ) //input                
    ,.pix_x_in              (x_2d               ) //input      [32- 1: 0]              
    ,.pix_y_in              (y_2d               ) //input      [32- 1: 0]              
    ,.syn_off0_hs           (syn_off0_hs        ) //output               
    ,.syn_off0_vs           (syn_off0_vs        ) //output               
    ,.out_de                (out_de             ) //output             
    ,.syn_off0_re           (syn_off0_re        ) //output               
    ,.thd_rgb_data          (thd_rgb_data       ) //output reg [15:0]   
);

assign ext_clk          = PAD_CLK;
assign rst_n            = PAD_RST_N;
assign mic_data_in[0]   = PAD_MIC0_DA;
assign mic_data_in[1]   = PAD_MIC12_DA;
assign mic_data_in[2]   = PAD_MIC34_DA;
assign mic_data_in[3]   = PAD_MIC56_DA;
assign subsys_start     = 1'b1;
assign PAD_WS           = clk_WS;
assign PAD_CLK_MIC      = clk_6MHz;
// assign PAD_UART_TX      = uart_tx;
assign PAD_LCD_DCLK     = clk_9MHz;
assign PAD_LCD_HS       = syn_off0_hs;
assign PAD_LCD_VS       = syn_off0_vs;
assign PAD_LCD_DE       = out_de;
assign PAD_LCD_R        = thd_rgb_data[16- 1:11];   
assign PAD_LCD_G        = thd_rgb_data[11- 1: 5]; 
assign PAD_LCD_B        = thd_rgb_data[5 - 1: 0]; 	 

endmodule