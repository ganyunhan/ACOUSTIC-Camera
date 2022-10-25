## part 1: new lib
vlib work
vmap work work

## part 2: load design

vlog -sv -novopt -incr -work work "../tb/prim_sim.v"
vlog -sv -novopt +incdir+../tb -work work "../../project/impl/gwsynthesis/ACOUSTIC-Camera.vg"
vlog -sv -novopt +incdir+../tb -work work "../tb/tb_top_impl.v"

## part 3: sim design
vsim  -novopt work.tb

## part 4: add signals
add wave -group "tb" {sim:/tb/*}
add wave -group "calc" {sim:/tb/U_TOP/U_CAL_POSITION/*}
add wave -group "sqrt" {sim:/tb/U_TOP/U_CAL_POSITION/U_SQRT/*}

## part 5: show ui 
view wave
view structure
view signals

## part 6: run 
## run 9060000ns
run 120000ns
