transcript on
if {[file exists rtl_work]} {
	vdel -lib rtl_work -all
}
vlib rtl_work
vmap work rtl_work

vlog -vlog01compat -work work +incdir+C:/Users/arul2/Workspace/ELEC5566M-Assignment2-arul2810/ip {C:/Users/arul2/Workspace/ELEC5566M-Assignment2-arul2810/ip/DigitalLock.v}

vlog -vlog01compat -work work +incdir+C:/Users/arul2/Workspace/ELEC5566M-Assignment2-arul2810/simulation {C:/Users/arul2/Workspace/ELEC5566M-Assignment2-arul2810/simulation/DigitalLock_tb.v}

vsim -t 1ps -L altera_ver -L lpm_ver -L sgate_ver -L altera_mf_ver -L altera_lnsim_ver -L cyclonev_ver -L cyclonev_hssi_ver -L cyclonev_pcie_hip_ver -L rtl_work -L work -voptargs="+acc"  DigitalLock_tb

do C:/Users/arul2/Workspace/ELEC5566M-Assignment2-arul2810/../ELEC5566M-Resources/simulation/modelsim.tcl
