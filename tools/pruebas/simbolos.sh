#!/bin/bash
# simbolos.sh: tras «python3 build.py color» en src/, deja aquí bb.sym (símbolos de la versión en color)
# Symbols of the colour build / カラー版のシンボル
A=$(cd "$(dirname "$0")" && pwd); cd "$A/../../src"
${SJASMPLUS:-sjasmplus} --nologo --msg=war -DACELERA -DCOLOREA -DAFINA_CPC -DFIGURAS_SPR -DSOLO_CAMBIOS -DPORFILAS -DMRUBEN \
  -DLIMITE=${LIMITE:-5} -DSALTO_V=${SALTO:-6} --sym="$A/bb.sym" blackbeard.asm
