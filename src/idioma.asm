; =============================================================================
;  Opción de idioma en el menú (pedido de araubi, con -DSOLO_CAMBIOS).
;
;  «3.- DEFINE TECLAS» sube a la fila 8 y en la 10 aparece «4.- ESPAÑOL»; la
;  tecla 4 pasa a «4.- ENGLISH» con todos los textos de la edición Kixx (y el
;  rótulo BULLETS del marcador), y otra vez a español. build.py ensambla las
;  dos ediciones, compara los bloques y deja en idioma_E294.bin lo que cambia,
;  con los bytes de la otra: «dw dirección / db largo / bytes», y dw 0 al final.
;  Cambiar de idioma es intercambiar esos bytes con la memoria.
;  La tabla va en E294h-E3FFh, libre durante la partida: en la cinta llega
;  con el bloque de LOAD.BIN (que ahora va en E400h) y la ROM la copia allí.
; =============================================================================

TABLA_IDIOMA    equ 0E294h              ; hasta E3FFh (build.py lo comprueba)
ENE             equ 07Fh                ; código de la Ñ (la fuente acaba en 5Ah)

        org 09EB8h                      ; «3.- DEFINE TECLAS»: fila 11 -> 8
        ld hl,009C0h
        org 09EC7h                      ; tras «0.- JUGAR», la opción nueva
        jp MENU_IDIOMA
        org 09E8Eh                      ; BIT 3,A / JP NZ,L9F28 / POP HL
        jp MENU_OPCION
        org 09F39h                      ; teclas del menú: 4, 1, 2, 3, 0
        ld ix,TECLAS_MENU
        org 09F40h
        db 5
        org 09F68h                      ; letra: LD DE,LBEAE
        call FUENTE

        org FIN_SCROLL
MENU_IDIOMA:
        call L9F8D
        ld hl,009D0h                    ; fila 10
        ld de,TXT_IDIOMA
        jp L9F8D
TXT_IDIOMA:
        ifdef KIXX
        db 00Bh,0A1h,"4.- ENGLISH"
        else
        db 00Bh,0A1h,"4.- ESPA",ENE,"OL"
        endif

; El primero da el bit 4 de E, y el resto como L9F44
TECLAS_MENU:
        db 0F0h,010h,0F0h,002h,0F0h,004h,0F0h,008h,0F0h,001h

MENU_OPCION:
        bit 3,a
        jp nz,L9F28
        bit 4,a
        jr nz,IDIOMA
        pop hl
        jp L9E94

IDIOMA:
        ld hl,TABLA_IDIOMA
.trozo: ld e,(hl)
        inc hl
        ld d,(hl)
        inc hl
        ld a,d
        or e
        jr z,.marcador
        ld b,(hl)
        inc hl
.byte:  ld a,(de)
        ld c,(hl)
        ld (hl),a
        ld a,c
        ld (de),a
        inc hl
        inc de
        djnz .byte
        jr .trozo
.marcador:
        ld hl,04600h                    ; patrones del marcador otra vez, como en 92CEh
        ld de,05EF0h
        ld bc,LC008
        call L9D71                      ; (acaba con EI)
        di                              ; el menú va sin interrupciones
        jp ESPERA_SUELTA

; DE = fuente + código x 8 (HL), con la Ñ fuera de la fuente
FUENTE:
        ld de,LBEAE
        ld a,h
        cp high (ENE * 8)
        ret nz
        ld a,l
        cp low (ENE * 8)
        ret nz
        ld de,GLIFO_ENE - ENE * 8
        ret
GLIFO_ENE:                              ; la N de la fuente con la tilde encima
        db 01111100b
        db 11000110b
        db 11000110b
        db 11010110b
        db 11011110b
        db 11001110b
        db 11000110b
        db 00000000b

FIN_IDIOMA:
        assert FIN_IDIOMA <= 0E290h     ; E290h-E293h: TEST.BIN (cinta) y el cargador de la ROM
