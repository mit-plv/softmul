default_target: all

.PHONY: clone_all update_all bedrock2_compiler_noex softmul all clean_bedrock2 clean_softmul run clean clean_deps clean_all

clone_all:
	git submodule update --init --recursive

update_all:
	git submodule update --recursive

REL_PATH_OF_THIS_MAKEFILE:=$(lastword $(MAKEFILE_LIST))
ABS_ROOT_DIR:=$(abspath $(dir $(REL_PATH_OF_THIS_MAKEFILE)))
# use cygpath -m because Coq on Windows cannot handle cygwin paths
ABS_ROOT_DIR:=$(shell cygpath -m '$(ABS_ROOT_DIR)' 2>/dev/null || echo '$(ABS_ROOT_DIR)')

BEDROCK2_DIR ?= $(ABS_ROOT_DIR)/bedrock2/

bedrock2_compiler_noex:
	$(MAKE) -C $(BEDROCK2_DIR) compiler_noex

clean_bedrock2:
	$(MAKE) -C $(BEDROCK2_DIR) clean

softmul: bedrock2_compiler_noex
	$(MAKE) -C $(ABS_ROOT_DIR)/src

clean_softmul:
	$(MAKE) -C $(ABS_ROOT_DIR)/src clean

run: softmul
	$(MAKE) -C $(ABS_ROOT_DIR)/run

all: bedrock2_compiler_noex softmul run

clean: clean_softmul

clean_deps: clean_bedrock2

clean_all: clean_deps clean
