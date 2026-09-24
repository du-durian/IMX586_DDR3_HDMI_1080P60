
module csi_rx_cphy #
(   parameter           DT_RAW10    =6'h2B
)
(   input               RESET_N
,   input               wDRstN
,   input               wDRstN_pos
,   input               CPHYCLK
,   input       [1:0]   ALGWV
,   input       [95:0]  ALGWORD
,   output reg          O_FVS  
,   output reg          O_FVE  
,   output reg  [3:0]   O_DE                // means vld bytes of O_DATA
,   output reg          O_EOL  
,   output reg  [95:0]  O_DATA              // first--last

,   input       [15:0]  RW_VRES             // used to detect err
,   input       [15:0]  RW_WC_REF           // used to detect err
,   input       [15:0]  RW_D96PERIOD        // used to detect err

,   output reg          RO_STATE0ERR
,   output reg          RO_WCERR  
,   output reg          RO_HCNTERR
,   output reg          RO_VCNTERR
,   output reg  [15:0]  RO_FVSCNT
,   output reg  [15:0]  RO_FVECNT

// FVS-to-FVS inferred frame completion. These do not represent a received
// CSI-2 FVE short packet; O_FVE and RO_FVECNT retain that original meaning.
,   output reg          O_FVE_INFERRED
,   output reg          RO_FVS_FRAME_VALID
,   output reg  [16:0]  RO_FVS_EOLCNT
,   output reg  [15:0]  RO_FVS_FVECNT
,   output reg          RO_FVS_VCNTERR

,   output wire         test_io
,   output wire [126:0]  DBG_CSI
);

//====================================================== sig_def
reg             rAlgWv              ='d0            ;
reg             rAlgWvD1            ='d0            ;
wire            wAlgWvPos           =rAlgWv && !rAlgWvD1;
reg     [31:0]  rAlgTrio2           ='d0            ;
reg     [31:0]  rAlgTrio1           ='d0            ;
reg     [31:0]  rAlgTrio0           ='d0            ;
wire    [95:0]  wAlgData            =
                                    {
                                    rAlgTrio0[07:00],   // first Byte
                                    rAlgTrio0[15:08],
                                    rAlgTrio1[07:00],
                                    rAlgTrio1[15:08],
                                    rAlgTrio2[07:00],
                                    rAlgTrio2[15:08],
                                    rAlgTrio0[23:16],
                                    rAlgTrio0[31:24],
                                    rAlgTrio1[23:16],
                                    rAlgTrio1[31:24],
                                    rAlgTrio2[23:16],
                                    rAlgTrio2[31:24]    // last Byte
                                    };
wire                                wLastPayload    ;
reg             rFirstFlag          ='d1            ;

enum                                {
                                     S0IDLE
                                    ,S0PH0
                                    ,S0PH1
                                    ,S0PH2
                                    ,S0FVS
                                    ,S0FVE
                                    ,S0PAYLOAD
                                    ,S0WAITEND
                                    ,S0ERR
                                    } state0 /* synthesis syn_encoding = "onehot" */;

reg     [5:0]   rDT                 ='d0            ;
reg     [15:0]  rWC                 ='d0            ;
reg     [95:0]  rHdrWord            ='d0            ;
reg     [5:0]   rHdrDT              ='d0            ;
reg     [15:0]  rHdrWC              ='d0            ;
reg     [15:0]  rWcCnt              ='d0            ;
reg     [15:0]  rPHCRC              ='d0            ;
                    
// localparam  [15:0]                  HBITS           =HRES*10        ;
// localparam  [15:0]                  D96QUOTIENT     =HBITS/96       ;
// localparam  [15:0]                  D96REMAINDER    =HBITS%96       ;
// localparam  [15:0]                  D96PERIOD       =D96QUOTIENT + ((D96REMAINDER>0)? 1'd1:1'd0);
reg             rFvS                ='d0            ;
reg             rFvE                ='d0            ;
reg             rDeMask             ='d0            ;
reg     [15:0]  rDe                 ='d0            ;
reg             rEol                ='d0            ;
reg     [95:0]  rData               ='d0            ;
reg     [15:0]  rHCnt               ='d0            ;
reg     [15:0]  rVCnt               ='d0            ;

