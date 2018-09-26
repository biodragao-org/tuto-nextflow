SHELL=/bin/bash
.PHONY: test-install self-update clean all

all:  ./nextflow hello_world.nf
	./hello_world.nf
	./hello_world.nf --salutation Bonjour --name Monde
	./nextflow run -config my.config hello_world.nf

test-install: ./nextflow
	./nextflow -v

self-update: ./nextflow
	./nextflow self-update


## install nextflow in the current directory
./nextflow:
	wget -q -O - "https://get.nextflow.io" | bash

clean:
	rm -f .nextflow.log* .nextflow nextflow

