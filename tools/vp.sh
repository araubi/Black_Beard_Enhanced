#!/bin/bash
# vp.sh MAQUINA ROM LOG
S=$HOME/w; . $S/bb/env.sh
sym() { grep -E "^$1: " $W/run/bb.sym | sed 's/.*0x0000/0x/'; }
cd $W/run
JKEYS="$(cat ${KEYS:-$W/pruebas/t11.txt})" VP_LOG=$3 VP_PARCIAL=$(sym RANGO_FILA) VP_ENTERO=$(sym VOLCADO_FILAS) VP_NTF=$(sym NT_FILAS) VP_ENT=$(sym ENTERO) VP_BUFCOL=$(sym V_PTR_BUFCOLOR) VP_TABLA=$(sym TABLA_COLOR) VP_FINO=$(sym FINO) timeout 900 xvfb-run -a openmsx -machine $1 -cart $2 -script verif_parcial.tcl -script $W/pruebas/tr_juego.tcl ${CNTS:+-script $W/pruebas/cnt.tcl} >/dev/null 2>&1
tail -1 $3
