NF=../bin/nextflow

all : workflow.nf
	$(NF) run $< --acns '../data/list1.acns.txt' --web wget
	$(NF) run $< --acns '../data/list1.acns.txt' --web curl
