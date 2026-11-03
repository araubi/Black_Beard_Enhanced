; =============================================================================
;  Copia oculta en MSX2, MSX2+ y turbo R (pedido de araubi, 2026-10-27).
;
;  En MSX1 el volcado se ve mientras se hace: dura unos dos cuadros, la parte
;  de arriba ya es la nueva y la de abajo aún la vieja, y los sprites de color
;  cambian de sitio tercio a tercio, así que a veces no coinciden con su
;  máscara. El V9938 tiene VRAM de sobra: aquí hay dos copias de la pantalla
;  (banco 0 en 0000h-3FFFh y banco 1 en 4000h-7FFFh, con las mismas tablas) y
;  se vuelca siempre en la que no se ve. Al acabar, en la siguiente
;  interrupción de imagen se cambian los registros de las tablas y se ve todo
;  de golpe: patrones, color y sprites a la vez.
;
;  - El registro 14 del VDP da los bits altos de la dirección: VDP_DIR_CUENTA
;    lo escribe en cada dirección (R14_ACT). Lo que escribe el juego va al
;    banco que se ve; el volcado, al otro.
;  - El banco que no se ve tiene lo de hace dos vueltas: el volcado parcial
;    junta lo pintado en esta vuelta, en la anterior y en la de antes (COL_PP).
;    Cada banco guarda su estado (EST: si vale, ventana, FINO y color) y su
;    SOMBRA de color.
;  - El marcador lo escribe el juego en el banco que se ve: se apunta qué
;    columna de 8 caracteres se tocó (MARCAS) y se copia al otro antes de
;    cambiar.
;  - INICIA_VDP lo pone todo en el banco 0 y el primer volcado copia el banco
;    entero al otro.
;
;  Se activa si el byte 002Dh de la BIOS (lo copia el cargador en V_MSX) es 1
;  o más. Va en F480h-F7FFh (RAM que el juego no usa); el cargador lo copia.
; =============================================================================
DOBLE           equ 0F480h
SOMBRA_B        equ 0F240h              ; SOMBRA del banco 1 (y SOMBRA2 en +0800h)
        assert SOMBRA_B == SOMBRA + 576
        assert SOMBRA_B + 0800h + 576 <= 0FC80h
BUF_COPIA       equ 0E400h              ; 64 bytes (LOAD.BIN, libre en la partida)
COL_PP          equ 0E400h + low COL_P  ; COL_N de hace dos vueltas (E400h-E4FFh: libre)
        assert COL_PP >= BUF_COPIA + 64
        assert COL_PP + 56 <= 0E500h

        org 0A560h                      ; INICIA_VDP: CALL LA571
        call REINICIA_VDP

        org DOBLE
V_MSX:  db 0                            ; byte 002Dh de la BIOS (lo copia el cargador)
MODO:   db 0                            ; <> 0: con copia oculta
B_VISTA:
        db 0                            ; banco que se ve
