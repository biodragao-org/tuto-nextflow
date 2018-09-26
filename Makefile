SHELL=/bin/bash
.PHONY: test-install self-update clean

test-install: ./nextflow
	./nextflow -v

self-update: ./nextflow
	./nextflow self-update


## install nextflow in the current directory
./nextflow:
	wget -q -O - "https://get.nextflow.io" | bash

clean:

