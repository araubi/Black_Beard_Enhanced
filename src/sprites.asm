; =============================================================================
;  Sprites de color 9 bajo los personajes (-DFIGURAS_SPR, con -DCOLOREA).
;
;  Las figuras de 24x24 (96BAh) llevan máscara: donde la máscara borra y el
;  dibujo no pinta queda «papel». Ahí se pone un sprite del VDP de color 9
;  (rojo claro; cian, color 7, en el jugador), y la tinta negra sigue viéndose porque esos píxeles no van en
;  el sprite. Cada figura usa 4 sprites de 16x16 (24x24 = 2 x 2), así que hay
;  2 por línea y caben 2 figuras en la misma altura sin que el VDP pierda
;  ninguna. Hasta 8 figuras por vuelta. Los objetos (AC1Fh) no cambian.
;
;  96BAh apunta cada figura que se dibuja (dirección, líneas, y de arriba, x,
;  si va del revés) y, al terminar VUELCA_PANTALLA, se mandan los patrones
;  (3800h, 128 bytes por figura) y los atributos (1B00h). Lo que pasa de la
;  columna 192 se recorta para no pisar el marcador.
;
;  Para que cueste poco:
;  - El papel de las 35 figuras se calcula una vez (TABLA_PAPEL, en RAM libre
;    que no se carga) y de ahí se copian los patrones.
;  - Si una figura es la misma que la vuelta anterior en el mismo hueco
;    (CACHE_SPR), sus patrones ya están en VRAM y no se mandan.
;  - Solo cuando otra figura dibujada después se le monta encima se arma el
;    patrón leyendo el búfer de pantalla (PATRONES_LENTA), para no tapar la
;    tinta de la de delante.
;
;  El código va en lo que sobra tras FIN_ACELERA, en 83xxh y en el código
;  muerto del color original (9BC5h-9C5Eh, 9CC7h-9D18h), que con -DCOLOREA ya
;  no se usa.
; =============================================================================

        ifdef SOLO_CAMBIOS
MAX_FIG         equ 7                   ; el hueco 8 es para la antorcha (antorcha.asm)
        else
MAX_FIG         equ 8
        endif
COLOR_SPR       equ 9                   ; rojo claro
COLOR_JUG       equ 7                   ; cian: el jugador
FIGURAS         equ 02100h              ; MAX_FIG x 6 bytes, RAM libre (no se carga):
        assert low FIGURAS == 0         ; dirección, líneas, y de arriba, x, revés (FFh)
N_FIG           equ FIGURAS + MAX_FIG*6
MASCARAS        equ N_FIG + 1           ; 3 máscaras de columna de la figura en curso
PTR_BUF         equ MASCARAS + 3        ; búfer de pantalla de la fila en curso
PTR_FIG         equ PTR_BUF + 2         ; línea de la figura
PTR_PAT         equ PTR_FIG + 2         ; dónde va la fila en PATRON
PASO            equ PTR_PAT + 2         ; +6 o -6 (del revés)
FILA            equ PASO + 2            ; 2 bytes
CUENTA          equ FILA + 2            ; filas con dibujo de la columna
DIR_VRAM        equ CUENTA + 1          ; patrones del hueco en curso
PATRON          equ 02150h              ; 128 bytes
        assert DIR_VRAM + 2 <= PATRON
CACHE_SPR       equ 02200h              ; 2 bancos x MAX_FIG x 8: dirección, líneas, revés y máscaras
COLOR_FIG       equ CACHE_SPR + 2*MAX_FIG*8 ; color de los sprites de la figura en curso
BANCO           equ COLOR_FIG + 1       ; 0: patrones en 3800h, 1: en 3C00h
N_NUEVA         equ BANCO + 1           ; sprites de la lista nueva / de la anterior
N_VIEJA         equ N_NUEVA + 1
PTR_ATR         equ N_VIEJA + 1
        assert PTR_ATR + 2 <= 02328h
