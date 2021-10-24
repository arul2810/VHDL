transcript on
if {[file exists rtl_work]} {
	vdel -lib rtl_work -all
}
vlib rtl_work
vmap work rtl_work

vlog -vlog01compat -work work +incdir+D:/Projects/VHDL/3-2-LT24TestProject {D:/Projects/VHDL/3-2-LT24TestProject/LT24Display.v}
vlog -vlog01compat -work work +incdir+D:/Projects/VHDL/3-2-LT24TestProject {D:/Projects/VHDL/3-2-LT24TestProject/LT24Top.v}

vlog -vlog01compat -work work +incdir+D:/Projects/VHDL/3-2-LT24TestProject/simulation {D:/Projects/VHDL/3-2-LT24TestProject/simulation/LT24Top_tb.v}
vlog -vlog01compat -work work +incdir+D:/Projects/VHDL/3-2-LT24TestProject/simulation {D:/Projects/VHDL/3-2-LT24TestProject/simulation/LT24FunctionalModel.v}

vsim -t 1ps -L altera_ver -L lpm_ver -L sgate_ver -L altera_mf_ver -L altera_lnsim_ver -L cyclonev_ver -L cyclonev_hssi_ver -L cyclonev_pcie_hip_ver -L rtl_work -L work -voptargs="+acc"  LT24Top_tb

do D:/Projects/VHDL/3-2-LT24TestProject/../../ELEC5566M-Resources/simulation/load_sim.tcl
