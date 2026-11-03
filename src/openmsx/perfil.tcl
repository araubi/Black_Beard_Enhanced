# muestreo del PC: una muestra cada ~1 ms de tiempo emulado
set ::perf_f [open $::env(PERF) w]
proc muestra {} {
  puts $::perf_f "[reg pc] [reg sp] [peek16 [reg sp]]"
  after time 0.000997 muestra
}
after time $::env(PERF_T0) muestra
after time $::env(PERF_T1) { close $::perf_f; set ::perf_f [open /dev/null w] }
