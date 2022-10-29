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
     input                  PAD_CLK
    ,input                  PAD_RST_N
    ,input                  PAD_XC_EN
    ,input                  PAD_MIC0_DA
    ,input                  PAD_MIC12_DA
    ,input                  PAD_MIC34_DA
    ,input                  PAD_MIC56_DA
    ,output                 PAD_WS
    ,output                 PAD_CLK_MIC
    ,output                 PAD_UART_TX

    ,output                 PAD_CMOS_SCL 
    ,inout                  PAD_CMOS_SDA 
    ,input                  PAD_CMOS_VSYN
    ,input                  PAD_CMOS_HREF
    ,input                  PAD_CMOS_PCLK
    ,output                 PAD_CMOS_XCLK
    ,input [8 - 1: 0]       PAD_CMOS_DATA
    ,output                 PAD_CMOS_RST 
    ,output                 PAD_CMOS_PWDN

    ,output                 PAD_LCD_DCLK
	,output                 PAD_LCD_HS      
	,output                 PAD_LCD_VS       
	,output                 PAD_LCD_DE      
	,output[5 - 1: 0]       PAD_LCD_R       
	,output[6 - 1: 0]       PAD_LCD_G       
	,output[5 - 1: 0]       PAD_LCD_B	    
);

wire                        clk_60MHz;
wire                        clk_24MHz;
wire                        clk_12MHz;
wire                        clk_9MHz;
wire                        clk_6MHz;

wire                        rst_mic_n;

wire [4 - 1: 0]             mic_data_in;
wire [6 - 1: 0]             lag_diff [6 - 1: 0];
wire [26- 1: 0]             x_2d;
wire [26- 1: 0]             y_2d;
wire                        done;

wire                        cmos_scl;
wire                        cmos_sda;
wire                        cmos_vsync;
wire                        cmos_href;
wire                        cmos_pclk;
wire                        cmos_xclk;
wire [8 - 1: 0]             cmos_db;
wire                        cmos_rst_n;
wire                        cmos_pwdn;
wire                        lcd_dclk;
wire                        lcd_hs;
wire                        lcd_vs;
wire                        lcd_de;
wire [5 - 1: 0]             lcd_r;
wire [6 - 1: 0]             lcd_g;
wire [5 - 1: 0]             lcd_b;

clock_manage U_CLOCK_MANAGE(
     .ext_clk               (ext_clk            ) //i
    ,.rst_n                 (rst_n              ) //i
    ,.clk_60MHz             (clk_60MHz          ) //o
    ,.clk_24MHz             (clk_24MHz          ) //o
    ,.clk_12MHz             (clk_12MHz          ) //o
    ,.clk_9MHz              (clk_9MHz           ) //o
    ,.clk_6MHz              (clk_6MHz           ) //o
    ,.clk_WS                (clk_WS             ) //o
    ,.rst_mic_n             (rst_mic_n          ) //o
);

mic_subsys#(
    .LAGNUM                 (16                 )
)
U_MIC_SUBSYS
(
     .clk                   (clk_12MHz          ) //input                         
    ,.clk_mic               (clk_6MHz           ) //input                         
    ,.clk_WS                (clk_WS             ) //input                         
    ,.rst_n                 (rst_n              ) //input                             
    ,.rst_mic_n             (rst_mic_n          ) //input                             
    ,.mic_data_in           (mic_data_in        ) //input [4 - 1: 0]      
    ,.subsys_start          (subsys_start       ) //input                         
    ,.subsys_done           (subsys_done        ) //output reg      
    ,.valid                 (valid              ) //output             
    ,.lag_diff_0            (lag_diff[0]        ) //output  signed   [6 - 1: 0]    
    ,.lag_diff_1            (lag_diff[1]        ) //output  signed   [6 - 1: 0]    
    ,.lag_diff_2            (lag_diff[2]        ) //output  signed   [6 - 1: 0]    
    ,.lag_diff_3            (lag_diff[3]        ) //output  signed   [6 - 1: 0]    
    ,.lag_diff_4            (lag_diff[4]        ) //output  signed   [6 - 1: 0]    
    ,.lag_diff_5            (lag_diff[5]        ) //output  signed   [6 - 1: 0]    
);

