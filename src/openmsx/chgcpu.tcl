# Simula un turbo R: 002Dh = 3 y CHGCPU (0180h) cambia de CPU conservando los registros
debug set_bp 0x4014 {} { reg a 3 }
debug set_bp 0x0180 {} {
  set a [reg a]; set sp [reg sp]; set ret [expr {[peek $sp] | ([peek [expr {$sp+1}]] << 8)}]
  set regs {}
  foreach r {af bc de hl ix iy af2 bc2 de2 hl2 i r iff im} { lappend regs $r [reg $r] }
  debug write ioports 0xE4 6; debug write ioports 0xE5 [expr {($a & 3) == 1 ? 0x40 : ($a & 3) == 2 ? 0x00 : 0x60}]
  foreach {r v} $regs { reg $r $v }
  reg sp [expr {$sp+2}]; reg pc $ret
  puts stderr "t=CHGCPU [format %02X $a] -> S1990 [debug read {S1990 regs} 6]"
}
