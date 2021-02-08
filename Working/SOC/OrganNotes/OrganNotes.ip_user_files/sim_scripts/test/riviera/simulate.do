onbreak {quit -force}
onerror {quit -force}

asim -t 1ps +access +r +m+test -L xilinx_vip -L xil_defaultlib -L xpm -L xlconcat_v2_1_3 -L xilinx_vip -L unisims_ver -L unimacro_ver -L secureip -O5 xil_defaultlib.test xil_defaultlib.glbl

do {wave.do}

view wave
view structure

do {test.udo}

run -all

endsim

quit -force
