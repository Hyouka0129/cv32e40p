mkfile_path := $(abspath $(lastword $(MAKEFILE_LIST)))
root-dir := $(dir $(mkfile_path))
work-dir := $(root-dir)work-vcs	
incdir := \


list_incdir := $(foreach dir, ${incdir}, +incdir+$(dir))

vcs:
	cd $(work-dir) && \
	vcs -f $(root-dir)filelist -full64 -sverilog +lint=TFIPC-L +notimingcheck +v2k $(list_incdir) -debug_access -debug_region=cell+lib -lca -l vcs.log -top tb_top +libext+.v +libext+.sv -assert svaext  -fsdb -R  

verdi:
	cd $(work-dir) && \
	verdi -assert svaext $(list_incdir) -2012 -sverilog -f $(root-dir)filelist -top tb_top -ssf wave.fsdb &
