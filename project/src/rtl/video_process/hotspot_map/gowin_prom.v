//Copyright (C)2014-2022 Gowin Semiconductor Corporation.
//All rights reserved.
//File Title: IP file
//GOWIN Version: V1.9.8.08
//Part Number: GW2A-LV18PG256C8/I7
//Device: GW2A-18C
//Created Time: Mon Oct 24 15:10:43 2022

module Gowin_pROM (dout, clk, oce, ce, reset, ad);

output [15:0] dout;
input clk;
input oce;
input ce;
input reset;
input [11:0] ad;

wire lut_f_0;
wire lut_f_1;
wire [23:0] prom_inst_0_dout_w;
wire [7:0] prom_inst_0_dout;
wire [23:0] prom_inst_1_dout_w;
wire [15:8] prom_inst_1_dout;
wire [15:0] prom_inst_2_dout_w;
wire [15:0] prom_inst_2_dout;
wire dff_q_0;
wire gw_gnd;

assign gw_gnd = 1'b0;

LUT2 lut_inst_0 (
  .F(lut_f_0),
  .I0(ce),
  .I1(ad[11])
);
defparam lut_inst_0.INIT = 4'h2;
LUT3 lut_inst_1 (
  .F(lut_f_1),
  .I0(ce),
  .I1(ad[10]),
  .I2(ad[11])
);
defparam lut_inst_1.INIT = 8'h20;
pROM prom_inst_0 (
    .DO({prom_inst_0_dout_w[23:0],prom_inst_0_dout[7:0]}),
    .CLK(clk),
    .OCE(oce),
    .CE(lut_f_0),
    .RESET(reset),
    .AD({ad[10:0],gw_gnd,gw_gnd,gw_gnd})
);

