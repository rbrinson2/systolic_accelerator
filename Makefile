
sources = src/MAC.sv
testbenches = testbenches/MAC_tb.cpp
top_exe = MAC

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

synth:

route:

.PHONEY: clean
clean:
	rm -r obj_dir/ logs/

