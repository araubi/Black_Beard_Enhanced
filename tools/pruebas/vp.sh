#!/bin/bash
# vp.sh MAQUINA ROM LOG: juega con las teclas de t11.txt y comprueba tras cada vuelta que la VRAM
# es exactamente el búfer del juego (src/openmsx/verif_parcial.tcl). Antes: simbolos.sh.
# Plays with the keys in t11.txt and checks VRAM against the game buffer after every loop.
# t11.txt のキーで遊び、毎ループ VRAM とバッファを比較します。
A=$(cd "$(dirname "$0")" && pwd)
sym() { grep -E "^$1: " $A/bb.sym | sed 's/.*0x0000/0x/'; }
cd $A/../../src/openmsx
JKEYS="$(cat ${KEYS:-$A/t11.txt})" VP_LOG=$3 VP_PARCIAL=$(sym RANGO_FILA) VP_ENTERO=$(sym VOLCADO_FILAS) VP_NTF=$(sym NT_FILAS) VP_ENT=$(sym ENTERO) VP_BUFCOL=$(sym V_PTR_BUFCOLOR) VP_TABLA=$(sym TABLA_COLOR) VP_FINO=$(sym FINO) \
  timeout 900 xvfb-run -a openmsx -machine $1 -cart $2 -script verif_parcial.tcl -script $A/tr_juego.tcl ${CNTS:+-script $A/cnt.tcl} >/dev/null 2>&1
tail -1 $3
