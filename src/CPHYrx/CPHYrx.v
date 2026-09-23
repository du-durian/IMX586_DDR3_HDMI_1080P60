`include "../MACROS.vh"


module CPHYrx
(input                      RESET_N
,input                      OSC_50M

//! CPHY Ports
,inout                      D0A
,inout                      D0B
,inout                      D0C
,inout                      D1A
,inout                      D1B
,inout                      D1C
,inout                      D2A
,inout                      D2B
,inout                      D2C

//! PPI
,input                      I_CPHYCLK
,output                     O_FVS
,output                     O_FVE
,output     [3:0]           O_DE
,output                     O_EOL
,output     [95:0]          O_DATA                  // first--last

,output                     LED

,input      [15:0]          RW_CPHY_CSI_VRES        // for csi_rx_cphy to detect err
,input      [15:0]          RW_CPHY_CSI_WC_REF      // for csi_rx_cphy to detect err
,input      [15:0]          RW_CPHY_CSI_D96PERIOD   // for csi_rx_cphy to detect err

,output                     RO_CPHY_CSI_STATE0ERR   // 
,output                     RO_CPHY_CSI_WCERR       // 
,output                     RO_CPHY_CSI_HCNTERR     // 
,output                     RO_CPHY_CSI_VCNTERR     // 
,output     [15:0]          RO_CPHY_CSI_FVSCNT      //
,output     [15:0]          RO_CPHY_CSI_FVECNT      //

// FVS-to-FVS inferred frame completion diagnostics. These remain distinct
// from the received CSI-2 FVE packet outputs above.
,output                     O_FVE_INFERRED
,output                     RO_CPHY_CSI_FVS_FRAME_VALID
,output     [16:0]          RO_CPHY_CSI_FVS_EOLCNT
,output     [15:0]          RO_CPHY_CSI_FVS_FVECNT
,output                     RO_CPHY_CSI_FVS_VCNTERR

,output wire test_io
,output wire test_io2
,output wire [146:0] DBG_CPHY
);




reg         [ 2:0]          rLpEn               = 3'b111        ;
wire        [ 2:0]          wHsEn                               ;
wire        [ 2:0]          wOdtEn                              ;
wire                        wDRst                               ;
wire                        wDRstN              =!wDRst         ;

wire        [ 2:0]          wLpData     [2:0]                   ;
wire        [ 2:0]          wHsRxVld                            ;
wire        [41:0]          wHsRxD      [2:0]                   ;
wire        [ 1:0]          wHsRxWA     [2:0]                   ;
wire        [ 1:0]          wHsRxDMI    [2:0]                   ;

wire        [ 2:0]          wHsRxFRE                            ;
wire        [ 2:0]          wHsRxFWF                            ;
wire                        wRxWClk0                            ;
wire                        wRxWClk1                            ;
wire                        wRxWClk2                            ;
wire                        wRxWClkMux                          ;

wire                        drp_tieh_o                          ;
wire                        drp_tiel_o                          ;
wire                        mdrp_data_1bit_o                    ;
wire                        mipi_test_o                         ;
wire                        clk_test                            ;
wire        [7:0]           mdrp_rdata                          ;
wire        [2:0]           test_port                           ;
wire                        tx_clk_1x                           ;
wire [126:0]                wDbgCsi                             ;


MIPI_PHY_CTRL #
(.PHY_TYPE              ("CPHY"                 )
,.LANE                  (3                      )
,.HSEN_DLY              (4                      )
,.DRST_CNT              (4                      )
)u_MIPI_PHY_CTRL
(.I_RST                 (!RESET_N               )
,.I_CLK                 (I_CPHYCLK              )
,.I_LP_DATA             (wLpData[0]             )
,.O_PHY_ODT_EN          (wOdtEn                 )
,.O_PHY_HS_EN           (wHsEn                  )
,.O_PHY_DRST            (wDRst                  )
);



//delay wDRstN
reg   [19:0]                wDRstN_delay;
wire                        wDRstN_pos = wDRstN_delay[18] & ~wDRstN_delay[19];//wDRstN & ~wDRstN_d0;//

always @(posedge I_CPHYCLK or negedge RESET_N) begin
  if(!RESET_N) wDRstN_delay <= 20'Hfffff;
  else wDRstN_delay <= {wDRstN_delay[18:0], wDRstN};
end 





MIPI_CPHY u_mipi_cphy
//!-- global --
(.GPLL_CK0                                      (1'b0               )   // input            phase 0 high clock.
,.GPLL_CK90                                     (1'b0               )   // input            phase 00 high clock.
,.GPLL_CK180                                    (1'b0               )   // input            phase 180 high clock.
,.GPLL_CK270                                    (1'b0               )   // input            phase 270 high clock.
    
,.SPLL0_CKN                                     (1'b0               )   // input            serdes pll0 high clock.
,.SPLL0_CKP                                     (1'b0               )   // input            serdes pll0 high clock.
,.SPLL1_CKN                                     (1'b0               )   // input            serdes pll1 high clock.
,.SPLL1_CKP                                     (1'b0               )   // input            serdes pll1 high clock.
    
    
//!-- MDRP --   
,.MDRP_CLK_I                                    (1'd0               )   // input            mdrp clk from port interface
,.MDRP_OPCODE_I                                 (2'b00              )   // input  [1:0]     mdrp opcode; [1:0]
                                                                        //                       2'b00: noop
                                                                        //                       2'b01: write
                                                                        //                       2'b10: read
                                                                        //                       2'b11: shift(only used in 1-bit mode)
,.MDRP_A_INC_I                                  (1'b0               )   // input            mdrp address increase signal, active high
,.MDRP_A_D_I                                    (8'h00              )   // input  [7:0]     mdrp write data, only bit[0] is used in 1-bit mode; [7:0]
,.MDRP_RDATA                                    (                   )   // output [7:0]     mdrp read data, only bit[0] is used in 1-bit mode
    
    
//!-- pins --   
,.D0A                                           (D0A                )   // inout    
,.D0B                                           (D0B                )   // inout    
,.D0C                                           (D0C                )   // inout    
,.D1A                                           (D1A                )   // inout    
,.D1B                                           (D1B                )   // inout    
,.D1C                                           (D1C                )   // inout    
,.D2A                                           (D2A                )   // inout    
,.D2B                                           (D2B                )   // inout    
,.D2C                                           (D2C                )   // inout    
    
    
    
//!-- LPRX fabric --   
,.LPRX_EN_D0                                    (1'b1               )   // input            Data Lane0: 1'b1 LPRX enabled
,.LPRX_EN_D1                                    (1'b1               )   // input            Data Lane1: 1'b1 LPRX enabled
,.LPRX_EN_D2                                    (1'b1               )   // input            Data Lane2: 1'b1 LPRX enabled
,.DI_LPRX0_A                                    (wLpData[0][2]      )   // output           Data lane0: received LPRX true data_a
,.DI_LPRX0_B                                    (wLpData[0][1]      )   // output           Data lane0: received LPRX true data_b
,.DI_LPRX0_C                                    (wLpData[0][0]      )   // output           Data lane0: received LPRX true data_c
,.DI_LPRX1_A                                    (wLpData[1][2]      )   // output           Data lane1: received LPRX true data_a
,.DI_LPRX1_B                                    (wLpData[1][1]      )   // output           Data lane1: received LPRX true data_b
,.DI_LPRX1_C                                    (wLpData[1][0]      )   // output           Data lane1: received LPRX true data_c
,.DI_LPRX2_A                                    (wLpData[2][2]      )   // output           Data lane2: received LPRX true data_a
,.DI_LPRX2_B                                    (wLpData[2][1]      )   // output           Data lane2: received LPRX true data_b
,.DI_LPRX2_C                                    (wLpData[2][0]      )   // output           Data lane2: received LPRX true data_c
    
    
//!-- HSRX fabric --   
,.PWRON_RX_LN0                                  (1'b1               )   // input            Data Lane0: PowerOn Control: 1'b1: HSRX on; 1'b0: HSRX off to standby in low power state
,.PWRON_RX_LN1                                  (1'b1               )   // input            Data Lane1: PowerOn Control: 1'b1: HSRX on; 1'b0: HSRX off to standby in low power state
,.PWRON_RX_LN2                                  (1'b1               )   // input            Data Lane2: PowerOn Control: 1'b1: HSRX on; 1'b0: HSRX off to standby in low power state
    
,.ARST_RXLN0                                    (!RESET_N           )   // input            Data Lane0: MIPI RX reset (analog?) . 1: reset.
,.ARST_RXLN1                                    (!RESET_N           )   // input            Data Lane1: MIPI RX reset (analog?) . 1: reset.
,.ARST_RXLN2                                    (!RESET_N           )   // input            Data Lane2: MIPI RX reset (analog?) . 1: reset.
    
,.D0LN_RX_CLK_1X_I                              (I_CPHYCLK          )   // input            Lane 0, 1x clock from fabric
,.D1LN_RX_CLK_1X_I                              (I_CPHYCLK          )   // input            Lane 1, 1x clock from fabric
,.D2LN_RX_CLK_1X_I                              (I_CPHYCLK          )   // input            Lane 2, 1x clock from fabric
,.D0LN_RX_CLK_1X_O                              (                   )   // output           Lane 0, RX output 1x clock
,.D1LN_RX_CLK_1X_O                              (                   )   // output           Lane 1, RX output 1x clock
,.D2LN_RX_CLK_1X_O                              (                   )   // output           Lane 2, RX output 1x clock
,.RX_CLK_MUXED                                  (                   )   // output           3 mux 1 RX output 1x clock   ??  Selected by RX_OUTCLK_SEL  ??
    
,.D0LN_RX_DRST_N                                (wDRstN             )   // input            rx digital reset, active low, from CIB, reset all the RX lanes 0
,.D1LN_RX_DRST_N                                (wDRstN             )   // input            rx digital reset, active low, from CIB, reset all the RX lanes 1
,.D2LN_RX_DRST_N                                (wDRstN             )   // input            rx digital reset, active low, from CIB, reset all the RX lanes 2
    
,.RX_CLK_EN_LN0                                 (1'b1               )   // input            Data Lane0: t3-SETTLE_expired control rx clock gating
,.RX_CLK_EN_LN1                                 (1'b1               )   // input            Data Lane1: t3-SETTLE_expired control rx clock gating
,.RX_CLK_EN_LN2                                 (1'b1               )   // input            Data Lane2: t3-SETTLE_expired control rx clock gating
    
,.D0LN_HSRX_EN                                  (1'b1               )   // input            data lane enable for lane 0 , also data lane function/input data enable
,.D1LN_HSRX_EN                                  (1'b1               )   // input            data lane enable for lane 1 , also data lane function/input data enable
,.D2LN_HSRX_EN                                  (1'b1               )   // input            data lane enable for lane 2 , also data lane function/input data enable
,.HSRX_EN_D0                                    (wHsEn[0]           )   // input            Data Lane0: 1'b1 HSRX enabled
,.HSRX_EN_D1                                    (wHsEn[1]           )   // input            Data Lane1: 1'b1 HSRX enabled
,.HSRX_EN_D2                                    (wHsEn[2]           )   // input            Data Lane2: 1'b1 HSRX enabled
,.HSRX_ODT_EN_D0                                (wOdtEn[0]          )   // input            Data Lane0: 1'b1 ODT enabled
,.HSRX_ODT_EN_D1                                (wOdtEn[1]          )   // input            Data Lane1: 1'b1 ODT enabled
,.HSRX_ODT_EN_D2                                (wOdtEn[2]          )   // input            Data Lane2: 1'b1 ODT enabled
,.D0LN_HSRXD_VLD                                (wHsRxVld[0]        )   // output           output data valid to fabric for lane 0, preamble data is output as the valid data
,.D1LN_HSRXD_VLD                                (wHsRxVld[1]        )   // output           output data valid to fabric for lane 1, preamble data is output as the valid data
,.D2LN_HSRXD_VLD                                (wHsRxVld[2]        )   // output           output data valid to fabric for lane 2, preamble data is output as the valid data
                                                                        //                       Be discontinuous when fabric clock is greater than the pma_dNln_rx_clk_2x (They are asynchronous clocks)
                                                                        //                       Be continuous when fabric clock is equal to pma_dNln_rx_clk_2x (They are asynchronous /synchronous clocks )
,.D0LN_HSRX_WA                                  (wHsRxWA[0]         )   // output [1:0]     aligned data indication for the packet data of lane 0
,.D1LN_HSRX_WA                                  (wHsRxWA[1]         )   // output [1:0]     aligned data indication for the packet data of lane 1
,.D2LN_HSRX_WA                                  (wHsRxWA[2]         )   // output [1:0]     aligned data indication for the packet data of lane 2
                                                                        //                       0: not aligned data, 1: aligned data
,.D0LN_HSRX_DEMAP_INVLD                         (wHsRxDMI[0]        )   // output [1:0]     not de-mapped data indication signal for lane 0; [1:0] -> [41:21, 20:0]
,.D1LN_HSRX_DEMAP_INVLD                         (wHsRxDMI[1]        )   // output [1:0]     not de-mapped data indication signal for lane 1; [1:0] -> [41:21, 20:0]
,.D2LN_HSRX_DEMAP_INVLD                         (wHsRxDMI[2]        )   // output [1:0]     not de-mapped data indication signal for lane 2; [1:0] -> [41:21, 20:0]
                                                                        //                       0: be de-mappped, 1: not be de-mapped, output the symbol data
,.D0LN_HSRXD                                    (wHsRxD[0]          )   // output [41:0]    output data to fabric for lane 0, refer to the Bit map figure; [41:0]
,.D1LN_HSRXD                                    (wHsRxD[1]          )   // output [41:0]    output data to fabric for lane 1, refer to the Bit map figure; [41:0]
,.D2LN_HSRXD                                    (wHsRxD[2]          )   // output [41:0]    output data to fabric for lane 2, refer to the Bit map figure; [41:0]
    
,.D0LN_HSRX_FIFO_RDE_ERR                        (wHsRxFRE[0]        )   // output           lane FIFO read empty error indication for lane 0
,.D1LN_HSRX_FIFO_RDE_ERR                        (wHsRxFRE[1]        )   // output           lane FIFO read empty error indication for lane 1
,.D2LN_HSRX_FIFO_RDE_ERR                        (wHsRxFRE[2]        )   // output           lane FIFO read empty error indication for lane 2
,.D0LN_HSRX_FIFO_WRF_ERR                        (wHsRxFWF[0]        )   // output           lane FIFO write full error indication for lane 0
,.D1LN_HSRX_FIFO_WRF_ERR                        (wHsRxFWF[1]        )   // output           lane FIFO write full error indication for lane 1
,.D2LN_HSRX_FIFO_WRF_ERR                        (wHsRxFWF[2]        )   // output           lane FIFO write full error indication for lane 2







//!-- LPTX fabric --
,.LPTX_ENLN0                                    (1'b0               )   // input            Data lane0: LPTX enable.
,.LPTX_ENLN1                                    (1'b0               )   // input            Data lane1: LPTX enable.
,.LPTX_ENLN2                                    (1'b0               )   // input            Data lane2: LPTX enable.
    
,.DO_LPTX_A_LN0                                 (1'b0               )   // input            Data lane0: LPTX line-a data.
,.DO_LPTX_A_LN1                                 (1'b0               )   // input            Data lane0: LPTX line-b data.
,.DO_LPTX_A_LN2                                 (1'b0               )   // input            Data lane0: LPTX line-c data.
,.DO_LPTX_B_LN0                                 (1'b0               )   // input            Data lane1: LPTX line-a data.
,.DO_LPTX_B_LN1                                 (1'b0               )   // input            Data lane1: LPTX line-b data.
,.DO_LPTX_B_LN2                                 (1'b0               )   // input            Data lane1: LPTX line-c data.
,.DO_LPTX_C_LN0                                 (1'b0               )   // input            Data lane2: LPTX line-a data.
,.DO_LPTX_C_LN1                                 (1'b0               )   // input            Data lane2: LPTX line-b data.
,.DO_LPTX_C_LN2                                 (1'b0               )   // input            Data lane2: LPTX line-c data.
    
    
    
//!-- HSTX fabric --   
,.PWRON_TX                                      (1'b0               )   // input            TX PowerOn Control: 1'b1: HSTX on; 1'b0: HSTX off to standby in low power state
,.ARSTN_TX                                      (1'b1               )   // input             reset of tx, 1'b0:reset
    
,.TX_CLK_1X_I                                   (I_CPHYCLK          )   // input            1x clock from fabric(max>=178.57MHz)
,.TX_CLK_1X_O                                   (                   )   // output           TX output 1x clock (max=178.57MHz)
    
,.TXDP_ENLN0                                    (1'b0               )   // input            Data lane0: MIPI TX datapath enable.
,.TXDP_ENLN1                                    (1'b0               )   // input            Data lane1: MIPI TX datapath enable.
,.TXDP_ENLN2                                    (1'b0               )   // input            Data lane2: MIPI TX datapath enable.
,.TXHCLK_EN                                     (1'b0               )   // input            MIPI high clock enable.
    
,.D0LN_TX_DRST_N                                (1'b0               )   // input            tx digital reset, active low, from CIB, reset all the RX lanes 0
,.D1LN_TX_DRST_N                                (1'b0               )   // input            tx digital reset, active low, from CIB, reset all the RX lanes 1
,.D2LN_TX_DRST_N                                (1'b0               )   // input            tx digital reset, active low, from CIB, reset all the RX lanes 2
,.D0LN_HSTX_EN                                  (1'b0               )   // input            data lane enable for lane 0, also data lane function/input data enable
,.D1LN_HSTX_EN                                  (1'b0               )   // input            data lane enable for lane 1, also data lane function/input data enable
,.D2LN_HSTX_EN                                  (1'b0               )   // input            data lane enable for lane 2, also data lane function/input data enable
,.HSTX_ENLN0                                    (1'b0               )   // input            Data lane0: HS tx driver enable.
,.HSTX_ENLN1                                    (1'b0               )   // input            Data lane1: HS tx driver enable.
,.HSTX_ENLN2                                    (1'b0               )   // input            Data lane2: HS tx driver enable.
,.D0LN_HSTX_DATA_VLD                            (1'b0               )   // input            input data valid from fabric for lane 0
,.D1LN_HSTX_DATA_VLD                            (1'b0               )   // input            input data valid from fabric for lane 1
,.D2LN_HSTX_DATA_VLD                            (1'b0               )   // input            input data valid from fabric for lane 2
,.D0LN_HSTX_MAP_DIS                             (2'b00              )   // input  [1:0]     not mapped data indication signal for lane 0; [1:0] -> [41:21, 20:0]
,.D1LN_HSTX_MAP_DIS                             (2'b00              )   // input  [1:0]     not mapped data indication signal for lane 1; [1:0] -> [41:21, 20:0]
,.D2LN_HSTX_MAP_DIS                             (2'b00              )   // input  [1:0]     not mapped data indication signal for lane 2; [1:0] -> [41:21, 20:0]
                                                                        //                       0: mapped, within the range of 0~65535
                                                                        //                       1: not mapped, output the symbol data
,.D0LN_HSTX_DATA                                (42'b0              )   // input  [41:0]    input data from fabric for lane 0, refer to the Bit map figure; [41:0]
,.D1LN_HSTX_DATA                                (42'b0              )   // input  [41:0]    input data from fabric for lane 1, refer to the Bit map figure; [41:0]
,.D2LN_HSTX_DATA                                (42'b0              )   // input  [41:0]    input data from fabric for lane 2, refer to the Bit map figure; [41:0]
    
,.HSTX_FIFO_AE                                  (                   )   // output           the TX FIFO read almost empty indication
,.HSTX_FIFO_AF                                  (                   )   // output           the TX FIFO write almost full indication
,.HSTX_FIFO_RDE_ERR                             (                   )   // output           3 lane FIFO read empty error indication
,.HSTX_FIFO_WRF_ERR                             (                   )   // output           3 lane FIFO write full error indication
);

defparam u_mipi_cphy.D0LN_HS_TX_EN = 1'b0; //data lane HS TX enable; 1=enable,0=disable
defparam u_mipi_cphy.D1LN_HS_TX_EN = 1'b0;
defparam u_mipi_cphy.D2LN_HS_TX_EN = 1'b0;
defparam u_mipi_cphy.D0LN_HS_RX_EN = 1'b1; //data lane HS RX enable; 1=enable,0=disable
defparam u_mipi_cphy.D1LN_HS_RX_EN = 1'b1;
defparam u_mipi_cphy.D2LN_HS_RX_EN = 1'b1;

defparam u_mipi_cphy.TX_HS_21BIT_MODE = 1'b0; //Selection of tx data width from Fabric;1=21bit input mode,0=42bit input mode
defparam u_mipi_cphy.RX_OUTCLK_SEL = 2'b00; //the RX out clock to global buffer selection; 00: lane0 RX clk,01: lane1 RX clk, 10: lane2 RX clk, 11: 1'b0
defparam u_mipi_cphy.TX_W_LENDIAN = 1'b1; //in 42-bit mode use this bit to set which byte will be sent out firstly; 0=send out higher 21-bit data firstly, 1=send out lower 21-bit data firstly

defparam u_mipi_cphy.CLK_SEL = 2'b00; //MIPI TX lane clk select: 00:gpll;01:spll0; 1x:spll1
defparam u_mipi_cphy.LNDIV_RATIO = 4'b0000; //MIPI TX lane divider ratio config. 0000~1111: /2 ~ /30.
defparam u_mipi_cphy.LNDIV_EN = 1'b0; //MIPI TX lane divide enable

defparam u_mipi_cphy.D0LN_TX_REASGN_A = 2'b00; //the data of the lane0 pina can be reassigned to pina,pinb or pinc; 00=connected to  pina, 01=connected to  pinb, 1x=connected to  pinc
defparam u_mipi_cphy.D0LN_TX_REASGN_B = 2'b01; //the data of the lane0 pinb can be reassigned to pina,pinb or pinc; 00=connected to  pina, 01=connected to  pinb, 1x=connected to  pinc
defparam u_mipi_cphy.D0LN_TX_REASGN_C = 2'b10; //the data of the lane0 pinc can be reassigned to pina,pinb or pinc; 00=connected to  pina, 01=connected to  pinb, 1x=connected to  pinc
defparam u_mipi_cphy.D0LN_RX_HS_21BIT_MODE = 1'b0; //Selection of lane0 rx data width to Fabric; 1=21bit input mode,0=42bit input mode

defparam u_mipi_cphy.D0LN_RX_WA_SYNC_PAT0_EN = 1'b1;  //lane0 word aligner sync pattern0(default:44444) enable; 1=enable to detect sync pattern0, 0=disable
defparam u_mipi_cphy.D0LN_RX_WA_SYNC_PAT0_H = 7'b1001001;  //the higher 7-bit sync pat0 value(sync pat0  includes the 5-symbol(15-bit), 'h49
defparam u_mipi_cphy.D0LN_RX_WA_SYNC_PAT0_L = 8'b00100100;  //the lower 8-bit sync pat0 value(sync pat0  includes the 5-symbol(15-bit), 'h24
defparam u_mipi_cphy.D0LN_RX_WA_SYNC_PAT1_EN = 1'b1;  //lane0 word aligner sync pattern1(default:44444) enable; 1=enable to detect sync pattern1, 0=disable
defparam u_mipi_cphy.D0LN_RX_WA_SYNC_PAT1_H = 7'b0101001;  //the higher 7-bit sync pat1 value(sync pat1  includes the 5-symbol(15-bit), 'h29
defparam u_mipi_cphy.D0LN_RX_WA_SYNC_PAT1_L = 8'b00100100;  //the lower 8-bit sync pat1 value(sync pat1  includes the 5-symbol(15-bit), 'h24
defparam u_mipi_cphy.D0LN_RX_WA_SYNC_PAT2_EN = 1'b1;  //lane0 word aligner sync pattern2(default:44444) enable; 1=enable to detect sync pattern2, 0=disable
defparam u_mipi_cphy.D0LN_RX_WA_SYNC_PAT2_H = 7'b0011001;  //the higher 7-bit sync pat2 value(sync pat2  includes the 5-symbol(15-bit), 'h19
defparam u_mipi_cphy.D0LN_RX_WA_SYNC_PAT2_L = 8'b00100100;  //the lower 8-bit sync pat2 value(sync pat2  includes the 5-symbol(15-bit), 'h24
defparam u_mipi_cphy.D0LN_RX_WA_SYNC_PAT3_EN = 1'b0;  //lane0 word aligner sync pattern3(default:44444) enable; 1=enable to detect sync pattern3, 0=disable
defparam u_mipi_cphy.D0LN_RX_WA_SYNC_PAT3_H = 7'b0001001;  //the higher 7-bit sync pat3 value(sync pat3  includes the 5-symbol(15-bit), 'h09
defparam u_mipi_cphy.D0LN_RX_WA_SYNC_PAT3_L = 8'b00100100;  //the lower 8-bit sync pat2 value(sync pat2  includes the 5-symbol(15-bit), 'h24

defparam u_mipi_cphy.D0LN_RX_W_LENDIAN = 1'b1;  //in 42-bit mode use this bit to set which byte will be sent in firstly for the lane0; 0= put the received data to the higher 21-bit data firstly, 1= put the received data to the lower 21-bit data firstly

defparam u_mipi_cphy.D0LN_RX_REASGN_A = 2'b00; //the data of the lane0 pina can be reassigned to pina ; pinb or pinc; 00=connected to pina, 01=connected to pinb, 1x=connected to pinc
defparam u_mipi_cphy.D0LN_RX_REASGN_B = 2'b01; //the data of the lane0 pinb can be reassigned to pina ; pinb or pinc; 00=connected to pina, 01=connected to pinb, 1x=connected to pinc
defparam u_mipi_cphy.D0LN_RX_REASGN_C = 2'b10; //the data of the lane0 pinc can be reassigned to pina ; pinb or pinc; 00=connected to pina, 01=connected to pinb, 1x=connected to pinc

defparam u_mipi_cphy.HSRX_LNSEL = 3'b111; //Data Lane Select: each bit controls a lane, [0]=1'b1 Lane0 on,[1]=1'b1 Lane2 on,[2]=1'b1 Lane2 on

defparam u_mipi_cphy.EQ_RS_LN0 = 3'b001; //Data lane0: EQ degeneration resistor control. (mc1_eq_rs_lane0[2:0]=eq_rs_lane0[2:0])
defparam u_mipi_cphy.EQ_CS_LN0 = 3'b101; //Data lane0: EQ degeneration cap control.(mc1_eq_cs_lane0[2:0]=eq_cs_lane0[2:0])
defparam u_mipi_cphy.PGA_GAIN_LN0 = 4'b0110; //Data lane1: PGA amplifier gain config.
defparam u_mipi_cphy.PGA_BIAS_LN0 = 4'b1000; //Data lane1: PGA amplifier tail current config.
defparam u_mipi_cphy.EQ_PBIAS_LN0 = 4'b0100; //Data Lane0: Equalizer source current setting  default 4'b1000
defparam u_mipi_cphy.EQ_ZLD_LN0 = 4'b1000; //Data Lane0: Preamplifier Resistive Load Setting: 4'b0000  smallest res loading

defparam u_mipi_cphy.D1LN_TX_REASGN_A = 2'b00; //the data of the lane1 pina can be reassigned to pina ; pinb or pinc; 00=connected to  pina,01=connected to  pinb,1x=connected to  pinc
defparam u_mipi_cphy.D1LN_TX_REASGN_B = 2'b01; //the data of the lane1 pinb can be reassigned to pina ; pinb or pinc;00=connected to  pina,01=connected to  pinb,1x=connected to  pinc
defparam u_mipi_cphy.D1LN_TX_REASGN_C = 2'b10; //the data of the lane1 pinc can be reassigned to pina ; pinb or pinc;00=connected to  pina,01=connected to  pinb,1x=connected to  pinc
defparam u_mipi_cphy.D1LN_RX_HS_21BIT_MODE = 1'b0; //Selection of lane1 rx data width to Fabric;1=21bit input mode,0=42bit input mode

defparam u_mipi_cphy.D1LN_RX_WA_SYNC_PAT0_EN = 1'b1;  //lane1 word aligner sync pattern0(default:44444) enable;1=enable to detect sync pattern0, 0=disable
defparam u_mipi_cphy.D1LN_RX_WA_SYNC_PAT0_H = 7'b1001001;  //the higher 7-bit sync pat0 value(sync pat0  includes the 5-symbol(15-bit)
defparam u_mipi_cphy.D1LN_RX_WA_SYNC_PAT0_L = 8'b00100100;  //the lower 8-bit sync pat0 value(sync pat0  includes the 5-symbol(15-bit)
defparam u_mipi_cphy.D1LN_RX_WA_SYNC_PAT1_EN = 1'b1;  //lane1 word aligner sync pattern1(default:24444) enable;1=enable to detect sync pattern1,0=disable
defparam u_mipi_cphy.D1LN_RX_WA_SYNC_PAT1_H = 7'b0101001;  //the higher 7-bit sync pat1 value(sync pat1  includes the 5-symbol(15-bit)
defparam u_mipi_cphy.D1LN_RX_WA_SYNC_PAT1_L = 8'b00100100;  //the lower 8-bit sync pat1 value(sync pat1  includes the 5-symbol(15-bit)
defparam u_mipi_cphy.D1LN_RX_WA_SYNC_PAT2_EN = 1'b1;  //lane1 word aligner sync pattern2(default:14444) enable;1=enable to detect sync pattern2,0=disable
defparam u_mipi_cphy.D1LN_RX_WA_SYNC_PAT2_H = 7'b0011001;  //the higher 7-bit sync pat2 value(sync pat2  includes the 5-symbol(15-bit)
defparam u_mipi_cphy.D1LN_RX_WA_SYNC_PAT2_L = 8'b00100100;  //the lower 8-bit sync pat2 value(sync pat2  includes the 5-symbol(15-bit)
defparam u_mipi_cphy.D1LN_RX_WA_SYNC_PAT3_EN = 1'b0;  //lane1 word aligner sync pattern3(default:04444) enable;1=enable to detect sync pattern3,0=disable
defparam u_mipi_cphy.D1LN_RX_WA_SYNC_PAT3_H = 7'b0001001;  //the higher 7-bit sync pat3 value(sync pat3  includes the 5-symbol(15-bit)
defparam u_mipi_cphy.D1LN_RX_WA_SYNC_PAT3_L = 8'b00100100;  //the lower 8-bit sync pat3 value(sync pat3  includes the 5-symbol(15-bit)
defparam u_mipi_cphy.D1LN_RX_W_LENDIAN = 1'b1;  //in 42-bit mode use this bit to set which byte will be sent in firstly for the lane1;0= put the received data to the higher 21-bit data firstly,1= put the received data to the lower 21-bit data firstly

defparam u_mipi_cphy.D1LN_RX_REASGN_A = 2'b00; //the data of the lane1 pina can be reassigned to pina ; pinb or pinc; 00=connected to pina,01=connected to pinb,1x=connected to
defparam u_mipi_cphy.D1LN_RX_REASGN_B = 2'b01; //the data of the lane1 pinb can be reassigned to pina ; pinb or pinc; 00=connected to pina,01=connected to pinb,1x=connected to pinc
defparam u_mipi_cphy.D1LN_RX_REASGN_C = 2'b10; //the data of the lane1 pinc can be reassigned to pina ; pinb or pinc; 00=connected to pina,01=connected to pinb,1x=connected to pinc

defparam u_mipi_cphy.EQ_RS_LN1 = 3'b001; //Data lane1: EQ degeneration resistor control.    (mc1_eq_rs_lane0[2:0]=eq_rs_lane0[2:0])
defparam u_mipi_cphy.EQ_CS_LN1 = 3'b101; //Data lane1: EQ degeneration cap control.(mc1_eq_cs_lane0[2:0]=eq_cs_lane0[2:0])
defparam u_mipi_cphy.PGA_GAIN_LN1 = 4'b0110; //Data lane1: PGA amplifier gain config.
defparam u_mipi_cphy.PGA_BIAS_LN1 = 4'b1000; //Data lane1: PGA amplifier tail current config.
defparam u_mipi_cphy.EQ_PBIAS_LN1 = 4'b0100; //Data Lane1: Equalizer source current setting  default 4'b1000
defparam u_mipi_cphy.EQ_ZLD_LN1 = 4'b1000; //Data Lane1: Preamplifier Resistive Load Setting: 4'b0000  smallest res loading

defparam u_mipi_cphy.D2LN_TX_REASGN_A = 2'b00; //the data of the lane2 pina can be reassigned to pina ; pinb or pinc; 00=connected to  pina,01=connected to  pinb,1x=connected to  pinc
defparam u_mipi_cphy.D2LN_TX_REASGN_B = 2'b01; //the data of the lane2 pinb can be reassigned to pina ; pinb or pinc; 00=connected to  pina,01=connected to  pinb,1x=connected to  pinc
defparam u_mipi_cphy.D2LN_TX_REASGN_C = 2'b10; //the data of the lane2 pinc can be reassigned to pina ; pinb or pinc; 00=connected to  pina,01=connected to  pinb,1x=connected to  pinc
defparam u_mipi_cphy.D2LN_RX_HS_21BIT_MODE = 1'b0; //Selection of lane2 rx data width to Fabric;1=21bit input mode,0=42bit input mode

defparam u_mipi_cphy.D2LN_RX_WA_SYNC_PAT0_EN = 1'b1;  //lane2 word aligner sync pattern0(default:44444) enable;1=enable to detect sync pattern0, 0=disable
defparam u_mipi_cphy.D2LN_RX_WA_SYNC_PAT0_H = 7'b1001001;  //the higher 7-bit sync pat0 value(sync pat0  includes the 5-symbol(15-bit)
defparam u_mipi_cphy.D2LN_RX_WA_SYNC_PAT0_L = 8'b00100100;  //the lower 8-bit sync pat0 value(sync pat0  includes the 5-symbol(15-bit)
defparam u_mipi_cphy.D2LN_RX_WA_SYNC_PAT1_EN = 1'b1;  //lane2 word aligner sync pattern1(default:24444) enable;1=enable to detect sync pattern1,0=disable
defparam u_mipi_cphy.D2LN_RX_WA_SYNC_PAT1_H = 7'b0101001;  //the higher 7-bit sync pat1 value(sync pat1  includes the 5-symbol(15-bit)
defparam u_mipi_cphy.D2LN_RX_WA_SYNC_PAT1_L = 8'b00100100;  //the lower 8-bit sync pat1 value(sync pat1  includes the 5-symbol(15-bit)
defparam u_mipi_cphy.D2LN_RX_WA_SYNC_PAT2_EN = 1'b1;  //lane2 word aligner sync pattern2(default:14444) enable;1=enable to detect sync pattern2,0=disable
defparam u_mipi_cphy.D2LN_RX_WA_SYNC_PAT2_H = 7'b0011001;  //the higher 7-bit sync pat2 value(sync pat2  includes the 5-symbol(15-bit)
defparam u_mipi_cphy.D2LN_RX_WA_SYNC_PAT2_L = 8'b00100100;  //the lower 8-bit sync pat2 value(sync pat2  includes the 5-symbol(15-bit)
defparam u_mipi_cphy.D2LN_RX_WA_SYNC_PAT3_EN = 1'b0;  //lane2 word aligner sync pattern3(default:04444) enable;1=enable to detect sync pattern3,0=disable
defparam u_mipi_cphy.D2LN_RX_WA_SYNC_PAT3_H = 7'b0001001;  //the higher 7-bit sync pat3 value(sync pat3  includes the 5-symbol(15-bit)
defparam u_mipi_cphy.D2LN_RX_WA_SYNC_PAT3_L = 8'b00100100;  //the lower 8-bit sync pat3 value(sync pat3  includes the 5-symbol(15-bit)
defparam u_mipi_cphy.D2LN_RX_W_LENDIAN = 1'b1;  //in 42-bit mode use this bit to set which byte will be sent in firstly for the lane2; 0= put the received data to the higher 21-bit data firstly,1= put the received data to the lower 21-bit data firstly

defparam u_mipi_cphy.D2LN_RX_REASGN_A = 2'b00; //the data of the lane2 pina can be reassigned to pina ; pinb or pinc; 00=connected to pina,01=connected to pinb,1x=connected to pinc
defparam u_mipi_cphy.D2LN_RX_REASGN_B = 2'b01; //the data of the lane2 pinb can be reassigned to pina ; pinb or pinc; 00=connected to pina,01=connected to pinb,1x=connected to pinc
defparam u_mipi_cphy.D2LN_RX_REASGN_C = 2'b10; //the data of the lane2 pinc can be reassigned to pina ; pinb or pinc; 00=connected to pina,01=connected to pinb,1x=connected to pinc

defparam u_mipi_cphy.EQ_RS_LN2 = 3'b001; //Data lane2: EQ degeneration resistor control.    (mc1_eq_rs_lane0[2:0]=eq_rs_lane0[2:0])
defparam u_mipi_cphy.EQ_CS_LN2 = 3'b101; //Data lane2: EQ degeneration cap control.(mc1_eq_cs_lane0[2:0]=eq_cs_lane0[2:0])
defparam u_mipi_cphy.PGA_GAIN_LN2 = 4'b0110; //Data lane2: PGA amplifier gain config.
defparam u_mipi_cphy.PGA_BIAS_LN2 = 4'b1000; //Data lane2: PGA amplifier tail current config.
defparam u_mipi_cphy.EQ_PBIAS_LN2 = 4'b0100; //Data Lane2: Equalizer source current setting  default 4'b1000
defparam u_mipi_cphy.EQ_ZLD_LN2 = 4'b1000; //Data Lane2: Preamplifier Resistive Load Setting: 4'b0000  smallest res loading





reg  [ 8:0] rLpData     = 9'h1FF /* synthesis syn_preserve = 1 */;
reg  [ 2:0] rHsRxVld    = 3'b000 /* synthesis syn_preserve = 1 */;

reg  [41:0] rHsRxD0         /* synthesis syn_preserve = 1 */;
reg  [41:0] rHsRxD1         /* synthesis syn_preserve = 1 */;
reg  [41:0] rHsRxD2         /* synthesis syn_preserve = 1 */;
reg  [ 1:0] rHsRxWA0        /* synthesis syn_preserve = 1 */;
reg  [ 1:0] rHsRxWA1        /* synthesis syn_preserve = 1 */;
reg  [ 1:0] rHsRxWA2        /* synthesis syn_preserve = 1 */;
reg  [ 1:0] rHsRxDMI0       /* synthesis syn_preserve = 1 */;
reg  [ 1:0] rHsRxDMI1       /* synthesis syn_preserve = 1 */;
reg  [ 1:0] rHsRxDMI2       /* synthesis syn_preserve = 1 */;

reg  [ 2:0] rHsRxFRE    ;
reg  [ 2:0] rHsRxFWF    ;

always @(posedge I_CPHYCLK) begin
    rLpData     <= { wLpData[2], wLpData[1], wLpData[0] };
    rHsRxVld    <= wHsRxVld;
    
    rHsRxD0     <= wHsRxD[0];
    rHsRxD1     <= wHsRxD[1];
    rHsRxD2     <= wHsRxD[2];

    rHsRxWA0    <= wHsRxWA[0];
    rHsRxWA1    <= wHsRxWA[1];
    rHsRxWA2    <= wHsRxWA[2];

    rHsRxDMI0   <= wHsRxDMI[0];
    rHsRxDMI1   <= wHsRxDMI[1];
    rHsRxDMI2   <= wHsRxDMI[2];

    rHsRxFRE    <= wHsRxFRE;
    rHsRxFWF    <= wHsRxFWF;
end




wire [ 2*3-1:0] wHsWA       = {  rHsRxWA2,  rHsRxWA1,  rHsRxWA0};
wire [ 2*3-1:0] wHsDMI      = { rHsRxDMI2, rHsRxDMI1, rHsRxDMI0};
wire [32*3-1:0] wHsWord     = { rHsRxD2[36:21], rHsRxD2[15:0]
                              , rHsRxD1[36:21], rHsRxD1[15:0]
                              , rHsRxD0[36:21], rHsRxD0[15:0]
                              };
                              

reg  [ 2:0]     rHsRxDly1Vld  =3'b000 /* synthesis syn_preserve = 1 */;
reg  [ 2*3-1:0] rHsRxDly1WA   ='d0    /* synthesis syn_preserve = 1 */;
reg  [ 2*3-1:0] rHsRxDly1DMI  ='d0    /* synthesis syn_preserve = 1 */;
reg  [32*3-1:0] rHsRxDly1Word ='d0    /* synthesis syn_preserve = 1 */;

reg  [ 2:0]     rHsRxDly2Vld  =3'b000 /* synthesis syn_preserve = 1 */;
reg  [ 2*3-1:0] rHsRxDly2WA   ='d0    /* synthesis syn_preserve = 1 */;
reg  [ 2*3-1:0] rHsRxDly2DMI  ='d0    /* synthesis syn_preserve = 1 */;
reg  [32*3-1:0] rHsRxDly2Word ='d0    /* synthesis syn_preserve = 1 */;

always @(posedge I_CPHYCLK) begin
    rHsRxDly1Vld  <= rHsRxVld;
    rHsRxDly1WA   <= wHsWA   ;
    rHsRxDly1DMI  <= wHsDMI  ;
    rHsRxDly1Word <= wHsWord ;
    
    rHsRxDly2Vld  <= rHsRxDly1Vld ;
    rHsRxDly2WA   <= rHsRxDly1WA  ;
    rHsRxDly2DMI  <= rHsRxDly1DMI ;
    rHsRxDly2Word <= rHsRxDly1Word;
end


wire [     1:0] wAlgWV      ;
wire [32*3-1:0] wAlgWord    ;
wire            wAlgErr     ;
wire            wCntErr     ;

reg  [     1:0] rAlgWV      ;
reg  [32*3-1:0] rAlgWord    ;
reg             rAlgErr     ;
reg             rCntErr     ;


cphy_trio_align_dw #
(   .TRIO_NUM   ( 3         )
,   .LATENCY    ( 4         )
) u_trio_alg
(   .I_RST      ( wDRstN_pos )//(!RESET_N | wDRstN_pos)// (~wDRstN    )//
,   .I_WCLK     ( {I_CPHYCLK, I_CPHYCLK, I_CPHYCLK}    )

,   .I_WV       ( rHsRxDly2Vld  )
,   .I_WA       ( rHsRxDly2WA   )
,   .I_DMI      ( rHsRxDly2DMI  )
,   .I_WORD     ( rHsRxDly2Word )

,   .I_RCLK     ( I_CPHYCLK  )
,   .O_WV       ( wAlgWV    )
,   .O_WORD     ( wAlgWord  )

,   .O_ALG_ERR  ( wAlgErr   )
,   .O_CNT_ERR  ( wCntErr   )
);



always @(posedge I_CPHYCLK) begin
    rAlgWV   <= wAlgWV  ;
    rAlgWord <= wAlgWord;
    rAlgErr  <= wAlgErr ;
    rCntErr  <= wCntErr ;
end

csi_rx_cphy u_csi_rx_cphy
(.RESET_N           (RESET_N                )
,.wDRstN            (wDRstN                 )
,.wDRstN_pos        (wDRstN_pos             )
,.CPHYCLK           (I_CPHYCLK              )
,.ALGWV             (rAlgWV                 )
,.ALGWORD           (rAlgWord               )
,.O_FVS             (O_FVS                  )
,.O_FVE             (O_FVE                  )
,.O_DE              (O_DE                   )
,.O_EOL             (O_EOL                  )
,.O_DATA            (O_DATA                 )

,.RW_VRES           (RW_CPHY_CSI_VRES       )
,.RW_WC_REF         (RW_CPHY_CSI_WC_REF     )
,.RW_D96PERIOD      (RW_CPHY_CSI_D96PERIOD  )

,.RO_STATE0ERR      (RO_CPHY_CSI_STATE0ERR  )
,.RO_WCERR          (RO_CPHY_CSI_WCERR      )
,.RO_HCNTERR        (RO_CPHY_CSI_HCNTERR    )
,.RO_VCNTERR        (RO_CPHY_CSI_VCNTERR    )
,.RO_FVSCNT         (RO_CPHY_CSI_FVSCNT     )
,.RO_FVECNT         (RO_CPHY_CSI_FVECNT     )
,.O_FVE_INFERRED    (O_FVE_INFERRED          )
,.RO_FVS_FRAME_VALID(RO_CPHY_CSI_FVS_FRAME_VALID)
,.RO_FVS_EOLCNT     (RO_CPHY_CSI_FVS_EOLCNT  )
,.RO_FVS_FVECNT     (RO_CPHY_CSI_FVS_FVECNT  )
,.RO_FVS_VCNTERR    (RO_CPHY_CSI_FVS_VCNTERR )
,.test_io           (test_io                )
,.DBG_CSI           (wDbgCsi                )
);



assign LED     = 1'd0           // for not swept
                ^(^O_FVS )
                ^(^O_FVE )
                ^(^O_DE  )
                ^(^O_EOL )
                ^(^O_DATA)
                ;

//test io
wire [32-1:0] wHsWord_2     = { rHsRxD2[36:21], rHsRxD2[15:0]};
wire [32-1:0] wHsWord_1     = { rHsRxD1[36:21], rHsRxD1[15:0]};
wire [32-1:0] wHsWord_0     = { rHsRxD0[36:21], rHsRxD0[15:0]};

assign test_io2 = ^wHsWord_2 | ^ wHsWord_1 | ^wHsWord_0;

// GAO debug packing, all fields are sampled in the I_CPHYCLK domain.
// [126:0]   : CSI parser debug word, see csi_rx_cphy DBG_CSI packing
// [127]     : C-PHY digital reset released
// [129:128] : trio-align valid mask
// [130]     : trio-align error
// [131]     : trio-align FIFO/count error
// [134:132] : raw per-trio HSRX valid mask
// [140:135] : raw per-trio word-align flags
// [146:141] : raw per-trio de-map-invalid flags
assign DBG_CPHY = {wHsDMI, wHsWA, rHsRxVld, rCntErr, rAlgErr,
                   rAlgWV, wDRstN, wDbgCsi};

endmodule

