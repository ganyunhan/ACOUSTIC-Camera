//Copyright (C)2014-2022 Gowin Semiconductor Corporation.
//All rights reserved.
//File Title: Template file for instantiation
//GOWIN Version: GowinSynthesis V1.9.8.07
//Part Number: GW2A-LV18PG256C8/I7
//Device: GW2A-18
//Created Time: Wed Sep 14 21:22:11 2022

//Change the instance name and port connections to the signal names
//--------Copy here to design--------

	fifo_mic your_instance_name(
		.Data(Data_i), //input [15:0] Data
		.WrClk(WrClk_i), //input WrClk
		.RdClk(RdClk_i), //input RdClk
		.WrEn(WrEn_i), //input WrEn
		.RdEn(RdEn_i), //input RdEn
		.Almost_Empty(Almost_Empty_o), //output Almost_Empty
		.Almost_Full(Almost_Full_o), //output Almost_Full
		.Q(Q_o), //output [15:0] Q
		.Empty(Empty_o), //output Empty
		.Full(Full_o) //output Full
	);

//--------Copy end-------------------
