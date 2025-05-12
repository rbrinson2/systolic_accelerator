
top_exe = Top
source_dir = src
sources = $(source_dir)/Top.v $(source_dir)/MACV3.v $(source_dir)/Control.v
synth_dir = synth
synth = results
route_dir = route
testbenches = testbenches/$(top_exe)_tb.cpp
orfs_root = ~/Downloads

flags = -cc --exe -x-assign fast --trace --build -j 0 

default: testbench synthesis routing
	

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
	@echo "#------------------------------------#"
	@echo "#             SYNTHESIS              #"
	@echo "#------------------------------------#"
	yosys -p "read_verilog $(sources); write_verilog synth/results.v; show Test"

routing:	
	@echo "#------------------------------------#"
	@echo "#             ROUTING                #"
	@echo "#------------------------------------#"


.PHONEY: clean
clean:
	rm -r obj_dir/ logs/

