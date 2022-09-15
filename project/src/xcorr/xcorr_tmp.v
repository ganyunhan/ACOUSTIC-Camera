//Copyright (C)2014-2022 Gowin Semiconductor Corporation.
//All rights reserved.
//File Title: Template file for instantiation
//GOWIN Version: GowinSynthesis V1.9.8.07
//Part Number: GW2A-LV18PG256C8/I7
//Device: GW2A-18
//Created Time: Wed Sep 14 15:16:29 2022

//Change the instance name and port connections to the signal names
//--------Copy here to design--------

	XCORR_Top your_instance_name(
		.series_x(series_x_i), //input [15:0] series_x
		.series_y(series_y_i), //input [15:0] series_y
		.result(result_o), //output [31:0] result
		.clk(clk_i), //input clk
		.rst(rst_i), //input rst
		.complete(complete_o), //output complete
		.delay(delay_o), //output [9:0] delay
		.start(start_i) //input start
	);

//--------Copy end-------------------
