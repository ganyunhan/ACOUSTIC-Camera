//Copyright (C)2014-2022 Gowin Semiconductor Corporation.
//All rights reserved.
//File Title: Template file for instantiation
//GOWIN Version: V1.9.8.08
//Part Number: GW2A-LV18PG256C8/I7
//Device: GW2A-18
//Created Time: Sat Oct 29 16:05:19 2022

//Change the instance name and port connections to the signal names
//--------Copy here to design--------

    rpll_9MHz your_instance_name(
        .clkout(clkout_o), //output clkout
        .reset(reset_i), //input reset
        .clkin(clkin_i) //input clkin
    );

//--------Copy end-------------------
