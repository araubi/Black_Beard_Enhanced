; =============================================================================
;  Área de juego en color (-DCOLOREA, siempre junto con -DACELERA).
;
;  Las losetas del MSX traen los 16 atributos de Spectrum de cada loseta (son
;  idénticos byte a byte a los de la versión de Spectrum) y el juego los
;  calculaba en el búfer de 1C68h, pero el volcado se quedó a medias:
;  VUELCA_COLOR_SIN_USAR iba detrás de un JP y CONVIERTE_COLOR leía dos veces
;  la tinta (tinta = papel: todo negro). Aquí se termina el trabajo:
;
;  1) COLOR_LOSETA(_INV) más rápidos, con la misma regla que el original: el
;     papel 0 toma el nibble bajo del byte de color del mapa y el papel 1 el
;     alto (así cambia el color de cada sala, igual que en Spectrum).
;  2) Volcado de color tras el de patrones. Atributo -> color MSX con una tabla
;     de 256 bytes (tabla_color.asm). 30 ciclos entre escrituras (TMS9918).
;  3) Nada se repite si no cambia: cada una de las 49 casillas recuerda qué
;     loseta y color de sala pintó (CACHE_COLOR) y, si es la misma, se salta
;     el cálculo. El color solo se vuelca al VDP si alguna casilla cambió, si
;     la ventana se desplazó dentro del búfer o si el juego escribió en la
;     tabla de color de VRAM (VDP_ESCRITURA lo marca). Quieto, el color no
;     cuesta casi nada; al cambiar de pantalla, unos 40 ms más.
;
;  Va en 8000-83FF (RAM libre entre los gráficos y el código): el bloque
;  55F0h se alarga hasta 8400h y LOAD.BIN carga 2E10h bytes en vez de 2A00h.
; =============================================================================

CACHE_COLOR     equ 01F78h              ; 49 casillas x 3 bytes, RAM libre tras el búfer de color

        org COLOR_LOSETA
        jp COLOR_LOSETA_RAPIDO
        org COLOR_LOSETA_INV
        jp COLOR_LOSETA_INV_RAPIDO

        org VUELCA_PANTALLA+01Bh        ; 9BC2: el JP final de VUELCA_PANTALLA
        jp VUELCA_COLOR

        org VDP_ESCRITURA
        jp VDP_ESCRITURA_MARCA

        org DIBUJA_FONDO
        jp EMPIEZA_FONDO

        org 08000h
TABLA_COLOR:                            ; alineada a 256
        include "tabla_color.asm"

COLOR_SUCIO:
        db 1                            ; <> 0: la VRAM de color se tocó desde fuera
COLOR_NUEVO:
        db 0                            ; <> 0: alguna casilla cambió de color
CACHE_LISTA:
        db 0                            ; 0: CACHE_COLOR aún sin borrar
PTR_CACHE:
        dw CACHE_COLOR
ULTIMO_PTR:
        dw 0                            ; V_PTR_BUFCOLOR del último volcado

; Principio de DIBUJA_FONDO: vuelve a la primera casilla de la caché
EMPIEZA_FONDO:
        ld hl,CACHE_COLOR
        ld (PTR_CACHE),hl
        ld a,(CACHE_LISTA)
        or a
        jr nz,.lista
        ld (hl),0FFh                    ; nunca coincide con una loseta de verdad
        ld de,CACHE_COLOR+1
        ld bc,49*3-1
        ldir
        ld a,1
        ld (CACHE_LISTA),a
.lista: exx                             ; lo que hacía el original
        ld de,01c68h
        exx
        ld de,003e8h
        jp DIBUJA_FONDO+8

; HL = color de la loseta, C = 0 normal / 80h al revés.
; Z: la casilla tiene lo mismo que la vuelta anterior. NZ: se apunta lo nuevo.
MIRA_CACHE:
        push de
        push hl
        ex de,hl
        ld a,d
        or c
        ld d,a
        ld a,(V_COLOR_LOSETA)
        ld b,a
        ld hl,(PTR_CACHE)
        cp (hl)
        jr nz,.color
        inc hl
        ld a,e
        cp (hl)
        jr nz,.bajo
        inc hl
        ld a,d
        cp (hl)
        jr nz,.alto
        jr .fin
.color: ld (hl),b
        inc hl
.bajo:  ld (hl),e
        inc hl
.alto:  ld (hl),d
        ld a,1
        ld (COLOR_NUEVO),a
.fin:   inc hl                          ; INC y LD no tocan Z
        ld (PTR_CACHE),hl
        pop hl
        pop de
        ret

; Igual que VDP_ESCRITURA, pero si la dirección cae en la tabla de color
; (2000h-37FFh) marca que hay que volver a volcar el color del área de juego
VDP_ESCRITURA_MARCA:
        push af
        ld a,h
        and 03Fh
        sub 020h
        cp 018h
        jr nc,.direccion
        ld a,1
        ld (COLOR_SUCIO),a
