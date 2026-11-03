; =============================================================================
;  Volcado por filas, segunda parte (FDE8h-FFFDh): ver filas.asm.
; =============================================================================
JUNTO_DIR       equ 0FDE8h

        org JUNTO_DIR

; ENTRA_VOLCADO (doble.asm), al empezar VUELCA_PANTALLA. Devuelve HL = primera
; línea del búfer que se ve.
PREPARA_FILAS:
        call PON_NT
        call PREPARA_SPRITES
        push hl
        xor a
        ld (CJ_ACT),a
        call VUELCA_COLOR+3             ; decide el color (COLOR_CAMBIA pone CJ_ACT)
        pop hl
        ret

; Tabla de nombres por filas, al empezar un volcado si no estaba
PON_NT:
        ld a,(NT_FILAS)
        or a
        ret nz
        inc a
        ld (NT_FILAS),a
        ld (COLOR_SUCIO),a              ; todo el color y todos los patrones otra vez,
        ld (EST+4),a                    ; en los dos bancos
        ld (EST+12),a
        xor a
        ld (PARCIAL_YA),a
        ld (EST),a
        ld (EST+8),a
        ld a,007h
        ld (REGS_0),a
        ld a,017h
        ld (REGS_1),a
        ld a,(MODO)
        or a
        jr z,.msx1
        xor a                           ; copia oculta: en los dos bancos; R#2 cambia
        call NT_BANCO                   ; al enseñar el banco volcado (ENSENA)
        ld a,1
        call NT_BANCO
        ld a,(R14_ACT)
        jp R14
.msx1:  call NT_ESCRIBE
        ld a,007h
        out (099h),a
        ld a,082h
        out (099h),a
        ret
NT_BANCO:
        call R14
NT_ESCRIBE:
        ld a,low NT_NUEVA
        out (099h),a
        ld a,high NT_NUEVA or 040h
        out (099h),a
        ld e,3                          ; tercios
.t:     xor a
        ld d,a                          ; fila
        ld c,a                          ; fila x 24
.f:     ld b,24
        ld a,c
.j:     out (098h),a                    ; juego: fila x 24 + columna
        inc a
        djnz .j
        ld c,a
        ld a,d
        add a,192
        ld b,8
.m:     out (098h),a                    ; marcador: 192 + (columna - 24) x 8 + fila
        add a,8
        djnz .m
        inc d
        ld a,d
        cp 8
        jr c,.f
        dec e
        jr nz,.t
        ret

; Vuelve a la tabla original: al limpiar la pantalla o si alguien escribe
; patrones en el área de juego (textos). Conserva HL.
QUITA_NT:
        ld a,(NT_FILAS)
        or a
        ret z
        push hl
        xor a
        ld (NT_FILAS),a
        ld (VRAM_OK),a
        ld (EST),a
        ld (EST+8),a
        inc a
        ld (COLOR_SUCIO),a
        ld (EST+4),a
        ld (EST+12),a
        ld a,006h
        ld (REGS_0),a
        ld a,016h
        ld (REGS_1),a
        ld a,(MODO)                     ; el banco que se ve ahora (con CAMBIO, aún el
        or a                            ; otro)
        ld b,006h
        jr z,.pon
        ld a,(CAMBIO)
        ld hl,B_VISTA
        xor (hl)
        jr z,.pon
        ld b,016h
.pon:   ld a,i
        push af
        di
        ld a,b
        out (099h),a
        ld a,082h
        out (099h),a
        pop af
        pop hl
        ret po
        ei
        ret

; INICIA_VDP (REINICIA_VDP, doble.asm): tabla original
INICIA_FILAS:
        xor a
        ld (NT_FILAS),a
        ld a,006h
        ld (REGS_0),a
        ld a,016h
        ld (REGS_1),a
        jp LA571

; Sprites durante el volcado (solo en MSX1: con copia oculta van al final).
; Un sprite cambia de sitio cuando el volcado pasa la fila de su mitad de
; arriba (la regla de ESCRIBE_ATR: Y + 32 < 8 x fila + 31). Si caben los dos
; (vieja + nueva <= 32), cada sprite tiene su hueco en la tabla de atributos:
; los viejos siguen en 0..N_VIEJA-1, como los dejó ATR_FINAL, y los nuevos se
; ponen detrás escondidos (Y = BFh); en cada fila solo se escribe la Y de los
; que cambian (ATR_FILA). F_FLAGS[fila] = primer sprite + 1 (nuevos 0-31,
; viejos 32-63) y N_SIG[sprite] = el siguiente de la misma fila + 1. Si no
; caben, F_FLAGS solo dice en qué filas hay que reescribir la tabla entera.
MARCA_FILAS_ATR:
        ld hl,F_FLAGS
        ld b,24
