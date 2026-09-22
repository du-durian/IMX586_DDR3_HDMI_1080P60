//Copyright (C)2014-2024 GOWIN Semiconductor Corporation.
//All rights reserved.
//File Title: Timing Constraints file
//Tool Version: V1.9.10.02 
//Created Time: 2024-09-29 19:37:10


create_clock -name clk_25m_i -period 40 -waveform {0 20} [get_ports {clk_25m_i}]

//create_clock -name tck_pad_i -period 40 -waveform {0 20} [get_ports {tck_pad_i}]


create_generated_clock -name sys_clk -source [get_ports {clk_25m_i}] -master_clock clk_25m_i -divide_by 25 -multiply_by 48 [get_pins {pll_system/PLLA_inst/CLKOUT0}]
//create_generated_clock -name usb_os_clk -source [get_ports {clk_25m_i}] -master_clock clk_25m_i -divide_by 25 -multiply_by 240 [get_pins {pll_system/PLLA_inst/CLKOUT1}]

//create_generated_clock -name mipi_clk -source [get_ports {mipi_rxc_p_io}] -master_clock mipi_rxc_p_io -divide_by 4 -multiply_by 1 [get_pins {u_MIPI_RX_Advance_Top/DPHY_RX_INST/u_idesx8/Inst3_CLKDIV/CLKOUT}]
//create_generated_clock -name mipi_hs_clk -source [get_ports {mipi_rxc_p_io}] -master_clock mipi_rxc_p_io -divide_by 1 -multiply_by 1 [get_pins {u_MIPI_RX_Advance_Top/DPHY_RX_INST/HS_CLK}]

create_generated_clock -name wCPHYclk -source [get_pins {pll_system/PLLA_inst/CLKOUT0}] -master_clock sys_clk -divide_by 24 -multiply_by 25 [get_pins {u_PLL_CPHY_700sps/PLLA_inst/CLKOUT0}]

//	DDR CLK (DDR3-800 to DDR3-1066)
create_generated_clock -name ddr_clk4x -source [get_ports {clk_25m_i}] -master_clock clk_25m_i -divide_by 4 -multiply_by 48 [get_pins {pll_ddr/PLLA_inst/CLKOUT0}]
create_generated_clock -name ddr_clk -source [get_ports {clk_25m_i}] -master_clock clk_25m_i -divide_by 16 -multiply_by 48 [get_pins {pll_ddr/PLLA_inst/CLKOUT1}]

create_generated_clock -name w_ddr3_clk4x -source [get_pins {pll_ddr/PLLA_inst/CLKOUT0}] -master_clock ddr_clk4x -divide_by 1 -multiply_by 1 [get_nets {w_ddr3_clk4x}]
create_generated_clock -name w_ddr3_clk -source [get_pins {pll_ddr/PLLA_inst/CLKOUT1}] -master_clock ddr_clk -divide_by 1 -multiply_by 1 [get_nets {w_ddr3_clk}]


//	HDMI CLK
create_generated_clock -name clk_27m -source [get_ports {clk_25m_i}] -master_clock clk_25m_i -divide_by 25 -multiply_by 27 [get_pins {u_pll_25_27/PLLA_inst/CLKOUT0}]

create_generated_clock -name clk_pixel -source [get_pins {u_pll_25_27/PLLA_inst/CLKOUT0}] -master_clock clk_27m -divide_by 2 -multiply_by 11 [get_pins {u_PLL_27_742_148/PLLA_inst/CLKOUT1}]
create_generated_clock -name clk_pixelx5 -source [get_pins {u_pll_25_27/PLLA_inst/CLKOUT0}] -master_clock clk_27m -divide_by 2 -multiply_by 55 [get_pins {u_PLL_27_742_148/PLLA_inst/CLKOUT0}]



//	Uncertainty
//set_clock_uncertainty 0.5 -setup -to [get_clocks {tck_pad_i}] 
//set_clock_uncertainty 0.3 -hold -to [get_clocks {tck_pad_i}] 

set_clock_uncertainty 0.5 -setup -to [get_clocks {clk_25m_i}] 
set_clock_uncertainty 0.3 -hold -to [get_clocks {clk_25m_i}] 

set_clock_uncertainty 0.5 -setup -to [get_clocks {sys_clk}] 
set_clock_uncertainty 0.3 -hold -to [get_clocks {sys_clk}] 


set_clock_uncertainty 0.5 -setup -to [get_clocks {ddr_clk4x}] 
set_clock_uncertainty 0.3 -hold -to [get_clocks {ddr_clk4x}] 

