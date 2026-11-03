# Cada 0,1 s apunta posición del jugador y contadores de scroll
proc vj {} { puts stderr "J [format %.1f [machine_info time]] [peek 0x8E23] [peek 0x8E24] [peek 0x8E2F] [peek 0x8E30]"; after time 0.1 vj }
after time 17 vj
