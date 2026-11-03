; =============================================================================
;  Scroll por hardware en MSX2+ y turbo R (V9958), solo en la ROM (pedido de
;  araubi, 28-10: «que en MSX2+ y TurboR detecte y aproveche su scroll suave
;  tanto horizontal como vertical»; eligió los dos finos y el marcador
;  aproximado).
;
;  El juego sigue dibujando en su búfer como siempre. Aquí cada banco de VRAM
;  es una pantalla virtual de 32x32 caracteres (256x256 píxeles) en SCREEN 2:
;  tabla de nombres fija (carácter = fila x 32 + columna, con los cuatro
;  «tercios»), así que la celda (fila v, columna c) del mundo va siempre en
;  base + v x 256 + c x 8 (patrones) y + 2000h (color), con v = fila del
;  mundo mod 32 y c = columna del mundo mod 32. El VDP enseña la ventana con
;  R#23 (vertical) y R#26/R#27 (horizontal), al píxel. Al moverse solo hay
;  que mandar las filas o columnas que entran y lo que cambió (SPAN_N/P/PP).
;
;  - Dos bancos (A: 08000h-0FFFFh, B: 10000h-17FFFh) con copia oculta: se
;    vuelca en el que no se ve y la interrupción cambia los registros.
;    El juego escribe en el banco «maestro» (00000h, SCREEN 2 normal): menús,
;    textos y el marcador. Si escribe patrones en el área de juego
;    (QUITA_NT) se enseña el maestro hasta el próximo volcado.
;  - El marcador también se mueve con el scroll: se recompone desplazado
;    FX píxeles (los colores, aproximados: uno por línea de 8 píxeles) en una
;    caché de VRAM y se coloca con HMMM (comandos del VDP con el bit CMD de
;    R#25) en las columnas que tocan, bajando FINO líneas.
;  - R#25 = MSK: las 8 primeras columnas de la pantalla no se ven, así que el
;    área de juego tiene 184 píxeles de ancho (antes 192).
;  - La cámara horizontal va al píxel (FX, 0-8).
;
;  El cargador de la ROM copia esto a F000h y F800h (SOMBRA, que aquí no se
;  usa) y cambia la llamada de REINICIA_VDP; lo demás se engancha en
;  MODO_INICIAL_HW.
; =============================================================================
HW_1            equ 0F000h              ; F000h-F47Fh
HW_2            equ 0F800h              ; F800h-FC7Fh

; Variables (0325h-03E7h, tras las de parcial.asm y antorcha.asm)
FX              equ ANT_PAT + 2         ; píxeles de más a la derecha (0-8)
VISTA_M         equ FX + 1              ; <> 0: se ve el banco maestro
H_WR0           equ VISTA_M + 1         ; fila del mundo de la ventana (mod 256)
H_WC0           equ H_WR0 + 1           ; columna
H_NP            equ H_WC0 + 1           ; columnas de juego enteras (23 o 24)
H_BM            equ H_NP + 1            ; columna virtual de la primera del marcador
H_F             equ H_BM + 1            ; FX and 7
H_R23           equ H_F + 1             ; R#23
H_S             equ H_R23 + 1           ; píxel virtual de la x = 0 de la pantalla
H_MIX           equ H_S + 1             ; <> 0: hay que rehacer la columna mezclada
H_PAG           equ H_MIX + 1           ; R#14 de los patrones del banco oculto (2 o 4)
H_DB            equ H_PAG + 1           ; y (G7) de sus patrones (128 o 256), 2 bytes
H_TODO          equ H_DB + 2            ; <> 0: volcado entero
H_CAMBIA        equ H_TODO + 1          ; <> 0: hay que recolocar el marcador
N_IZQ           equ H_CAMBIA + 1        ; columnas nuevas por la izquierda
N_DER           equ N_IZQ + 1           ; primera nueva por la derecha (FFh: ninguna)
MGEN            equ N_DER + 1           ; cambia con el marcador
CV              equ MGEN + 1            ; 8 (FX and 7): tercios de la caché ya hechos
ST_A            equ CV + 8              ; por banco: vale, fila, columna, NP, BM, F, R23, MGEN
ST_B            equ ST_A + 8
REGS_V          equ ST_B + 8            ; registros del banco por enseñar (11 pares)
CMDB            equ REGS_V + 22         ; R#32-R#46
T_V             equ CMDB + 15           ; DIBUJA / TRAMO
T_VC            equ T_V + 1
T_N             equ T_VC + 1
H_FILA          equ T_N + 1
T_PP            equ H_FILA + 1          ; 2
T_CP            equ T_PP + 2            ; 2
P_T             equ T_CP + 2            ; COLOCA: patrones (0) o color (1)
P_K             equ P_T + 1
P_FIN           equ P_K + 1
P_CMD           equ P_FIN + 1
P_SX            equ P_CMD + 1           ; 2: caché
P_SY            equ P_SX + 2            ; 2
P_ROW           equ P_SY + 2
FIN_HWV         equ P_ROW + 1
        assert FIN_HWV <= 003E8h
TP              equ 00048h              ; una fila del marcador maestro: 64 de patrones
TC              equ 00090h              ; (con 8 ceros antes y después) y 64 de color
        assert TC + 64 <= 00100h

; -----------------------------------------------------------------------------
        org HW_1

; INICIA_VDP (REINICIA_VDP: el cargador cambia allí CALL INICIA_FILAS por este)
MODO_INICIAL_HW:
        call INICIA_FILAS
        ld a,i
        push af
        di
        ld hl,PARCHES
.p:     ld e,(hl)
        inc hl
        ld d,(hl)
        inc hl
        ld a,d
        or e
        jr z,.hecho
        ld a,0C3h                       ; JP
        ld (de),a
        inc de
        ldi
        ldi
        jr .p
.hecho: ld hl,0
        ld (VDP_DIR_CUENTA.r14),hl      ; NOP / NOP: R#14 en cada dirección
        ld a,1
        ld (MODO),a                     ; COPIA_PP y MARCA_HUD, como la copia oculta
        ld (VISTA_M),a
        ld (SALTO),a                    ; la cámara sigue cada paso
        xor a
        ld (B_VISTA),a
        ld (R14_ACT),a
        ld (CAMBIO),a
        ld (DENTRO),a
        ld (FX),a
        call INVALIDA_HW
        ld hl,CV
        ld b,8
.cv:    ld (hl),a
        inc hl
        djnz .cv
        ld hl,CACHE_SPR                 ; los patrones de los sprites, otra vez
        ld b,2*MAX_FIG*8
.spr:   ld (hl),0FFh
        inc hl
        djnz .spr
        ld a,3                          ; tabla de nombres fija en los dos bancos
        call NT_HW
        ld a,5
        call NT_HW
        call MAESTRO
        pop af
        pop hl                          ; no sigue REINICIA_VDP (copia oculta de MSX2)
        ret po
        ei
        ret

; A = R#14 de la segunda página del banco: carácter = fila x 32 + columna (los
; cuatro tercios)
NT_HW:  ld hl,0
        call VESC
        ld c,4
