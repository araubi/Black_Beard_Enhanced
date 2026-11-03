; =============================================================================
;  Prueba de aceleración (-DACELERA). Dos cambios sin tocar la jugabilidad:
;
;  A) COLOR_LOSETA y COLOR_LOSETA_INV ya no rellenan el búfer de color de
;     1C68h, que nunca llega al VDP (VUELCA_COLOR_SIN_USAR es código muerto).
;     Solo se deja el puntero de patrones (DE) donde lo dejaba el original.
;  B) VUELCA_TERCIO desenrollado: LD A,(HL) / OUT (98h),A / ADD HL,DE son
;     32 ciclos por byte con la espera del MSX (antes 47), por encima de los
;     ~29 que necesita el TMS9918 entre escrituras durante la imagen.
;
;  Medido en openMSX (C-BIOS, PAL): DIBUJA_FONDO pasa de 96 a 61 ms por
;  vuelta y VUELCA_PANTALLA de 64 a 42 ms.
; =============================================================================

        ifndef COLOREA                  ; con -DCOLOREA el color sí se calcula (color.asm)
        org COLOR_LOSETA
        ld hl,0FC84h                    ; DE = DE - 32*28 + 4 (siguiente loseta)
        add hl,de
        ex de,hl
        ret

        org COLOR_LOSETA_INV
        ld hl,00020h                    ; DE = DE + 32 (la inversa ya bajó 32*28)
        add hl,de
        ex de,hl
        ret

        endif

        ifndef PORFILAS
        org VUELCA_TERCIO
        jp VOLCADO_RAPIDO
        endif

        org FIN_JUEGO                   ; D3FFh, RAM libre que antes no se cargaba
        ifndef PORFILAS                    ; (con FILAS se vuelca por filas: filas.asm)
VOLCADO_RAPIDO:
        ex de,hl
        call VDP_ESCRITURA
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
        dec c
        jp nz,.col
        ret
        endif
FIN_ACELERA:

; Texto final: «PORFIN» -> «POR FIN» (pedido de araubi). La línea empieza una
; columna antes y la de espacios que borra debajo pierde uno: mismo tamaño y
; mismo número de elementos (04Fh)
        ifndef KIXX
        org 0A388h
        db 007h,01Fh,"ESTA POR FIN EN TU PODER",009h,01Fh
        db "                      "
        assert $ == 0A3BAh
        else
; Inglés de la Kixx corregido (mismas longitudes): «YOUR AMMUNITION GO DOWN»,
; «GO CAREFULLY», «THE TREASURE MAP IN IN YOURS HANDS»...
        org 0A2FDh
        db "YOU HAVE RUN OUT OF AMMO AND "
        org 0A31Ch
        db "CANNOT OPEN THE OTHER CHESTS"
        org 0A33Ah
        db "  BE MORE CAREFUL NEXT TIME   "
        org 0A36Ch
        db "THE TREASURE MAP IS AT LAST "
        org 0A38Ah
        db "     IN YOUR HANDS     "
        assert $ == 0A3A1h
        endif

; Teclas por defecto del proyecto: cursores y ESPACIO (H sigue siendo la pausa).
; Se pueden redefinir igual que antes con «3.- DEFINE TECLAS».
        org TABLA_TECLAS
        db 0F8h,001h                    ; ESPACIO   (antes ESPACIO)
        db 0F8h,020h                    ; arriba    (antes Q)
        db 0F8h,040h                    ; abajo     (antes A)
        db 0F8h,010h                    ; izquierda (antes O)
        db 0F8h,080h                    ; derecha   (antes P)