defparam prom_inst_0.READ_MODE = 1'b0;
defparam prom_inst_0.BIT_WIDTH = 8;
defparam prom_inst_0.RESET_MODE = "SYNC";
defparam prom_inst_0.INIT_RAM_00 = 256'hE5E5E5E5E5E5E5E5E5E5E5E5E5E5E5E5E5E5666666666666666666667F7F7F7F;
defparam prom_inst_0.INIT_RAM_01 = 256'hE5E5E56666666666666666667F7F7F7F7F7F7F7F7F66666666666666666666E5;
defparam prom_inst_0.INIT_RAM_02 = 256'h7F7F7F666666666666666666E5E5E5E5E5E5E5E5E5E5E5E5E5E5E5E5E5E5E5E5;
defparam prom_inst_0.INIT_RAM_03 = 256'hE5E5E5E5E5E5E5E5E5E5E5E5E5E5E5E5E5E5E5E566666666666666667F7F7F7F;
defparam prom_inst_0.INIT_RAM_04 = 256'hE5E5E5E566666666666666667F7F7F7F7F6666666666666666E5E5E5E5E5E5E5;
defparam prom_inst_0.INIT_RAM_05 = 256'h66666666666666E5E5E5E5E5E5E5E5E5E5E5E5E5E5E5E5E5E5E5E5E5E5E5E5E5;
defparam prom_inst_0.INIT_RAM_06 = 256'hE0E0E0E0E0E0E0E0E0E0E0E5E5E5E5E5E5E5E5E5E5666666666666667F7F7F66;
defparam prom_inst_0.INIT_RAM_07 = 256'hE5E5E5E5E56666666666667F7F66666666666666E5E5E5E5E5E5E5E5E5E5E0E0;
defparam prom_inst_0.INIT_RAM_08 = 256'h6666E5E5E5E5E5E5E5E5E5E0E0E0E0E0E0E0E0E0E0E0E0E0E0E0E0E0E5E5E5E5;
defparam prom_inst_0.INIT_RAM_09 = 256'hE0E0E0E0E0E0E0E0E0E0E0E0E0E5E5E5E5E5E5E5E566666666667F7F66666666;
defparam prom_inst_0.INIT_RAM_0A = 256'hE5E5E5E5E5666666667F666666666666E5E5E5E5E5E5E5E5E0E0E0E0E0E0E0E0;
defparam prom_inst_0.INIT_RAM_0B = 256'hE5E5E5E5E5E5E0E0E0E0E0E0E0E0E0E0E0E0E0E0E0E0E0E0E0E0E0E0E0E5E5E5;
defparam prom_inst_0.INIT_RAM_0C = 256'hE0E0E0E0E0E0E0E0E0E0E0E0E0E0E5E5E5E5E5E566666666666666666666E5E5;
defparam prom_inst_0.INIT_RAM_0D = 256'hE5E5E5E5666666666666666666E5E5E5E5E5E5E0E0E0E0E0E0E0E0E0E0E0E0E0;
defparam prom_inst_0.INIT_RAM_0E = 256'hE5E0E0E0E0E0E0E0E0E02020202020202020202020E0E0E0E0E0E0E0E0E0E5E5;
defparam prom_inst_0.INIT_RAM_0F = 256'h202020202020E0E0E0E0E0E0E0E0E5E5E5E5E5E566666666666666E5E5E5E5E5;
defparam prom_inst_0.INIT_RAM_10 = 256'hE5E5E5666666666666E5E5E5E5E5E5E0E0E0E0E0E0E0E0202020202020202020;
defparam prom_inst_0.INIT_RAM_11 = 256'hE0E0E0E0E02020202020202020202020202020202020E0E0E0E0E0E0E0E5E5E5;
defparam prom_inst_0.INIT_RAM_12 = 256'h20202020202020E0E0E0E0E0E0E5E5E5E5E5E56666666666E5E5E5E5E5E5E0E0;
defparam prom_inst_0.INIT_RAM_13 = 256'hE5E566666666E5E5E5E5E5E5E0E0E0E0E0E02020202020202020202020202020;
defparam prom_inst_0.INIT_RAM_14 = 256'h2020202020202020202020202020202020202020202020E0E0E0E0E0E0E5E5E5;
defparam prom_inst_0.INIT_RAM_15 = 256'h202020202020E0E0E0E0E0E0E5E5E5E5E5E5666666E5E5E5E5E5E0E0E0E0E0E0;
defparam prom_inst_0.INIT_RAM_16 = 256'hE56666E5E5E5E5E5E5E0E0E0E0E0E02020202020202020202020202020202020;
defparam prom_inst_0.INIT_RAM_17 = 256'h20202020202020202020202020202020202020202020E0E0E0E0E0E0E5E5E5E5;
defparam prom_inst_0.INIT_RAM_18 = 256'h202020202020E0E0E0E0E0E5E5E5E5E56666E5E5E5E5E5E0E0E0E0E0E0202020;
defparam prom_inst_0.INIT_RAM_19 = 256'h66E5E5E5E5E5E0E0E0E0E0202020202020202020202020202020202020202020;
defparam prom_inst_0.INIT_RAM_1A = 256'h202020202020202020202020202020202020202020E0E0E0E0E0E0E5E5E5E566;
defparam prom_inst_0.INIT_RAM_1B = 256'h2020202020E0E0E0E0E0E5E5E5E566E5E5E5E5E5E0E0E0E0E0E0202020202020;
defparam prom_inst_0.INIT_RAM_1C = 256'hE5E5E5E0E0E0E0E0202020202020202020202020202020202020202020202020;
defparam prom_inst_0.INIT_RAM_1D = 256'h2020200000000000202020202020202020202020E0E0E0E0E0E5E5E5E566E5E5;
defparam prom_inst_0.INIT_RAM_1E = 256'h202020E0E0E0E0E0E5E5E5E566E5E5E5E5E5E0E0E0E0E0202020202020202020;
defparam prom_inst_0.INIT_RAM_1F = 256'hE5E0E0E0E0E02020202020202020202020000000000000002020202020202020;
defparam prom_inst_0.INIT_RAM_20 = 256'h000000000000000020202020202020202020E0E0E0E0E0E5E5E5E566E5E5E5E5;
defparam prom_inst_0.INIT_RAM_21 = 256'h20E0E0E0E0E0E5E5E5E566E5E5E5E5E5E0E0E0E0E02020202020202020202000;
defparam prom_inst_0.INIT_RAM_22 = 256'hE0E0E0E020202020202020202020000000000000000000202020202020202020;
defparam prom_inst_0.INIT_RAM_23 = 256'h00000000000020202020202020202020E0E0E0E0E0E5E5E5E566E5E5E5E5E5E0;
defparam prom_inst_0.INIT_RAM_24 = 256'hE0E0E0E0E5E5E5E566E5E5E5E5E5E0E0E0E0E020202020202020202020000000;
defparam prom_inst_0.INIT_RAM_25 = 256'hE0E02020202020202020202000000000000000000020202020202020202020E0;
defparam prom_inst_0.INIT_RAM_26 = 256'h0000000020202020202020202020E0E0E0E0E0E5E5E5E566E5E5E5E5E5E0E0E0;
defparam prom_inst_0.INIT_RAM_27 = 256'hE0E0E5E5E5E566E5E5E5E5E5E0E0E0E0E0202020202020202020200000000000;
defparam prom_inst_0.INIT_RAM_28 = 256'h2020202020202020202020000000000000002020202020202020202020E0E0E0;
defparam prom_inst_0.INIT_RAM_29 = 256'h202020202020202020202020E0E0E0E0E0E5E5E5E566E5E5E5E5E5E0E0E0E0E0;
defparam prom_inst_0.INIT_RAM_2A = 256'hE5E5E5E566E5E5E5E5E5E0E0E0E0E02020202020202020202020200000000000;
defparam prom_inst_0.INIT_RAM_2B = 256'h202020202020202020202020202020202020202020202020202020E0E0E0E0E0;
defparam prom_inst_0.INIT_RAM_2C = 256'h202020202020202020E0E0E0E0E0E0E5E5E5E566E5E5E5E5E5E0E0E0E0E02020;
defparam prom_inst_0.INIT_RAM_2D = 256'hE5E566E5E5E5E5E5E0E0E0E0E0E0202020202020202020202020202020202020;
defparam prom_inst_0.INIT_RAM_2E = 256'h202020202020202020202020202020202020202020202020E0E0E0E0E0E5E5E5;
defparam prom_inst_0.INIT_RAM_2F = 256'h202020202020E0E0E0E0E0E0E5E5E5E5E56666E5E5E5E5E5E0E0E0E0E0202020;
defparam prom_inst_0.INIT_RAM_30 = 256'h6666E5E5E5E5E5E0E0E0E0E0E020202020202020202020202020202020202020;
defparam prom_inst_0.INIT_RAM_31 = 256'h2020202020202020202020202020202020202020E0E0E0E0E0E0E5E5E5E5E5E5;
defparam prom_inst_0.INIT_RAM_32 = 256'h202020E0E0E0E0E0E0E5E5E5E5E5666666E5E5E5E5E5E5E0E0E0E0E0E0202020;
defparam prom_inst_0.INIT_RAM_33 = 256'h66E5E5E5E5E5E0E0E0E0E0E02020202020202020202020202020202020202020;
defparam prom_inst_0.INIT_RAM_34 = 256'h2020202020202020202020202020202020E0E0E0E0E0E0E5E5E5E5E5E5666666;
defparam prom_inst_0.INIT_RAM_35 = 256'hE0E0E0E0E0E5E5E5E5E5E56666666666E5E5E5E5E5E5E0E0E0E0E0E020202020;
defparam prom_inst_0.INIT_RAM_36 = 256'hE5E5E5E5E5E5E0E0E0E0E0E0E02020202020202020202020202020202020E0E0;
defparam prom_inst_0.INIT_RAM_37 = 256'h202020202020202020202020E0E0E0E0E0E0E0E0E5E5E5E5E5E5666666666666;
defparam prom_inst_0.INIT_RAM_38 = 256'hE0E0E5E5E5E5E5E566666666666666E5E5E5E5E5E5E0E0E0E0E0E0E0E0202020;
defparam prom_inst_0.INIT_RAM_39 = 256'hE5E5E5E5E5E0E0E0E0E0E0E0E0E02020202020202020202020E0E0E0E0E0E0E0;
defparam prom_inst_0.INIT_RAM_3A = 256'hE0E0E0E0E0E0E0E0E0E0E0E0E0E0E0E0E5E5E5E5E5E5666666666666666666E5;
defparam prom_inst_0.INIT_RAM_3B = 256'hE5E5E5E5E566666666666666666666E5E5E5E5E5E5E0E0E0E0E0E0E0E0E0E0E0;
defparam prom_inst_0.INIT_RAM_3C = 256'hE5E5E5E5E5E5E0E0E0E0E0E0E0E0E0E0E0E0E0E0E0E0E0E0E0E0E0E0E0E5E5E5;
defparam prom_inst_0.INIT_RAM_3D = 256'hE0E0E0E0E0E0E0E0E0E0E0E5E5E5E5E5E5E5E56666666666666666666666E5E5;
defparam prom_inst_0.INIT_RAM_3E = 256'hE56666666666667F666666666666E5E5E5E5E5E5E5E5E0E0E0E0E0E0E0E0E0E0;
defparam prom_inst_0.INIT_RAM_3F = 256'hE5E5E5E5E5E5E5E0E0E0E0E0E0E0E0E0E0E0E0E0E0E0E0E0E5E5E5E5E5E5E5E5;

