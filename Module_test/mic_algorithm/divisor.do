## part 1: new lib
vlib work
vmap work work

## part 2: load design
vlog -sv -novopt -incr -work work "./tb.v"
vlog -sv -novopt +incdir+../tb -work work "./divisor_cell.v"
vlog -sv -novopt +incdir+../tb -work work "./divisor_top.v"
vlog -sv -novopt +incdir+../tb -work work "./sqrt.v"
vlog -sv -novopt +incdir+../tb -work work "./cal_position_6+1.v"

## part 3: sim design
vsim  -novopt work.tb

## part 4: add signals
add wave -group "tb" {sim:/tb/*}
add wave -group "cal" {sim:/tb/u_cal_position/*}
add wave -group "cal" {sim:/tb/u_cal_position/distance}

## part 5: show ui 
view wave
view structure
view signals

## part 6: run 
run 20000ns
