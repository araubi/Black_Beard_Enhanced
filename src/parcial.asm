; =============================================================================
;  Redibujado parcial y limitador (-DSOLO_CAMBIOS, con -DFIGURAS_SPR).
;
;  El original redibuja cada vuelta las 49 losetas del fondo en el búfer
;  (DIBUJA_FONDO, unos 60 ms) y vuelca al VDP los 576 caracteres del área de
;  juego (unos 40 ms), aunque solo se hayan movido unas pocas figuras. Aquí:
;
;  - Las figuras (96BAh) y los objetos (AC1Fh) apuntan qué caracteres del
;    búfer pisan: por cada fila de caracteres, la primera y la última columna
;    (para restaurar por filas), y por cada columna, la primera y la última
;    fila (para volcar: la tabla de nombres va 0, 8, 16... y en VRAM los
;    caracteres de una columna del tercio van seguidos).
;  - En la vuelta siguiente solo se restauran esos caracteres desde las
;    losetas (RESTAURA), y al VDP solo van los que se restauraron o se pintaron
;    en esta vuelta (TERCIO_PARCIAL).
;  - Se vuelve a hacer todo, como antes, si cambia el trozo de mapa (scroll de
;    loseta, otra sala, el mapa cambió), si la ventana se movió dentro del
;    búfer (scroll de 8 píxeles: solo el volcado) o si algo escribió por su
;    cuenta en el búfer o en el área de juego de la VRAM (transiciones, menús,
;    textos).
;  - El color solo se manda donde cambia: SOMBRA guarda lo que hay en la tabla
;    de color de VRAM (en el scroll, casi todo sigue igual).
;  - Limitador: la interrupción cuenta imágenes (CUADROS) y el volcado no
;    empieza hasta que han pasado LIMITE desde el anterior, así el juego va al
;    mismo ritmo haya más o menos figuras, y el volcado arranca justo tras el
;    barrido vertical. A 60 Hz espera más imágenes (IMAGENES_60) para que el
;    ritmo sea el mismo: el cargador copia en FRECUENCIA el byte 002Bh de la
;    BIOS (bit 7 = 50 Hz). Tras una vuelta lenta (scroll) las siguientes no
;    esperan hasta recuperar como mucho una vuelta.
;
;  Datos en 0100h-03E7h (RAM libre por debajo del búfer, no se carga).
; =============================================================================

        ifndef LIMITE
LIMITE = 5                              ; imágenes por vuelta como mínimo a 50 Hz (100 ms)
        endif
IMAGENES_60 = (LIMITE*6+2)/5              ; lo mismo a 60 Hz (5 -> 6: 100 ms)

SPAN_N          equ 00100h              ; 28 filas x (primera, última columna) de esta vuelta
COL_N           equ SPAN_N + 038h       ; 28 columnas x (primera, última fila)
SPAN_P          equ SPAN_N + 080h       ; lo mismo de la vuelta anterior (lo que se restaura)
COL_P           equ COL_N + 080h
        assert low SPAN_N == 0
