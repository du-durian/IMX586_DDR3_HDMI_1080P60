//Copyright (C)2014-2026 Gowin Semiconductor Corporation.
//All rights reserved.
//File Title: Template file for instantiation
//Tool Version: V1.9.12.03 (64-bit)
//IP Version: 1.1
//Part Number: GW5AT-LV15MG132C1/I0
//Device: GW5AT-15
//Device Version: B
//Created Time: Tue Sep 22 10:15:21 2026

//Change the instance name and port connections to the signal names
//--------Copy here to design--------

	MIPI_Byte_to_Pixel_Converter_Top your_instance_name(
		.I_RSTN(I_RSTN), //input I_RSTN
		.I_BYTE_CLK(I_BYTE_CLK), //input I_BYTE_CLK
		.I_PIXEL_CLK(I_PIXEL_CLK), //input I_PIXEL_CLK
		.I_SP_EN(I_SP_EN), //input I_SP_EN
		.I_LP_AV_EN(I_LP_AV_EN), //input I_LP_AV_EN
		.I_DT(I_DT), //input [5:0] I_DT
		.I_WC(I_WC), //input [15:0] I_WC
		.I_PAYLOAD_DV(I_PAYLOAD_DV), //input [0:0] I_PAYLOAD_DV
		.I_PAYLOAD(I_PAYLOAD), //input [7:0] I_PAYLOAD
		.O_FV(O_FV), //output O_FV
		.O_LV(O_LV), //output O_LV
		.O_PIXEL(O_PIXEL) //output [7:0] O_PIXEL
	);

//--------Copy end-------------------