.t:     xor a
.c:     out (098h),a
        push af
        pop af
        inc a
        jr nz,.c
        dec c
        jr nz,.t
        ret

INVALIDA_HW:
        xor a
        ld (ST_A),a
        ld (ST_B),a
        ret

; Registros del banco maestro (SCREEN 2 normal, sin scroll; CMD para los comandos)
MAESTRO:
        ld hl,REGS_M
        ld bc,22 * 256 + 099h
        otir
        ret
REGS_M: db 006h,082h, 0FFh,083h, 003h,084h, 036h,085h, 007h,086h, 000h,08Ah, 000h,08Bh
        db 000h,097h, 000h,09Ah, 000h,09Bh, 040h,099h
REGS_A: db 030h,082h, 0FFh,083h, 013h,084h, 0B6h,085h, 01Fh,086h, 002h,08Ah, 001h,08Bh
REGS_B: db 050h,082h, 0FFh,083h, 023h,084h, 0B6h,085h, 02Fh,086h, 004h,08Ah, 002h,08Bh

PARCHES:
        dw ENTRA, ENTRA_HW
        dw SALE_DOBLE, SALE_HW
        dw ENSENA, ENSENA_HW
        dw QUITA_NT, QUITA_HW
        dw PREPARA_FILAS, HW_PREPARA
        dw VOLCADO_FILAS, HW_VOLCADO
        dw ATR_FINAL, ATR_FINAL_HW
        dw CAMARA.h_hw, CAMARA_H_HW
        dw 0

; A = R#14, HL = dirección (A13-A0): escritura / lectura. Si el VDP tenía
; pendiente la interrupción de imagen, la cuenta (como VDP_DIR_CUENTA).
VESC:   push af
        in a,(099h)
        rlca
        call c,CUENTA_CUADRO
        pop af
        out (099h),a
        ld a,08Eh
        out (099h),a
        ld a,l
        out (099h),a
        ld a,h
        and 03Fh
        or 040h
        out (099h),a
        ret
