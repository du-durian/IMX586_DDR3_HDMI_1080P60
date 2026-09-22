//Copyright (C)2014-2024 Gowin Semiconductor Corporation.
//All rights reserved.
//File Title: Post-PnR Verilog Simulation Model file
//Tool Version: V1.9.10.02
//Created Time: Wed Oct  9 16:53:16 2024

`timescale 100 ps/100 ps
module MIPI_RX_Advance_Top(
	reset_n,
	lp_clk_in,
	lp_clk_dir,
	lp_data0_in,
	lp_data0_dir,
	hs_en,
	clk_term_en,
	data_term_en,
	lp_clk_out,
	clk_byte_out,
	data_out0,
	lp_data0_out,
	ready,
	MIPI_CLK_P,
	MIPI_CLK_N,
	MIPI_LANE0_P,
	MIPI_LANE0_N
);
input reset_n;
input [1:0] lp_clk_in;
input lp_clk_dir;
input [1:0] lp_data0_in;
input lp_data0_dir;
input hs_en;
input clk_term_en;
input data_term_en;
output [1:0] lp_clk_out;
output clk_byte_out;
output [7:0] data_out0;
output [1:0] lp_data0_out;
output ready;
inout MIPI_CLK_P;
inout MIPI_CLK_N;
inout MIPI_LANE0_P;
inout MIPI_LANE0_N;
wire GND;
wire MIPI_CLK_N;
wire MIPI_CLK_P;
wire MIPI_LANE0_N;
wire MIPI_LANE0_P;
wire VCC;
wire clk_byte_out;
wire clk_term_en;
wire [7:0] data_out0;
wire data_term_en;
wire hs_en;
wire lp_clk_dir;
wire [1:0] lp_clk_in;
wire [1:0] lp_clk_out;
wire lp_data0_dir;
wire [1:0] lp_data0_in;
wire [1:0] lp_data0_out;
wire ready;
wire reset_n;
wire \DPHY_RX_INST/HS_CLK ;
wire \DPHY_RX_INST/n9_6 ;
wire \DPHY_RX_INST/n17_6 ;
wire \DPHY_RX_INST/n19_6 ;
wire [0:0] \DPHY_RX_INST/HS_DATA ;
wire [7:0] \DPHY_RX_INST/data0 ;
wire \DPHY_RX_INST/u_idesx8/opensync_cken ;
wire \DPHY_RX_INST/u_idesx8/xstop ;
wire \DPHY_RX_INST/u_idesx8/udel_dataini0_1_DF ;
wire \DPHY_RX_INST/u_idesx8/dataini_t0 ;
wire \DPHY_RX_INST/u_idesx8/eclko ;
wire [3:0] \DPHY_RX_INST/u_idesx8/opensync ;
wire \DPHY_RX_INST/u_Aligner/wd/n1142_4 ;
wire \DPHY_RX_INST/u_Aligner/wd/n1143_3 ;
wire \DPHY_RX_INST/u_Aligner/wd/n1144_3 ;
wire \DPHY_RX_INST/u_Aligner/wd/n1145_3 ;
wire \DPHY_RX_INST/u_Aligner/wd/n1146_3 ;
wire \DPHY_RX_INST/u_Aligner/wd/n1147_3 ;
wire \DPHY_RX_INST/u_Aligner/wd/n1148_3 ;
wire \DPHY_RX_INST/u_Aligner/wd/n579_3 ;
wire \DPHY_RX_INST/u_Aligner/wd/n580_3 ;
wire \DPHY_RX_INST/u_Aligner/wd/n581_3 ;
wire \DPHY_RX_INST/u_Aligner/wd/n582_3 ;
wire \DPHY_RX_INST/u_Aligner/wd/n583_3 ;
wire \DPHY_RX_INST/u_Aligner/wd/n584_3 ;
wire \DPHY_RX_INST/u_Aligner/wd/n585_3 ;
wire \DPHY_RX_INST/u_Aligner/wd/n586_3 ;
wire \DPHY_RX_INST/u_Aligner/wd/n1141_3 ;
wire \DPHY_RX_INST/u_Aligner/wd/n70_5 ;
wire \DPHY_RX_INST/u_Aligner/wd/n1142_5 ;
wire \DPHY_RX_INST/u_Aligner/wd/n1142_6 ;
wire \DPHY_RX_INST/u_Aligner/wd/n1142_7 ;
wire \DPHY_RX_INST/u_Aligner/wd/n1143_4 ;
wire \DPHY_RX_INST/u_Aligner/wd/n1144_4 ;
wire \DPHY_RX_INST/u_Aligner/wd/n1145_4 ;
wire \DPHY_RX_INST/u_Aligner/wd/n1146_4 ;
wire \DPHY_RX_INST/u_Aligner/wd/n1147_4 ;
wire \DPHY_RX_INST/u_Aligner/wd/n1148_4 ;
wire \DPHY_RX_INST/u_Aligner/wd/n579_4 ;
wire \DPHY_RX_INST/u_Aligner/wd/n579_5 ;
wire \DPHY_RX_INST/u_Aligner/wd/n580_4 ;
wire \DPHY_RX_INST/u_Aligner/wd/n580_5 ;
wire \DPHY_RX_INST/u_Aligner/wd/n580_6 ;
wire \DPHY_RX_INST/u_Aligner/wd/n581_4 ;
wire \DPHY_RX_INST/u_Aligner/wd/n581_5 ;
wire \DPHY_RX_INST/u_Aligner/wd/n581_6 ;
wire \DPHY_RX_INST/u_Aligner/wd/n582_4 ;
wire \DPHY_RX_INST/u_Aligner/wd/n582_5 ;
wire \DPHY_RX_INST/u_Aligner/wd/n583_4 ;
wire \DPHY_RX_INST/u_Aligner/wd/n583_5 ;
wire \DPHY_RX_INST/u_Aligner/wd/n584_4 ;
wire \DPHY_RX_INST/u_Aligner/wd/n584_5 ;
wire \DPHY_RX_INST/u_Aligner/wd/n585_4 ;
wire \DPHY_RX_INST/u_Aligner/wd/n585_5 ;
wire \DPHY_RX_INST/u_Aligner/wd/n586_4 ;
wire \DPHY_RX_INST/u_Aligner/wd/n586_5 ;
wire \DPHY_RX_INST/u_Aligner/wd/n586_6 ;
wire \DPHY_RX_INST/u_Aligner/wd/n1141_4 ;
wire \DPHY_RX_INST/u_Aligner/wd/ready_d_3 ;
wire \DPHY_RX_INST/u_Aligner/wd/ready_d_4 ;
wire \DPHY_RX_INST/u_Aligner/wd/n1142_8 ;
wire \DPHY_RX_INST/u_Aligner/wd/n1142_9 ;
wire \DPHY_RX_INST/u_Aligner/wd/n1142_10 ;
wire \DPHY_RX_INST/u_Aligner/wd/n1142_11 ;
wire \DPHY_RX_INST/u_Aligner/wd/n1142_12 ;
wire \DPHY_RX_INST/u_Aligner/wd/n1142_13 ;
wire \DPHY_RX_INST/u_Aligner/wd/n1142_14 ;
wire \DPHY_RX_INST/u_Aligner/wd/n1142_15 ;
wire \DPHY_RX_INST/u_Aligner/wd/n1142_16 ;
wire \DPHY_RX_INST/u_Aligner/wd/n1143_5 ;
wire \DPHY_RX_INST/u_Aligner/wd/n1144_5 ;
wire \DPHY_RX_INST/u_Aligner/wd/n1145_5 ;
wire \DPHY_RX_INST/u_Aligner/wd/n1147_5 ;
wire \DPHY_RX_INST/u_Aligner/wd/n579_6 ;
wire \DPHY_RX_INST/u_Aligner/wd/n579_7 ;
wire \DPHY_RX_INST/u_Aligner/wd/n579_8 ;
wire \DPHY_RX_INST/u_Aligner/wd/n580_7 ;
wire \DPHY_RX_INST/u_Aligner/wd/n580_8 ;
wire \DPHY_RX_INST/u_Aligner/wd/n580_9 ;
wire \DPHY_RX_INST/u_Aligner/wd/n580_10 ;
wire \DPHY_RX_INST/u_Aligner/wd/n581_7 ;
wire \DPHY_RX_INST/u_Aligner/wd/n581_8 ;
wire \DPHY_RX_INST/u_Aligner/wd/n581_9 ;
wire \DPHY_RX_INST/u_Aligner/wd/n581_10 ;
wire \DPHY_RX_INST/u_Aligner/wd/n582_6 ;
wire \DPHY_RX_INST/u_Aligner/wd/n582_7 ;
wire \DPHY_RX_INST/u_Aligner/wd/n582_8 ;
wire \DPHY_RX_INST/u_Aligner/wd/n583_6 ;
wire \DPHY_RX_INST/u_Aligner/wd/n583_7 ;
wire \DPHY_RX_INST/u_Aligner/wd/n583_8 ;
wire \DPHY_RX_INST/u_Aligner/wd/n584_6 ;
wire \DPHY_RX_INST/u_Aligner/wd/n584_7 ;
wire \DPHY_RX_INST/u_Aligner/wd/n584_8 ;
wire \DPHY_RX_INST/u_Aligner/wd/n585_6 ;
wire \DPHY_RX_INST/u_Aligner/wd/n585_7 ;
wire \DPHY_RX_INST/u_Aligner/wd/n585_8 ;
wire \DPHY_RX_INST/u_Aligner/wd/n586_7 ;
wire \DPHY_RX_INST/u_Aligner/wd/n586_8 ;
wire \DPHY_RX_INST/u_Aligner/wd/n586_9 ;
wire \DPHY_RX_INST/u_Aligner/wd/n586_10 ;
wire [7:0] \DPHY_RX_INST/u_Aligner/wd/reg0[0] ;
wire [7:0] \DPHY_RX_INST/u_Aligner/wd/reg1[0] ;
wire [7:0] \DPHY_RX_INST/u_Aligner/wd/reg2[0] ;
wire [7:0] \DPHY_RX_INST/u_Aligner/wd/reg3[0] ;
wire [7:0] \DPHY_RX_INST/u_Aligner/wd/reg4[0] ;
wire [7:0] \DPHY_RX_INST/u_Aligner/wd/reg5[0] ;
wire [7:0] \DPHY_RX_INST/u_Aligner/wd/shftamt ;
VCC VCC_cZ (
  .V(VCC)
);
GND GND_cZ (
  .G(GND)
);
GSR GSR (
	.GSRI(VCC)
);
MIPI_IBUF \DPHY_RX_INST/MIPI_IBUF_CLK  (
	.I(lp_clk_in[1]),
	.OEN(\DPHY_RX_INST/n9_6 ),
	.IO(MIPI_CLK_P),
	.IB(lp_clk_in[0]),
	.IOB(MIPI_CLK_N),
	.OENB(\DPHY_RX_INST/n9_6 ),
	.HSREN(clk_term_en),
	.HSEN(clk_term_en),
	.OB(lp_clk_out[0]),
	.OL(lp_clk_out[1]),
	.OH(\DPHY_RX_INST/HS_CLK )
);
MIPI_IBUF \DPHY_RX_INST/MIPI_IBUF_LANE0  (
	.I(lp_data0_in[1]),
	.OEN(\DPHY_RX_INST/n17_6 ),
	.IO(MIPI_LANE0_P),
	.IB(lp_data0_in[0]),
	.IOB(MIPI_LANE0_N),
	.OENB(\DPHY_RX_INST/n17_6 ),
	.HSREN(data_term_en),
	.HSEN(clk_term_en),
	.OB(lp_data0_out[0]),
	.OL(lp_data0_out[1]),
	.OH(\DPHY_RX_INST/HS_DATA [0])
);
INV \DPHY_RX_INST/n9_s2  (
	.I(lp_clk_dir),
	.O(\DPHY_RX_INST/n9_6 )
);
INV \DPHY_RX_INST/n17_s2  (
	.I(lp_data0_dir),
	.O(\DPHY_RX_INST/n17_6 )
);
INV \DPHY_RX_INST/n19_s2  (
	.I(reset_n),
	.O(\DPHY_RX_INST/n19_6 )
);
LUT4 \DPHY_RX_INST/u_idesx8/LUT4_1  (
	.I0(VCC),
	.I1(VCC),
	.I2(\DPHY_RX_INST/u_idesx8/opensync [3]),
	.I3(\DPHY_RX_INST/u_idesx8/opensync [0]),
	.F(\DPHY_RX_INST/u_idesx8/opensync_cken )
);
defparam \DPHY_RX_INST/u_idesx8/LUT4_1 .INIT=16'h0A78;
LUT4 \DPHY_RX_INST/u_idesx8/LUT4_0  (
	.I0(GND),
	.I1(GND),
	.I2(\DPHY_RX_INST/u_idesx8/opensync [1]),
	.I3(\DPHY_RX_INST/u_idesx8/opensync [0]),
	.F(\DPHY_RX_INST/u_idesx8/xstop )
);
defparam \DPHY_RX_INST/u_idesx8/LUT4_0 .INIT=16'hFFFE;
DFFCE \DPHY_RX_INST/u_idesx8/opensync_2_s0  (
	.D(\DPHY_RX_INST/u_idesx8/opensync [1]),
	.CLK(\DPHY_RX_INST/HS_CLK ),
	.CE(\DPHY_RX_INST/u_idesx8/opensync_cken ),
	.CLEAR(\DPHY_RX_INST/n19_6 ),
	.Q(\DPHY_RX_INST/u_idesx8/opensync [2])
);
defparam \DPHY_RX_INST/u_idesx8/opensync_2_s0 .INIT=1'b0;
DFFCE \DPHY_RX_INST/u_idesx8/opensync_1_s0  (
	.D(\DPHY_RX_INST/u_idesx8/opensync [0]),
	.CLK(\DPHY_RX_INST/HS_CLK ),
	.CE(\DPHY_RX_INST/u_idesx8/opensync_cken ),
	.CLEAR(\DPHY_RX_INST/n19_6 ),
	.Q(\DPHY_RX_INST/u_idesx8/opensync [1])
);
defparam \DPHY_RX_INST/u_idesx8/opensync_1_s0 .INIT=1'b0;
DFFCE \DPHY_RX_INST/u_idesx8/opensync_3_s0  (
	.D(\DPHY_RX_INST/u_idesx8/opensync [2]),
	.CLK(\DPHY_RX_INST/HS_CLK ),
	.CE(\DPHY_RX_INST/u_idesx8/opensync_cken ),
	.CLEAR(\DPHY_RX_INST/n19_6 ),
	.Q(\DPHY_RX_INST/u_idesx8/opensync [3])
);
defparam \DPHY_RX_INST/u_idesx8/opensync_3_s0 .INIT=1'b0;
DFFPE \DPHY_RX_INST/u_idesx8/opensync_0_s0  (
	.D(\DPHY_RX_INST/u_idesx8/opensync [3]),
	.CLK(\DPHY_RX_INST/HS_CLK ),
	.CE(\DPHY_RX_INST/u_idesx8/opensync_cken ),
	.PRESET(\DPHY_RX_INST/n19_6 ),
	.Q(\DPHY_RX_INST/u_idesx8/opensync [0])
);
defparam \DPHY_RX_INST/u_idesx8/opensync_0_s0 .INIT=1'b1;
IODELAY \DPHY_RX_INST/u_idesx8/udel_dataini0  (
	.DI(\DPHY_RX_INST/HS_DATA [0]),
	.SDTAP(GND),
	.VALUE(GND),
	.DLYSTEP({GND, GND, GND, GND, GND, GND, GND, GND}),
	.DO(\DPHY_RX_INST/u_idesx8/dataini_t0 ),
	.DF(\DPHY_RX_INST/u_idesx8/udel_dataini0_1_DF )
);
defparam \DPHY_RX_INST/u_idesx8/udel_dataini0 .C_STATIC_DLY=0;
defparam \DPHY_RX_INST/u_idesx8/udel_dataini0 .DYN_DLY_EN="FALSE";
defparam \DPHY_RX_INST/u_idesx8/udel_dataini0 .ADAPT_EN="FALSE";
//IDES8 \DPHY_RX_INST/u_idesx8/Inst4_IDES80  (
//	.D(\DPHY_RX_INST/u_idesx8/dataini_t0 ),
//	.PCLK(clk_byte_out),
//	.FCLK(\DPHY_RX_INST/u_idesx8/eclko ),
//	.RESET(\DPHY_RX_INST/n19_6 ),
//	.CALIB(GND),
//	.Q0(\DPHY_RX_INST/data0 [0]),
//	.Q1(\DPHY_RX_INST/data0 [1]),
//	.Q2(\DPHY_RX_INST/data0 [2]),
//	.Q3(\DPHY_RX_INST/data0 [3]),
//	.Q4(\DPHY_RX_INST/data0 [4]),
//	.Q5(\DPHY_RX_INST/data0 [5]),
//	.Q6(\DPHY_RX_INST/data0 [6]),
//	.Q7(\DPHY_RX_INST/data0 [7])
//);
wire [7:0] data_invert;
IDES8 \DPHY_RX_INST/u_idesx8/Inst4_IDES80  (
	.D(\DPHY_RX_INST/u_idesx8/dataini_t0 ),
	.PCLK(clk_byte_out),
	.FCLK(\DPHY_RX_INST/u_idesx8/eclko ),
	.RESET(\DPHY_RX_INST/n19_6 ),
	.CALIB(GND),
	.Q0(data_invert [0]),
	.Q1(data_invert [1]),
	.Q2(data_invert [2]),
	.Q3(data_invert [3]),
	.Q4(data_invert [4]),
	.Q5(data_invert [5]),
	.Q6(data_invert [6]),
	.Q7(data_invert [7])
);
assign \DPHY_RX_INST/data0 = ~data_invert;

DHCE \DPHY_RX_INST/u_idesx8/u_DHCEN  (
	.CLKIN(\DPHY_RX_INST/HS_CLK ),
	.CEN(\DPHY_RX_INST/u_idesx8/xstop ),
	.CLKOUT(\DPHY_RX_INST/u_idesx8/eclko )
);
CLKDIV \DPHY_RX_INST/u_idesx8/Inst3_CLKDIV  (
	.HCLKIN(\DPHY_RX_INST/u_idesx8/eclko ),
	.RESETN(reset_n),
	.CALIB(GND),
	.CLKOUT(clk_byte_out)
);
defparam \DPHY_RX_INST/u_idesx8/Inst3_CLKDIV .DIV_MODE="4";
LUT4 \DPHY_RX_INST/u_Aligner/wd/n1142_s0  (
	.I0(ready),
	.I1(\DPHY_RX_INST/u_Aligner/wd/n1142_5 ),
	.I2(\DPHY_RX_INST/u_Aligner/wd/n1142_6 ),
	.I3(\DPHY_RX_INST/u_Aligner/wd/n1142_7 ),
	.F(\DPHY_RX_INST/u_Aligner/wd/n1142_4 )
);
defparam \DPHY_RX_INST/u_Aligner/wd/n1142_s0 .INIT=16'h4000;
LUT4 \DPHY_RX_INST/u_Aligner/wd/n1143_s0  (
	.I0(ready),
	.I1(\DPHY_RX_INST/u_Aligner/wd/n1142_6 ),
	.I2(\DPHY_RX_INST/u_Aligner/wd/n1142_7 ),
	.I3(\DPHY_RX_INST/u_Aligner/wd/n1143_4 ),
	.F(\DPHY_RX_INST/u_Aligner/wd/n1143_3 )
);
defparam \DPHY_RX_INST/u_Aligner/wd/n1143_s0 .INIT=16'h4000;
LUT4 \DPHY_RX_INST/u_Aligner/wd/n1144_s0  (
	.I0(ready),
	.I1(\DPHY_RX_INST/u_Aligner/wd/n1144_4 ),
	.I2(\DPHY_RX_INST/u_Aligner/wd/n1142_6 ),
	.I3(\DPHY_RX_INST/u_Aligner/wd/n1142_7 ),
	.F(\DPHY_RX_INST/u_Aligner/wd/n1144_3 )
);
defparam \DPHY_RX_INST/u_Aligner/wd/n1144_s0 .INIT=16'h4000;
LUT4 \DPHY_RX_INST/u_Aligner/wd/n1145_s0  (
	.I0(ready),
	.I1(\DPHY_RX_INST/u_Aligner/wd/n1142_6 ),
	.I2(\DPHY_RX_INST/u_Aligner/wd/n1142_7 ),
	.I3(\DPHY_RX_INST/u_Aligner/wd/n1145_4 ),
	.F(\DPHY_RX_INST/u_Aligner/wd/n1145_3 )
);
defparam \DPHY_RX_INST/u_Aligner/wd/n1145_s0 .INIT=16'h4000;
LUT4 \DPHY_RX_INST/u_Aligner/wd/n1146_s0  (
	.I0(ready),
	.I1(\DPHY_RX_INST/u_Aligner/wd/n1146_4 ),
	.I2(\DPHY_RX_INST/u_Aligner/wd/n1142_6 ),
	.I3(\DPHY_RX_INST/u_Aligner/wd/n1142_7 ),
	.F(\DPHY_RX_INST/u_Aligner/wd/n1146_3 )
);
defparam \DPHY_RX_INST/u_Aligner/wd/n1146_s0 .INIT=16'h4000;
LUT4 \DPHY_RX_INST/u_Aligner/wd/n1147_s0  (
	.I0(ready),
	.I1(\DPHY_RX_INST/u_Aligner/wd/n1147_4 ),
	.I2(\DPHY_RX_INST/u_Aligner/wd/n1142_6 ),
	.I3(\DPHY_RX_INST/u_Aligner/wd/n1142_7 ),
	.F(\DPHY_RX_INST/u_Aligner/wd/n1147_3 )
);
defparam \DPHY_RX_INST/u_Aligner/wd/n1147_s0 .INIT=16'h4000;
LUT4 \DPHY_RX_INST/u_Aligner/wd/n1148_s0  (
	.I0(ready),
	.I1(\DPHY_RX_INST/u_Aligner/wd/n1148_4 ),
	.I2(\DPHY_RX_INST/u_Aligner/wd/n1142_6 ),
	.I3(\DPHY_RX_INST/u_Aligner/wd/n1142_7 ),
	.F(\DPHY_RX_INST/u_Aligner/wd/n1148_3 )
);
defparam \DPHY_RX_INST/u_Aligner/wd/n1148_s0 .INIT=16'h4000;
LUT4 \DPHY_RX_INST/u_Aligner/wd/n579_s0  (
	.I0(\DPHY_RX_INST/u_Aligner/wd/shftamt [0]),
	.I1(\DPHY_RX_INST/u_Aligner/wd/reg4[0] [2]),
	.I2(\DPHY_RX_INST/u_Aligner/wd/n579_4 ),
	.I3(\DPHY_RX_INST/u_Aligner/wd/n579_5 ),
	.F(\DPHY_RX_INST/u_Aligner/wd/n579_3 )
);
defparam \DPHY_RX_INST/u_Aligner/wd/n579_s0 .INIT=16'hFFF8;
LUT4 \DPHY_RX_INST/u_Aligner/wd/n580_s0  (
	.I0(\DPHY_RX_INST/u_Aligner/wd/shftamt [2]),
	.I1(\DPHY_RX_INST/u_Aligner/wd/n580_4 ),
	.I2(\DPHY_RX_INST/u_Aligner/wd/n580_5 ),
	.I3(\DPHY_RX_INST/u_Aligner/wd/n580_6 ),
	.F(\DPHY_RX_INST/u_Aligner/wd/n580_3 )
);
defparam \DPHY_RX_INST/u_Aligner/wd/n580_s0 .INIT=16'hEF00;
LUT4 \DPHY_RX_INST/u_Aligner/wd/n581_s0  (
	.I0(\DPHY_RX_INST/u_Aligner/wd/shftamt [2]),
	.I1(\DPHY_RX_INST/u_Aligner/wd/n581_4 ),
	.I2(\DPHY_RX_INST/u_Aligner/wd/n581_5 ),
	.I3(\DPHY_RX_INST/u_Aligner/wd/n581_6 ),
	.F(\DPHY_RX_INST/u_Aligner/wd/n581_3 )
);
defparam \DPHY_RX_INST/u_Aligner/wd/n581_s0 .INIT=16'hEF00;
LUT4 \DPHY_RX_INST/u_Aligner/wd/n582_s0  (
	.I0(\DPHY_RX_INST/u_Aligner/wd/shftamt [0]),
	.I1(\DPHY_RX_INST/u_Aligner/wd/reg3[0] [7]),
	.I2(\DPHY_RX_INST/u_Aligner/wd/n582_4 ),
	.I3(\DPHY_RX_INST/u_Aligner/wd/n582_5 ),
	.F(\DPHY_RX_INST/u_Aligner/wd/n582_3 )
);
defparam \DPHY_RX_INST/u_Aligner/wd/n582_s0 .INIT=16'hFFF8;
LUT4 \DPHY_RX_INST/u_Aligner/wd/n583_s0  (
	.I0(\DPHY_RX_INST/u_Aligner/wd/shftamt [0]),
	.I1(\DPHY_RX_INST/u_Aligner/wd/reg3[0] [6]),
	.I2(\DPHY_RX_INST/u_Aligner/wd/n583_4 ),
	.I3(\DPHY_RX_INST/u_Aligner/wd/n583_5 ),
	.F(\DPHY_RX_INST/u_Aligner/wd/n583_3 )
);
defparam \DPHY_RX_INST/u_Aligner/wd/n583_s0 .INIT=16'hFFF8;
LUT4 \DPHY_RX_INST/u_Aligner/wd/n584_s0  (
	.I0(\DPHY_RX_INST/u_Aligner/wd/shftamt [0]),
	.I1(\DPHY_RX_INST/u_Aligner/wd/reg3[0] [5]),
	.I2(\DPHY_RX_INST/u_Aligner/wd/n584_4 ),
	.I3(\DPHY_RX_INST/u_Aligner/wd/n584_5 ),
	.F(\DPHY_RX_INST/u_Aligner/wd/n584_3 )
);
defparam \DPHY_RX_INST/u_Aligner/wd/n584_s0 .INIT=16'hFFF8;
LUT4 \DPHY_RX_INST/u_Aligner/wd/n585_s0  (
	.I0(\DPHY_RX_INST/u_Aligner/wd/shftamt [0]),
	.I1(\DPHY_RX_INST/u_Aligner/wd/reg3[0] [4]),
	.I2(\DPHY_RX_INST/u_Aligner/wd/n585_4 ),
	.I3(\DPHY_RX_INST/u_Aligner/wd/n585_5 ),
	.F(\DPHY_RX_INST/u_Aligner/wd/n585_3 )
);
defparam \DPHY_RX_INST/u_Aligner/wd/n585_s0 .INIT=16'hFFF8;
LUT4 \DPHY_RX_INST/u_Aligner/wd/n586_s0  (
	.I0(\DPHY_RX_INST/u_Aligner/wd/shftamt [2]),
	.I1(\DPHY_RX_INST/u_Aligner/wd/n586_4 ),
	.I2(\DPHY_RX_INST/u_Aligner/wd/n586_5 ),
	.I3(\DPHY_RX_INST/u_Aligner/wd/n586_6 ),
	.F(\DPHY_RX_INST/u_Aligner/wd/n586_3 )
);
defparam \DPHY_RX_INST/u_Aligner/wd/n586_s0 .INIT=16'hEF00;
LUT4 \DPHY_RX_INST/u_Aligner/wd/n1141_s0  (
	.I0(ready),
	.I1(\DPHY_RX_INST/u_Aligner/wd/n1141_4 ),
	.I2(\DPHY_RX_INST/u_Aligner/wd/n1142_6 ),
	.I3(\DPHY_RX_INST/u_Aligner/wd/n1142_7 ),
	.F(\DPHY_RX_INST/u_Aligner/wd/n1141_3 )
);
defparam \DPHY_RX_INST/u_Aligner/wd/n1141_s0 .INIT=16'h4000;
LUT4 \DPHY_RX_INST/u_Aligner/wd/ready_d_s  (
	.I0(\DPHY_RX_INST/u_Aligner/wd/shftamt [6]),
	.I1(\DPHY_RX_INST/u_Aligner/wd/shftamt [7]),
	.I2(\DPHY_RX_INST/u_Aligner/wd/ready_d_3 ),
	.I3(\DPHY_RX_INST/u_Aligner/wd/ready_d_4 ),
	.F(ready)
);
defparam \DPHY_RX_INST/u_Aligner/wd/ready_d_s .INIT=16'hEFFF;
LUT2 \DPHY_RX_INST/u_Aligner/wd/n70_s1  (
	.I0(reset_n),
	.I1(hs_en),
	.F(\DPHY_RX_INST/u_Aligner/wd/n70_5 )
);
defparam \DPHY_RX_INST/u_Aligner/wd/n70_s1 .INIT=4'h7;
LUT4 \DPHY_RX_INST/u_Aligner/wd/n1142_s1  (
	.I0(\DPHY_RX_INST/u_Aligner/wd/reg1[0] [3]),
	.I1(\DPHY_RX_INST/u_Aligner/wd/reg1[0] [4]),
	.I2(\DPHY_RX_INST/u_Aligner/wd/reg1[0] [2]),
	.I3(\DPHY_RX_INST/u_Aligner/wd/n1142_8 ),
	.F(\DPHY_RX_INST/u_Aligner/wd/n1142_5 )
);
defparam \DPHY_RX_INST/u_Aligner/wd/n1142_s1 .INIT=16'h4000;
LUT4 \DPHY_RX_INST/u_Aligner/wd/n1142_s2  (
	.I0(\DPHY_RX_INST/u_Aligner/wd/n1142_9 ),
	.I1(\DPHY_RX_INST/u_Aligner/wd/n1142_10 ),
	.I2(\DPHY_RX_INST/u_Aligner/wd/n1142_11 ),
	.I3(\DPHY_RX_INST/u_Aligner/wd/n1142_12 ),
	.F(\DPHY_RX_INST/u_Aligner/wd/n1142_6 )
);
defparam \DPHY_RX_INST/u_Aligner/wd/n1142_s2 .INIT=16'h8000;
LUT4 \DPHY_RX_INST/u_Aligner/wd/n1142_s3  (
	.I0(\DPHY_RX_INST/u_Aligner/wd/n1142_13 ),
	.I1(\DPHY_RX_INST/u_Aligner/wd/n1142_14 ),
	.I2(\DPHY_RX_INST/u_Aligner/wd/n1142_15 ),
	.I3(\DPHY_RX_INST/u_Aligner/wd/n1142_16 ),
	.F(\DPHY_RX_INST/u_Aligner/wd/n1142_7 )
);
defparam \DPHY_RX_INST/u_Aligner/wd/n1142_s3 .INIT=16'h8000;
LUT4 \DPHY_RX_INST/u_Aligner/wd/n1143_s1  (
	.I0(\DPHY_RX_INST/u_Aligner/wd/n1143_5 ),
	.I1(\DPHY_RX_INST/u_Aligner/wd/reg1[0] [3]),
	.I2(\DPHY_RX_INST/u_Aligner/wd/reg1[0] [4]),
	.I3(\DPHY_RX_INST/u_Aligner/wd/reg1[0] [5]),
	.F(\DPHY_RX_INST/u_Aligner/wd/n1143_4 )
);
defparam \DPHY_RX_INST/u_Aligner/wd/n1143_s1 .INIT=16'h8000;
LUT4 \DPHY_RX_INST/u_Aligner/wd/n1144_s1  (
	.I0(\DPHY_RX_INST/u_Aligner/wd/reg1[0] [1]),
	.I1(\DPHY_RX_INST/u_Aligner/wd/reg1[0] [4]),
	.I2(\DPHY_RX_INST/u_Aligner/wd/reg1[0] [3]),
	.I3(\DPHY_RX_INST/u_Aligner/wd/n1144_5 ),
	.F(\DPHY_RX_INST/u_Aligner/wd/n1144_4 )
);
defparam \DPHY_RX_INST/u_Aligner/wd/n1144_s1 .INIT=16'h4000;
LUT4 \DPHY_RX_INST/u_Aligner/wd/n1145_s1  (
	.I0(\DPHY_RX_INST/u_Aligner/wd/n1145_5 ),
	.I1(\DPHY_RX_INST/u_Aligner/wd/reg1[0] [3]),
	.I2(\DPHY_RX_INST/u_Aligner/wd/reg1[0] [2]),
	.I3(\DPHY_RX_INST/u_Aligner/wd/reg1[0] [1]),
	.F(\DPHY_RX_INST/u_Aligner/wd/n1145_4 )
);
defparam \DPHY_RX_INST/u_Aligner/wd/n1145_s1 .INIT=16'h8000;
LUT4 \DPHY_RX_INST/u_Aligner/wd/n1146_s1  (
	.I0(\DPHY_RX_INST/u_Aligner/wd/reg0[0] [7]),
	.I1(\DPHY_RX_INST/u_Aligner/wd/reg1[0] [1]),
	.I2(\DPHY_RX_INST/u_Aligner/wd/reg0[0] [6]),
	.I3(\DPHY_RX_INST/u_Aligner/wd/n1144_5 ),
	.F(\DPHY_RX_INST/u_Aligner/wd/n1146_4 )
);
defparam \DPHY_RX_INST/u_Aligner/wd/n1146_s1 .INIT=16'h4000;
LUT4 \DPHY_RX_INST/u_Aligner/wd/n1147_s1  (
	.I0(\DPHY_RX_INST/u_Aligner/wd/reg0[0] [6]),
	.I1(\DPHY_RX_INST/u_Aligner/wd/reg1[0] [1]),
	.I2(\DPHY_RX_INST/u_Aligner/wd/reg0[0] [5]),
	.I3(\DPHY_RX_INST/u_Aligner/wd/n1147_5 ),
	.F(\DPHY_RX_INST/u_Aligner/wd/n1147_4 )
);
defparam \DPHY_RX_INST/u_Aligner/wd/n1147_s1 .INIT=16'h4000;
LUT4 \DPHY_RX_INST/u_Aligner/wd/n1148_s1  (
	.I0(\DPHY_RX_INST/u_Aligner/wd/reg0[0] [5]),
	.I1(\DPHY_RX_INST/u_Aligner/wd/reg0[0] [6]),
	.I2(\DPHY_RX_INST/u_Aligner/wd/reg0[0] [4]),
	.I3(\DPHY_RX_INST/u_Aligner/wd/n1147_5 ),
	.F(\DPHY_RX_INST/u_Aligner/wd/n1148_4 )
);
defparam \DPHY_RX_INST/u_Aligner/wd/n1148_s1 .INIT=16'h4000;
LUT4 \DPHY_RX_INST/u_Aligner/wd/n579_s1  (
	.I0(\DPHY_RX_INST/u_Aligner/wd/ready_d_4 ),
	.I1(\DPHY_RX_INST/u_Aligner/wd/n579_6 ),
	.I2(\DPHY_RX_INST/u_Aligner/wd/ready_d_3 ),
	.I3(\DPHY_RX_INST/u_Aligner/wd/n579_7 ),
	.F(\DPHY_RX_INST/u_Aligner/wd/n579_4 )
);
defparam \DPHY_RX_INST/u_Aligner/wd/n579_s1 .INIT=16'h7000;
LUT4 \DPHY_RX_INST/u_Aligner/wd/n579_s2  (
	.I0(\DPHY_RX_INST/u_Aligner/wd/reg4[0] [1]),
	.I1(\DPHY_RX_INST/u_Aligner/wd/n579_8 ),
	.I2(\DPHY_RX_INST/u_Aligner/wd/shftamt [0]),
	.I3(\DPHY_RX_INST/u_Aligner/wd/shftamt [1]),
	.F(\DPHY_RX_INST/u_Aligner/wd/n579_5 )
);
defparam \DPHY_RX_INST/u_Aligner/wd/n579_s2 .INIT=16'h0A03;
LUT4 \DPHY_RX_INST/u_Aligner/wd/n580_s1  (
	.I0(\DPHY_RX_INST/u_Aligner/wd/n580_7 ),
	.I1(\DPHY_RX_INST/u_Aligner/wd/n580_8 ),
	.I2(\DPHY_RX_INST/u_Aligner/wd/shftamt [3]),
	.I3(\DPHY_RX_INST/u_Aligner/wd/n580_9 ),
	.F(\DPHY_RX_INST/u_Aligner/wd/n580_4 )
);
defparam \DPHY_RX_INST/u_Aligner/wd/n580_s1 .INIT=16'h0D00;
LUT4 \DPHY_RX_INST/u_Aligner/wd/n580_s2  (
	.I0(\DPHY_RX_INST/u_Aligner/wd/shftamt [3]),
	.I1(\DPHY_RX_INST/u_Aligner/wd/reg3[0] [6]),
	.I2(\DPHY_RX_INST/u_Aligner/wd/shftamt [1]),
	.I3(\DPHY_RX_INST/u_Aligner/wd/shftamt [0]),
	.F(\DPHY_RX_INST/u_Aligner/wd/n580_5 )
);
defparam \DPHY_RX_INST/u_Aligner/wd/n580_s2 .INIT=16'h0007;
LUT3 \DPHY_RX_INST/u_Aligner/wd/n580_s3  (
	.I0(\DPHY_RX_INST/u_Aligner/wd/reg4[0] [1]),
	.I1(\DPHY_RX_INST/u_Aligner/wd/n580_10 ),
	.I2(\DPHY_RX_INST/u_Aligner/wd/shftamt [0]),
	.F(\DPHY_RX_INST/u_Aligner/wd/n580_6 )
);
defparam \DPHY_RX_INST/u_Aligner/wd/n580_s3 .INIT=8'hAC;
LUT4 \DPHY_RX_INST/u_Aligner/wd/n581_s1  (
	.I0(\DPHY_RX_INST/u_Aligner/wd/n581_7 ),
	.I1(\DPHY_RX_INST/u_Aligner/wd/n581_8 ),
	.I2(\DPHY_RX_INST/u_Aligner/wd/shftamt [3]),
	.I3(\DPHY_RX_INST/u_Aligner/wd/n581_9 ),
	.F(\DPHY_RX_INST/u_Aligner/wd/n581_4 )
);
defparam \DPHY_RX_INST/u_Aligner/wd/n581_s1 .INIT=16'h0D00;
LUT4 \DPHY_RX_INST/u_Aligner/wd/n581_s2  (
	.I0(\DPHY_RX_INST/u_Aligner/wd/shftamt [3]),
	.I1(\DPHY_RX_INST/u_Aligner/wd/reg3[0] [5]),
	.I2(\DPHY_RX_INST/u_Aligner/wd/shftamt [1]),
	.I3(\DPHY_RX_INST/u_Aligner/wd/shftamt [0]),
	.F(\DPHY_RX_INST/u_Aligner/wd/n581_5 )
);
defparam \DPHY_RX_INST/u_Aligner/wd/n581_s2 .INIT=16'h0007;
LUT3 \DPHY_RX_INST/u_Aligner/wd/n581_s3  (
	.I0(\DPHY_RX_INST/u_Aligner/wd/reg4[0] [0]),
	.I1(\DPHY_RX_INST/u_Aligner/wd/n581_10 ),
	.I2(\DPHY_RX_INST/u_Aligner/wd/shftamt [0]),
	.F(\DPHY_RX_INST/u_Aligner/wd/n581_6 )
);
defparam \DPHY_RX_INST/u_Aligner/wd/n581_s3 .INIT=8'hAC;
LUT4 \DPHY_RX_INST/u_Aligner/wd/n582_s1  (
	.I0(\DPHY_RX_INST/u_Aligner/wd/ready_d_4 ),
	.I1(\DPHY_RX_INST/u_Aligner/wd/n582_6 ),
	.I2(\DPHY_RX_INST/u_Aligner/wd/ready_d_3 ),
	.I3(\DPHY_RX_INST/u_Aligner/wd/n582_7 ),
	.F(\DPHY_RX_INST/u_Aligner/wd/n582_4 )
);
defparam \DPHY_RX_INST/u_Aligner/wd/n582_s1 .INIT=16'h7000;
LUT4 \DPHY_RX_INST/u_Aligner/wd/n582_s2  (
	.I0(\DPHY_RX_INST/u_Aligner/wd/reg3[0] [6]),
	.I1(\DPHY_RX_INST/u_Aligner/wd/n582_8 ),
	.I2(\DPHY_RX_INST/u_Aligner/wd/shftamt [0]),
	.I3(\DPHY_RX_INST/u_Aligner/wd/shftamt [1]),
	.F(\DPHY_RX_INST/u_Aligner/wd/n582_5 )
);
defparam \DPHY_RX_INST/u_Aligner/wd/n582_s2 .INIT=16'h0A03;
LUT4 \DPHY_RX_INST/u_Aligner/wd/n583_s1  (
	.I0(\DPHY_RX_INST/u_Aligner/wd/ready_d_4 ),
	.I1(\DPHY_RX_INST/u_Aligner/wd/n583_6 ),
	.I2(\DPHY_RX_INST/u_Aligner/wd/ready_d_3 ),
	.I3(\DPHY_RX_INST/u_Aligner/wd/n583_7 ),
	.F(\DPHY_RX_INST/u_Aligner/wd/n583_4 )
);
defparam \DPHY_RX_INST/u_Aligner/wd/n583_s1 .INIT=16'h7000;
LUT4 \DPHY_RX_INST/u_Aligner/wd/n583_s2  (
	.I0(\DPHY_RX_INST/u_Aligner/wd/reg3[0] [5]),
	.I1(\DPHY_RX_INST/u_Aligner/wd/n583_8 ),
	.I2(\DPHY_RX_INST/u_Aligner/wd/shftamt [0]),
	.I3(\DPHY_RX_INST/u_Aligner/wd/shftamt [1]),
	.F(\DPHY_RX_INST/u_Aligner/wd/n583_5 )
);
defparam \DPHY_RX_INST/u_Aligner/wd/n583_s2 .INIT=16'h0A03;
LUT4 \DPHY_RX_INST/u_Aligner/wd/n584_s1  (
	.I0(\DPHY_RX_INST/u_Aligner/wd/ready_d_4 ),
	.I1(\DPHY_RX_INST/u_Aligner/wd/n584_6 ),
	.I2(\DPHY_RX_INST/u_Aligner/wd/ready_d_3 ),
	.I3(\DPHY_RX_INST/u_Aligner/wd/n584_7 ),
	.F(\DPHY_RX_INST/u_Aligner/wd/n584_4 )
);
defparam \DPHY_RX_INST/u_Aligner/wd/n584_s1 .INIT=16'h7000;
LUT4 \DPHY_RX_INST/u_Aligner/wd/n584_s2  (
	.I0(\DPHY_RX_INST/u_Aligner/wd/reg3[0] [4]),
	.I1(\DPHY_RX_INST/u_Aligner/wd/n584_8 ),
	.I2(\DPHY_RX_INST/u_Aligner/wd/shftamt [0]),
	.I3(\DPHY_RX_INST/u_Aligner/wd/shftamt [1]),
	.F(\DPHY_RX_INST/u_Aligner/wd/n584_5 )
);
defparam \DPHY_RX_INST/u_Aligner/wd/n584_s2 .INIT=16'h0A03;
LUT4 \DPHY_RX_INST/u_Aligner/wd/n585_s1  (
	.I0(\DPHY_RX_INST/u_Aligner/wd/ready_d_4 ),
	.I1(\DPHY_RX_INST/u_Aligner/wd/n585_6 ),
	.I2(\DPHY_RX_INST/u_Aligner/wd/ready_d_3 ),
	.I3(\DPHY_RX_INST/u_Aligner/wd/n585_7 ),
	.F(\DPHY_RX_INST/u_Aligner/wd/n585_4 )
);
defparam \DPHY_RX_INST/u_Aligner/wd/n585_s1 .INIT=16'h7000;
LUT4 \DPHY_RX_INST/u_Aligner/wd/n585_s2  (
	.I0(\DPHY_RX_INST/u_Aligner/wd/reg3[0] [3]),
	.I1(\DPHY_RX_INST/u_Aligner/wd/n585_8 ),
	.I2(\DPHY_RX_INST/u_Aligner/wd/shftamt [0]),
	.I3(\DPHY_RX_INST/u_Aligner/wd/shftamt [1]),
	.F(\DPHY_RX_INST/u_Aligner/wd/n585_5 )
);
defparam \DPHY_RX_INST/u_Aligner/wd/n585_s2 .INIT=16'h0A03;
LUT4 \DPHY_RX_INST/u_Aligner/wd/n586_s1  (
	.I0(\DPHY_RX_INST/u_Aligner/wd/n586_7 ),
	.I1(\DPHY_RX_INST/u_Aligner/wd/n586_8 ),
	.I2(\DPHY_RX_INST/u_Aligner/wd/shftamt [3]),
	.I3(\DPHY_RX_INST/u_Aligner/wd/n586_9 ),
	.F(\DPHY_RX_INST/u_Aligner/wd/n586_4 )
);
defparam \DPHY_RX_INST/u_Aligner/wd/n586_s1 .INIT=16'h0D00;
LUT4 \DPHY_RX_INST/u_Aligner/wd/n586_s2  (
	.I0(\DPHY_RX_INST/u_Aligner/wd/shftamt [3]),
	.I1(\DPHY_RX_INST/u_Aligner/wd/reg3[0] [0]),
	.I2(\DPHY_RX_INST/u_Aligner/wd/shftamt [1]),
	.I3(\DPHY_RX_INST/u_Aligner/wd/shftamt [0]),
	.F(\DPHY_RX_INST/u_Aligner/wd/n586_5 )
);
defparam \DPHY_RX_INST/u_Aligner/wd/n586_s2 .INIT=16'h0007;
LUT3 \DPHY_RX_INST/u_Aligner/wd/n586_s3  (
	.I0(\DPHY_RX_INST/u_Aligner/wd/reg3[0] [3]),
	.I1(\DPHY_RX_INST/u_Aligner/wd/n586_10 ),
	.I2(\DPHY_RX_INST/u_Aligner/wd/shftamt [0]),
	.F(\DPHY_RX_INST/u_Aligner/wd/n586_6 )
);
defparam \DPHY_RX_INST/u_Aligner/wd/n586_s3 .INIT=8'hAC;
LUT4 \DPHY_RX_INST/u_Aligner/wd/n1141_s1  (
	.I0(\DPHY_RX_INST/u_Aligner/wd/reg1[0] [4]),
	.I1(\DPHY_RX_INST/u_Aligner/wd/reg1[0] [3]),
	.I2(\DPHY_RX_INST/u_Aligner/wd/reg1[0] [7]),
	.I3(\DPHY_RX_INST/u_Aligner/wd/n1142_8 ),
	.F(\DPHY_RX_INST/u_Aligner/wd/n1141_4 )
);
defparam \DPHY_RX_INST/u_Aligner/wd/n1141_s1 .INIT=16'h4000;
LUT4 \DPHY_RX_INST/u_Aligner/wd/ready_d_s0  (
	.I0(\DPHY_RX_INST/u_Aligner/wd/shftamt [3]),
	.I1(\DPHY_RX_INST/u_Aligner/wd/shftamt [2]),
	.I2(\DPHY_RX_INST/u_Aligner/wd/shftamt [1]),
	.I3(\DPHY_RX_INST/u_Aligner/wd/shftamt [0]),
	.F(\DPHY_RX_INST/u_Aligner/wd/ready_d_3 )
);
defparam \DPHY_RX_INST/u_Aligner/wd/ready_d_s0 .INIT=16'h0001;
LUT2 \DPHY_RX_INST/u_Aligner/wd/ready_d_s1  (
	.I0(\DPHY_RX_INST/u_Aligner/wd/shftamt [5]),
	.I1(\DPHY_RX_INST/u_Aligner/wd/shftamt [4]),
	.F(\DPHY_RX_INST/u_Aligner/wd/ready_d_4 )
);
defparam \DPHY_RX_INST/u_Aligner/wd/ready_d_s1 .INIT=4'h1;
LUT2 \DPHY_RX_INST/u_Aligner/wd/n1142_s4  (
	.I0(\DPHY_RX_INST/u_Aligner/wd/reg1[0] [5]),
	.I1(\DPHY_RX_INST/u_Aligner/wd/reg1[0] [6]),
	.F(\DPHY_RX_INST/u_Aligner/wd/n1142_8 )
);
defparam \DPHY_RX_INST/u_Aligner/wd/n1142_s4 .INIT=4'h8;
LUT4 \DPHY_RX_INST/u_Aligner/wd/n1142_s5  (
	.I0(\DPHY_RX_INST/u_Aligner/wd/reg5[0] [4]),
	.I1(\DPHY_RX_INST/u_Aligner/wd/reg5[0] [5]),
	.I2(\DPHY_RX_INST/u_Aligner/wd/reg5[0] [6]),
	.I3(\DPHY_RX_INST/u_Aligner/wd/reg5[0] [7]),
	.F(\DPHY_RX_INST/u_Aligner/wd/n1142_9 )
);
defparam \DPHY_RX_INST/u_Aligner/wd/n1142_s5 .INIT=16'h0001;
LUT4 \DPHY_RX_INST/u_Aligner/wd/n1142_s6  (
	.I0(\DPHY_RX_INST/u_Aligner/wd/reg4[0] [4]),
	.I1(\DPHY_RX_INST/u_Aligner/wd/reg4[0] [5]),
	.I2(\DPHY_RX_INST/u_Aligner/wd/reg4[0] [6]),
	.I3(\DPHY_RX_INST/u_Aligner/wd/reg4[0] [7]),
	.F(\DPHY_RX_INST/u_Aligner/wd/n1142_10 )
);
defparam \DPHY_RX_INST/u_Aligner/wd/n1142_s6 .INIT=16'h0001;
LUT4 \DPHY_RX_INST/u_Aligner/wd/n1142_s7  (
	.I0(\DPHY_RX_INST/u_Aligner/wd/reg4[0] [0]),
	.I1(\DPHY_RX_INST/u_Aligner/wd/reg4[0] [1]),
	.I2(\DPHY_RX_INST/u_Aligner/wd/reg4[0] [2]),
	.I3(\DPHY_RX_INST/u_Aligner/wd/reg4[0] [3]),
	.F(\DPHY_RX_INST/u_Aligner/wd/n1142_11 )
);
defparam \DPHY_RX_INST/u_Aligner/wd/n1142_s7 .INIT=16'h0001;
LUT4 \DPHY_RX_INST/u_Aligner/wd/n1142_s8  (
	.I0(\DPHY_RX_INST/u_Aligner/wd/reg5[0] [0]),
	.I1(\DPHY_RX_INST/u_Aligner/wd/reg5[0] [1]),
	.I2(\DPHY_RX_INST/u_Aligner/wd/reg5[0] [2]),
	.I3(\DPHY_RX_INST/u_Aligner/wd/reg5[0] [3]),
	.F(\DPHY_RX_INST/u_Aligner/wd/n1142_12 )
);
defparam \DPHY_RX_INST/u_Aligner/wd/n1142_s8 .INIT=16'h0001;
LUT4 \DPHY_RX_INST/u_Aligner/wd/n1142_s9  (
	.I0(\DPHY_RX_INST/u_Aligner/wd/reg3[0] [4]),
	.I1(\DPHY_RX_INST/u_Aligner/wd/reg3[0] [5]),
	.I2(\DPHY_RX_INST/u_Aligner/wd/reg3[0] [6]),
	.I3(\DPHY_RX_INST/u_Aligner/wd/reg3[0] [7]),
	.F(\DPHY_RX_INST/u_Aligner/wd/n1142_13 )
);
defparam \DPHY_RX_INST/u_Aligner/wd/n1142_s9 .INIT=16'h0001;
LUT4 \DPHY_RX_INST/u_Aligner/wd/n1142_s10  (
	.I0(\DPHY_RX_INST/u_Aligner/wd/reg2[0] [4]),
	.I1(\DPHY_RX_INST/u_Aligner/wd/reg2[0] [5]),
	.I2(\DPHY_RX_INST/u_Aligner/wd/reg2[0] [6]),
	.I3(\DPHY_RX_INST/u_Aligner/wd/reg2[0] [7]),
	.F(\DPHY_RX_INST/u_Aligner/wd/n1142_14 )
);
defparam \DPHY_RX_INST/u_Aligner/wd/n1142_s10 .INIT=16'h0001;
LUT4 \DPHY_RX_INST/u_Aligner/wd/n1142_s11  (
	.I0(\DPHY_RX_INST/u_Aligner/wd/reg2[0] [0]),
	.I1(\DPHY_RX_INST/u_Aligner/wd/reg2[0] [1]),
	.I2(\DPHY_RX_INST/u_Aligner/wd/reg2[0] [2]),
	.I3(\DPHY_RX_INST/u_Aligner/wd/reg2[0] [3]),
	.F(\DPHY_RX_INST/u_Aligner/wd/n1142_15 )
);
defparam \DPHY_RX_INST/u_Aligner/wd/n1142_s11 .INIT=16'h0001;
LUT4 \DPHY_RX_INST/u_Aligner/wd/n1142_s12  (
	.I0(\DPHY_RX_INST/u_Aligner/wd/reg3[0] [0]),
	.I1(\DPHY_RX_INST/u_Aligner/wd/reg3[0] [1]),
	.I2(\DPHY_RX_INST/u_Aligner/wd/reg3[0] [2]),
	.I3(\DPHY_RX_INST/u_Aligner/wd/reg3[0] [3]),
	.F(\DPHY_RX_INST/u_Aligner/wd/n1142_16 )
);
defparam \DPHY_RX_INST/u_Aligner/wd/n1142_s12 .INIT=16'h0001;
LUT2 \DPHY_RX_INST/u_Aligner/wd/n1143_s2  (
	.I0(\DPHY_RX_INST/u_Aligner/wd/reg1[0] [2]),
	.I1(\DPHY_RX_INST/u_Aligner/wd/reg1[0] [1]),
	.F(\DPHY_RX_INST/u_Aligner/wd/n1143_5 )
);
defparam \DPHY_RX_INST/u_Aligner/wd/n1143_s2 .INIT=4'h4;
LUT2 \DPHY_RX_INST/u_Aligner/wd/n1144_s2  (
	.I0(\DPHY_RX_INST/u_Aligner/wd/reg1[0] [2]),
	.I1(\DPHY_RX_INST/u_Aligner/wd/reg1[0] [0]),
	.F(\DPHY_RX_INST/u_Aligner/wd/n1144_5 )
);
defparam \DPHY_RX_INST/u_Aligner/wd/n1144_s2 .INIT=4'h8;
LUT2 \DPHY_RX_INST/u_Aligner/wd/n1145_s2  (
	.I0(\DPHY_RX_INST/u_Aligner/wd/reg1[0] [0]),
	.I1(\DPHY_RX_INST/u_Aligner/wd/reg0[0] [7]),
	.F(\DPHY_RX_INST/u_Aligner/wd/n1145_5 )
);
defparam \DPHY_RX_INST/u_Aligner/wd/n1145_s2 .INIT=4'h4;
LUT2 \DPHY_RX_INST/u_Aligner/wd/n1147_s2  (
	.I0(\DPHY_RX_INST/u_Aligner/wd/reg1[0] [0]),
	.I1(\DPHY_RX_INST/u_Aligner/wd/reg0[0] [7]),
	.F(\DPHY_RX_INST/u_Aligner/wd/n1147_5 )
);
defparam \DPHY_RX_INST/u_Aligner/wd/n1147_s2 .INIT=4'h8;
LUT4 \DPHY_RX_INST/u_Aligner/wd/n579_s3  (
	.I0(\DPHY_RX_INST/u_Aligner/wd/reg3[0] [3]),
	.I1(\DPHY_RX_INST/u_Aligner/wd/shftamt [7]),
	.I2(\DPHY_RX_INST/u_Aligner/wd/reg3[0] [4]),
	.I3(\DPHY_RX_INST/u_Aligner/wd/shftamt [6]),
	.F(\DPHY_RX_INST/u_Aligner/wd/n579_6 )
);
defparam \DPHY_RX_INST/u_Aligner/wd/n579_s3 .INIT=16'h0F77;
LUT4 \DPHY_RX_INST/u_Aligner/wd/n579_s4  (
	.I0(\DPHY_RX_INST/u_Aligner/wd/reg3[0] [5]),
	.I1(\DPHY_RX_INST/u_Aligner/wd/shftamt [5]),
	.I2(\DPHY_RX_INST/u_Aligner/wd/reg3[0] [6]),
	.I3(\DPHY_RX_INST/u_Aligner/wd/shftamt [4]),
	.F(\DPHY_RX_INST/u_Aligner/wd/n579_7 )
);
defparam \DPHY_RX_INST/u_Aligner/wd/n579_s4 .INIT=16'hF0BB;
LUT4 \DPHY_RX_INST/u_Aligner/wd/n579_s5  (
	.I0(\DPHY_RX_INST/u_Aligner/wd/reg3[0] [7]),
	.I1(\DPHY_RX_INST/u_Aligner/wd/shftamt [3]),
	.I2(\DPHY_RX_INST/u_Aligner/wd/reg4[0] [0]),
	.I3(\DPHY_RX_INST/u_Aligner/wd/shftamt [2]),
	.F(\DPHY_RX_INST/u_Aligner/wd/n579_8 )
);
defparam \DPHY_RX_INST/u_Aligner/wd/n579_s5 .INIT=16'h0F77;
LUT4 \DPHY_RX_INST/u_Aligner/wd/n580_s4  (
	.I0(\DPHY_RX_INST/u_Aligner/wd/shftamt [6]),
	.I1(\DPHY_RX_INST/u_Aligner/wd/reg3[0] [3]),
	.I2(\DPHY_RX_INST/u_Aligner/wd/shftamt [5]),
	.I3(\DPHY_RX_INST/u_Aligner/wd/shftamt [4]),
	.F(\DPHY_RX_INST/u_Aligner/wd/n580_7 )
);
defparam \DPHY_RX_INST/u_Aligner/wd/n580_s4 .INIT=16'h0007;
LUT3 \DPHY_RX_INST/u_Aligner/wd/n580_s5  (
	.I0(\DPHY_RX_INST/u_Aligner/wd/shftamt [6]),
	.I1(\DPHY_RX_INST/u_Aligner/wd/reg3[0] [2]),
	.I2(\DPHY_RX_INST/u_Aligner/wd/shftamt [7]),
	.F(\DPHY_RX_INST/u_Aligner/wd/n580_8 )
);
defparam \DPHY_RX_INST/u_Aligner/wd/n580_s5 .INIT=8'h40;
LUT4 \DPHY_RX_INST/u_Aligner/wd/n580_s6  (
	.I0(\DPHY_RX_INST/u_Aligner/wd/reg3[0] [4]),
	.I1(\DPHY_RX_INST/u_Aligner/wd/shftamt [5]),
	.I2(\DPHY_RX_INST/u_Aligner/wd/reg3[0] [5]),
	.I3(\DPHY_RX_INST/u_Aligner/wd/shftamt [4]),
	.F(\DPHY_RX_INST/u_Aligner/wd/n580_9 )
);
defparam \DPHY_RX_INST/u_Aligner/wd/n580_s6 .INIT=16'hF0BB;
LUT4 \DPHY_RX_INST/u_Aligner/wd/n580_s7  (
	.I0(\DPHY_RX_INST/u_Aligner/wd/reg3[0] [7]),
	.I1(\DPHY_RX_INST/u_Aligner/wd/shftamt [2]),
	.I2(\DPHY_RX_INST/u_Aligner/wd/reg4[0] [0]),
	.I3(\DPHY_RX_INST/u_Aligner/wd/shftamt [1]),
	.F(\DPHY_RX_INST/u_Aligner/wd/n580_10 )
);
defparam \DPHY_RX_INST/u_Aligner/wd/n580_s7 .INIT=16'hF0BB;
LUT4 \DPHY_RX_INST/u_Aligner/wd/n581_s4  (
	.I0(\DPHY_RX_INST/u_Aligner/wd/shftamt [6]),
	.I1(\DPHY_RX_INST/u_Aligner/wd/reg3[0] [2]),
	.I2(\DPHY_RX_INST/u_Aligner/wd/shftamt [5]),
	.I3(\DPHY_RX_INST/u_Aligner/wd/shftamt [4]),
	.F(\DPHY_RX_INST/u_Aligner/wd/n581_7 )
);
defparam \DPHY_RX_INST/u_Aligner/wd/n581_s4 .INIT=16'h0007;
LUT3 \DPHY_RX_INST/u_Aligner/wd/n581_s5  (
	.I0(\DPHY_RX_INST/u_Aligner/wd/shftamt [6]),
	.I1(\DPHY_RX_INST/u_Aligner/wd/reg3[0] [1]),
	.I2(\DPHY_RX_INST/u_Aligner/wd/shftamt [7]),
	.F(\DPHY_RX_INST/u_Aligner/wd/n581_8 )
);
defparam \DPHY_RX_INST/u_Aligner/wd/n581_s5 .INIT=8'h40;
LUT4 \DPHY_RX_INST/u_Aligner/wd/n581_s6  (
	.I0(\DPHY_RX_INST/u_Aligner/wd/reg3[0] [3]),
	.I1(\DPHY_RX_INST/u_Aligner/wd/shftamt [5]),
	.I2(\DPHY_RX_INST/u_Aligner/wd/reg3[0] [4]),
	.I3(\DPHY_RX_INST/u_Aligner/wd/shftamt [4]),
	.F(\DPHY_RX_INST/u_Aligner/wd/n581_9 )
);
defparam \DPHY_RX_INST/u_Aligner/wd/n581_s6 .INIT=16'hF0BB;
LUT4 \DPHY_RX_INST/u_Aligner/wd/n581_s7  (
	.I0(\DPHY_RX_INST/u_Aligner/wd/reg3[0] [6]),
	.I1(\DPHY_RX_INST/u_Aligner/wd/shftamt [2]),
	.I2(\DPHY_RX_INST/u_Aligner/wd/reg3[0] [7]),
	.I3(\DPHY_RX_INST/u_Aligner/wd/shftamt [1]),
	.F(\DPHY_RX_INST/u_Aligner/wd/n581_10 )
);
defparam \DPHY_RX_INST/u_Aligner/wd/n581_s7 .INIT=16'hF0BB;
LUT4 \DPHY_RX_INST/u_Aligner/wd/n582_s3  (
	.I0(\DPHY_RX_INST/u_Aligner/wd/reg3[0] [0]),
	.I1(\DPHY_RX_INST/u_Aligner/wd/shftamt [7]),
	.I2(\DPHY_RX_INST/u_Aligner/wd/reg3[0] [1]),
	.I3(\DPHY_RX_INST/u_Aligner/wd/shftamt [6]),
	.F(\DPHY_RX_INST/u_Aligner/wd/n582_6 )
);
defparam \DPHY_RX_INST/u_Aligner/wd/n582_s3 .INIT=16'h0F77;
LUT4 \DPHY_RX_INST/u_Aligner/wd/n582_s4  (
	.I0(\DPHY_RX_INST/u_Aligner/wd/reg3[0] [2]),
	.I1(\DPHY_RX_INST/u_Aligner/wd/shftamt [5]),
	.I2(\DPHY_RX_INST/u_Aligner/wd/reg3[0] [3]),
	.I3(\DPHY_RX_INST/u_Aligner/wd/shftamt [4]),
	.F(\DPHY_RX_INST/u_Aligner/wd/n582_7 )
);
defparam \DPHY_RX_INST/u_Aligner/wd/n582_s4 .INIT=16'hF0BB;
LUT4 \DPHY_RX_INST/u_Aligner/wd/n582_s5  (
	.I0(\DPHY_RX_INST/u_Aligner/wd/reg3[0] [4]),
	.I1(\DPHY_RX_INST/u_Aligner/wd/shftamt [3]),
	.I2(\DPHY_RX_INST/u_Aligner/wd/reg3[0] [5]),
	.I3(\DPHY_RX_INST/u_Aligner/wd/shftamt [2]),
	.F(\DPHY_RX_INST/u_Aligner/wd/n582_8 )
);
defparam \DPHY_RX_INST/u_Aligner/wd/n582_s5 .INIT=16'h0F77;
LUT4 \DPHY_RX_INST/u_Aligner/wd/n583_s3  (
	.I0(\DPHY_RX_INST/u_Aligner/wd/reg2[0] [7]),
	.I1(\DPHY_RX_INST/u_Aligner/wd/shftamt [7]),
	.I2(\DPHY_RX_INST/u_Aligner/wd/reg3[0] [0]),
	.I3(\DPHY_RX_INST/u_Aligner/wd/shftamt [6]),
	.F(\DPHY_RX_INST/u_Aligner/wd/n583_6 )
);
defparam \DPHY_RX_INST/u_Aligner/wd/n583_s3 .INIT=16'h0F77;
LUT4 \DPHY_RX_INST/u_Aligner/wd/n583_s4  (
	.I0(\DPHY_RX_INST/u_Aligner/wd/reg3[0] [1]),
	.I1(\DPHY_RX_INST/u_Aligner/wd/shftamt [5]),
	.I2(\DPHY_RX_INST/u_Aligner/wd/reg3[0] [2]),
	.I3(\DPHY_RX_INST/u_Aligner/wd/shftamt [4]),
	.F(\DPHY_RX_INST/u_Aligner/wd/n583_7 )
);
defparam \DPHY_RX_INST/u_Aligner/wd/n583_s4 .INIT=16'hF0BB;
LUT4 \DPHY_RX_INST/u_Aligner/wd/n583_s5  (
	.I0(\DPHY_RX_INST/u_Aligner/wd/reg3[0] [3]),
	.I1(\DPHY_RX_INST/u_Aligner/wd/shftamt [3]),
	.I2(\DPHY_RX_INST/u_Aligner/wd/reg3[0] [4]),
	.I3(\DPHY_RX_INST/u_Aligner/wd/shftamt [2]),
	.F(\DPHY_RX_INST/u_Aligner/wd/n583_8 )
);
defparam \DPHY_RX_INST/u_Aligner/wd/n583_s5 .INIT=16'h0F77;
LUT4 \DPHY_RX_INST/u_Aligner/wd/n584_s3  (
	.I0(\DPHY_RX_INST/u_Aligner/wd/reg2[0] [6]),
	.I1(\DPHY_RX_INST/u_Aligner/wd/shftamt [7]),
	.I2(\DPHY_RX_INST/u_Aligner/wd/reg2[0] [7]),
	.I3(\DPHY_RX_INST/u_Aligner/wd/shftamt [6]),
	.F(\DPHY_RX_INST/u_Aligner/wd/n584_6 )
);
defparam \DPHY_RX_INST/u_Aligner/wd/n584_s3 .INIT=16'h0F77;
LUT4 \DPHY_RX_INST/u_Aligner/wd/n584_s4  (
	.I0(\DPHY_RX_INST/u_Aligner/wd/reg3[0] [0]),
	.I1(\DPHY_RX_INST/u_Aligner/wd/shftamt [5]),
	.I2(\DPHY_RX_INST/u_Aligner/wd/reg3[0] [1]),
	.I3(\DPHY_RX_INST/u_Aligner/wd/shftamt [4]),
	.F(\DPHY_RX_INST/u_Aligner/wd/n584_7 )
);
defparam \DPHY_RX_INST/u_Aligner/wd/n584_s4 .INIT=16'hF0BB;
LUT4 \DPHY_RX_INST/u_Aligner/wd/n584_s5  (
	.I0(\DPHY_RX_INST/u_Aligner/wd/reg3[0] [2]),
	.I1(\DPHY_RX_INST/u_Aligner/wd/shftamt [3]),
	.I2(\DPHY_RX_INST/u_Aligner/wd/reg3[0] [3]),
	.I3(\DPHY_RX_INST/u_Aligner/wd/shftamt [2]),
	.F(\DPHY_RX_INST/u_Aligner/wd/n584_8 )
);
defparam \DPHY_RX_INST/u_Aligner/wd/n584_s5 .INIT=16'h0F77;
LUT4 \DPHY_RX_INST/u_Aligner/wd/n585_s3  (
	.I0(\DPHY_RX_INST/u_Aligner/wd/reg2[0] [5]),
	.I1(\DPHY_RX_INST/u_Aligner/wd/shftamt [7]),
	.I2(\DPHY_RX_INST/u_Aligner/wd/reg2[0] [6]),
	.I3(\DPHY_RX_INST/u_Aligner/wd/shftamt [6]),
	.F(\DPHY_RX_INST/u_Aligner/wd/n585_6 )
);
defparam \DPHY_RX_INST/u_Aligner/wd/n585_s3 .INIT=16'h0F77;
LUT4 \DPHY_RX_INST/u_Aligner/wd/n585_s4  (
	.I0(\DPHY_RX_INST/u_Aligner/wd/reg2[0] [7]),
	.I1(\DPHY_RX_INST/u_Aligner/wd/shftamt [5]),
	.I2(\DPHY_RX_INST/u_Aligner/wd/reg3[0] [0]),
	.I3(\DPHY_RX_INST/u_Aligner/wd/shftamt [4]),
	.F(\DPHY_RX_INST/u_Aligner/wd/n585_7 )
);
defparam \DPHY_RX_INST/u_Aligner/wd/n585_s4 .INIT=16'hF0BB;
LUT4 \DPHY_RX_INST/u_Aligner/wd/n585_s5  (
	.I0(\DPHY_RX_INST/u_Aligner/wd/reg3[0] [1]),
	.I1(\DPHY_RX_INST/u_Aligner/wd/shftamt [3]),
	.I2(\DPHY_RX_INST/u_Aligner/wd/reg3[0] [2]),
	.I3(\DPHY_RX_INST/u_Aligner/wd/shftamt [2]),
	.F(\DPHY_RX_INST/u_Aligner/wd/n585_8 )
);
defparam \DPHY_RX_INST/u_Aligner/wd/n585_s5 .INIT=16'h0F77;
LUT4 \DPHY_RX_INST/u_Aligner/wd/n586_s4  (
	.I0(\DPHY_RX_INST/u_Aligner/wd/shftamt [6]),
	.I1(\DPHY_RX_INST/u_Aligner/wd/reg2[0] [5]),
	.I2(\DPHY_RX_INST/u_Aligner/wd/shftamt [5]),
	.I3(\DPHY_RX_INST/u_Aligner/wd/shftamt [4]),
	.F(\DPHY_RX_INST/u_Aligner/wd/n586_7 )
);
defparam \DPHY_RX_INST/u_Aligner/wd/n586_s4 .INIT=16'h0007;
LUT3 \DPHY_RX_INST/u_Aligner/wd/n586_s5  (
	.I0(\DPHY_RX_INST/u_Aligner/wd/shftamt [6]),
	.I1(\DPHY_RX_INST/u_Aligner/wd/reg2[0] [4]),
	.I2(\DPHY_RX_INST/u_Aligner/wd/shftamt [7]),
	.F(\DPHY_RX_INST/u_Aligner/wd/n586_8 )
);
defparam \DPHY_RX_INST/u_Aligner/wd/n586_s5 .INIT=8'h40;
LUT4 \DPHY_RX_INST/u_Aligner/wd/n586_s6  (
	.I0(\DPHY_RX_INST/u_Aligner/wd/reg2[0] [6]),
	.I1(\DPHY_RX_INST/u_Aligner/wd/shftamt [5]),
	.I2(\DPHY_RX_INST/u_Aligner/wd/reg2[0] [7]),
	.I3(\DPHY_RX_INST/u_Aligner/wd/shftamt [4]),
	.F(\DPHY_RX_INST/u_Aligner/wd/n586_9 )
);
defparam \DPHY_RX_INST/u_Aligner/wd/n586_s6 .INIT=16'hF0BB;
LUT4 \DPHY_RX_INST/u_Aligner/wd/n586_s7  (
	.I0(\DPHY_RX_INST/u_Aligner/wd/reg3[0] [1]),
	.I1(\DPHY_RX_INST/u_Aligner/wd/shftamt [2]),
	.I2(\DPHY_RX_INST/u_Aligner/wd/reg3[0] [2]),
	.I3(\DPHY_RX_INST/u_Aligner/wd/shftamt [1]),
	.F(\DPHY_RX_INST/u_Aligner/wd/n586_10 )
);
defparam \DPHY_RX_INST/u_Aligner/wd/n586_s7 .INIT=16'hF0BB;
DFFCE \DPHY_RX_INST/u_Aligner/wd/reg0[0]_6_s0  (
	.D(\DPHY_RX_INST/data0 [1]),
	.CLK(clk_byte_out),
	.CE(VCC),
	.CLEAR(\DPHY_RX_INST/u_Aligner/wd/n70_5 ),
	.Q(\DPHY_RX_INST/u_Aligner/wd/reg0[0] [6])
);
defparam \DPHY_RX_INST/u_Aligner/wd/reg0[0]_6_s0 .INIT=1'b0;
DFFCE \DPHY_RX_INST/u_Aligner/wd/reg0[0]_5_s0  (
	.D(\DPHY_RX_INST/data0 [2]),
	.CLK(clk_byte_out),
	.CE(VCC),
	.CLEAR(\DPHY_RX_INST/u_Aligner/wd/n70_5 ),
	.Q(\DPHY_RX_INST/u_Aligner/wd/reg0[0] [5])
);
defparam \DPHY_RX_INST/u_Aligner/wd/reg0[0]_5_s0 .INIT=1'b0;
DFFCE \DPHY_RX_INST/u_Aligner/wd/reg0[0]_4_s0  (
	.D(\DPHY_RX_INST/data0 [3]),
	.CLK(clk_byte_out),
	.CE(VCC),
	.CLEAR(\DPHY_RX_INST/u_Aligner/wd/n70_5 ),
	.Q(\DPHY_RX_INST/u_Aligner/wd/reg0[0] [4])
);
defparam \DPHY_RX_INST/u_Aligner/wd/reg0[0]_4_s0 .INIT=1'b0;
DFFCE \DPHY_RX_INST/u_Aligner/wd/reg0[0]_3_s0  (
	.D(\DPHY_RX_INST/data0 [4]),
	.CLK(clk_byte_out),
	.CE(VCC),
	.CLEAR(\DPHY_RX_INST/u_Aligner/wd/n70_5 ),
	.Q(\DPHY_RX_INST/u_Aligner/wd/reg0[0] [3])
);
defparam \DPHY_RX_INST/u_Aligner/wd/reg0[0]_3_s0 .INIT=1'b0;
DFFCE \DPHY_RX_INST/u_Aligner/wd/reg0[0]_2_s0  (
	.D(\DPHY_RX_INST/data0 [5]),
	.CLK(clk_byte_out),
	.CE(VCC),
	.CLEAR(\DPHY_RX_INST/u_Aligner/wd/n70_5 ),
	.Q(\DPHY_RX_INST/u_Aligner/wd/reg0[0] [2])
);
defparam \DPHY_RX_INST/u_Aligner/wd/reg0[0]_2_s0 .INIT=1'b0;
DFFCE \DPHY_RX_INST/u_Aligner/wd/reg0[0]_1_s0  (
	.D(\DPHY_RX_INST/data0 [6]),
	.CLK(clk_byte_out),
	.CE(VCC),
	.CLEAR(\DPHY_RX_INST/u_Aligner/wd/n70_5 ),
	.Q(\DPHY_RX_INST/u_Aligner/wd/reg0[0] [1])
);
defparam \DPHY_RX_INST/u_Aligner/wd/reg0[0]_1_s0 .INIT=1'b0;
DFFCE \DPHY_RX_INST/u_Aligner/wd/reg0[0]_0_s0  (
	.D(\DPHY_RX_INST/data0 [7]),
	.CLK(clk_byte_out),
	.CE(VCC),
	.CLEAR(\DPHY_RX_INST/u_Aligner/wd/n70_5 ),
	.Q(\DPHY_RX_INST/u_Aligner/wd/reg0[0] [0])
);
defparam \DPHY_RX_INST/u_Aligner/wd/reg0[0]_0_s0 .INIT=1'b0;
DFFCE \DPHY_RX_INST/u_Aligner/wd/reg1[0]_7_s0  (
	.D(\DPHY_RX_INST/u_Aligner/wd/reg0[0] [7]),
	.CLK(clk_byte_out),
	.CE(VCC),
	.CLEAR(\DPHY_RX_INST/u_Aligner/wd/n70_5 ),
	.Q(\DPHY_RX_INST/u_Aligner/wd/reg1[0] [7])
);
defparam \DPHY_RX_INST/u_Aligner/wd/reg1[0]_7_s0 .INIT=1'b0;
DFFCE \DPHY_RX_INST/u_Aligner/wd/reg1[0]_6_s0  (
	.D(\DPHY_RX_INST/u_Aligner/wd/reg0[0] [6]),
	.CLK(clk_byte_out),
	.CE(VCC),
	.CLEAR(\DPHY_RX_INST/u_Aligner/wd/n70_5 ),
	.Q(\DPHY_RX_INST/u_Aligner/wd/reg1[0] [6])
);
defparam \DPHY_RX_INST/u_Aligner/wd/reg1[0]_6_s0 .INIT=1'b0;
DFFCE \DPHY_RX_INST/u_Aligner/wd/reg1[0]_5_s0  (
	.D(\DPHY_RX_INST/u_Aligner/wd/reg0[0] [5]),
	.CLK(clk_byte_out),
	.CE(VCC),
	.CLEAR(\DPHY_RX_INST/u_Aligner/wd/n70_5 ),
	.Q(\DPHY_RX_INST/u_Aligner/wd/reg1[0] [5])
);
defparam \DPHY_RX_INST/u_Aligner/wd/reg1[0]_5_s0 .INIT=1'b0;
DFFCE \DPHY_RX_INST/u_Aligner/wd/reg1[0]_4_s0  (
	.D(\DPHY_RX_INST/u_Aligner/wd/reg0[0] [4]),
	.CLK(clk_byte_out),
	.CE(VCC),
	.CLEAR(\DPHY_RX_INST/u_Aligner/wd/n70_5 ),
	.Q(\DPHY_RX_INST/u_Aligner/wd/reg1[0] [4])
);
defparam \DPHY_RX_INST/u_Aligner/wd/reg1[0]_4_s0 .INIT=1'b0;
DFFCE \DPHY_RX_INST/u_Aligner/wd/reg1[0]_3_s0  (
	.D(\DPHY_RX_INST/u_Aligner/wd/reg0[0] [3]),
	.CLK(clk_byte_out),
	.CE(VCC),
	.CLEAR(\DPHY_RX_INST/u_Aligner/wd/n70_5 ),
	.Q(\DPHY_RX_INST/u_Aligner/wd/reg1[0] [3])
);
defparam \DPHY_RX_INST/u_Aligner/wd/reg1[0]_3_s0 .INIT=1'b0;
DFFCE \DPHY_RX_INST/u_Aligner/wd/reg1[0]_2_s0  (
	.D(\DPHY_RX_INST/u_Aligner/wd/reg0[0] [2]),
	.CLK(clk_byte_out),
	.CE(VCC),
	.CLEAR(\DPHY_RX_INST/u_Aligner/wd/n70_5 ),
	.Q(\DPHY_RX_INST/u_Aligner/wd/reg1[0] [2])
);
defparam \DPHY_RX_INST/u_Aligner/wd/reg1[0]_2_s0 .INIT=1'b0;
DFFCE \DPHY_RX_INST/u_Aligner/wd/reg1[0]_1_s0  (
	.D(\DPHY_RX_INST/u_Aligner/wd/reg0[0] [1]),
	.CLK(clk_byte_out),
	.CE(VCC),
	.CLEAR(\DPHY_RX_INST/u_Aligner/wd/n70_5 ),
	.Q(\DPHY_RX_INST/u_Aligner/wd/reg1[0] [1])
);
defparam \DPHY_RX_INST/u_Aligner/wd/reg1[0]_1_s0 .INIT=1'b0;
DFFCE \DPHY_RX_INST/u_Aligner/wd/reg1[0]_0_s0  (
	.D(\DPHY_RX_INST/u_Aligner/wd/reg0[0] [0]),
	.CLK(clk_byte_out),
	.CE(VCC),
	.CLEAR(\DPHY_RX_INST/u_Aligner/wd/n70_5 ),
	.Q(\DPHY_RX_INST/u_Aligner/wd/reg1[0] [0])
);
defparam \DPHY_RX_INST/u_Aligner/wd/reg1[0]_0_s0 .INIT=1'b0;
DFFCE \DPHY_RX_INST/u_Aligner/wd/reg2[0]_7_s0  (
	.D(\DPHY_RX_INST/u_Aligner/wd/reg1[0] [7]),
	.CLK(clk_byte_out),
	.CE(VCC),
	.CLEAR(\DPHY_RX_INST/u_Aligner/wd/n70_5 ),
	.Q(\DPHY_RX_INST/u_Aligner/wd/reg2[0] [7])
);
defparam \DPHY_RX_INST/u_Aligner/wd/reg2[0]_7_s0 .INIT=1'b0;
DFFCE \DPHY_RX_INST/u_Aligner/wd/reg2[0]_6_s0  (
	.D(\DPHY_RX_INST/u_Aligner/wd/reg1[0] [6]),
	.CLK(clk_byte_out),
	.CE(VCC),
	.CLEAR(\DPHY_RX_INST/u_Aligner/wd/n70_5 ),
	.Q(\DPHY_RX_INST/u_Aligner/wd/reg2[0] [6])
);
defparam \DPHY_RX_INST/u_Aligner/wd/reg2[0]_6_s0 .INIT=1'b0;
DFFCE \DPHY_RX_INST/u_Aligner/wd/reg2[0]_5_s0  (
	.D(\DPHY_RX_INST/u_Aligner/wd/reg1[0] [5]),
	.CLK(clk_byte_out),
	.CE(VCC),
	.CLEAR(\DPHY_RX_INST/u_Aligner/wd/n70_5 ),
	.Q(\DPHY_RX_INST/u_Aligner/wd/reg2[0] [5])
);
defparam \DPHY_RX_INST/u_Aligner/wd/reg2[0]_5_s0 .INIT=1'b0;
DFFCE \DPHY_RX_INST/u_Aligner/wd/reg2[0]_4_s0  (
	.D(\DPHY_RX_INST/u_Aligner/wd/reg1[0] [4]),
	.CLK(clk_byte_out),
	.CE(VCC),
	.CLEAR(\DPHY_RX_INST/u_Aligner/wd/n70_5 ),
	.Q(\DPHY_RX_INST/u_Aligner/wd/reg2[0] [4])
);
defparam \DPHY_RX_INST/u_Aligner/wd/reg2[0]_4_s0 .INIT=1'b0;
DFFCE \DPHY_RX_INST/u_Aligner/wd/reg2[0]_3_s0  (
	.D(\DPHY_RX_INST/u_Aligner/wd/reg1[0] [3]),
	.CLK(clk_byte_out),
	.CE(VCC),
	.CLEAR(\DPHY_RX_INST/u_Aligner/wd/n70_5 ),
	.Q(\DPHY_RX_INST/u_Aligner/wd/reg2[0] [3])
);
defparam \DPHY_RX_INST/u_Aligner/wd/reg2[0]_3_s0 .INIT=1'b0;
DFFCE \DPHY_RX_INST/u_Aligner/wd/reg2[0]_2_s0  (
	.D(\DPHY_RX_INST/u_Aligner/wd/reg1[0] [2]),
	.CLK(clk_byte_out),
	.CE(VCC),
	.CLEAR(\DPHY_RX_INST/u_Aligner/wd/n70_5 ),
	.Q(\DPHY_RX_INST/u_Aligner/wd/reg2[0] [2])
);
defparam \DPHY_RX_INST/u_Aligner/wd/reg2[0]_2_s0 .INIT=1'b0;
DFFCE \DPHY_RX_INST/u_Aligner/wd/reg2[0]_1_s0  (
	.D(\DPHY_RX_INST/u_Aligner/wd/reg1[0] [1]),
	.CLK(clk_byte_out),
	.CE(VCC),
	.CLEAR(\DPHY_RX_INST/u_Aligner/wd/n70_5 ),
	.Q(\DPHY_RX_INST/u_Aligner/wd/reg2[0] [1])
);
defparam \DPHY_RX_INST/u_Aligner/wd/reg2[0]_1_s0 .INIT=1'b0;
DFFCE \DPHY_RX_INST/u_Aligner/wd/reg2[0]_0_s0  (
	.D(\DPHY_RX_INST/u_Aligner/wd/reg1[0] [0]),
	.CLK(clk_byte_out),
	.CE(VCC),
	.CLEAR(\DPHY_RX_INST/u_Aligner/wd/n70_5 ),
	.Q(\DPHY_RX_INST/u_Aligner/wd/reg2[0] [0])
);
defparam \DPHY_RX_INST/u_Aligner/wd/reg2[0]_0_s0 .INIT=1'b0;
DFFCE \DPHY_RX_INST/u_Aligner/wd/reg3[0]_7_s0  (
	.D(\DPHY_RX_INST/u_Aligner/wd/reg2[0] [7]),
	.CLK(clk_byte_out),
	.CE(VCC),
	.CLEAR(\DPHY_RX_INST/u_Aligner/wd/n70_5 ),
	.Q(\DPHY_RX_INST/u_Aligner/wd/reg3[0] [7])
);
defparam \DPHY_RX_INST/u_Aligner/wd/reg3[0]_7_s0 .INIT=1'b0;
DFFCE \DPHY_RX_INST/u_Aligner/wd/reg3[0]_6_s0  (
	.D(\DPHY_RX_INST/u_Aligner/wd/reg2[0] [6]),
	.CLK(clk_byte_out),
	.CE(VCC),
	.CLEAR(\DPHY_RX_INST/u_Aligner/wd/n70_5 ),
	.Q(\DPHY_RX_INST/u_Aligner/wd/reg3[0] [6])
);
defparam \DPHY_RX_INST/u_Aligner/wd/reg3[0]_6_s0 .INIT=1'b0;
DFFCE \DPHY_RX_INST/u_Aligner/wd/reg3[0]_5_s0  (
	.D(\DPHY_RX_INST/u_Aligner/wd/reg2[0] [5]),
	.CLK(clk_byte_out),
	.CE(VCC),
	.CLEAR(\DPHY_RX_INST/u_Aligner/wd/n70_5 ),
	.Q(\DPHY_RX_INST/u_Aligner/wd/reg3[0] [5])
);
defparam \DPHY_RX_INST/u_Aligner/wd/reg3[0]_5_s0 .INIT=1'b0;
DFFCE \DPHY_RX_INST/u_Aligner/wd/reg3[0]_4_s0  (
	.D(\DPHY_RX_INST/u_Aligner/wd/reg2[0] [4]),
	.CLK(clk_byte_out),
	.CE(VCC),
	.CLEAR(\DPHY_RX_INST/u_Aligner/wd/n70_5 ),
	.Q(\DPHY_RX_INST/u_Aligner/wd/reg3[0] [4])
);
defparam \DPHY_RX_INST/u_Aligner/wd/reg3[0]_4_s0 .INIT=1'b0;
DFFCE \DPHY_RX_INST/u_Aligner/wd/reg3[0]_3_s0  (
	.D(\DPHY_RX_INST/u_Aligner/wd/reg2[0] [3]),
	.CLK(clk_byte_out),
	.CE(VCC),
	.CLEAR(\DPHY_RX_INST/u_Aligner/wd/n70_5 ),
	.Q(\DPHY_RX_INST/u_Aligner/wd/reg3[0] [3])
);
defparam \DPHY_RX_INST/u_Aligner/wd/reg3[0]_3_s0 .INIT=1'b0;
DFFCE \DPHY_RX_INST/u_Aligner/wd/reg3[0]_2_s0  (
	.D(\DPHY_RX_INST/u_Aligner/wd/reg2[0] [2]),
	.CLK(clk_byte_out),
	.CE(VCC),
	.CLEAR(\DPHY_RX_INST/u_Aligner/wd/n70_5 ),
	.Q(\DPHY_RX_INST/u_Aligner/wd/reg3[0] [2])
);
defparam \DPHY_RX_INST/u_Aligner/wd/reg3[0]_2_s0 .INIT=1'b0;
DFFCE \DPHY_RX_INST/u_Aligner/wd/reg3[0]_1_s0  (
	.D(\DPHY_RX_INST/u_Aligner/wd/reg2[0] [1]),
	.CLK(clk_byte_out),
	.CE(VCC),
	.CLEAR(\DPHY_RX_INST/u_Aligner/wd/n70_5 ),
	.Q(\DPHY_RX_INST/u_Aligner/wd/reg3[0] [1])
);
defparam \DPHY_RX_INST/u_Aligner/wd/reg3[0]_1_s0 .INIT=1'b0;
DFFCE \DPHY_RX_INST/u_Aligner/wd/reg3[0]_0_s0  (
	.D(\DPHY_RX_INST/u_Aligner/wd/reg2[0] [0]),
	.CLK(clk_byte_out),
	.CE(VCC),
	.CLEAR(\DPHY_RX_INST/u_Aligner/wd/n70_5 ),
	.Q(\DPHY_RX_INST/u_Aligner/wd/reg3[0] [0])
);
defparam \DPHY_RX_INST/u_Aligner/wd/reg3[0]_0_s0 .INIT=1'b0;
DFFCE \DPHY_RX_INST/u_Aligner/wd/reg4[0]_7_s0  (
	.D(\DPHY_RX_INST/u_Aligner/wd/reg3[0] [7]),
	.CLK(clk_byte_out),
	.CE(VCC),
	.CLEAR(\DPHY_RX_INST/u_Aligner/wd/n70_5 ),
	.Q(\DPHY_RX_INST/u_Aligner/wd/reg4[0] [7])
);
defparam \DPHY_RX_INST/u_Aligner/wd/reg4[0]_7_s0 .INIT=1'b0;
DFFCE \DPHY_RX_INST/u_Aligner/wd/reg4[0]_6_s0  (
	.D(\DPHY_RX_INST/u_Aligner/wd/reg3[0] [6]),
	.CLK(clk_byte_out),
	.CE(VCC),
	.CLEAR(\DPHY_RX_INST/u_Aligner/wd/n70_5 ),
	.Q(\DPHY_RX_INST/u_Aligner/wd/reg4[0] [6])
);
defparam \DPHY_RX_INST/u_Aligner/wd/reg4[0]_6_s0 .INIT=1'b0;
DFFCE \DPHY_RX_INST/u_Aligner/wd/reg4[0]_5_s0  (
	.D(\DPHY_RX_INST/u_Aligner/wd/reg3[0] [5]),
	.CLK(clk_byte_out),
	.CE(VCC),
	.CLEAR(\DPHY_RX_INST/u_Aligner/wd/n70_5 ),
	.Q(\DPHY_RX_INST/u_Aligner/wd/reg4[0] [5])
);
defparam \DPHY_RX_INST/u_Aligner/wd/reg4[0]_5_s0 .INIT=1'b0;
DFFCE \DPHY_RX_INST/u_Aligner/wd/reg4[0]_4_s0  (
	.D(\DPHY_RX_INST/u_Aligner/wd/reg3[0] [4]),
	.CLK(clk_byte_out),
	.CE(VCC),
	.CLEAR(\DPHY_RX_INST/u_Aligner/wd/n70_5 ),
	.Q(\DPHY_RX_INST/u_Aligner/wd/reg4[0] [4])
);
defparam \DPHY_RX_INST/u_Aligner/wd/reg4[0]_4_s0 .INIT=1'b0;
DFFCE \DPHY_RX_INST/u_Aligner/wd/reg4[0]_3_s0  (
	.D(\DPHY_RX_INST/u_Aligner/wd/reg3[0] [3]),
	.CLK(clk_byte_out),
	.CE(VCC),
	.CLEAR(\DPHY_RX_INST/u_Aligner/wd/n70_5 ),
	.Q(\DPHY_RX_INST/u_Aligner/wd/reg4[0] [3])
);
defparam \DPHY_RX_INST/u_Aligner/wd/reg4[0]_3_s0 .INIT=1'b0;
DFFCE \DPHY_RX_INST/u_Aligner/wd/reg4[0]_2_s0  (
	.D(\DPHY_RX_INST/u_Aligner/wd/reg3[0] [2]),
	.CLK(clk_byte_out),
	.CE(VCC),
	.CLEAR(\DPHY_RX_INST/u_Aligner/wd/n70_5 ),
	.Q(\DPHY_RX_INST/u_Aligner/wd/reg4[0] [2])
);
defparam \DPHY_RX_INST/u_Aligner/wd/reg4[0]_2_s0 .INIT=1'b0;
DFFCE \DPHY_RX_INST/u_Aligner/wd/reg4[0]_1_s0  (
	.D(\DPHY_RX_INST/u_Aligner/wd/reg3[0] [1]),
	.CLK(clk_byte_out),
	.CE(VCC),
	.CLEAR(\DPHY_RX_INST/u_Aligner/wd/n70_5 ),
	.Q(\DPHY_RX_INST/u_Aligner/wd/reg4[0] [1])
);
defparam \DPHY_RX_INST/u_Aligner/wd/reg4[0]_1_s0 .INIT=1'b0;
DFFCE \DPHY_RX_INST/u_Aligner/wd/reg4[0]_0_s0  (
	.D(\DPHY_RX_INST/u_Aligner/wd/reg3[0] [0]),
	.CLK(clk_byte_out),
	.CE(VCC),
	.CLEAR(\DPHY_RX_INST/u_Aligner/wd/n70_5 ),
	.Q(\DPHY_RX_INST/u_Aligner/wd/reg4[0] [0])
);
defparam \DPHY_RX_INST/u_Aligner/wd/reg4[0]_0_s0 .INIT=1'b0;
DFFCE \DPHY_RX_INST/u_Aligner/wd/reg5[0]_7_s0  (
	.D(\DPHY_RX_INST/u_Aligner/wd/reg4[0] [7]),
	.CLK(clk_byte_out),
	.CE(VCC),
	.CLEAR(\DPHY_RX_INST/u_Aligner/wd/n70_5 ),
	.Q(\DPHY_RX_INST/u_Aligner/wd/reg5[0] [7])
);
defparam \DPHY_RX_INST/u_Aligner/wd/reg5[0]_7_s0 .INIT=1'b0;
DFFCE \DPHY_RX_INST/u_Aligner/wd/reg5[0]_6_s0  (
	.D(\DPHY_RX_INST/u_Aligner/wd/reg4[0] [6]),
	.CLK(clk_byte_out),
	.CE(VCC),
	.CLEAR(\DPHY_RX_INST/u_Aligner/wd/n70_5 ),
	.Q(\DPHY_RX_INST/u_Aligner/wd/reg5[0] [6])
);
defparam \DPHY_RX_INST/u_Aligner/wd/reg5[0]_6_s0 .INIT=1'b0;
DFFCE \DPHY_RX_INST/u_Aligner/wd/reg5[0]_5_s0  (
	.D(\DPHY_RX_INST/u_Aligner/wd/reg4[0] [5]),
	.CLK(clk_byte_out),
	.CE(VCC),
	.CLEAR(\DPHY_RX_INST/u_Aligner/wd/n70_5 ),
	.Q(\DPHY_RX_INST/u_Aligner/wd/reg5[0] [5])
);
defparam \DPHY_RX_INST/u_Aligner/wd/reg5[0]_5_s0 .INIT=1'b0;
DFFCE \DPHY_RX_INST/u_Aligner/wd/reg5[0]_4_s0  (
	.D(\DPHY_RX_INST/u_Aligner/wd/reg4[0] [4]),
	.CLK(clk_byte_out),
	.CE(VCC),
	.CLEAR(\DPHY_RX_INST/u_Aligner/wd/n70_5 ),
	.Q(\DPHY_RX_INST/u_Aligner/wd/reg5[0] [4])
);
defparam \DPHY_RX_INST/u_Aligner/wd/reg5[0]_4_s0 .INIT=1'b0;
DFFCE \DPHY_RX_INST/u_Aligner/wd/reg5[0]_3_s0  (
	.D(\DPHY_RX_INST/u_Aligner/wd/reg4[0] [3]),
	.CLK(clk_byte_out),
	.CE(VCC),
	.CLEAR(\DPHY_RX_INST/u_Aligner/wd/n70_5 ),
	.Q(\DPHY_RX_INST/u_Aligner/wd/reg5[0] [3])
);
defparam \DPHY_RX_INST/u_Aligner/wd/reg5[0]_3_s0 .INIT=1'b0;
DFFCE \DPHY_RX_INST/u_Aligner/wd/reg5[0]_2_s0  (
	.D(\DPHY_RX_INST/u_Aligner/wd/reg4[0] [2]),
	.CLK(clk_byte_out),
	.CE(VCC),
	.CLEAR(\DPHY_RX_INST/u_Aligner/wd/n70_5 ),
	.Q(\DPHY_RX_INST/u_Aligner/wd/reg5[0] [2])
);
defparam \DPHY_RX_INST/u_Aligner/wd/reg5[0]_2_s0 .INIT=1'b0;
DFFCE \DPHY_RX_INST/u_Aligner/wd/reg5[0]_1_s0  (
	.D(\DPHY_RX_INST/u_Aligner/wd/reg4[0] [1]),
	.CLK(clk_byte_out),
	.CE(VCC),
	.CLEAR(\DPHY_RX_INST/u_Aligner/wd/n70_5 ),
	.Q(\DPHY_RX_INST/u_Aligner/wd/reg5[0] [1])
);
defparam \DPHY_RX_INST/u_Aligner/wd/reg5[0]_1_s0 .INIT=1'b0;
DFFCE \DPHY_RX_INST/u_Aligner/wd/reg5[0]_0_s0  (
	.D(\DPHY_RX_INST/u_Aligner/wd/reg4[0] [0]),
	.CLK(clk_byte_out),
	.CE(VCC),
	.CLEAR(\DPHY_RX_INST/u_Aligner/wd/n70_5 ),
	.Q(\DPHY_RX_INST/u_Aligner/wd/reg5[0] [0])
);
defparam \DPHY_RX_INST/u_Aligner/wd/reg5[0]_0_s0 .INIT=1'b0;
DFFCE \DPHY_RX_INST/u_Aligner/wd/shftamt_0_s0  (
	.D(VCC),
	.CLK(clk_byte_out),
	.CE(\DPHY_RX_INST/u_Aligner/wd/n1141_3 ),
	.CLEAR(\DPHY_RX_INST/u_Aligner/wd/n70_5 ),
	.Q(\DPHY_RX_INST/u_Aligner/wd/shftamt [0])
);
defparam \DPHY_RX_INST/u_Aligner/wd/shftamt_0_s0 .INIT=1'b0;
DFFCE \DPHY_RX_INST/u_Aligner/wd/shftamt_1_s0  (
	.D(VCC),
	.CLK(clk_byte_out),
	.CE(\DPHY_RX_INST/u_Aligner/wd/n1142_4 ),
	.CLEAR(\DPHY_RX_INST/u_Aligner/wd/n70_5 ),
	.Q(\DPHY_RX_INST/u_Aligner/wd/shftamt [1])
);
defparam \DPHY_RX_INST/u_Aligner/wd/shftamt_1_s0 .INIT=1'b0;
DFFCE \DPHY_RX_INST/u_Aligner/wd/shftamt_2_s0  (
	.D(VCC),
	.CLK(clk_byte_out),
	.CE(\DPHY_RX_INST/u_Aligner/wd/n1143_3 ),
	.CLEAR(\DPHY_RX_INST/u_Aligner/wd/n70_5 ),
	.Q(\DPHY_RX_INST/u_Aligner/wd/shftamt [2])
);
defparam \DPHY_RX_INST/u_Aligner/wd/shftamt_2_s0 .INIT=1'b0;
DFFCE \DPHY_RX_INST/u_Aligner/wd/shftamt_3_s0  (
	.D(VCC),
	.CLK(clk_byte_out),
	.CE(\DPHY_RX_INST/u_Aligner/wd/n1144_3 ),
	.CLEAR(\DPHY_RX_INST/u_Aligner/wd/n70_5 ),
	.Q(\DPHY_RX_INST/u_Aligner/wd/shftamt [3])
);
defparam \DPHY_RX_INST/u_Aligner/wd/shftamt_3_s0 .INIT=1'b0;
DFFCE \DPHY_RX_INST/u_Aligner/wd/shftamt_4_s0  (
	.D(VCC),
	.CLK(clk_byte_out),
	.CE(\DPHY_RX_INST/u_Aligner/wd/n1145_3 ),
	.CLEAR(\DPHY_RX_INST/u_Aligner/wd/n70_5 ),
	.Q(\DPHY_RX_INST/u_Aligner/wd/shftamt [4])
);
defparam \DPHY_RX_INST/u_Aligner/wd/shftamt_4_s0 .INIT=1'b0;
DFFCE \DPHY_RX_INST/u_Aligner/wd/shftamt_5_s0  (
	.D(VCC),
	.CLK(clk_byte_out),
	.CE(\DPHY_RX_INST/u_Aligner/wd/n1146_3 ),
	.CLEAR(\DPHY_RX_INST/u_Aligner/wd/n70_5 ),
	.Q(\DPHY_RX_INST/u_Aligner/wd/shftamt [5])
);
defparam \DPHY_RX_INST/u_Aligner/wd/shftamt_5_s0 .INIT=1'b0;
DFFCE \DPHY_RX_INST/u_Aligner/wd/shftamt_6_s0  (
	.D(VCC),
	.CLK(clk_byte_out),
	.CE(\DPHY_RX_INST/u_Aligner/wd/n1147_3 ),
	.CLEAR(\DPHY_RX_INST/u_Aligner/wd/n70_5 ),
	.Q(\DPHY_RX_INST/u_Aligner/wd/shftamt [6])
);
defparam \DPHY_RX_INST/u_Aligner/wd/shftamt_6_s0 .INIT=1'b0;
DFFCE \DPHY_RX_INST/u_Aligner/wd/shftamt_7_s0  (
	.D(VCC),
	.CLK(clk_byte_out),
	.CE(\DPHY_RX_INST/u_Aligner/wd/n1148_3 ),
	.CLEAR(\DPHY_RX_INST/u_Aligner/wd/n70_5 ),
	.Q(\DPHY_RX_INST/u_Aligner/wd/shftamt [7])
);
defparam \DPHY_RX_INST/u_Aligner/wd/shftamt_7_s0 .INIT=1'b0;
DFFCE \DPHY_RX_INST/u_Aligner/wd/dout[0]_7_s0  (
	.D(\DPHY_RX_INST/u_Aligner/wd/n579_3 ),
	.CLK(clk_byte_out),
	.CE(VCC),
	.CLEAR(\DPHY_RX_INST/u_Aligner/wd/n70_5 ),
	.Q(data_out0[0])
);
defparam \DPHY_RX_INST/u_Aligner/wd/dout[0]_7_s0 .INIT=1'b0;
DFFCE \DPHY_RX_INST/u_Aligner/wd/dout[0]_6_s0  (
	.D(\DPHY_RX_INST/u_Aligner/wd/n580_3 ),
	.CLK(clk_byte_out),
	.CE(VCC),
	.CLEAR(\DPHY_RX_INST/u_Aligner/wd/n70_5 ),
	.Q(data_out0[1])
);
defparam \DPHY_RX_INST/u_Aligner/wd/dout[0]_6_s0 .INIT=1'b0;
DFFCE \DPHY_RX_INST/u_Aligner/wd/dout[0]_5_s0  (
	.D(\DPHY_RX_INST/u_Aligner/wd/n581_3 ),
	.CLK(clk_byte_out),
	.CE(VCC),
	.CLEAR(\DPHY_RX_INST/u_Aligner/wd/n70_5 ),
	.Q(data_out0[2])
);
defparam \DPHY_RX_INST/u_Aligner/wd/dout[0]_5_s0 .INIT=1'b0;
DFFCE \DPHY_RX_INST/u_Aligner/wd/dout[0]_4_s0  (
	.D(\DPHY_RX_INST/u_Aligner/wd/n582_3 ),
	.CLK(clk_byte_out),
	.CE(VCC),
	.CLEAR(\DPHY_RX_INST/u_Aligner/wd/n70_5 ),
	.Q(data_out0[3])
);
defparam \DPHY_RX_INST/u_Aligner/wd/dout[0]_4_s0 .INIT=1'b0;
DFFCE \DPHY_RX_INST/u_Aligner/wd/dout[0]_3_s0  (
	.D(\DPHY_RX_INST/u_Aligner/wd/n583_3 ),
	.CLK(clk_byte_out),
	.CE(VCC),
	.CLEAR(\DPHY_RX_INST/u_Aligner/wd/n70_5 ),
	.Q(data_out0[4])
);
defparam \DPHY_RX_INST/u_Aligner/wd/dout[0]_3_s0 .INIT=1'b0;
DFFCE \DPHY_RX_INST/u_Aligner/wd/dout[0]_2_s0  (
	.D(\DPHY_RX_INST/u_Aligner/wd/n584_3 ),
	.CLK(clk_byte_out),
	.CE(VCC),
	.CLEAR(\DPHY_RX_INST/u_Aligner/wd/n70_5 ),
	.Q(data_out0[5])
);
defparam \DPHY_RX_INST/u_Aligner/wd/dout[0]_2_s0 .INIT=1'b0;
DFFCE \DPHY_RX_INST/u_Aligner/wd/dout[0]_1_s0  (
	.D(\DPHY_RX_INST/u_Aligner/wd/n585_3 ),
	.CLK(clk_byte_out),
	.CE(VCC),
	.CLEAR(\DPHY_RX_INST/u_Aligner/wd/n70_5 ),
	.Q(data_out0[6])
);
defparam \DPHY_RX_INST/u_Aligner/wd/dout[0]_1_s0 .INIT=1'b0;
DFFCE \DPHY_RX_INST/u_Aligner/wd/dout[0]_0_s0  (
	.D(\DPHY_RX_INST/u_Aligner/wd/n586_3 ),
	.CLK(clk_byte_out),
	.CE(VCC),
	.CLEAR(\DPHY_RX_INST/u_Aligner/wd/n70_5 ),
	.Q(data_out0[7])
);
defparam \DPHY_RX_INST/u_Aligner/wd/dout[0]_0_s0 .INIT=1'b0;
DFFCE \DPHY_RX_INST/u_Aligner/wd/reg0[0]_7_s0  (
	.D(\DPHY_RX_INST/data0 [0]),
	.CLK(clk_byte_out),
	.CE(VCC),
	.CLEAR(\DPHY_RX_INST/u_Aligner/wd/n70_5 ),
	.Q(\DPHY_RX_INST/u_Aligner/wd/reg0[0] [7])
);
defparam \DPHY_RX_INST/u_Aligner/wd/reg0[0]_7_s0 .INIT=1'b0;

endmodule
