
sources = src/MAC.sv
testbenches = testbenches/MAC_tb.cpp
top_exe = VMAC

flags = -cc --exe -x-assign fast --trace

default: testbench synth route
	

testbench:
	@echo "#------------------------------------#"
	@echo "#             TESTBENCH              #"
	@echo "#------------------------------------#"


	# --------------------------------------------- Verilate
	verilator $(flags) $(sources) $(testbenches)	

	# --------------------------------------------- Build
	$(MAKE) -j -C obj_dir -f VMAC.mk
	mkdir -p logs
	obj_dir/$(top_exe) +trace

synth:

route:

.PHONEY: clean
clean:
	rm -r obj_dir/ logs/

