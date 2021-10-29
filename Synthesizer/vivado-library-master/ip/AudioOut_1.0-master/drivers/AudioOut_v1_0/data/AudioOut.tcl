

proc generate {drv_handle} {
	xdefine_include_file $drv_handle "xparameters.h" "AudioOut" "NUM_INSTANCES" "DEVICE_ID"  "C_config_port_BASEADDR" "C_config_port_HIGHADDR"
}
