`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Create Date: 25.08.2022
// Designer : Hank.Gan
// Design Name: myxcorr
// Description: A DSP module used to calculate XCORR
// Dependencies: Semi dual-port Block RAM 
// Revision 1.0
// Additional Comments: 
//////////////////////////////////////////////////////////////////////////////////

module myxcorr #(
     parameter       DATAWIDTH           = 24
    ,parameter       SEQUENCE_LENGTH     = 512
)
(
     input                              clk
    ,input                              clk_mic
    ,input                              rst_n
    ,input      [DATAWIDTH - 1: 0]      series_x
    ,input      [DATAWIDTH - 1: 0]      series_y
    ,input                              start
    
    ,output                             complete
    ,output reg [2*DATAWIDTH- 1: 0]     result
    ,output reg [12- 1: 0]              lag

);


mem_x U_MEM_X(
    .dout(dout_o), //output [15:0] dout
    .clka(clka_i), //input clka
    .cea(cea_i), //input cea
    .reseta(reseta_i), //input reseta
    .clkb(clkb_i), //input clkb
    .ceb(ceb_i), //input ceb
    .resetb(resetb_i), //input resetb
    .oce(oce_i), //input oce
    .ada(ada_i), //input [9:0] ada
    .din(din_i), //input [15:0] din
    .adb(adb_i) //input [9:0] adb
);

mem_y U_MEM_Y(
    .dout(dout_o), //output [15:0] dout
    .clka(clka_i), //input clka
    .cea(cea_i), //input cea
    .reseta(reseta_i), //input reseta
    .clkb(clkb_i), //input clkb
    .ceb(ceb_i), //input ceb
    .resetb(resetb_i), //input resetb
    .oce(oce_i), //input oce
    .ada(ada_i), //input [9:0] ada
    .din(din_i), //input [15:0] din
    .adb(adb_i) //input [9:0] adb
);

endmodule