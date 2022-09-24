## part 1: new lib
vlib work
vmap work work

## part 2: load design

vlog -sv -novopt -incr -work work "../tb/prim_sim.v"
vlog -sv -novopt +incdir+../tb -work work "../../project/src/rtl/top.v"
vlog -sv -novopt +incdir+../tb -work work "../../project/src/fifo_hs/fifo_hs.vo"
vlog -sv -novopt +incdir+../tb -work work "../../project/src/gowin_rpll/rpll_mic.v"
vlog -sv -novopt +incdir+../tb -work work "../../project/src/rtl/audio_process/abs.v"
vlog -sv -novopt +incdir+../tb -work work "../../project/src/rtl/audio_process/i2s_decoder.v"
vlog -sv -novopt +incdir+../tb -work work "../../project/src/rtl/audio_process/mic_subsys.v"
vlog -sv -novopt +incdir+../tb -work work "../../project/src/rtl/clock_and_reset/clk_div.v"
vlog -sv -novopt +incdir+../tb -work work "../../project/src/rtl/clock_and_reset/clk_div_64.v"
vlog -sv -novopt +incdir+../tb -work work "../../project/src/rtl/clock_and_reset/clock_manage.v"
vlog -sv -novopt +incdir+../tb -work work "../../project/src/xcorr/xcorr.vo"

vlog -sv -novopt +incdir+../tb -work work "../tb/tb.v"
vlog -sv -novopt +incdir+../tb -work work "../tb/eliminate_shake.v"

## part 3: sim design
vsim  -novopt work.tb

## part 4: add signals
add wave -group "tb" {sim:/tb/*}
add wave -group "XCORR" {sim:/tb/U_TOP/U_MIC_SUBSYS/*}


## part 5: show ui 
view wave
view structure
view signals

## part 6: run 
run 400000ns

