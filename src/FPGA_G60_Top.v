`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// C-PHY receive debug top
//
// This top is intended for boards without DDR3. It brings up IMX586 through I2C,
// receives the C-PHY stream, and retains decoded CSI-2 signals for GAO capture.
//////////////////////////////////////////////////////////////////////////////////

module FPGA_G60_Top(
    input           clk_25m_i,

    // Frame activity indicator
    output  wire    led,

    // C-PHY RX trios
    inout           D0A,
    inout           D0B,
    inout           D0C,
    inout           D1A,
    inout           D1B,
    inout           D1C,
    inout           D2A,
    inout           D2B,
    inout           D2C,

    // IMX586 control interface
    output          OV_MCLK,
    output          OV_RST_N,
    output          OV_SCK,
    inout           OV_SDA
);

    parameter CLOCK_MAIN = 48000000;

    ////////////////////////////////////////////////////////////////////////
    // System clock and reset
    ////////////////////////////////////////////////////////////////////////
    wire w_sys_clk;
    wire w_sys_rst;
    wire w_sys_rstn;
    wire w_sys_lock;

    PLL_25_48 pll_system (
        .lock       (w_sys_lock),
        .clkout0    (w_sys_clk),
        .clkin      (clk_25m_i)
    );

    Reset rst_sys_clk (
        .clk_i      (w_sys_clk),
        .rstn_i     (1'b1),
        .locked_i   (w_sys_lock),
        .rstn_o     (w_sys_rstn),
        .rst_o      (w_sys_rst)
    );

    ////////////////////////////////////////////////////////////////////////
    // Sensor clock and I2C configuration
    ////////////////////////////////////////////////////////////////////////
    assign OV_RST_N = 1'b1;

    PLL_OV_24M u_PLL_OV_24M (
        .reset      (w_sys_rst),
        .clkin      (w_sys_clk),
        .clkout0    (OV_MCLK)
    );

    wire        i2c_sclk;
    wire        i2c_sdat;
    wire [9:0]  i2c_config_index;
    wire [23:0] i2c_config_data;
    wire [9:0]  i2c_config_size;
    wire        i2c_config_done;

    i2c_timing_ctrl_reg16_dat8_wronly #(
        .CLK_FREQ       (CLOCK_MAIN),
        .I2C_FREQ       (50_000)
    ) u_i2c_timing_ctrl_reg16_dat8_wronly (
        .clk            (w_sys_clk),
        .rst_n          (w_sys_rstn),
        .i2c_sclk       (i2c_sclk),
        .i2c_sdat       (i2c_sdat),
        .i2c_config_size(i2c_config_size),
        .i2c_config_index(i2c_config_index),
        .i2c_config_data({8'h34, i2c_config_data}),
        .i2c_config_done(i2c_config_done)
    );

    I2C_IMX586_Config u_I2C_IMX586_Config (
        .LUT_INDEX      (i2c_config_index),
        .LUT_DATA       (i2c_config_data),
        .LUT_SIZE       (i2c_config_size)
    );

    assign OV_SCK = i2c_sclk;
    assign OV_SDA = i2c_sdat;

    ////////////////////////////////////////////////////////////////////////
    // C-PHY clock and CSI-2 receiver
    ////////////////////////////////////////////////////////////////////////
    wire wCPHYclk_rstn /* synthesis syn_keep=1 */;
    wire wCPHYclk;

    PLL_CPHY_700sps u_PLL_CPHY_700sps (
        .lock       (wCPHYclk_rstn),
        .clkout0    (wCPHYclk),
        .clkin      (w_sys_clk),
        .reset      (w_sys_rst)
    );

    // The values must match the active IMX586 output mode.
    parameter HRES = 3840;
    parameter VRES = 2160;

    localparam [15:0] HBITS        = HRES * 10;
    localparam [15:0] WC_REF       = HBITS / 8;
    localparam [15:0] D96QUOTIENT  = HBITS / 96;
    localparam [15:0] D96REMAINDER = HBITS % 96;
    localparam [15:0] D96PERIOD    = D96QUOTIENT +
                                      ((D96REMAINDER > 0) ? 1'd1 : 1'd0);

    reg [15:0] RW_CPHY_CSI_VRES      = VRES;
    reg [15:0] RW_CPHY_CSI_WC_REF    = WC_REF;
    reg [15:0] RW_CPHY_CSI_D96PERIOD = D96PERIOD;

    // Decoder status signals retained for GAO capture.
    wire        RO_CPHY_CSI_STATE0ERR /* synthesis syn_keep=1 */;
    wire        RO_CPHY_CSI_WCERR     /* synthesis syn_keep=1 */;
    wire        RO_CPHY_CSI_HCNTERR   /* synthesis syn_keep=1 */;
    wire        RO_CPHY_CSI_VCNTERR   /* synthesis syn_keep=1 */;
    wire [15:0] RO_CPHY_CSI_FVSCNT    /* synthesis syn_keep=1 */;
    wire [15:0] RO_CPHY_CSI_FVECNT    /* synthesis syn_keep=1 */;

    // Primary GAO probes: all are synchronous to wCPHYclk.
    wire        wCPHYrxFvs       /* synthesis syn_keep=1 */;
    wire        wCPHYrxFve       /* synthesis syn_keep=1 */;
    wire [3:0]  wCPHYrxDe        /* synthesis syn_keep=1 */;
    wire        wCPHYrxEol       /* synthesis syn_keep=1 */;
    wire [95:0] wCPHYrxData      /* synthesis syn_keep=1 */;
    wire        cphy_test_io     /* synthesis syn_keep=1 */;
    wire        cphy_test_io2    /* synthesis syn_keep=1 */;

    CPHYrx u_CPHYrx (
        .RESET_N               (w_sys_rstn),
        .OSC_50M               (wCPHYclk),

        .D0A                   (D0A),
        .D0B                   (D0B),
        .D0C                   (D0C),
        .D1A                   (D1A),
        .D1B                   (D1B),
        .D1C                   (D1C),
        .D2A                   (D2A),
        .D2B                   (D2B),
        .D2C                   (D2C),

        .I_CPHYCLK             (wCPHYclk),
        .O_FVS                 (wCPHYrxFvs),
        .O_FVE                 (wCPHYrxFve),
        .O_DE                  (wCPHYrxDe),
        .O_EOL                 (wCPHYrxEol),
        .O_DATA                (wCPHYrxData),

        .RW_CPHY_CSI_VRES      (RW_CPHY_CSI_VRES),
        .RW_CPHY_CSI_WC_REF    (RW_CPHY_CSI_WC_REF),
        .RW_CPHY_CSI_D96PERIOD (RW_CPHY_CSI_D96PERIOD),

        .RO_CPHY_CSI_STATE0ERR (RO_CPHY_CSI_STATE0ERR),
        .RO_CPHY_CSI_WCERR     (RO_CPHY_CSI_WCERR),
        .RO_CPHY_CSI_HCNTERR   (RO_CPHY_CSI_HCNTERR),
        .RO_CPHY_CSI_VCNTERR   (RO_CPHY_CSI_VCNTERR),
        .RO_CPHY_CSI_FVSCNT    (RO_CPHY_CSI_FVSCNT),
        .RO_CPHY_CSI_FVECNT    (RO_CPHY_CSI_FVECNT),

        .test_io               (cphy_test_io),
        .test_io2              (cphy_test_io2)
    );

    // A visible, low-rate indication that decoded frame-start packets arrive.
    reg [5:0] r_frame_cnt /* synthesis syn_keep=1 */;
    always @(posedge wCPHYclk or negedge wCPHYclk_rstn) begin
        if (!wCPHYclk_rstn)
            r_frame_cnt <= 6'd0;
        else if (wCPHYrxFvs)
            r_frame_cnt <= r_frame_cnt + 1'b1;
    end

    assign led = r_frame_cnt[5];

endmodule
