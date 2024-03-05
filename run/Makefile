default_goal: all

ROOT:=$(CURDIR)/..
COQPATH_SEP:=:
COQPATH=$(ROOT)/src$(COQPATH_SEP)$(ROOT)/bedrock2/bedrock2/src$(COQPATH_SEP)$(ROOT)/bedrock2/compiler/src$(COQPATH_SEP)$(ROOT)/bedrock2/deps/riscv-coq/src$(COQPATH_SEP)$(ROOT)/bedrock2/deps/coqutil/src
export COQPATH
COQC?=coqc

# Note: the binaries with 64 in their name also support 32-bit
RISCV_NAME_PREFIX?=riscv64-unknown-elf-
RISCV_OBJCOPY?=$(RISCV_NAME_PREFIX)objcopy
RISCV_OBJDUMP?=$(RISCV_NAME_PREFIX)objdump
RISCV_GCC?=$(RISCV_NAME_PREFIX)gcc
RISCV_AS?=$(RISCV_NAME_PREFIX)as
RISCV_LD?=$(RISCV_NAME_PREFIX)ld

.PRECIOUS: %.vo %.o %.hex %.bin %.elf %.txt

print_handler.v: ../src/softmul/SoftmulTop.v

handler.hex: print_%.v
	@echo "COQPATH is " $(COQPATH)
	$(COQC) $(COQC_OPTIONS) $< > $@

handler.bin: handler.hex
	xxd -r -p < $< > $@

%.o: %.c
	$(RISCV_GCC) -march=rv32im -mabi=ilp32 -c $< -o $@

setup.o: setup.s
	$(RISCV_GCC) -march=rv32im -mabi=ilp32 -c $< -o $@

%.elf: %.o setup.o spike.lds
	$(RISCV_LD) -m elf32lriscv -nostdlib -T spike.lds $< setup.o -o $@

# for debugging/inspection:
dump_%: %
	$(RISCV_OBJDUMP) -d $<

# start address & size of instruction memory, heap, and scratchpad+stack
MEM_LAYOUT?='-m0x10000:0x10000,0x8000000:0x10000,0x9000000:0x3000'

run_%_IM: %.elf debugger_commands.txt
	spike -d --debug-cmd=debugger_commands.txt --isa=RV32IM $(MEM_LAYOUT) $<

run_%_I: %.elf debugger_commands.txt
	spike -d --debug-cmd=debugger_commands.txt --isa=RV32I $(MEM_LAYOUT) $<

all: run_factorial_IM run_factorial_I
