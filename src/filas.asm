; =============================================================================
;  Volcado por filas (-DPORFILAS; pedido de araubi, 2026-10-28: «evitar saltos de
;  color»).
;
;  La tabla de nombres del juego va por columnas (carácter = columna x 8 +
;  fila en cada tercio), así que el volcado iba por columnas de un tercio:
;  mientras dura (unos 100 ms en MSX1) se veían trozos verticales nuevos junto
;  a otros viejos, el color llegaba después que los dibujos y los sprites de
;  color cambiaban de sitio solo al acabar cada tercio, con lo que a veces no
;  coincidían con su máscara del fondo.
;
;  Ahora, durante la partida, el área de juego usa otra tabla de nombres
;  (1C00h, R#2 = 07h) que va por filas: carácter = fila x 24 + columna (el
;  marcador, igual que antes). Así cada fila de 24 caracteres es seguida en
;  VRAM y se manda de una vez: primero sus patrones, luego su color y, si
;  algún sprite cambia de sitio a esa altura, los atributos (la mitad de
;  arriba de la figura ya volcada: el sprite nuevo; si no, el viejo). Lo que
;  se ve a medias es como mucho una fila de caracteres.
;
;  Los textos del juego (menús, fin de partida) escriben con la tabla
;  original: al limpiar la pantalla (todo el color en negro) se vuelve a ella,
;  y al empezar un volcado del bucle principal se pasa a la nueva.
;
;  El bucle de volcado va en el bloque 8400h (desplaza.asm lo incluye) y lo
;  demás en FDE8h-FFFDh (filas_alto.asm: encima de la pila del juego; lo copian
;  los cargadores al final, como doble.asm). Datos en 0040h-00FFh.
; =============================================================================
NT_NUEVA        equ 01C00h              ; libre en VRAM (1B80h-1FFFh)
SPAN_PP         equ 0E400h + low SPAN_P ; SPAN_N de hace dos vueltas (copia oculta)
        assert SPAN_PP >= BUF_COPIA + 64
        assert SPAN_PP + 56 <= COL_PP

F_FLAGS         equ 00040h              ; 24 filas: sprites que cambian tras ella (ver
                                        ; MARCA_FILAS_ATR)
NT_FILAS        equ F_FLAGS + 24        ; <> 0: tabla de nombres por filas
CJ_ACT          equ NT_FILAS + 1        ; <> 0: en este volcado va color
F_FILA          equ CJ_ACT + 1          ; fila de la pantalla (0-23)
F_PTR           equ F_FILA + 1          ; búfer de patrones de la fila
F_COL           equ F_PTR + 2           ; búfer de color de la fila
F_VRAM          equ F_COL + 2           ; patrones de la fila en VRAM
F_SOMBRA        equ F_VRAM + 2          ; SOMBRA de la fila
F_HUECOS        equ F_SOMBRA + 2        ; <> 0: cada sprite en su hueco (ATR_FILA)
FIN_F           equ F_HUECOS + 1
N_SIG           equ 00080h              ; 64 sprites (32 nuevos y 32 viejos): siguiente
        assert FIN_F <= N_SIG           ; de la misma fila + 1
        assert N_SIG + 64 <= 00100h

; VUELCA_PANTALLA: las 24 filas. HL = primera línea del búfer que se ve.
VOLCADO_FILAS:
        push ix
        push iy
        ld (F_PTR),hl
        ld hl,(ULTIMO_PTR)
        ld (F_COL),hl
        call TERCIO_COLOR               ; F_SOMBRA = SOMBRA del banco
        call MARCA_FILAS_ATR
        xor a
        ld (F_FILA),a
.fila:  ld a,(F_FILA)
        ld c,a
        and 7
        jr nz,.dentro
        ld h,c                          ; tercio nuevo: VRAM = fila x 100h (tercio x 800h)
        ld l,a
        ld (F_VRAM),hl
        ld a,c
        add a,020h
        ld (C_VRAM),a
        ld hl,(F_SOMBRA)
        ld (C_BASE),hl
.dentro:
        ld a,(PARCIAL_YA)
        or a
        ld de,01700h                    ; D = última columna, E = primera
        call nz,RANGO_FILA
        jr c,.color                     ; nada que mandar en esta fila
        ld hl,(F_VRAM)
        ld a,e
        add a,a
        add a,a
        add a,a
        add a,l
        ld l,a
        adc a,h
        sub l
        ld h,a
        call VDP_DIRECCION
        ld a,d
        sub e
        inc a
        ld b,a                          ; caracteres
        ld hl,(F_PTR)
        ld a,e
        add a,l
        ld l,a
        adc a,h
        sub l
        ld h,a
        ld de,28
.car:   push hl
        rept 7
        ld a,(hl)
        out (098h),a
        add hl,de
        endr
        ld a,(hl)
        out (098h),a
        pop hl
        inc hl
        djnz .car
.color: ld a,(CJ_ACT)
        or a
        call nz,TERCIO_COLOR.fila
        ld a,(F_FILA)
        ld e,a
        add a,low F_FLAGS
        ld l,a
        ld h,high F_FLAGS
        ld a,(hl)
        or a
        jr z,.sig
        ld c,a
        ld a,(F_HUECOS)
        or a
        ld a,c
        jr z,.lento
        call ATR_FILA
        jr .sig