pROM prom_inst_1 (
    .DO({prom_inst_1_dout_w[23:0],prom_inst_1_dout[15:8]}),
    .CLK(clk),
    .OCE(oce),
    .CE(lut_f_0),
    .RESET(reset),
    .AD({ad[10:0],gw_gnd,gw_gnd,gw_gnd})
);

defparam prom_inst_1.READ_MODE = 1'b0;
defparam prom_inst_1.BIT_WIDTH = 8;
defparam prom_inst_1.RESET_MODE = "SYNC";
defparam prom_inst_1.INIT_RAM_00 = 256'hAFAFAFAFAFAFAFAFAFAFAFAFAFAFAFAFAFAF3636363636363636363686868686;
defparam prom_inst_1.INIT_RAM_01 = 256'hAFAFAF36363636363636363686868686868686868636363636363636363636AF;
defparam prom_inst_1.INIT_RAM_02 = 256'h868686363636363636363636AFAFAFAFAFAFAFAFAFAFAFAFAFAFAFAFAFAFAFAF;
defparam prom_inst_1.INIT_RAM_03 = 256'hAFAFAFAFAFAFAFAFAFAFAFAFAFAFAFAFAFAFAFAF363636363636363686868686;
defparam prom_inst_1.INIT_RAM_04 = 256'hAFAFAFAF363636363636363686868686863636363636363636AFAFAFAFAFAFAF;
defparam prom_inst_1.INIT_RAM_05 = 256'h36363636363636AFAFAFAFAFAFAFAFAFAFAFAFAFAFAFAFAFAFAFAFAFAFAFAFAF;
defparam prom_inst_1.INIT_RAM_06 = 256'hFFFFFFFFFFFFFFFFFFFFFFAFAFAFAFAFAFAFAFAFAF3636363636363686868636;
defparam prom_inst_1.INIT_RAM_07 = 256'hAFAFAFAFAF363636363636868636363636363636AFAFAFAFAFAFAFAFAFAFFFFF;
defparam prom_inst_1.INIT_RAM_08 = 256'h3636AFAFAFAFAFAFAFAFAFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFAFAFAFAF;
defparam prom_inst_1.INIT_RAM_09 = 256'hFFFFFFFFFFFFFFFFFFFFFFFFFFAFAFAFAFAFAFAFAF3636363636868636363636;
defparam prom_inst_1.INIT_RAM_0A = 256'hAFAFAFAFAF3636363686363636363636AFAFAFAFAFAFAFAFFFFFFFFFFFFFFFFF;
defparam prom_inst_1.INIT_RAM_0B = 256'hAFAFAFAFAFAFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFAFAFAF;
defparam prom_inst_1.INIT_RAM_0C = 256'hFFFFFFFFFFFFFFFFFFFFFFFFFFFFAFAFAFAFAFAF36363636363636363636AFAF;
defparam prom_inst_1.INIT_RAM_0D = 256'hAFAFAFAF363636363636363636AFAFAFAFAFAFFFFFFFFFFFFFFFFFFFFFFFFFFF;
defparam prom_inst_1.INIT_RAM_0E = 256'hAFFFFFFFFFFFFFFFFFFFFDFDFDFDFDFDFDFDFDFDFDFFFFFFFFFFFFFFFFFFAFAF;
defparam prom_inst_1.INIT_RAM_0F = 256'hFDFDFDFDFDFDFFFFFFFFFFFFFFFFAFAFAFAFAFAF36363636363636AFAFAFAFAF;
defparam prom_inst_1.INIT_RAM_10 = 256'hAFAFAF363636363636AFAFAFAFAFAFFFFFFFFFFFFFFFFFFDFDFDFDFDFDFDFDFD;
defparam prom_inst_1.INIT_RAM_11 = 256'hFFFFFFFFFFFDFDFDFDFDFDFDFDFDFDFDFDFDFDFDFDFDFFFFFFFFFFFFFFAFAFAF;
defparam prom_inst_1.INIT_RAM_12 = 256'hFDFDFDFDFDFDFDFFFFFFFFFFFFAFAFAFAFAFAF3636363636AFAFAFAFAFAFFFFF;
defparam prom_inst_1.INIT_RAM_13 = 256'hAFAF36363636AFAFAFAFAFAFFFFFFFFFFFFFFDFDFDFDFDFDFDFDFDFDFDFDFDFD;
defparam prom_inst_1.INIT_RAM_14 = 256'hFDFDFDFDFDFDFDFDFDFDFDFDFDFDFDFDFDFDFDFDFDFDFDFFFFFFFFFFFFAFAFAF;
defparam prom_inst_1.INIT_RAM_15 = 256'hFDFDFDFDFDFDFFFFFFFFFFFFAFAFAFAFAFAF363636AFAFAFAFAFFFFFFFFFFFFF;
defparam prom_inst_1.INIT_RAM_16 = 256'hAF3636AFAFAFAFAFAFFFFFFFFFFFFFFDFDFDFDFDFDFDFAFAFAFAFAFAFAFAFAFD;
defparam prom_inst_1.INIT_RAM_17 = 256'hFDFDFDFDFAFAFAFAFAFAFAFAFAFAFAFDFDFDFDFDFDFDFFFFFFFFFFFFAFAFAFAF;
defparam prom_inst_1.INIT_RAM_18 = 256'hFDFDFDFDFDFDFFFFFFFFFFAFAFAFAFAF3636AFAFAFAFAFFFFFFFFFFFFFFDFDFD;
defparam prom_inst_1.INIT_RAM_19 = 256'h36AFAFAFAFAFFFFFFFFFFFFDFDFDFDFDFDFAFAFAFAFAFAFAFAFAFAFAFAFAFAFA;
defparam prom_inst_1.INIT_RAM_1A = 256'hFAFAFAFAFAFAFAFAFAFAFAFAFAFAFAFDFDFDFDFDFDFFFFFFFFFFFFAFAFAFAF36;
defparam prom_inst_1.INIT_RAM_1B = 256'hFDFDFDFDFDFFFFFFFFFFAFAFAFAF36AFAFAFAFAFFFFFFFFFFFFFFDFDFDFDFDFD;
defparam prom_inst_1.INIT_RAM_1C = 256'hAFAFAFFFFFFFFFFFFDFDFDFDFDFDFAFAFAFAFAFAFAFAFAFAFAFAFAFAFAFAFAFD;
defparam prom_inst_1.INIT_RAM_1D = 256'hFAFAFAF8F8F8F8F8FAFAFAFAFAFAFAFDFDFDFDFDFFFFFFFFFFAFAFAFAF36AFAF;
defparam prom_inst_1.INIT_RAM_1E = 256'hFDFDFDFFFFFFFFFFAFAFAFAF36AFAFAFAFAFFFFFFFFFFFFDFDFDFDFDFAFAFAFA;
defparam prom_inst_1.INIT_RAM_1F = 256'hAFFFFFFFFFFFFDFDFDFDFDFAFAFAFAFAFAF8F8F8F8F8F8F8FAFAFAFAFAFAFDFD;
defparam prom_inst_1.INIT_RAM_20 = 256'hF8F8F8F8F8F8F8F8FAFAFAFAFAFDFDFDFDFDFFFFFFFFFFAFAFAFAF36AFAFAFAF;
defparam prom_inst_1.INIT_RAM_21 = 256'hFDFFFFFFFFFFAFAFAFAF36AFAFAFAFAFFFFFFFFFFFFDFDFDFDFDFAFAFAFAFAF8;
defparam prom_inst_1.INIT_RAM_22 = 256'hFFFFFFFFFDFDFDFDFDFAFAFAFAFAF8F8F8F8F8F8F8F8F8FAFAFAFAFAFDFDFDFD;
defparam prom_inst_1.INIT_RAM_23 = 256'hF8F8F8F8F8F8FAFAFAFAFAFDFDFDFDFDFFFFFFFFFFAFAFAFAF36AFAFAFAFAFFF;
defparam prom_inst_1.INIT_RAM_24 = 256'hFFFFFFFFAFAFAFAF36AFAFAFAFAFFFFFFFFFFFFDFDFDFDFDFAFAFAFAFAF8F8F8;
defparam prom_inst_1.INIT_RAM_25 = 256'hFFFFFDFDFDFDFDFAFAFAFAFAF8F8F8F8F8F8F8F8F8FAFAFAFAFAFDFDFDFDFDFF;
defparam prom_inst_1.INIT_RAM_26 = 256'hF8F8F8F8FAFAFAFAFAFDFDFDFDFDFFFFFFFFFFAFAFAFAF36AFAFAFAFAFFFFFFF;
defparam prom_inst_1.INIT_RAM_27 = 256'hFFFFAFAFAFAF36AFAFAFAFAFFFFFFFFFFFFDFDFDFDFDFAFAFAFAFAF8F8F8F8F8;
defparam prom_inst_1.INIT_RAM_28 = 256'hFDFDFDFDFDFAFAFAFAFAFAF8F8F8F8F8F8F8FAFAFAFAFAFAFDFDFDFDFDFFFFFF;
defparam prom_inst_1.INIT_RAM_29 = 256'hFAFAFAFAFAFAFAFDFDFDFDFDFFFFFFFFFFAFAFAFAF36AFAFAFAFAFFFFFFFFFFF;
defparam prom_inst_1.INIT_RAM_2A = 256'hAFAFAFAF36AFAFAFAFAFFFFFFFFFFFFDFDFDFDFDFAFAFAFAFAFAFAF8F8F8F8F8;
defparam prom_inst_1.INIT_RAM_2B = 256'hFDFDFDFDFAFAFAFAFAFAFAFAFAFAFAFAFAFAFAFAFAFDFDFDFDFDFDFFFFFFFFFF;
defparam prom_inst_1.INIT_RAM_2C = 256'hFAFAFAFDFDFDFDFDFDFFFFFFFFFFFFAFAFAFAF36AFAFAFAFAFFFFFFFFFFFFDFD;
defparam prom_inst_1.INIT_RAM_2D = 256'hAFAF36AFAFAFAFAFFFFFFFFFFFFFFDFDFDFDFDFDFAFAFAFAFAFAFAFAFAFAFAFA;
defparam prom_inst_1.INIT_RAM_2E = 256'hFDFDFDFAFAFAFAFAFAFAFAFAFAFAFAFAFAFAFDFDFDFDFDFDFFFFFFFFFFAFAFAF;
defparam prom_inst_1.INIT_RAM_2F = 256'hFDFDFDFDFDFDFFFFFFFFFFFFAFAFAFAFAF3636AFAFAFAFAFFFFFFFFFFFFDFDFD;
defparam prom_inst_1.INIT_RAM_30 = 256'h3636AFAFAFAFAFFFFFFFFFFFFFFDFDFDFDFDFDFDFAFAFAFAFAFAFAFAFAFAFAFD;
defparam prom_inst_1.INIT_RAM_31 = 256'hFDFDFDFDFAFAFAFAFAFAFAFAFAFDFDFDFDFDFDFDFFFFFFFFFFFFAFAFAFAFAFAF;
defparam prom_inst_1.INIT_RAM_32 = 256'hFDFDFDFFFFFFFFFFFFAFAFAFAFAF363636AFAFAFAFAFAFFFFFFFFFFFFFFDFDFD;
defparam prom_inst_1.INIT_RAM_33 = 256'h36AFAFAFAFAFFFFFFFFFFFFFFDFDFDFDFDFDFDFDFDFDFDFDFDFDFDFDFDFDFDFD;
defparam prom_inst_1.INIT_RAM_34 = 256'hFDFDFDFDFDFDFDFDFDFDFDFDFDFDFDFDFDFFFFFFFFFFFFAFAFAFAFAFAF363636;
defparam prom_inst_1.INIT_RAM_35 = 256'hFFFFFFFFFFAFAFAFAFAFAF3636363636AFAFAFAFAFAFFFFFFFFFFFFFFDFDFDFD;
defparam prom_inst_1.INIT_RAM_36 = 256'hAFAFAFAFAFAFFFFFFFFFFFFFFFFDFDFDFDFDFDFDFDFDFDFDFDFDFDFDFDFDFFFF;
defparam prom_inst_1.INIT_RAM_37 = 256'hFDFDFDFDFDFDFDFDFDFDFDFDFFFFFFFFFFFFFFFFAFAFAFAFAFAF363636363636;
defparam prom_inst_1.INIT_RAM_38 = 256'hFFFFAFAFAFAFAFAF36363636363636AFAFAFAFAFAFFFFFFFFFFFFFFFFFFDFDFD;
defparam prom_inst_1.INIT_RAM_39 = 256'hAFAFAFAFAFFFFFFFFFFFFFFFFFFFFDFDFDFDFDFDFDFDFDFDFDFFFFFFFFFFFFFF;
defparam prom_inst_1.INIT_RAM_3A = 256'hFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFAFAFAFAFAFAF363636363636363636AF;
defparam prom_inst_1.INIT_RAM_3B = 256'hAFAFAFAFAF36363636363636363636AFAFAFAFAFAFFFFFFFFFFFFFFFFFFFFFFF;
defparam prom_inst_1.INIT_RAM_3C = 256'hAFAFAFAFAFAFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFAFAFAF;
defparam prom_inst_1.INIT_RAM_3D = 256'hFFFFFFFFFFFFFFFFFFFFFFAFAFAFAFAFAFAFAF3636363636363636363636AFAF;
defparam prom_inst_1.INIT_RAM_3E = 256'hAF36363636363686363636363636AFAFAFAFAFAFAFAFFFFFFFFFFFFFFFFFFFFF;
defparam prom_inst_1.INIT_RAM_3F = 256'hAFAFAFAFAFAFAFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFAFAFAFAFAFAFAFAF;

