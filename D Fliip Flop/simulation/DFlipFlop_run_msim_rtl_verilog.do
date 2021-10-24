transcript on
if {[file exists rtl_work]} {
	vdel -lib rtl_work -all
}
vlib rtl_work
vmap work rtl_work

vlog -vlog01compat -work work +incdir+D:/Projects/VHDL/D\ Fliip\ Flop {D:/Projects/VHDL/D Fliip Flop/DFlipFlop.v}

vlog -vlog01compat -work work +incdir+D:/Projects/VHDL/D\ Fliip\ Flop {D:/Projects/VHDL/D Fliip Flop/DFlipFlop_tb.v}

vsim -t 1ps -L altera_ver -L lpm_ver -L sgate_ver -L altera_mf_ver -L altera_lnsim_ver -L cyclonev_ver -L cyclonev_hssi_ver -L cyclonev_pcie_hip_ver -L rtl_work -L work -voptargs="+acc"  DFlipFlop_tb

do C:/Users/arul2/Workspace/ELEC5566M-Resources/simulation/load_sim.tcl
