; =============================================================================
;  Patrones y color juntos, columna a columna (-DPATCOL; pedido de araubi,
;  2026-10-28: «evitar saltos de color»).
;
;  Antes VUELCA_PANTALLA mandaba los patrones de los tres tercios (unos dos
;  cuadros en MSX1) y después el color: mientras tanto se veían los dibujos
;  nuevos con los colores viejos. Ahora se decide al empezar si hay que mandar
;  color (VUELCA_COLOR sin el tercer tercio) y, tras los patrones de cada
;  columna de 8 caracteres de un tercio, va su color (TERCIO_COLOR, una
;  columna cada vez). Lo que se ve a medias es como mucho una columna.
;
;  Va en FDE8h-FFFEh: por encima de la pila del juego (FDE8h), RAM que la BIOS
;  usa durante la carga y el juego no toca. Los cargadores lo copian al final.
; =============================================================================
JUNTO_DIR       equ 0FDE8h

        org JUNTO_DIR
CJ_ACT: db 0                            ; <> 0: en este volcado va color
CJ_HL:  dw 0                            ; búfer de color: esquina del tercio siguiente
CJ_HLC: dw 0                            ; búfer de color: columna en curso
CJ_DE:  dw 0                            ; SOMBRA de la columna en curso
VR_DIR: dw 0                            ; VOLCADO_RAPIDO: VRAM de la columna en curso

; ENTRA_VOLCADO (doble.asm), al empezar cualquier VUELCA_PANTALLA
PREPARA_JUNTO:
        call PREPARA_SPRITES            ; devuelve HL = primera línea del búfer
        push hl
        xor a
        ld (CJ_ACT),a
        call VUELCA_COLOR+3             ; decide y prepara el color (COLOR_CAMBIA pone CJ_ACT)
        pop hl
        ret

; TERCIO_ELIGE, antes de cada tercio: HL = búfer, D = 0, 8 o 16 (VRAM).
; Conserva HL y DE.
TC_INICIO:
        ld a,(CJ_ACT)
        or a
        ret z
        push hl
        push de
        ld hl,(CJ_HL)
        ld (CJ_HLC),hl
        ld bc,224
        add hl,bc
        ld (CJ_HL),hl
        ld hl,0
        ld (C_SIGUE),hl
        ld a,d
        add a,020h
        ld (C_VRAM),a
        sub 020h                        ; 0, 8, 16 -> x 24 (como TERCIO_COLOR)
        ld l,a
        ld h,0
        add hl,hl
        ld b,h
        ld c,l
        add hl,hl
        add hl,bc
        add hl,hl
        add hl,hl
        ld bc,(TERCIO_COLOR.sombra+1)   ; SOMBRA o SOMBRA_B
        add hl,bc
        ld (C_BASE),hl
        ex de,hl
        ld hl,(CJ_HLC)
        ld a,(C_FORZAR)
        or a
        call nz,BORRA_SOMBRA            ; (conserva HL y DE)
        ld (CJ_DE),de
        pop de
        pop hl
        ret

; Tras los patrones de una columna: su color. No conserva nada salvo IX.
COL_JUNTO:
        ld a,(CJ_ACT)
        or a
        ret z
        push ix
        ld hl,0                         ; la VRAM ya no está detrás del último color
        ld (C_SIGUE),hl
        ld hl,(CJ_HLC)
        ld d,h
        ld e,l
        inc de
        ld (CJ_HLC),de
        ld de,(CJ_DE)
        ld bc,28
        call .entra
        ld (CJ_DE),de
        pop ix
        ret
.entra: push hl                         ; lo saca TERCIO_COLOR.fin_t
        ld a,(C_RAPIDO)
        or a
        ld a,1                          ; una columna
        jp nz,TERCIO_COLOR.rcol
        jp TERCIO_COLOR.col

; VUELCA_TERCIO entero, como el de acelera.asm, con el color de cada columna
; detrás de sus patrones. HL = esquina del tercio en el búfer, DE = VRAM.
; Devuelve HL + 24.
VOLCADO_RAPIDO:
        ex de,hl
        call VDP_ESCRITURA
        ld (VR_DIR),hl
        ex de,hl
        ld c,18h                        ; 24 columnas de caracteres
.col:   ld de,1Ch                       ; 28 bytes por línea en el búfer
        rept 64                         ; 8 caracteres x 8 líneas
        ld a,(hl)
        out (98h),a
        add hl,de
        endr
        ld de,0F901h                    ; vuelve arriba y avanza un byte
        add hl,de
        ld a,(CJ_ACT)
        or a
        jr z,.sig
        push hl
        push bc
        call COL_JUNTO
        ld hl,(VR_DIR)                  ; patrones de la columna siguiente
        ld de,64
        add hl,de
        ld (VR_DIR),hl
        call VDP_DIRECCION
        pop bc
        pop hl
.sig:   dec c
        jp nz,.col
        ret
FIN_JUNTO:
        assert FIN_JUNTO <= 0FFFFh
        savebin "junto_FDE8.bin",JUNTO_DIR,FIN_JUNTO-JUNTO_DIR
