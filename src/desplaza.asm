; =============================================================================
;  Sin tirón al cambiar de loseta (pedido de araubi, 2026-10-27).
;
;  Cada 32 píxeles de scroll el mapa avanza una loseta y DIBUJA_FONDO volvía
;  a montar las 49 del búfer (unos 85 ms en MSX1). Si el mapa se ha movido
;  justo una fila o una columna, aquí se limpia el búfer como en una vuelta
;  normal, se desplaza (patrones, color y CACHE_COLOR: MUEVE_TODO, en
;  doble.asm) y solo se dibujan las 7 losetas nuevas. Si además cambió alguna
;  casilla del mapa (cofre, pasarela...), se redibuja todo como antes.
; =============================================================================

; Desde FONDO_JUEGO: HL = V_PTR_MAPA - ULT_MAPA (<> 0)
AVANZA_LOSETA:
        ld a,(L8E44)
        add a,a
        ld b,a                          ; B = bytes de una fila del mapa
        ld c,2                          ; derecha
        ld a,h
        or a
        ld a,l
        jr z,.pos
        inc h
        jr nz,.no
        inc c                           ; izquierda
        neg
.pos:   cp 2
        jr z,.dir
        dec c
        dec c                           ; abajo / arriba
        cp b
        jr z,.dir
.no:    jp FONDO_JUEGO.entero
.dir:   ld a,c
        ld (D_DIR),a
        call PASO_MAPA                  ; ¿la ventana de antes sigue igual en el mapa?
        ld hl,(ULT_MAPA)
        call MIRA_MAPA+3
        jr nz,.no
        call FONDO_JUEGO.limpia         ; búfer = fondo, como en una vuelta normal
        call MUEVE_TODO                 ; HL = mapa, DE/DE' = búfer, PTR_CACHE: la loseta nueva
        ld a,(D_DIR)
        cp 2
        jr nc,.columna
        ld c,1                          ; una fila de 7 losetas, con el bucle del juego
        call DIBUJA_FONDO+0Dh
        jr .fin
.columna:
        ld b,7
.loseta:
        push bc
        ld a,(hl)                       ; lo mismo que una vuelta de DIBUJA_FONDO
        ld (V_COLOR_LOSETA),a
        inc hl
        ld a,(hl)
        ex af,af'
        push hl
        call DIR_LOSETA
        ex af,af'
        call COPIA_LOSETA
        pop hl
        ld bc,(PASO_FILA)               ; misma columna, fila siguiente
        add hl,bc
        ld bc,13
        add hl,bc
        push hl
        ld hl,0037Ch
        add hl,de
        ex de,hl
        exx
        ld hl,0006Ch
        add hl,de
        ex de,hl
        exx
        ld hl,(PTR_CACHE)
        ld c,18
        add hl,bc
        ld (PTR_CACHE),hl
        pop hl
        pop bc
        djnz .loseta
.fin:   jp FIN_LOSETA
        ifdef PORFILAS
        include "filas.asm"             ; volcado por filas

; Color del jugador (araubi, 28-10): verde claro mientras dura la pócima
; (L8E3C: 100 vueltas de 100 ms, baja de 1 en 1); los 2 últimos segundos
; parpadea entre verde y cian cada 2,5 vueltas (0,25 s) de media.
COLOR_POCIMA    equ 3                   ; verde claro
COLOR_JUGADOR:
        ld a,(L8E3C)
        or a
        ld a,COLOR_JUG
        ret z
        ld a,(L8E3C)
        cp 21
        ld a,COLOR_POCIMA
        ret nc
        push bc
        ld a,(L8E3C)
        add a,a
        ld c,0FFh
.cinco: inc c                           ; C = 2 x vueltas / 5
        sub 5
        jr nc,.cinco
        bit 0,c
        pop bc
        ld a,COLOR_POCIMA
        ret z
        ld a,COLOR_JUG
        ret

