set_fml_appmode FPV
set design execute_stage
analyze -format sverilog \
-vcs {-f ../design/filelist +define+INLINE_SVA \
../sva/execute_stage.sva ../sva/bind_execute_stage.sva}
elaborate $design -sva

create_clock clk -period 100
create_reset reset_n -sense high

sim_run -stable
sim_save_reset
