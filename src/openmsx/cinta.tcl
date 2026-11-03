# Carga como la cinta: LOAD.BIN y TEST.BIN donde dice la cinta, TAPION/TAPIN de la BIOS
# servidos desde los bloques sin cabecera (cas_prep.py). Al llegar a 92ACh vuelca la RAM.
set throttle off
set d $::env(CINTA)
set f [open $d/flujo.bin rb]; set ::flujo [read $f]; close $f
set f [open $d/offs.txt r]; set ::offs [read $f]; close $f
set ::blq 0; set ::p 0
proc volver {} { set sp [reg sp]; reg pc [expr {[peek $sp] | ([peek [expr {$sp+1}]] << 8)}]; reg sp [expr {$sp+2}] }
proc tapion {} { set ::p [lindex $::offs $::blq]; incr ::blq; reg f [expr {[reg f] & 0xFE}]; volver }
proc tapin {} { binary scan [string index $::flujo $::p] cu b; incr ::p; reg a $b; reg f [expr {[reg f] & 0xFE}]; volver }
debug set_bp 0x00E1 {} tapion
debug set_bp 0x00E4 {} tapin
proc arranca {} {
  foreach {r v} {0 2 1 0xE2 2 6 3 0xFF 4 3 5 0x36 6 7 7 0x11} { vdpreg $r $v }
  foreach fn [glob $::env(CINTA)/*_*.bin] {
    scan [file rootname [file tail $fn]] {%[^_]_%x} n a
    set f [open $fn rb]; debug write_block memory $a [read $f]; close $f
    if {$n eq "LOAD"} { set ::load $a }
  }
  debug write memory 0xF000 0x18; debug write memory 0xF001 0xFE
  debug write memory 0xF37C 0x00; debug write memory 0xF37D 0xF0
  if {[file exists $::env(CINTA)/ejec.txt]} { set f [open $::env(CINTA)/ejec.txt]; set ::load [string trim [read $f]]; close $f }
  reg sp 0xF37C; reg pc $::load; reg iff 0
  puts stderr [format "LOAD en %04X" $::load]
}
after time 3 arranca
set ::hecho 0
debug set_bp 0x92AC {} {
  if {!$::hecho} { set ::hecho 1
    set f [open $::env(OUT)/cpu.bin wb]; puts -nonewline $f [debug read_block memory 0 65536]; close $f
    puts stderr "llega a 92AC t=[machine_info time] bloques=$::blq" }
}
after time 40 { keymatrixdown 8 1 } ; after time 40.3 { keymatrixup 8 1 }
after time 43 { keymatrixdown 0 1 } ; after time 43.3 { keymatrixup 0 1 }
after time 55 "screenshot -raw -prefix $::env(OUT)/juego"
after time 56 exit
