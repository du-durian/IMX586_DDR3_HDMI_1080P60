`timescale		1ns/1ns

module test_tb();
	reg 				wCPHYclk;
	reg 				rstn;
	wire			wCPHYclkx10;
	wire			wCPHYclkx10_rstn;
	PLL_wCPHYclkx5 u_PLL_wCPHYclkx10(
			.lock(wCPHYclkx10_rstn), //output lock
			.clkout0(wCPHYclkx10), //output clkout0
			.clkin(wCPHYclk), //input clkin
			.reset(~rstn) //input reset
		);
//////////////////////////////////////////////////////////
	reg		[3:0]			state0;
	reg 				vss;
	reg					de;
	reg		[95:0]		data_in;
	reg		[15:0]		h_cnt;
	reg		[10:0]		p_cnt;
	
	//
	always@(posedge wCPHYclk or negedge wCPHYclkx10_rstn)begin
	if(!wCPHYclkx10_rstn)begin
		state0 <= 0;
		vss <= 0;
		de <= 0;
		data_in <= 0;
		h_cnt  <= 0;
		p_cnt <= 0;
	end
	else begin
		case(state0)
			'd0: begin
				vss <= 1;
				state0 <= 'd1; 
			end 
			'd1:begin
				vss <= 0;
				
				if(h_cnt == 'd1080)begin
					state0 <= 'd3;
					h_cnt <= 0;
				end
				else begin
					de <= 1;
					data_in <= data_in + 1'b1;
					state0 <= 'd2;
				end
			end
			'd2:begin
				if(p_cnt == 'd199)begin
					h_cnt <= h_cnt + 1'b1;
					state0 <= 'd1;
					p_cnt <= 0;
					de <= 0;
				end
				else begin
					p_cnt <= p_cnt + 1'b1;
					state0 <= 'd2;
				end 
			end
		endcase
	end 
	end 
	

	
	//////////////////////////////////////////////////////////////
	reg     [479:0]     r_CPHY_data;
    reg     [  3:0]     r_stitch_cnt;
    reg     [5:0]       r_stitch_total;
    reg     [383:0]     r_CPHYdat8bit;
    
    wire                w_mipi_vld = wCPHYrxDe[2];
           
    
    wire    [479:0]     w_CPHY_data;
    always@(posedge wCPHYclk)begin
    if(wCPHYrxFvs)
        r_CPHY_data <= 480'd0;
    else if(w_mipi_vld)
        r_CPHY_data <= w_CPHY_data;
    else
        r_CPHY_data <= r_CPHY_data;
    end

    assign w_CPHY_data = {r_CPHY_data[383:0],wCPHYrxData};
	reg		[1:0]	r_vs_edge;
    always@(posedge wCPHYclk)begin
		r_vs_edge <= {r_vs_edge,vss};
        if(r_vs_edge == 2'b01)
            r_stitch_cnt <= 0;
        else if(w_mipi_vld)begin
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
    reg     [2:0]       r_shift_cnt;
    reg     [127:0]     r_image_data;
    reg                 r_image_de;
    always@(posedge wCPHYclk or negedge wCPHYclkx10_rstn)begin
    if(!wCPHYclkx10_rstn)begin
        state <= 0;
        r_shift_cnt <= 0;
        r_image_de <= 0;
        r_image_data <= 0;
        
    end
    else begin
        case(state)
            3'd0: begin
                if(r_stitch_cnt == 'd4 )begin
                    state <= 3'd1;
                    r_image_de <= 1;
                     r_CPHYdat8bit <= picelcut8bit(w_CPHY_data);
                end
                else
                    state <= 3'd0;
            end
            3'd1: begin
                if(r_shift_cnt == 'd2)begin
                    r_shift_cnt <= 0;
                    state <= 3'd0;
                    r_image_de <= 0; 
                end
                else begin
                    r_shift_cnt <= r_shift_cnt + 1'b1;
                    r_CPHYdat8bit <= r_CPHYdat8bit << 128;
                    r_image_data <= r_CPHYdat8bit[383:256];
                    state <= 3'd1; 
                end
            end
        endcase
    end
    end

     function   [383:0]  picelcut8bit;
        input [479:0]   data_in;
        begin
            integer i;
            for (i = 0; i < 48; i = i + 1) begin
                picelcut8bit[i*8 +: 8] = data_in[i*10 + 9 -: 8];
        end
        end
    endfunction;
    wire        [9:0]      w_pixel_data;
    assign      w_pixel_data = r_rd_data;
	
	always #10 wCPHYclk = ~wCPHYclk;
	
	wire		wCPHYclkx2;
	reg 		q;
	assign		wCPHYclkx2 = wCPHYclk^q;
	always@(posedge wCPHYclkx2 )begin
		q <= ~q;
	end
	initial begin
	r_vs_edge = 0;
	q = 0;
	wCPHYclk		<= 0;
	rstn			<=        0;
	#100
	rstn <= 1;
	
	end
	
endmodule