pROM prom_inst_2 (
    .DO({prom_inst_2_dout_w[15:0],prom_inst_2_dout[15:0]}),
    .CLK(clk),
    .OCE(oce),
    .CE(lut_f_1),
    .RESET(reset),
    .AD({ad[9:0],gw_gnd,gw_gnd,gw_gnd,gw_gnd})
);

defparam prom_inst_2.READ_MODE = 1'b0;
defparam prom_inst_2.BIT_WIDTH = 16;
defparam prom_inst_2.RESET_MODE = "SYNC";
defparam prom_inst_2.INIT_RAM_00 = 256'h366636663666366636663666867F867F366636663666366636663666AFE5AFE5;
defparam prom_inst_2.INIT_RAM_01 = 256'hFFE0FFE0FFE0FFE0FFE0AFE5AFE5AFE5AFE5AFE5AFE5AFE5AFE5AFE5AFE53666;
defparam prom_inst_2.INIT_RAM_02 = 256'hAFE5AFE5AFE5AFE5AFE5AFE5AFE5AFE5FFE0FFE0FFE0FFE0FFE0FFE0FFE0FFE0;
defparam prom_inst_2.INIT_RAM_03 = 256'h3666366636663666867F867F867F3666366636663666366636663666AFE5AFE5;
defparam prom_inst_2.INIT_RAM_04 = 256'hAFE5AFE5AFE5AFE5AFE5AFE5AFE5AFE5AFE5AFE5AFE5AFE53666366636663666;
defparam prom_inst_2.INIT_RAM_05 = 256'hAFE5AFE5AFE5AFE5AFE5AFE5AFE5AFE5AFE5AFE5AFE5AFE5AFE5AFE5AFE5AFE5;
defparam prom_inst_2.INIT_RAM_06 = 256'h36663666867F867F867F867F867F36663666366636663666366636663666AFE5;
defparam prom_inst_2.INIT_RAM_07 = 256'hAFE5AFE5AFE5AFE5AFE5AFE5AFE5AFE5AFE5AFE5366636663666366636663666;
defparam prom_inst_2.INIT_RAM_08 = 256'hAFE5AFE5AFE5AFE5AFE5AFE5AFE5AFE5AFE5AFE5AFE5AFE5AFE5AFE5AFE5AFE5;
defparam prom_inst_2.INIT_RAM_09 = 256'h867F867F867F867F867F867F867F36663666366636663666366636663666AFE5;
defparam prom_inst_2.INIT_RAM_0A = 256'hAFE5AFE5AFE5AFE5AFE5AFE5AFE5366636663666366636663666366636663666;
defparam prom_inst_2.INIT_RAM_0B = 256'hAFE5AFE5AFE5AFE5AFE5AFE5AFE5AFE5AFE5AFE5AFE5AFE5AFE5AFE5AFE5AFE5;
defparam prom_inst_2.INIT_RAM_0C = 256'h867F867F867F867F867F867F867F366636663666366636663666366636663666;
defparam prom_inst_2.INIT_RAM_0D = 256'hAFE5AFE5AFE5AFE53666366636663666366636663666366636663666867F867F;
defparam prom_inst_2.INIT_RAM_0E = 256'h3666AFE5AFE5AFE5AFE5AFE5AFE5AFE5AFE5AFE5AFE5AFE5AFE5AFE5AFE5AFE5;
defparam prom_inst_2.INIT_RAM_0F = 256'h867F867F867F867F867F867F867F366636663666366636663666366636663666;
defparam prom_inst_2.INIT_RAM_10 = 256'h36663666366636663666366636663666366636663666867F867F867F867F867F;
defparam prom_inst_2.INIT_RAM_11 = 256'h366636663666AFE5AFE5AFE5AFE5AFE5AFE5AFE5AFE5AFE5AFE5AFE5AFE5AFE5;
defparam prom_inst_2.INIT_RAM_12 = 256'h867F867F867F867F867F867F867F867F36663666366636663666366636663666;
defparam prom_inst_2.INIT_RAM_13 = 256'h366636663666366636663666366636663666867F867F867F867F867F867F867F;
defparam prom_inst_2.INIT_RAM_14 = 256'h3666366636663666366636663666366636663666366636663666366636663666;
defparam prom_inst_2.INIT_RAM_15 = 256'h867F867F867F867F867F867F867F867F36663666366636663666366636663666;
defparam prom_inst_2.INIT_RAM_16 = 256'h000000000000000000000000000000000000000000000000000000000000067A;

