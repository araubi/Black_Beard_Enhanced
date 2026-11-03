# Mide la duración de cada vuelta del bucle principal (9317h) con un guion de teclas igual para las dos versiones
set ::lf [open $::env(LOG) w]; fconfigure $::lf -buffering line
set throttle off
set ::emp 0
proc pulsa {} {
  if {$::emp} return
  keymatrixdown 8 1; after time 0.3 {keymatrixup 8 1}
  after time 1.5 {keymatrixdown 0 1; after time 0.3 {keymatrixup 0 1}}
  after time 3 pulsa
}
proc empieza {} {
  if {$::emp} return
  set ::emp 1; set ::t0 [machine_info time]
  puts $::lf "INICIO $::t0"
  # guion: 3 s quieto, 9 s derecha, 9 s izquierda, 4 s arriba, 4 s abajo
  foreach {t k d} [list 3 $::env(KD) 9  12.2 $::env(KI) 9  21.4 $::env(KA) 4  25.6 $::env(KB) 4] {
    lassign $k r m
    after time $t "keymatrixdown $r $m"; after time [expr {$t+$d}] "keymatrixup $r $m"
  }
  debug set_bp 0x9317 {} vuelta
  after time 30 exit
}
proc vuelta {} {
  puts $::lf [format "V %.6f %d %d %d" [expr {[machine_info time]-$::t0}] [peek 0x8E23] [peek 0x8E24] [peek 0x8E31]]
}
debug set_bp 0x935D {} empieza
after time $::env(TPULSA) pulsa
after time 60 "screenshot -raw -prefix $::env(LOG)"
after time 120 exit
