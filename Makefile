
top_exe = Test
sources = testing/$(top_exe).v testing/test_mac.v testing/test_control.v
testbenches = testing/$(top_exe)_tb.cpp

flags = -cc --exe -x-assign fast --trace --build -j 0

default: testbench synthesis route
	

testbench:
	@echo "#------------------------------------#"
	@echo "#             TESTBENCH              #"
	@echo "#------------------------------------#"


	# --------------------------------------------- Verilate
	verilator $(flags) $(sources) $(testbenches)	
	mkdir -p logs
	obj_dir/V$(top_exe) +trace

	# --------------------------------------------- GTKWave
	gtkwave logs/top_dump.vcd

synthesis: 
	yosys -p "read_verilog -sv $(sources); prep -top $(top_exe) -flatten -ifx; write_verilog synth/results.v; show Test"

route:

.PHONEY: clean
clean:
	rm -r obj_dir/ logs/

