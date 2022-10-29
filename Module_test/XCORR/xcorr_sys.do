## part 1: new lib
vlib work
vmap work work

## part 2: load design

vlog -sv -novopt -incr -work work "../tb/prim_sim.v"
vlog -sv -novopt +incdir+../tb -work work "../../project/src/rtl/top.v"

vlog -sv -novopt +incdir+../tb -work work "../../project/src/ram_512/ram_512.v"
vlog -sv -novopt +incdir+../tb -work work "../../project/src/ram_512/ram0_512.v"
vlog -sv -novopt +incdir+../tb -work work "../../project/src/ram_512/ram1_512.v"
vlog -sv -novopt +incdir+../tb -work work "../../project/src/ram_512/ram2_512.v"
vlog -sv -novopt +incdir+../tb -work work "../../project/src/ram_512/ram3_512.v"
vlog -sv -novopt +incdir+../tb -work work "../../project/src/ram_512/ram4_512.v"
vlog -sv -novopt +incdir+../tb -work work "../../project/src/ram_512/ram5_512.v"
vlog -sv -novopt +incdir+../tb -work work "../../project/src/ram_512/ram6_512.v"
vlog -sv -novopt +incdir+../tb -work work "../../project/src/gowin_prom/acos_rom.v"

vlog -sv -novopt +incdir+../tb -work work "../../project/src/gowin_rpll/rpll_mic.v"
vlog -sv -novopt +incdir+../tb -work work "../../project/src/gowin_rpll/rpll_9MHz.v"
vlog -sv -novopt +incdir+../tb -work work "../../project/src/rpll_9M_to_12M_24M/rpll_9M_to_12M_24M.v"

vlog -sv -novopt +incdir+../tb -work work "../../project/src/rtl/audio_process/abs.v"
vlog -sv -novopt +incdir+../tb -work work "../../project/src/rtl/audio_process/i2s_decoder.v"
vlog -sv -novopt +incdir+../tb -work work "../../project/src/rtl/audio_process/mic_subsys.v"

vlog -sv -novopt +incdir+../tb -work work "../../project/src/rtl/video_process/cmos_8_16bit.v"
vlog -sv -novopt +incdir+../tb -work work "../../project/src/rtl/video_process/color_bar.v"
vlog -sv -novopt +incdir+../tb -work work "../../project/src/rtl/video_process/video_subsys.v"
vlog -sv -novopt +incdir+../tb -work work "../../project/src/rtl/video_process/video_timing_data.v"
vlog -sv -novopt +incdir+../tb -work work "../../project/src/rtl/video_process/fifo_hs/video_fifo.vo"
vlog -sv -novopt +incdir+../tb -work work "../../project/src/rtl/video_process/hotspot_map/gowin_prom.v"
vlog -sv -novopt +incdir+../tb -work work "../../project/src/rtl/video_process/hotspot_map/hotspot_show.v"
vlog -sv -novopt +incdir+../tb -work work "../../project/src/rtl/video_process/iic_init/iic_ctrl.sv"
vlog -sv -novopt +incdir+../tb -work work "../../project/src/rtl/video_process/iic_init/iic_master.sv"

vlog -sv -novopt +incdir+../tb -work work "../../project/src/rtl/uart/uart_top.v"
vlog -sv -novopt +incdir+../tb -work work "../../project/src/rtl/uart/uart_tx.v"

vlog -sv -novopt +incdir+../tb -work work "../../project/src/rtl/clock_and_reset/clk_div.v"
vlog -sv -novopt +incdir+../tb -work work "../../project/src/rtl/clock_and_reset/clk_div_64.v"
vlog -sv -novopt +incdir+../tb -work work "../../project/src/rtl/clock_and_reset/clock_manage.v"

vlog -sv -novopt +incdir+../tb -work work "../../project/src/rtl/cal_position/bi_microphone.v"
vlog -sv -novopt +incdir+../tb -work work "../../project/src/rtl/cal_position/cal_position_6+1.v"
vlog -sv -novopt +incdir+../tb -work work "../../project/src/rtl/cal_position/divisor_cell.v"
vlog -sv -novopt +incdir+../tb -work work "../../project/src/rtl/cal_position/divisor_top.v"
vlog -sv -novopt +incdir+../tb -work work "../../project/src/rtl/cal_position/sqrt.v"

vlog -sv -novopt +incdir+../tb -work work "../../project/src/rtl/audio_process/mic_subsys_6+1.v"

vlog -sv -novopt +incdir+../tb -work work "../../project/src/xcorr/xcorr.vo"
vlog -sv -novopt +incdir+../src/define/ -incr -work work "../../project/src/xcorr_new/XCORR.vo"

vlog -sv -novopt +incdir+../tb -work work "../tb/tb_top.v"
vlog -sv -novopt +incdir+../tb -work work "../tb/eliminate_shake.v"

## part 3: sim design
vsim  -novopt work.tb

