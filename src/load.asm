; BLACK BEARD - LOAD.BIN de la cinta (Topo Soft 1988). Desensamblado para estudio.
; Con -DORG_LOAD=... se ensambla en otra dirección (la versión con sprites lo
; sube a D900h para que el bloque 8400h pueda crecer; build.py cambia el DEF USR).
        device zxspectrum48
        ifndef ORG_LOAD
ORG_LOAD = 0D6D8h
        endif
        org ORG_LOAD
        include "cuerpo_load.asm"
FIN_CUERPO:
        include "frecuencia.inc"        ; lo escribe build.py
        ifdef DIR_FRECUENCIA            ; redibujado parcial: el limitador necesita saber si
        org ORG_LOAD                    ; la máquina es de 50 o 60 Hz. CALL 0C350h (TEST.BIN):
        call LEE_FRECUENCIA             ; aquí aún está la BIOS en la página 0
        org ORG_LOAD + 043h             ; DI / JP 92ACh: el bloque 8400h ya está cargado
        jp FIJA_FRECUENCIA
        org FIN_CUERPO
LEE_FRECUENCIA:
        pop hl                          ; la pila del BASIC puede caer donde se carga el
        ld sp,0E290h                    ; bloque 8400h (con disco, HB-F900: DB86h) y el
        push hl                         ; último RET saltaba a cualquier sitio
        ld a,(0002Bh)                   ; BIOS: bit 7 = 50 Hz
        ld (V_FREC_LOAD),a
        ifdef LARGO_DOBLE
        ld a,(0002Dh)                   ; BIOS: 0 = MSX1, 1 o más = MSX2 (copia oculta)
        ld (V_MSX_LOAD),a
        endif
        jp 0C350h
FIJA_FRECUENCIA:
        di
        ld a,080h
V_FREC_LOAD = $ - 1
        ld (DIR_FRECUENCIA),a
        ifdef LARGO_DOBLE               ; doble.asm viaja detrás de LOAD.BIN
        ld hl,FIN
        ld de,DIR_DOBLE
        ld bc,LARGO_DOBLE
        ldir
        ld a,0
V_MSX_LOAD = $ - 1
        ld (DIR_MSX),a
        endif
        ifdef LARGO_JUNTO               ; junto.asm, detrás de doble.asm: encima de la pila
        ld hl,FIN + LARGO_DOBLE         ; del juego, donde la BIOS ya no hace falta
        ld de,DIR_JUNTO
        ld bc,LARGO_JUNTO
        ldir
        endif
        jp 092ACh
        endif
FIN:
        savebin "LOAD.BIN",ORG_LOAD,FIN-ORG_LOAD
