# FPV_EXE_STAGE

## FPV Verification for EXE stage
Follow the PDF tutorial

## DPV Verification for ALU
The following commands verify the ALU from the
ALU_DPV/run folder

```sh
csh
source setup.tcl
vcf -f run.tcl -gui
# now enter the gui
make
sim
...
profit!
```
