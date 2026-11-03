; =============================================================================
;  Scroll que sigue al jugador (pedido de araubi, con -DSOLO_CAMBIOS).
;
;  El original deja andar al jugador hasta 32 píxeles del borde y entonces
;  desplaza 7 caracteres seguidos (56 píxeles, una vuelta por carácter). Aquí
;  hay un cuadrado de 72x72 (LADO_CAJA) en el centro de la ventana de 192x192: mientras el
;  jugador (24x24) está dentro no se mueve nada, y cuando se sale por un lado
;  la pantalla le sigue.
;
;  - En vertical, al píxel. El búfer de patrones va por líneas (28 bytes cada
;    una) y tiene 4 filas de caracteres de margen, así que basta con empezar a
;    volcar FINO líneas más abajo (0-7). El juego no se entera: sus
;    coordenadas siguen siendo las de la ventana alineada a carácter, y cuando
;    FINO pasaría de 7 se le pide su scroll de un carácter (L8E2F = 1 o -1).
;    En SCREEN 2 el color va por línea, así que con FINO <> 0 cada carácter de
;    la pantalla lleva 8-FINO líneas del color de su fila del búfer y FINO de
;    la siguiente (TERCIO_COLOR, en parcial.asm), sin colores corridos.
;  - En horizontal, de carácter en carácter (8 píxeles): al píxel habría que
;    desplazar bits en todo el volcado y mezclar los colores de dos caracteres.
;
;  La cámara se decide al empezar cada vuelta, con la posición en la que quedó
;  el jugador en la anterior. Las figuras de color (sprites) suben FINO líneas.
; =============================================================================

        ifndef LADO_CAJA
LADO_CAJA = 72                          ; araubi lo bajó de 80 a 72 (había que ir muy al borde)
        endif
CAJA_MIN        equ (192 - LADO_CAJA) / 2
CAJA_MAX        equ CAJA_MIN + LADO_CAJA - 24   ; la x/y más alta con el jugador dentro
        ifndef SALTO_V
SALTO_V = 12                            ; píxeles que tiene que salir para que se mueva
                                        ; (araubi eligió 12: la mitad de vueltas con scroll)
        endif

        org 0932Dh                      ; bucle principal: CALL SCROLL
        call CAMARA
        org 0982Ah                      ; L97C7 (partida nueva): LD (L8E2F),A con A = 0
        call FINO_A_CERO

; El jugador ya no pide el scroll de 7 caracteres al acercarse al borde
        org 0943Ah                      ; derecha: RET C
        ret
        org 09471h                      ; izquierda: RET NC
        ret
        org 094A6h                      ; abajo: RET C
        ret
        org 094DCh                      ; arriba: RET NC
        ret

; Paso de la cubierta 0 a la 1 (L9ADC): el jugador entraba en x = A2h, justo en
; la columna 44h que devuelve a la cubierta 0, así que si no seguía andando
; volvía a la pantalla de la derecha (araubi, 28-10). Ahora entra un paso más
; allá (A2h - 6), igual que en la otra dirección (x = 0Ch, a un paso).
        org 09AF2h                      ; LD A,0A2h
        db 0A2h - 6

        org FIN_ESCALERAS
FINO:
        db 0                            ; líneas que la ventana baja dentro del búfer (0-7)
SALTO:
        db SALTO_V                      ; la ROM pone 1 en un turbo R: con el R800 sobra tiempo

FINO_A_CERO:
        ld (L8E2F),a
        ld (FINO),a
        ld (CACHE_LISTA),a              ; la partida nueva borra el búfer de color:
        ret                             ; la caché de color.asm ya no vale (ladrillos negros
                                        ; en la segunda partida; araubi, 28-10)

; En lugar de CALL SCROLL al empezar la vuelta. La pantalla se mueve cuando el
; jugador sale del cuadrado SALTO_V píxeles o más (o algo, si está quieto), y
; entonces lo deja justo en el borde: con SALTO_V = 1 le sigue en cada paso.
; Cada vuelta en que la pantalla se mueve hay que volcarla entera.
CAMARA:
        call CANON_QUIETO               ; el cañón manda (araubi, 28-10)
        jp nz,SCROLL
        ld a,(SALTO)
        ld b,a
        ld a,(V_JUG_Y)
        ld hl,Y_ANTES
        cp (hl)
        jr nz,.anda
        ld b,1                          ; quieto: la pantalla termina de alcanzarle
