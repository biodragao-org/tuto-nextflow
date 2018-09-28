include ../data/nextflow.mk

all : workflow.nf
	$(NF) run $(NFRUNFLAGS) $< --acns '../data/list*.acns.txt'
