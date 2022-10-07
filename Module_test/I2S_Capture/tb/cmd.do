## part 1: new lib
vlib work
vmap work work

## part 2: load design

vlog -sv -novopt -incr -work work "prim_sim.v"
vlog -sv -novopt +incdir+../tb -work work "../src/audio_process/mic_subsys.v"
vlog -sv -novopt +incdir+../tb -work work "tb.v"
vlog -sv -novopt +incdir+../tb -work work "../src/audio_process/i2s_decoder.v"
vlog -sv -novopt +incdir+../tb -work work "../src/fifo_hs/fifo_hs.vo"
vlog -sv -novopt +incdir+../tb -work work "../src/gao_clk/gao_clk.v"
vlog -sv -novopt +incdir+../tb -work work "../src/gowin_rpll/rpll_81MHz.v"
vlog -sv -novopt +incdir+../tb -work work "../src/bus_cnt_width.v"
vlog -sv -novopt +incdir+../tb -work work "../src/clk_div.v"
vlog -sv -novopt +incdir+../tb -work work "../src/clk_div_64.v"
vlog -sv -novopt +incdir+../tb -work work "../src/uart_top.v"
vlog -sv -novopt +incdir+../tb -work work "../src/uart_tx.v"


## part 3: sim design
vsim  -novopt work.tb

## part 4: add signals
add wave -group "tb" {sim:/tb/*}
add wave -group "modles" {sim:/tb/U_TOP/*}
add wave -group "uart" {sim:/tb/U_TOP/u_uart_top/*}
add wave -group "fifo_l" {sim:/tb/U_TOP/u_FIFO_L_Top/WrClk}
add wave -group "fifo_l" {sim:/tb/U_TOP/u_FIFO_L_Top/WrEn}
add wave -group "fifo_l" {sim:/tb/U_TOP/u_FIFO_L_Top/Data}
add wave -group "fifo_l" {sim:/tb/U_TOP/u_FIFO_L_Top/Wnum}
add wave -group "fifo_l" {sim:/tb/U_TOP/u_FIFO_L_Top/RdClk}
add wave -group "fifo_l" {sim:/tb/U_TOP/u_FIFO_L_Top/RdEn}
add wave -group "fifo_l" {sim:/tb/U_TOP/u_FIFO_L_Top/Q}
add wave -group "fifo_l" {sim:/tb/U_TOP/u_FIFO_L_Top/Rnum}
add wave -group "fifo_l" {sim:/tb/U_TOP/u_FIFO_L_Top/Full}
add wave -group "fifo_l" {sim:/tb/U_TOP/u_FIFO_L_Top/Empty}

add wave -group "fifo_r" {sim:/tb/U_TOP/u_FIFO_R_Top/WrClk}
add wave -group "fifo_r" {sim:/tb/U_TOP/u_FIFO_R_Top/WrEn}
add wave -group "fifo_r" {sim:/tb/U_TOP/u_FIFO_R_Top/Data}
add wave -group "fifo_r" {sim:/tb/U_TOP/u_FIFO_R_Top/Wnum}
add wave -group "fifo_r" {sim:/tb/U_TOP/u_FIFO_R_Top/RdClk}
add wave -group "fifo_r" {sim:/tb/U_TOP/u_FIFO_R_Top/RdEn}
add wave -group "fifo_r" {sim:/tb/U_TOP/u_FIFO_R_Top/Q}
add wave -group "fifo_r" {sim:/tb/U_TOP/u_FIFO_R_Top/Rnum}
add wave -group "fifo_r" {sim:/tb/U_TOP/u_FIFO_R_Top/Full}
add wave -group "fifo_r" {sim:/tb/U_TOP/u_FIFO_R_Top/Empty}

## part 5: show ui 
view wave
view structure
view signals

## part 6: run 
## run 9060000ns
run 9100000ns
