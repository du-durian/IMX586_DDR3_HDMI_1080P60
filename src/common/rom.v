module ROM #
(   parameter   WIDTH   = 32
,   parameter   DEPTH   = 32
,   parameter   SSRAM   = 0
,   parameter   SSREG   = 1
,   parameter   INIT    = ""
,   localparam  BW      = $clog2(DEPTH)
)
(   input  wire             RESET
,   input  wire             CLK
,   input  wire             REN
,   input  wire [BW-1:0]    RADDR
,   output wire [WIDTH-1:0] RDATA
);
localparam REAL_DEPTH   = 2 ** BW ;
//
generate
if (SSRAM == 0) begin: gen_bsram
    reg  [WIDTH-1:0] dout;
    (* syn_ramstyle="block_ram" *) reg  [WIDTH-1:0] Bram [REAL_DEPTH-1:0];
    if (INIT != "") begin
        initial begin
            $readmemh (INIT, Bram);
        end
    end

    always@(posedge CLK or posedge RESET) begin
        if (RESET)      dout <= 0;
        else if (REN)   dout <= Bram[RADDR];
    end

    assign RDATA = dout;
end else begin: gen_ssram
    wire [WIDTH-1:0] dout_w;
    reg  [WIDTH-1:0] dout;
    (* syn_ramstyle="distributed_ram" *) reg  [WIDTH-1:0] Sram [REAL_DEPTH-1:0];
//    (* syn_ramstyle="registers" *) reg  [WIDTH-1:0] Sram [REAL_DEPTH-1:0];
    if (INIT != "") begin
        initial begin
            $readmemh (INIT, Sram);
        end
    end

    assign dout_w = Sram[RADDR];
    
    always@(posedge CLK or posedge RESET) begin
        if (RESET)      dout <= 0;
        else if (REN)   dout <= dout_w;
    end

    assign RDATA = (SSREG == 0) ? dout_w : dout;
end
endgenerate
endmodule