VLEE:   push af
        in a,(099h)
        rlca
        call c,CUENTA_CUADRO
        pop af
        out (099h),a
        ld a,08Eh
        out (099h),a
        ld a,l
        out (099h),a
        ld a,h
        and 03Fh
        out (099h),a
        ret

; Espera a que el VDP acabe el comando en curso (S#2, CE)
ESPERA_CE:
        ld a,2
        out (099h),a
        ld a,08Fh
        out (099h),a
.w:     in a,(099h)
        rrca
        jr c,.w
        xor a
        out (099h),a
        ld a,08Fh
        out (099h),a
        ret

; Manda CMDB (R#32-R#46) cuando el VDP acaba el anterior
COMANDO:
        call ESPERA_CE
        ld a,32
        out (099h),a
        ld a,091h                       ; R#17 = 32, con incremento
        out (099h),a
        ld hl,CMDB
        ld bc,15 * 256 + 09Bh
        otir
        ret

; En lugar de ENTRA (doble.asm), al empezar un volcado. A = EN_JUEGO.
ENTRA_HW:
        ld b,a
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
.ya:    ld a,(VRAM_OK)                  ; fondo nuevo o algo escrito en el área de
        or a                            ; juego: los dos bancos, enteros
        call z,INVALIDA_HW
        ld a,(ENTERO)
        or a
        call nz,INVALIDA_HW
        ld a,(B_VISTA)                  ; los sprites, en la segunda página del oculto
        or a
        ld a,5
        jr z,.r
        ld a,3
.r:     ld (R14_ACT),a
        ret

; En lugar de PREPARA_FILAS: ventana, límite de los sprites y sprites.
; Devuelve HL = primera línea del búfer que se ve (no se usa).
HW_PREPARA:
        ld a,(L8E31)                    ; columna del mundo: (L8E31 - 1) x 4 + L8E42
        dec a
        add a,a
        add a,a
        ld hl,L8E42
        add a,(hl)
        ld (H_WC0),a
        ld e,a
        ld a,(L8E32)                    ; fila del mundo
        dec a
        add a,a
        add a,a
        ld hl,L8E43
        add a,(hl)
        ld (H_WR0),a
        and 31                          ; R#23 = fila x 8 + FINO
        add a,a
        add a,a
        add a,a
        ld hl,FINO
        add a,(hl)
        ld (H_R23),a
        ld a,(FX)
        ld c,a
        and 7
        ld (H_F),a
        ld a,c
        rrca
        rrca
        rrca
        and 1
        add a,23
        ld (H_NP),a                     ; 23, o 24 con FX = 8
        add a,e                         ; la primera columna del marcador
        and 31
        ld (H_BM),a
        ld a,e                          ; x = 0 de la pantalla: columna x 8 + FX - 8
        add a,a
        add a,a
        add a,a
        add a,c
        sub 8
        ld (H_S),a
        ld a,184                        ; los sprites, hasta x = 184 + FX
        add a,c
        ld (CALCULA_MASCARAS.lim1+1),a
        ld (CALCULA_MASCARAS.dentro+1),a
        ld (CALCULA_MASCARAS.lim3+1),a
        ld (ATRIBUTO.lim+1),a
        sub 15
        ld (ANTORCHA_SPR.lim+1),a
        jp PREPARA_SPRITES

; Sprites al final: X + 8 - FX (la pantalla empieza 8 - FX píxeles antes) e
; Y + R#23 (el scroll vertical del VDP también mueve los sprites; D0h acabaría
; la lista: un píxel más abajo)
ATR_FINAL_HW:
        ld hl,01B00h
        call VDP_DIRECCION
        ld a,(H_R23)
        ld d,a
        ld a,(FX)
        neg
        add a,8
        ld c,a
        ld a,(N_NUEVA)
        or a
        jr z,.d0
        ld b,a
        ld hl,ATR_NUEVA
.spr:   ld a,(hl)
        add a,d
        cp 0D0h
        jr nz,.y
        inc a
.y:     out (098h),a
        inc l
        ld a,(hl)
        add a,c
        out (098h),a
        inc l
        ld a,(hl)
        out (098h),a
        inc l
        ld a,(hl)
        out (098h),a
        inc l
        djnz .spr
.d0:    ld a,(N_NUEVA)
        cp 32
        ret nc
        ld a,0D0h
        out (098h),a
        ret

; En lugar de SALE_DOBLE: espera a los comandos y pide enseñar el banco
SALE_HW:
        ld a,(DENTRO)
        or a
        ret z
        xor a
        ld (DENTRO),a
        call ESPERA_CE
        ld a,(B_VISTA)
        xor 1
        ld (B_VISTA),a
        ld hl,REGS_A
        jr z,.a
        ld hl,REGS_B
.a:     ld de,REGS_V
        ld bc,14
        ldir
        ex de,hl
        ld (hl),0                       ; R#25: CMD y MSK (luego R#23, R#26 y R#27)
        inc hl
        ld (hl),099h
        inc hl
        ld a,(H_R23)
        ld (hl),a
        inc hl
        ld (hl),097h
        inc hl
        ld a,(H_S)                      ; R#26 = (s + 7) / 8, R#27 = R#26 x 8 - s
        ld c,a
        add a,7
        rra                             ; (con el acarreo: s + 7 puede pasar de 255)
        rrca
        rrca
        and 01Fh
        ld (hl),a
        inc hl
        ld (hl),09Ah
        inc hl
        add a,a
        add a,a
        add a,a
        sub c
        and 7
        ld (hl),a
        inc hl
        ld (hl),09Bh
        ld a,042h
        ld (REGS_V+14),a
        xor a
        ld (R14_ACT),a
        call R14                        ; lo que escriba el juego, al maestro
        xor a
        ld (VISTA_M),a
        inc a
        ld (CAMBIO),a
        ret

; En la interrupción (CUENTA_CUADRO), en lugar de ENSENA
ENSENA_HW:
        xor a
        ld (CAMBIO),a
        push bc
        push hl
        ld hl,REGS_V
        ld bc,22 * 256 + 099h
        otir
        pop hl
        pop bc
        ret

; En lugar de QUITA_NT: se enseña el maestro (textos). Conserva HL.
QUITA_HW:
        ld a,(VISTA_M)
        or a
        ret nz
        push hl
        ld a,1
        ld (VISTA_M),a
        xor a
        ld (CAMBIO),a
        ld (VRAM_OK),a
        call INVALIDA_HW
        ld a,i
        push af
        di
        call MAESTRO
        pop af
        pop hl
        ret po
        ei
        ret

; En lugar de LD A,(V_JUG_X) en CAMARA: la cámara horizontal, al píxel. El
; jugador (24 de ancho) se queda entre 56 y 104 del área de juego (184).
CAMARA_H_HW:
        ld hl,FX
        ld a,(V_JUG_X)
        sub (hl)                        ; x en pantalla - 8 (hasta 184: sin signo)
        jr c,.izq
        cp 104 + 1
        jr c,.no_der
        sub 104
        add a,(hl)                      ; FX nuevo
.der:   cp 8
        jr c,.pon
        ld c,a
        ld a,(L8E44)                    ; ¿puede ir a la derecha? (como SCROLL)
        sub 5
        ld b,a
        ld a,(L8E31)
        sub b
        ld b,a
        ld a,(L8E42)
        or b
        ld a,c
        jr z,.tope
        ld a,1
        ld (L8E30),a
        push bc
        call SCROLL
        pop bc
        ld a,c
        sub 8
        jr .der
.tope:  ld a,8                          ; al final del mapa: hasta la última columna
        jr .pon
.no_der:
        cp 56
        ret nc
.izq:   sub 56
        add a,(hl)                      ; FX nuevo (negativo: a la izquierda)
.izq2:  bit 7,a
        jr z,.pon
        ld c,a
        ld a,(L8E31)
        dec a
        ld b,a
        ld a,(L8E42)
        or b
        jr z,.cero
        ld a,0FFh
        ld (L8E30),a
        push bc
        call SCROLL
        pop bc
        ld a,c
        add a,8
        jr .izq2
.cero:  xor a
.pon:   ld (FX),a
        ret

; Tercio C del marcador maestro desplazado H_F píxeles: 8 filas de 9 columnas
; (72 bytes de patrones y 72 de color) en la caché
COMPONE:
        xor a
        ld hl,TP - 8
        ld b,8
.z1:    ld (hl),a
        inc l
        djnz .z1
        ld hl,TP + 64
        ld b,8
.z2:    ld (hl),a
        inc l
        djnz .z2
        ld a,c
        add a,a
        add a,a
        add a,a
        ld (H_FILA),a
        ld b,8
.fila:  push bc
        ld a,(H_FILA)                   ; la fila del maestro: columnas 24-31
        and 7
        add a,a
        add a,a
        add a,a
        ld (T_VC),a                     ; fila x 8
        ld a,(H_FILA)
        and 018h
        add a,6
        ld (T_V),a                      ; tercio x 8 + 6: x 0800h + 0600h
        ld c,0
        ld de,TP
.col:   ld a,(T_VC)                     ; columna C: + C x 64
        ld l,a
        ld a,c
        rrca
        rrca
        ld b,a
        and 0C0h
        or l
        ld l,a
        ld a,b
        and 1
        ld b,a
        ld a,(T_V)
        add a,b
        ld h,a
        push hl
        xor a
        call VLEE
        ld b,8
.lp:    in a,(098h)
        ld (de),a
        inc e
        djnz .lp
        pop hl
        ld a,h
        add a,020h
        ld h,a
        ld a,e
        add a,TC - TP - 8
        ld e,a
        xor a
        call VLEE
        ld b,8
.lc:    in a,(098h)
        ld (de),a
        inc e
        djnz .lc
        ld a,e
        sub TC - TP
        ld e,a
        inc c
        ld a,c
        cp 8
        jr c,.col
        xor a                           ; patrones: (izquierda x 256 + derecha) >> F
        ld (P_T),a
        call BLOQUE
        call DIR_CACHE
        ld hl,TP - 8
        ld b,72
.pb:    ld d,(hl)
        ld a,l
        add a,8
        ld l,a
        ld e,(hl)
        sub 7
        ld l,a
        ld a,(H_F)
        ld c,a
        inc c
        ld a,e
        jr .s1
.s:     srl d
        rra
.s1:    dec c
        jr nz,.s
        out (098h),a
        djnz .pb
        ld a,1                          ; color: el de la derecha, o el de la
        ld (P_T),a                      ; izquierda si F > 4
        call BLOQUE
        call DIR_CACHE
        ld a,(H_F)
        cp 5
        jr c,.cr
        ld hl,TC
        ld b,8
        call OUTB
        ld hl,TC
        ld b,64
        call OUTB
        jr .sig
.cr:    ld hl,TC
        ld b,64
        call OUTB
        ld hl,TC + 56
        ld b,8
        call OUTB
.sig:   ld hl,H_FILA
        inc (hl)
        pop bc
        dec b
        jp nz,.fila
        ret

OUTB:   ld a,(hl)
        out (098h),a
        inc hl
        nop
        djnz OUTB
        ret

; Escritura en la fila H_FILA del bloque de la caché (L = x, DE = y)
DIR_CACHE:
        ld a,(H_FILA)
        add a,e
        ld e,a
        jr nc,.c
        inc d
.c:     ld a,e
        rlca
        rlca
        and 3
        ld c,a
        ld a,d
        add a,a
        add a,a
        or c
        ld h,e
        jp VESC

FIN_HW1:
        assert FIN_HW1 <= 0F480h

; -----------------------------------------------------------------------------
        org HW_2

; En lugar de VOLCADO_FILAS: el banco oculto
HW_VOLCADO:
        push ix
        push iy
        ld a,(B_VISTA)
        or a
        ld ix,ST_B                      ; se vuelca en el otro
        ld a,4
        ld hl,256
        jr z,.b
        ld ix,ST_A
        ld a,2
        ld hl,128
.b:     ld (H_PAG),a
        ld (H_DB),hl
        call MIRA_MARCAS
        ; ¿entero?
        ld a,(ix+0)
        or a
        jr z,.todo
        ld a,(H_WR0)
        sub (ix+1)
        add a,24
        cp 49
        jr nc,.todo
        ld a,(H_WC0)
        sub (ix+2)
        add a,23
        cp 47
        jr nc,.todo
        xor a
        jr .t
.todo:  ld a,1
.t:     ld (H_TODO),a
        ld (H_MIX),a
        ; ¿marcador en otro sitio?
        or a
        jr nz,.cambia
        ld a,(H_BM)
        cp (ix+4)
        jr nz,.cambia
        ld a,(H_F)
        cp (ix+5)
        jr nz,.cambia
        ld a,(H_R23)
        cp (ix+6)
        jr nz,.cambia
        ld a,(MGEN)
        cp (ix+7)
        jr z,.igual
.cambia:
        ld a,1
        ld (H_MIX),a
        db 0FEh                         ; (CP n: salta el XOR A)
.igual: xor a
        ld (H_CAMBIA),a
        ; columnas nuevas: N_IZQ por la izquierda, desde N_DER por la derecha
        xor a
        ld (N_IZQ),a
        dec a
        ld (N_DER),a
        ld a,(H_TODO)
        or a
        jr nz,.filas
        ld a,(ix+2)                     ; vieja - nueva
        ld hl,H_WC0
        sub (hl)
        jr z,.der
        jp m,.der
        ld b,a
        ld a,(H_NP)
        cp b
        jr c,.izq
        ld a,b
.izq:   ld (N_IZQ),a
.der:   ld a,(ix+2)                     ; fin viejo - columna nueva
        add a,(ix+3)
        ld hl,H_WC0
        sub (hl)
        ld b,a
        ld a,(H_NP)
        sub b
        jr z,.filas
        jp m,.filas
        ld a,b
        bit 7,a
        jr z,.d
        xor a
.d:     ld (N_DER),a
.filas: ld c,0
.fila:  ld a,c
        ld (H_FILA),a
        ld a,(H_TODO)
        or a
        jr nz,.entera
        ld a,(H_WR0)                    ; ¿la fila ya estaba?
        add a,c
        sub (ix+1)
        cp 25
        jr nc,.entera
        call RANGO_HW                   ; lo que cambió
        jr c,.nuevas
        ld a,d
        cp 23
        jr c,.mix
        ld a,1
        ld (H_MIX),a
.mix:   ld a,(H_NP)
        dec a
        cp d
        jr nc,.dd
        ld d,a
.dd:    ld a,d
        cp e
        call nc,DIBUJA
.nuevas:
        ld a,(N_IZQ)
        or a
        jr z,.nd
        dec a
        ld d,a
        ld e,0
        call DIBUJA
.nd:    ld a,(N_DER)
        cp 0FFh
        jr z,.sig
        ld e,a
        jr .hasta
.entera:
        ld e,0
.hasta: ld a,(H_NP)
        dec a
        ld d,a
        call DIBUJA
.sig:   ld a,(H_FILA)
        inc a
        ld c,a
        cp 25
        jr c,.fila
        ; marcador
        ld a,(H_CAMBIA)
        or a
        call nz,COLOCA_MARCADOR
        ld a,(H_F)
        or a
        jr z,.fin
        ld a,(H_MIX)
        or a
        call nz,MEZCLA
.fin:   ld a,1                          ; estado del banco
        ld (ix+0),a
        ld a,(H_WR0)
        ld (ix+1),a
        ld a,(H_WC0)
        ld (ix+2),a
        ld a,(H_NP)
        ld (ix+3),a
        ld a,(H_BM)
        ld (ix+4),a
        ld a,(H_F)
        ld (ix+5),a
        ld a,(H_R23)
        ld (ix+6),a
        ld a,(MGEN)
        ld (ix+7),a
        pop iy
        pop ix
        ret

; Columnas de la ventana que cambiaron en la fila C (SPAN_N, SPAN_P y
; SPAN_PP): E = primera, D = última (sin recortar a la derecha). CF: ninguna.
RANGO_HW:
        ld a,(WIN_R)
        add a,c
        add a,a
        ld l,a
        ld h,high SPAN_N
        ld de,000FFh
        call RANGO_FILA.une             ; SPAN_N
        set 7,l
        call RANGO_FILA.une             ; SPAN_P
        ld h,high SPAN_PP
        call RANGO_FILA.une             ; SPAN_PP
        ld a,(WIN_C)
        ld b,a
        ld a,d
        sub b
        ret c
        ld d,a
        ld a,e
        sub b
        jr nc,.e
        xor a
.e:     ld e,a
        ld a,d
        cp e
        ret

; Fila (H_FILA) de la ventana, columnas E-D: patrones y color del búfer en el
; banco oculto. Si pasa de la columna virtual 31, en dos trozos.
DIBUJA: ld a,d
        sub e
        inc a
        ld b,a                          ; caracteres
        ld a,(H_WC0)
        add a,e
        and 31                          ; columna virtual
        ld c,a
        add a,b
        cp 33
        jr c,TRAMO                      ; cabe
        push de
        push bc
        ld a,32
        sub c
        ld b,a
        ld a,c
        call TRAMO
        pop bc
        pop de
        ld a,32
        sub c                           ; los que fueron
        add a,e
        ld e,a
        ld a,c
        add a,b
        sub 32
        ld b,a
        xor a
        ld c,a
TRAMO:  ld a,c
        ld (T_VC),a
        ld a,b
        ld (T_N),a
        call PUNTEROS
        ; patrones
        ld a,(T_VC)
        add a,a
        add a,a
        add a,a
        ld l,a
        ld a,(T_V)
        ld h,a
        ld a,(H_PAG)
        call VESC
        ld hl,(T_PP)
        ld de,28
        ld a,(T_N)
        ld b,a
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
        ; color
        ld a,(T_VC)
        add a,a
        add a,a
        add a,a
        ld l,a
        ld a,(T_V)
        add a,020h
        ld h,a
        ld a,(H_PAG)
        call VESC
        ld hl,(T_CP)
        ld a,(T_N)
        ld b,a
        ld d,high TABLA_COLOR
.col:   ld e,(hl)
        inc hl
        ld a,(de)
        rept 8
        out (098h),a
        push af
        pop af
        endr
        djnz .col
        ret

; Marcas del marcador (MARCA_HUD): la caché de esos tercios ya no vale
MIRA_MARCAS:
        ld hl,MARCAS
        ld bc,48 * 256
.m:     ld a,(hl)
        or a
        jr z,.s
        ld (hl),0
        ld a,l
        sub low MARCAS
        cp 24
        jr c,.p
        sub 24
.p:     and 018h                        ; tercio x 8
        rrca
        rrca
        rrca
        inc a
        ld e,a
        ld a,080h
.bit:   rlca
        dec e
        jr nz,.bit
        or c
        ld c,a
.s:     inc hl
        djnz .m
        ld a,c
        or a
        ret z
        cpl
        ld hl,CV
        ld b,8
.cv:    ld e,a
        and (hl)
        ld (hl),a
        ld a,e
        inc hl
        djnz .cv
        ld hl,MGEN
        inc (hl)
        ret


; Fila H_FILA de la ventana, columna E: T_V = fila virtual, T_PP y T_CP = búfer
; de patrones (primera línea) y de color
PUNTEROS:
        ld a,(H_FILA)
        ld c,a
        ld a,(H_WR0)
        add a,c
        and 31
        ld (T_V),a
        ld d,0                          ; DE = columna
        ld l,c
        ld h,d
        add hl,hl
        add hl,hl
        push hl
        add hl,hl
        add hl,hl
        add hl,hl
        pop bc
        or a
        sbc hl,bc                       ; fila x 28
        push hl
        add hl,de
        ld bc,(V_PTR_BUFCOLOR)
        add hl,bc
        ld (T_CP),hl
        pop hl
        add hl,hl
        add hl,hl
        add hl,hl                       ; fila x 224
        add hl,de
        ld bc,(V_PTR_BUFER)
        add hl,bc
        ld (T_PP),hl
        ret

; El marcador en su sitio (H_BM, H_R23) desde la caché de FX and 7: columnas
; 1-8 si hay columna mezclada (MEZCLA hace la 0), si no 0-7
COLOCA_MARCADOR:
        call ASEGURA
        ld a,0D0h                       ; HMMM
        ld (P_CMD),a
        xor a
        call .tipo                      ; patrones
        ld a,1                          ; color
.tipo:  ld (P_T),a
        ld a,(H_F)
        or a
        jr z,.k
        ld a,1
.k:     ld b,8
.col:   push bc
        push af
        call COL
        pop af
        pop bc
        inc a
        djnz .col
        ret

; Columna A (0-8) de la caché (P_T: patrones o color) en la columna virtual
; H_BM + A, bajando R#23 and 7 líneas: dos rectángulos (las líneas que quedan
; en su fila y las que pasan a la siguiente), cada uno en dos si pasa de la fila
; virtual 31. P_CMD: HMMM, o LMMM con OR (columna mezclada).
COL:    ld (P_K),a
        call BLOQUE
        ld a,(P_K)
        add a,a
        add a,a
        add a,a
        add a,l
        ld l,a
        ld h,0
        ld (P_SX),hl
        ld (P_SY),de
        ld a,(H_BM)
        ld hl,P_K
        add a,(hl)
        and 31
        add a,a
        add a,a
        add a,a
        ld c,a                          ; x de la columna virtual
        ld a,(H_R23)
        and 7
        ld b,a                          ; líneas que baja
        ld hl,(P_SX)
        ld (CMDB),hl
        ld a,c
        add a,b
        ld (CMDB+4),a
        xor a
        ld (CMDB+5),a
        ld (CMDB+9),a
        ld a,8
        sub b
        ld (CMDB+8),a
        ld a,(H_R23)
        rrca
        rrca
        rrca
        and 31
        push bc
        call RECT
        pop bc
        ld a,b
        or a
        ret z
        ld a,(P_SX)                     ; las B últimas líneas, a la fila siguiente
        add a,8
        sub b
        ld (CMDB),a
        ld a,c
        ld (CMDB+4),a
        ld a,b
        ld (CMDB+8),a
        ld a,(H_R23)
        rrca
        rrca
        rrca
        inc a
        and 31
