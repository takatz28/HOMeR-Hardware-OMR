# Definitional proc to organize widgets for parameters.
proc init_gui { IPINST } {
  ipgui::add_param $IPINST -name "Component_Name"
  #Adding Page
  set Page_0 [ipgui::add_page $IPINST -name "Page 0"]
  ipgui::add_param $IPINST -name "C_BASEADDR" -parent ${Page_0}
  ipgui::add_param $IPINST -name "C_HIGHADDR" -parent ${Page_0}
  ipgui::add_param $IPINST -name "C_S_AXI_MIN_SIZE" -parent ${Page_0}
  ipgui::add_param $IPINST -name "PCORE_DEVICE_TYPE" -parent ${Page_0}
  ipgui::add_param $IPINST -name "PCORE_ID" -parent ${Page_0}
  ipgui::add_param $IPINST -name "PCORE_IODELAY_GROUP" -parent ${Page_0}


}

proc update_PARAM_VALUE.C_BASEADDR { PARAM_VALUE.C_BASEADDR } {
	# Procedure called to update C_BASEADDR when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.C_BASEADDR { PARAM_VALUE.C_BASEADDR } {
	# Procedure called to validate C_BASEADDR
	return true
}

proc update_PARAM_VALUE.C_HIGHADDR { PARAM_VALUE.C_HIGHADDR } {
	# Procedure called to update C_HIGHADDR when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.C_HIGHADDR { PARAM_VALUE.C_HIGHADDR } {
	# Procedure called to validate C_HIGHADDR
	return true
}

proc update_PARAM_VALUE.C_S_AXI_MIN_SIZE { PARAM_VALUE.C_S_AXI_MIN_SIZE } {
	# Procedure called to update C_S_AXI_MIN_SIZE when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.C_S_AXI_MIN_SIZE { PARAM_VALUE.C_S_AXI_MIN_SIZE } {
	# Procedure called to validate C_S_AXI_MIN_SIZE
	return true
}

proc update_PARAM_VALUE.PCORE_DEVICE_TYPE { PARAM_VALUE.PCORE_DEVICE_TYPE } {
	# Procedure called to update PCORE_DEVICE_TYPE when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.PCORE_DEVICE_TYPE { PARAM_VALUE.PCORE_DEVICE_TYPE } {
	# Procedure called to validate PCORE_DEVICE_TYPE
	return true
}

proc update_PARAM_VALUE.PCORE_ID { PARAM_VALUE.PCORE_ID } {
	# Procedure called to update PCORE_ID when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.PCORE_ID { PARAM_VALUE.PCORE_ID } {
	# Procedure called to validate PCORE_ID
	return true
}

proc update_PARAM_VALUE.PCORE_IODELAY_GROUP { PARAM_VALUE.PCORE_IODELAY_GROUP } {
	# Procedure called to update PCORE_IODELAY_GROUP when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.PCORE_IODELAY_GROUP { PARAM_VALUE.PCORE_IODELAY_GROUP } {
	# Procedure called to validate PCORE_IODELAY_GROUP
	return true
}


proc update_MODELPARAM_VALUE.PCORE_ID { MODELPARAM_VALUE.PCORE_ID PARAM_VALUE.PCORE_ID } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.PCORE_ID}] ${MODELPARAM_VALUE.PCORE_ID}
}

proc update_MODELPARAM_VALUE.PCORE_DEVICE_TYPE { MODELPARAM_VALUE.PCORE_DEVICE_TYPE PARAM_VALUE.PCORE_DEVICE_TYPE } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.PCORE_DEVICE_TYPE}] ${MODELPARAM_VALUE.PCORE_DEVICE_TYPE}
}

proc update_MODELPARAM_VALUE.PCORE_IODELAY_GROUP { MODELPARAM_VALUE.PCORE_IODELAY_GROUP PARAM_VALUE.PCORE_IODELAY_GROUP } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.PCORE_IODELAY_GROUP}] ${MODELPARAM_VALUE.PCORE_IODELAY_GROUP}
}

proc update_MODELPARAM_VALUE.C_S_AXI_MIN_SIZE { MODELPARAM_VALUE.C_S_AXI_MIN_SIZE PARAM_VALUE.C_S_AXI_MIN_SIZE } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.C_S_AXI_MIN_SIZE}] ${MODELPARAM_VALUE.C_S_AXI_MIN_SIZE}
}

proc update_MODELPARAM_VALUE.C_BASEADDR { MODELPARAM_VALUE.C_BASEADDR PARAM_VALUE.C_BASEADDR } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.C_BASEADDR}] ${MODELPARAM_VALUE.C_BASEADDR}
}

proc update_MODELPARAM_VALUE.C_HIGHADDR { MODELPARAM_VALUE.C_HIGHADDR PARAM_VALUE.C_HIGHADDR } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.C_HIGHADDR}] ${MODELPARAM_VALUE.C_HIGHADDR}
}

