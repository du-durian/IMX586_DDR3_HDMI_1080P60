//Copyright (C)2014-2026 Gowin Semiconductor Corporation.
//All rights reserved.
//File Title: Template file for instantiation
//Tool Version: V1.9.12.03 (64-bit)
//IP Version: 1.1
//Part Number: GW5AT-LV15MG132C1/I0
//Device: GW5AT-15
//Device Version: B
//Created Time: Tue Sep 22 10:12:19 2026

//Change the instance name and port connections to the signal names
//--------Copy here to design--------

	fifo_480_30 your_instance_name(
		.Data(Data), //input [479:0] Data
		.Reset(Reset), //input Reset
		.WrClk(WrClk), //input WrClk
		.RdClk(RdClk), //input RdClk
		.WrEn(WrEn), //input WrEn
		.RdEn(RdEn), //input RdEn
		.Rnum(Rnum), //output [10:0] Rnum
		.Almost_Empty(Almost_Empty), //output Almost_Empty
		.Almost_Full(Almost_Full), //output Almost_Full
		.Q(Q), //output [29:0] Q
		.Empty(Empty), //output Empty
		.Full(Full) //output Full
	);

//--------Copy end-------------------
