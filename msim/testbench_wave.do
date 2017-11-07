onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -format Logic  -radix unsigned /tb_io_ctrl/*
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {0 ps}
WaveRestoreZoom {0 ps} {1 ns}
configure wave -namecolwidth 150
configure wave -valuecolwidth 100
configure wave -signalnamewidth 0
configure wave -justifyvalue left
