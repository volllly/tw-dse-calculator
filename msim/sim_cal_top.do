vsim -t ns -novopt -lib work work.tb_cal_top
view *

onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -format Logic  -radix binary         /tb_cal_top/clk_i
add wave -noupdate -format Logic  -radix binary         /tb_cal_top/reset_i
add wave -noupdate -format Logic  -radix binary         /tb_cal_top/pb_i
add wave -noupdate -format Logic  -radix hexadecimal    /tb_cal_top/sw_i
add wave -noupdate -format Logic  -radix binary         /tb_cal_top/ss_o
add wave -noupdate -format Logic  -radix binary         /tb_cal_top/ss_sel_o
add wave -noupdate -format Logic  -radix hexadecimal    /tb_cal_top/led_o
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {0 ps}
WaveRestoreZoom {0 ps} {1 ns}
configure wave -namecolwidth 150
configure wave -valuecolwidth 100
configure wave -signalnamewidth 0
configure wave -justifyvalue left

run 1000 ms