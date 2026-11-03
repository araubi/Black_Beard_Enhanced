; =============================================================================
;  Antorcha en la mano con sprite de color 8 (pedido de araubi, 2026-10-24).
;  LB8B4 dibuja la antorcha que lleva el jugador como objeto (AC1Fh) junto a
;  él. Aquí se apunta cuál de las 4 y dónde, y PREPARA_SPRITES pone debajo un
;  sprite de 16x16 de color 8 con su papel (las zonas verdes de la hoja de
;  araubi). Usa el último hueco de patrones de cada banco (por eso MAX_FIG = 7)
;  y va detrás de las figuras en la lista de atributos.
;  Las máscaras de las antorchas llevan el halo recortado (antorcha_mascaras.asm).
; =============================================================================
COLOR_ANT       equ 8                   ; rojo
ANT_HAY         equ 0320h               ; <> 0: esta vuelta se ha dibujado la antorcha
ANT_X           equ ANT_HAY + 1         ; x e y como en LAC1F (C y B)
ANT_Y           equ ANT_X + 1
ANT_PAT         equ ANT_Y + 1           ; 2 bytes: patrón en ANT_TABLA
        assert ANT_PAT + 2 <= 003E8h

        include "antorcha_mascaras.asm"

        org 0B8F6h                      ; LD HL,0210h / JP LAC1F
        jp ANTORCHA

        org FIN_ANTERIOR
; B = y, C = x, DE = gráfico (59E0h, 5A20h, 5A60h o 5AA0h)
ANTORCHA:
        ld (ANT_X),bc
        ld hl,-059E0h
        add hl,de                       ; 0, 40h, 80h o C0h
        ld a,l
        rrca                            ; 32 bytes por patrón
        ld l,a
        ld h,0
        push de
        ld de,ANT_TABLA
        add hl,de
        pop de
        ld (ANT_PAT),hl
        ld a,1
        ld (ANT_HAY),a
        ld hl,00210h
        jp LAC1F

; Al final de PREPARA_SPRITES: patrón en el banco que no se ve y atributo
ANTORCHA_SPR:
        ld a,(ANT_HAY)
        or a
        ret z
        xor a
        ld (ANT_HAY),a
        ld a,(ANT_X)
.lim:   cp 192-16+1                     ; pegada al marcador: sin sprite
        ret nc
        ld hl,03B80h                    ; hueco 8 del banco 0 (patrón 70h)
        ld a,(BANCO)
        or a
        jr z,.banco
        ld h,03Fh                       ; del banco 1 (F0h)
.banco: call VDP_DIRECCION
        ld hl,(ANT_PAT)
        ld b,32
.pat:   ld a,(hl)                       ; 37 ciclos por byte
        out (098h),a
        inc hl
        djnz .pat
        ld a,(FINO)                     ; la ventana baja FINO líneas (scroll.asm)
        ld e,a
        ld a,(ANT_Y)
        sub e
        dec a                           ; el VDP pinta el sprite una línea más abajo
        cp 0D0h                         ; D0h acabaría la lista
        jr nz,.y
        ld a,0BFh
.y:     ld d,a
        ld a,(ANT_X)
        ld e,a
        ld a,(BANCO)
        rrca
        add a,070h
        ld c,a
        ld a,COLOR_ANT
        ld (COLOR_FIG),a
        call ATRIBUTO
        ld hl,N_NUEVA
        inc (hl)
        ret

        include "antorcha_tabla.asm"
FIN_ANTORCHA:
        assert FIN_ANTORCHA <= 0E290h   ; E290h-E293h: TEST.BIN y el cargador de la ROM
