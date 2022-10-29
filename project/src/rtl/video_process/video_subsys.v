module video_subsys(
	 input                       video_clk
    ,input                       ext_clk
	,input						 cmos_clk
	,input                       rst_n
	,output                      cmos_scl          //cmos i2c clock
	,inout                       cmos_sda          //cmos i2c data
	,input                       cmos_vsync        //cmos vsync
	,input                       cmos_href         //cmos hsync refrence,data valid
	,input                       cmos_pclk         //cmos pxiel clock
    ,output                      cmos_xclk         //cmos externl clock 
	,input   [8 - 1: 0]          cmos_db           //cmos data
	,output                      cmos_rst_n        //cmos reset 
	,output                      cmos_pwdn         //cmos power down

	,input						 ena
	,input   [26- 1: 0]  		 pix_x_in            
    ,input   [26- 1: 0]  		 pix_y_in

	,output                      lcd_dclk	
	,output                      lcd_hs            //lcd horizontal synchronization
	,output                      lcd_vs            //lcd vertical synchronization        
	,output                      lcd_de            //lcd data enable     
	,output  [5 - 1: 0]          lcd_r             //lcd red
	,output  [6 - 1: 0]          lcd_g             //lcd green
	,output  [5 - 1: 0]          lcd_b	           //lcd blue
);

wire                hs;
wire                vs;
wire                de;
wire	[16- 1: 0]  vout_data;
wire	[16- 1: 0]  cmos_16bit_data;
wire	[16- 1: 0]	write_data;

assign 	lcd_hs = hs;
assign 	lcd_vs = vs;
assign 	lcd_de = de;
assign 	lcd_r  = vout_data	[16- 1:11];
assign 	lcd_g  = vout_data	[11- 1: 5];
assign 	lcd_b  = vout_data	[5 - 1: 0];
assign 	lcd_dclk = ~video_clk;
		
assign 	cmos_xclk = cmos_clk;
assign 	cmos_pwdn = 1'b0;
assign 	cmos_rst_n = 1'b1;
assign 	write_data = {cmos_16bit_data[4:0],cmos_16bit_data[10:5],cmos_16bit_data[15:11]};


//I2C master controller
reg 	[32- 1: 0] 	clk_delay = 0;
wire 	iic_rst = clk_delay != 9_000_000;

always@(posedge video_clk, negedge rst_n) begin
    if (!rst_n) begin
		clk_delay = 0;
	end 
    else begin
        clk_delay <=( clk_delay == 9_000_000)? clk_delay : clk_delay + 1;
	end
end

iic_ctrl#(
 	 .CLK_FRE                	(27   			    )
 	,.IIC_FRE                	(100    			)
 	,.IIC_SLAVE_REG_EX       	(1      			)
 	,.IIC_SLAVE_ADDR_EX      	(0      			)
 	,.IIC_SLAVE_ADDR         	(16'h78 			)
 	,.INIT_CMD_NUM           	(255    			)
 ) 
 iic_ctrl_m0
 (
 	 .clk                    	(ext_clk            )
 	,.rst_n                  	(~iic_rst           )
 	,.iic_scl                	(cmos_scl           )
 	,.iic_sda                	(cmos_sda           )
 );

//CMOS sensor 8bit data is converted to 16bit data
cmos_8_16bit U_CMOS_8_16BIT(
	 .rst                      	(~rst_n             )
	,.pclk                     	(cmos_pclk          )
	,.pdata_i                  	(cmos_db            )
	,.de_i                     	(cmos_href          )
	,.pdata_o                  	(cmos_16bit_data    )
	,.hblank                   	(/*reserved*/       )
	,.de_o                     	(cmos_16bit_wr      )
);

//The video output timing generator and generate a frame read data request
video_timing_data video_timing_data_m0
(
	 .video_clk                 (video_clk          )
	,.rst                       (~rst_n             )
	,.ena						(ena				)
	,.fifo_data_in   			(write_data 		)
	,.fifo_data_in_en			(cmos_16bit_wr 		)
	,.fifo_data_in_clk			(cmos_pclk 			)
	,.fifo_data_vs  			(cmos_vsync 		)
    ,.pix_x_in                  (pix_x_in    		)            
    ,.pix_y_in                  (pix_y_in			)
	,.hs                        (hs                 )
	,.vs                        (vs                 )
	,.de                        (de                 )
	,.vout_data                 (vout_data          )
);

endmodule