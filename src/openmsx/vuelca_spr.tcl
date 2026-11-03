# Con JDUMP="t1 t2 ...": en cada tiempo, al acabar el siguiente VUELCA_SPRITES (.fin), guarda VRAM, RAM y registros
set ::nd 0
proc vs_arma {} { set ::vs_bp [debug set_bp $::env(VS_FIN) {} vs_vuelca] }
proc vs_vuelca {} {
  debug remove_bp $::vs_bp
  incr ::nd
  set f [open $::env(OUT)/v$::nd.bin wb]; puts -nonewline $f [debug read_block VRAM 0 0x4000]; close $f
  set f [open $::env(OUT)/r$::nd.bin wb]; puts -nonewline $f [debug read_block memory 0 0x10000]; close $f
  set r {}; for {set i 0} {$i < 8} {incr i} { lappend r [vdpreg $i] }
  set f [open $::env(OUT)/g$::nd.txt w]; puts $f $r; close $f
}
