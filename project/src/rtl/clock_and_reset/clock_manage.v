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
    ,output                 clk_24MHz
    ,output                 clk_12MHz
    ,output                 clk_9MHz
    ,output                 clk_6MHz    
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

rpll_9MHz U_RPLL_9MHz(
     .clkout        (clk_9MHz       ) //output clkout
    ,.reset         (!rst_n         ) //input reset
    ,.clkin         (ext_clk        ) //input clkin
);

rpll_9M_to_12M_24M U_RPLL_12_24MHz(
     .clkout        (clk_24MHz      )
    ,.clkoutd       (clk_12MHz      )
    ,.reset         (!rst_n         )
    ,.clkin         (clk_9MHz       )
);

clk_div #(
    .SCALER         (10             )
)
U_CLK_DIV_10
(
     .clk_in        (clk_60MHz      ) //i
    ,.rst_n         (rst_n          ) //i
    ,.clk_out       (clk_6MHz       ) //o
);

clk_div_64 U_CLK_DIV_64
(
     .clk_in        (clk_6MHz       ) //i
    ,.rst_n         (rst_n          ) //i
    ,.clk_out       (clk_WS         ) //o
);

endmodule
