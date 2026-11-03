; =============================================================================
;  BLACK BEARD en ROM de 64 KB (mapper ASCII16, el que supone BlueMSX para
;  cualquier ROM de 64 KB; openMSX lo deduce de las escrituras en 77FFh).
;
;  Hace lo mismo que la cinta: logotipo de Topo, pantalla de carga y juego,
;  con los bloques comprimidos en ZX0 (Einar Saukas, licencia BSD de 3
;  cláusulas: LICENSE_ZX0.txt; descompresor dzx0_standard de Einar Saukas y
;  Urusergi). Para buscar la RAM usa el propio TEST.BIN de la cinta y cambia
;  las páginas igual que LOAD.BIN, así que pide lo mismo que la cinta: 64 KB.
;
;  Mitad 1 (4000h, se lee con la ROM en la página 1): arranque, cargador,
;  TEST.BIN, pantalla de carga (9C40h), 8000h-83FFh y el bloque 8400h.
;  Banco 1 (8000h, se lee con la ROM en la página 2): logotipo de Topo (pasa
;  por un búfer en C000h) y lo que va a la página 3 y a la copia oculta.
;  Banco 2 (8000h): losetas y gráficos 2328h-7FFFh.
; =============================================================================

        device zxspectrum48
        include "../frecuencia.inc"     ; build.py: dónde copiar el byte 002Bh (redibujado parcial)

ENASLT          equ 00024h
RSLREG          equ 00138h
CHGCLR          equ 00062h
CHGCPU          equ 00180h
INIGRP          equ 00072h
FORCLR          equ 0F3E9h
BAKCLR          equ 0F3EAh
BDRCLR          equ 0F3EBh
EXPTBL          equ 0FCC1h
SLTTBL          equ 0FCC5h
RAM_A8          equ 0E292h              ; TEST.BIN deja aquí la RAM de las páginas 0-2:
RAM_FFFF        equ 0E293h              ; puerto A8h y registro de subslot (negado)
TEST_BIN        equ 0C350h
LOGO            equ 09470h
PANTALLA        equ 09C40h
INICIO_JUEGO    equ 092ACh
BUF_LOGO        equ 0C000h
CARGADOR        equ 0E400h
BUF_DOBLE       equ 0E600h

        org 04000h
        db "AB"
        dw ARRANQUE
        dw 0,0,0
        ds 6,0

ARRANQUE:
        di
        xor a                           ; ASCII16: banco 0 en 4000h y banco 1 en 8000h
        ld (06000h),a                   ; (al encender no se sabe qué hay). ASCII16 es lo
        inc a                           ; que supone BlueMSX para cualquier ROM de 64 KB, y
        ld (077FFh),a                   ; openMSX lo deduce de las escrituras en 77FFh
        ld a,(0002Dh)                   ; versión del MSX: 3 = turbo R
        cp 3
        jr c,.z80
        ld a,081h                       ; CHGCPU: R800 en modo ROM (y el piloto)
        call CHGCPU
        di
.z80:
        ld hl,CARGADOR_ROM              ; el cargador y TEST.BIN van a la RAM de la página 3
        ld de,CARGADOR
        ld bc,CARGADOR_LARGO
        ldir
        ld hl,TEST_ROM
        ld de,TEST_BIN
        ld bc,TEST_LARGO
        ldir
        xor a                           ; sin el EI final de TEST.BIN (ver REPON_SLOT0)
        ld (TEST_BIN + 043h),a
        ld a,(SLTTBL)                   ; subslots del slot 0, por si está expandido
        ld (V_SUB0),a
        call RSLREG                     ; slot de la ROM (página 1), en formato ENASLT
        rrca
        rrca
        and 3
        ld e,a
        ld d,0
        ld hl,EXPTBL
        add hl,de
        ld a,(hl)
        and 080h
        jr z,.fija
        ld hl,SLTTBL
        add hl,de
        ld a,(hl)
        and 00Ch
        or 080h
.fija:  or e
        ld (V_ROMSLT),a
        jp CARGA

; TEST.BIN busca la RAM con ENASLT por todos los slots y solo deja como estaban
; el registro A8h y los subslots del slot de la página 3. En un turbo R el
; slot 0 está expandido (BIOS en 0-0): se quedaba con otro subslot en la página
; 0, sin BIOS, y la primera interrupción colgaba el ordenador. Aquí se repone
; el registro de subslots del slot 0 (corre en la página 1, la ROM, porque la
; página 3 pasa un momento al slot 0) y luego se activan las interrupciones.
REPON_SLOT0:
        ld a,(EXPTBL)
        and 080h
        jr z,.fin
        ld a,(V_SUB0)
        ld c,a
        in a,(0A8h)
        ld b,a
        and 03Fh                        ; página 3 al slot 0
        out (0A8h),a
        ld a,c
        ld (0FFFFh),a
        ld a,b
        out (0A8h),a
