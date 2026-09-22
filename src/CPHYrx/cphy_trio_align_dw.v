module cphy_trio_align_dw #
(parameter                      TRIO_NUM    = 1
,parameter                      LATENCY     = 4
)
(input                          I_RST    
,input      [   TBW-1:0]        I_WCLK   
                    
,input      [   TBW-1:0]        I_WV     // data valid
,input      [ 2*TBW-1:0]        I_WA     // word valid
,input      [ 2*TBW-1:0]        I_DMI    // 0: be de-mappped, 1: not be de-mapped, output the symbol data
,input      [32*TBW-1:0]        I_WORD   
                    
,input                          I_RCLK   
,output     [       1:0]        O_WV     
,output     [32*TBW-1:0]        O_WORD   
                
,output                         O_ALG_ERR
,output                         O_CNT_ERR
);
localparam  TBW = (TRIO_NUM<1) ? 1 : TRIO_NUM;



reg    [32*TBW-1:0]     rWordOut    = 'b0;
reg    [       1:0]     rOutWV      = 'b0;
reg                     rBufRdMsk   = 'b0;
reg    [       1:0]     rBufRdReg   = 'b0;
reg                     rCntErr     = 'b0;

wire   [   TBW-1:0]     wEnough;
wire   [   TBW-1:0]     wBufEmpty;
wire   [   TBW-1:0]     wBufRd;
wire   [   TBW-1:0]     wDFlag;
wire   [32*TBW-1:0]     wBufDout;
wire   [       4:0]     wBufCnt [TBW-1:0];
reg                     rAlgErr ;

wire   [   TBW-1:0]     wBufEptLat;


