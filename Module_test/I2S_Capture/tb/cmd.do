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

add wave -group "fifo_0" {sim:/tb/U_TOP/u_FIFO_0_Top/WrClk}
add wave -group "fifo_0" {sim:/tb/U_TOP/u_FIFO_0_Top/WrEn}
add wave -group "fifo_0" {sim:/tb/U_TOP/u_FIFO_0_Top/Data}
add wave -group "fifo_0" {sim:/tb/U_TOP/u_FIFO_0_Top/Wnum}
add wave -group "fifo_0" {sim:/tb/U_TOP/u_FIFO_0_Top/RdClk}
add wave -group "fifo_0" {sim:/tb/U_TOP/u_FIFO_0_Top/RdEn}
add wave -group "fifo_0" {sim:/tb/U_TOP/u_FIFO_0_Top/Q}
add wave -group "fifo_0" {sim:/tb/U_TOP/u_FIFO_0_Top/Rnum}
add wave -group "fifo_0" {sim:/tb/U_TOP/u_FIFO_0_Top/Full}
add wave -group "fifo_0" {sim:/tb/U_TOP/u_FIFO_0_Top/Empty}

add wave -group "fifo_1" {sim:/tb/U_TOP/u_FIFO_1_Top/WrClk}
add wave -group "fifo_1" {sim:/tb/U_TOP/u_FIFO_1_Top/WrEn}
add wave -group "fifo_1" {sim:/tb/U_TOP/u_FIFO_1_Top/Data}
add wave -group "fifo_1" {sim:/tb/U_TOP/u_FIFO_1_Top/Wnum}
add wave -group "fifo_1" {sim:/tb/U_TOP/u_FIFO_1_Top/RdClk}
add wave -group "fifo_1" {sim:/tb/U_TOP/u_FIFO_1_Top/RdEn}
add wave -group "fifo_1" {sim:/tb/U_TOP/u_FIFO_1_Top/Q}
add wave -group "fifo_1" {sim:/tb/U_TOP/u_FIFO_1_Top/Rnum}
add wave -group "fifo_1" {sim:/tb/U_TOP/u_FIFO_1_Top/Full}
add wave -group "fifo_1" {sim:/tb/U_TOP/u_FIFO_1_Top/Empty}

add wave -group "fifo_2" {sim:/tb/U_TOP/u_FIFO_2_Top/WrClk}
add wave -group "fifo_2" {sim:/tb/U_TOP/u_FIFO_2_Top/WrEn}
add wave -group "fifo_2" {sim:/tb/U_TOP/u_FIFO_2_Top/Data}
add wave -group "fifo_2" {sim:/tb/U_TOP/u_FIFO_2_Top/Wnum}
add wave -group "fifo_2" {sim:/tb/U_TOP/u_FIFO_2_Top/RdClk}
add wave -group "fifo_2" {sim:/tb/U_TOP/u_FIFO_2_Top/RdEn}
add wave -group "fifo_2" {sim:/tb/U_TOP/u_FIFO_2_Top/Q}
add wave -group "fifo_2" {sim:/tb/U_TOP/u_FIFO_2_Top/Rnum}
add wave -group "fifo_2" {sim:/tb/U_TOP/u_FIFO_2_Top/Full}
add wave -group "fifo_2" {sim:/tb/U_TOP/u_FIFO_2_Top/Empty}

add wave -group "fifo_3" {sim:/tb/U_TOP/u_FIFO_3_Top/WrClk}
add wave -group "fifo_3" {sim:/tb/U_TOP/u_FIFO_3_Top/WrEn}
add wave -group "fifo_3" {sim:/tb/U_TOP/u_FIFO_3_Top/Data}
add wave -group "fifo_3" {sim:/tb/U_TOP/u_FIFO_3_Top/Wnum}
add wave -group "fifo_3" {sim:/tb/U_TOP/u_FIFO_3_Top/RdClk}
add wave -group "fifo_3" {sim:/tb/U_TOP/u_FIFO_3_Top/RdEn}
add wave -group "fifo_3" {sim:/tb/U_TOP/u_FIFO_3_Top/Q}
add wave -group "fifo_3" {sim:/tb/U_TOP/u_FIFO_3_Top/Rnum}
add wave -group "fifo_3" {sim:/tb/U_TOP/u_FIFO_3_Top/Full}
add wave -group "fifo_3" {sim:/tb/U_TOP/u_FIFO_3_Top/Empty}

