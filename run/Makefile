default_goal: all

ROOT:=$(CURDIR)/..
COQPATH_SEP:=:
COQPATH=$(ROOT)/src$(COQPATH_SEP)$(ROOT)/bedrock2/bedrock2/src$(COQPATH_SEP)$(ROOT)/bedrock2/compiler/src$(COQPATH_SEP)$(ROOT)/bedrock2/deps/riscv-coq/src$(COQPATH_SEP)$(ROOT)/bedrock2/deps/coqutil/src
export COQPATH
COQC?=coqc

# Note: the binaries with 64 in their name also support 32-bit
RISCV_NAME_PREFIX?=riscv64-unknown-elf-
RISCV_OBJCOPY?=$(RISCV_NAME_PREFIX)objcopy
RISCV_AS?=$(RISCV_NAME_PREFIX)as
RISCV_LD?=$(RISCV_NAME_PREFIX)ld

.PRECIOUS: %.vo %.o %.hex %.bin

print_handler.v: ../src/softmul/SoftmulTop.v

%.hex : print_%.v
	@echo "COQPATH is " $(COQPATH)
	$(COQC) $(COQC_OPTIONS) $< > $@

%.bin : %.hex
	xxd -r -p < $< > $@

%.o : %.bin
	$(RISCV_OBJCOPY) -I binary -O elf32-littleriscv -B riscv $< $@

all: handler.o