.direccion:
        in a,(099h)
        ld a,l
        out (099h),a
        ld a,h
        and 07Fh
        or 040h
        out (099h),a
        pop af
        ret

; B = papel que sustituye al 1 (nibble alto del color de la sala)
; C = papel que sustituye al 0 (nibble bajo)
PREPARA_PAPEL:
        ld a,(V_COLOR_LOSETA)
        ld c,a
        rrca
        and 038h
        ld b,a
        ld a,c
        rlca
        rlca
        rlca
        and 038h
        ld c,a
        ret

; Un byte de color, como COPIA_BYTE_COLOR: papel 0/1 sustituido, resto igual
BYTE_COLOR:
        ld a,(hl)
        inc hl
        bit 5,a
        jr nz,.guarda
        bit 4,a
        jr nz,.guarda
        bit 3,a
        jr z,.papel0
        and 0C7h
        or b
        jr .guarda
.papel0:
        and 0C7h
        or c
.guarda:
        ld (de),a
        inc de
        ret

        macro FILA_COLOR
        call BYTE_COLOR
        call BYTE_COLOR
        call BYTE_COLOR
        call BYTE_COLOR
        endm

COLOR_LOSETA_RAPIDO:
        ld c,0
        call MIRA_CACHE
        jp z,SALTA_LOSETA
        push hl
        exx
        pop hl
        call PREPARA_PAPEL
        ld a,4
.fila:  ex af,af'
        FILA_COLOR
        ld a,e                          ; DE += 24: siguiente fila del búfer
        add a,24
        ld e,a
        adc a,d
        sub e
        ld d,a
        ex af,af'
        dec a
        jp nz,.fila
        ld hl,0FF94h                    ; como el original: DE apunta a la siguiente loseta
        add hl,de
        ex de,hl
        exx
        ld hl,0FC84h
        add hl,de
        ex de,hl
        ret

SALTA_LOSETA:                           ; igual que antes: el color ya está en el búfer
        exx
        inc de
        inc de
        inc de
        inc de
        exx
        ld hl,0FC84h
        add hl,de
        ex de,hl
        ret

COLOR_LOSETA_INV_RAPIDO:                ; la loseta va del revés: de abajo arriba
        ld c,080h
        call MIRA_CACHE
        jp z,SALTA_LOSETA_INV
        push hl
        exx
        ld hl,00054h
        add hl,de
        ex de,hl
        pop hl
        call PREPARA_PAPEL
        ld a,4
.fila:  ex af,af'
        FILA_COLOR
        ld a,e                          ; DE -= 32: fila de arriba
        sub 32
        ld e,a
        jr nc,.sigue
        dec d
.sigue: ex af,af'
        dec a
        jp nz,.fila
        ld hl,00020h
        add hl,de
        ex de,hl
        exx
        ld hl,00020h
        add hl,de
        ex de,hl
        ret

SALTA_LOSETA_INV:
        exx
        inc de
        inc de
        inc de
        inc de
        exx
        ld hl,00020h
        add hl,de
        ex de,hl
        ret

; Sustituye al JP VUELCA_TERCIO final de VUELCA_PANTALLA
VUELCA_COLOR:
        call VUELCA_TERCIO              ; tercer tercio de patrones, como antes
        ld a,(COLOR_SUCIO)
        ld hl,COLOR_NUEVO
        or (hl)
        ld hl,(V_PTR_BUFCOLOR)
        jr nz,.cambia
        ld de,(ULTIMO_PTR)              ; ¿se movió la ventana dentro del búfer?
        sbc hl,de                       ; (CF = 0 tras el OR)
        ret z                           ; nada que volcar
        add hl,de
.cambia:
        ld (ULTIMO_PTR),hl
        xor a
        ld (COLOR_SUCIO),a
        ld (COLOR_NUEVO),a
        ld a,020h
        call VUELCA_TERCIO_COLOR_RAPIDO
        ld a,028h
        call VUELCA_TERCIO_COLOR_RAPIDO
        ld a,030h
; HL = búfer de color (esquina del tercio), A = byte alto de la dirección de VRAM.
; Mismo orden que los patrones: por columnas, 8 caracteres de arriba abajo.
VUELCA_TERCIO_COLOR_RAPIDO:
        ld b,a
        in a,(099h)
        xor a
        out (099h),a
        ld a,b
        or 040h
        out (099h),a
        ld d,high TABLA_COLOR
        ld bc,28
        ld a,24                         ; columnas
.col:   ex af,af'
        rept 8
        ld e,(hl)
        ld a,(de)                       ; atributo -> color MSX
        rept 7
        out (098h),a
        nop
        jr $+2                          ; 30 ciclos entre escrituras
        endr
        out (098h),a
        add hl,bc
        endr
        ld bc,0FF21h                    ; sube 8 filas y avanza una columna
        add hl,bc
        ld bc,28
        ex af,af'
        dec a
        jp nz,.col
        ld bc,200                       ; HL = esquina del tercio siguiente
        add hl,bc
        ret
FIN_COLOR:
        assert FIN_COLOR <= 08400h