; 24 filas desde la fila virtual A (CMDB: SX, DX y NX ya puestos)
RECT:   ld c,a
        ld hl,(P_SY)
        ld (CMDB+2),hl
        ld a,32
        sub c
        cp 24
        jr c,.parte
        ld a,24
.parte: ld (CMDB+10),a
        ld b,a
        xor a
        ld (CMDB+11),a
        ld (CMDB+12),a
        ld (CMDB+13),a
        ld a,(P_CMD)
        ld (CMDB+14),a
        ld a,c
        call DY
        push bc
        call COMANDO
        pop bc
        ld a,b
        cp 24
        ret z
        ld hl,(P_SY)                    ; lo que pasa de la fila 31, desde la 0
        ld e,b
        ld d,0
        add hl,de
        ld (CMDB+2),hl
        ld a,24
        sub b
        ld (CMDB+10),a
        xor a
        call DY
        jp COMANDO
; CMDB+6 = y (G7) de la fila virtual A del banco oculto (+32 en el color)
DY:     ld hl,(H_DB)
        ld e,a
        ld d,0
        add hl,de
        ld a,(P_T)
        or a
        jr z,.p
        ld e,32
        add hl,de
.p:     ld (CMDB+6),hl
        ret

; Bloque de la caché de (H_F, P_T): L = x (0, 72 o 144), DE = y
BLOQUE: ld a,(H_F)
        add a,a
        ld hl,P_T
        add a,(hl)
        ld c,0
