set throttle off
after time 20 { keymatrixdown 8 1 } ; after time 20.3 { keymatrixup 8 1 }
after time 23 { keymatrixdown 0 1 } ; after time 23.3 { keymatrixup 0 1 }
set ::jb [debug set_bp 0x935D {} {
  debug remove_bp $::jb; vp_arma
  foreach {t r m d} $::env(JKEYS) { after time $t "keymatrixdown $r $m"; after time [expr {$t+$d}] "keymatrixup $r $m" }
  after time 120 { vp_desarma; exit }
}]
after time 200 exit