set_clock_uncertainty 0.5 -setup -to [get_clocks {ddr_clk}] 
set_clock_uncertainty 0.3 -hold -to [get_clocks {ddr_clk}] 

set_clock_uncertainty 0.5 -setup -to [get_clocks {w_ddr3_clk4x}] 
set_clock_uncertainty 0.3 -hold -to [get_clocks {w_ddr3_clk4x}] 

set_clock_uncertainty 0.5 -setup -to [get_clocks {w_ddr3_clk}] 
set_clock_uncertainty 0.3 -hold -to [get_clocks {w_ddr3_clk}] 

//set_clock_uncertainty 0.5 -setup -to [get_clocks {clk_27m}] 
//set_clock_uncertainty 0.3 -hold -to [get_clocks {clk_27m}] 

//set_clock_uncertainty 0.5 -setup -to [get_clocks {clk_pixel}] 
//set_clock_uncertainty 0.3 -hold -to [get_clocks {clk_pixel}] 

//set_clock_uncertainty 0.5 -setup -to [get_clocks {clk_pixelx5}] 
//set_clock_uncertainty 0.3 -hold -to [get_clocks {clk_pixelx5}] 

//set_clock_uncertainty 0.5 -setup -to [get_clocks {mipi_clk}] 
//set_clock_uncertainty 0.3 -hold -to [get_clocks {mipi_clk}] 

//set_clock_uncertainty 0.5 -setup -to [get_clocks {mipi_hs_clk}] 
//set_clock_uncertainty 0.3 -hold -to [get_clocks {mipi_hs_clk}] 



//	False Paths (clk_25m_i)
set_false_path -from [get_clocks {clk_25m_i}] -to [get_clocks {sys_clk}] 
//set_false_path -from [get_clocks {clk_25m_i}] -to [get_clocks {usb_os_clk}] //
set_false_path -from [get_clocks {clk_25m_i}] -to [get_clocks {ddr_clk4x}] 
set_false_path -from [get_clocks {clk_25m_i}] -to [get_clocks {ddr_clk}] 
set_false_path -from [get_clocks {clk_25m_i}] -to [get_clocks {w_ddr3_clk4x}] 
set_false_path -from [get_clocks {clk_25m_i}] -to [get_clocks {w_ddr3_clk}] 
set_false_path -from [get_clocks {clk_25m_i}] -to [get_clocks {clk_27m}] 
set_false_path -from [get_clocks {clk_25m_i}] -to [get_clocks {clk_pixel}] 
set_false_path -from [get_clocks {clk_25m_i}] -to [get_clocks {clk_pixelx5}] 

//set_false_path -from [get_clocks {clk_25m_i}] -to [get_clocks {mipi_clk}] 
//set_false_path -from [get_clocks {clk_25m_i}] -to [get_clocks {mipi_hs_clk}] 

set_false_path -from [get_clocks {sys_clk}] -to [get_clocks {clk_25m_i}] 
//set_false_path -from [get_clocks {usb_os_clk}] -to [get_clocks {clk_25m_i}]//
set_false_path -from [get_clocks {ddr_clk4x}] -to [get_clocks {clk_25m_i}] 
set_false_path -from [get_clocks {ddr_clk}] -to [get_clocks {clk_25m_i}] 
set_false_path -from [get_clocks {w_ddr3_clk4x}] -to [get_clocks {clk_25m_i}] 
set_false_path -from [get_clocks {w_ddr3_clk}] -to [get_clocks {clk_25m_i}] 
set_false_path -from [get_clocks {clk_27m}] -to [get_clocks {clk_25m_i}] 
set_false_path -from [get_clocks {clk_pixel}] -to [get_clocks {clk_25m_i}] 
set_false_path -from [get_clocks {clk_pixelx5}] -to [get_clocks {clk_25m_i}] 
//set_false_path -from [get_clocks {mipi_clk}] -to [get_clocks {clk_25m_i}] 
//set_false_path -from [get_clocks {mipi_hs_clk}] -to [get_clocks {clk_25m_i}] 


