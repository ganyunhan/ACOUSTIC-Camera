//Copyright (C)2014-2022 GOWIN Semiconductor Corporation.
//All rights reserved.
//File Title: Timing Constraints file
//GOWIN Version: 1.9.8.08 
//Created Time: 2022-10-26 21:41:32
create_clock -name clk_9MHz -period 111.111 -waveform {0 55.556} [get_nets {clk_out_2}] -add
