-makelib ies_lib/xilinx_vip -sv \
  "C:/Xilinx/Vivado/2019.1/data/xilinx_vip/hdl/axi4stream_vip_axi4streampc.sv" \
  "C:/Xilinx/Vivado/2019.1/data/xilinx_vip/hdl/axi_vip_axi4pc.sv" \
  "C:/Xilinx/Vivado/2019.1/data/xilinx_vip/hdl/xil_common_vip_pkg.sv" \
  "C:/Xilinx/Vivado/2019.1/data/xilinx_vip/hdl/axi4stream_vip_pkg.sv" \
  "C:/Xilinx/Vivado/2019.1/data/xilinx_vip/hdl/axi_vip_pkg.sv" \
  "C:/Xilinx/Vivado/2019.1/data/xilinx_vip/hdl/axi4stream_vip_if.sv" \
  "C:/Xilinx/Vivado/2019.1/data/xilinx_vip/hdl/axi_vip_if.sv" \
  "C:/Xilinx/Vivado/2019.1/data/xilinx_vip/hdl/clk_vip_if.sv" \
  "C:/Xilinx/Vivado/2019.1/data/xilinx_vip/hdl/rst_vip_if.sv" \
-endlib
-makelib ies_lib/xil_defaultlib -sv \
  "C:/Xilinx/Vivado/2019.1/data/ip/xpm/xpm_cdc/hdl/xpm_cdc.sv" \
  "C:/Xilinx/Vivado/2019.1/data/ip/xpm/xpm_memory/hdl/xpm_memory.sv" \
-endlib
-makelib ies_lib/xpm \
  "C:/Xilinx/Vivado/2019.1/data/ip/xpm/xpm_VCOMP.vhd" \
-endlib
-makelib ies_lib/xil_defaultlib \
  "../../../bd/test/ip/test_axi_gpio_0_1/test_axi_gpio_0_1_sim_netlist.v" \
  "../../../bd/test/ip/test_zybo_audio_ctrl_0_0/test_zybo_audio_ctrl_0_0_sim_netlist.v" \
  "../../../bd/test/ip/test_axi_timer_0_0/test_axi_timer_0_0_sim_netlist.v" \
-endlib
-makelib ies_lib/xlconcat_v2_1_3 \
  "../../../../OrganNotes.srcs/sources_1/bd/test/ipshared/442e/hdl/xlconcat_v2_1_vl_rfs.v" \
-endlib
-makelib ies_lib/xil_defaultlib \
  "../../../bd/test/ip/test_xlconcat_0_0/sim/test_xlconcat_0_0.v" \
  "../../../bd/test/ip/test_axi_gpio_0_3/test_axi_gpio_0_3_sim_netlist.v" \
  "../../../bd/test/ip/test_axi_gpio_0_4/test_axi_gpio_0_4_sim_netlist.v" \
  "../../../bd/test/ip/test_axi_gpio_1_0/test_axi_gpio_1_0_sim_netlist.v" \
  "../../../bd/test/ip/test_processing_system7_0_0/test_processing_system7_0_0_sim_netlist.v" \
  "../../../bd/test/ip/test_xbar_0/test_xbar_0_sim_netlist.v" \
  "../../../bd/test/ip/test_rst_ps7_0_50M_0/test_rst_ps7_0_50M_0_sim_netlist.v" \
  "../../../bd/test/ipshared/ee8a/hdl/OrganHarmonizer_v1_0_S00_AXI.v" \
  "../../../bd/test/ipshared/ee8a/src/blender.v" \
  "../../../bd/test/ipshared/ee8a/src/fcw_ctrl.v" \
  "../../../bd/test/ipshared/ee8a/src/fcw_table.v" \
  "../../../bd/test/ipshared/ee8a/src/harmonizer.v" \
  "../../../bd/test/ipshared/ee8a/src/music_dds.v" \
  "../../../bd/test/ipshared/ee8a/src/nco.v" \
  "../../../bd/test/ipshared/ee8a/src/organ_note.v" \
  "../../../bd/test/ipshared/ee8a/src/sine_table.v" \
  "../../../bd/test/ipshared/ee8a/src/tone_gen.v" \
  "../../../bd/test/ipshared/ee8a/hdl/OrganHarmonizer_v1_0.v" \
  "../../../bd/test/ip/test_OrganHarmonizer_0_0/sim/test_OrganHarmonizer_0_0.v" \
  "../../../bd/test/ip/test_auto_pc_0/test_auto_pc_0_sim_netlist.v" \
  "../../../bd/test/sim/test.v" \
-endlib
-makelib ies_lib/xil_defaultlib \
  glbl.v
-endlib

