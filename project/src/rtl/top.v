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



endmodule