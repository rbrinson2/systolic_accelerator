
top_exe = Test
sources = testing/$(top_exe).sv testing/test_mac.v
testbenches = testing/$(top_exe)_tb.cpp

flags = -cc --exe -x-assign fast --trace --build -j 0

default: testbench synth route
	

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

.PHONEY: clean
clean:
	rm -r obj_dir/ logs/

