//Copyright (C)2014-2026 GOWIN Semiconductor Corporation.
//All rights reserved.
//File Title: Timing Constraints file
//Tool Version: V1.9.12.03 (64-bit) 
//Created Time: 2026-09-22 17:38:06
create_clock -name clk_50m_i -period 20 -waveform {0 10} [get_ports {clk_50m_i}]
create_generated_clock -name sys_clk -source [get_ports {clk_50m_i}] -master_clock clk_50m_i -divide_by 50 -multiply_by 48 [get_pins {pll_system/u_pll/PLLA_inst/CLKOUT0}]
create_generated_clock -name ov_mclk -source [get_pins {pll_system/u_pll/PLLA_inst/CLKOUT0}] -master_clock sys_clk -divide_by 2 [get_ports {OV_MCLK}]
create_generated_clock -name wCPHYclk -source [get_pins {pll_system/u_pll/PLLA_inst/CLKOUT0}] -master_clock sys_clk -divide_by 24 -multiply_by 25 [get_pins {u_PLL_CPHY_700sps/u_pll/PLLA_inst/CLKOUT0}]