genvar trio;
generate
for (trio=0; trio<TBW; trio=trio+1) begin: gen_for_trio
    reg     [15:0]  rWReg       = 'b0;
    reg             rRemain     = 'b0;
    reg             rALgWV      = 'b0;
    reg     [32:0]  rAlgWord    = 'b0;
    reg             rError      = 'b0;
    reg     [15:0]  rEmpty      = 16'hFFFF;

    wire            wWClk       = I_WCLK    [trio];
    wire    [ 1:0]  wWA         = I_WA      [trio* 2 +: 2];
    wire    [ 1:0]  wDMI        = I_DMI     [trio* 2 +: 2];
    wire    [31:0]  wWord       = I_WORD    [trio*32 +:32];
    wire    [ 1:0]  wWV         = {I_WV[trio], I_WV[trio]} & wWA & ~wDMI;

    always @(posedge wWClk) begin
        case ({rRemain, wWV})
            // 3'b000:     rWReg       <= 16'h0000;
            3'b001:     rWReg       <= wWord[15: 0];
            3'b010:     rWReg       <= wWord[31:16];
            // 3'b011:     rWReg       <= 16'h0000;
            // 3'b101:     rWReg       <= 16'h0000;
            // 3'b110:     rWReg       <= 16'h0000;
            3'b111:     rWReg       <= wWord[31:16];
        endcase
    //!_________________________________________________________________________
        case ({rRemain, wWV})
            3'b011:     rAlgWord    <= {1'b1, wWord[31:0]};
            3'b101:     rAlgWord    <= {1'b1, wWord[15: 0], rWReg};
            3'b110:     rAlgWord    <= {1'b1, wWord[31:16], rWReg};
            3'b111:     rAlgWord    <= {1'b1, wWord[15: 0], rWReg};
            3'b100:     rAlgWord    <= {1'b0, 16'h0000,     rWReg};
        endcase
    end

    always @(posedge I_RST or posedge wWClk) begin
        if (I_RST)          rRemain <= 1'b0;
        else if (~(|wWV))   rRemain <= 1'b0;
        else if (1)         rRemain <= rRemain ^ (^wWV);
    //!_________________________________________________________________________
        if (I_RST)          rALgWV  <= 1'b0;
        else                rALgWV  <= ({rRemain, wWV} == 3'b011)
                                     | ({rRemain, wWV} == 3'b101)
                                     | ({rRemain, wWV} == 3'b110)
                                     | ({rRemain, wWV} == 3'b111)
                                     | ({rRemain, wWV} == 3'b100);
    //!_________________________________________________________________________
        if (I_RST)          rError  <= 1'b0;
        else                rError  <= ({rRemain, wWV} == 3'b100);
    end

    assign  wBufRd[trio]    = rBufRdMsk & ~wBufEmpty[trio];

`ifdef NOIP
    ASYNC_FIFO #
    (   .FiFoWidth      ( 33        )
    ,   .FiFoDepth      ( 16        )
    ,   .FwFt           ( 0         )
    ,   .UseBsram       ( 0         )
    ) u_ela_buf
    (   .I_RST          ( I_RST             )
    ,   .I_CLR          ( 1'b0              )
    ,   .I_WR_CLK       ( wWClk             )
    ,   .I_WR_EN        ( rALgWV            )
    ,   .I_WR_DATA      ( rAlgWord          )
    ,   .O_FULL         ( )
    ,   .O_ALMOST_FULL  ( )
    ,   .O_WR_LEVEL     ( )
    ,   .O_WR_COUNT     ( )

    ,   .I_RD_CLK       ( I_RCLK            )
    ,   .I_RD_EN        ( wBufRd[trio]      )
    ,   .O_RD_DATA      ( {wDFlag[trio] , wBufDout[32*trio +: 32]}  )
    ,   .O_EMPTY        ( wBufEmpty[trio]   )
    ,   .O_ALMOST_EMPTY ( )
    ,   .O_RD_LEVEL     ( )
    ,   .O_RD_COUNT     ( wBufCnt[trio]     )
    );
`else
    ASYNC_FIFO_D16W33_STD u_ela_buf
    (.Reset             (I_RST              )                       //input Reset
    
    ,.WrClk             (wWClk              )                       //input WrClk
    ,.WrEn              (rALgWV             )                       //input WrEn
    ,.Data              (rAlgWord           )                       //input [32:0] Data
    ,.Full              (                   )                       //output Full
    
    ,.RdClk             (I_RCLK             )                       //input RdClk
    ,.RdEn              (wBufRd[trio]       )                       //input RdEn
    ,.Q                 ({wDFlag[trio] ,wBufDout[32*trio +: 32]})   //output [32:0] Q
    ,.Empty             (wBufEmpty[trio]    )                       //output Empty
    );
`endif

    always @(posedge I_RST or posedge I_RCLK) begin
        if (I_RST)  rEmpty  <= 16'hFFFF;
        else        rEmpty  <= {rEmpty[14:0], wBufEmpty[trio]};
    end

    // assign  wAlgErr[trio]   = rError;
    assign  wBufEptLat[trio]    = (LATENCY<1 ) ? rEmpty[0]
                                : (LATENCY>16) ? rEmpty[15]
                                : rEmpty[LATENCY-1];

end//:
endgenerate


reg  [TBW-1:0] rWVReg   = 'b0;

always @(posedge I_RST or posedge I_RCLK) begin
    if (I_RST)  rWVReg      <= {TBW{1'b0}};
    else if (1) rWVReg      <= I_WV;
//!_____________________________________________________________________________
    // if (I_RST)  rBufRdMsk   <= 1'b0;
    // else        rBufRdMsk   <= rBufRdMsk ? ~(| wBufEmpty)
                             // : (&rWVReg) ? (wBufEptLat==0)
                             // : ~(& wBufEmpty);
    if(I_RST)
        rBufRdMsk <= 'd0;
    else
        if(rBufRdMsk==1'd1)
            rBufRdMsk <= ~(|wBufEmpty);  // end read when one or more fifo empty
        else
            if(&rWVReg)
                rBufRdMsk <= (wBufEptLat==0);   // start read when all fifo not empty
            else
                rBufRdMsk <= ~(&wBufEmpty);
//!_____________________________________________________________________________
    if (I_RST)  rBufRdReg   <= 2'b00;
    else        rBufRdReg   <= {rBufRdReg[0], rBufRdMsk & (&(~wBufEmpty))};
//!_____________________________________________________________________________
    if (I_RST)              rCntErr <= 1'b0;
    else if (rBufRdReg==1)  rCntErr <= (wBufRd != 0) & (wBufRd != 7);
//!_____________________________________________________________________________
    if (I_RST)              rAlgErr <= 1'b0;
    else if (rBufRdReg[0])  rAlgErr <= ((| wDFlag) & ~(& wDFlag));
//!_____________________________________________________________________________
    if (I_RST)              rOutWV  <= 2'b00;
    else if (~rBufRdReg[0]) rOutWV  <= 2'b00;
    else if (1)             rOutWV  <= (| wDFlag) ? 2'b11 : 2'b01;
end

always @(posedge I_RCLK) begin
    if (rBufRdReg[0])   rWordOut    <= wBufDout;
end

assign  O_WV        = rOutWV;
assign  O_WORD      = rWordOut;

assign  O_ALG_ERR   = rAlgErr;
assign  O_CNT_ERR   = rCntErr;

endmodule//: cphy_trio_align_dw
