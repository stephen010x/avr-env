tui new-layout custom {-horizontal regs 1 src 1} 2 status 0 cmd 1
tui new-layout custom2 {-horizontal regs 1 asm 1} 2 status 0 cmd 1
target remote localhost:1212
layout custom2
focus cmd
set $sram=0x00800000