ATR_NUEVA       equ 0E500h              ; atributos de esta vuelta (32 x 4), RAM libre
ATR_VIEJA       equ 0E580h              ; los de la vuelta anterior
TABLA_PAPEL     equ 0E600h              ; 35 figuras x 24 líneas x 3 bytes, RAM libre
        assert TABLA_PAPEL + 35*72 <= 0F378h

        org 096BAh                      ; LD (L8E2B),DE al empezar a dibujar
        call APUNTA_FIGURA
        nop

        org VUELCA_PANTALLA             ; DI / LD HL,(V_PTR_BUFER)
        ifdef PORFILAS
        call ENTRA_VOLCADO              ; copia oculta (doble.asm), luego PREPARA_FILAS
        call VOLCADO_FILAS              ; fila a fila: patrones, color y sprites (filas.asm)
        jp VUELCA_TODO
        else
        ifdef SOLO_CAMBIOS
        call ENTRA_VOLCADO              ; copia oculta (doble.asm), luego PREPARA_SPRITES
        else
        call PREPARA_SPRITES
        endif
        nop
        org VUELCA_PANTALLA+07h         ; tras el primer tercio
        call TERCIO_1
        org VUELCA_PANTALLA+011h        ; tras el segundo
        call TERCIO_2
        org VUELCA_PANTALLA+01Bh
        jp VUELCA_TODO
        endif

        org L9F4C
        jp LIMPIA_PANTALLA

; -----------------------------------------------------------------------------
        org FIN_ACELERA
; DE = figura (ya recortada), L = líneas, B = y, C = x. Del revés (979Eh = FFh)
; B es la línea de abajo y se dibuja hacia arriba.
APUNTA_FIGURA:
        ld (L8E2B),de
        ld a,(N_FIG)
        cp MAX_FIG
        ret nc
        push de
        push hl
        ld h,a
        inc a
        ld (N_FIG),a
        ld a,h
        add a,a
        add a,h
        add a,a                         ; L = 6*n (FIGURAS está alineada a 256)
        ld l,a
        ld h,high FIGURAS
        ld (hl),e
        inc hl
        ld (hl),d
        inc hl
        pop de                          ; E = líneas
        push de
        ld (hl),e
        inc hl
        ld a,(0979Eh)
        rrca                            ; CF = del revés
        ld a,b
        jr nc,.normal
        inc a                           ; y de arriba = y - (líneas - 1)
        sub e
.normal:
        ld (hl),a
        inc hl
        ld (hl),c
        inc hl
        ld a,(0979Eh)
        ld (hl),a
        pop hl
        pop de
        ret

; Antes de volcar la pantalla: patrones de las figuras de esta vuelta en el banco
; que no se ve y lista de atributos nueva en ATR_NUEVA. Los atributos se mandan
; tras cada tercio (TERCIO_1, TERCIO_2, VUELCA_TODO): en lo ya volcado, los
; sprites nuevos; en lo que aún no, los de la vuelta anterior. Así no se ven
; descolocados mientras dura el volcado (unos 40 ms, 2 o 3 imágenes).
PREPARA_SPRITES:
        di
        push ix
        push iy
        ld a,(TABLA_LISTA)
        or a
        call z,PREPARA_TABLA
        ld ix,FIGURAS
        ld iy,CACHE_SPR
        ld hl,03800h
        ld a,(BANCO)
        or a
        jr z,.banco
        ld iy,CACHE_SPR+MAX_FIG*8
        ld h,03Ch
.banco: ld a,(N_FIG)
        or a
        jr z,.atributos
        ld b,a
.patron:
        push bc
        push hl
        call UNA_FIGURA
        pop hl
        ld de,128
        add hl,de
        ld de,6
        add ix,de
        ld de,8
        add iy,de
        pop bc
        djnz .patron
.atributos:
        ld hl,ATR_NUEVA
        ld (PTR_ATR),hl
        ld a,(N_FIG)
        add a,a
        add a,a
        ld (N_NUEVA),a
        ld a,(N_FIG)                    ; de la última figura a la primera: si hay más
        or a                            ; de 4 sprites en una línea, el VDP se queda con
        jr z,.fin                       ; los de las que se dibujaron después (delante)
        ld b,a
        dec a
        ld e,a
        add a,a
        add a,e
        add a,a
        ld e,a
        ld d,0
        ld ix,FIGURAS
        add ix,de
        ld a,(BANCO)
        rrca                            ; 80h en el banco 1
        ld c,a
        ld a,b
        dec a
        add a,a
        add a,a
        add a,a
        add a,a
        add a,c
        ld c,a                          ; número del primer patrón de la figura
