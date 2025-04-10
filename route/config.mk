export PLATFORM         = sky130hd

export DESIGN_NAME      = test

export VERILOG_FILES    = $(sort $(wildcard ./designs/src/$(DESIGN_NAME)/*.v))
export SDC_FILE         = ./designs/$(PLATFORM)/$(DESIGN_NAME)/constraint.sdc

export CORE_UTILIZATION = 40
export PLACE_DENSITY    = 0.60