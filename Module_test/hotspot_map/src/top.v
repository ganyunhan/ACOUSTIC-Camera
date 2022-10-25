module top (
     input              PAD_CLK
    ,input              PAD_RST_N
    ,output             PAD_LCD_DCLK	
	,output             PAD_LCD_HS            //lcd horizontal synchronization
	,output             PAD_LCD_VS            //lcd vertical synchronization        
	,output             PAD_LCD_DE            //lcd data enable     
	,output[4:0]        PAD_LCD_R             //lcd red
	,output[5:0]        PAD_LCD_G             //lcd green
	,output[4:0]        PAD_LCD_B	          //lcd blue
);

wire                    clk_9MHz;
wire                    syn_off0_hs;
wire                    syn_off0_vs;
wire                    out_de; 
wire                    syn_off0_re;
wire  [16- 1: 0]        thd_rgb_data;

clk_div #(
    .SCALER                 (3              )
)
U_CLK_DIV_3
(
     .clk_in                (ext_clk        ) //i
    ,.rst_n                 (rst_n          ) //i
    ,.clk_out               (clk_9MHz       ) //o
);

thd_show U_THD_SHOW(
     .clk_pix               (clk_9MHz           ) //input
    ,.ena                   (1'b1               )
    ,.rst_n                 (rst_n              ) //input                
    ,.pix_x_in              (135     ) //input  [16- 1: 0]              
    ,.pix_y_in              (362     ) //input  [16- 1: 0]              
    ,.syn_off0_hs           (syn_off0_hs        ) //output               
    ,.syn_off0_vs           (syn_off0_vs        ) //output               
    ,.out_de                (out_de             ) //output             
    ,.syn_off0_re           (syn_off0_re        ) //output               
    ,.thd_rgb_data          (thd_rgb_data       ) //output reg [15:0]    
);

assign ext_clk          = PAD_CLK;
assign rst_n            = PAD_RST_N;

assign PAD_LCD_DCLK     = clk_9MHz;
assign PAD_LCD_HS       = syn_off0_hs;
assign PAD_LCD_VS       = syn_off0_vs;
assign PAD_LCD_DE       = out_de;
assign PAD_LCD_R        = thd_rgb_data[16- 1:11];   
assign PAD_LCD_G        = thd_rgb_data[11- 1: 5]; 
assign PAD_LCD_B        = thd_rgb_data[5 - 1: 0]; 	 

endmodule