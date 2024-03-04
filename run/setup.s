.section .text
.globl _estack
.globl _escratch
.globl mystart
.globl mymain
.globl _shandlerinsts

mystart:
        la sp, _estack
        la a0, _shandlerinsts
        # low to bits of _shandlerinsts must be 0 so that mtvec_mode is direct
        # (as opposed to vectored)
        # uncomment the next line to deliberately break it
        # (but note that if we use IM, the trap handler is never called, so it still works)
        # addi a0, a0, 42
        csrw mtvec, a0
        la a0, _escratch
        csrw mscratch, a0
        j mymain

.section .handlerinsts

_shandlerinsts:
        .incbin "handler.bin"
