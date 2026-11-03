set throttle off
foreach {a n} {0x4010 ARRANQUE 0xE400 CARGA 0xC350 TEST 0xE406 tras_TEST 0xE40E tras_ENASLT 0xE417 tras_dzx0 0x9470 LOGO 0x9C40 PANTALLA 0xE4B0 ESPERA 0xE4BD RAM_PAG0 0xE4C2 RAM_PAG1 0xE4C7 RAM_PAG2 0x92AC JUEGO} {
  set ::bp($n) [debug set_bp $a {} "puts stderr \"$n \[format %.3f \[machine_info time\]\] A8=\[format %02X \[debug read ioports 0xA8\]\] SP=\[format %04X \[reg sp\]\]\"; debug remove_bp \$::bp($n)"]
}
after time 15 exit
debug set_bp 0xE406 {} { puts stderr "V_ROMSLT=[format %02X [peek 0xE529]] EXPTBL=[format %02X [peek 0xFCC1]] [format %02X [peek 0xFCC2]] [format %02X [peek 0xFCC3]] [format %02X [peek 0xFCC4]] E290-3=[format %02X%02X%02X%02X [peek 0xE290] [peek 0xE291] [peek 0xE292] [peek 0xE293]] FFFF=[format %02X [peek 0xFFFF]]" }