.atr:   push bc
        ifdef SOLO_CAMBIOS
        call Y_FIGURA                   ; y - FINO (scroll.asm)
        else
        ld a,(ix+3)
        endif
        dec a                           ; el VDP pinta el sprite una línea más abajo
        ld d,a
        ld e,(ix+4)
        call COLOR_FIGURA
        call ATRIBUTO                   ; arriba izquierda
        call ATRIBUTO_DERECHA           ; arriba derecha
        ld a,(ix+2)
        cp 17
        ld a,d
        jr nc,.alta
        ld a,0AFh                       ; 16 líneas o menos: la mitad de abajo no hace falta
.alta:  add a,16
        ld d,a
        ld a,e
        sub 16
        ld e,a
        call ATRIBUTO                   ; abajo izquierda
        call ATRIBUTO_DERECHA           ; abajo derecha
        ld de,-6
        add ix,de
        ld a,c                          ; patrones de la figura anterior
        sub 32
        pop bc
        ld c,a
        djnz .atr
.fin:
        ifdef SOLO_CAMBIOS
        call ANTORCHA_SPR
        endif
        xor a
        ld (N_FIG),a
        pop iy
        pop ix
        ifdef SOLO_CAMBIOS
        jp PTR_VISTA                    ; la ventana puede bajar FINO líneas (scroll.asm)
        else
        ld hl,(V_PTR_BUFER)
        ret
        endif

TERCIO_1:
        call VUELCA_TERCIO
        push hl
        ld d,64+23
        jr TERCIO_ATR
TERCIO_2:
        call VUELCA_TERCIO
        push hl
        ld d,128+23
TERCIO_ATR:
        ifdef SOLO_CAMBIOS
        call ATR_TERCIO                 ; (con copia oculta, solo al final)
        else
        call ESCRIBE_ATR
        endif
        pop hl
        ret

VUELCA_TODO:
        ifndef PORFILAS                    ; (con FILAS el color va con cada fila)
        call VUELCA_COLOR
        endif
        ifdef PORFILAS
        call ATR_FINAL                  ; cada sprite en su hueco (filas_alto.asm)
        else
        ld d,255                        ; todo volcado: solo la lista nueva
        call ESCRIBE_ATR
        endif
        ld a,(N_NUEVA)                  ; la nueva pasa a ser la anterior
        ld (N_VIEJA),a
        add a,a
        add a,a
        jr z,.vacia
        ld c,a
        ld b,0
        ld hl,ATR_NUEVA
        ld de,ATR_VIEJA
        ldir
.vacia: ld a,(BANCO)
        xor 1
        ld (BANCO),a
        ifdef SOLO_CAMBIOS
        jp SALE_DOBLE                   ; copia oculta: se enseña en la próxima imagen
        else
        ret
        endif
FIN_VUELCA:

; Atributos en VRAM: los sprites nuevos de la zona ya volcada y los anteriores
; del resto. D = límite: un sprite es de la zona volcada si Y+32 < D (su centro
; está por encima). Y = BFh (escondido) no se manda. Hasta 32 sprites.
ESCRIBE_ATR:
        ld hl,01B00h
        call VDP_DIRECCION
        ld b,32
        ld hl,ATR_NUEVA
        ld a,(N_NUEVA)
        ld e,0
        call .lista
        ld hl,ATR_VIEJA
        ld a,(N_VIEJA)
        ld e,0FFh
        call .lista
        ld a,0D0h
        out (098h),a
        ret
.lista: ld c,a
        or a
        ret z
.sig:   ld a,(hl)
        cp 0BFh
        jr z,.salta
        add a,32
        cp d
        sbc a,a                         ; FFh si está en la zona volcada
        xor e
        jr z,.salta
        ld a,b
        or a
        jr z,.salta
        dec b
        push bc
        ld b,4
.byte:  ld a,(hl)
        out (098h),a
        inc hl
        djnz .byte
        pop bc
        jr .otro
.salta: inc hl
        inc hl
        inc hl
        inc hl
.otro:  dec c
        jr nz,.sig
        ret

; Patrones de la figura IX en el hueco de VRAM HL. B = figuras que quedan (con esta).
UNA_FIGURA:
        ld (DIR_VRAM),hl
        call SOLAPA
        push af
        call CALCULA_MASCARAS
        pop af
        jr c,.lenta                     ; otra figura se le monta encima
        call BUSCA_TABLA
        jr c,.lenta                     ; no es de las figuras de la tabla
        push hl
        push ix                         ; ¿lo mismo que la vuelta anterior?
        pop hl
        push iy
        pop de
        ld bc,0300h
        call COPIA_CLAVE                ; dirección y líneas
        inc hl
        inc hl
        inc b
        call COPIA_CLAVE                ; revés
        ld hl,MASCARAS
        ld b,3
        call COPIA_CLAVE                ; recorte por la derecha
        pop hl
        ld a,c
        or a
        ret z                           ; los patrones ya están en VRAM
        push hl
        call DIRECCION_HUECO
        pop hl
        jp RAPIDA
