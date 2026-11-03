set throttle off
foreach {tt nn} $::env(SHOTS) { after time $tt "screenshot -raw -prefix $::env(OUT)/$nn" }
if {[info exists ::env(KEYS)]} { foreach {t r m d} $::env(KEYS) { after time $t "keymatrixdown $r $m" ; after time [expr {$t+$d}] "keymatrixup $r $m" } }
after time [expr {[lindex $::env(SHOTS) end-1]+1}] exit
