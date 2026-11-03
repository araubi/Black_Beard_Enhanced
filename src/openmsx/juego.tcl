# Como shot.tcl, pero los tiempos de JSHOTS/JKEYS/JVERT/JPERF cuentan desde la primera vuelta
# del bucle principal (935Dh) tras pulsar JUGAR, que en C-BIOS varía de una vez a otra.
set throttle off
after time 12 { keymatrixdown 8 1 } ; after time 12.3 { keymatrixup 8 1 }
after time 15 { keymatrixdown 0 1 } ; after time 15.3 { keymatrixup 0 1 }
proc j_empieza {} {
  debug remove_bp $::j_bp
  set t0 [machine_info time]
  puts stderr "juego en marcha a t=$t0"
  if {[info exists ::env(JSHOTS)]} { foreach {tt nn} $::env(JSHOTS) { after time $tt "screenshot -raw -prefix $::env(OUT)/$nn" } }
  if {[info exists ::env(JKEYS)]} { foreach {t r m d} $::env(JKEYS) { after time $t "keymatrixdown $r $m" ; after time [expr {$t+$d}] "keymatrixup $r $m" } }
  if {[info exists ::env(JDUMP)]} { foreach t $::env(JDUMP) { after time $t vs_arma } }
  if {[info exists ::env(JVERT)]} { foreach t $::env(JVERT) { after time $t arma } }
  if {[info exists ::env(JPERF)]} { lassign $::env(JPERF) a b; set ::env(PERF_T0) $a; set ::env(PERF_T1) $b; source $::env(BBRUN)/tramos.tcl }
  if {[info exists ::env(JDIAG)]} { after time $::env(JDIAG) diag }
  if {[info exists ::env(JVP)]} { lassign $::env(JVP) a b; after time $a vp_arma; after time $b vp_desarma }
  after time $::env(JFIN) exit
}
after time 16 { set ::j_bp [debug set_bp 0x935D {} j_empieza] }
after time 200 exit
