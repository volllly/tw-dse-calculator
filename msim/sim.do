vsim -t ns -novopt -lib work work.tb_io_ctrl 
view *
do testbench_wave.do
run 1000000 ns
