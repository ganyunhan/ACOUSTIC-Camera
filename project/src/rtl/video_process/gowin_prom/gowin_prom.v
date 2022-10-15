//Copyright (C)2014-2022 Gowin Semiconductor Corporation.
//All rights reserved.
//File Title: IP file
//GOWIN Version: V1.9.8.08
//Part Number: GW2A-LV18PG256C8/I7
//Device: GW2A-18C
//Created Time: Sat Oct 15 15:17:34 2022

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
defparam prom_inst_0.INIT_RAM_00 = 256'h666666666666666666666666666666666666DCDCDCDCDCDCDCDCDCDCF4F4F4F4;
defparam prom_inst_0.INIT_RAM_01 = 256'h666666DCDCDCDCDCDCDCDCDCF4F4F4F4F4F4F4F4F4DCDCDCDCDCDCDCDCDCDC66;
defparam prom_inst_0.INIT_RAM_02 = 256'hF4F4F4DCDCDCDCDCDCDCDCDC6666666666666666666666666666666666666666;
defparam prom_inst_0.INIT_RAM_03 = 256'h6666666666666666666666666666666666666666DCDCDCDCDCDCDCDCF4F4F4F4;
defparam prom_inst_0.INIT_RAM_04 = 256'h66666666DCDCDCDCDCDCDCDCF4F4F4F4F4DCDCDCDCDCDCDCDC66666666666666;
defparam prom_inst_0.INIT_RAM_05 = 256'hDCDCDCDCDCDCDC66666666666666666666666666666666666666666666666666;
defparam prom_inst_0.INIT_RAM_06 = 256'hE5E5E5E5E5E5E5E5E5E5E566666666666666666666DCDCDCDCDCDCDCF4F4F4DC;
defparam prom_inst_0.INIT_RAM_07 = 256'h6666666666DCDCDCDCDCDCF4F4DCDCDCDCDCDCDC66666666666666666666E5E5;
defparam prom_inst_0.INIT_RAM_08 = 256'hDCDC666666666666666666E5E5E5E5E5E5E5E5E5E5E5E5E5E5E5E5E566666666;
defparam prom_inst_0.INIT_RAM_09 = 256'hE5E5E5E5E5E5E5E5E5E5E5E5E56666666666666666DCDCDCDCDCF4F4DCDCDCDC;
defparam prom_inst_0.INIT_RAM_0A = 256'h6666666666DCDCDCDCF4DCDCDCDCDCDC6666666666666666E5E5E5E5E5E5E5E5;
defparam prom_inst_0.INIT_RAM_0B = 256'h666666666666E5E5E5E5E5E5E5E5E5E5E5E5E5E5E5E5E5E5E5E5E5E5E5666666;
defparam prom_inst_0.INIT_RAM_0C = 256'hE5E5E5E5E5E5E5E5E5E5E5E5E5E5666666666666DCDCDCDCDCDCDCDCDCDC6666;
defparam prom_inst_0.INIT_RAM_0D = 256'h66666666DCDCDCDCDCDCDCDCDC666666666666E5E5E5E5E5E5E5E5E5E5E5E5E5;
defparam prom_inst_0.INIT_RAM_0E = 256'h66E5E5E5E5E5E5E5E5E5E0E0E0E0E0E0E0E0E0E0E0E5E5E5E5E5E5E5E5E56666;
defparam prom_inst_0.INIT_RAM_0F = 256'hE0E0E0E0E0E0E5E5E5E5E5E5E5E5666666666666DCDCDCDCDCDCDC6666666666;
defparam prom_inst_0.INIT_RAM_10 = 256'h666666DCDCDCDCDCDC666666666666E5E5E5E5E5E5E5E5E0E0E0E0E0E0E0E0E0;
defparam prom_inst_0.INIT_RAM_11 = 256'hE5E5E5E5E5E0E0E0E0E0E0E0E0E0E0E0E0E0E0E0E0E0E5E5E5E5E5E5E5666666;
defparam prom_inst_0.INIT_RAM_12 = 256'hE0E0E0E0E0E0E0E5E5E5E5E5E5666666666666DCDCDCDCDC666666666666E5E5;
defparam prom_inst_0.INIT_RAM_13 = 256'h6666DCDCDCDC666666666666E5E5E5E5E5E5E0E0E0E0E0E0E0E0E0E0E0E0E0E0;
defparam prom_inst_0.INIT_RAM_14 = 256'hE0E0E0E0E0E0E0E0E0E0E0E0E0E0E0E0E0E0E0E0E0E0E0E5E5E5E5E5E5666666;
defparam prom_inst_0.INIT_RAM_15 = 256'hE0E0E0E0E0E0E5E5E5E5E5E5666666666666DCDCDC6666666666E5E5E5E5E5E5;
defparam prom_inst_0.INIT_RAM_16 = 256'h66DCDC666666666666E5E5E5E5E5E5E0E0E0E0E0E0E0202020202020202020E0;
defparam prom_inst_0.INIT_RAM_17 = 256'hE0E0E0E02020202020202020202020E0E0E0E0E0E0E0E5E5E5E5E5E566666666;
defparam prom_inst_0.INIT_RAM_18 = 256'hE0E0E0E0E0E0E5E5E5E5E56666666666DCDC6666666666E5E5E5E5E5E5E0E0E0;
defparam prom_inst_0.INIT_RAM_19 = 256'hDC6666666666E5E5E5E5E5E0E0E0E0E0E0202020202020202020202020202020;
defparam prom_inst_0.INIT_RAM_1A = 256'h202020202020202020202020202020E0E0E0E0E0E0E5E5E5E5E5E566666666DC;
defparam prom_inst_0.INIT_RAM_1B = 256'hE0E0E0E0E0E5E5E5E5E566666666DC6666666666E5E5E5E5E5E5E0E0E0E0E0E0;
defparam prom_inst_0.INIT_RAM_1C = 256'h666666E5E5E5E5E5E0E0E0E0E0E02020202020202020202020202020202020E0;
defparam prom_inst_0.INIT_RAM_1D = 256'h202020000000000020202020202020E0E0E0E0E0E5E5E5E5E566666666DC6666;
defparam prom_inst_0.INIT_RAM_1E = 256'hE0E0E0E5E5E5E5E566666666DC6666666666E5E5E5E5E5E0E0E0E0E020202020;
defparam prom_inst_0.INIT_RAM_1F = 256'h66E5E5E5E5E5E0E0E0E0E020202020202000000000000000202020202020E0E0;
defparam prom_inst_0.INIT_RAM_20 = 256'h00000000000000002020202020E0E0E0E0E0E5E5E5E5E566666666DC66666666;
defparam prom_inst_0.INIT_RAM_21 = 256'hE0E5E5E5E5E566666666DC6666666666E5E5E5E5E5E0E0E0E0E0202020202000;
defparam prom_inst_0.INIT_RAM_22 = 256'hE5E5E5E5E0E0E0E0E020202020200000000000000000002020202020E0E0E0E0;
defparam prom_inst_0.INIT_RAM_23 = 256'h0000000000002020202020E0E0E0E0E0E5E5E5E5E566666666DC6666666666E5;
defparam prom_inst_0.INIT_RAM_24 = 256'hE5E5E5E566666666DC6666666666E5E5E5E5E5E0E0E0E0E02020202020000000;
defparam prom_inst_0.INIT_RAM_25 = 256'hE5E5E0E0E0E0E020202020200000000000000000002020202020E0E0E0E0E0E5;
defparam prom_inst_0.INIT_RAM_26 = 256'h000000002020202020E0E0E0E0E0E5E5E5E5E566666666DC6666666666E5E5E5;
defparam prom_inst_0.INIT_RAM_27 = 256'hE5E566666666DC6666666666E5E5E5E5E5E0E0E0E0E020202020200000000000;
defparam prom_inst_0.INIT_RAM_28 = 256'hE0E0E0E0E020202020202000000000000000202020202020E0E0E0E0E0E5E5E5;
defparam prom_inst_0.INIT_RAM_29 = 256'h20202020202020E0E0E0E0E0E5E5E5E5E566666666DC6666666666E5E5E5E5E5;
defparam prom_inst_0.INIT_RAM_2A = 256'h66666666DC6666666666E5E5E5E5E5E0E0E0E0E0202020202020200000000000;
defparam prom_inst_0.INIT_RAM_2B = 256'hE0E0E0E02020202020202020202020202020202020E0E0E0E0E0E0E5E5E5E5E5;
defparam prom_inst_0.INIT_RAM_2C = 256'h202020E0E0E0E0E0E0E5E5E5E5E5E566666666DC6666666666E5E5E5E5E5E0E0;
defparam prom_inst_0.INIT_RAM_2D = 256'h6666DC6666666666E5E5E5E5E5E5E0E0E0E0E0E0202020202020202020202020;
defparam prom_inst_0.INIT_RAM_2E = 256'hE0E0E0202020202020202020202020202020E0E0E0E0E0E0E5E5E5E5E5666666;
defparam prom_inst_0.INIT_RAM_2F = 256'hE0E0E0E0E0E0E5E5E5E5E5E56666666666DCDC6666666666E5E5E5E5E5E0E0E0;
defparam prom_inst_0.INIT_RAM_30 = 256'hDCDC6666666666E5E5E5E5E5E5E0E0E0E0E0E0E02020202020202020202020E0;
defparam prom_inst_0.INIT_RAM_31 = 256'hE0E0E0E0202020202020202020E0E0E0E0E0E0E0E5E5E5E5E5E5666666666666;
defparam prom_inst_0.INIT_RAM_32 = 256'hE0E0E0E5E5E5E5E5E56666666666DCDCDC666666666666E5E5E5E5E5E5E0E0E0;
defparam prom_inst_0.INIT_RAM_33 = 256'hDC6666666666E5E5E5E5E5E5E0E0E0E0E0E0E0E0E0E0E0E0E0E0E0E0E0E0E0E0;
defparam prom_inst_0.INIT_RAM_34 = 256'hE0E0E0E0E0E0E0E0E0E0E0E0E0E0E0E0E0E5E5E5E5E5E5666666666666DCDCDC;
defparam prom_inst_0.INIT_RAM_35 = 256'hE5E5E5E5E5666666666666DCDCDCDCDC666666666666E5E5E5E5E5E5E0E0E0E0;
defparam prom_inst_0.INIT_RAM_36 = 256'h666666666666E5E5E5E5E5E5E5E0E0E0E0E0E0E0E0E0E0E0E0E0E0E0E0E0E5E5;
defparam prom_inst_0.INIT_RAM_37 = 256'hE0E0E0E0E0E0E0E0E0E0E0E0E5E5E5E5E5E5E5E5666666666666DCDCDCDCDCDC;
defparam prom_inst_0.INIT_RAM_38 = 256'hE5E5666666666666DCDCDCDCDCDCDC666666666666E5E5E5E5E5E5E5E5E0E0E0;
defparam prom_inst_0.INIT_RAM_39 = 256'h6666666666E5E5E5E5E5E5E5E5E5E0E0E0E0E0E0E0E0E0E0E0E5E5E5E5E5E5E5;
defparam prom_inst_0.INIT_RAM_3A = 256'hE5E5E5E5E5E5E5E5E5E5E5E5E5E5E5E5666666666666DCDCDCDCDCDCDCDCDC66;
defparam prom_inst_0.INIT_RAM_3B = 256'h6666666666DCDCDCDCDCDCDCDCDCDC666666666666E5E5E5E5E5E5E5E5E5E5E5;
defparam prom_inst_0.INIT_RAM_3C = 256'h666666666666E5E5E5E5E5E5E5E5E5E5E5E5E5E5E5E5E5E5E5E5E5E5E5666666;
defparam prom_inst_0.INIT_RAM_3D = 256'hE5E5E5E5E5E5E5E5E5E5E56666666666666666DCDCDCDCDCDCDCDCDCDCDC6666;
defparam prom_inst_0.INIT_RAM_3E = 256'h66DCDCDCDCDCDCF4DCDCDCDCDCDC6666666666666666E5E5E5E5E5E5E5E5E5E5;
defparam prom_inst_0.INIT_RAM_3F = 256'h66666666666666E5E5E5E5E5E5E5E5E5E5E5E5E5E5E5E5E56666666666666666;

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
defparam prom_inst_1.INIT_RAM_00 = 256'h363636363636363636363636363636363636AEAEAEAEAEAEAEAEAEAE5C5C5C5C;
defparam prom_inst_1.INIT_RAM_01 = 256'h363636AEAEAEAEAEAEAEAEAE5C5C5C5C5C5C5C5C5CAEAEAEAEAEAEAEAEAEAE36;
defparam prom_inst_1.INIT_RAM_02 = 256'h5C5C5CAEAEAEAEAEAEAEAEAE3636363636363636363636363636363636363636;
defparam prom_inst_1.INIT_RAM_03 = 256'h3636363636363636363636363636363636363636AEAEAEAEAEAEAEAE5C5C5C5C;
defparam prom_inst_1.INIT_RAM_04 = 256'h36363636AEAEAEAEAEAEAEAE5C5C5C5C5CAEAEAEAEAEAEAEAE36363636363636;
defparam prom_inst_1.INIT_RAM_05 = 256'hAEAEAEAEAEAEAE36363636363636363636363636363636363636363636363636;
defparam prom_inst_1.INIT_RAM_06 = 256'hAFAFAFAFAFAFAFAFAFAFAF36363636363636363636AEAEAEAEAEAEAE5C5C5CAE;
defparam prom_inst_1.INIT_RAM_07 = 256'h3636363636AEAEAEAEAEAE5C5CAEAEAEAEAEAEAE36363636363636363636AFAF;
defparam prom_inst_1.INIT_RAM_08 = 256'hAEAE363636363636363636AFAFAFAFAFAFAFAFAFAFAFAFAFAFAFAFAF36363636;
defparam prom_inst_1.INIT_RAM_09 = 256'hAFAFAFAFAFAFAFAFAFAFAFAFAF3636363636363636AEAEAEAEAE5C5CAEAEAEAE;
defparam prom_inst_1.INIT_RAM_0A = 256'h3636363636AEAEAEAE5CAEAEAEAEAEAE3636363636363636AFAFAFAFAFAFAFAF;
defparam prom_inst_1.INIT_RAM_0B = 256'h363636363636AFAFAFAFAFAFAFAFAFAFAFAFAFAFAFAFAFAFAFAFAFAFAF363636;
defparam prom_inst_1.INIT_RAM_0C = 256'hAFAFAFAFAFAFAFAFAFAFAFAFAFAF363636363636AEAEAEAEAEAEAEAEAEAE3636;
defparam prom_inst_1.INIT_RAM_0D = 256'h36363636AEAEAEAEAEAEAEAEAE363636363636AFAFAFAFAFAFAFAFAFAFAFAFAF;
defparam prom_inst_1.INIT_RAM_0E = 256'h36AFAFAFAFAFAFAFAFAFFFFFFFFFFFFFFFFFFFFFFFAFAFAFAFAFAFAFAFAF3636;
defparam prom_inst_1.INIT_RAM_0F = 256'hFFFFFFFFFFFFAFAFAFAFAFAFAFAF363636363636AEAEAEAEAEAEAE3636363636;
defparam prom_inst_1.INIT_RAM_10 = 256'h363636AEAEAEAEAEAE363636363636AFAFAFAFAFAFAFAFFFFFFFFFFFFFFFFFFF;
defparam prom_inst_1.INIT_RAM_11 = 256'hAFAFAFAFAFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFAFAFAFAFAFAFAF363636;
defparam prom_inst_1.INIT_RAM_12 = 256'hFFFFFFFFFFFFFFAFAFAFAFAFAF363636363636AEAEAEAEAE363636363636AFAF;
defparam prom_inst_1.INIT_RAM_13 = 256'h3636AEAEAEAE363636363636AFAFAFAFAFAFFFFFFFFFFFFFFFFFFFFFFFFFFFFF;
defparam prom_inst_1.INIT_RAM_14 = 256'hFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFAFAFAFAFAFAF363636;
defparam prom_inst_1.INIT_RAM_15 = 256'hFFFFFFFFFFFFAFAFAFAFAFAF363636363636AEAEAE3636363636AFAFAFAFAFAF;
defparam prom_inst_1.INIT_RAM_16 = 256'h36AEAE363636363636AFAFAFAFAFAFFFFFFFFFFFFFFFFAFAFAFAFAFAFAFAFAFF;
defparam prom_inst_1.INIT_RAM_17 = 256'hFFFFFFFFFAFAFAFAFAFAFAFAFAFAFAFFFFFFFFFFFFFFAFAFAFAFAFAF36363636;
defparam prom_inst_1.INIT_RAM_18 = 256'hFFFFFFFFFFFFAFAFAFAFAF3636363636AEAE3636363636AFAFAFAFAFAFFFFFFF;
defparam prom_inst_1.INIT_RAM_19 = 256'hAE3636363636AFAFAFAFAFFFFFFFFFFFFFFAFAFAFAFAFAFAFAFAFAFAFAFAFAFA;
defparam prom_inst_1.INIT_RAM_1A = 256'hFAFAFAFAFAFAFAFAFAFAFAFAFAFAFAFFFFFFFFFFFFAFAFAFAFAFAF36363636AE;
defparam prom_inst_1.INIT_RAM_1B = 256'hFFFFFFFFFFAFAFAFAFAF36363636AE3636363636AFAFAFAFAFAFFFFFFFFFFFFF;
defparam prom_inst_1.INIT_RAM_1C = 256'h363636AFAFAFAFAFFFFFFFFFFFFFFAFAFAFAFAFAFAFAFAFAFAFAFAFAFAFAFAFF;
defparam prom_inst_1.INIT_RAM_1D = 256'hFAFAFAF8F8F8F8F8FAFAFAFAFAFAFAFFFFFFFFFFAFAFAFAFAF36363636AE3636;
defparam prom_inst_1.INIT_RAM_1E = 256'hFFFFFFAFAFAFAFAF36363636AE3636363636AFAFAFAFAFFFFFFFFFFFFAFAFAFA;
defparam prom_inst_1.INIT_RAM_1F = 256'h36AFAFAFAFAFFFFFFFFFFFFAFAFAFAFAFAF8F8F8F8F8F8F8FAFAFAFAFAFAFFFF;
defparam prom_inst_1.INIT_RAM_20 = 256'hF8F8F8F8F8F8F8F8FAFAFAFAFAFFFFFFFFFFAFAFAFAFAF36363636AE36363636;
defparam prom_inst_1.INIT_RAM_21 = 256'hFFAFAFAFAFAF36363636AE3636363636AFAFAFAFAFFFFFFFFFFFFAFAFAFAFAF8;
defparam prom_inst_1.INIT_RAM_22 = 256'hAFAFAFAFFFFFFFFFFFFAFAFAFAFAF8F8F8F8F8F8F8F8F8FAFAFAFAFAFFFFFFFF;
defparam prom_inst_1.INIT_RAM_23 = 256'hF8F8F8F8F8F8FAFAFAFAFAFFFFFFFFFFAFAFAFAFAF36363636AE3636363636AF;
defparam prom_inst_1.INIT_RAM_24 = 256'hAFAFAFAF36363636AE3636363636AFAFAFAFAFFFFFFFFFFFFAFAFAFAFAF8F8F8;
defparam prom_inst_1.INIT_RAM_25 = 256'hAFAFFFFFFFFFFFFAFAFAFAFAF8F8F8F8F8F8F8F8F8FAFAFAFAFAFFFFFFFFFFAF;
defparam prom_inst_1.INIT_RAM_26 = 256'hF8F8F8F8FAFAFAFAFAFFFFFFFFFFAFAFAFAFAF36363636AE3636363636AFAFAF;
defparam prom_inst_1.INIT_RAM_27 = 256'hAFAF36363636AE3636363636AFAFAFAFAFFFFFFFFFFFFAFAFAFAFAF8F8F8F8F8;
defparam prom_inst_1.INIT_RAM_28 = 256'hFFFFFFFFFFFAFAFAFAFAFAF8F8F8F8F8F8F8FAFAFAFAFAFAFFFFFFFFFFAFAFAF;
defparam prom_inst_1.INIT_RAM_29 = 256'hFAFAFAFAFAFAFAFFFFFFFFFFAFAFAFAFAF36363636AE3636363636AFAFAFAFAF;
defparam prom_inst_1.INIT_RAM_2A = 256'h36363636AE3636363636AFAFAFAFAFFFFFFFFFFFFAFAFAFAFAFAFAF8F8F8F8F8;
defparam prom_inst_1.INIT_RAM_2B = 256'hFFFFFFFFFAFAFAFAFAFAFAFAFAFAFAFAFAFAFAFAFAFFFFFFFFFFFFAFAFAFAFAF;
defparam prom_inst_1.INIT_RAM_2C = 256'hFAFAFAFFFFFFFFFFFFAFAFAFAFAFAF36363636AE3636363636AFAFAFAFAFFFFF;
defparam prom_inst_1.INIT_RAM_2D = 256'h3636AE3636363636AFAFAFAFAFAFFFFFFFFFFFFFFAFAFAFAFAFAFAFAFAFAFAFA;
defparam prom_inst_1.INIT_RAM_2E = 256'hFFFFFFFAFAFAFAFAFAFAFAFAFAFAFAFAFAFAFFFFFFFFFFFFAFAFAFAFAF363636;
defparam prom_inst_1.INIT_RAM_2F = 256'hFFFFFFFFFFFFAFAFAFAFAFAF3636363636AEAE3636363636AFAFAFAFAFFFFFFF;
defparam prom_inst_1.INIT_RAM_30 = 256'hAEAE3636363636AFAFAFAFAFAFFFFFFFFFFFFFFFFAFAFAFAFAFAFAFAFAFAFAFF;
defparam prom_inst_1.INIT_RAM_31 = 256'hFFFFFFFFFAFAFAFAFAFAFAFAFAFFFFFFFFFFFFFFAFAFAFAFAFAF363636363636;
defparam prom_inst_1.INIT_RAM_32 = 256'hFFFFFFAFAFAFAFAFAF3636363636AEAEAE363636363636AFAFAFAFAFAFFFFFFF;
defparam prom_inst_1.INIT_RAM_33 = 256'hAE3636363636AFAFAFAFAFAFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF;
defparam prom_inst_1.INIT_RAM_34 = 256'hFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFAFAFAFAFAFAF363636363636AEAEAE;
defparam prom_inst_1.INIT_RAM_35 = 256'hAFAFAFAFAF363636363636AEAEAEAEAE363636363636AFAFAFAFAFAFFFFFFFFF;
defparam prom_inst_1.INIT_RAM_36 = 256'h363636363636AFAFAFAFAFAFAFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFAFAF;
defparam prom_inst_1.INIT_RAM_37 = 256'hFFFFFFFFFFFFFFFFFFFFFFFFAFAFAFAFAFAFAFAF363636363636AEAEAEAEAEAE;
defparam prom_inst_1.INIT_RAM_38 = 256'hAFAF363636363636AEAEAEAEAEAEAE363636363636AFAFAFAFAFAFAFAFFFFFFF;
defparam prom_inst_1.INIT_RAM_39 = 256'h3636363636AFAFAFAFAFAFAFAFAFFFFFFFFFFFFFFFFFFFFFFFAFAFAFAFAFAFAF;
defparam prom_inst_1.INIT_RAM_3A = 256'hAFAFAFAFAFAFAFAFAFAFAFAFAFAFAFAF363636363636AEAEAEAEAEAEAEAEAE36;
defparam prom_inst_1.INIT_RAM_3B = 256'h3636363636AEAEAEAEAEAEAEAEAEAE363636363636AFAFAFAFAFAFAFAFAFAFAF;
defparam prom_inst_1.INIT_RAM_3C = 256'h363636363636AFAFAFAFAFAFAFAFAFAFAFAFAFAFAFAFAFAFAFAFAFAFAF363636;
defparam prom_inst_1.INIT_RAM_3D = 256'hAFAFAFAFAFAFAFAFAFAFAF3636363636363636AEAEAEAEAEAEAEAEAEAEAE3636;
defparam prom_inst_1.INIT_RAM_3E = 256'h36AEAEAEAEAEAE5CAEAEAEAEAEAE3636363636363636AFAFAFAFAFAFAFAFAFAF;
defparam prom_inst_1.INIT_RAM_3F = 256'h36363636363636AFAFAFAFAFAFAFAFAFAFAFAFAFAFAFAFAF3636363636363636;

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
defparam prom_inst_2.INIT_RAM_00 = 256'hAEDCAEDCAEDCAEDCAEDCAEDC5CF45CF4AEDCAEDCAEDCAEDCAEDCAEDC36663666;
defparam prom_inst_2.INIT_RAM_01 = 256'hAFE5AFE5AFE5AFE5AFE53666366636663666366636663666366636663666AEDC;
defparam prom_inst_2.INIT_RAM_02 = 256'h36663666366636663666366636663666AFE5AFE5AFE5AFE5AFE5AFE5AFE5AFE5;
defparam prom_inst_2.INIT_RAM_03 = 256'hAEDCAEDCAEDCAEDC5CF45CF45CF4AEDCAEDCAEDCAEDCAEDCAEDCAEDC36663666;
defparam prom_inst_2.INIT_RAM_04 = 256'h366636663666366636663666366636663666366636663666AEDCAEDCAEDCAEDC;
defparam prom_inst_2.INIT_RAM_05 = 256'h3666366636663666366636663666366636663666366636663666366636663666;
defparam prom_inst_2.INIT_RAM_06 = 256'hAEDCAEDC5CF45CF45CF45CF45CF4AEDCAEDCAEDCAEDCAEDCAEDCAEDCAEDC3666;
defparam prom_inst_2.INIT_RAM_07 = 256'h3666366636663666366636663666366636663666AEDCAEDCAEDCAEDCAEDCAEDC;
defparam prom_inst_2.INIT_RAM_08 = 256'h3666366636663666366636663666366636663666366636663666366636663666;
defparam prom_inst_2.INIT_RAM_09 = 256'h5CF45CF45CF45CF45CF45CF45CF4AEDCAEDCAEDCAEDCAEDCAEDCAEDCAEDC3666;
defparam prom_inst_2.INIT_RAM_0A = 256'h3666366636663666366636663666AEDCAEDCAEDCAEDCAEDCAEDCAEDCAEDCAEDC;
defparam prom_inst_2.INIT_RAM_0B = 256'h3666366636663666366636663666366636663666366636663666366636663666;
defparam prom_inst_2.INIT_RAM_0C = 256'h5CF45CF45CF45CF45CF45CF45CF4AEDCAEDCAEDCAEDCAEDCAEDCAEDCAEDCAEDC;
defparam prom_inst_2.INIT_RAM_0D = 256'h3666366636663666AEDCAEDCAEDCAEDCAEDCAEDCAEDCAEDCAEDCAEDC5CF45CF4;
defparam prom_inst_2.INIT_RAM_0E = 256'hAEDC366636663666366636663666366636663666366636663666366636663666;
defparam prom_inst_2.INIT_RAM_0F = 256'h5CF45CF45CF45CF45CF45CF45CF4AEDCAEDCAEDCAEDCAEDCAEDCAEDCAEDCAEDC;
defparam prom_inst_2.INIT_RAM_10 = 256'hAEDCAEDCAEDCAEDCAEDCAEDCAEDCAEDCAEDCAEDCAEDC5CF45CF45CF45CF45CF4;
defparam prom_inst_2.INIT_RAM_11 = 256'hAEDCAEDCAEDC3666366636663666366636663666366636663666366636663666;
defparam prom_inst_2.INIT_RAM_12 = 256'h5CF45CF45CF45CF45CF45CF45CF45CF4AEDCAEDCAEDCAEDCAEDCAEDCAEDCAEDC;
defparam prom_inst_2.INIT_RAM_13 = 256'hAEDCAEDCAEDCAEDCAEDCAEDCAEDCAEDCAEDC5CF45CF45CF45CF45CF45CF45CF4;
defparam prom_inst_2.INIT_RAM_14 = 256'hAEDCAEDCAEDCAEDCAEDCAEDCAEDCAEDCAEDCAEDCAEDCAEDCAEDCAEDCAEDCAEDC;
defparam prom_inst_2.INIT_RAM_15 = 256'h5CF45CF45CF45CF45CF45CF45CF45CF4AEDCAEDCAEDCAEDCAEDCAEDCAEDCAEDC;
defparam prom_inst_2.INIT_RAM_16 = 256'h000000000000000000000000000000000000000000000000000000000000AEDC;

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