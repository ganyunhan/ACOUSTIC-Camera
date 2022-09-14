//Copyright (C)2014-2022 GOWIN Semiconductor Corporation.
//All rights reserved.
//File Title: Timing Constraints file
//GOWIN Version: 1.9.8.07 
//Created Time: 2022-09-13 11:59:29
create_clock -name PAD_CLK_MIC -period 333.333 -waveform {0 166.667} [get_ports {PAD_CLK_MIC}] -add
create_clock -name PAD_CLK_WS -period 21333.332 -waveform {0 10666.666} [get_ports {PAD_LCK_WS}] -add
create_clock -name PAD_CLK -period 37.037 -waveform {0 18.518} [get_ports {PAD_CLK}] -add
set_operating_conditions -grade i -model fast -speed 8 -setup -hold -max -min -max_min
