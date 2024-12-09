set_fml_appmode FPV

########################################################
## Setup Specific to DUT
########################################################
set design execute_stage

########################################################
## Compile & Setup
########################################################
# Compilation Step 
read_file -top $design -format sverilog -sva \
  -vcs {-f ../design/filelist +define+INLINE_SVA \
   ../sva/execute_stage.sva ../sva/bind_execute_stage.sva}

# Clock Definitions 
create_clock clk -period 100
# Reset Definitions 
create_reset rst -sense high

# Initialisation Commands 
sim_run -stable
sim_save_reset

########################################################
## Proof
########################################################
check_fv -block 

########################################################
## Reports
########################################################
report_fv -list > results.txt
