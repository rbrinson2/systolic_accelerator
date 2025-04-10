
top_exe = Test
source_dir = testing
sources = $(source_dir)/Test.v $(source_dir)/test_mac.v $(source_dir)/test_control.v
synth_dir = synth
synth = results
route_dir = route
testbenches = testing/$(top_exe)_tb.cpp

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
	yosys -p "read_verilog -sv $(sources); write_verilog synth/results.v; show Test"

routing:	
	@echo "#------------------------------------#"
	@echo "#             ROUTING                #"
	@echo "#------------------------------------#"
	docker run --rm -it \
			-v ./$(synth_dir):/OpenROAD-flow-scripts/flow/designs/src/test \
			-v ./$(route_dir):/OpenROAD-flow-scripts/flow/designs/sky130hd/test \
			-e DISPLAY=${DISPLAY} \
			openroad/orfs

.PHONEY: clean
clean:
	rm -r obj_dir/ logs/

