
`timescale 1ps/1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2016/08/16 12:26:43
// Design Name: 
// Module Name: key_debounce
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////

module debounce #
(   parameter   POLARITY    = 0
,   parameter   COUNT       = 511
)
(   input       I_RST
,   input       I_CLK

,   input       I_IN
,   output      O_OUT
);
localparam      BW          = $clog2(COUNT+1);
localparam      DEF_VAL     = (POLARITY==0) ? 1'b0 : 1'b1;

reg  [   1:0]   rInReg      = {2{DEF_VAL}};
reg  [BW-1:0]   rCnt        = {{BW-1{1'b0}}, 1'b1};
reg             rOutReg     = DEF_VAL;

wire            wInput      = (POLARITY == 0) ? I_IN : ~I_IN;
wire            wEdge       = ^rInReg;


always @(posedge I_RST or posedge I_CLK) begin
    if (I_RST)      rInReg  <= {2{DEF_VAL}};
    else            rInReg  <= {rInReg[0], wInput};
//!_____________________________________________________________________________
    if (I_RST)      rCnt    <= {{BW-1{1'b0}}, 1'b1};
    else if (wEdge) rCnt    <= COUNT[BW-1:0];
    else if (|rCnt) rCnt    <= rCnt - 1'd1;
//!_____________________________________________________________________________
    if (I_RST)          rOutReg <= DEF_VAL;
    else if (rCnt==1)   rOutReg <= I_IN;
end

assign  O_OUT = rOutReg;

endmodule

