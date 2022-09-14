`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Create Date: 26.08.2022
// Last Modified : Hank.Gan 26.08.2022
// Designer : Hank.Gan
// Design Name: mic_subsys
// Description: Microphone Array processing sub-system
// Dependencies: i2s_decoder/
// Revision 1.0
// Additional Comments: 
//////////////////////////////////////////////////////////////////////////////////
module mic_subsys (

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
    ,.L_Sel             () //o
    ,.R_Sel             () //o
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