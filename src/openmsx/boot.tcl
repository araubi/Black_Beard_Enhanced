# Arranca Black Beard (cinta) en C-BIOS inyectando los bloques en la RAM
set ::bbdir $::env(BBMEM)
proc cargar {a} {
  set f [open [file join $::bbdir [format %04X.bin $a]] rb]; set d [read $f]; close $f
  debug write_block "Main RAM" $a $d
}
proc bb_fase2 {} {
  debug remove_bp $::bpstub; set ::fase2hecha 1
  foreach a {0x2328 0x55F0 0x8400} { cargar $a }
  if {[file exists [file join $::bbdir E294.bin]]} { cargar 0xE294 }
  reg pc 0x92AC
  reg sp 0xF380
  if {[info exists ::bb_listo]} { eval $::bb_listo }
}
proc bb_fase1 {} {
  debug write "ioports" 0xA8 0xFF
  # SCREEN 2 como lo deja el BASIC (COLOR 1,1,1:SCREEN 2)
  foreach {r v} {0 2 1 0xE2 2 6 3 0xFF 4 3 5 0x36 6 7 7 0x11} { vdpreg $r $v }
  for {set i 0} {$i < 768} {incr i} { debug write VRAM [expr {0x1800+$i}] [expr {$i & 255}] }
  cargar 0x9C40
  # bucle JR $ en D800 como retorno
  debug write "Main RAM" 0xD800 0x18
  debug write "Main RAM" 0xD801 0xFE
  debug write "Main RAM" 0xF37E 0x00
  debug write "Main RAM" 0xF37F 0xD8
  reg sp 0xF37E
  reg pc 0x9C40
  reg iff 0
}
set ::bpstub [debug set_bp 0xD800 {} {bb_fase2}]
after time 3 { bb_fase1 }
