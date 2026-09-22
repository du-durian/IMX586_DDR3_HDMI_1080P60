/*-------------------------------------------------------------------------
This confidential and proprietary software may be only used as authorized
by a licensing agreement from CrazyBingo.www.cnblogs.com/crazybingo
(C) COPYRIGHT 2012 CrazyBingo. ALL RIGHTS RESERVED
Filename            :       I2C_SC130GS_12801024_Config.v
Author              :       CrazyBingo
Date                :       2019-08-03
Version             :       1.0
Description         :       I2C Configure Data of AR0135.
Modification History    :
Date            By          Version         Change Description
===========================================================================
19/08/03        CrazyBingo  1.0             Original
--------------------------------------------------------------------------*/

`timescale 1ns/1ns
module  I2C_SC130GS_12801024_1Lanes_Config  //1280*1024@60 with AutO/Manual Exposure
(
    input       [7:0]   LUT_INDEX,
    output  reg [23:0]  LUT_DATA,
    output      [7:0]   LUT_SIZE
);
assign  LUT_SIZE = 1'b1 + 8'd121 ;

//-----------------------------------------------------------------
/////////////////////   Config Data LUT   //////////////////////////    
always@(*)
begin
    case(LUT_INDEX)
        0  : LUT_DATA = {16'h0103,8'h01};
        1  : LUT_DATA = {16'h0100,8'h00};
        2  : LUT_DATA = {16'h3039,8'h80};
        3  : LUT_DATA = {16'h3034,8'h80};
        4  : LUT_DATA = {16'h3001,8'h00};
        5  : LUT_DATA = {16'h3018,8'h10};
        6  : LUT_DATA = {16'h3019,8'h0e};
        7  : LUT_DATA = {16'h301f,8'h1c};
        8  : LUT_DATA = {16'h3022,8'h10};
        9  : LUT_DATA = {16'h302b,8'h80};
        10 : LUT_DATA = {16'h3030,8'h04};
        11 : LUT_DATA = {16'h3000,8'h00};
        12 : LUT_DATA = {16'h3031,8'h08};
        13 : LUT_DATA = {16'h3035,8'hd2};
        14 : LUT_DATA = {16'h3036,8'h00};
        15 : LUT_DATA = {16'h3038,8'h44};
        16 : LUT_DATA = {16'h303a,8'h2d};
        17 : LUT_DATA = {16'h303b,8'h0d};
        18 : LUT_DATA = {16'h303c,8'h04};
        19 : LUT_DATA = {16'h303d,8'h03};
        20 : LUT_DATA = {16'h303f,8'h11};
        21 : LUT_DATA = {16'h3202,8'h00};
        22 : LUT_DATA = {16'h3203,8'h00};
        23 : LUT_DATA = {16'h3205,8'h8b};
        24 : LUT_DATA = {16'h3206,8'h02};
        25 : LUT_DATA = {16'h3207,8'h04};
        26 : LUT_DATA = {16'h320a,8'h04};
        27 : LUT_DATA = {16'h320b,8'h00};
        28 : LUT_DATA = {16'h320c,8'h03};
        29 : LUT_DATA = {16'h320d,8'hf8};
        30 : LUT_DATA = {16'h320e,8'h02};
        31 : LUT_DATA = {16'h320f,8'h0e};
        32 : LUT_DATA = {16'h3200,8'h00};
        33 : LUT_DATA = {16'h3201,8'h7c};
        34 : LUT_DATA = {16'h3202,8'h00};
        35 : LUT_DATA = {16'h3203,8'h45};
        36 : LUT_DATA = {16'h3204,8'h05};
        37 : LUT_DATA = {16'h3205,8'h8b};
        38 : LUT_DATA = {16'h3206,8'h01};
        39 : LUT_DATA = {16'h3207,8'hbf};
        40 : LUT_DATA = {16'h3208,8'h05};
        41 : LUT_DATA = {16'h3209,8'h00};
        42 : LUT_DATA = {16'h320a,8'h02};
        43 : LUT_DATA = {16'h320b,8'hee};
        44 : LUT_DATA = {16'h3210,8'h00};
        45 : LUT_DATA = {16'h3211,8'h0c};
        46 : LUT_DATA = {16'h3212,8'h00};
        47 : LUT_DATA = {16'h3213,8'h04};
        48 : LUT_DATA = {16'h3211,8'h0c};
        49 : LUT_DATA = {16'h3213,8'h04};
        50 : LUT_DATA = {16'h3300,8'h20};
        51 : LUT_DATA = {16'h3302,8'h0c};
        52 : LUT_DATA = {16'h3306,8'h48};
        53 : LUT_DATA = {16'h3308,8'h50};
        54 : LUT_DATA = {16'h330a,8'h00};
        55 : LUT_DATA = {16'h330b,8'h80};
        56 : LUT_DATA = {16'h330e,8'h1a};
        57 : LUT_DATA = {16'h3310,8'hf0};
        58 : LUT_DATA = {16'h3311,8'h10};
        59 : LUT_DATA = {16'h3319,8'he8};
        60 : LUT_DATA = {16'h3333,8'h90};
        61 : LUT_DATA = {16'h3334,8'h30};
        62 : LUT_DATA = {16'h3348,8'h02};
        63 : LUT_DATA = {16'h3349,8'hee};
        64 : LUT_DATA = {16'h334a,8'h02};
        65 : LUT_DATA = {16'h334b,8'he8};
        66 : LUT_DATA = {16'h335d,8'h00};
        67 : LUT_DATA = {16'h3380,8'hff};
        68 : LUT_DATA = {16'h3382,8'he0};
        69 : LUT_DATA = {16'h3383,8'h0a};
        70 : LUT_DATA = {16'h3384,8'he4};
        71 : LUT_DATA = {16'h3400,8'h53};
        72 : LUT_DATA = {16'h3416,8'h31};
        73 : LUT_DATA = {16'h3518,8'h07};
        74 : LUT_DATA = {16'h3519,8'hc8};
        75 : LUT_DATA = {16'h3620,8'h23};
        76 : LUT_DATA = {16'h3621,8'h0a};
        77 : LUT_DATA = {16'h3622,8'h06};
        78 : LUT_DATA = {16'h3623,8'h14};
        79 : LUT_DATA = {16'h3624,8'h40};
        80 : LUT_DATA = {16'h3625,8'h00};
        81 : LUT_DATA = {16'h3626,8'h00};
        82 : LUT_DATA = {16'h3627,8'h01};
        83 : LUT_DATA = {16'h3630,8'h63};
        84 : LUT_DATA = {16'h3632,8'h74};
        85 : LUT_DATA = {16'h3633,8'h63};
        86 : LUT_DATA = {16'h3634,8'hff};
        87 : LUT_DATA = {16'h3635,8'h44};
        88 : LUT_DATA = {16'h3638,8'h82};
        89 : LUT_DATA = {16'h3639,8'h74};
        90 : LUT_DATA = {16'h363a,8'h24};
        91 : LUT_DATA = {16'h363b,8'h00};
        92 : LUT_DATA = {16'h3640,8'h03};
        93 : LUT_DATA = {16'h3658,8'h9a};
        94 : LUT_DATA = {16'h3663,8'h88};
        95 : LUT_DATA = {16'h3664,8'h07};
        96 : LUT_DATA = {16'h3c00,8'h41};
        97 : LUT_DATA = {16'h3d08,8'h00};
        98 : LUT_DATA = {16'h3e01,8'h1a};
        99 : LUT_DATA = {16'h3e02,8'h00};
        100: LUT_DATA = {16'h3e03,8'h03};
        101: LUT_DATA = {16'h3e08,8'h00};  //Gain
        //102: LUT_DATA = {16'h3e09,8'h10};
        102: LUT_DATA = {16'h3e09,8'h10};   //Change 
        103: LUT_DATA = {16'h3e0e,8'h00};
        104: LUT_DATA = {16'h3e0f,8'h14};
        105: LUT_DATA = {16'h3e14,8'hb0};
        106: LUT_DATA = {16'h3f08,8'h04};
        107: LUT_DATA = {16'h3f09,8'h98};
        108: LUT_DATA = {16'h4501,8'hc0};
        109: LUT_DATA = {16'h4502,8'h16};
        110: LUT_DATA = {16'h4800,8'h04};
        111: LUT_DATA = {16'h4837,8'h0a};
        112: LUT_DATA = {16'h5000,8'h01};
        113: LUT_DATA = {16'h5b00,8'h02};
        114: LUT_DATA = {16'h5b01,8'h03};
        115: LUT_DATA = {16'h5b02,8'h01};
        116: LUT_DATA = {16'h5b03,8'h01};
        117: LUT_DATA = {16'h3039,8'h23};
        118: LUT_DATA = {16'h3034,8'h01};
        119: LUT_DATA = {16'h0100,8'h01};
        120: LUT_DATA = {16'h363a,8'h64};
        121: LUT_DATA = {16'h3630,8'h73};
    default:LUT_DATA    =   {16'h0000, 8'h00};
    endcase
end

endmodule
