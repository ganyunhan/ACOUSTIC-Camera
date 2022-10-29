//Copyright (C)2014-2022 GOWIN Semiconductor Corporation.
//All rights reserved.
//File Title: Timing Constraints file
//GOWIN Version: 1.9.8.08 
//Created Time: 2022-10-29 16:17:02
create_clock -name cmos_vsync -period 1000 -waveform {0 500} [get_ports {PAD_CMOS_VSYN}] -add
create_clock -name cmos_pclk -period 10 -waveform {0 5} [get_ports {PAD_CMOS_PCLK}] -add
create_clock -name ext_clk -period 37.037 -waveform {0 18.518} [get_ports {PAD_CLK}] -add
create_clock -name clk_mic -period 166.667 -waveform {0 83.334} [get_ports {PAD_CLK_MIC}] -add