cal_position U_CAL_POSITION(
     .clk                   (clk_12MHz          ) //input    
    ,.clk_pix               (clk_9MHz           ) //input                     
    ,.rst_n                 (rst_n              ) //input                                  
    ,.ena                   (subsys_done&valid  ) //input                                       
    ,.lag_diff_in_0         (lag_diff[0]        ) //input  signed [6 - 1: 0]
    ,.lag_diff_in_1         (lag_diff[1]        ) //input  signed [6 - 1: 0]
    ,.lag_diff_in_2         (lag_diff[2]        ) //input  signed [6 - 1: 0]
    ,.lag_diff_in_3         (lag_diff[3]        ) //input  signed [6 - 1: 0]
    ,.lag_diff_in_4         (lag_diff[4]        ) //input  signed [6 - 1: 0]
    ,.lag_diff_in_5         (lag_diff[5]        ) //input  signed [6 - 1: 0]          
    ,.x_2d                  (x_2d               ) //output reg    [32- 1: 0]               
    ,.y_2d                  (y_2d               ) //output reg    [32- 1: 0]           
    ,.done                  (done               ) //output reg                         
);

video_subsys U_VIDEO_SUBSYS(
	 .video_clk             (clk_9MHz           ) // input      
    ,.ext_clk               (ext_clk            ) // input
	,.cmos_clk              (clk_24MHz          ) //,input				        
	,.rst_n                 (rst_n              ) //,input                       
	,.cmos_scl              (cmos_scl           ) //,output             cmos i2c clock
	,.cmos_sda              (PAD_CMOS_SDA       ) //,inout              cmos i2c data
	,.cmos_vsync            (cmos_vsync         ) //,input              cmos vsync
	,.cmos_href             (cmos_href          ) //,input              cmos hsync refrence,data valid
	,.cmos_pclk             (cmos_pclk          ) //,input              cmos pxiel clock
    ,.cmos_xclk             (cmos_xclk          ) //,output             cmos externl clock 
	,.cmos_db               (cmos_db            ) //,input   [8 - 1: 0] cmos data
	,.cmos_rst_n            (cmos_rst_n         ) //,output             cmos reset 
	,.cmos_pwdn             (cmos_pwdn          ) //,output             cmos power down
	,.ena                   (done               ) //,input				    
	,.pix_x_in              (x_2d               ) //,input   [16- 1: 0]             
    ,.pix_y_in              (y_2d               ) //,input   [16- 1: 0] 
	,.lcd_dclk	            (lcd_dclk           ) //,output                      
	,.lcd_hs                (lcd_hs             ) //,output             lcd horizontal synchronization
	,.lcd_vs                (lcd_vs             ) //,output             lcd vertical synchronization        
	,.lcd_de                (lcd_de             ) //,output             lcd data enable     
	,.lcd_r                 (lcd_r              ) //,output  [5 - 1: 0] lcd red
	,.lcd_g                 (lcd_g              ) //,output  [6 - 1: 0] lcd green
	,.lcd_b	                (lcd_b              ) //,output  [5 - 1: 0] lcd blue
);

// uart_top U_UART_TOP
// (
// 	 .sys_clk		        (clk_60MHz          )//i
// 	,.sys_rst_n		        (rst_n              )//i
// 	,.data	                ({26'b0,{lag_diff[0]}})//i[32- 1: 0]
//  ,.uart_ena              (subsys_done        )//i
// 	,.uart_ready	        ()//o
// 	,.uart_txd		        (uart_tx            )//o	
// );

assign ext_clk              = PAD_CLK;
assign rst_n                = PAD_RST_N;
assign mic_data_in[0]       = PAD_MIC0_DA;
assign mic_data_in[1]       = PAD_MIC12_DA;
assign mic_data_in[2]       = PAD_MIC34_DA;
assign mic_data_in[3]       = PAD_MIC56_DA;

assign cmos_vsync           = PAD_CMOS_VSYN;
assign cmos_href            = PAD_CMOS_HREF;
assign cmos_pclk            = PAD_CMOS_PCLK;
assign cmos_db              = PAD_CMOS_DATA;
assign subsys_start         = 1'b1;

// assign PAD_UART_TX          = uart_tx;
assign PAD_WS               = clk_WS;
assign PAD_CLK_MIC          = clk_6MHz;
assign PAD_CMOS_SCL         = cmos_scl  ;
assign PAD_CMOS_XCLK        = cmos_xclk ;
assign PAD_CMOS_RST         = cmos_rst_n;
assign PAD_CMOS_PWDN        = cmos_pwdn ;
assign PAD_LCD_DCLK         = lcd_dclk;
assign PAD_LCD_HS           = lcd_hs;
assign PAD_LCD_VS           = lcd_vs;
assign PAD_LCD_DE           = lcd_de;
assign PAD_LCD_R            = lcd_r;   
assign PAD_LCD_G            = lcd_g; 
assign PAD_LCD_B            = lcd_b; 	 

endmodule