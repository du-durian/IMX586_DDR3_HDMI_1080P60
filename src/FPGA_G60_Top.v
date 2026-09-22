`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Create Date:    17:30:27 07/17/2024 
// Module Name:    FPGA_Top 
//////////////////////////////////////////////////////////////////////////////////

//	DDR3 IO Config: 
//	   \		ACMD		DQ 				DQS
//	800Mbps	6mA Fast 	8mA Fast CTLE HIGH	8mA Fast CTLE MEDIUM
//	1200Mbps	8mA Fast 	12mA Fast CTLE UHIGH	12mA Fast CTLE MEDIUM
//	1600Mbps	8mA Fast 	12mA Fast CTLE UHIGH	12mA Fast CTLE MEDIUM
//	2000Mbps	12mA Fast 	12mA Fast CTLE UHIGH	12mA Fast CTLE MEDIUM
//	IO must be set properly to achieve higher performance. Note SSO issue when using data rate > 1200Mbps. 
//	




module FPGA_G60_Top(
	input 			clk_25m_i, 			//	L6
	
	//led test
    output   wire   led,
    
	//	DDR3 IO
	output 			ddr3_ck_o, 			//	N8. Note DIFF is inverted. 
	output 			ddr3_ck_n_o,  		//	M8
	output 			ddr3_cs_n_o,  		//	R2. 
	output 			ddr3_cke_o,  		//	L10. 
	output 			ddr3_cas_n_o,  		//	P2. 
	output 			ddr3_ras_n_o,  		//	N1. 
	output 			ddr3_we_n_o,  		//	N2. 
	output 			ddr3_odt_o,  		//	P1. 
	output 			ddr3_reset_n_o,  		//	R14. 
	inout 	[14:0] 	ddr3_a_io,  		//	[0..14]R11, M9, N12, R10, N10, P11, L9, P13, M11, R12, L7, N11, N9, R13, M10. 
	inout 	[2:0] 	ddr3_ba_io,  		//	[0..2]N7, L8, P9. 
	
	inout 	[15:0] 	ddr3_dq_io,  		//	[0..15]L5, M6, M5, N6, P7, R7, R4, R5, M4, N5, M1, P5, L3, L1, N4, L2
	output 	[1:0] 	ddr3_dm_o,  		//	[0..1]R6, M3
	inout 	[1:0] 	ddr3_dqs_io, 		//	[0..1]R8, R3
	inout 	[1:0] 	ddr3_dqs_n_io, 		//	[0..1]R9, P3
    
    //! CPHY Ports
    inout           D0A,
    inout           D0B,
    inout           D0C,
    inout           D1A,
    inout           D1B,
    inout           D1C,
    inout           D2A,
    inout           D2B,
    inout           D2C,
    
    output          OV_MCLK,     //K5 output 24MHz
    output          OV_RST_N ,   //J5
    output          OV_SCK,      //H5
    inout           OV_SDA,      //H6
     //hdmi_io
    output hdmi_txc_p_o,
	output [2:0] hdmi_txd_p_o //rgb
	
);
	
	parameter 	SIM_DATAPATH_OVR 	= 0; 
	
	genvar _i; 
	
	assign              OV_RST_N = 1'b1;

 
	
	////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	//	System Clock & Control
	////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	wire 			w_sys_clk; 
	wire 			w_sys_rst, w_sys_rstn; 
	wire 			w_sys_lock; 
	
	
	PLL_25_48 pll_system (
		.lock 		(w_sys_lock), 
		.clkout0	(w_sys_clk), 
		.clkin		(clk_25m_i)
	);
	
	//	Reset Control
	Reset rst_sys_clk (.clk_i(w_sys_clk), .rstn_i(1'b1), .locked_i(w_sys_lock), .rstn_o(w_sys_rstn), .rst_o(w_sys_rst));
	
	
	//	System Configuration
	parameter 	CLOCK_MAIN 	= 48000000; 

	

    ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	//	HDMI_CLK & RESET
	////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	wire	w_clk27m;
	wire 	w_clk27m_rstn;
	
	PLL_25_27 u_pll_25_27(
        .lock(w_clk27m_rstn), //output lock
        .clkout0(w_clk27m), //output clkout0
        .clkin(clk_25m_i) //input clkin
        
    );
	
	wire	clk_pixel;
	wire	clk_pixelx5;
	
	wire 	w_pll_hdmi_lock;
	wire 	clk_pixel_rstn;
	wire 	clk_pixel_rst;
	wire 	w_pll_hdmi_lock;
	
	PLL_27_742_148 u_PLL_27_742_148(
        .lock(w_pll_hdmi_lock), //output lock
        .clkout0(clk_pixelx5), //output clkout0
        .clkout1(clk_pixel), //output clkout1
        .clkin(w_clk27m), //input clkin
        .reset(~w_clk27m_rstn) //input reset
    );
	
    //	Reset Control
	Reset rst_clk_pixel (.clk_i(clk_pixel), .rstn_i(1'b1), .locked_i(w_pll_hdmi_lock), .rstn_o(clk_pixel_rstn), .rst_o(clk_pixel_rst));
    
	////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	//	Sensor Clock & Control
	////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

    PLL_OV_24M u_PLL_OV_24M
   (    
        .reset      (w_sys_rst    ) ,  //input reset
        .clkin     (w_sys_clk        ),   //input clkin 50M
        .clkout0   (OV_MCLK        )   //output clkout0 24M
      
    );
	////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	//	C-PHY CLK
	////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    wire                            wCPHYclk_rstn        ;
    wire                            wCPHYclk            ;
    
    PLL_CPHY_700sps u_PLL_CPHY_700sps(
        .lock       (wCPHYclk_rstn), //output lock
        .clkout0    (wCPHYclk), //output clkout0
        .clkin      (w_sys_clk), //input clkin
        .reset      (w_sys_rst) //input reset
    );


	////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	//	DDR3 PLL & Reset & Init
	////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	wire 			w_pll_ddr_lock; 
	wire 			w_pll_ddr_clk4x, w_pll_ddr_clk; 
	
	PLL_25_300_75 pll_ddr (
		.lock			(w_pll_ddr_lock), 
		.clkout0		(w_pll_ddr_clk4x), 
		.clkout1		(w_pll_ddr_clk), 
		.clkin		    (clk_25m_i)
	); 
	
	//	DDR3 Clocks. Note DCE & DHCE must be utilized. 
	wire 			w_ddr3_clk, w_ddr3_clk4x; 
	wire 			w_ddr3_rst; 
	
	wire 			w_ddr3_clk_en; 			//	DDR3 Clock Enable. 
	DCE ddr3_clk_ce (.CLKIN(w_pll_ddr_clk), .CE(w_ddr3_clk_en), .CLKOUT(w_ddr3_clk)); 
	DHCE ddr3_clk4x_ce (.CLKIN(w_pll_ddr_clk4x), .CEN(~w_ddr3_clk_en), .CLKOUT(w_ddr3_clk4x)); 
	
	
	//	DDR3 UI Clock & Reset
	wire	[0:0]		w_ddr3_0_ui_clk = w_ddr3_clk;
	wire			w_ddr3_0_ui_rst = w_ddr3_rst;
	
	wire			w_ddr3_0_ui_areset = w_ddr3_rst;
	wire			w_ddr3_0_ui_aresetn = ~w_ddr3_rst;
	
	wire	[0:0]		w_ddr3_1_ui_clk = w_ddr3_clk;
	wire			w_ddr3_1_ui_rst = w_ddr3_rst;
	
	wire			w_ddr3_1_ui_areset = w_ddr3_rst;
	wire			w_ddr3_1_ui_aresetn = ~w_ddr3_rst;

	wire 			w_ustick, w_mstick; 
	
	DDR_Tick_Generator#(
        .CLK_PERIOD     (CLOCK_MAIN)
    )u_DDR_Tick_Generator
    (
        .sys_clk_i      (w_sys_clk),
        .sys_rstn_i     (w_sys_rstn),
        
        .ustick_o       (w_ustick),  // 1MHz
        .mstick_o	    (w_mstick)  // 1KHz

    );
	
	////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	//	DDR3 Controller 
	////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	
	//	DDR3 Configuration
	parameter 	DDR3_ADDR_BITS 	= 15; 
	parameter 	DDR3_BA_BITS 	= 3; 
	parameter 	DDR3_DQ_BITS 	= 16; 
	parameter 	DDR3_DQS_BITS 	= DDR3_DQ_BITS / 8; 
	parameter 	DDR3_CS_BITS 	= 1; 
	
	
	//	AXI Configuration
	parameter 	MIG_AWID_LEN 	= 2; 
	parameter 	MIG_ARID_LEN 	= MIG_AWID_LEN; 
	parameter 	MIG0_DATA_WIDTH 	= DDR3_DQ_BITS * 8; 
	parameter 	MIG0_STRB_BITS 	= MIG0_DATA_WIDTH / 8; 
	parameter 	MIG0_RUSER_LEN 	= MIG0_STRB_BITS; 		//	RUSER is readback of DQS. 
	
	
	//	AXI Port 00
	wire	[MIG_AWID_LEN-1:0]	w_ddr3_axi_awid;
	wire	[31:0]			w_ddr3_axi_awaddr;
	wire	[7:0]				w_ddr3_axi_awlen;
	wire					w_ddr3_axi_awvalid;
	wire					w_ddr3_axi_awready;
	
	wire	[MIG_AWID_LEN-1:0]	w_ddr3_axi_wid;
	wire	[MIG0_DATA_WIDTH-1:0]	w_ddr3_axi_wdata;
	wire	[MIG0_STRB_BITS-1:0]	w_ddr3_axi_wstrb;
	wire					w_ddr3_axi_wlast;
	wire					w_ddr3_axi_wvalid;
	wire					w_ddr3_axi_wready;
	
	wire	[MIG_AWID_LEN-1:0]	w_ddr3_axi_bid;
	wire	[1:0]				w_ddr3_axi_bresp;
	wire					w_ddr3_axi_bvalid;
	wire					w_ddr3_axi_bready;
	
	wire	[MIG_ARID_LEN-1:0]	w_ddr3_axi_arid;
	wire	[31:0]			w_ddr3_axi_araddr;
	wire	[7:0]				w_ddr3_axi_arlen;
	wire					w_ddr3_axi_arvalid;
	wire					w_ddr3_axi_arready;
	
	wire					w_ddr3_axi_rready;
	wire	[MIG_ARID_LEN-1:0]	w_ddr3_axi_rid;
	wire	[MIG0_DATA_WIDTH-1:0]	w_ddr3_axi_rdata;
	wire 	[MIG0_RUSER_LEN-1:0] 	w_ddr3_axi_ruser; 
	wire	[1:0]				w_ddr3_axi_rresp;
	wire					w_ddr3_axi_rlast;
	wire					w_ddr3_axi_rvalid;
	
	
	
	wire 					w_cal_done; 
	wire 	[DDR3_ADDR_BITS*8-1:0] 	w_ddr3_tp_a_o; 
	wire 	[31:0] 			w_ddr3_tp1, w_ddr3_tp2, w_ddr3_tp3; 
	wire 	[6:0] 			w_ps_dyna_offset_i; 
	wire 					w_ps_dyna_incdec_i, w_ps_dyna_shift_i; 
	
	
	//	Calibration
	wire 	[7:0] 			w_ddr3_adlytap_i; 		//	IODELAY Inc for A
	wire 					w_ddr3_adlyupd_i; 
	wire 	[7:0] 			w_ddr3_dqdlytap_i; 		//	IODELAY Inc for DQ
	wire 					w_ddr3_dqdlyupd_i;
	wire 	[7:0] 			w_ddr3_dqsdlytap_i; 		//	IODELAY Inc for DQS
	wire 					w_ddr3_dqsdlyupd_i; 
	wire 					w_ddr3_ddrdllupd_i; 		//	DDRDLL Update
	wire 					w_ddr3_ddrdqsupd_i; 		//	DDRDQS Update
	wire 	[7:0] 			w_ddr3_ddrdllstep_o; 		
	wire 					w_ddr3_dqswinc0dec1_i; 
	wire 					w_ddr3_dqswmove_i; 		
	wire 	[2:0] 			w_ddr3_calib_tap_i; 
	wire 	[3:0] 			w_ddr3_bitpos_i; 
	
	DDR3ControllerGWTopLite u_ddr3_top (		//	#(.TG_CYC_PS(1250), .TG_RATIO(4)) 
		.sysclk_i 			(w_sys_clk), 			//	System Clock & Reset (Async)
		.sysrst_i 			(w_sys_rst), 			//	System Clock & Reset (sysclk_i Region)
		
		.clk_i			(w_ddr3_clk),			//	UI Clock (1X)
		.clk4x_i			(w_ddr3_clk4x), 			//	IO Clock (4X)
		.lock_i 			(w_pll_ddr_lock), 		//	PLL Lock
		
		.clken_o 			(w_ddr3_clk_en), 			//	HS Clock Enable (Async)
		.rst_o 			(w_ddr3_rst), 			//	DDR3 Reset Output (clk_i Region)
		
		.ddr_ck_inv_i		(0), 	//	DDR CK Invert
		.ddr_dqs_inv_i		(0), 	//	DDR DQS Invert
		
		.ustick_i			(w_ustick), 
		.mstick_i			(w_mstick), 	
		
		.adlytap_i			(0), 		//	IODELAY Inc for A
		.adlyupd_i			(0), 
		.dqdlytap_i			(0), 		//	IODELAY Inc for DQ
		.dqdlyupd_i			(0),
		.dqsdlytap_i		(0), 		//	IODELAY Inc for DQS
		.dqsdlyupd_i		(0), 
		.ddrdllupd_i		(0), 		//	DDRDLL Update
		.ddrdqsupd_i		(0), 		//	DDRDQS Update
		.ddrdllstep_o 		( ), 
		.dqswinc0dec1_i		(0), 	//	DQS Write Tap Inc 0 Dec 1
		.dqswmove_i			(0), 		//	DQS Write Tap Update
		.calib_tap_i		(0), 		//	Calibration Data Tap
		.bitpos_i			(0), 			//	Data Bit Position
		
		.cal_done_o 		(w_cal_done), 
		
		.ps_dyna_offset_i 	(0), 	//	Phase Tuner
		.ps_incdec_i		(0), 
		.ps_en_i 			(0), 
		
		.tp_a_o 			(), 
		.tp1_o			    (), 
		.tp2_o			    (), 
		.tp3_o 			    (), 
		.txd_o 			(fpga_done_io), 			
		
		//	DDR Interface
		.ddr3_ck_o			(ddr3_ck_o), 			//	N8. Note DIFF is inverted. 
		.ddr3_ck_n_o		(ddr3_ck_n_o),  		//	M8
		.ddr3_cs_n_o		(ddr3_cs_n_o),  		//	R2. 
		.ddr3_cke_o			(ddr3_cke_o),  		//	L10. 
		.ddr3_cas_n_o		(ddr3_cas_n_o),  		//	P2. 
		.ddr3_ras_n_o		(ddr3_ras_n_o),  		//	N1. 
		.ddr3_we_n_o		(ddr3_we_n_o),  		//	N2. 
		.ddr3_odt_o			(ddr3_odt_o),  		//	P1. 
		.ddr3_reset_n_o		(ddr3_reset_n_o),  		//	R14. 
		.ddr3_a_io			(ddr3_a_io),  		//	[0..14]R11, M9, N12, R10, N10, P11, L9, P13, M11, R12, L7, N11, N9, R13, M10. 
		.ddr3_ba_io			(ddr3_ba_io),  		//	[0..2]N7, L8, P9. 
		
		.ddr3_dq_io			(ddr3_dq_io),  		//	[0..15]L5, M6, M5, N6, P7, R7, R4, R5, M4, N5, M1, P5, L3, L1, N4, L2
		.ddr3_dm_o			(ddr3_dm_o),  		//	[0..1]R6, M3
		.ddr3_dqs_io		(ddr3_dqs_io), 		//	[0..1]R8, R3
		.ddr3_dqs_n_io		(ddr3_dqs_n_io),		//	[0..1]R9, P3
		
		//	AXI Interface
		.s_axi_awid_i		(w_ddr3_axi_awid),
		.s_axi_awaddr_i		(w_ddr3_axi_awaddr),
		.s_axi_awlen_i		(w_ddr3_axi_awlen),		//	Burst_Length = AWLEN+1
		.s_axi_awvalid_i		(w_ddr3_axi_awvalid),
		.s_axi_awready_o		(w_ddr3_axi_awready),
		
		.s_axi_wid_i		(w_ddr3_axi_wid),
		.s_axi_wdata_i		(w_ddr3_axi_wdata),
		.s_axi_wstrb_i		(w_ddr3_axi_wstrb),		//	Write Strobe. Default: FF
		.s_axi_wlast_i		(w_ddr3_axi_wlast),
		.s_axi_wvalid_i		(w_ddr3_axi_wvalid),
		.s_axi_wready_o		(w_ddr3_axi_wready),
		
		.s_axi_bid_o		(w_ddr3_axi_bid),
		.s_axi_bresp_o		(w_ddr3_axi_bresp),		//	OK		(), EXOK		(), SLVERR		(), DECERR
		.s_axi_bvalid_o		(w_ddr3_axi_bvalid),
		.s_axi_bready_i		(w_ddr3_axi_bready),
		
		.s_axi_arid_i		(w_ddr3_axi_arid),
		.s_axi_araddr_i		(w_ddr3_axi_araddr),
		.s_axi_arlen_i		(w_ddr3_axi_arlen),		//	Burst_Length = ARLEN+1
		.s_axi_arvalid_i		(w_ddr3_axi_arvalid),
		.s_axi_arready_o		(w_ddr3_axi_arready),
		
		.s_axi_rid_o		(w_ddr3_axi_rid),
		.s_axi_rdata_o		(w_ddr3_axi_rdata),
		.s_axi_ruser_o		(w_ddr3_axi_ruser),
		.s_axi_rresp_o		(w_ddr3_axi_rresp),		//	OK		(), EXOK		(), SLVERR		(), DECERR
		.s_axi_rlast_o		(w_ddr3_axi_rlast),
		.s_axi_rvalid_o		(w_ddr3_axi_rvalid),
		.s_axi_rready_i		(w_ddr3_axi_rready)
	); 
	

	assign w_ddr3_axi_bready = 1; 
	assign w_ddr3_axi_rready = 1; 
	
	wire 			w_mcb_calibdone = w_cal_done; 
	

	
	////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	//	I2C Config 
	////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	
	wire i2c_sclk;
	wire i2c_sdat;
	wire                   [   9:0]         i2c_config_index           ;
	wire                   [  23:0]         i2c_config_data            ;
	wire                   [   9:0]         i2c_config_size            ;
	wire                                    i2c_config_done            ;
	i2c_timing_ctrl_reg16_dat8_wronly
	#(
		.CLK_FREQ                          (CLOCK_MAIN                ),//48 MHz
		.I2C_FREQ                          (50_000                     ) //10 KHz(< 400KHz)
	)
	u_i2c_timing_ctrl_reg16_dat8_wronly
	(
		//global clock
		.clk                               (w_sys_clk                   ),//48MHz
		.rst_n                             (w_sys_rstn    ),//system reset & w_mcb_calibdone

		.i2c_sclk                          (i2c_sclk               ),//i2c clock
		.i2c_sdat                          (i2c_sdat               ),//i2c data for bidirection


		.i2c_config_size                   (i2c_config_size           ),//i2c config data counte
		.i2c_config_index                  (i2c_config_index          ),//i2c config reg index, read 2 reg and write xx reg
		.i2c_config_data                   ({8'h34, i2c_config_data}          ),//i2c config data
		.i2c_config_done                   (i2c_config_done           ) //i2c config timing complete
	);
	I2C_IMX586_Config U_I2C_IMX586_Config
		(
		.LUT_INDEX                         (i2c_config_index          ),
		.LUT_DATA                          (i2c_config_data           ),
		.LUT_SIZE                          (i2c_config_size           ) 
		);

	assign OV_SCK      = i2c_sclk;
    assign OV_SDA      = i2c_sdat;
	
	////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	//	MIPI RX C-PHY
	////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////	
	
    // initial values
    parameter                               HRES                                = 3840;     // 1920, 4096   : determined by Sensor, used to check whether CPHY rx image match Sensor configuration
    parameter                               VRES                                = 2160;    // 1080, 3072   : determined by Sensor, used to check whether CPHY rx image match Sensor configuration
    
    localparam  [15:0]                      HBITS                               =HRES*10            ;
    localparam  [15:0]                      WC_REF                              =HBITS/8            ;

    localparam  [15:0]                      D96QUOTIENT                         =HBITS/96           ;
    localparam  [15:0]                      D96REMAINDER                        =HBITS%96           ;
    localparam  [15:0]                      D96PERIOD                           =D96QUOTIENT + ((D96REMAINDER>0)? 1'd1:1'd0);


    // ---- CPHYrx ----
    // config
    reg         [15:0]                      RW_CPHY_CSI_VRES                    =VRES               ;
    reg         [15:0]                      RW_CPHY_CSI_WC_REF                  =WC_REF             ;
    reg         [15:0]                      RW_CPHY_CSI_D96PERIOD               =D96PERIOD          ;

    // debug
    wire                                    RO_CPHY_CSI_STATE0ERR                                   ;
    wire                                    RO_CPHY_CSI_WCERR                                       ;
    wire                                    RO_CPHY_CSI_HCNTERR                                     ;
    wire                                    RO_CPHY_CSI_VCNTERR                                     ;
    wire        [15:0]                      RO_CPHY_CSI_FVSCNT                                      ;
    wire        [15:0]                      RO_CPHY_CSI_FVECNT                                      ;
	
    localparam                              DT_RAW10                            =6'h2B              ;


    wire                                    wCPHYrxFvs      /* synthesis syn_keep=1 */;
    wire                                    wCPHYrxFve      /* synthesis syn_keep=1 */;
    wire        [3:0]                       wCPHYrxDe       /* synthesis syn_keep=1 */;
    wire                                    wCPHYrxEol      /* synthesis syn_keep=1 */;
    wire        [95:0]                      wCPHYrxData     /* synthesis syn_keep=1 */;  // first--last



    CPHYrx u_CPHYrx
    (
        .RESET_N               (w_sys_rstn             ),
        .OSC_50M               (wCPHYclk              ),
    
        .D0A                   (D0A                    ),
        .D0B                   (D0B                    ),
        .D0C                   (D0C                    ),
        .D1A                   (D1A                    ),
        .D1B                   (D1B                    ),
        .D1C                   (D1C                    ),
        .D2A                   (D2A                    ),
        .D2B                   (D2B                    ),
        .D2C                   (D2C                    ),
                        
        .I_CPHYCLK             (wCPHYclk               ),
        .O_FVS                 (wCPHYrxFvs             ),
        .O_FVE                 (wCPHYrxFve             ),
        .O_DE                  (wCPHYrxDe              ),
        .O_EOL                 (wCPHYrxEol             ),
        .O_DATA                (wCPHYrxData            ),
    
        //,.LED                   (   LED              ),
    
        .RW_CPHY_CSI_VRES      (RW_CPHY_CSI_VRES       ),
        .RW_CPHY_CSI_WC_REF    (RW_CPHY_CSI_WC_REF     ),
        .RW_CPHY_CSI_D96PERIOD (RW_CPHY_CSI_D96PERIOD  ),
                                
        .RO_CPHY_CSI_STATE0ERR (RO_CPHY_CSI_STATE0ERR  ),
        .RO_CPHY_CSI_WCERR     (RO_CPHY_CSI_WCERR      ),
        .RO_CPHY_CSI_HCNTERR   (RO_CPHY_CSI_HCNTERR    ),
        .RO_CPHY_CSI_VCNTERR   (RO_CPHY_CSI_VCNTERR    ),
        .RO_CPHY_CSI_FVSCNT    (RO_CPHY_CSI_FVSCNT     ),
        .RO_CPHY_CSI_FVECNT    (RO_CPHY_CSI_FVECNT     ),
    
        .test_io               (cphy_test_io           ),
        .test_io2              (cphy_test_io2          )
    );

    reg     [5:0]       r_frame_cnt;


    always@(posedge wCPHYclk)begin
    if(wCPHYrxFvs)
        r_frame_cnt <= r_frame_cnt + 1'b1;
    else    
        r_frame_cnt <= r_frame_cnt;
    end
    
    assign led = r_frame_cnt[5];

   
    ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	//	DATA RESHARPE
	//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////// 

    wire                    w_cmos_vsync;
    wire                    w_cmos_hsync;
    wire                    w_cmos_de;
    wire    [127:0]         w_cmos_data;

    CMOS_IMX586_FrameCapture#(
        .IMAGE_HSIZE_SOURCE(HRES),
        .IMAGE_VSIZE_SOURCE(VRES)
    )u_imx586_capture
    (
        .Rstn_i             (wCPHYclk_rstn),
        .CPHYClk_i          (wCPHYclk),
        .CPHYFvs_i          (wCPHYrxFvs),
        .CPHYDe_i           (wCPHYrxDe[3]|wCPHYrxDe[2]),
        .CPHYData96bit_i    (wCPHYrxData),
        
        .cmos_vsync_o       (w_cmos_vsync),
        .cmos_hsync_o       (w_cmos_hsync),
        .cmos_de_o          (w_cmos_de),
        .cmos_16pixels_o    (w_cmos_data)
         
    );
    
    ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	//	XYCrop
	////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
   

	parameter IMAGE_HSIZE_SOURCE  = HRES/16;
	parameter IMAGE_VSIZE_SOURCE  = VRES;
	parameter IMAGE_HSIZE_TARGET  = 1920/16;
	parameter IMAGE_YSIZE_TARGET  = 1080 ;
	parameter PIXEL_DATA_WIDTH    = 128  ;

    

	wire  image_out_vsync                      ;
	wire  image_out_href                       ;
	wire  image_out_de                         ;
	wire  [PIXEL_DATA_WIDTH-1:0]  image_out_data ;


	Sensor_Image_XYCrop #(
		.IMAGE_HSIZE_SOURCE ( IMAGE_HSIZE_SOURCE ),
		.IMAGE_VSIZE_SOURCE ( IMAGE_VSIZE_SOURCE ),
		.IMAGE_HSIZE_TARGET ( IMAGE_HSIZE_TARGET ),
		.IMAGE_YSIZE_TARGET ( IMAGE_YSIZE_TARGET ),
		.PIXEL_DATA_WIDTH   ( PIXEL_DATA_WIDTH   )
    ) 
	 u_Sensor_Image_XYCrop (
		.clk                     ( wCPHYclk                                     ), //pclk  align with data
		.rst_n                   ( wCPHYclk_rstn                                   ),
		.image_in_vsync          ( w_cmos_vsync                          ),//vsync 
		.image_in_href           ( w_cmos_hsync                           ),//hsync
		.image_in_de             ( w_cmos_de                             ),//data_valid , if dvp data doesn't have hsync,both use data_valid（data_enable)
		.image_in_data           ( w_cmos_data),//dvp data

		.image_out_vsync         ( image_out_vsync                         ),//delay vsync ,just delay
		.image_out_href          ( image_out_href                          ),//delay data valid, after  XYCrop
		.image_out_de            ( image_out_de                            ),//delay data_en ,originally align with data
		.image_out_data          ( image_out_data   [PIXEL_DATA_WIDTH-1:0] )//out data ,align with data de
	);

	////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	//	AXI4_Ctrl
	////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	


	wire 			w_lcd_vs, w_lcd_de; 
	wire 	[7:0] 	w_lcd_data; 


	axi4_ctrl 
	#(
		.C_RD_END_ADDR	(1920*1080           ), 
		.C_W_WIDTH 		(128), 
		.C_R_WIDTH 		(8)
	)
	u_axi4_ctrl
	(
		.axi_clk        (w_ddr3_clk            ),
		.axi_reset      (w_ddr3_rst            ),
		
		.axi_awid       (         ),
		.axi_awaddr     (w_ddr3_axi_awaddr       ),
		.axi_awlen      (w_ddr3_axi_awlen        ),
		.axi_awsize     (       ),
		.axi_awburst    (      ),
		.axi_awlock     (       ),
		.axi_awcache    (      ),
		.axi_awprot     (       ),
		.axi_awqos      (        ),
		.axi_awvalid    (w_ddr3_axi_awvalid      ),
		.axi_awready    (w_ddr3_axi_awready      ),
		
		.axi_wdata      (w_ddr3_axi_wdata        ),
		.axi_wstrb      (w_ddr3_axi_wstrb        ),
		.axi_wlast      (w_ddr3_axi_wlast        ),
		.axi_wvalid     (w_ddr3_axi_wvalid       ),
		.axi_wready     (w_ddr3_axi_wready       ),
		
		.axi_bid        (0          ),
		.axi_bresp      (0        ),
		.axi_bvalid     (1       ),
		.axi_bready     (w_ddr3_axi_bready       ),
		
		.axi_arid       (w_ddr3_axi_arid         ),
		.axi_araddr     (w_ddr3_axi_araddr       ),
		.axi_arlen      (w_ddr3_axi_arlen        ),
		.axi_arsize     (       ),
		.axi_arburst    (      ),
		.axi_arlock     (       ),
		.axi_arcache    (      ),
		.axi_arprot     (       ),
		.axi_arqos      (        ),
		.axi_arvalid    (w_ddr3_axi_arvalid      ),
		.axi_arready    (w_ddr3_axi_arready      ),
		
		.axi_rid        (w_ddr3_axi_rid          ),
		.axi_rdata      (w_ddr3_axi_rdata        ),
		.axi_rresp      (0        ),
		.axi_rlast      (w_ddr3_axi_rlast        ),
		.axi_rvalid     (w_ddr3_axi_rvalid       ),
		.axi_rready     (w_ddr3_axi_rready       ),
//		
		.wframe_pclk    (wCPHYclk          ),
        .wframe_vsync   (~image_out_vsync ),
		.wframe_data_en (image_out_de&image_out_href),
		.wframe_data    (image_out_data    ),

		.rframe_pclk    (clk_pixel            ),
		.rframe_vsync   (lcd_vs               ),
		.rframe_data_en (lcd_request          ),
		.rframe_data    (w_lcd_data           )
	

	);
	
	
	
	////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	//	LCD Driver
	////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	
	wire                            lcd_de;
	wire                            lcd_hs;      
	wire                            lcd_vs;
	wire 					        lcd_request; 
	wire            [7:0]           lcd_red, lcd_red2;
	wire            [7:0]           lcd_green, lcd_green2;
	wire            [7:0]           lcd_blue, lcd_blue2;
	
	wire            [11:0]          lcd_xpos, lcd_ypos; 
	wire            [23:0]          lcd_data = {3{w_lcd_data}};

    wire                            w_lcd_rdata_rvalid         ;
    wire            [ 7:0]          w_lcd_rdata_raw            ;


    lcd_driver u_lcd_driver
	(
//		  global clock
		.clk        (clk_pixel   ),
		.rst_n      (clk_pixel_rstn), 

//		  lcd interface
		.lcd_dclk   (               ),
		.lcd_blank  (               ),
		.lcd_sync   (               ),
		.lcd_request(lcd_request    ), 	//	Request data 1 cycle ahead. 
		.lcd_hs     (lcd_hs         ),
		.lcd_vs     (lcd_vs         ),
		.lcd_en     (lcd_de         ),
		.lcd_rgb    ({lcd_red,lcd_green,lcd_blue}),

//		  user interface
		.lcd_xpos	(),		//lcd horizontal coordinate
		.lcd_ypos	(),		//lcd vertical coordinate
		.lcd_data   (lcd_data)
	);

    ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	//	Bayer2RGB
	////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    
    wire 			w_rgb_vsync, w_rgb_hsync, w_rgb_href; 
    wire 	[7:0] 	w_rgb_r, w_rgb_g, w_rgb_b; 

    VIP_RAW8_RGB888 #(.IMG_HDISP(1920), .IMG_VDISP(1080)) u_bayer2rgb (
        .clk                               (clk_pixel                   ),//cmos video pixel clock
        .rst_n                             (clk_pixel_rstn             ),//global reset
        
        .mirror                            (2'b01                     ),


        .per_frame_vsync                   (lcd_vs                    ),//Prepared Image data vsync valid signal. Reset on falling edge. 
        .per_frame_href                    (lcd_de                    ),//Prepared Image data href vaild  signal
        .per_frame_hsync                   (lcd_hs                    ),//Prepared Image data href vaild  signal
        .per_img_RAW                       (lcd_red                 ),//Prepared Image data 8 Bit RAW Data

        .post_frame_vsync                  (w_rgb_vsync               ),//Processed Image data vsync valid signal
        .post_frame_href                   (w_rgb_href                ),//Processed Image data href vaild  signal
        .post_frame_hsync                  (w_rgb_hsync               ),//Processed Image data href vaild  signal
        .post_img_red                      (w_rgb_r                   ),//Prepared Image green data to be processed 
        .post_img_green                    (w_rgb_g                   ),//Prepared Image green data to be processed
        .post_img_blue                     (w_rgb_b                   ) //Prepared Image blue data to be processed
    );

    /////////////////////////////////////////////////////////////////////////////
    //  Manual White Balance
    wire 	[7:0] 	w_rgb_wb_r, w_rgb_wb_g, w_rgb_wb_b; 
    wire 	[17:0] 	w_rgb_r_mult = w_rgb_r * 441;//490; //409
	wire 	[17:0] 	w_rgb_b_mult = w_rgb_b * 460; //384
	assign w_rgb_wb_r = w_rgb_r_mult[17:16] ? 8'hFF : w_rgb_r_mult[15: 8]; 
	assign w_rgb_wb_g = w_rgb_g; 
	assign w_rgb_wb_b = w_rgb_b_mult[17:16] ? 8'hFF : w_rgb_b_mult[15: 8]; 
	
	reg 			r_rgb_vsync = 0, r_rgb_hsync = 0, r_rgb_href = 0; 
	reg 	[7:0] 	r_rgb_r = 0, r_rgb_g = 0, r_rgb_b = 0; 
	always @(posedge clk_pixel) begin
		r_rgb_vsync <= w_rgb_vsync; 
		r_rgb_hsync <= w_rgb_hsync; 
		r_rgb_href <= w_rgb_href; 
		r_rgb_r <= w_rgb_wb_r; 
		r_rgb_g <= w_rgb_wb_g; 
		r_rgb_b <= w_rgb_wb_b; 
	end

    /////////////////////////////////////////////////////////////////////////////
    //FrameBoundCrop

    wire                w_out_vs;
    wire                w_out_hs;
    wire                w_out_de;
    wire    [23:0]      w_out_rgb;
    FrameBoundCrop #(
        .SKIP_ROWS 	    (2), 
        .SKIP_COLS 	    (2),
        .TOTAL_ROWS 	(1080), 
        .TOTAL_COLS 	(1920)
    )u_FrameBoundCrop
    (
        .clk_i          (clk_pixel),
        .rst_i(clk_pixel_rstn),
        
        
        .vs_i(r_rgb_vsync),
        .hs_i(r_rgb_hsync),
        .de_i(r_rgb_href),
        .data_i({r_rgb_r,r_rgb_g,r_rgb_b}),
        
        
        .vs_o(w_out_vs),
        .hs_o(w_out_hs),
        .de_o(w_out_de),
        .data_o(w_out_rgb)
    );

	////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	//	HDMI IP
	////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	wire 	[9:0] 	w_hdmi_txc, w_hdmi_txd0, w_hdmi_txd1, w_hdmi_txd2; 
	
	rgb2dvi #(.ENABLE_OSERDES(0)) u_bgr2dvi 
	(
		.oe_i 		(1), 			//	Always enable output
		.bitflip_i 		(4'b1111), 		//	Reverse clock & data lanes. 
//	
		.aRst			(clk_pixel_rst), 
		.aRst_n		    (clk_pixel_rstn), 
		
		.PixelClk		(clk_pixel),	//pixel clk = 74.25M
		.SerialClk		(),			//pixel clk*5 = 371.25M
		
//		.vid_pVSync		(w_rgb_vsync),	//	w_lcd_vs), 
//		.vid_pHSync		(w_rgb_hsync),	//	w_lcd_hs), 
//		.vid_pVDE		(w_rgb_href),	//	w_lcd_de), 
//		.vid_pData		({w_rgb_b,w_rgb_g,w_rgb_r}),	//	{w_lcd_red, w_lcd_green, w_lcd_blue}), {lcd_red,lcd_green,lcd_blue}
        .vid_pVSync		(w_out_vs),	//	w_lcd_vs), 
		.vid_pHSync		(w_out_hs),	//	w_lcd_hs), 
		.vid_pVDE		(w_out_de),	//	w_lcd_de), 
		.vid_pData		(w_out_rgb),	//	{w_lcd_red, w_lcd_green, w_lcd_blue}), {lcd_red,lcd_green,lcd_blue}
		
		.txc_o		(w_hdmi_txc), 
		.txd0_o		(w_hdmi_txd0), 
		.txd1_o		(w_hdmi_txd1), 
		.txd2_o		(w_hdmi_txd2)
	); 

    reg 			r_hdmi_tx_oser10_reset_i = 0; 
	reg 	[3:0] 	r_hdmi_tx_oser10_reset = 0; 
	always @(posedge clk_pixel) begin
		r_hdmi_tx_oser10_reset_i <= clk_pixel_rst; 
		r_hdmi_tx_oser10_reset <= {4{r_hdmi_tx_oser10_reset_i}}; 
	end 
	
   OSER10 oss0 (.Q(hdmi_txd_p_o[0]), .D0(w_hdmi_txd0[0]), .D1(w_hdmi_txd0[1]), .D2(w_hdmi_txd0[2]), .D3(w_hdmi_txd0[3]), .D4(w_hdmi_txd0[4]), .D5(w_hdmi_txd0[5]), .D6(w_hdmi_txd0[6]), .D7(w_hdmi_txd0[7]), .D8(w_hdmi_txd0[8]), .D9(w_hdmi_txd0[9]), .PCLK(clk_pixel), .FCLK(clk_pixelx5), .RESET(r_hdmi_tx_oser10_reset)); 
   OSER10 oss1 (.Q(hdmi_txd_p_o[1]), .D0(w_hdmi_txd1[0]), .D1(w_hdmi_txd1[1]), .D2(w_hdmi_txd1[2]), .D3(w_hdmi_txd1[3]), .D4(w_hdmi_txd1[4]), .D5(w_hdmi_txd1[5]), .D6(w_hdmi_txd1[6]), .D7(w_hdmi_txd1[7]), .D8(w_hdmi_txd1[8]), .D9(w_hdmi_txd1[9]), .PCLK(clk_pixel), .FCLK(clk_pixelx5), .RESET(r_hdmi_tx_oser10_reset)); 
   OSER10 oss2 (.Q(hdmi_txd_p_o[2]), .D0(w_hdmi_txd2[0]), .D1(w_hdmi_txd2[1]), .D2(w_hdmi_txd2[2]), .D3(w_hdmi_txd2[3]), .D4(w_hdmi_txd2[4]), .D5(w_hdmi_txd2[5]), .D6(w_hdmi_txd2[6]), .D7(w_hdmi_txd2[7]), .D8(w_hdmi_txd2[8]), .D9(w_hdmi_txd2[9]), .PCLK(clk_pixel), .FCLK(clk_pixelx5), .RESET(r_hdmi_tx_oser10_reset)); 
   OSER10 oss3 (.Q(hdmi_txc_p_o), .D0(w_hdmi_txc[0]), .D1(w_hdmi_txc[1]), .D2(w_hdmi_txc[2]), .D3(w_hdmi_txc[3]), .D4(w_hdmi_txc[4]), .D5(w_hdmi_txc[5]), .D6(w_hdmi_txc[6]), .D7(w_hdmi_txc[7]), .D8(w_hdmi_txc[8]), .D9(w_hdmi_txc[9]), .PCLK(clk_pixel), .FCLK(clk_pixelx5), .RESET(r_hdmi_tx_oser10_reset)); 
	
endmodule
