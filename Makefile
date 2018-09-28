SHELL=/bin/bash

EXAMPLEDIRS=$(dir $(shell find . -type f -name "*.nf" | sort))

all:
	for D in 0010_install $(EXAMPLEDIRS); do (cd $$D && $(MAKE) --no-print-directory ); done

readme:
	for D in $(EXAMPLEDIRS); do (cd $$D && bash -x ../bin/synopsis.sh > README.md ); done

clean:
	-find $(EXAMPLEDIRS) -type d -name "work" -exec rm -rfv '{}' ';'