//	False Paths (tck_pad_i)
//set_false_path -from [get_clocks {tck_pad_i}] -to [get_clocks {sys_clk}] 
//set_false_path -from [get_clocks {tck_pad_i}] -to [get_clocks {wCPHYclk}] 
//set_false_path -from [get_clocks {tck_pad_i}] -to [get_clocks {usb_os_clk}] 
//set_false_path -from [get_clocks {tck_pad_i}] -to [get_clocks {ddr_clk4x}] 
//set_false_path -from [get_clocks {tck_pad_i}] -to [get_clocks {ddr_clk}] 
//set_false_path -from [get_clocks {tck_pad_i}] -to [get_clocks {w_ddr3_clk4x}] 
//set_false_path -from [get_clocks {tck_pad_i}] -to [get_clocks {w_ddr3_clk}] 
//set_false_path -from [get_clocks {tck_pad_i}] -to [get_clocks {clk_27m}] 
//set_false_path -from [get_clocks {tck_pad_i}] -to [get_clocks {clk_pixel}] 
//set_false_path -from [get_clocks {tck_pad_i}] -to [get_clocks {clk_pixelx5}] 
//set_false_path -from [get_clocks {tck_pad_i}] -to [get_clocks {mipi_clk}] 
//set_false_path -from [get_clocks {tck_pad_i}] -to [get_clocks {mipi_hs_clk}] 

//set_false_path -from [get_clocks {sys_clk}] -to [get_clocks {tck_pad_i}] 
//set_false_path -from [get_clocks {wCPHYclk}] -to [get_clocks {tck_pad_i}] 
//set_false_path -from [get_clocks {ddr_clk4x}] -to [get_clocks {tck_pad_i}] 
//set_false_path -from [get_clocks {ddr_clk}] -to [get_clocks {tck_pad_i}] 
//set_false_path -from [get_clocks {w_ddr3_clk4x}] -to [get_clocks {tck_pad_i}] 
//set_false_path -from [get_clocks {w_ddr3_clk}] -to [get_clocks {tck_pad_i}] 
//set_false_path -from [get_clocks {clk_27m}] -to [get_clocks {tck_pad_i}] 
//set_false_path -from [get_clocks {clk_pixel}] -to [get_clocks {tck_pad_i}] 
//set_false_path -from [get_clocks {clk_pixelx5}] -to [get_clocks {tck_pad_i}] 
//set_false_path -from [get_clocks {mipi_clk}] -to [get_clocks {tck_pad_i}] 
//set_false_path -from [get_clocks {mipi_hs_clk}] -to [get_clocks {tck_pad_i}] 







//	False Paths (sys_clk)
//set_false_path -from [get_clocks {sys_clk}] -to [get_clocks {usb_os_clk}] 
set_false_path -from [get_clocks {sys_clk}] -to [get_clocks {ddr_clk4x}] 
set_false_path -from [get_clocks {sys_clk}] -to [get_clocks {ddr_clk}] 
set_false_path -from [get_clocks {sys_clk}] -to [get_clocks {w_ddr3_clk4x}] 
set_false_path -from [get_clocks {sys_clk}] -to [get_clocks {w_ddr3_clk}] 
set_false_path -from [get_clocks {sys_clk}] -to [get_clocks {clk_27m}] 
set_false_path -from [get_clocks {sys_clk}] -to [get_clocks {clk_pixel}] 
set_false_path -from [get_clocks {sys_clk}] -to [get_clocks {clk_pixelx5}] 
set_false_path -from [get_clocks {sys_clk}] -to [get_clocks {wCPHYclk}] 
//set_false_path -from [get_clocks {sys_clk}] -to [get_clocks {mipi_clk}] 
//set_false_path -from [get_clocks {sys_clk}] -to [get_clocks {mipi_hs_clk}] 

//set_false_path -from [get_clocks {usb_os_clk}] -to [get_clocks {sys_clk}] 
set_false_path -from [get_clocks {ddr_clk4x}] -to [get_clocks {sys_clk}] 
set_false_path -from [get_clocks {ddr_clk}] -to [get_clocks {sys_clk}] 
set_false_path -from [get_clocks {w_ddr3_clk4x}] -to [get_clocks {sys_clk}] 
set_false_path -from [get_clocks {w_ddr3_clk}] -to [get_clocks {sys_clk}] 
set_false_path -from [get_clocks {clk_27m}] -to [get_clocks {sys_clk}] 
set_false_path -from [get_clocks {clk_pixel}] -to [get_clocks {sys_clk}] 
set_false_path -from [get_clocks {clk_pixelx5}] -to [get_clocks {sys_clk}] 
//set_false_path -from [get_clocks {wCPHYclk}] -to [get_clocks {sys_clk}] 
//set_false_path -from [get_clocks {mipi_clk}] -to [get_clocks {sys_clk}] 
//set_false_path -from [get_clocks {mipi_hs_clk}] -to [get_clocks {sys_clk}] 



set_false_path -from [get_clocks {ddr_clk4x}] -to [get_clocks {ddr_clk}] 
set_false_path -from [get_clocks {ddr_clk}] -to [get_clocks {ddr_clk4x}] 

