`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Create Date:    11:23:23 02/27/2022 
// Module Name:    rgb2dvi 
//////////////////////////////////////////////////////////////////////////////////

module rgb2dvi #(
	parameter 	ENABLE_OSERDES 	= 1		
)(
	//	Pixel Clock (1X). 
	input 			PixelClk,
	input 			aRst,
	input 			aRst_n, 
	
	input 	[3:0] 	bitflip_i,		//	LVDS Lane Flip. [3]TXC, [2:0]TXD
	input 			oe_i, 		//	Output Enable. 
	
	//	Video Timing Generator (With Data Valid Control)
	input 			vid_pVSync,		//	VSync. High Valid. 
	input 			vid_pHSync,		//	HSync. High Valid. 
	input 			vid_pVDE, 		//	DataValid (Timing). Must be WIDTH + 2. (de & ~dvalid) will send VLG. 
	input 	[23:0] 	vid_pData,		//	RGB Data. [7:0]B(0), [15:8]G(1), [23:16]R(2). 
	
	//	HDMI Serializer (5X). 
	input 	 		SerialClk, 
	output 			TMDS_Clk_p,
	output 			TMDS_Clk_n,
	output 	[2:0] 	TMDS_Data_p,
	output 	[2:0] 	TMDS_Data_n,
	
	output 	[9:0] 	txc_o, 
	output 	[9:0] 	txd0_o, 
	output 	[9:0] 	txd1_o, 
	output 	[9:0] 	txd2_o
);
	
	wire 			w_rst = aRst || (~aRst_n); 
	
	wire 	[3:0] 	w_ctl = 4'b0000; 
	
	//////////////////////////////////////////////////////////////////////////////////
	//	TMDS Encoder
	//////////////////////////////////////////////////////////////////////////////////
	
	wire 	[9:0] 	w_tmds_0_enc, w_tmds_1_enc, w_tmds_2_enc; 
	
	
	reg 	[7:0] 	r_data0, r_data1, r_data2;
	reg 	[1:0] 	r_ctl0, r_ctl1, r_ctl2; 
	reg 			r_de0, r_de1, r_de2; 
	
	always @(posedge PixelClk) begin
		r_data0 <= vid_pData[ 23: 16]; 
		r_ctl0 <= {vid_pVSync, vid_pHSync}; 
		r_de0 <= vid_pVDE; 
	end
	
	
	
	//	tmds_channel can only support 1080P30. Max freq is around 95MHz. 
	
	//tmds_channel enc_0 (
	//	.clk_pixel			(PixelClk),
	//	.video_data			(r_data0),
	//	.data_island_data		(0),
	//	.control_data		(r_ctl0),
	//	.mode				({3'b0, r_de0}),  // Mode select (0 = control, 1 = video, 2 = video guard, 3 = island, 4 = island guard)
	//	.tmds				(w_tmds_0_enc)
	//);
	tmds_enc enc0 (
		.clk_i		(PixelClk),
		.rst_i		(w_rst),
		
		.ctl_i		(r_ctl0),	//	D0:HS/CTL0/CTL2, D1:VS/CTL1/CTL3
		.de_i 		(r_de0),
		.data_i		(r_data0),
		
		.terc4_dat_i	(0), 
		.terc4_en_i		(0), 
		
		.enc_o		(w_tmds_0_enc)
	);

	
	always @(posedge PixelClk) begin
		r_data1 <= vid_pData[15: 8]; 
		r_ctl1 <= w_ctl[1:0]; 
		r_de1 <= vid_pVDE; 
	end
	
	//tmds_channel enc_1 (
	//	.clk_pixel			(PixelClk),
	//	.video_data			(r_data1),
	//	.data_island_data		(0),
	//	.control_data		(r_ctl1),
	//	.mode				({3'b0, r_de1}),  // Mode select (0 = control, 1 = video, 2 = video guard, 3 = island, 4 = island guard)
	//	.tmds				(w_tmds_1_enc)
	//);
	tmds_enc enc1 (
		.clk_i		(PixelClk),
		.rst_i		(w_rst),
		
		.ctl_i		(r_ctl1),	//	D0:HS/CTL0/CTL2, D1:VS/CTL1/CTL3
		.de_i 		(r_de1),
		.data_i		(r_data1),
		
		.terc4_dat_i	(0), 
		.terc4_en_i		(0), 
		
		.enc_o		(w_tmds_1_enc)
	);
	
	always @(posedge PixelClk) begin
		r_data2 <= vid_pData[7:0]; 
		r_ctl2 <= w_ctl[3:2]; 
		r_de2 <= vid_pVDE; 
	end
	
	//tmds_channel enc_2 (
	//	.clk_pixel			(PixelClk),
	//	.video_data			(r_data2),
	//	.data_island_data		(0),
	//	.control_data		(r_ctl2),
	//	.mode				({3'b0, r_de2}),  // Mode select (0 = control, 1 = video, 2 = video guard, 3 = island, 4 = island guard)
	//	.tmds				(w_tmds_2_enc)
	//);
	tmds_enc enc2 (
		.clk_i		(PixelClk),
		.rst_i		(w_rst),
		
		.ctl_i		(r_ctl2),	//	D0:HS/CTL0/CTL2, D1:VS/CTL1/CTL3
		.de_i 		(r_de2),
		.data_i		(r_data2),
		
		.terc4_dat_i	(0), 
		.terc4_en_i		(0), 
		
		.enc_o		(w_tmds_2_enc)
	);
	
	
	//////////////////////////////////////////////////////////////////////////////////
	//	Serializer
	//////////////////////////////////////////////////////////////////////////////////
	
	reg 	[9:0] 	r_tmds_0_enc, r_tmds_1_enc, r_tmds_2_enc; 
	always @(posedge PixelClk) begin
		r_tmds_0_enc <= bitflip_i[0] ? ~w_tmds_0_enc : w_tmds_0_enc; 
		r_tmds_1_enc <= bitflip_i[1]?~w_tmds_1_enc:w_tmds_1_enc; 
		r_tmds_2_enc <= bitflip_i[2]?~w_tmds_2_enc:w_tmds_2_enc; 
	end
	
	assign txc_o = 10'b1111100000;
	assign txd0_o = r_tmds_0_enc;
	assign txd1_o = r_tmds_1_enc;
	assign txd2_o = r_tmds_2_enc; 
	
	
	
endmodule
