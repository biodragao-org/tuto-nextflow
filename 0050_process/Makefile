include ../data/nextflow.mk

all: test1 test2 test3

test1: workflow.nf
	$(NF) run $< 
test2: workflow.nf
	$(NF) run $<  --salutation Bonjour --name Monde
test3: workflow.nf
	$(NF) run -config my.config $<  
