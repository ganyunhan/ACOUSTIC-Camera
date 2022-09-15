## part 1: new lib
vlib work
vmap work work


## part 2: load design
vlog -sv  ../../tb/prim_sim.v
vlog -sv ../../xcorr.vo
vlog -sv ../../tb/XCORR_tb.v

## part 3: sim design
vsim -novopt work.tb

## part 4: show ui 
view transcript

##part 5:add wave
add wave -noupdate /tb/clk
add wave -noupdate /tb/rst
add wave -noupdate /tb/start
add wave -noupdate /tb/series_x
add wave -noupdate /tb/series_y
add wave -noupdate /tb/result
add wave -noupdate /tb/complete
add wave -noupdate /tb/delay
add wave -noupdate /tb/ad
add wave -noupdate /tb/k
add wave -noupdate /tb/m
add wave -noupdate /tb/ip_result
add wave -noupdate /tb/golden_result

## part 6: run 
run -all