TILES           equ 00200h              ; 49 casillas x (dirección de la loseta, revés)
MAPA_COPIA      equ TILES + 49*3        ; 49 casillas x 2 bytes del mapa ya dibujadas
FONDO_OK        equ MAPA_COPIA + 98     ; <> 0: el búfer es fondo + lo apuntado en SPAN_N
VRAM_OK         equ FONDO_OK + 1        ; <> 0: la VRAM tiene lo que había en el búfer
ENTERO          equ VRAM_OK + 1         ; <> 0: esta vuelta se redibujó todo
PARCIAL_YA      equ ENTERO + 1          ; <> 0: el volcado en curso es parcial
CUADROS         equ PARCIAL_YA + 1      ; imágenes desde el último volcado
ULT_MAPA        equ CUADROS + 1         ; V_PTR_MAPA del último fondo
ULT_BUFER       equ ULT_MAPA + 2        ; V_PTR_BUFER del último volcado
WIN_R           equ ULT_BUFER + 2       ; ventana dentro del búfer: filas de caracteres
WIN_C           equ WIN_R + 1           ; y columnas
R_BASE          equ WIN_C + 1           ; RESTAURA_FILA: búfer de la fila
R_TILE          equ R_BASE + 2          ; casillas de la fila de losetas
R_SUB           equ R_TILE + 2          ; línea dentro de la loseta x 4
R_FIN           equ R_SUB + 1           ; última columna
R_FINSEG        equ R_FIN + 1           ; última columna del trozo en curso
T_PTR           equ R_FINSEG + 1        ; TERCIO_PARCIAL: búfer de la fila
T_VRAM          equ T_PTR + 2           ; byte alto de la VRAM de la fila
T_IND           equ T_VRAM + 1          ; COL_N de la columna en curso
T_FILA          equ T_IND + 1           ; primera fila del tercio en el búfer
C_FORZAR        equ T_FILA + 1          ; <> 0: el color de VRAM se tocó desde fuera
C_BASE          equ C_FORZAR + 1        ; SOMBRA del tercio en curso (2 bytes)
C_VRAM          equ C_BASE + 2           ; byte alto de la tabla de color del tercio
C_RAPIDO        equ C_VRAM + 1          ; <> 0: solo cambió FINO (TERCIO_COLOR.rapido)
D_DIR           equ C_RAPIDO + 1        ; AVANZA_LOSETA: 0 abajo, 1 arriba, 2 derecha, 3 izquierda
M_SPAN          equ D_DIR + 1           ; MUEVE_UNO: bytes de una fila a otra y bytes por fila
M_N             equ M_SPAN + 2
M_INI           equ M_N + 2             ; dónde va la loseta nueva
F_MAPA          equ M_INI + 2           ; FIN_LOSETA: casilla del mapa, de TILES
F_TIL           equ F_MAPA + 2          ; y de MAPA_COPIA de la primera loseta nueva
F_COP           equ F_TIL + 2
FIN_DATOS       equ F_COP + 2
SOMBRA          equ 0F000h              ; 3 x 192 atributos ya en VRAM (en el orden de la VRAM)
SOMBRA2         equ SOMBRA + 0800h      ; el de la parte de abajo (TERCIO_COLOR); con la
                                        ; copia oculta, SOMBRA_B y SOMBRA_B + 0800h (doble.asm)
        assert SOMBRA + 576 <= 0F240h
        assert SOMBRA2 + 576 <= 0FC80h  ; F380h-FC7Fh: sin usar en el juego
        assert FIN_DATOS <= 003E8h

        org 0933Ch                      ; bucle principal: CALL DIBUJA_FONDO
        call FONDO_JUEGO
        org 0935Ah                      ; bucle principal: CALL VUELCA_PANTALLA
        call VUELCA_JUEGO
        org DIBUJA_FONDO                ; cualquier redibujado entero
        jp FONDO_ENTERO
        ifndef PORFILAS                    ; (con FILAS, VUELCA_PANTALLA va por filas: filas.asm)
        org VUELCA_TERCIO
        jp TERCIO_ELIGE
        endif
        org 096CAh                      ; figuras: CALL L9B74
        call MARCA_FIGURA
        org 0AC28h                      ; objetos: CALL L9B74
        call MARCA_OBJETO
        org 0A6B6h                      ; transición entre salas: CALL LA767
        call TRANSICION
        org L9F4C
        jp LIMPIA_PARCIAL
        org VDP_ESCRITURA
        jp VDP_ESCRITURA_PARCIAL
        org INT_JUEGO
        jp INT_CUADROS
        org VDP_DIRECCION               ; (DIRECCION_HUECO sigue aquí)
        jp VDP_DIR_CUENTA
        org VUELCA_COLOR.cambia         ; el color se vuelca comparando con lo que ya hay
        jp COLOR_CAMBIA

; -----------------------------------------------------------------------------
        org FIN_SPRITES

FRECUENCIA:
        db 080h                         ; byte 002Bh de la BIOS (LOAD.BIN o la ROM lo copian aquí)

INT_CUADROS:                            ; lo que había en INT_JUEGO, más la cuenta
        di
        push af
        in a,(099h)
        and a
        jp p,LA409                      ; no es el barrido vertical
        call CUENTA_CUADRO
        jp INT_JUEGO+8

TRANSICION:
        call INVALIDA
        jp LA767

LIMPIA_PARCIAL:
        call INVALIDA
        ifdef PORFILAS
        call LIMPIA_PANTALLA            ; todo el color en negro: se puede volver a la
        jp QUITA_NT                     ; tabla de nombres original sin que se vea
        else
        jp LIMPIA_PANTALLA
        endif

FONDO_ENTERO:
        call INVALIDA
        jp EMPIEZA_FONDO

INVALIDA:
        xor a
        ld (FONDO_OK),a
        ld (VRAM_OK),a
        ret

; Si alguien escribe patrones del área de juego (columnas 0-23), la VRAM ya no
; tiene lo que había en el búfer: el próximo volcado será entero. Si escribe su
; color, se repasa todo el color. El marcador (columnas 24-31, dirección con los
; bits 9 y 10 a 1: la tabla va por columnas de 64 bytes) no cuenta: el icono del
; brebaje parpadea ahí en cada vuelta y forzaba el color entero
VDP_ESCRITURA_PARCIAL:
        push af
        ld a,h
        and 006h
        cp 006h
        call z,MARCA_HUD                ; copia oculta: copiarlo luego al otro banco (Z)
        jr z,.color
        ld a,h
        and 03Fh
        cp 018h
        jr nc,.fuera
        ifdef PORFILAS
        call QUITA_NT                   ; textos: con la tabla de nombres original
        endif
        xor a
        ld (VRAM_OK),a
        jr .color
