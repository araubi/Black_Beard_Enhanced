# tiempo emulado entre las llamadas del bucle principal (9317-935D)
set ::tr_dirs {0x931B 0x931E 0x9321 0x9324 0x9327 0x932A 0x932D 0x9330 0x9333 0x9336 0x9339 0x933C 0x933F 0x9342 0x9345 0x9348 0x934B 0x934E 0x9351 0x9354 0x9357 0x935A 0x935D}
array set ::tr_acu {}
set ::tr_prev ""
set ::tr_vueltas 0
proc tr_bp {a} {
  set t [machine_info time]
  if {$::tr_prev ne ""} {
    set k $::tr_prev
    if {![info exists ::tr_acu($k)]} {set ::tr_acu($k) 0}
    set ::tr_acu($k) [expr {$::tr_acu($k) + $t - $::tr_t}]
  }
  if {$a == 0x931B} {incr ::tr_vueltas}
  set ::tr_prev $a; set ::tr_t $t
}
after time $::env(PERF_T0) { foreach a $::tr_dirs { debug set_bp $a {} "tr_bp $a" } }
after time $::env(PERF_T1) {
  set f [open $::env(PERF) w]
  puts $f "vueltas $::tr_vueltas"
  foreach a $::tr_dirs { if {[info exists ::tr_acu($a)]} { puts $f [format "%04X %.6f" $a $::tr_acu($a)] } }
  close $f
  foreach b [debug list_bp] { debug remove_bp [lindex $b 0] }
}
