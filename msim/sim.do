vsim -t ns -novopt -lib work work.testbench 
view *
do testbench_wave.do
run 220 ns