## part 4: add signals
add wave -group "tb" {sim:/tb/*}
add wave -group "subsys" {sim:/tb/U_TOP/U_MIC_SUBSYS/*}

## add wave -group "subsys/ram_0" {sim:/tb/U_TOP/U_MIC_SUBSYS/MIC_DATA_RAM[0]/U_RAM_512/*}
## add wave -group "subsys/ram_1" {sim:/tb/U_TOP/U_MIC_SUBSYS/MIC_DATA_RAM[1]/U_RAM_512/*}
## add wave -group "subsys/ram_2" {sim:/tb/U_TOP/U_MIC_SUBSYS/MIC_DATA_RAM[2]/U_RAM_512/*}
## add wave -group "subsys/ram_3" {sim:/tb/U_TOP/U_MIC_SUBSYS/MIC_DATA_RAM[3]/U_RAM_512/*}
## add wave -group "subsys/ram_4" {sim:/tb/U_TOP/U_MIC_SUBSYS/MIC_DATA_RAM[4]/U_RAM_512/*}
## add wave -group "subsys/ram_5" {sim:/tb/U_TOP/U_MIC_SUBSYS/MIC_DATA_RAM[5]/U_RAM_512/*}
## add wave -group "subsys/ram_6" {sim:/tb/U_TOP/U_MIC_SUBSYS/MIC_DATA_RAM[6]/U_RAM_512/*}

## add wave -group "subsys/ram_0" {sim:/tb/U_TOP/U_MIC_SUBSYS/U_RAM0_512/*}
## add wave -group "subsys/ram_1" {sim:/tb/U_TOP/U_MIC_SUBSYS/U_RAM1_512/*}
## add wave -group "subsys/ram_2" {sim:/tb/U_TOP/U_MIC_SUBSYS/U_RAM2_512/*}
## add wave -group "subsys/ram_3" {sim:/tb/U_TOP/U_MIC_SUBSYS/U_RAM3_512/*}
## add wave -group "subsys/ram_4" {sim:/tb/U_TOP/U_MIC_SUBSYS/U_RAM4_512/*}
## add wave -group "subsys/ram_5" {sim:/tb/U_TOP/U_MIC_SUBSYS/U_RAM5_512/*}
## add wave -group "subsys/ram_6" {sim:/tb/U_TOP/U_MIC_SUBSYS/U_RAM6_512/*}

add wave -group "subsys/xcorr_1" {sim:/tb/U_TOP/U_MIC_SUBSYS/XCORR_MODULE[1]/U_XCORR_TOP/series_x}
add wave -group "subsys/xcorr_1" {sim:/tb/U_TOP/U_MIC_SUBSYS/XCORR_MODULE[1]/U_XCORR_TOP/series_y}
add wave -group "subsys/xcorr_1" {sim:/tb/U_TOP/U_MIC_SUBSYS/XCORR_MODULE[1]/U_XCORR_TOP/clk}
add wave -group "subsys/xcorr_1" {sim:/tb/U_TOP/U_MIC_SUBSYS/XCORR_MODULE[1]/U_XCORR_TOP/rstn}
add wave -group "subsys/xcorr_1" {sim:/tb/U_TOP/U_MIC_SUBSYS/XCORR_MODULE[1]/U_XCORR_TOP/result}
add wave -group "subsys/xcorr_1" {sim:/tb/U_TOP/U_MIC_SUBSYS/XCORR_MODULE[1]/U_XCORR_TOP/complete}
add wave -group "subsys/xcorr_1" {sim:/tb/U_TOP/U_MIC_SUBSYS/XCORR_MODULE[1]/U_XCORR_TOP/delay}

add wave -group "subsys/xcorr_2" {sim:/tb/U_TOP/U_MIC_SUBSYS/XCORR_MODULE[2]/U_XCORR_TOP/series_x}
add wave -group "subsys/xcorr_2" {sim:/tb/U_TOP/U_MIC_SUBSYS/XCORR_MODULE[2]/U_XCORR_TOP/series_y}
add wave -group "subsys/xcorr_2" {sim:/tb/U_TOP/U_MIC_SUBSYS/XCORR_MODULE[2]/U_XCORR_TOP/clk}
add wave -group "subsys/xcorr_2" {sim:/tb/U_TOP/U_MIC_SUBSYS/XCORR_MODULE[2]/U_XCORR_TOP/rstn}
add wave -group "subsys/xcorr_2" {sim:/tb/U_TOP/U_MIC_SUBSYS/XCORR_MODULE[2]/U_XCORR_TOP/result}
add wave -group "subsys/xcorr_2" {sim:/tb/U_TOP/U_MIC_SUBSYS/XCORR_MODULE[2]/U_XCORR_TOP/complete}
add wave -group "subsys/xcorr_2" {sim:/tb/U_TOP/U_MIC_SUBSYS/XCORR_MODULE[2]/U_XCORR_TOP/delay}

add wave -group "subsys/xcorr_3" {sim:/tb/U_TOP/U_MIC_SUBSYS/XCORR_MODULE[3]/U_XCORR_TOP/series_x}
add wave -group "subsys/xcorr_3" {sim:/tb/U_TOP/U_MIC_SUBSYS/XCORR_MODULE[3]/U_XCORR_TOP/series_y}
add wave -group "subsys/xcorr_3" {sim:/tb/U_TOP/U_MIC_SUBSYS/XCORR_MODULE[3]/U_XCORR_TOP/clk}
add wave -group "subsys/xcorr_3" {sim:/tb/U_TOP/U_MIC_SUBSYS/XCORR_MODULE[3]/U_XCORR_TOP/rstn}
add wave -group "subsys/xcorr_3" {sim:/tb/U_TOP/U_MIC_SUBSYS/XCORR_MODULE[3]/U_XCORR_TOP/result}
add wave -group "subsys/xcorr_3" {sim:/tb/U_TOP/U_MIC_SUBSYS/XCORR_MODULE[3]/U_XCORR_TOP/complete}
add wave -group "subsys/xcorr_3" {sim:/tb/U_TOP/U_MIC_SUBSYS/XCORR_MODULE[3]/U_XCORR_TOP/delay}

add wave -group "subsys/xcorr_4" {sim:/tb/U_TOP/U_MIC_SUBSYS/XCORR_MODULE[4]/U_XCORR_TOP/series_x}
add wave -group "subsys/xcorr_4" {sim:/tb/U_TOP/U_MIC_SUBSYS/XCORR_MODULE[4]/U_XCORR_TOP/series_y}
add wave -group "subsys/xcorr_4" {sim:/tb/U_TOP/U_MIC_SUBSYS/XCORR_MODULE[4]/U_XCORR_TOP/clk}
add wave -group "subsys/xcorr_4" {sim:/tb/U_TOP/U_MIC_SUBSYS/XCORR_MODULE[4]/U_XCORR_TOP/rstn}
add wave -group "subsys/xcorr_4" {sim:/tb/U_TOP/U_MIC_SUBSYS/XCORR_MODULE[4]/U_XCORR_TOP/result}
add wave -group "subsys/xcorr_4" {sim:/tb/U_TOP/U_MIC_SUBSYS/XCORR_MODULE[4]/U_XCORR_TOP/complete}
add wave -group "subsys/xcorr_4" {sim:/tb/U_TOP/U_MIC_SUBSYS/XCORR_MODULE[4]/U_XCORR_TOP/delay}

add wave -group "subsys/xcorr_5" {sim:/tb/U_TOP/U_MIC_SUBSYS/XCORR_MODULE[5]/U_XCORR_TOP/series_x}
add wave -group "subsys/xcorr_5" {sim:/tb/U_TOP/U_MIC_SUBSYS/XCORR_MODULE[5]/U_XCORR_TOP/series_y}
add wave -group "subsys/xcorr_5" {sim:/tb/U_TOP/U_MIC_SUBSYS/XCORR_MODULE[5]/U_XCORR_TOP/clk}
add wave -group "subsys/xcorr_5" {sim:/tb/U_TOP/U_MIC_SUBSYS/XCORR_MODULE[5]/U_XCORR_TOP/rstn}
add wave -group "subsys/xcorr_5" {sim:/tb/U_TOP/U_MIC_SUBSYS/XCORR_MODULE[5]/U_XCORR_TOP/result}
add wave -group "subsys/xcorr_5" {sim:/tb/U_TOP/U_MIC_SUBSYS/XCORR_MODULE[5]/U_XCORR_TOP/complete}
add wave -group "subsys/xcorr_5" {sim:/tb/U_TOP/U_MIC_SUBSYS/XCORR_MODULE[5]/U_XCORR_TOP/delay}

add wave -group "subsys/xcorr_6" {sim:/tb/U_TOP/U_MIC_SUBSYS/XCORR_MODULE[6]/U_XCORR_TOP/series_x}
add wave -group "subsys/xcorr_6" {sim:/tb/U_TOP/U_MIC_SUBSYS/XCORR_MODULE[6]/U_XCORR_TOP/series_y}
add wave -group "subsys/xcorr_6" {sim:/tb/U_TOP/U_MIC_SUBSYS/XCORR_MODULE[6]/U_XCORR_TOP/clk}
add wave -group "subsys/xcorr_6" {sim:/tb/U_TOP/U_MIC_SUBSYS/XCORR_MODULE[6]/U_XCORR_TOP/rstn}
add wave -group "subsys/xcorr_6" {sim:/tb/U_TOP/U_MIC_SUBSYS/XCORR_MODULE[6]/U_XCORR_TOP/result}
add wave -group "subsys/xcorr_6" {sim:/tb/U_TOP/U_MIC_SUBSYS/XCORR_MODULE[6]/U_XCORR_TOP/complete}
add wave -group "subsys/xcorr_6" {sim:/tb/U_TOP/U_MIC_SUBSYS/XCORR_MODULE[6]/U_XCORR_TOP/delay}

add wave -group "calc" {sim:/tb/U_TOP/U_CAL_POSITION/*}
add wave -group "calc" {sim:/tb/U_TOP/U_CAL_POSITION/lag_diff}

add wave -group "thd_show" {sim:/tb/U_TOP/U_VIDEO_SUBSYS/video_timing_data_m0/U_THD_SHOW/*}

## part 5: show ui 
view wave
view structure
view signals

## part 6: run 
## run 9060000ns
run 96000000ns
