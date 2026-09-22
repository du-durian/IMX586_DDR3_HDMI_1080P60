// ===========Oooo==========================================Oooo========
// =  Copyright (C) 2014 Shanghai Gowin Semiconductor Technology Co.,Ltd.
// =                     All rights reserved.
// =====================================================================
//
//  __      __      __
//  \ \    /  \    / /   [File name   ] MIPI_PHY_CTRL.v
//   \ \  / /\ \  / /    [Description ] PHY ctrl. for D-PHY/C-PHY
//    \ \/ /  \ \/ /     [Timestamp   ] 2024/06/06
//     \  /    \  /      [version     ] 1.0
//      \/      \/       
// --------------------------------------------------------------------
// Code Revision History :
// --------------------------------------------------------------------
// Ver: | Author        | Mod. Date  | Changes Made:
// V1.0 | Huang Mingtao | 2024/06/06 | Initial version
// ===========Oooo==========================================Oooo========

//  Module: MIPI_PHY_CTRL
//
module MIPI_PHY_CTRL #
(   parameter   PHY_TYPE    = "DPHY"    // "CPHY" or "DPHY"
,   parameter   LANE        = 1
,   parameter   HSEN_DLY    = 4
,   parameter   DRST_CNT    = 4
,   parameter   SYNC_ODT    = 1
)
(   I_RST
,   I_CLK
,   I_LP_DATA
,   O_PHY_ODT_EN
,   O_PHY_HS_EN
,   O_PHY_DRST
);
localparam  BW  = (PHY_TYPE=="CPHY") ? 3 : 2;
localparam  LN  = (LANE<1) ? 1 : LANE;
localparam  HD  = (HSEN_DLY<2) ? 1
                : (HSEN_DLY>15) ? 15
                : HSEN_DLY;
localparam  DHD = {HD[3:0], 1'b0};

input           I_RST       ;
input           I_CLK       ;
input  [BW-1:0] I_LP_DATA   ;
output [LN-1:0] O_PHY_ODT_EN;
output [LN-1:0] O_PHY_HS_EN ;
output          O_PHY_DRST  ;

reg  [     3:0] rLpData     = 4'b1111;
reg             rOdtMsk     = 'b0   ;
reg  [     4:0] rHsCnt      = 'b0  ;
reg  [  LN-1:0] rOdtEn      = 'b0   /* synthesis syn_preserve  = 1 */;
reg  [  LN  :0] rHsEn       = 'b0   /* synthesis syn_preserve  = 1 */;
reg             rDRst       = 'b0   /* synthesis syn_preserve  = 1 */;

wire wLP00      = (rLpData[1:0] == 0);           //! High Speed State
wire wLP01      = (rLpData[1:0] == 1);           //! LP-001 or LP-01
wire wLP11      = (rLpData[1:0] == 3);  //! Low Power State
wire wPreLP00   = (rLpData[3:2] == 0);  //!
wire wPreLP01   = (rLpData[3:2] == 1);  //!
wire wPreLP11   = (rLpData[3:2] == 3);  //!
wire wLP11to01  = (wPreLP11 & wLP01);               //! From LP-11 to LP-01, or
                                                    //! from LP-111 to LP-001
wire wLP01to00  = (wPreLP01 & wLP00);


always @(posedge I_CLK or posedge I_RST) begin
    if (I_RST)      rLpData <= 4'b1111;
    else if (BW<3)  rLpData <= {rLpData[1:0], I_LP_DATA};
    else            rLpData <= {rLpData[1:0], |I_LP_DATA[2:1], I_LP_DATA[0]};
//!_____________________________________________________________________________
    if (I_RST)                      rHsCnt  <= 5'd0;
    else if (rOdtMsk & wLP01to00)   rHsCnt  <= DHD;
    else if (rOdtMsk & wLP00)       rHsCnt  <= (rHsCnt>HD) ? (rHsCnt - 1'd1) : rHsCnt;
    else                            rHsCnt  <= (|rHsCnt) ? (rHsCnt - 1'd1) : 5'd0;
//!_____________________________________________________________________________
    if (I_RST)              rHsEn   <= {LN+1{1'b0}};
    else                    rHsEn   <= {LN+1{(|rHsCnt) & (HD>=rHsCnt)}};
//    else if (wLP11)     rHsEn   <= {LN{1'b0}};
//    else if (rHsCnt==1) rHsEn   <= {LN{rOdtMsk}};
end

generate
if (SYNC_ODT != 0) begin
    localparam      CW  = $clog2(DRST_CNT+1);
    reg  [CW-1:0]   rRstCnt = 'b0;
    always @(posedge I_RST or posedge I_CLK) begin
        if (I_RST)          rOdtMsk <= 1'b0;
        else if (wLP11)     rOdtMsk <= 1'b0;
        else if (wLP11to01) rOdtMsk <= 1'b1;
    //!_________________________________________________________________________
        if (I_RST)          rOdtEn  <= {LN{1'b0}};
        else if (1)         rOdtEn  <= {LN{rLpData[0+:BW]==0 & rOdtMsk}};
    //!_________________________________________________________________________
        if (I_RST)          rRstCnt <= {CW{1'b0}};
        else if (rHsEn[LN]) rRstCnt <= DRST_CNT[CW-1:0];
        else if (|rRstCnt)  rRstCnt <= rRstCnt - 1'd1;
    //!_________________________________________________________________________
        if (I_RST)          rDRst   <= 1'b0;
        else if (1)         rDRst   <= (~rHsEn[LN]) & (|rRstCnt);
    end
end else begin
/*
    reg     rOdtRstN    = 1'b0;
    wire    wInLP11     = (I_LP_DATA == {BW{1'b1}});
    wire    wClkLP      = I_LP_DATA[BW-1];

    always @(posedge wInLP11 or negedge wClkLP) begin
        if (wInLP11)            rOdtRstN    <= 1'b0;
        else if (I_LP_DATA[0])  rOdtRstN    <= 1'b1;
    end

    always @(negedge rOdtRstN or posedge I_CLK) begin
        if (~rOdtRstN)          rOdtMsk     <= 1'b0;
        else                    rOdtMsk     <= 1'b1;
    end

    always @(*) begin
        rOdtEn  <= {LN{rOdtRstN & ~I_LP_DATA[0]}};
        rDRst   <= rOdtRstN & rLpData[0];
    end
*/
end
endgenerate

assign  O_PHY_HS_EN     = rHsEn[LN-1:0];
assign  O_PHY_DRST      = rDRst;
assign  O_PHY_ODT_EN    = rOdtEn;

endmodule//: MIPI_PHY_CTRL