.div:   cp 3
        jr c,.r
        sub 3
        inc c
        jr .div
.r:     ld b,a
        add a,a
        add a,a
        add a,a
        ld l,a
        add a,a
        add a,a
        add a,a
        add a,l
        ld l,a                          ; x 72
        ld a,c
        add a,a
        add a,low BANDAS
        ld e,a
        adc a,high BANDAS
        sub e
        ld d,a
        ex de,hl
        ld a,(hl)
        inc hl
        ld h,(hl)
        ld l,a
        ex de,hl
        ret
BANDAS: dw 64, 88, 384, 408, 432, 456   ; 18 bloques de 72x24 (hacen falta 16)

; La columna virtual H_BM con FX and 7 <> 0: los F píxeles de la izquierda son
; de la columna 23 de la ventana y el resto del marcador (columna 0 de la
; caché, con OR). El color, del que más ocupa.
MEZCLA: ld a,(H_F)
        ld b,a
        xor a
.m:     scf
        rra
        djnz .m
        ld (.y+1),a
        xor a
.fila:  ld (H_FILA),a
        ld e,23
        call PUNTEROS
        ld a,(H_BM)
        add a,a
        add a,a
        add a,a
        ld l,a
        ld a,(T_V)
        ld h,a
        ld a,(H_PAG)
        call VESC
        ld hl,(T_PP)
        ld de,28
        ld b,8
