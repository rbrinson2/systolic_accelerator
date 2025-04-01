top_exe = MACV2
verilog = v
systemverilog = sv
sources = src/$(top_exe).$(systemverilog)
testbenches = testbenches/$(top_exe)_tb.cpp

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
	gtkwave logs/macv2_dump.vcd

synth:
	@echo "#------------------------------------#"
	@echo "#             SYNTHESIS              #"
	@echo "#------------------------------------#"

	yosys -p "read_verilog -sv src/$(top_exe).$(systemverilog); proc; fsm; show"
route:

.PHONEY: clean
clean:
	rm -r obj_dir/ logs/

