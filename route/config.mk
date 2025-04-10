export PLATFORM         = sky130hd
export DESIGN_KNICKNAME = test 
export DESIGN_NAME      = Test

# export VERILOG_FILES    = $(DESIGHN_HOME)/src/$(DESIGN_KNICKNAME)/Test.v \
						$(DESIGHN_HOME)/src/$(DESIGN_KNICKNAME)/test_mac.v \
						$(DESIGHN_HOME)/src/$(DESIGN_KNICKNAME)/test_control.v \

export VERILOG_FILES    =  $(DESIGHN_HOME)/src/$(DESIGN_KNICKNAME)/results.v 

export SDC_FILE         = $(DESIGHN_HOME)/$(PLATFORM)/$(DESIGN_KNICKNAME)/constraint.sdc

export CORE_UTILIZATION = 40
export PLACE_DENSITY    = 0.60

export TNS_END_PERCENT  = 100