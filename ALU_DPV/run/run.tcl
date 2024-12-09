#C++ New Front End Flow
set _hector_comp_use_new_flow true
#Enable Vacuity
set_fml_var fml_vacuity_on true
#Enable Witness
set_fml_var fml_witness_on true

proc compile_spec {} {
    create_design -name spec -top DPV_wrapper -cov
    cppan -I. \
	../c/alu.cpp
    compile_design spec
}

proc compile_impl {} {
    global step
    create_design -name impl -top alu -clock clk -reset reset
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


proc global_assumes {} {
    map_by_name -inputs -specphase 1 -implphase 1
    assume command_range = spec.command(1) <= 6
#    assume multiply_size = impl.command(1) == 6
}
proc ual {} {
    global step
    global_assumes
    if {$step == 1} {
	assume spec.command(1) <= 0
    } elseif {$step ==2} {
	assume spec.command(1) <= 1
    } elseif {$step == 3} {
	assume spec.command(1) <= 2
#	multiplier_properties lemma
    } elseif {$step == 4} {
	assume spec.command(1) <= 3
#	multiplier_properties assume
    } elseif {$step == 5} {
#	assume mult = impl.command(1) == 6 -> impl.temp_result(1) == impl.in_a(1)[15:0] * impl.in_b(1)[15:0]
    }
    if {$step != 3} {
#	lemma result_equal_small = impl.valid(1) && impl.size(1) == 0 -> impl.result(3)[15:0] == spec.result(1)[15:0] || impl.command(1) == 6
#	lemma result_equal_big = impl.valid(1) && (impl.size(1) == 1 || impl.command(1) == 6) -> impl.result(3) == spec.result(1)
#	lemma signal_equal = impl.valid(1) -> impl.signal(3)[1:0] == spec.signal(1)[1:0]
    }
}

proc multiplier_properties {type} {
    #Add properties for multiplier. Use $type to to allow props to be used as assume or lemma
    #used as assume or lemma.
    #For example, "$type name = impl.signal_a(1) == impl.signal_b(1)"
    global step
    set rel "=="
    $type mult_lo_$type = impl.mult_result_lo(1) $rel impl.in_a(1)[15:0] * impl.in_b(1)[7:0]
    $type mult_hi_$type = impl.mult_result_hi(1) == impl.in_a(1)[15:0] * impl.in_b(1)[15:8]
}


proc case_split {} {
    caseSplitStrategy foo
    caseEnumerate cmd -expr impl.command(1)
}


proc run_solve {} {
    global step
    #Configure host file
    #set_host_file "host.qsub"
    #Enable all multiple solve scripts
    set_hector_multiple_solve_scripts true
    set_hector_multiple_solve_scripts_list ""
    set_user_assumes_lemmas_procedure "ual"
    set proof_name alu
    if {$step == 1} {
	#Step 1 - To prove lemma without any convergence technique
	set_hector_case_splitting_procedure ""
    }
    if {$step == 2} {
	#Step 2 - Set case split TCL procedure
	set_hector_case_splitting_procedure "case_split"
    }
    if {$step == 3} {
	#Step 3 - For command 6, To prove multiplier output
	set_hector_case_splitting_procedure ""
	set_hector_multiple_solve_scripts_list [list orch_custom_bit_operations1]
	set proof_name ALU
    }
    if {$step == 4} {
	#Step 4 - Set case split TCL procedure
	set_hector_case_splitting_procedure "case_split"
    }
    if {$step == 5} {
	#Step 5 – apply HDPS multiplier result as assumption
	set_hector_case_splitting_procedure ""
    }
    gen_proof $proof_name
    check_fv
    # proofwait
}

proc run {step_in} {
    global step
    set step $step_in
    run_solve
}

proc hdps_ual {} {
    #HDPS - Add lemma for all multiplication result, to prove it with
    HDPS
    global step
    assume impl.command(1) == 6
    lemma mult = impl.temp_result(1) == impl.in_a(1)[15:0] * impl.in_b(1)[15:0]
}
proc run_HDPS {} {
    global step set_hector_case_splitting_procedure "" set_user_assumes_lemmas_procedure "hdps_ual" run_all_hdps_options -encoding auto alu_hdps -modes 0 -rrtypes false -abstypes no_abstraction
}
