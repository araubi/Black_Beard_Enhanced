set throttle off
set ::tf [open $::env(OUT) w]; set ::tn 0
proc paso {} {
  puts $::tf [format "%04X SP=%04X A8=%02X AF=%04X HL=%04X" [reg pc] [reg sp] [debug read ioports 0xA8] [reg af] [reg hl]]
  incr ::tn; if {$::tn >= 6000} { debug remove_condition $::tc; close $::tf; exit }
}
set ::tb [debug set_bp 0xE40B {} { debug remove_bp $::tb; set ::tc [debug set_condition 1 paso] }]
after time 20 exit
