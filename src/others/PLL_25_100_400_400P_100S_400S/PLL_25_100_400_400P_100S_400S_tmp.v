//Copyright (C)2014-2026 Gowin Semiconductor Corporation.
//All rights reserved.
//File Title: Template file for instantiation
//Part Number: GW5AT-LV15MG132C1/I0
//Device: GW5AT-15
//Device Version: B


//Change the instance name and port connections to the signal names
//--------Copy here to design--------
    PLL_25_100_400_400P_100S_400S your_instance_name(
        .clkin(clkin), //input  clkin
        .pssel(pssel), //input [2:0] pssel
        .psdir(psdir), //input  psdir
        .pspulse(pspulse), //input  pspulse
        .clkout0(clkout0), //output  clkout0
        .clkout1(clkout1), //output  clkout1
        .clkout2(clkout2), //output  clkout2
        .clkout3(clkout3), //output  clkout3
        .clkout4(clkout4), //output  clkout4
        .lock(lock), //output  lock
        .mdclk(mdclk) //input  mdclk
);


//--------Copy end-------------------
