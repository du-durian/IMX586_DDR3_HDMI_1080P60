// by CrazyStaff 					20241101			v0.1
// 		Only use for GOWIN CPHY RX IP 96bits pixel date resharpe. this module resharpe 96bits 
// successional pixel data to 128 bits for axi_ctl module, and cut RAW 10 to RAW8(MSB). This module 
// only fit n x 1920 Source Horizontal pixel.

module CMOS_IMX586_FrameCapture #(
		parameter 	[12:0]	IMAGE_HSIZE_SOURCE = 1920,
							IMAGE_VSIZE_SOURCE = 1080
)(
	input					Rstn_i,
	input					CPHYClk_i,
	input					CPHYFvs_i,
	input					CPHYDe_i,
	input		[95:0]		CPHYData96bit_i,
	
	output					cmos_vsync_o,
	output					cmos_hsync_o,
	output					cmos_de_o,
	output		[127:0]		cmos_16pixels_o
	
	


);
	localparam 	[7:0]	HDENUM = IMAGE_HSIZE_SOURCE/48;


	reg     [479:0]     r_CPHY_data;    //stitch 96bits to 480bits (48pixels)
    reg     [  3:0]     r_stitch_cnt;
    reg     [  5:0]     r_stitch_total;
    reg     [383:0]     r_CPHYdat8bit; // cut raw10 to 8bits(MSB)
    
 
           
    
    wire    [479:0]     w_CPHY_data;
    always@(posedge CPHYClk_i)begin
    if(CPHYFvs_i)
        r_CPHY_data <= 480'd0;
    else if(CPHYDe_i)
        r_CPHY_data <= w_CPHY_data;
    else
        r_CPHY_data <= r_CPHY_data;
    end

    assign w_CPHY_data = {r_CPHY_data,CPHYData96bit_i}; 

    always@(posedge CPHYClk_i)begin
        if(CPHYFvs_i)
            r_stitch_cnt <= 0;
        else if(CPHYDe_i)begin
            if(r_stitch_cnt == 'd4 )begin
                r_stitch_cnt <= 0;
            end
            else
                r_stitch_cnt <= r_stitch_cnt + 1'b1;
        end
        else
            r_stitch_cnt <= r_stitch_cnt;
    end

    
    reg     [2:0]       state;
    reg     [2:0]       de_state;
    reg     [2:0]       r_shift_cnt;
    wire    [127:0]     r_image_data;
    reg                 r_image_de;
    reg                 r_image_hs;
    reg     [12:0]      r_image_hs_cnt;
    reg     [ 7:0]      r_image_de_cnt;
    always@(posedge CPHYClk_i or negedge Rstn_i)begin
    if(!Rstn_i)begin
        state <= 0;
        r_shift_cnt <= 0;
        r_image_de <= 0;
        r_image_hs <= 0;
        r_image_hs_cnt <= 0;
        r_image_de_cnt <= 0;
        de_state <= 0;
        
    end
    else begin
          case(state)
            3'd0: begin
                if(CPHYFvs_i)begin
                    state <= 3'd1;
                    r_image_hs <= 0;
                    r_image_de <= 0;
                    r_image_hs_cnt <= 0;
                end
                else
                    state <= 3'd0;
            end
            3'd1: begin
                if(CPHYDe_i)begin
                    r_image_hs <= 1;
                    state <= 3'd2;
                end
                else
                    state <= 3'd1;
            end
            3'd2: begin
                if(r_image_hs_cnt == IMAGE_HSIZE_SOURCE)begin
                    r_image_hs_cnt <= 0;
                    state <= 3'd0;
                end
                else begin
                    if(r_image_de_cnt == HDENUM)begin
                        r_image_hs <= 0;
                        de_state <= 0;
                        r_image_de_cnt <= 0;
                        r_image_hs_cnt <= r_image_hs_cnt + 1'b1;
                    end
                    else begin
                        r_image_hs <= 1;
                        case(de_state)
                            3'd0: begin
                                if(r_stitch_cnt == 'd4 )begin
                                    de_state <= 3'd1;
                                    r_image_de <= 1;
                                     r_CPHYdat8bit <= pixelcut8bit(w_CPHY_data);
                                end
                                else
                                    de_state <= 3'd0;
                            end
                            3'd1: begin
                                if(r_shift_cnt == 'd2)begin
                                    r_shift_cnt <= 0;
                                    de_state <= 3'd0;
                                    r_image_de <= 0; 
                                    r_image_de_cnt <= r_image_de_cnt + 1'b1;
                                end
                                else begin
                                    r_shift_cnt <= r_shift_cnt + 1'b1;
                                    r_CPHYdat8bit <= r_CPHYdat8bit << 128; // 384bits(48pixels) to 128bit(16pixels)
                                    r_image_de_cnt <= r_image_de_cnt;
                                    de_state <= 3'd1; 
                                end
                            end
                        endcase
                    end
                end
            end
          endcase
    end
    end
    

     function [383:0] pixelcut8bit;
        input [479:0] data_in;
        integer i;
        begin
            for (i = 11; i >= 0; i = i - 1) begin
                pixelcut8bit[(i*32)+31 -: 32] = data_in[(i*40)+39 -: 32]; // cut raw10 to 8
            end
        end
    endfunction
	
	assign  cmos_16pixels_o = r_CPHYdat8bit[383:256]; 
	assign	cmos_vsync_o 	= ~CPHYFvs_i;
	assign	cmos_hsync_o 	= r_image_hs;
	assign	cmos_de_o 	 	= r_image_de;
	
endmodule