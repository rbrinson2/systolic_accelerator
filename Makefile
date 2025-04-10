
top_exe = Test
source_dir = testing
sources = $(source_dir)/*.v
route_dir = route
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
	yosys -p "read_verilog -sv $(sources); write_verilog synth/results.v; show Test"

route:
	docker run --rm -it \
			-v $(pwd)/$(source_dir):/OpenROAD-flow-scripts/flow/designs/src/$(top_exp) \
			-v $(pwd)/$(route_dir):/OpenROAD-flow-scripts/flow/designs/sky130hd/$(top_exp) \
			-e DISPLAY=${DISPLAY} \
			openroad/orfs
.PHONEY: clean
clean:
	rm -r obj_dir/ logs/

