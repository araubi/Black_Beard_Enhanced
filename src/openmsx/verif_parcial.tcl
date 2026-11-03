# Comprueba el redibujado parcial: tras FONDO_JUEGO (933F) el búfer debe ser el fondo limpio
# del mapa, y tras VUELCA_JUEGO (935D) la VRAM del área de juego debe ser la ventana del búfer.
# VP_T0/VP_T1: segundos (desde la primera vuelta) en que se vigila. VP_LOG: fichero.
proc rd16 {a} { expr {[debug read memory $a] + 256*[debug read memory [expr {$a+1}]]} }
proc bloque {a n} { binary scan [debug read_block memory $a $n] cu* l; return $l }
proc fondo_esperado {} {
  set mapa [rd16 0x8E45]; set ancho [debug read memory 0x8E44]
  set buf [lrepeat 6272 0]
  for {set tr 0} {$tr < 7} {incr tr} {
    for {set tc 0} {$tc < 7} {incr tc} {
      set t [debug read memory [expr {$mapa + $tr*$ancho*2 + $tc*2 + 1}]]
      set src [expr {0x2328 + 144*($t & 127)}]
      set d [bloque $src 128]
      for {set l 0} {$l < 32} {incr l} {
        set sl [expr {($t & 128) ? 31-$l : $l}]
        for {set b 0} {$b < 4} {incr b} {
          lset buf [expr {($tr*32+$l)*28 + $tc*4 + $b}] [lindex $d [expr {$sl*4+$b}]]
        }
      }
    }
  }
  return $buf
}
set ::vp_n 0; set ::vp_mal_c 0; set ::vp_mal_b 0; set ::vp_mal_v 0; set ::vp_tprev 0; set ::vp_par 0; set ::vp_ent 0
proc vp_fondo {} {
  set ::vp_tf [expr {([machine_info time]-$::vp_t933c)*1000}]; set ::vp_fe [debug read memory $::env(VP_ENT)]
  set e [fondo_esperado]; set b [bloque 0x03E8 6272]; set m 0
  for {set i 0} {$i < 6272} {incr i} { if {[lindex $e $i] != [lindex $b $i]} {incr m} }
  set ::vp_fm $m
  if {$m} {incr ::vp_mal_b}
}
proc vp_vuelca {} {
  # copia oculta (doble.asm): el banco recién volcado es B_VISTA (F482h) si MODO (F481h)
  set o [expr {[debug read memory 0xF481] ? [debug read memory 0xF482]*0x4000 : 0}]
  set fino [expr {[info exists ::env(VP_FINO)] ? [debug read memory $::env(VP_FINO)] : 0}]
  # tabla de nombres: la original (1800h) o la de filas.asm (1C00h, NT_FILAS = VP_NTF)
  set ntb [expr {([info exists ::env(VP_NTF)] && [debug read memory $::env(VP_NTF)]) ? 0x1C00 : 0x1800}]
  set k [expr {$ntb == 0x1C00}]
  set p [expr {[rd16 0x8E47] + 28*$fino}]; set m 0
  binary scan [debug read_block VRAM [expr {$o+$ntb}] 768] cu* nt
  set b [bloque $p [expr {224*24}]]
  set pc [rd16 $::env(VP_BUFCOL)]; set tc $::env(VP_TABLA); set mc 0
  set cb [bloque $pc [expr {28*25}]]; set tab [bloque $tc 256]
  for {set t 0} {$t < 3} {incr t} {
    binary scan [debug read_block VRAM [expr {$o+$t*0x800}] 0x800] cu* v
    binary scan [debug read_block VRAM [expr {$o+0x2000+$t*0x800}] 0x800] cu* vc
    for {set i 0} {$i < 8} {incr i} { for {set c 0} {$c < 24} {incr c} {
      set n [lindex $nt [expr {($t*8+$i)*32+$c}]]
      if {$n != ($k ? $i*24+$c : $c*8+$i)} {incr m}
      for {set l 0} {$l < 8} {incr l} {
        if {[lindex $v [expr {$n*8+$l}]] != [lindex $b [expr {($t*8+$i)*224 + $l*28 + $c}]]} {incr m}
        set kc [lindex $tab [lindex $cb [expr {($t*8+$i+($l+$fino)/8)*28+$c}]]]
        if {[lindex $vc [expr {$n*8+$l}]] != $kc} {incr mc}
      }
    }}
  }
  if {$mc} {incr ::vp_mal_c}
  set t [machine_info time]
  set tv [expr {($t-$::vp_t935a)*1000}]
  puts $::vp_f [format "%.3f fondo=%.1f/%d vuelca=%.1f dt=%.1fms fondo_mal=%d vram_mal=%d color_mal=%d parciales=%d enteros=%d fino=%d k=%d" $t $::vp_tf $::vp_fe $tv [expr {($t-$::vp_tprev)*1000}] $::vp_fm $m $mc $::vp_par $::vp_ent $fino $k]
  set ::vp_tprev $t; set ::vp_par 0; set ::vp_ent 0
  incr ::vp_n; if {$m} {incr ::vp_mal_v}
}
proc vp_arma {} {
  set ::vp_f [open $::env(VP_LOG) w]; set ::vp_fm -1
  set ::vp_t933c 0; set ::vp_t935a 0; set ::vp_tf 0; set ::vp_fe 0
  lappend ::vp_bps [debug set_bp 0x933C {} {set ::vp_t933c [machine_info time]}] [debug set_bp 0x935A {} {set ::vp_t935a [machine_info time]}]
  lappend ::vp_bps [debug set_bp 0x933F {} vp_fondo] [debug set_bp 0x935D {} vp_vuelca]
  lappend ::vp_bps [debug set_bp $::env(VP_PARCIAL) {} {incr ::vp_par}] [debug set_bp $::env(VP_ENTERO) {} {incr ::vp_ent}]
}
proc vp_desarma {} {
  foreach b $::vp_bps { debug remove_bp $b }
  puts $::vp_f "vueltas $::vp_n  con_fondo_mal $::vp_mal_b  con_vram_mal $::vp_mal_v  con_color_mal $::vp_mal_c"; close $::vp_f
}