.fin:   ei
        ret

CARGADOR_ROM:
        phase CARGADOR
CARGA:
        call SCREEN2                    ; COLOR 1,1,1:SCREEN 2, como el BASIC de la cinta
        call TEST_BIN                   ; RAM en las páginas 1 y 2, BIOS en la 0
        call REPON_SLOT0
        ; --- logotipo de Topo (necesita la BIOS y las interrupciones) ---
        ld a,(V_ROMSLT)
        ld h,080h
        call ENASLT
        call BANCOS_23
        ld hl,Z_LOGO
        ld de,BUF_LOGO
        call dzx0_standard
        call RAM_PAG2
        ld hl,BUF_LOGO
        ld de,LOGO
        ld bc,LOGO_LARGO
        ldir
        ei
        call LOGO
        di
        call SCREEN2
        ; --- ROM en la página 1: pantalla de carga y bloques de las páginas 2 y 3 ---
        ld a,(V_ROMSLT)
        ld h,040h
        call ENASLT
        ld hl,Z_PANTALLA
        ld de,PANTALLA
        call dzx0_standard
        call PANTALLA
        call ESPERA
        ld hl,Z_8000
        ld de,08000h
        call dzx0_standard
        ld hl,Z_8400
        ld de,08400h
        call dzx0_standard
        ; --- ROM en la página 2, banco 1: lo que va a la página 3 (RAM siempre) ---
        ld a,(V_ROMSLT)
        ld h,080h
        call ENASLT
        call BANCOS_23
        ld hl,Z_C000
        ld de,0C000h
        call dzx0_standard
        ld hl,Z_D000                    ; el resto de la página 3 (C000h-CORTE va en la otra mitad)
        ld de,CORTE
        call dzx0_standard
        ifdef LARGO_DOBLE               ; copia oculta en MSX2 (doble.asm) y junto.asm: de
        ld hl,Z_DOBLE                   ; momento en E600h (TABLA_PAPEL, aún sin usar); F480h
        ld de,BUF_DOBLE                 ; y FDE8h son de la BIOS hasta el final
        call dzx0_standard
        endif
        ifdef IDIOMA_LARGO
        ld hl,T_IDIOMA                  ; tabla de idioma.asm (en la cinta va con LOAD.BIN)
        ld de,0E294h
        ld bc,IDIOMA_LARGO
        ldir
        endif
        ; --- banco 2: losetas y gráficos en las páginas 0 y 1. Los registros ASCII16
        ; están en 6000h-7FFFh: se cambia de banco antes de quitar la ROM de la página 1
        ld a,2
        ld (077FFh),a
        ld a,(0002Bh)                   ; BIOS: bit 7 = 50 Hz (para el limitador)
        ld (V_FREC),a
        ld a,(0002Dh)                   ; 3 = turbo R
        ld (V_VERSION),a
        call RAM_PAG1
        call RAM_PAG0                   ; desde aquí ya no hay BIOS
        ld hl,Z_2328
        ld de,02328h
        call dzx0_standard
        ifdef QHW_LARGO1                ; MSX2+ y turbo R: scroll por hardware (hw.asm) en
        ld a,(V_VERSION)                ; F000h-F47Fh y F800h-FC7Fh, que eran de la BIOS
        cp 2
        jr c,.sin_hw
        ld sp,0E290h                    ; (la pila estaba en F2xxh), como LOAD.BIN
        ld hl,HW_BIN1
        ld de,0F000h
        ld bc,QHW_LARGO1
        ldir
        ld hl,HW_BIN2
        ld de,0F800h
        ld bc,QHW_LARGO2
        ldir
        ld a,1
        ld (V_HW),a
.sin_hw:
        endif
        call RAM_PAG2                   ; todo RAM, como deja LOAD.BIN
        di
        ifdef DIR_FRECUENCIA
        ld a,(V_FREC)
        ld (DIR_FRECUENCIA),a
        ld a,(V_VERSION)                ; turbo R (R800): la pantalla sigue cada paso
        cp 3
        jr c,.salto
        ld a,1
        ld (DIR_SALTO),a
