; BLACK BEARD - pantalla de carga (bloque 9C40h, se ejecuta antes de cargar el resto)
; La imagen va firmada «-ACE-» (seguramente Roberto Potenciano Acebes). Para estudio.
        device zxspectrum48
        org 09C40h
        include "cuerpo_pantalla.asm"
FIN:
        savebin "bloque_9C40.bin",09C40h,FIN-09C40h
