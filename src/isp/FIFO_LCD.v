module fifo_lcd 
#(
        parameter C_H_TOTAL = 12'd1186,
        parameter C_H_START = 12'd162,
        parameter C_V_DISP  = 12'd600
)
(
    input                               clk                        ,
    input                               rstn_sys                   ,
    input  wire        [  23:0]         fifo2_rdata                ,
    


    input  wire                         zoom_img_vs                ,
    input  wire                         zoom_img_hs                ,
    input  wire                         zoom_img_de                ,

    output reg                          fifo2_renb                 ,
    output wire                         obj_img_de                 ,
    output wire        [   7:0]         obj_img_red                ,
    output wire        [   7:0]         obj_img_green              ,
    output wire        [   7:0]         obj_img_blue                

);
reg                    [  11:0]         sync_hcnt                  ;
reg                    [  11:0]         sync_vcnt                  ;
wire                                    clk_lvds_1x = clk          ;



reg     [   3:0]         sync_vs                    ;
reg     [   3:0]         sync_hs                    ;
reg     [   3:0]         sync_de                    ;


always @(posedge clk_lvds_1x)//打三拍同步
begin
if(rstn_sys == 1'b0)
begin
	sync_vs <= 4'b0;
	sync_hs <= 4'b0;
	sync_de <= 4'b0;
end
else
begin
	sync_vs <= {sync_vs[2:0],zoom_img_vs};
	sync_hs <= {sync_hs[2:0],zoom_img_hs};
	sync_de <= {sync_de[2:0],zoom_img_de};
end
end

always @(posedge clk_lvds_1x)// horizon count
begin
if(rstn_sys == 1'b0)
	sync_hcnt <= 12'b0;
else
begin
	if(sync_hs[2] == 1'b1)
		sync_hcnt <= sync_hcnt + 1'b1;
	else
		sync_hcnt <= 12'b0;
end
end

always @(posedge clk_lvds_1x)
begin
if(rstn_sys == 1'b0)
	sync_vcnt <= 12'b0;
else
begin
	if(sync_vs[2] == 1'b1)
	begin
		if(sync_hs[3:2] == 2'b10)
			sync_vcnt <= sync_vcnt + 1'b1;
		else
			sync_vcnt <= sync_vcnt;
	end
	else
		sync_vcnt <= 12'b0;
end
end


reg             [11:0]          obj_img_hcnt;
reg             [11:0]          obj_img_vcnt;

always @(posedge clk_lvds_1x)
begin
if(rstn_sys == 1'b0)
begin
	obj_img_hcnt <= 12'b0;
	obj_img_vcnt <= 12'b0;
end
else
begin
	if((obj_img_hcnt == 12'b0)&&(obj_img_vcnt == 12'b0)&&(sync_hs[2] == 1'b1)&&(sync_vcnt == 12'b0)&&(sync_hcnt == 12'd0))
	begin
		obj_img_hcnt <= 12'b1;
		obj_img_vcnt <= 12'b0;
	end
	else if((obj_img_hcnt > 12'b0)||(obj_img_vcnt > 12'b0))
	begin
		if(obj_img_hcnt < C_H_TOTAL - 1'b1)
		begin
			obj_img_hcnt <= obj_img_hcnt + 1'b1;
			obj_img_vcnt <= obj_img_vcnt;
		end
		else
		begin
			obj_img_hcnt <= 12'b0;
			if(obj_img_vcnt < C_V_DISP - 1'b1)
				obj_img_vcnt <= obj_img_vcnt + 1'b1;
			else
				obj_img_vcnt <= 12'b0;
		end
	end
	else
	begin
		obj_img_hcnt <= 12'b0;
		obj_img_vcnt <= 12'b0;
	end
end
end



always @(posedge clk_lvds_1x)
begin
if(rstn_sys == 1'b0)
	fifo2_renb <= 1'b0;
else
begin
	if((obj_img_hcnt > C_H_START - 1'b1)&&(obj_img_hcnt <= C_H_TOTAL - 1'b1))
		fifo2_renb <= 1'b1;
	else
		fifo2_renb <= 1'b0;
end
end


assign obj_img_de    = fifo2_renb;
assign obj_img_red   = fifo2_rdata[23:16];
assign obj_img_green = fifo2_rdata[15:8];
assign obj_img_blue  = fifo2_rdata[7:0];


endmodule