.borra: ld (hl),0
        inc l
        djnz .borra
        xor a
        ld (F_HUECOS),a
        ld a,(MODO)
        or a
        ret nz
        ld a,(N_VIEJA)
        ld c,a
        ld a,(N_NUEVA)
        ld b,a
        add a,c
        cp 33
        jr nc,.listas
        ld (F_HUECOS),a
        ld a,c                          ; los nuevos, escondidos, detrás de los viejos
        add a,a
        add a,a
        ld l,a
        ld h,high 01B00h
        call VDP_DIRECCION
        ld a,b
        or a
        jr z,.d0
        ld hl,ATR_NUEVA
.nuevo: ld a,0BFh
        out (098h),a
        inc l
        ld a,(hl)
        nop                             ; (30 ciclos entre escrituras como poco)
        out (098h),a
        inc l
        ld a,(hl)
        nop
        out (098h),a
        inc l
        ld a,(hl)
        nop
        out (098h),a
        inc l
        djnz .nuevo
.d0:    ld a,(F_HUECOS)
        cp 32
        jr nc,.listas
        ld a,0D0h
        out (098h),a
.listas:
        ld hl,ATR_NUEVA
        ld a,(N_NUEVA)
        ld e,0
        call .lista
        ld hl,ATR_VIEJA
        ld a,(N_VIEJA)
        ld e,32
.lista: or a
        ret z
        ld b,a
.sig:   ld a,(hl)
        cp 0BFh
        jr z,.salta
        add a,32
        sub 31
        jr c,.pon
        rrca
        rrca
        rrca
        and 01Fh
        inc a
        cp 23
        jr nc,.salta                    ; la última fila: ya lo hace ATR_FINAL
        db 0FEh                         ; (CP n: salta el XOR A)
.pon:   xor a
        push hl
        add a,low F_FLAGS
        ld l,a
        ld h,high F_FLAGS
        ld c,(hl)
        ld a,e
        inc a
        ld (hl),a
        ld a,e
        add a,low N_SIG
        ld l,a
        ld (hl),c
        pop hl
.salta: inc l
        inc l
        inc l
        inc l
        inc e
        djnz .sig
        ret

; Tras una fila: A = F_FLAGS de la fila (primer sprite + 1)
ATR_FILA:
        dec a
        ld e,a
        cp 32
        jr nc,.viejo
        add a,a                         ; nuevo: Y en su hueco (N_VIEJA + n)
        add a,a
        ld l,a
        ld h,high ATR_NUEVA
        ld c,(hl)
        ld a,(N_VIEJA)
        add a,e
        jr .pon
.viejo: ld c,0BFh                       ; viejo: se esconde
        sub 32
.pon:   add a,a
        add a,a
        ld l,a
        ld h,high 01B00h
        call VDP_DIRECCION
        ld a,c
        out (098h),a
        ld a,e
        add a,low N_SIG
        ld l,a
        ld h,high N_SIG
        ld a,(hl)
        or a
        jr nz,ATR_FILA
        ret

; VUELCA_TODO, al acabar: la lista nueva entera (también los escondidos), cada
; sprite en su hueco, como la espera MARCA_FILAS_ATR en el volcado siguiente
ATR_FINAL:
        ld hl,01B00h
        call VDP_DIRECCION
        ld a,(N_NUEVA)
        add a,a
        add a,a
        jr z,.d0
        ld b,a
        ld hl,ATR_NUEVA
.byte:  ld a,(hl)
        out (098h),a
        inc l
        djnz .byte
.d0:    ld a,(N_NUEVA)
        cp 32
        ret nc
        ld a,0D0h
        out (098h),a
        ret

FIN_JUNTO:
        assert FIN_JUNTO <= 0FFFEh      ; FFFFh: registro de subslots
        savebin "junto_FDE8.bin",JUNTO_DIR,FIN_JUNTO-JUNTO_DIR
