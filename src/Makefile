default_target: all

.PHONY: clean force all

VFILES:=$(shell find ./softmul -type f -name '*.v')

all: Makefile.coq $(VFILES)
	rm -f .Makefile.coq.d
	$(MAKE) -f Makefile.coq

Makefile.coq: force _CoqProject
	@echo "Generating Makefile.coq"
	$(COQBIN)coq_makefile -f _CoqProject -docroot softmul $(COQMF_ARGS) -o Makefile.coq

force:

clean: Makefile.coq
	$(MAKE) -f Makefile.coq clean
	find . -type f \( -name '*~' -o -name '*.aux' -o -name '.lia.cache' -o -name '.nia.cache' \) -delete
	rm -f Makefile.coq Makefile.coq.conf