add wave -group "fifo_4" {sim:/tb/U_TOP/u_FIFO_4_Top/WrClk}
add wave -group "fifo_4" {sim:/tb/U_TOP/u_FIFO_4_Top/WrEn}
add wave -group "fifo_4" {sim:/tb/U_TOP/u_FIFO_4_Top/Data}
add wave -group "fifo_4" {sim:/tb/U_TOP/u_FIFO_4_Top/Wnum}
add wave -group "fifo_4" {sim:/tb/U_TOP/u_FIFO_4_Top/RdClk}
add wave -group "fifo_4" {sim:/tb/U_TOP/u_FIFO_4_Top/RdEn}
add wave -group "fifo_4" {sim:/tb/U_TOP/u_FIFO_4_Top/Q}
add wave -group "fifo_4" {sim:/tb/U_TOP/u_FIFO_4_Top/Rnum}
add wave -group "fifo_4" {sim:/tb/U_TOP/u_FIFO_4_Top/Full}
add wave -group "fifo_4" {sim:/tb/U_TOP/u_FIFO_4_Top/Empty}

add wave -group "fifo_5" {sim:/tb/U_TOP/u_FIFO_5_Top/WrClk}
add wave -group "fifo_5" {sim:/tb/U_TOP/u_FIFO_5_Top/WrEn}
add wave -group "fifo_5" {sim:/tb/U_TOP/u_FIFO_5_Top/Data}
add wave -group "fifo_5" {sim:/tb/U_TOP/u_FIFO_5_Top/Wnum}
add wave -group "fifo_5" {sim:/tb/U_TOP/u_FIFO_5_Top/RdClk}
add wave -group "fifo_5" {sim:/tb/U_TOP/u_FIFO_5_Top/RdEn}
add wave -group "fifo_5" {sim:/tb/U_TOP/u_FIFO_5_Top/Q}
add wave -group "fifo_5" {sim:/tb/U_TOP/u_FIFO_5_Top/Rnum}
add wave -group "fifo_5" {sim:/tb/U_TOP/u_FIFO_5_Top/Full}
add wave -group "fifo_5" {sim:/tb/U_TOP/u_FIFO_5_Top/Empty}

add wave -group "fifo_6" {sim:/tb/U_TOP/u_FIFO_6_Top/WrClk}
add wave -group "fifo_6" {sim:/tb/U_TOP/u_FIFO_6_Top/WrEn}
add wave -group "fifo_6" {sim:/tb/U_TOP/u_FIFO_6_Top/Data}
add wave -group "fifo_6" {sim:/tb/U_TOP/u_FIFO_6_Top/Wnum}
add wave -group "fifo_6" {sim:/tb/U_TOP/u_FIFO_6_Top/RdClk}
add wave -group "fifo_6" {sim:/tb/U_TOP/u_FIFO_6_Top/RdEn}
add wave -group "fifo_6" {sim:/tb/U_TOP/u_FIFO_6_Top/Q}
add wave -group "fifo_6" {sim:/tb/U_TOP/u_FIFO_6_Top/Rnum}
add wave -group "fifo_6" {sim:/tb/U_TOP/u_FIFO_6_Top/Full}
add wave -group "fifo_6" {sim:/tb/U_TOP/u_FIFO_6_Top/Empty}

## part 5: show ui 
view wave
view structure
view signals

## part 6: run 
## run 9060000ns
run 9100000ns
