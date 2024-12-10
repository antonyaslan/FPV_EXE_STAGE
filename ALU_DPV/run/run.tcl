# run this program by in a csh shell running
# source setup.tcl
# vcf -f run2.tcl -gui
# now enter the gui
# make
# sim
# ...
# profit!

#Switch to DPV mode
set_fml_appmode DPV
#Configure host file
#set_host_file "host.qsub"

proc compile_spec {} {
    create_design -name spec -top DPV_wrapper
    cppan -I. ../c/alu.cpp
    compile_design spec
}

proc compile_impl {} {
    create_design -name impl -top alu -clock clk -reset reset
    ## RTL lab case with common.sv
    vcs -sverilog ../rtl/common.sv ../rtl/alu.sv
    compile_design impl
}


proc make {} {
    if {[compile_spec] == 0} {
	puts "Failure in compiling the specification model."
    }
    if {[compile_impl] == 0} {
	puts "Failure in compiling the implementation model."
    }
    if {[compose] == 0} {
	puts "Failure in composing the design."
    }
}

proc sim {} {
    solveNB P1
}

proc global_assumes {} {
    map_by_name -inputs -specphase 1 -implphase 1
    assume command_range = spec.command(1) < 3 
    # increase the 3 above to test more functions!
}

proc ual {} {
    global_assumes

    lemma result_equal_small = impl.valid(1) -> impl.result(3)[15:0] == spec.result(1)[15:0]

    lemma result_equal_big = impl.valid(1) -> impl.result(3) == spec.result(1)
    
    lemma alu_and = impl.command(1) == 0 -> impl.result(3) == spec.result(1)

    lemma alu_or = impl.command(1) == 1 -> impl.result(3) == spec.result(1)

    lemma alu_add = impl.command(1) == 2 -> impl.result(3) == spec.result(1)

    lemma alu_sub = impl.command(1) == 3 -> impl.result(3) == spec.result(1)


#    lemma signal_equal = impl.valid(1) -> impl.signal(3)[1:0] == spec.signal(1)[1:0]
}
set_user_assumes_lemmas_procedure "ual"
