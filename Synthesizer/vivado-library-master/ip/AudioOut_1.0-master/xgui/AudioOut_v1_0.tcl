# Definitional proc to organize widgets for parameters.
proc init_gui { IPINST } {
  ipgui::add_param $IPINST -name "Component_Name"
  #Adding Page
  set Page_0 [ipgui::add_page $IPINST -name "Page 0"]
  set C_config_port_DATA_WIDTH [ipgui::add_param $IPINST -name "C_config_port_DATA_WIDTH" -parent ${Page_0} -widget comboBox]
  set_property tooltip {Width of S_AXI data bus} ${C_config_port_DATA_WIDTH}
  set C_config_port_ADDR_WIDTH [ipgui::add_param $IPINST -name "C_config_port_ADDR_WIDTH" -parent ${Page_0}]
  set_property tooltip {Width of S_AXI address bus} ${C_config_port_ADDR_WIDTH}
  ipgui::add_param $IPINST -name "C_config_port_BASEADDR" -parent ${Page_0}
  ipgui::add_param $IPINST -name "C_config_port_HIGHADDR" -parent ${Page_0}
  set C_data_port_ADDR_WIDTH [ipgui::add_param $IPINST -name "C_data_port_ADDR_WIDTH" -parent ${Page_0}]
  set_property tooltip {Width of M_AXI address bus. 
    -- The master generates the read and write addresses of width specified as C_M_AXI_ADDR_WIDTH.} ${C_data_port_ADDR_WIDTH}
  set C_data_port_DATA_WIDTH [ipgui::add_param $IPINST -name "C_data_port_DATA_WIDTH" -parent ${Page_0} -widget comboBox]
  set_property tooltip {Width of M_AXI data bus. 
    -- The master issues write data and accept read data where the width of the data bus is C_M_AXI_DATA_WIDTH} ${C_data_port_DATA_WIDTH}


}

proc update_PARAM_VALUE.DEFAULT_START_ADDR { PARAM_VALUE.DEFAULT_START_ADDR } {
	# Procedure called to update DEFAULT_START_ADDR when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.DEFAULT_START_ADDR { PARAM_VALUE.DEFAULT_START_ADDR } {
	# Procedure called to validate DEFAULT_START_ADDR
	return true
}

proc update_PARAM_VALUE.C_config_port_DATA_WIDTH { PARAM_VALUE.C_config_port_DATA_WIDTH } {
	# Procedure called to update C_config_port_DATA_WIDTH when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.C_config_port_DATA_WIDTH { PARAM_VALUE.C_config_port_DATA_WIDTH } {
	# Procedure called to validate C_config_port_DATA_WIDTH
	return true
}

proc update_PARAM_VALUE.C_config_port_ADDR_WIDTH { PARAM_VALUE.C_config_port_ADDR_WIDTH } {
	# Procedure called to update C_config_port_ADDR_WIDTH when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.C_config_port_ADDR_WIDTH { PARAM_VALUE.C_config_port_ADDR_WIDTH } {
	# Procedure called to validate C_config_port_ADDR_WIDTH
	return true
}

proc update_PARAM_VALUE.C_config_port_BASEADDR { PARAM_VALUE.C_config_port_BASEADDR } {
	# Procedure called to update C_config_port_BASEADDR when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.C_config_port_BASEADDR { PARAM_VALUE.C_config_port_BASEADDR } {
	# Procedure called to validate C_config_port_BASEADDR
	return true
}

proc update_PARAM_VALUE.C_config_port_HIGHADDR { PARAM_VALUE.C_config_port_HIGHADDR } {
	# Procedure called to update C_config_port_HIGHADDR when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.C_config_port_HIGHADDR { PARAM_VALUE.C_config_port_HIGHADDR } {
	# Procedure called to validate C_config_port_HIGHADDR
	return true
}

proc update_PARAM_VALUE.C_data_port_ADDR_WIDTH { PARAM_VALUE.C_data_port_ADDR_WIDTH } {
	# Procedure called to update C_data_port_ADDR_WIDTH when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.C_data_port_ADDR_WIDTH { PARAM_VALUE.C_data_port_ADDR_WIDTH } {
	# Procedure called to validate C_data_port_ADDR_WIDTH
	return true
}

proc update_PARAM_VALUE.C_data_port_DATA_WIDTH { PARAM_VALUE.C_data_port_DATA_WIDTH } {
	# Procedure called to update C_data_port_DATA_WIDTH when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.C_data_port_DATA_WIDTH { PARAM_VALUE.C_data_port_DATA_WIDTH } {
	# Procedure called to validate C_data_port_DATA_WIDTH
	return true
}


proc update_MODELPARAM_VALUE.C_config_port_DATA_WIDTH { MODELPARAM_VALUE.C_config_port_DATA_WIDTH PARAM_VALUE.C_config_port_DATA_WIDTH } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.C_config_port_DATA_WIDTH}] ${MODELPARAM_VALUE.C_config_port_DATA_WIDTH}
}

proc update_MODELPARAM_VALUE.C_config_port_ADDR_WIDTH { MODELPARAM_VALUE.C_config_port_ADDR_WIDTH PARAM_VALUE.C_config_port_ADDR_WIDTH } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.C_config_port_ADDR_WIDTH}] ${MODELPARAM_VALUE.C_config_port_ADDR_WIDTH}
}

proc update_MODELPARAM_VALUE.C_data_port_ADDR_WIDTH { MODELPARAM_VALUE.C_data_port_ADDR_WIDTH PARAM_VALUE.C_data_port_ADDR_WIDTH } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.C_data_port_ADDR_WIDTH}] ${MODELPARAM_VALUE.C_data_port_ADDR_WIDTH}
}

proc update_MODELPARAM_VALUE.C_data_port_DATA_WIDTH { MODELPARAM_VALUE.C_data_port_DATA_WIDTH PARAM_VALUE.C_data_port_DATA_WIDTH } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.C_data_port_DATA_WIDTH}] ${MODELPARAM_VALUE.C_data_port_DATA_WIDTH}
}

proc update_MODELPARAM_VALUE.DEFAULT_START_ADDR { MODELPARAM_VALUE.DEFAULT_START_ADDR PARAM_VALUE.DEFAULT_START_ADDR } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.DEFAULT_START_ADDR}] ${MODELPARAM_VALUE.DEFAULT_START_ADDR}
}

