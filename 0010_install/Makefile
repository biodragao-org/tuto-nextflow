SHELL=/bin/bash
.PHONY: test-install self-update clean all

test-install: ../bin/nextflow
	../bin/nextflow -v

self-update: ../bin/nextflow
	../bin/nextflow self-update


## install nextflow in the current directory
../bin/nextflow:
	mkdir -p ../bin
	cd ../bin && wget  -O - "https://get.nextflow.io" | bash

clean:
	rm -f ../bin/nextflow

