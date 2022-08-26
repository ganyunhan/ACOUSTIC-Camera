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

);

clock_manage U_CLOCK_MANAGE(
     .ext_clk           () //i
    ,.rst_n             () //i
    ,.clk_50MHz         () //o
    ,.clk_mic           () //o
    ,.clk_WS            () //o
    ,.rst_mic_n         () //o
);

i2s_decoder#(
	 .DATAWIDTH         (24)
)
U_I2S_DECODER(
	 .clk_mic           () //i
	,.rst_mic_n         () //i
	,.WS                () //i
	,.DATA              () //i
	,.L_DATA            () //o[DATAWIDTH - 1: 0]
	,.R_DATA            () //o[DATAWIDTH - 1: 0]
	,.recv_over         () //o
);

myxcorr #(
     .DATAWIDTH         (24)
    ,.SEQUENCE_LENGTH   (512)
)
(
     .clk               () //i
    ,.clk_mic           () //i
    ,.rst_n             () //i
    ,.mic_data_valid    () //i
    ,.series_x          () //i[DATAWIDTH - 1: 0]
    ,.series_y          () //i[DATAWIDTH - 1: 0]
    ,.start             () //i
    ,.complete          () //o
    ,.result            () //o[2*DATAWIDTH- 1: 0]
    ,.lag               () //o[12- 1: 0]

);

endmodule