.salto:
        endif
        ifdef LARGO_DOBLE
        ld hl,BUF_DOBLE
        ld de,DIR_DOBLE
        ld bc,LARGO_DOBLE
        ldir
        ld a,(V_VERSION)                ; 1 o más: MSX2, con copia oculta
        ld (DIR_MSX),a
        endif
        ifdef QHW_LARGO1
        ld a,(V_HW)                     ; INICIA_VDP: MODO_INICIAL_HW en vez de INICIA_FILAS
        or a
        jr z,.sin_hw2
        ld hl,QHW_MODO
        ld (QHW_REINICIA+1),hl
.sin_hw2:
        endif
        ifdef LARGO_JUNTO               ; junto.asm (detrás de doble.asm): encima de la pila
        ld hl,BUF_DOBLE + LARGO_DOBLE   ; del juego, ya sin BIOS
        ld de,DIR_JUNTO
        ld bc,LARGO_JUNTO
        ldir
        endif
        jp INICIO_JUEGO

; ASCII16: banco 1 en 8000h-BFFFh (la página 2 tiene que ser la ROM)
BANCOS_23:
        ld a,1
        ld (077FFh),a
        ret

SCREEN2:
        ld a,1
        ld (FORCLR),a
        ld (BAKCLR),a
        ld (BDRCLR),a
        call CHGCLR
        call INIGRP
        di
        ret

; Unos 3 segundos (150 cuadros) con la pantalla de carga
ESPERA:
        ld b,150
        in a,(099h)
.cuadro:
        in a,(099h)
        and a
        jp p,.cuadro
        djnz .cuadro
        ret

; Pone RAM en una página igual que LOAD.BIN (D7E6h-D81Ch)
RAM_PAG0:
        ld de,003FCh
        jr RAM_PAG
RAM_PAG1:
        ld de,00CF3h
        jr RAM_PAG
RAM_PAG2:
        ld de,030CFh
RAM_PAG:
        di
        ld hl,RAM_FFFF
        ld a,(hl)
        and d
        ld b,a
        ld a,(0FFFFh)
        cpl
        and e
        or b
        ld (0FFFFh),a
        dec hl
        ld a,(hl)
        and d
        ld b,a
        in a,(0A8h)
        and e
        or b
        out (0A8h),a
        ret

        include "dzx0_standard.asm"

V_ROMSLT:
        db 0
V_FREC:
        db 080h
V_SUB0:
        db 0
V_VERSION:
        db 0
V_HW:   db 0                            ; <> 0: hw.asm copiado (V9958)
        dephase
CARGADOR_LARGO = $ - CARGADOR_ROM
        assert CARGADOR + CARGADOR_LARGO <= BUF_DOBLE

TEST_ROM:
        incbin "../TEST.BIN"
TEST_LARGO = $ - TEST_ROM

Z_PANTALLA:
        incbin "pantalla_9C40.zx0"
Z_8000:
        incbin "bloque_8000.zx0"
Z_8400:
        incbin "bloque_8400.zx0"
FIN_MITAD1:
        assert FIN_MITAD1 <= 08000h
        ds 08000h - $, 0FFh

Z_LOGO:
        incbin "logo_9470.zx0"
LOGO_LARGO = LARGO_LOGO_CM
Z_C000:
        incbin "bloque_C000.zx0"
Z_D000:
        incbin "bloque_D000.zx0"
        ifdef LARGO_DOBLE
Z_DOBLE:
        incbin "doble_F480.zx0"
        endif
        ifdef IDIOMA_LARGO
T_IDIOMA:
        incbin "../idioma_E294.bin"
        endif
FIN_MITAD2:
        assert FIN_MITAD2 <= 0C000h
        ds 0C000h - $, 0FFh

        savebin "BlackBeard.rom",04000h,08000h

; Banco 2 de la ROM (ASCII16): se ve en 8000h-BFFFh tras escribir 2 en 77FFh
; (lo hace el cargador antes de quitar la ROM de la página 1)
        org 08000h
Z_2328:
        incbin "bloque_2328.zx0"
        ifdef QHW_LARGO1
HW_BIN1:
        incbin "../hw_F000.bin"
HW_BIN2:
        incbin "../hw_F800.bin"
        endif
FIN_EXTRA:
        assert FIN_EXTRA <= 0C000h
        ds 0C000h - $, 0FFh
        savebin "extra.bin",08000h,04000h