; Efecto 5 (el cañón, LB8FC; araubi, 28-10: «un sonido estruendoso»): ruido
; grave en los tres canales y dos tonos muy graves (27 y 36 Hz) con la
; envolvente bajando en 1,6 s (antes: ruido en B, 1,1 s). Lo escribe
; ESCRIBE_PSG: número de registros y pares registro, valor.
EFECTO_CANON:
        db 12
        db 0,0FFh, 1,00Fh               ; A: 27 Hz
        db 2,000h, 3,00Ch               ; B: 36 Hz
        db 6,01Fh                       ; el ruido más grave
        db 8,010h, 9,010h, 10,010h      ; los tres con envolvente
        db 7,004h                       ; tonos A y B, ruido en A, B y C
        db 11,000h, 12,02Ch             ; 256 x 2C00h / 1,79 MHz = 1,6 s
        db 13,000h                      ; bajando y luego silencio
        endif
FIN_AVANZA:
        assert FIN_AVANZA <= 0E270h     ; pila de LOAD.BIN (build.py)

; -----------------------------------------------------------------------------
; En el cargador de cinta que el juego trae copiado y no usa (A5CFh-A66Dh)
        ifdef CINTA_TSX
        error "desplaza.asm usa A5CFh-A66Dh (cinta_tsx.asm)"
        endif
        org CARGADOR_CINTA_SIN_USAR

; Desplaza el búfer de patrones, el de color, CACHE_COLOR, TILES y MAPA_COPIA
; una loseta según D_DIR (MUEVE_UNO, en doble.asm). Devuelve dónde va la fila o
; columna nueva: HL = mapa, DE = patrones, DE' = color, PTR_CACHE; F_MAPA,
; F_TIL y F_COP para RELLENA.
MUEVE_TODO:
        ld ix,T_MUEVE
        call MUEVE_UNO
        push hl                         ; patrones
        call MUEVE_UNO
        push hl                         ; color
        call MUEVE_UNO
        push hl                         ; caché
        call MUEVE_UNO
        ld (F_TIL),hl
        call MUEVE_UNO
        ld (F_COP),hl
        call PASO_MAPA                  ; HL = V_PTR_MAPA
        ld a,(D_DIR)
        ld de,6*2
        cp 2
        jr z,.suma                      ; derecha: columna 6
        or a
        jr nz,.ya                       ; arriba o izquierda: la primera
        ld a,(L8E44)                    ; abajo: fila 6
        ld e,a
        ld b,12
.fila:  add hl,de
        djnz .fila
        jr .ya
.suma:  add hl,de
.ya:    ld (F_MAPA),hl
        pop bc
        ld (PTR_CACHE),bc
        exx
        pop de
        exx
        pop de
        ret

; Las 7 casillas nuevas en MAPA_COPIA y TILES (lo que hace COPIA_MAPA con todas)
FIN_LOSETA:
        ld hl,(F_MAPA)
        ld de,(F_COP)
        ld ix,(F_TIL)
        ld b,7
.casilla:
        push bc
        ld a,(hl)
        ld (de),a
        inc hl
        inc de
        ld a,(hl)
        ld (de),a
        inc de
        push de
        push hl
        call DIR_LOSETA
        ld (ix+0),l
        ld (ix+1),h
        pop hl
        ld a,(hl)
        and 080h
        ld (ix+2),a
        inc hl
        ld bc,3
        add ix,bc
        pop de
        ld a,(D_DIR)
        cp 2
        jr c,.sig
        ld bc,(PASO_FILA)               ; columna: misma columna, fila siguiente
        add hl,bc
        ld bc,12
        add hl,bc
        ex de,hl
        add hl,bc
        ex de,hl
        ld c,18
        add ix,bc
.sig:   pop bc
        djnz .casilla
        ld hl,(V_PTR_MAPA)
        ld (ULT_MAPA),hl
        ld a,1
        ld (ENTERO),a                   ; volcado entero en los dos bancos
        ld (COLOR_NUEVO),a              ; y el color también
        ret
FIN_A5CF:
        assert FIN_A5CF <= 0A66Eh

        org FIN_SPR_COLOR               ; lo que queda de 8000h-83FFh
; BC bytes (múltiplo de 8) con LDI o LDD: 19 ciclos por byte en vez de 23 (MUEVE_UNO)
COPIA8: rept 8
        ldi
        endr
        jp pe,COPIA8
        ret
FIN_8000:
        assert FIN_8000 <= 08400h
