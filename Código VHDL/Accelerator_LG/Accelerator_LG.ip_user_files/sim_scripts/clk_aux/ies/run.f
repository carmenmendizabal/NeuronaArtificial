-makelib ies_lib/xil_defaultlib -sv \
  "C:/Xilinx/Vivado/2018.3/data/ip/xpm/xpm_cdc/hdl/xpm_cdc.sv" \
-endlib
-makelib ies_lib/xpm \
  "C:/Xilinx/Vivado/2018.3/data/ip/xpm/xpm_VCOMP.vhd" \
-endlib
-makelib ies_lib/xil_defaultlib \
  "../../../../Accelerator_LG.srcs/sources_1/ip/clk_aux/clk_aux_clk_wiz.v" \
  "../../../../Accelerator_LG.srcs/sources_1/ip/clk_aux/clk_aux.v" \
-endlib
-makelib ies_lib/xil_defaultlib \
  glbl.v
-endlib

