SHELL=/bin/bash

EXAMPLEDIRS=$(dir $(shell find . -type f -name "*.nf" | sort))

all:
	for D in 0010_install $(EXAMPLEDIRS); do (cd $$D && $(MAKE)); done

clean:
	-find $(EXAMPLEDIRS) -type d -name "work" -exec rm -rfv '{}' ';'

