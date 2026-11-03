; BLACK BEARD - TEST.BIN de la cinta (Topo Soft 1988). Desensamblado para estudio.
        device zxspectrum48
        org 0C350h
        include "cuerpo_test.asm"
FIN:
        savebin "TEST.BIN",0C350h,FIN-0C350h
