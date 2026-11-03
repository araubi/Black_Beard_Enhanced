# Compara la tabla de color de VRAM con el búfer 1C68 convertido con TABLA_COLOR (8000h)
proc verifica_color {} {
  set p [expr {[peek 0x8E49] + 256*[peek 0x8E4A]}]
  set mal 0
  for {set t 0} {$t < 3} {incr t} {
    for {set n 0} {$n < 192} {incr n} {
      set col [expr {$n / 8}]; set fil [expr {$t*8 + $n % 8}]
      set at [peek [expr {$p + $fil*28 + $col}]]
      set esp [peek [expr {0x8000 + $at}]]
      set v [debug read VRAM [expr {0x2000 + $t*0x800 + $n*8}]]
      if {$v != $esp} { incr mal }
    }
  }
  puts stderr "t=[machine_info time] ptr=[format %04X $p] desajustes=$mal"
}
proc una {} { debug remove_bp $::bpv; verifica_color }
proc arma {} { set ::bpv [debug set_bp 0x935D {} una] }
if {[info exists ::env(VERT)]} { foreach t $::env(VERT) { after time $t arma } }
