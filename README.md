# FPV_EXE_STAGE

## FPV Verification for EXE stage
Follow the PDF tutorial

## DPV Verification for ALU
There's two variants of the verification, residing in run.tcl and run2.tcl in
the ALU_DPV/run folder

run2.tcl is advised to use. The following commands verify the ALU from the
ALU_DPV/run folder

```sh
csh
source setup.tcl
vcf -f run2.tcl -gui
# now enter the gui
make
sim
...
profit!
```
