set throttle off
after time 15 { type "run\"cas:\"\r" }
set ::b1 [debug set_bp 0xE400 {} {
  debug remove_bp $::b1
  puts stderr "SP=[format %04X [reg sp]] HIMEM=[format %04X [expr {[peek 0xFC4A]+256*[peek 0xFC4B]}]]"
  foreach a {0xE403 0xE419 0xE426 0xE433 0xE440 0xE443 0xE554} { debug set_bp $a {} "puts stderr \"bp $a t=\[machine_info time\]\"" }
  debug set_bp 0xE554 {} { puts stderr "FIJA" }
  set ::b2 [debug set_bp 0x92AC {} { debug remove_bp $::b2; binary scan [debug read_block memory 0xE440 8] H* h; puts stderr "92AC t=[machine_info time] E440: $h F498=[peek 0xF498] vmsx=[peek 0xF480]"; set ::ens 0; debug set_bp 0xF5F4 {} {incr ::ens}; after time 4 {keymatrixdown 8 1}; after time 4.3 {keymatrixup 8 1}; after time 7 {keymatrixdown 0 1}; after time 7.3 {keymatrixup 0 1}; after time 15 {puts stderr "modo=[peek 0xF481] cambios=$::ens"; exit} }]
}]
after time 1500 { puts stderr "no llega pc=[format %04X [reg pc]]"; exit }
