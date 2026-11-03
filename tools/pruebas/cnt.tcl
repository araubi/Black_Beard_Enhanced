set ::cf [open $::env(CNT) w]
debug set_bp 0xA614 {} { puts $::cf [format "av dir=%d" [peek 0x0311]]; flush $::cf }
debug set_bp 0xDA07 {} { puts $::cf "entero"; flush $::cf }