.fuera: sub 020h                        ; tabla de color (2000h-37FFh)
        cp 018h
        jr nc,.color
        ld a,1
        ld (COLOR_SUCIO),a
.color: ld a,i                          ; P/V = interrupciones activas
        push af
        di                              ; la interrupción lee 99h: si llega entre los
        call VDP_DIR_CUENTA             ; dos bytes de la dirección, esta sale mal (L9DB2,
        pop af                          ; el parpadeo del brebaje, escribe con EI y pintaba
        jp po,.fin                      ; de rojo la primera botella del marcador)
        ei
.fin:   pop af
        ret

; Como VDP_DIRECCION, pero si al leer el estado el VDP tenía pendiente la
; interrupción de imagen (que con DI se pierde al leerlo) la cuenta aquí
VDP_DIR_CUENTA:
        in a,(099h)
        rlca
        call c,CUENTA_CUADRO
.r14:   jr .dir                         ; (NOP / NOP con copia oculta: R#14 = banco)
        ld a,(R14_ACT)
        out (099h),a
        ld a,08Eh
        out (099h),a
.dir:   ld a,l
        out (099h),a
        ld a,h
        and 03Fh
        or 040h
        out (099h),a
        ret

CUENTA_CUADRO:
        ld a,(CUADROS)
        inc a
        jr z,.tope
        ld (CUADROS),a
.tope:  ld a,(CAMBIO)                   ; copia oculta: enseñar el otro banco
        or a
        ret z
        jp ENSENA

; WIN_R, WIN_C = posición de la ventana en el búfer, en caracteres
VENTANA:
        push hl
        push de
        ld hl,(V_PTR_BUFER)
        ld de,-003E8h
        add hl,de
        ld de,-224
        xor a
.fila:  add hl,de
        jr nc,.fin
        inc a
        jr .fila
.fin:   ld (WIN_R),a
        ld de,224
        add hl,de
        ld a,l
        ld (WIN_C),a
        pop de
        pop hl
        ret

; En lugar de CALL L9B74 al dibujar una figura: B = y (la de abajo si va del
; revés), C = x, (L8E33) = líneas. Siempre 4 bytes de ancho.
MARCA_FIGURA:
        push bc
        ld a,(L8E33)
        ld e,a
        ld a,(0979Eh)
        rrca                            ; CF = del revés
        ld a,b
        jr nc,.normal
        inc a
        sub e
.normal:
        ld d,a
        ld b,4
        call MARCA_RECT
        pop bc
        jp L9B74

; En lugar de CALL L9B74 al dibujar un objeto: B = y, C = x, y en la pila el HL
; de LAD5B: H = ancho en bytes (se escribe uno más), L = líneas.
MARCA_OBJETO:
        push bc
        ld hl,6                         ; BC, retorno, DE, HL
        add hl,sp
        ld e,(hl)
        inc hl
        ld a,(hl)
        inc a
        ld d,b
        ld b,a
        call MARCA_RECT
        pop bc
        jp L9B74

; D = y de arriba (píxeles de la ventana), E = líneas, C = x, B = ancho en bytes.
; Amplía SPAN_N/COL_N en las filas y columnas de caracteres que toca. Lo que
; pasa de la columna 27 cae (como en L9B74, que no recorta) al principio de la
; línea siguiente del búfer: también se apunta, o una figura pegada al borde
; derecho dejaba restos en la columna 0
MARCA_RECT:
        ld a,e
        or a
        ret z
        call VENTANA
        ld a,(WIN_R)
        add a,a
        add a,a
        add a,a
        add a,d                         ; línea del búfer
        ret c
        cp 224
        ret nc
        ld d,a
        add a,e
        jr c,.tope
        dec a                           ; última línea
        cp 224
        jr c,.lineas
.tope:  ld a,223
.lineas:
        ld e,a                          ; D, E = primera y última línea
        ld a,c
        rrca
        rrca
        rrca
        and 01Fh
        ld c,a
        ld a,(WIN_C)
        add a,c
        ld c,a                          ; C = primera columna (puede pasar de 27)
        add a,b
        dec a
        ld b,a                          ; B = última
        cp 28
        jr c,.sin_vuelta
        push bc
        push de
        sub 28
        ld b,a                          ; columnas 0..B de la línea siguiente
        ld a,c
        sub 28
        jr nc,.desde
        xor a
.desde: ld c,a
        inc d
        ld a,e
        cp 223
        adc a,0                         ; última + 1 sin pasar de 223
        ld e,a
        ld a,d
        cp 224
        call c,MARCA_LINEAS
        pop de
        pop bc
        ld a,27
        cp b
        jr nc,.sin_vuelta
        ld b,a
.sin_vuelta:
        ld a,c
        cp 28
        ret nc
; D, E = primera y última línea del búfer; C, B = primera y última columna
MARCA_LINEAS:
        ld a,e
        rrca
        rrca
        rrca
        and 01Fh
        ld e,a                          ; E = última fila de caracteres
        ld a,d
        rrca
        rrca
        rrca
        and 01Fh
        ld d,a                          ; D = primera
        push bc
        push de
        ld a,d
        add a,a
        ld l,a
        ld h,high SPAN_N
.fila:  ld a,c
        cp (hl)
        jr nc,.min
        ld (hl),a
.min:   inc l
        ld a,b
        cp (hl)
        jr c,.max
        ld (hl),a
.max:   inc l
        ld a,d
        cp e
        jr nc,.columnas
        inc d
        jr .fila
.columnas:
        pop de
        pop bc
        ld a,c
        add a,a
        add a,low COL_N
        ld l,a
.col:   ld a,d
        cp (hl)
        jr nc,.cmin
        ld (hl),a
.cmin:  inc l
        ld a,e
        cp (hl)
        jr c,.cmax
        ld (hl),a
.cmax:  inc l
        ld a,c
        cp b
        ret nc
        inc c
        jr .col

VACIA_N:
        ld hl,SPAN_N
        ld b,56                         ; filas y columnas
.fila:  ld (hl),0FFh                    ; primera > última: fila vacía
        inc l
        ld (hl),0
        inc l
        djnz .fila
        ret

; En el bucle principal, en lugar de DIBUJA_FONDO
FONDO_JUEGO:
        ld a,(FONDO_OK)
        or a
        jr z,.entero
        ld hl,(V_PTR_MAPA)
        ld de,(ULT_MAPA)
        or a
        sbc hl,de
        jp nz,AVANZA_LOSETA            ; el mapa avanzó una loseta (desplaza.asm)
        call MIRA_MAPA
        jr nz,.entero
        call COPIA_PP                   ; copia oculta: lo de hace dos vueltas (doble.asm)
.limpia:
        ld hl,SPAN_N                    ; lo pintado en la vuelta anterior
        ld de,SPAN_P
        ld bc,112
        ldir
        call VACIA_N
        jp RESTAURA
.entero:
        call DIBUJA_FONDO
        call VACIA_N
        call COPIA_MAPA
        ld hl,(V_PTR_MAPA)
        ld (ULT_MAPA),hl
        ld a,1
        ld (FONDO_OK),a
        ld (ENTERO),a
        ret

; Recorre las 7x7 casillas del mapa como DIBUJA_FONDO. Z: iguales a MAPA_COPIA.
MIRA_MAPA:
        call PASO_MAPA
        ld de,MAPA_COPIA
        ld c,7
.fila:  ld b,14
.byte:  ld a,(de)
        cp (hl)
        ret nz
        inc hl
        inc de
        djnz .byte
        push bc
        ld bc,(PASO_FILA)
        add hl,bc
        pop bc
        dec c
        jr nz,.fila
        ret

; HL = V_PTR_MAPA, PASO_FILA = lo que hay que saltar tras cada fila de 7 casillas
PASO_MAPA:
        ld a,(L8E44)
        sub 7
        add a,a
        ld l,a
        ld h,0
        ld (PASO_FILA),hl
        ld hl,(V_PTR_MAPA)
        ret
PASO_FILA:
        dw 0

; Tras un redibujado entero: copia de las casillas y dirección de cada loseta
COPIA_MAPA:
        call PASO_MAPA
        ld de,MAPA_COPIA
        ld c,7
.fila:  ld b,14
.byte:  ld a,(hl)
        ld (de),a
        inc hl
        inc de
        djnz .byte
        push bc
        ld bc,(PASO_FILA)
        add hl,bc
        pop bc
        dec c
        jr nz,.fila
        ld hl,MAPA_COPIA+1
        ld de,TILES
        ld b,49
.loseta:
        push bc
        push hl
        push de
        ld a,(hl)
        push af
        call DIR_LOSETA
        pop af
        pop de
        ex de,hl
        ld (hl),e
        inc hl
        ld (hl),d
        inc hl
        and 080h
        ld (hl),a
        inc hl
        ex de,hl
        pop hl
        inc hl
        inc hl
        pop bc
        djnz .loseta
        ret

; Restaura desde las losetas los caracteres apuntados en SPAN_P
RESTAURA:
        ld c,0
.fila:  ld a,c
        add a,a
        or low SPAN_P
        ld l,a
        ld h,high SPAN_P
        ld d,(hl)
        inc l
        ld a,(hl)
        cp d
        jr c,.vacia
        ld e,a
        push bc
        call RESTAURA_FILA
        pop bc
.vacia: inc c
        ld a,c
        cp 28
        jr c,.fila
        ret

; C = fila de caracteres del búfer, D = primera columna, E = última
RESTAURA_FILA:
        ld a,e
        ld (R_FIN),a
        ld a,c
        and 3
        rrca
        rrca
        rrca                            ; (fila AND 3) x 32: 8 líneas x 4 bytes
        ld (R_SUB),a
        push de
        ld h,c
        ld l,0                          ; fila x 256
        ld e,c
        ld d,0
        ex de,hl
        add hl,hl
        add hl,hl
        add hl,hl
        add hl,hl
        add hl,hl                       ; fila x 32
        ex de,hl
        or a
        sbc hl,de                       ; fila x 224
        ld de,003E8h
        add hl,de
        ld (R_BASE),hl
        ld a,c
        srl a
        srl a                           ; fila de losetas
        ld l,a
        add a,a
        add a,l
        ld l,a                          ; x 3
        add a,a
        add a,a
        add a,a
        sub l                           ; x 21
        ld l,a
        ld h,0
        ld de,TILES
        add hl,de
        ld (R_TILE),hl
        pop de
        ld a,d
.trozo: ld c,a                          ; C = columna; el trozo acaba en la loseta
        or 3
        ld b,a
        ld a,(R_FIN)
        cp b
        jr nc,.fin
        ld b,a
.fin:   ld a,b
        ld (R_FINSEG),a
        sub c
        inc a
        ld e,a                          ; E = bytes por línea
        ld (.bytes+1),a
        ld a,28
        sub e
        ld (.destino+1),a
        ld a,c
        rrca
        rrca
        and 03Fh
        ld l,a
        add a,a
        add a,l                         ; 3 x columna de losetas
        ld hl,(R_TILE)
        add a,l
        ld l,a
        adc a,h
        sub l
        ld h,a
        ld a,(hl)
        inc hl
        ld d,(hl)
        inc hl
        bit 7,(hl)
        ld h,d
        ld l,a                          ; HL = loseta
        ld a,(R_SUB)
        ld d,0
        ld b,4
        jr z,.derecha
        cpl
        add a,125                       ; del revés: línea 31 - n, hacia arriba
        ld d,0FFh
        ld b,-4
.derecha:
        push af
        ld a,b
        sub e
        ld (.origen+1),a
        ld a,d
        ld (.origen+2),a
        pop af
        add a,l
        ld l,a
        adc a,h
        sub l
        ld h,a
        ld a,c
        and 3
        add a,l
        ld l,a
        adc a,h
        sub l
        ld h,a
        push hl
        ld hl,(R_BASE)
        ld a,c
        add a,l
        ld e,a
        adc a,h
        sub e
        ld d,a
        pop hl
        ld a,8
.linea:
.bytes: ld bc,0
        ldir
.origen:
        ld bc,0
        add hl,bc
        ex de,hl
.destino:
        ld bc,0
        add hl,bc
        ex de,hl
        dec a
        jr nz,.linea
        ld a,(R_FINSEG)
        inc a
        ld hl,R_FIN
        cp (hl)
        jp c,.trozo
        jp z,.trozo
        ret

; En el bucle principal, en lugar de VUELCA_PANTALLA: limitador y elección
; entre volcado entero o parcial
VUELCA_JUEGO:
.espera:
        di
        ld a,(FRECUENCIA)
        rlca
        ld b,IMAGENES_60
        jr nc,.limite
        ld b,LIMITE
.limite:
        ld a,(CUADROS)
        sub b
        jr nc,.ya
        ei
        halt
        jr .espera
.ya:    cp b                            ; lo que sobra se descuenta de la vuelta siguiente
        jr c,.resto                     ; (como mucho una vuelta entera): tras una vuelta
        ld a,b                          ; lenta (scroll) las siguientes no esperan y el
.resto: ld (CUADROS),a                  ; ritmo medio no cambia
        call ENTRA_JUEGO                ; copia oculta: estado del banco que no se ve
        call PTR_VISTA                  ; también si cambió FINO (scroll.asm)
        ld de,(ULT_BUFER)
        ld (ULT_BUFER),hl
        or a
        sbc hl,de
        ld a,0
        jr nz,.pon                      ; la ventana se movió: entero
        ld a,(ENTERO)
        or a
        ld a,0
        jr nz,.pon
        ld a,(VRAM_OK)
.pon:   ld (PARCIAL_YA),a
        call VENTANA
        xor a
        ld (ENTERO),a
        call VUELCA_PANTALLA
        xor a
        ld (PARCIAL_YA),a
        inc a
        ld (VRAM_OK),a
        ret

; VUELCA_TERCIO: HL = esquina del tercio en el búfer, DE = 0000h/0800h/1000h.
; Devuelve HL + 24, como VOLCADO_RAPIDO.
        ifndef PORFILAS
TERCIO_ELIGE:
        ld a,(PARCIAL_YA)
        or a
        jp z,VOLCADO_RAPIDO
TERCIO_PARCIAL:
        push hl
        ld (T_PTR),hl
        ld a,d
        ld (T_VRAM),a                   ; D = 0, 8, 16: también la primera fila del tercio
        ld c,a
        ld a,(WIN_R)
        add a,c
        ld (T_FILA),a                   ; primera fila del tercio en el búfer
        ld a,(WIN_C)
        add a,a
        add a,low COL_N
        ld (T_IND),a
        ld b,24                         ; columnas de la ventana
.col:   push bc
        ld a,(T_IND)
        ld l,a
        ld h,high COL_N
        ld e,(hl)                       ; E = primera fila (COL_N)
        inc l
        ld d,(hl)                       ; D = última
        set 7,l                         ; COL_P
        ld a,(hl)
        cp d
        jr c,.m1
        ld d,a
.m1:    dec l
        ld a,(hl)
        cp e
        jr nc,.m2
        ld e,a
.m2:
.pp:    jr .m2b                         ; (JR $+2 con copia oculta: también COL_PP,
        ld h,high COL_PP                ; lo de hace dos vueltas, porque el banco que
        ld a,(hl)                       ; no se ve se volcó hace dos)
        cp e
        jr nc,.p1
        ld e,a
.p1:    inc l
        ld a,(hl)
        cp d
        jr c,.m2b
        ld d,a
.m2b:   ld a,(FINO)                     ; con FINO <> 0 cada fila del búfer sale
        or a                            ; también en la fila de pantalla de encima
        jr z,.m3
        ld a,e
        or a
        jr z,.m3
        dec e
.m3:    ld a,(T_FILA)                   ; a filas del tercio (0-7)
        ld c,a
        ld a,d
        sub c
        jr c,.nada
        cp 8
        jr c,.ult
        ld a,7
.ult:   ld d,a
        ld a,e
        sub c
        jr nc,.pri
        xor a
.pri:   cp d
        jr z,.hay
        jr nc,.nada
.hay:   ld e,a                          ; VRAM: tercio + columna x 64 + fila x 8
        add a,a
        add a,a
        add a,a
        ld l,a
        ld a,24
        sub b                           ; columna de la ventana
        ld c,a
        rrca
        rrca
        and 03Fh
        ld h,a
        ld a,c
        rrca
        rrca
        and 0C0h
        or l
        ld l,a
        ld a,(T_VRAM)
        add a,h
        ld h,a
        call VDP_DIRECCION
        ld a,d
        sub e
        inc a
        ld b,a                          ; caracteres
        ld a,e                          ; búfer: esquina + fila x 224 + columna
        ld hl,(T_PTR)
        ld d,0
        ld e,c
        add hl,de
        ld de,224
        or a
        jr z,.dir
.fila:  add hl,de
        dec a
        jr nz,.fila
.dir:   ld de,28
.car:
        rept 8
        ld a,(hl)
        out (098h),a
        add hl,de
        endr
        djnz .car
.nada:  ld hl,T_IND
        inc (hl)
        inc (hl)
        pop bc
        dec b
        jp nz,.col
        pop hl
        ld de,24
        add hl,de
        ret
        endif
;-----------------------------------------------------------------------------
; Sustituye a la parte final de VUELCA_COLOR (tras decidir que hay que volcar).
; Con el scroll al píxel (scroll.asm) la ventana puede empezar FINO líneas por
; debajo de una fila de caracteres: cada carácter de la pantalla lleva 8-FINO
; líneas del atributo de su fila del búfer (arriba) y FINO de la siguiente
; (abajo). SOMBRA guarda el de arriba de lo que hay en VRAM y SOMBRA2 el de
; abajo (FINO_VRAM: con qué FINO se mandó). Solo se mandan los que cambian.
COLOR_CAMBIA:
        ld de,(ULTIMO_PTR)
        ld (ULTIMO_PTR),hl
        or a
        sbc hl,de                       ; Z: la ventana no se movió
        ld a,(COLOR_NUEVO)              ; bit 0: casillas de otro color; bit 1: FINO
        jr nz,.todo
        and 1
        ld e,a
        ld a,(COLOR_SUCIO)
        or e
        jr nz,.todo
        inc a                           ; solo FINO: se mandan solo los caracteres
        db 0FEh                         ; con distinto color arriba y abajo (CP n)
.todo:  xor a
        ld (C_RAPIDO),a
        ld a,(COLOR_SUCIO)
        ld (C_FORZAR),a
        xor a
        ld (COLOR_SUCIO),a
        ld (COLOR_NUEVO),a
        ld a,(FINO)
        ld (ENVIA_COLOR.abajo+1),a
        ld b,a
        neg
        add a,8
        ld (ENVIA_COLOR.arriba+1),a
        ld a,b                          ; con FINO = 0, abajo = arriba (LD B,C)
        or a
        ld a,041h
        jr z,.p0
        xor a                           ; NOP
.p0:    ld (ENVIA_COLOR.p0),a
        ld a,b                          ; con FINO = 0 el de abajo tiene que ser el de
        or a                            ; arriba (CP A); si no, si FINO cambió, el
        ifdef PORFILAS
        ld a,0BFh                       ; de la fila siguiente (CP B, filas.asm)
        jr z,.c3
        ld a,0B8h
        else
        ld a,0BFh                       ; de la fila siguiente (CP (HL))
        jr z,.c3
        dec a
        endif
.c3:    ld (TERCIO_COLOR.c3),a
        ld hl,0                         ; NOP / NOP: se miran SOMBRA2 = arriba y abajo
        ld a,(FINO_VRAM)                ; = arriba (la VRAM de antes y la de ahora sin
        cp b                            ; caracteres partidos, o FINO cambió)
        jr nz,.modo
        or a
        jr z,.modo
        ld hl,TERCIO_COLOR.salto        ; mismo FINO <> 0: SOMBRA2 = abajo
.modo:  ld (TERCIO_COLOR.modo),hl
        ld a,b
        ld (FINO_VRAM),a
        ifdef PORFILAS                     ; el color va fila a fila con los patrones
        ld a,1                          ; (filas.asm)
        ld (CJ_ACT),a
        ret
        else
        push ix
        ld hl,(ULTIMO_PTR)
        ld a,020h
        call TERCIO_COLOR
        ld a,028h
        call TERCIO_COLOR
        ld a,030h
        call TERCIO_COLOR
        pop ix
        ret
        endif

        ifndef PORFILAS
; HL = búfer de color (esquina del tercio), A = byte alto de la VRAM. Devuelve
; HL en la esquina del tercio siguiente.
TERCIO_COLOR:
        push hl
        ld hl,0                         ; otro tercio: hay que dar la dirección
        ld (C_SIGUE),hl
        pop hl
        push hl
        ld (C_VRAM),a
        sub 020h                        ; 0, 8, 16 -> x 24 = 0, 192, 384
        ld e,a
        ld d,0
        ex de,hl
        add hl,hl
        ld b,h
        ld c,l
        add hl,hl
        add hl,bc                       ; x 6
        add hl,hl
        add hl,hl                       ; x 24
.sombra:
        ld bc,SOMBRA                    ; (o SOMBRA_B, doble.asm)
        add hl,bc
        ld (C_BASE),hl
        ex de,hl                        ; DE = SOMBRA del tercio, HL = búfer
        ld a,(C_FORZAR)
        or a
        call nz,BORRA_SOMBRA
        ld bc,28
        ld a,(C_RAPIDO)
        or a
        jr nz,.rapido
        ld a,24                         ; columnas
.col:   ex af,af'
        push hl
        ld ixl,8                        ; caracteres
.car:   ld a,(hl)                       ; A = arriba
        ex de,hl
        cp (hl)                         ; SOMBRA
        jr nz,.manda_x
        set 3,h                         ; SOMBRA2
.modo:  jr .a                           ; (o NOP / NOP)
        cp (hl)                         ; SOMBRA2 = arriba
        res 3,h
        ex de,hl
        jr nz,.manda_y
        add hl,bc
.c3:    cp (hl)                         ; abajo = arriba (CP A con FINO = 0)
        jr nz,.manda_z
        jr .sig
.a:     ld a,(hl)                       ; SOMBRA2 = abajo
        res 3,h
        ex de,hl
        add hl,bc
        cp (hl)
        jr nz,.manda_z
.sig:   inc de
        dec ixl
        jr nz,.car
        pop hl
        inc hl
        ex af,af'
        dec a
        jr nz,.col
.fin_t: pop hl
        ld bc,224
        add hl,bc
        ret
; Solo cambió FINO: los caracteres con el mismo color arriba y abajo siguen igual
.rapido:
        ld a,24
.rcol:  ex af,af'
        push hl
        ld ixl,8
.rcar:  ld a,(hl)
        add hl,bc
        cp (hl)
        call nz,ENVIA_COLOR             ; HL = abajo, DE = SOMBRA
        inc de
        dec ixl
        jr nz,.rcar
        pop hl
        inc hl
        ex af,af'
        dec a
        jr nz,.rcol
        jr .fin_t
.manda_x:
        ex de,hl
.manda_y:
        add hl,bc
.manda_z:
        call ENVIA_COLOR
        jr .sig
.salto  equ ((.a - .modo - 2) << 8) | 018h ; JR .a
        endif

        ifdef PORFILAS
; Manda un carácter: HL = su sitio en SOMBRA, C = atributo de arriba, B = el de
; abajo (filas.asm). Conserva HL, IX e IY.
ENVIA_COLOR:
.p0:    nop                             ; (LD B,C con FINO = 0)
        ld (hl),c
        set 3,h
        ld (hl),b
        res 3,h
        ld de,(C_SIGUE)                 ; justo detrás del último mandado: la VRAM
        ld a,e                          ; ya está ahí
        cp l
        jr nz,.dir
        ld a,d
        cp h
        jr z,.seguido
.dir:   push hl
        ld de,(C_BASE)                  ; VRAM = tercio + 8 x posición en SOMBRA
        or a
        sbc hl,de
        add hl,hl
        add hl,hl
        add hl,hl
        ld a,(C_VRAM)
        add a,h
        ld h,a
        call VDP_DIRECCION
        pop hl
.seguido:
        ld d,high TABLA_COLOR           ; atributo -> color MSX
        ld e,b
        ld a,(de)
        ld b,a
        ld e,c
        ld a,(de)
.arriba:
        ld c,8                          ; 8 - FINO
.l1:    out (098h),a                    ; 31 ciclos entre escrituras
        dec c
        jr nz,.l1
        ld a,b
.abajo: ld c,0                          ; FINO
        inc c
        dec c
        jr z,.hecho
.l2:    out (098h),a
        dec c
        jr nz,.l2
.hecho: inc hl
        ld (C_SIGUE),hl
        dec hl
        ret
        else
; Manda un carácter: HL = búfer en la fila de abajo, DE = su sitio en SOMBRA.
; Conserva BC, DE y HL.
ENVIA_COLOR:
        push bc
        push hl
        ld b,(hl)                       ; abajo
        ld a,l
        sub 28
        ld l,a
        jr nc,.arr
        dec h
.arr:   ld c,(hl)                       ; arriba
.p0:    nop                             ; (LD B,C con FINO = 0)
        ld a,c
        ld (de),a
        set 3,d
        ld a,b
        ld (de),a
        res 3,d
        ld hl,(C_SIGUE)                 ; justo detrás del último mandado: la VRAM
        or a                            ; ya está ahí
        sbc hl,de
        jr z,.seguido
        push de
        ld hl,(C_BASE)                  ; VRAM = tercio + 8 x posición en SOMBRA
        ex de,hl
        or a
        sbc hl,de
        add hl,hl
        add hl,hl
        add hl,hl
        ld a,(C_VRAM)
        add a,h
        ld h,a
        call VDP_DIRECCION
        pop de
.seguido:
        ld h,d
        ld l,e
        inc hl
        ld (C_SIGUE),hl
        ld h,high TABLA_COLOR           ; atributo -> color MSX
        ld l,b
        ld b,(hl)
        ld l,c
        ld a,(hl)
.arriba:
        ld c,8                          ; 8 - FINO
.l1:    out (098h),a                    ; 31 ciclos entre escrituras
        dec c
        jr nz,.l1
        ld a,b
.abajo: ld c,0                          ; FINO
        inc c
        dec c
        jr z,.hecho
.l2:    out (098h),a
        dec c
        jr nz,.l2
.hecho: pop hl
        pop bc
        ret
        endif
C_SIGUE:
        dw 0                            ; SOMBRA del carácter que sigue al último mandado
FINO_VRAM:
        db 0                            ; FINO con el que se mandó el color

        ifndef PORFILAS
; Con la VRAM de color tocada desde fuera: SOMBRA del tercio (DE) distinta de
; todo el búfer (HL), para que se mande entero. Conserva HL y DE.
BORRA_SOMBRA:
        push hl
        push de
        ld c,24
.col:   push hl
        ld b,8
.car:   ld a,(hl)
        cpl
        ld (de),a
        inc de
        ld a,l
        add a,28
        ld l,a
        jr nc,.mismo
        inc h
.mismo: djnz .car
        pop hl
        inc hl
        dec c
        jr nz,.col
        pop de
        pop hl
        ret
        endif
FIN_PARCIAL:
        assert FIN_PARCIAL <= 0E290h   ; E290h-E293h: TEST.BIN y el cargador de la ROM