R14_ACT:
        db 0                            ; banco de las escrituras (R#14)
CAMBIO: db 0                            ; <> 0: en la próxima imagen se enseña B_VISTA
DENTRO: db 0                            ; <> 0: volcando en el banco que no se ve
EN_JUEGO:
        db 0                            ; <> 0: el volcado es el del bucle principal
COPIA_TODO:
        db 0                            ; <> 0: copiar entero el banco que se ve al otro
EST:    ds 16                           ; por banco: VRAM_OK, ULT_BUFER (2), FINO_VRAM,
                                        ; COLOR_SUCIO, COLOR_NUEVO, ULTIMO_PTR (2)
REGS_0: db 006h,082h, 003h,084h, 036h,085h, 007h,086h, 000h,08Ah
REGS_1: db 016h,082h, 00Bh,084h, 0B6h,085h, 00Fh,086h, 001h,08Ah

; En lugar de CALL LA571 en INICIA_VDP: todo en el banco 0
REINICIA_VDP:
        ifdef PORFILAS
        call INICIA_FILAS               ; tabla de nombres original (filas.asm)
        else
        call LA571
        endif
        ld a,(V_MSX)
        or a
        ret z
        ld a,i                          ; P/V = interrupciones activas
        push af
        di
        xor a
        ld (B_VISTA),a
        ld (R14_ACT),a
        ld (CAMBIO),a
        ld (DENTRO),a
        ifndef PORFILAS
        ld (TERCIO_PARCIAL.pp+1),a      ; JR $+2: COL_PP también
        endif
        out (099h),a                    ; R#10 = 0 (color en 2000h)
        ld a,08Ah
        out (099h),a
        xor a
        out (099h),a                    ; R#14 = 0
        ld a,08Eh
        out (099h),a
        ld hl,0
        ld (VDP_DIR_CUENTA.r14),hl      ; NOP / NOP: R#14 en cada dirección
        ld a,1
        ld (MODO),a
        ld (COPIA_TODO),a
        pop af
        ret po
        ei
        ret

; Al empezar un volcado: desde el bucle principal (VUELCA_JUEGO, antes de
; decidir si es parcial) o desde cualquier VUELCA_PANTALLA
ENTRA_JUEGO:
        ld a,1
        jr ENTRA
ENTRA_VOLCADO:
        di
        xor a
        call ENTRA
        ifdef PORFILAS
        jp PREPARA_FILAS
        else
        jp PREPARA_SPRITES
        endif
ENTRA:
        ld b,a
        ld a,(MODO)
        or a
        ret z
        ld a,(DENTRO)
        or a
        ret nz
        inc a
        ld (DENTRO),a
        ld a,b
        ld (EN_JUEGO),a
.espera:
        ld a,(CAMBIO)                   ; el banco que no se ve aún se está viendo
        or a
        jr z,.ya
        ei
        halt
        di
        jr .espera
.ya:    ld a,(COPIA_TODO)
        or a
        call nz,COPIA_BANCO
        ld a,(VRAM_OK)                  ; alguien escribió en el área de juego
        or a
        jr nz,.vale
        ld (EST),a
        ld (EST+8),a
.vale:  ld a,(ENTERO)                   ; fondo nuevo: el banco que se ve ya no vale
        or a
        jr z,.fondo
        ld a,(B_VISTA)
        call EST_BANCO
        ld (hl),0
.fondo: ld a,(COLOR_SUCIO)              ; lo que pide repasar el color, para los dos
        or a
        jr z,.sucio
        ld (EST+4),a
        ld (EST+12),a
.sucio: ld a,(COLOR_NUEVO)
        ld hl,EST+5
        or (hl)
        ld (hl),a
        ld a,(COLOR_NUEVO)
        ld hl,EST+13
        or (hl)
        ld (hl),a
.nuevo: ld a,(B_VISTA)
        xor 1
        ld (R14_ACT),a
        ld de,SOMBRA
        jr z,.s0
        ld de,SOMBRA_B
.s0:    ld (TERCIO_COLOR.sombra+1),de
        call EST_BANCO
        ld a,(hl)
        ld (VRAM_OK),a
        inc hl
        ld e,(hl)
        inc hl
        ld d,(hl)
        inc hl
        ld (ULT_BUFER),de
        ld a,(hl)
        ld (FINO_VRAM),a
        inc hl
        ld a,(hl)
        ld (COLOR_SUCIO),a
        inc hl
        ld a,(hl)
        ld (COLOR_NUEVO),a
        inc hl
        ld e,(hl)
        inc hl
        ld d,(hl)
        ld (ULTIMO_PTR),de
        ret

; HL = EST del banco A
EST_BANCO:
        add a,a
        add a,a
        add a,a
        add a,low EST
        ld l,a
        adc a,high EST
        sub l
        ld h,a
        ret

; Al acabar VUELCA_PANTALLA (VUELCA_TODO): guarda el estado del banco volcado,
; le copia lo que cambió del marcador y pide enseñarlo
SALE_DOBLE:
        ld a,(DENTRO)
        or a
        ret z
        xor a
        ld (DENTRO),a
        ld a,(B_VISTA)
        xor 1
        call EST_BANCO
        ld a,(EN_JUEGO)
        ld (hl),a
        inc hl
        ld de,(ULT_BUFER)
        ld (hl),e
        inc hl
        ld (hl),d
        inc hl
        ld a,(FINO_VRAM)
        ld (hl),a
        inc hl
        ld a,(COLOR_SUCIO)
        ld (hl),a
        inc hl
        ld a,(COLOR_NUEVO)
        ld (hl),a
        inc hl
        ld de,(ULTIMO_PTR)
        ld (hl),e
        inc hl
        ld (hl),d
        ld hl,MARCAS                    ; columnas del marcador tocadas
        ld c,0
.marca: ld a,(hl)
        or a
        jr z,.sig
        ld (hl),0
        push hl
        push bc
        call DIR_MARCA
        call COPIA64
        pop bc
        pop hl
.sig:   inc hl
        inc c
        ld a,c
        cp 48
        jr c,.marca
        ld a,(B_VISTA)
        xor 1
        ld (B_VISTA),a
        ld (R14_ACT),a
        call R14                        ; lo que escriba el juego, al que se va a ver
        ld a,1
        ld (CAMBIO),a
        ret

; En la interrupción de imagen (CUENTA_CUADRO): registros de las tablas
ENSENA:
        xor a
        ld (CAMBIO),a
        push bc
        push hl
        ld a,(B_VISTA)
        or a
        ld hl,REGS_0
        jr z,.r
        ld hl,REGS_1
.r:     ld bc,10 * 256 + 099h
        otir
        pop hl
        pop bc
        ret

; Con copia oculta, los atributos de los sprites solo al final (VUELCA_TODO)
ATR_TERCIO:
        ld a,(MODO)
        or a
        ret nz
        jp ESCRIBE_ATR

; FONDO_JUEGO: lo de la vuelta anterior pasa a ser lo de hace dos
COPIA_PP:
        ld a,(MODO)
        or a
        ret z
        ifdef PORFILAS
        ld hl,SPAN_P                    ; por filas (filas.asm)
        ld de,SPAN_PP
        else
        ld hl,COL_P
        ld de,COL_PP
        endif
        ld bc,56
        ldir
        ret

; VDP_ESCRITURA_PARCIAL, en el marcador (columnas 24-31): HL = dirección.
; Apunta su columna de 8 caracteres. Devuelve Z.
MARCA_HUD:
        ld a,(MODO)
        or a
        ret z
        push bc
        ld a,h
        and 03Fh
        cp 018h
        jr c,.pat                       ; patrones
        sub 020h
        cp 018h
        jr nc,.fin                      ; ni patrones ni color
        and 018h
        add a,24                        ; color: 24-47
        jr .col
.pat:   and 018h                        ; tercio x 8
.col:   ld b,a
        ld a,h
        and 1
        add a,a
        add a,a
        ld c,a
        ld a,l
        rlca
        rlca
        and 3
        or c                            ; columna - 24
        add a,b
        add a,low MARCAS
        ld c,a
        ld b,high MARCAS
        ld a,1
        ld (bc),a
.fin:   pop bc
        xor a
        ret

; C = marca (0-47) -> HL = dirección de su columna
DIR_MARCA:
        ld a,c
        ld d,0
        cp 24
        jr c,.p
        sub 24
        ld d,020h
.p:     ld e,a
        and 018h                        ; tercio x 0800h
        add a,d
        add a,6                         ; columna 24 x 64
        ld d,a
        ld a,e
        and 4
        rrca
        rrca
        add a,d
        ld h,a
        ld a,e
        and 3
        rrca
        rrca
        ld l,a
        ret

; El banco que se ve, entero, al otro (tras INICIA_VDP)
COPIA_BANCO:
        xor a
        ld (COPIA_TODO),a
        ld hl,0
.trozo: call COPIA64
        ld de,64
        add hl,de
        bit 6,h
        jr z,.trozo
        ld hl,EST                       ; nada vale; el color, a repasar
        ld b,16
.est:   ld (hl),0
        inc hl
        djnz .est
        ld a,1
        ld (EST+4),a
        ld (EST+12),a
        ld hl,MARCAS
        ld b,48
.m:     ld (hl),0
        inc hl
        djnz .m
        ret

; 64 bytes de VRAM (HL, 0000h-3FFFh) del banco que se ve al otro. Conserva HL.
COPIA64:
        ld a,(B_VISTA)
        call R14
        ld a,l
        out (099h),a
        ld a,h
        and 03Fh
        out (099h),a                    ; lectura
        push hl
        ld hl,BUF_COPIA
        ld b,64
.lee:   in a,(098h)
        ld (hl),a
        inc hl
        djnz .lee
        pop hl
        ld a,(B_VISTA)
        xor 1
        call R14
        ld a,l
        out (099h),a
        ld a,h
        and 03Fh
        or 040h
        out (099h),a
        push hl
        ld hl,BUF_COPIA
        ld b,64
.esc:   ld a,(hl)
        out (098h),a
        inc hl
        djnz .esc
        pop hl
        ret

R14:    out (099h),a
        ld a,08Eh
        out (099h),a
        ret

        align 64
MARCAS: ds 48                           ; columnas del marcador por copiar: 3 tercios x 8
                                        ; de patrones y luego 3 x 8 de color
        assert high MARCAS == high (MARCAS + 47)

; AVANZA_LOSETA (desplaza.asm), en todas las máquinas: MUEVE_TODO desplaza
; cada búfer una loseta con MUEVE_UNO.
; IX = entrada de T_MUEVE (base, loseta y tamaño en vertical; loseta, ancho y
; filas en horizontal). Devuelve HL = sitio de la loseta nueva e IX + 9.
MUEVE_UNO:
        ld a,(D_DIR)
        cp 2
        jr nc,.horiz
        ld c,(ix+2)
        ld b,(ix+3)
        ld e,(ix+4)
        ld d,(ix+5)
        ld a,1
        jr .sigue
.horiz: ld c,(ix+6)
        ld b,0
        ld e,(ix+7)
        ld d,b
        ld a,(ix+8)
.sigue: push af                         ; filas
        ld (M_SPAN),de
        ex de,hl
        or a
        sbc hl,bc
        ld (M_N),hl                     ; bytes que se mueven en cada fila
        ld e,(ix+0)
        ld d,(ix+1)
        ld a,(D_DIR)
        rrca
        jr c,.atras
        add hl,de                       ; abajo o derecha: hacia el principio;
        ld (M_INI),hl                   ; lo nuevo, al final
        ld h,d
        ld l,e
        add hl,bc
        ld a,0B0h                       ; LDIR
        ld bc,COPIA8                    ; (desplaza.asm)
        jr .pon
.atras: ld (M_INI),de                   ; arriba o izquierda: desde el final de
        ld hl,(M_SPAN)                  ; cada fila; lo nuevo, al principio
        add hl,de
        dec hl
        ld d,h
        ld e,l
        sbc hl,bc                       ; (CY = 0)
        ld a,0B8h                       ; LDDR
        ld bc,COPIA8_ATRAS
.pon:   ld (.op+1),a
        ld (.rap+1),bc
        pop af
.fila:  push af
        push hl
        push de
        ld bc,(M_N)
        ld a,c
        and 7
        jr nz,.op
.rap:   call COPIA8                     ; múltiplo de 8: más rápido que LDIR
        jr .hecho
.op:    ldir
.hecho:
        ld bc,(M_SPAN)
        pop hl
        add hl,bc
        ex de,hl
        pop hl
        add hl,bc
        pop af
        dec a
        jr nz,.fila
        ld bc,9
        add ix,bc
        ld hl,(M_INI)
        ret

T_MUEVE:
        dw 003E8h, 0380h, 28*224 : db 4, 28, 224        ; patrones
        dw 01C68h, 0070h, 28*28  : db 4, 28, 28         ; color
        dw CACHE_COLOR, 21, 49*3 : db 3, 21, 7          ; caché del color
        dw TILES, 21, 49*3       : db 3, 21, 7          ; losetas (RESTAURA)
        dw MAPA_COPIA, 14, 49*2  : db 2, 14, 7          ; casillas (MIRA_MAPA)

COPIA8_ATRAS:                           ; como COPIA8 (desplaza.asm), con LDD
        rept 8
        ldd
        endr
        jp pe,COPIA8_ATRAS
        ret
FIN_DOBLE:
        assert FIN_DOBLE <= SOMBRA2
        savebin "doble_F480.bin",DOBLE,FIN_DOBLE-DOBLE