.lento: ld a,e                          ; sprites: zona volcada hasta esta fila
        add a,a
        add a,a
        add a,a
        add a,31
        ld d,a
        call ESCRIBE_ATR
.sig:   ld hl,(F_PTR)
        ld de,224
        add hl,de
        ld (F_PTR),hl
        ld hl,(F_COL)
        ld de,28
        add hl,de
        ld (F_COL),hl
        ld hl,(F_SOMBRA)
        ld de,24
        add hl,de
        ld (F_SOMBRA),hl
        ld hl,(F_VRAM)
        ld de,192
        add hl,de
        ld (F_VRAM),hl
        ld hl,F_FILA
        inc (hl)
        ld a,(hl)
        cp 24
        jp c,.fila
        pop iy
        pop ix
        ret

; Volcado parcial: columnas de la fila F_FILA que cambiaron (SPAN_N, SPAN_P y,
; con copia oculta, SPAN_PP; con FINO <> 0 también las de la fila siguiente
; del búfer). Devuelve E = primera, D = última (de la ventana) o CF si no hay.
RANGO_FILA:
        ld a,(WIN_R)
        ld hl,F_FILA
        add a,(hl)
        add a,a
        ld l,a
        ld h,high SPAN_N
        ld de,000FFh                    ; D = última, E = primera: vacío
        call .une                       ; SPAN_N
        set 7,l
        call .une                       ; SPAN_P
        call .pp
        ld a,(FINO)
        or a
        jr z,.ventana
        ld a,l
        add a,2
        cp low SPAN_P + 56
        jr nc,.ventana
        ld l,a
        call .une                       ; fila siguiente: SPAN_P,
        call .pp                        ; SPAN_PP
        res 7,l
        call .une                       ; y SPAN_N
.ventana:
        ld a,(WIN_C)
        ld c,a
        ld a,d
        sub c
        ret c
        cp 24
        jr c,.ult
        ld a,23
.ult:   ld d,a
        ld a,e
        sub c
        jr nc,.pri
        xor a
.pri:   ld e,a
        ld a,d
        cp e
        ret
.pp:    ld a,(MODO)
        or a
        ret z
        ld h,high SPAN_PP
        call .une
        ld h,high SPAN_N
        ret
.une:   ld a,(hl)
        cp e
        jr nc,.u1
        ld e,a
.u1:    inc l
        ld a,(hl)
        cp d
        jr c,.u2
        ld d,a
.u2:    dec l
        ret

; Color. TERCIO_COLOR (una vez por volcado): F_SOMBRA = SOMBRA del banco.
; TERCIO_COLOR.fila: la fila F_FILA, de izquierda a derecha, comparando con
; SOMBRA y SOMBRA2 como en el TERCIO_COLOR de parcial.asm (COLOR_CAMBIA
; modifica .modo y .c3). IY = búfer de color, HL = SOMBRA.
TERCIO_COLOR:
.sombra:
        ld hl,SOMBRA                    ; (o SOMBRA_B, doble.asm)
        ld (F_SOMBRA),hl
        ret
.fila:  ld hl,0                         ; tras los patrones hay que dar la dirección
        ld (C_SIGUE),hl
        ld iy,(F_COL)
        ld hl,(F_SOMBRA)
        ld ixl,24
        ld a,(C_FORZAR)
        or a
        jr nz,.forzar
        ld a,(C_RAPIDO)
        or a
        jr nz,.rapido
.car:   ld c,(iy+0)                     ; C = arriba
        ld a,c
        cp (hl)                         ; SOMBRA
        jr nz,.manda
        ld b,(iy+28)                    ; B = abajo
        set 3,h                         ; SOMBRA2
.modo:  jr .a                           ; (o NOP / NOP)
        cp (hl)                         ; SOMBRA2 = arriba
        res 3,h
        jr nz,.manda
.c3:    cp b                            ; abajo = arriba (CP A con FINO = 0)
        jr nz,.manda
.sig:   inc hl
        inc iy
        dec ixl
        jr nz,.car
        ret
.a:     ld a,b                          ; SOMBRA2 = abajo
        cp (hl)
        res 3,h
        jr z,.sig
.manda: ld b,(iy+28)
        call ENVIA_COLOR
        jr .sig
.salto  equ ((.a - .modo - 2) << 8) | 018h ; JR .a
; Solo cambió FINO: los caracteres con el mismo color arriba y abajo siguen igual
.rapido:
        ld c,(iy+0)
        ld b,(iy+28)
        ld a,c
        cp b
        call nz,ENVIA_COLOR
        inc hl
        inc iy
        dec ixl
        jr nz,.rapido
        ret
; El color de VRAM se tocó desde fuera: se manda todo
.forzar:
        ld c,(iy+0)
        ld b,(iy+28)
        call ENVIA_COLOR
        inc hl
        inc iy
        dec ixl
        jr nz,.forzar
        ret