.lenta: ld (iy+2),0FFh                  ; la próxima vez hay que mandarlo
        call DIRECCION_HUECO
        push iy
        ld iy,MASCARAS
        call PATRONES_LENTA
        pop iy
        ret

; Copia B bytes de HL a DE; C se incrementa si alguno cambia
COPIA_CLAVE:
        ld a,(de)
        cp (hl)
        jr z,.igual
        ld a,(hl)
        ld (de),a
        inc c
.igual: inc hl
        inc de
        djnz COPIA_CLAVE
        ret

; CF si alguna de las B-1 figuras siguientes (dibujadas después) está a menos de 24 píxeles
SOLAPA:
        push ix
        pop hl
        ld de,6
        or a
.sig:   dec b
        ret z
        add hl,de
        push hl
        inc hl
        inc hl
        inc hl
        ld a,(ix+3)
        sub (hl)
        jr nc,.p1
        neg
.p1:    cp 24
        jr nc,.lejos
        inc hl
        ld a,(ix+4)
        sub (hl)
        jr nc,.p2
        neg
.p2:    cp 24
.lejos: pop hl
        ret c
        jr .sig

; Máscaras de las 3 columnas de bytes: nada a partir de x = 192
CALCULA_MASCARAS:
        ld hl,MASCARAS
        ld e,(ix+4)
        ld b,3
.masc:  ld a,e
.lim1:  cp 192                          ; (los tres 192: hw.asm los cambia en MSX2+)
        jr c,.dentro
        xor a
        jr .pon
.dentro:
        ld a,192
        sub e                           ; píxeles que quedan hasta 192
        cp 8
        ld a,0FFh
        jr nc,.pon
.lim3:  ld a,192
        sub e
        ld d,a
        ld a,0FFh
.corre: srl a
        dec d
        jr nz,.corre
        cpl                             ; los D bits de la izquierda
.pon:   ld (hl),a
        inc hl
        ld a,e
        add a,8
        jr nc,.sig
        ld a,0FFh
.sig:   ld e,a
        djnz .masc
        ret

; Camino lento: el patrón sale del búfer de pantalla. Un píxel va en el sprite
; si la figura deja ahí papel y el búfer sigue a 0, así no tapa la tinta de lo
; que se dibujó encima después. IY = MASCARAS, VRAM ya apuntando al hueco.
PATRONES_LENTA:
        ld hl,PATRON
        ld (PTR_PAT),hl
        ld de,PATRON+1
        ld bc,127
        ld (hl),b
        ldir
        ld a,(ix+4)                     ; desplazamiento dentro del byte del búfer
        and 7
        cpl
        add a,8
        ld (DESPLAZA.salto+1),a         ; JR que se salta 7 - (x AND 7) ADD HL,HL
        ld b,(ix+3)
        ld c,(ix+4)
        call L9B74                      ; HL = búfer en (y, x)
        ld (PTR_BUF),hl
        ld l,(ix+0)
        ld h,(ix+1)
        ld de,6
        bit 0,(ix+5)
        jr z,.paso
        ld a,(ix+2)                     ; del revés: se empieza por la última línea
        dec a
        ld e,a
        add a,a
        add a,e
        add a,a
        ld e,a
        add hl,de
        ld de,-6
.paso:  ld (PASO),de
        ld (PTR_FIG),hl
        ld b,(ix+2)
        ld c,0                          ; fila
.fila:  push bc
        ld hl,(PTR_BUF)
        ld de,(PTR_FIG)
        call BYTE_SPR
        and (iy+0)
        ld (FILA),a
        call BYTE_SPR
        and (iy+1)
        ld (FILA+1),a
        call BYTE_SPR
        and (iy+2)
        ld hl,(PTR_PAT)                 ; columna 2 en +32, 1 en +16, 0 en +0
        ld de,32
        add hl,de
        ld (hl),a
        ld de,-16
        add hl,de
        ld a,(FILA+1)
        ld (hl),a
        add hl,de
        ld a,(FILA)
        ld (hl),a
        inc hl
        pop bc
        inc c
        ld a,c
        cp 16                           ; de la fila 16 en adelante: patrones de abajo
        jr nz,.mitad
        ld de,48
        add hl,de
