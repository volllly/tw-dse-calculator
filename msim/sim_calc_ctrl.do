vsim -t ns -novopt -lib work work.tb_calc_ctrl
view *

onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -format Logic  -radix binary         /tb_calc_ctrl/clk_i
add wave -noupdate -format Logic  -radix binary         /tb_calc_ctrl/reset_i
add wave -noupdate -format Logic  -radix binary         /tb_calc_ctrl/start_o
add wave -noupdate -format Logic  -radix binary         /tb_calc_ctrl/finished_i
add wave -noupdate -format Logic  -radix binary         /tb_calc_ctrl/sign_i
add wave -noupdate -format Logic  -radix binary         /tb_calc_ctrl/overflow_i
add wave -noupdate -format Logic  -radix binary         /tb_calc_ctrl/error_i
add wave -noupdate -format Logic  -radix binary         /tb_calc_ctrl/pbsync_i
add wave -noupdate -format Logic  -radix hexadecimal    /tb_calc_ctrl/swsync_i
add wave -noupdate -format Logic  -radix binary         /tb_calc_ctrl/dig3_o
add wave -noupdate -format Logic  -radix binary         /tb_calc_ctrl/dig2_o
add wave -noupdate -format Logic  -radix binary         /tb_calc_ctrl/dig1_o
add wave -noupdate -format Logic  -radix binary         /tb_calc_ctrl/dig0_o
add wave -noupdate -format Logic  -radix hexadecimal    /tb_calc_ctrl/i_calc_ctrl/s_op1
add wave -noupdate -format Logic  -radix hexadecimal    /tb_calc_ctrl/i_calc_ctrl/s_op2
add wave -noupdate -format Logic  -radix hexadecimal    /tb_calc_ctrl/i_calc_ctrl/s_otype
add wave -noupdate -format Logic  -radix hexadecimal    /tb_calc_ctrl/op1_o
add wave -noupdate -format Logic  -radix hexadecimal    /tb_calc_ctrl/op2_o
add wave -noupdate -format Logic  -radix hexadecimal    /tb_calc_ctrl/otype_o
add wave -noupdate -format Logic  -radix symbolic       /tb_calc_ctrl/i_calc_ctrl/s_state
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {0 ps}
WaveRestoreZoom {0 ps} {1 ns}
configure wave -namecolwidth 150
configure wave -valuecolwidth 100
configure wave -signalnamewidth 0
configure wave -justifyvalue left

run 1000000 ns