.p:     ld a,(hl)
.y:     and 0
        out (098h),a
        add hl,de
        djnz .p
        ld a,(H_BM)
        add a,a
        add a,a
        add a,a
        ld l,a
        ld a,(T_V)
        add a,020h
        ld h,a
        ld a,(H_PAG)
        call VESC
        ld hl,(T_CP)
        ld e,(hl)
        ld d,high TABLA_COLOR
        ld a,(de)
        ld b,8
.c:     out (098h),a
        push af
        pop af
        djnz .c
        ld a,(H_FILA)
        inc a
        cp 25
        jr c,.fila
        call ASEGURA
        xor a
        ld (P_T),a
        ld a,092h                       ; LMMM con OR
        ld (P_CMD),a
        xor a
        call COL
        ld a,(H_F)
        cp 5
        ret nc                          ; más juego que marcador: su color
        ld a,1
        ld (P_T),a
        ld a,0D0h
        ld (P_CMD),a
        xor a
        jp COL

; Caché de H_F: los tercios que falten
ASEGURA:
        ld a,(H_F)
        add a,low CV
        ld l,a
        ld h,high CV
        ld bc,00100h                    ; B = bit, C = tercio
.t:     ld a,(hl)
        and b
        jr nz,.ya
        push hl
        push bc
        call COMPONE
        pop bc
        pop hl
        ld a,(hl)
        or b
        ld (hl),a
.ya:    sla b
        inc c
        ld a,c
        cp 3
        jr c,.t
        ret

FIN_HW2:
        assert FIN_HW2 <= 0FC80h

        savebin "hw_F000.bin",HW_1,FIN_HW1-HW_1
        savebin "hw_F800.bin",HW_2,FIN_HW2-HW_2
