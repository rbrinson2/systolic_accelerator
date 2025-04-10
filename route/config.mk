export PLATFORM         = sky130hd

export DESIGN_NAME      = toplevel

export VERILOG_FILES    = $(sort $(wildcard ./designs/src/orfs_test/orfs.v))
export SDC_FILE         = ./designs/$(PLATFORM)/orfs_test/constraint.sdc

export CORE_UTILIZATION = 40
export PLACE_DENSITY    = 0.60