SECTIONS { .dosstub 0 : { *(.dosstub) } .text 0x10001000 : { *(.text) } .rdata 0x10002000 : { *(.rdata) } .data 0x10003000 : { *(.data) } /DISCARD/ : { *(.comment) *(.note*) *(.eh_frame*) } }