.mitad: ld (PTR_PAT),hl
        ld hl,(PTR_BUF)
        ld de,28
        add hl,de
        ld (PTR_BUF),hl
        ld hl,(PTR_FIG)
        ld de,(PASO)
        add hl,de
        ld (PTR_FIG),hl
        djnz .fila
        ld hl,PATRON
        ld bc,128*256+098h
.out:   outi
        nop                             ; 32 ciclos entre escrituras
        jr nz,.out
        ret

; HL -> búfer, DE -> máscara de la figura. A = papel de la figura que sigue a 0
; en el búfer. HL y DE avanzan un byte.
BYTE_SPR:
        call DESPLAZA
        ex de,hl
        or (hl)                         ; máscara
        inc hl
        inc hl
        inc hl
        or (hl)                         ; dibujo
        dec hl
        dec hl
        cpl
        ex de,hl
        ret

; A = 8 píxeles del búfer desde (HL) + (x AND 7) bits. HL avanza un byte.
DESPLAZA:
        ld a,(hl)
        inc hl
        push hl
        ld l,(hl)
        ld h,a
.salto: jr $+2
        add hl,hl
        add hl,hl
        add hl,hl
        add hl,hl
        add hl,hl
        add hl,hl
        add hl,hl
        ld a,h
        pop hl
        ret
; Una vez (y tras limpiar la pantalla): papel de las figuras y caché vacía
PREPARA_TABLA:
        xor a
        ld (BANCO),a
        ld (N_VIEJA),a
        inc a
        ld (TABLA_LISTA),a
        ld hl,CACHE_SPR
        ld de,CACHE_SPR+1
        ld bc,2*MAX_FIG*8-1
        ld (hl),0FFh
        ldir
        ld hl,04608h
        ld de,TABLA_PAPEL
        ld c,28
        call .figuras
        ld hl,055F0h
        ld c,7
.figuras:
        ld b,24
.linea: push bc
        ld b,3
.byte:  ld a,(hl)                       ; ni máscara ni dibujo
        inc hl
        inc hl
        inc hl
        or (hl)
        dec hl
        dec hl
        cpl
        ld (de),a
        inc de
        djnz .byte
        inc hl
        inc hl
        inc hl
        pop bc
        djnz .linea
        dec c
        jr nz,.figuras
        ret
; L9F4C limpia la pantalla (menú, nueva partida): antes se esconden los sprites
LIMPIA_PANTALLA:
        di
        ld hl,01B00h
        call VDP_DIRECCION
        ld a,0D0h
        out (098h),a
        xor a
        ld (N_FIG),a
        ld (N_VIEJA),a
        ld (TABLA_LISTA),a              ; los patrones se vuelven a mandar
        ld hl,06000h
        jp L9F4C+3
FIN_SPRITES:
        assert FIN_SPRITES <= 0D900h    ; con -DFIGURAS_SPR LOAD.BIN va en D900h (build.py)

; -----------------------------------------------------------------------------
        org 09BC5h                      ; VUELCA_COLOR_SIN_USAR, muerto
; HL = papel de la figura IX en TABLA_PAPEL (desde su primera línea). CF: no está.
BUSCA_TABLA:
        ld l,(ix+0)
        ld h,(ix+1)
        ld de,-055F0h
        add hl,de
        ld a,28                         ; 55F0h: las 7 del segundo grupo
        jr c,.otros
        ld de,055F0h-04608h             ; 4608h: las 28 del primero
        add hl,de
        ccf
        ret c
        xor a
.otros: ld de,-144
        jp BUSCA_TABLA_2
        assert $ <= 09BE4h              ; VUELCA_TERCIO: JP VOLCADO_RAPIDO

        org 09BE7h                      ; resto del VUELCA_TERCIO original y el color muerto
BUSCA_TABLA_2:
        add hl,de
        jr nc,.resto
        inc a
        jr BUSCA_TABLA_2
.resto: cp 35
        ccf
        ret c
        ld de,144
        add hl,de                       ; HL = 6*línea
        srl l
        ex de,hl                        ; DE = 3*línea
        ld l,a
        ld h,0
        add hl,hl
        add hl,hl
        add hl,hl
        ld b,h
        ld c,l
        add hl,hl
        add hl,hl
        add hl,hl
        add hl,bc                       ; 72*figura
        add hl,de
        ld de,TABLA_PAPEL
        add hl,de                       ; CF = 0
        ret