// Counts image-line EOL pulses between two received FVS packets. The extra
// bit prevents a bad stream from wrapping to an apparently valid VRES value.
reg     [16:0]  rFvsFrameEolCnt      ='d0            ;
reg             rFvsSeen             ='d0            ;
wire    [16:0]  wVresExt              = {1'b0, RW_VRES};

reg     [15:0]  rCrcFromData        ='d0            ;   //LSB, MSB  same as cphy out
reg             rCrcFromDataErr     ='d0            ;


reg [11:0] ALGWV_cnt;



//====================================================== main_logic
always@(posedge CPHYCLK or negedge RESET_N) begin
//!_____________________________________________________________________________
    if(!RESET_N) begin
        rAlgWv    <= 'd0;
        rAlgWvD1  <= 'd0;
        rAlgTrio2 <= 'd0;
        rAlgTrio1 <= 'd0;
        rAlgTrio0 <= 'd0;
    end
    else begin
        rAlgWv    <= |ALGWV;
        rAlgWvD1  <= rAlgWv;
        rAlgTrio2 <= ALGWORD[95:64];
        rAlgTrio1 <= ALGWORD[63:32];
        rAlgTrio0 <= ALGWORD[31:00];
    end
//!_____________________________________________________________________________
    if(!RESET_N) begin
        state0 <= S0IDLE;
        rFirstFlag <= 'd1;
        rDT    <= 'd0;
        rWC    <= 'd0;
        rPHCRC <= 'd0;
    end
    else if(wDRstN_pos) begin
        state0 <= S0IDLE;
        rFirstFlag <= 1'b1;
        rDT    <= 'd0;
        rWC    <= 'd0;
        rPHCRC <= 'd0;
    end
    else begin
        case(state0)
            S0IDLE: begin
                state0 <= S0PH0;

                rDT    <= 'd0;
                rWC    <= 'd0;
                rPHCRC <= 'd0;
            end
            S0PH0: begin
                if(rFirstFlag) begin
                    // The C-PHY receiver can begin observing a frame after its
                    // Frame Start short packet. Accept the first valid RAW10
                    // long packet as a synchronization point as well.
                    if(wAlgWvPos && (rAlgTrio2[13:8] == 6'h00)) begin
                        state0 <= S0FVS;
                        rFirstFlag <= 1'b0;
                    end
                    //▼▼▼▼▼▼▼▼▼ 新增 ▼▼▼▼▼▼▼▼▼
                    else if(wAlgWvPos && (rAlgTrio2[13:8] == 6'h01)) begin
                        state0 <= S0FVE;
                        rFirstFlag <= 1'b0;
                    end
                    //▲▲▲▲▲▲▲▲▲ 新增 ▲▲▲▲▲▲▲▲▲
                    else if(wAlgWvPos && (rAlgTrio2[13:8] == DT_RAW10)) begin
                        state0 <= S0PH1;
                        rFirstFlag <= 1'b0;
                        rDT <= rAlgTrio2[13:8];
                        rWC <= rAlgTrio2[31:16];
                    end
                end
                else begin
                    if(wAlgWvPos) begin
                        case(rAlgTrio2[13:8])
                            6'h00   : state0 <= S0FVS;
                            6'h01   : state0 <= S0FVE;
                            DT_RAW10: state0 <= S0PH1;
                            default : state0 <= S0ERR;
                        endcase
                        rDT <= rAlgTrio2[13:08];
                        rWC <= rAlgTrio2[31:16];
                    end
                end
            end
            
            
            S0FVS: begin
                state0 <= S0WAITEND;
            end
            S0FVE: begin
                state0 <= S0WAITEND;
            end
            
            
            S0PH1: begin
                state0 <= S0PH2;
                rPHCRC <= rAlgTrio2[15:00];
            end
            S0PH2: begin
                state0 <= S0PAYLOAD;
            end
            S0PAYLOAD: begin
                if(wLastPayload) begin
                    state0 <= S0WAITEND;
                end
                else begin
                    if(!rAlgWv) //Error detect, rAlgWv should not be 0 when S0PAYLOAD
                        state0 <= S0ERR;
                    else
                        state0 <= state0;
                end
            end
            
            
            S0WAITEND: begin
                if(!rAlgWv) begin
                    state0 <= S0PH0;
                end
            end
            
            
            S0ERR: begin
              state0 <= S0IDLE;
              rFirstFlag <= 1'b1;
            end
            default: begin
                state0 <= S0IDLE;
            end
        endcase
    end
//!_____________________________________________________________________________
    // Retain the exact parser input at every header-decision strobe for GAO.
    // These values describe the same pre-clock word used by S0PH0.
    if(!RESET_N) begin
        rHdrWord <= 'd0;
        rHdrDT   <= 'd0;
        rHdrWC   <= 'd0;
    end
    else if(wAlgWvPos) begin
        rHdrWord <= wAlgData;
        rHdrDT   <= rAlgTrio2[13:8];
        rHdrWC   <= rAlgTrio2[31:16];
    end
//!_____________________________________________________________________________
    if(!RESET_N)
        rWcCnt <= 'd0;
    else
        if(state0==S0PAYLOAD)
            if(rAlgWv)  // this may be discontinus when cphyclk(gen by pll) freq faster than cphy ip's cphyclk
                rWcCnt <= rWcCnt + 4'd12;
            else
                rWcCnt <= rWcCnt;
        else
            rWcCnt <= 'd0;
//!_____________________________________________________________________________
end
assign wLastPayload = (rWcCnt + 4'd12 >= rWC) && rAlgWv;  // for better timming
// assign wLastPayload = (rWcCnt + 4'd12 >= RW_WC_REF) && (state0==S0PAYLOAD) && rAlgWv;




always@(posedge CPHYCLK or negedge RESET_N) begin
//!_____________________________________________________________________________
    if(!RESET_N)    rFvS    <= 'd0;
    else            rFvS    <= (state0 == S0FVS);
//!_____________________________________________________________________________
    if(!RESET_N)    rFvE    <= 'd0;
    else            rFvE    <= (state0 == S0FVE);
//!_____________________________________________________________________________
    if(!RESET_N)    rEol    <= 'd0;
    else            rEol    <= wLastPayload && (state0==S0PAYLOAD);
//!_____________________________________________________________________________
    if(!RESET_N)    rDeMask <= 'd0;
    else            rDeMask <= rAlgWv;
//!_____________________________________________________________________________
    if(!RESET_N) begin
        rDe <= 'd0;
    end
    else begin
        if(state0 == S0PAYLOAD) begin
            if(rWcCnt + 4'd12 <= rWC) begin
                rDe <= 4'd12;
            end
            else begin
                rDe <= rWC - rWcCnt;
            end
        end
        else begin
            rDe <= 'd0;
        end
    end
//!_____________________________________________________________________________
    if(!RESET_N)
        rData <= 'd0;
    else if(state0 == S0PAYLOAD)
        rData <= wAlgData;
    else
        rData <= 'd0;
//!_____________________________________________________________________________
    if(!RESET_N)
        rVCnt <= 'd0;
    else
        if(rFvS)
            rVCnt <= 'd0;
        else
            if(rEol)
                rVCnt <= rVCnt + 1'd1;
//!_____________________________________________________________________________
    if(!RESET_N)
        rHCnt <= 'd0;
    else if(wDRstN_pos)
        rHCnt <= 'd0;
    else
        if(rDe)
            if(rEol | rFirstFlag)//
                rHCnt <= 'd0;
            else
                rHCnt <= rHCnt + 1'd1;
//!_____________________________________________________________________________
    if(!RESET_N) begin
        rCrcFromData <= 'd0;
        rCrcFromDataErr <= 'd0;
    end
    else begin
        if(rEol) begin
            case(rDe[3:0])
                'd01: rCrcFromData <= rData[87:72];
                'd02: rCrcFromData <= rData[79:64];
                'd03: rCrcFromData <= rData[71:56];
                'd04: rCrcFromData <= rData[63:48];
                'd05: rCrcFromData <= rData[55:40];
                'd06: rCrcFromData <= rData[47:32];
                'd07: rCrcFromData <= rData[39:24];
                'd08: rCrcFromData <= rData[31:16];
                'd09: rCrcFromData <= rData[23:08];
                'd10: rCrcFromData <= rData[15:00];
                'd11: rCrcFromData <= {rData[07:00], wAlgData[95:88]};
                'd12: rCrcFromData <= wAlgData[95:80];
                default: begin
                    rCrcFromData <= 16'hDEAD;
                    rCrcFromDataErr <= 1'd1;
                end
            endcase
        end
        else begin
            rCrcFromDataErr <= 'd0;
        end
    end
//!_____________________________________________________________________________
end






//============================================================= output delay
always@(posedge CPHYCLK or negedge RESET_N) begin
    if(!RESET_N) begin
        O_FVS  <= 'd0;
        O_FVE  <= 'd0;
        O_DE   <= 'd0;
        O_EOL  <= 'd0;
        O_DATA <= 'd0;
    end
    else begin
        O_FVS  <= rFvS;
        O_FVE  <= rFvE;
        O_DE   <= rDeMask? rDe[3:0]:1'd0;
        O_EOL  <= rEol;
        O_DATA <= rData;
    end
end


//============================================================= FVS-boundary frame verifier
// A new received FVS closes the preceding FVS-delimited frame. This is used
// only when a sensor mode does not supply a usable CSI-2 FVE short packet.
always@(posedge CPHYCLK or negedge RESET_N) begin
    if(!RESET_N) begin
        rFvsFrameEolCnt   <= 17'd0;
        rFvsSeen          <= 1'b0;
        O_FVE_INFERRED    <= 1'b0;
        RO_FVS_FRAME_VALID<= 1'b0;
        RO_FVS_EOLCNT     <= 17'd0;
        RO_FVS_FVECNT     <= 16'd0;
        RO_FVS_VCNTERR    <= 1'b0;
    end
    else begin
        // wDRstN_pos is a normal C-PHY burst-level reset/release event. Do
        // not discard FVS-to-FVS history here, or a frame can never close.
        O_FVE_INFERRED <= 1'b0;

        if(rFvS) begin
            if(rFvsSeen) begin
                O_FVE_INFERRED <= 1'b1;
                RO_FVS_EOLCNT  <= rFvsFrameEolCnt;
                if(RO_FVS_FVECNT != 16'hFFFF)
                    RO_FVS_FVECNT <= RO_FVS_FVECNT + 1'b1;
                if(rFvsFrameEolCnt != wVresExt)
                    RO_FVS_VCNTERR <= 1'b1;
            end

            rFvsFrameEolCnt    <= 17'd0;
            rFvsSeen           <= 1'b1;
            RO_FVS_FRAME_VALID <= 1'b1;
        end
        else if(rFvsSeen && rEol) begin
            if(!(&rFvsFrameEolCnt))
                rFvsFrameEolCnt <= rFvsFrameEolCnt + 1'b1;
        end
    end
end


//============================================================= Error detect
always@(posedge CPHYCLK or negedge RESET_N) begin
    if(!RESET_N) RO_STATE0ERR<= 'd0; else if(!wDRstN) RO_STATE0ERR<= 'd0; else RO_STATE0ERR<= (state0==S0ERR)?                       1'd1:RO_STATE0ERR;

    if(!RESET_N) RO_WCERR    <= 'd0; else RO_WCERR    <= (state0==S0PH1 && rWC!=RW_WC_REF)?     1'd1:RO_WCERR    ;
    if(!RESET_N) RO_HCNTERR  <= 'd0; else RO_HCNTERR  <= (rEol && (rHCnt+1'd1!=RW_D96PERIOD))?  1'd1:RO_HCNTERR  ;
    if(!RESET_N) RO_VCNTERR  <= 'd0; else RO_VCNTERR  <= (rFvE && (rVCnt!=RW_VRES))?            1'd1:RO_VCNTERR  ;
    if(!RESET_N) RO_FVSCNT   <= 'd0; else RO_FVSCNT   <= rFvS? RO_FVSCNT+1'd1:RO_FVSCNT;
    if(!RESET_N) RO_FVECNT   <= 'd0; else RO_FVECNT   <= rFvE? RO_FVECNT+1'd1:RO_FVECNT;
end




//============================================================= to calculate Tlines time, this is involved with sensor(one Tlines time send 4 lines)
reg     [1:0]       rTlinesFlag ='d0;
reg     [15:0]      rTlinesCnt  ='d0;
wire                wTlinesLockFlag;
reg     [15:0]      rTlinesLock ='d0;
always@(posedge CPHYCLK or negedge RESET_N) begin
//!_____________________________________________________________________________
    if(!RESET_N) begin
        rTlinesFlag <= 'd0;
    end
    else begin
        if(rEol && rVCnt[1:0]==2'b00) begin
            rTlinesFlag[1] <= 1'b1;
            rTlinesFlag[0] <= ~rTlinesFlag[0];
        end
    end
//!_____________________________________________________________________________
    if(!RESET_N) begin
        rTlinesCnt <= 'd0;
    end
    else begin
        if(&rTlinesFlag) begin
            rTlinesCnt <= rTlinesCnt + 1'd1;
        end
        else begin
            rTlinesCnt <= 'd0;
        end
    end
//!_____________________________________________________________________________
    if(!RESET_N) begin
        rTlinesLock <= 'd0;
    end
    else begin
        if(wTlinesLockFlag) begin
            rTlinesLock <= rTlinesCnt;
        end
    end
//!_____________________________________________________________________________
end
assign wTlinesLockFlag = (&rTlinesFlag) && rEol && rVCnt[1:0]==2'b00;


always@(posedge CPHYCLK or negedge RESET_N) begin
//!_____________________________________________________________________________
    if(!RESET_N) 
       ALGWV_cnt <= 0;
    else if(!wDRstN)
       ALGWV_cnt <= 0;
    else if(ALGWV)
       ALGWV_cnt <= ALGWV_cnt + 1;
end

assign test_io = ^ALGWV_cnt;

// GAO debug packing, all synchronous to CPHYCLK.
// [95:0]   : retained parser input at the most recent header strobe
// [111:96]  : retained Word Count from the most recent header strobe
// [117:112] : retained Data Type from the most recent header strobe
// [118]     : parser aligned-data valid
// [119]     : aligned-data valid rising edge (current header strobe)
// [120]     : first-frame acquisition flag
// [122:121] : reserved for future debug use
// [126:123] : portable parser state code
wire [3:0] wDbgState = (state0 == S0IDLE)    ? 4'd0 :
                        (state0 == S0PH0)     ? 4'd1 :
                        (state0 == S0PH1)     ? 4'd2 :
                        (state0 == S0PH2)     ? 4'd3 :
                        (state0 == S0FVS)     ? 4'd4 :
                        (state0 == S0FVE)     ? 4'd5 :
                        (state0 == S0PAYLOAD) ? 4'd6 :
                        (state0 == S0WAITEND) ? 4'd7 :
                        (state0 == S0ERR)     ? 4'd8 : 4'hF;

assign DBG_CSI = {wDbgState, 2'b00, rFirstFlag, wAlgWvPos,
                  rAlgWv, rHdrDT, rHdrWC, rHdrWord};

endmodule