ENTRY(mystart)

STACK_SIZE = 0x2000;
SCRATCH_SIZE = 0x1000; /* bigger than needed (256 bytes) to align with page sizes */

SECTIONS
{
  . = 0x10000;
  .text : { *(.text) }
  _shandler_insts = .;
  .text : { *(.handlerinsts) }
  . = 0x8000000;
  .data : { *(.data) }
  .bss : { *(.bss) }
  mymem_start = .;

  . = 0x9000000;
  .stack (NOLOAD): {
    . = ALIGN(8);
    _sscratch = .;
    . = . + SCRATCH_SIZE;
    _escratch = .;
    _sstack = .;
    . = . + STACK_SIZE;
    . = ALIGN(8);
    _estack = .;
  }
}