.anda:  ld hl,FINO
        sub (hl)                        ; y en pantalla
        jr c,.arriba                    ; negativa: muy por arriba
        ld c,a
        sub CAJA_MAX
        jr c,.no_abajo
        jr z,.no_abajo
        cp b                            ; sale por abajo: ¿lo bastante?
        jr c,.pon_fino
        ld a,(V_JUG_Y)
        sub CAJA_MAX                    ; FINO nuevo (puede pasar de 7)
        ld c,a
.baja:  ld a,c
        cp 8
        jr c,.resto_abajo
        call PUEDE_BAJAR
        jr z,.cero
        ld a,1                          ; un carácter abajo, ya
        ld (L8E2F),a
        push bc
        call SCROLL                     ; (no conserva BC)
        pop bc
        ld a,c
        sub 8
        ld c,a
        jr .baja
.resto_abajo:
        or a
        jr z,.pon
        call PUEDE_BAJAR                ; con FINO <> 0 se ve el principio de la fila
        ld a,c                          ; siguiente: solo si existe
        jr nz,.pon
.cero:  xor a
        jr .pon
.no_abajo:
        ld a,c
        cp CAJA_MIN
        jr nc,.pon_fino
        ld a,CAJA_MIN
        sub c
        cp b                            ; sale por arriba: ¿lo bastante?
        jr c,.pon_fino
.arriba:
        ld a,(V_JUG_Y)
        sub CAJA_MIN                    ; FINO nuevo (negativo: subir caracteres)
        ld c,a
.sube:  bit 7,c
        ld a,c
        jr z,.pon
        ld a,(L8E32)                    ; arriba del todo (fila 1, 0): FINO = 0
        dec a
        ld b,a
        ld a,(L8E43)
        or b
        jr z,.cero
        ld a,0FFh                       ; un carácter arriba, ya
        ld (L8E2F),a
        push bc
        call SCROLL                     ; (no conserva BC)
        pop bc
        ld a,c
        add a,8
        ld c,a
        jr .sube
.pon_fino:
        ld a,(FINO)
.pon:   ld hl,FINO
        cp (hl)
        jr z,.horizontal
        ld (hl),a
        ld a,(COLOR_NUEVO)              ; otras líneas: hay que repasar el color
        or 2                            ; (bit 1: solo los caracteres partidos)
        ld (COLOR_NUEVO),a
.horizontal:
        ld a,(V_JUG_Y)
        ld (Y_ANTES),a
.h_hw:  ld a,(V_JUG_X)                  ; (hw.asm pone aquí un JP en MSX2+)
        cp CAJA_MAX + 1
        jr c,.izquierda
        ld a,1                          ; un carácter a la derecha
        ld (L8E30),a
        jp SCROLL
.izquierda:
        cp CAJA_MIN
        jp nc,SCROLL
        ld a,0FFh
        ld (L8E30),a
        jp SCROLL
Y_ANTES:
        db 0                            ; y del jugador al acabar la cámara anterior

; NZ si la cámara no se puede mover: con la antorcha en la mano junto al cañón
; (LB8FC: celda 78h,12h de la cubierta 0) el juego pide subir hasta arriba del
; todo antes de disparar, y la cámara lo volvía a bajar (no disparaba nunca);
; mientras dura el disparo (L8E58 de 0Eh a 1) la explosión se pinta en un sitio
; fijo de la pantalla.
CANON_QUIETO:
        ld a,(L8E58)
        inc a
        jr z,.mano
        dec a
        ret                             ; 0: normal; 1-0Eh: disparo
.mano:  ld a,(L8E41)
        or a
        jr nz,.no
        call LB9CF                      ; celda del jugador
        ld a,l
        cp 078h
        jr nz,.no
        ld a,h
        cp 012h
        jr nz,.no
        or a                            ; NZ: en el cañón
        ret
.no:    xor a
        ret

; NZ si SCROLL aún puede bajar un carácter (no está en la fila 0Dh, 0)
PUEDE_BAJAR:
        ld a,(L8E32)
        sub 00Dh
        ld b,a
        ld a,(L8E43)
        or b
        ret

; HL = primera línea que se ve en el búfer de patrones: V_PTR_BUFER + 28 x FINO
PTR_VISTA:
        ld a,(FINO)
        ld hl,(V_PTR_BUFER)
        or a
        ret z
        push de
        ld de,28
.linea: add hl,de
        dec a
        jr nz,.linea
        pop de
        ret

; y del sprite de la figura IX en pantalla
Y_FIGURA:
        ld a,(FINO)
        neg
        add a,(ix+3)
        ret

FIN_SCROLL:
        assert FIN_SCROLL <= 0E290h     ; E290h-E293h: TEST.BIN (cinta) y el cargador de la ROM
