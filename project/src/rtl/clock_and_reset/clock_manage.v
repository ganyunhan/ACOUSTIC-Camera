`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Create Date: 26.08.2022
// Last Modified : Hank.Gan 26.08.2022
// Designer : Hank.Gan
// Design Name: clock_manage
// Description: Manage clocks and rests, including dividers and plls
// Dependencies: pll/clk_div
// Revision 1.0
// Additional Comments: clk_WS=20KHz clk_mic=128KHz ext_clk=27MHz
//////////////////////////////////////////////////////////////////////////////////
module clock_manage(
     input                  ext_clk
    ,input                  rst_n
    ,output                 clk_60MHz
    ,output                 clk_20MHz
    ,output                 clk_2MHz    
    ,output                 clk_WS
    ,output                 rst_mic_n
);

wire    rst_mic_lock;

rpll_mic U_PLL_27_60(
    .clkout         (clk_60MHz      ), //o
    .lock           (rst_mic_lock   ), //o
    .reset          (!rst_n         ), //i
    .clkin          (ext_clk        )  //i
);
assign rst_mic_n = rst_mic_lock ? rst_n : 1'b0;

rpll_20MHz U_RPLL_20MHZ(
    .clkout         (clk_20MHz), //output clkout
    .reset          (!rst_n), //input reset
    .clkin          (clk_60MHz) //input clkin
);

clk_div #(
    .SCALER         (10             )
)
U_CLK_DIV_30
(
     .clk_in        (clk_60MHz      ) //i
    ,.rst_n         (rst_n          ) //i
    ,.clk_out       (clk_2MHz       ) //o
);

clk_div_64 U_CLK_DIV_64
(
     .clk_in        (clk_2MHz       ) //i
    ,.rst_n         (rst_n          ) //i
    ,.clk_out       (clk_WS         ) //o
);

endmodule