DFFE dff_inst_0 (
  .Q(dff_q_0),
  .D(ad[11]),
  .CLK(clk),
  .CE(ce)
);
MUX2 mux_inst_2 (
  .O(dout[0]),
  .I0(prom_inst_0_dout[0]),
  .I1(prom_inst_2_dout[0]),
  .S0(dff_q_0)
);
MUX2 mux_inst_5 (
  .O(dout[1]),
  .I0(prom_inst_0_dout[1]),
  .I1(prom_inst_2_dout[1]),
  .S0(dff_q_0)
);
MUX2 mux_inst_8 (
  .O(dout[2]),
  .I0(prom_inst_0_dout[2]),
  .I1(prom_inst_2_dout[2]),
  .S0(dff_q_0)
);
MUX2 mux_inst_11 (
  .O(dout[3]),
  .I0(prom_inst_0_dout[3]),
  .I1(prom_inst_2_dout[3]),
  .S0(dff_q_0)
);
MUX2 mux_inst_14 (
  .O(dout[4]),
  .I0(prom_inst_0_dout[4]),
  .I1(prom_inst_2_dout[4]),
  .S0(dff_q_0)
);
MUX2 mux_inst_17 (
  .O(dout[5]),
  .I0(prom_inst_0_dout[5]),
  .I1(prom_inst_2_dout[5]),
  .S0(dff_q_0)
);
MUX2 mux_inst_20 (
  .O(dout[6]),
  .I0(prom_inst_0_dout[6]),
  .I1(prom_inst_2_dout[6]),
  .S0(dff_q_0)
);
MUX2 mux_inst_23 (
  .O(dout[7]),
  .I0(prom_inst_0_dout[7]),
  .I1(prom_inst_2_dout[7]),
  .S0(dff_q_0)
);
MUX2 mux_inst_26 (
  .O(dout[8]),
  .I0(prom_inst_1_dout[8]),
  .I1(prom_inst_2_dout[8]),
  .S0(dff_q_0)
);
MUX2 mux_inst_29 (
  .O(dout[9]),
  .I0(prom_inst_1_dout[9]),
  .I1(prom_inst_2_dout[9]),
  .S0(dff_q_0)
);
MUX2 mux_inst_32 (
  .O(dout[10]),
  .I0(prom_inst_1_dout[10]),
  .I1(prom_inst_2_dout[10]),
  .S0(dff_q_0)
);
MUX2 mux_inst_35 (
  .O(dout[11]),
  .I0(prom_inst_1_dout[11]),
  .I1(prom_inst_2_dout[11]),
  .S0(dff_q_0)
);
MUX2 mux_inst_38 (
  .O(dout[12]),
  .I0(prom_inst_1_dout[12]),
  .I1(prom_inst_2_dout[12]),
  .S0(dff_q_0)
);
MUX2 mux_inst_41 (
  .O(dout[13]),
  .I0(prom_inst_1_dout[13]),
  .I1(prom_inst_2_dout[13]),
  .S0(dff_q_0)
);
MUX2 mux_inst_44 (
  .O(dout[14]),
  .I0(prom_inst_1_dout[14]),
  .I1(prom_inst_2_dout[14]),
  .S0(dff_q_0)
);
MUX2 mux_inst_47 (
  .O(dout[15]),
  .I0(prom_inst_1_dout[15]),
  .I1(prom_inst_2_dout[15]),
  .S0(dff_q_0)
);
endmodule //Gowin_pROM
