NF=../bin/nextflow

all : workflow.nf
	$(NF) run $(NFRUNFLAGS) $< --acns '../data/list*.acns.txt'
