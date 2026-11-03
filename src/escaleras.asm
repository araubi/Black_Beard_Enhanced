; =============================================================================
;  Escaleras sin disparo (pedido de araubi, con -DSOLO_CAMBIOS).
;
;  En el original se sube o se baja pulsando disparo encima de la escalera:
;  L93FC llama a LA9E2, que busca la casilla del jugador en L904Bh y, si es una
;  escalera, cambia de planta (LAA36). Aquí se mira tras cada movimiento y basta
;  con pisarla. Al llegar a la otra planta el jugador está sobre la escalera de
;  vuelta: no se usa hasta que se sale de ella y se vuelve a pisar.
;  El disparo ya no busca escaleras: siempre dispara.
; =============================================================================

        org 0940Eh                      ; L93FC: CALL LA9E2 / JP LAAA0
        nop
        nop
        nop
        org 09395h                      ; MUEVE_JUGADOR: CALL L93CE
        call ESCALERA_AUTO

        org FIN_ANTORCHA
ESCALERA_AUTO:
        call L93CE                      ; el movimiento de siempre
        ld a,0C9h                       ; RET en LAA36: LA9E2 solo mira si hay escalera
        ld (LAA36),a
        call LA9E2                      ; Z: escalera (IX = su entrada); NZ: no
        ld a,0C1h                       ; vuelve el POP BC
        ld (LAA36),a
        ld hl,ESC_ENCIMA
        jr z,.escalera
        ld (hl),0
        ret
.escalera:
        ld a,(hl)
        ld (hl),1
        or a
        ret nz                          ; sigue en la escalera por la que llegó
        xor a                           ; la ventana vuelve a ir alineada a carácter
        ld (FINO),a
        inc a
        ld (COLOR_SUCIO),a
        push hl                         ; LAA36 quita una dirección de la pila
        jp LAA36                        ; cambia de planta y vuelve a MUEVE_JUGADOR
ESC_ENCIMA:
        db 1
FIN_ESCALERAS:
        assert FIN_ESCALERAS <= 0E290h  ; E290h-E293h: TEST.BIN y el cargador de la ROM