; Patrones de la figura IX desde TABLA_PAPEL (HL). VRAM ya apuntando al hueco.
RAPIDA:
        ld de,3
        bit 0,(ix+5)
        jr z,.normal
        ld a,(ix+2)                     ; del revés: arriba va la última línea
        dec a
        ld b,a
        add a,a
        add a,b
        add a,l
        ld l,a
        adc a,h
        sub l
        ld h,a
        ld de,-3
.normal:
        ld a,(ix+2)
        cp 16
        jr c,.arriba
        ld a,16
.arriba:
        call TRES                       ; filas 0-15 de las 3 columnas
        call CEROS16
        ld b,16
.baja:  add hl,de
        djnz .baja
        ld a,(ix+2)
        sub 16
        jr nc,.abajo
        xor a
.abajo: call TRES                       ; filas 16-31
        jp CEROS16

; HL = primera fila (se conserva), DE = paso, A = filas con dibujo (0-16)
TRES:   push hl
        ld (CUENTA),a
        ld a,(MASCARAS)
        call COLUMNA
        inc hl
        ld a,(MASCARAS+1)
        call COLUMNA
        inc hl
        ld a,(MASCARAS+2)
        call COLUMNA
        pop hl
        ret
        assert $ <= 09C5Fh

; -----------------------------------------------------------------------------
        org 09CC7h                      ; COLOR_LOSETA original, muerto
; 16 bytes de una columna: (CUENTA) filas desde HL con paso DE y máscara A; luego ceros
COLUMNA:
        push hl
        ld c,a
        ld a,(CUENTA)
        or a
        jr z,.ceros
        ld b,a
.f:     ld a,(hl)
        and c
        out (098h),a
        add hl,de
        djnz .f
        ld a,(CUENTA)
.ceros: sub 16
        neg
        pop hl
        ret z
        ld b,a
        jr CEROS
        assert $ <= 09CECh              ; COLOR_LOSETA_INV: JP COLOR_LOSETA_INV_RAPIDO

        org 09CEFh                      ; COLOR_LOSETA_INV original, muerto
CEROS16:
        ld b,16
CEROS:  xor a
.c:     out (098h),a
        nop
        nop
        djnz .c
        ret

; Color de los sprites de la figura IX: cian si es el jugador (misma x e y)
COLOR_FIGURA:
        ld a,(V_JUG_X)
        cp (ix+4)
        ld a,COLOR_SPR
        jr nz,.pon
        ld a,(V_JUG_Y)
        cp (ix+3)
        ld a,COLOR_SPR
        jr nz,.pon
        ifdef PORFILAS
        call COLOR_JUGADOR              ; verde con la pócima (desplaza.asm)
        else
        ld a,COLOR_JUG
        endif
.pon:   ld (COLOR_FIG),a
        ret
        assert $ <= 09D19h              ; COPIA_BYTE_COLOR, que sí se usa

; -----------------------------------------------------------------------------
        org FIN_COLOR                   ; lo que sobra de 8000-83FF
TABLA_LISTA:
        db 0                            ; 0: hay que preparar TABLA_PAPEL

; Atributo del sprite en la lista nueva: D = y, E = x, C = patrón (se suma 4).
; Desde x = 192, escondido.
ATRIBUTO_DERECHA:
        ld a,e
        add a,16
        ld e,a
ATRIBUTO:
        ld hl,(PTR_ATR)
        ld a,e
.lim:   cp 192
        ld a,d
        jr c,.y
        ld a,0BFh                       ; abajo, fuera de la pantalla
.y:     ld (hl),a
        inc hl
        ld (hl),e
        inc hl
        ld (hl),c
        inc hl
        ld a,(COLOR_FIG)
        ld (hl),a
        inc hl
        ld (PTR_ATR),hl
        ld a,c
        add a,4
        ld c,a
        ret

DIRECCION_HUECO:
        ld hl,(DIR_VRAM)
VDP_DIRECCION:
        in a,(099h)
        ld a,l
        out (099h),a
        ld a,h
        or 040h
        out (099h),a
        ret

FIN_SPR_COLOR:
        assert FIN_SPR_COLOR <= 08400h