set_false_path -from [get_clocks {w_ddr3_clk4x}] -to [get_clocks {w_ddr3_clk}] 
set_false_path -from [get_clocks {w_ddr3_clk}] -to [get_clocks {w_ddr3_clk4x}] 

//set_false_path -from [get_clocks {mipi_hs_clk}] -to [get_clocks {mipi_clk}] 
//set_false_path -from [get_clocks {mipi_clk}] -to [get_clocks {mipi_hs_clk}] 



//	False Paths (clk_27m)
//set_false_path -from [get_clocks {clk_27m}] -to [get_clocks {usb_os_clk}] 
//set_false_path -from [get_clocks {clk_27m}] -to [get_clocks {ddr_clk4x}] 
//set_false_path -from [get_clocks {clk_27m}] -to [get_clocks {ddr_clk}] 
//set_false_path -from [get_clocks {clk_27m}] -to [get_clocks {w_ddr3_clk4x}] 
//set_false_path -from [get_clocks {clk_27m}] -to [get_clocks {w_ddr3_clk}] 
//set_false_path -from [get_clocks {clk_27m}] -to [get_clocks {clk_pixel}] 
//set_false_path -from [get_clocks {clk_27m}] -to [get_clocks {clk_pixelx5}] 

//set_false_path -from [get_clocks {usb_os_clk}] -to [get_clocks {clk_27m}] 
//set_false_path -from [get_clocks {ddr_clk4x}] -to [get_clocks {clk_27m}] 
//set_false_path -from [get_clocks {ddr_clk}] -to [get_clocks {clk_27m}] 
//set_false_path -from [get_clocks {w_ddr3_clk4x}] -to [get_clocks {clk_27m}] 
//set_false_path -from [get_clocks {w_ddr3_clk}] -to [get_clocks {clk_27m}] 
//set_false_path -from [get_clocks {clk_pixel}] -to [get_clocks {clk_27m}] 
//set_false_path -from [get_clocks {clk_pixelx5}] -to [get_clocks {clk_27m}] 



//	False Paths (clk_pixel)

//set_false_path -from [get_clocks {clk_pixel}] -to [get_clocks {ddr_clk4x}] 
//set_false_path -from [get_clocks {clk_pixel}] -to [get_clocks {ddr_clk}] 
//set_false_path -from [get_clocks {clk_pixel}] -to [get_clocks {w_ddr3_clk4x}] 
set_false_path -from [get_clocks {clk_pixel}] -to [get_clocks {w_ddr3_clk}] 
set_false_path -from [get_clocks {clk_pixel}] -to [get_clocks {clk_pixelx5}] 


//set_false_path -from [get_clocks {ddr_clk4x}] -to [get_clocks {clk_pixel}] 
//set_false_path -from [get_clocks {ddr_clk}] -to [get_clocks {clk_pixel}] 
//set_false_path -from [get_clocks {w_ddr3_clk4x}] -to [get_clocks {clk_pixel}] 
set_false_path -from [get_clocks {w_ddr3_clk}] -to [get_clocks {clk_pixel}] 
//set_false_path -from [get_clocks {clk_pixelx5}] -to [get_clocks {clk_pixel}] 


//	False Paths (wCPHYclk)

//set_false_path -from [get_clocks {wCPHYclk}] -to [get_clocks {ddr_clk4x}] 
//set_false_path -from [get_clocks {wCPHYclk}] -to [get_clocks {ddr_clk}] 
//set_false_path -from [get_clocks {wCPHYclk}] -to [get_clocks {w_ddr3_clk4x}] 
set_false_path -from [get_clocks {wCPHYclk}] -to [get_clocks {w_ddr3_clk}] 
//set_false_path -from [get_clocks {wCPHYclk}] -to [get_clocks {clk_pixel}] 
//set_false_path -from [get_clocks {wCPHYclk}] -to [get_clocks {clk_pixelx5}] 


//set_false_path -from [get_clocks {ddr_clk4x}] -to [get_clocks {wCPHYclk}] 
//set_false_path -from [get_clocks {ddr_clk}] -to [get_clocks {wCPHYclk}] 
//set_false_path -from [get_clocks {w_ddr3_clk4x}] -to [get_clocks {wCPHYclk}] 
set_false_path -from [get_clocks {w_ddr3_clk}] -to [get_clocks {wCPHYclk}] 
//set_false_path -from [get_clocks {clk_pixel}] -to [get_clocks {wCPHYclk}] 
//set_false_path -from [get_clocks {clk_pixelx5}] -to [get_clocks {wCPHYclk}] 



