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
    ,output                 clk_50MHz
    ,output                 clk_1P28MHz
    ,output                 clk_20KHz       
    ,output                 clk_WS
    ,output                 rst_mic_n
);

assign rst_mic_n = rst_mic_lock ? rst_n : 1'b0;

rpll_cpu U_PLL_27_50(
    .reset          (!rst_n         ), //i
    .clkout         (clk_50MHz      ), //o
    .clkin          (ext_clk        )  //i
);

wire rst_mic_lock;
wire clk_172P8MHz;
rpll_mic U_PLL_27_135(
    .clkout         (clk_172P8MHz   ), //o
    .lock           (rst_mic_lock   ), //o
    .reset          (!rst_n         ), //i
    .clkin          (ext_clk        )  //i
);

clk_div #(
    .SCALER         (135            )
)
U_CLK_DIV_675
(
     .clk_in        (clk_172P8MHz   ) //i
    ,.rst_n         (rst_n          ) //i
    ,.clk_out       (clk_1P28MHz    ) //o
);

clk_div #(
    .SCALER         (64             )
)
U_CLK_DIV_675
(
     .clk_in        (clk_1P28MHz    ) //i
    ,.rst_n         (rst_n          ) //i
    ,.clk_out       (clk_20KHz      ) //o
);

endmodule
