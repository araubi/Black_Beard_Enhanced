; =============================================================================
;  BLACK BEARD (Topo Soft, 1988) - versión MSX en cinta
;  Desensamblado para sjasmplus 1.24.0
;
;  Juego original (c) 1988 Topo Soft, distribuido por Erbe Software.
;    Programa: Carlos Arias Alonso      Gráficos: Roberto Potenciano Acebes
;    Música: César Astudillo (Gominolas) Portada: Alfonso Azpiri
;  (créditos según la ficha de Computer Emuzone; el juego escribe "ACEVES")
;  Este desensamblado es solo para estudio y preservación; el código y los
;  gráficos siguen siendo de sus autores.
;
;  Hecho a partir de "Blackbeard (1988)(Topo Soft)(ES)[RUN'CAS-'].cas".
;  Con -DKIXX sale la edición Kixx (inglés) y con -DACELERA la prueba más rápida;
;  -DACELERA -DCOLOREA añade el área de juego en color (color.asm).
;  -DFIGURAS_SPR (con COLOREA) pone sprites de color 9 bajo los personajes, y
;  -DSOLO_CAMBIOS (con FIGURAS_SPR) redibuja y vuelca solo lo que cambia, con
;  un limitador de LIMITE imágenes por vuelta (parcial.asm).
;  -DMRUBEN (con SOLO_CAMBIOS) pone el marcador recoloreado por araubi.
;  -DAFINA_CPC pone la música con la afinación del Amstrad (afina_cpc.asm).
;  Con -DCINTA_TSX, A5CFh queda como en la cinta real (cargador tipo Spectrum).
;
;  Mapa de memoria (todo RAM, sin BIOS durante el juego):
;    0000-0037  sin usar          0038  JP INT_JUEGO (lo escribe INICIO)
;    0100-030F  con SOLO_CAMBIOS: qué caracteres se tocaron, casillas, banderas
;    03E8-1C67  búfer de patrones del área de juego: 28 bytes x 224 líneas
;    1C68-1F77  búfer de color (se calcula y no se usa nunca)
;    2328-55EF  losetas de 32x32: 144 bytes cada una (128 patrón + 16 color)
;    55F0-7FEF  más gráficos: marcador, mapa, figuras
;    8400-BA7D  código          BA7E-D3FE  datos (figuras, mapas...)
;    D3FF-F37F  libre (salvo LOAD.BIN en D6D8, D900 con sprites o E380 con
;               SOLO_CAMBIOS, que ya no hace falta). Con sprites: TABLA_PAPEL en
;               E600h y atributos en E500h; con SOLO_CAMBIOS, SOMBRA en F000h
;    FDE8       pila
; =============================================================================

        device zxspectrum48             ; solo para tener 64 KB y SAVEBIN

        org 02328h
        incbin "graficos/losetas_2328.bin"
        org 055F0h
        incbin "graficos/graficos_55F0.bin"

        org 08400h
        include "cuerpo_juego.asm"
FIN_JUEGO:

        ifdef CINTA_TSX
        include "cinta_tsx.asm"
        endif

        ifdef KIXX
        include "kixx.asm"
        endif

        ifdef AFINA_CPC
        include "afina_cpc.asm"
        endif

        ifdef ACELERA
        include "acelera.asm"
        ifdef COLOREA
        include "color.asm"
        endif
        ifdef FIGURAS_SPR
        include "sprites.asm"
        include "retoque_figuras.asm"   ; halo de las figuras recortado (hoja de araubi)
        ifdef SOLO_CAMBIOS
        include "parcial.asm"           ; solo se redibuja y vuelca lo que cambia, y limitador
        ifdef MRUBEN
        include "marcador.asm"          ; marcador recoloreado por araubi (herramientas/marcador.py)
FIN_ANTERIOR = FIN_MARCADOR
        else
FIN_ANTERIOR = FIN_PARCIAL
        endif
        include "antorcha.asm"          ; sprite de color 8 bajo la antorcha (herramientas/antorcha.py)
        include "escaleras.asm"         ; escaleras sin pulsar disparo
        include "scroll.asm"            ; scroll que sigue al jugador (vertical al píxel)
        include "idioma.asm"            ; «4.- ESPAÑOL / ENGLISH» en el menú
        include "desplaza.asm"          ; sin tirón al avanzar una loseta
        include "doble.asm"             ; copia oculta de la pantalla en MSX2 (F480h)
        ifdef PORFILAS
        org 0A54Bh                      ; LA545 (partida nueva): el área de juego en negro
        ld e,011h                       ; (era 1Fh: un bloque blanco con el menú hasta el
                                        ; primer volcado; araubi, 28-10)
        org 0A44Eh                      ; LA444: el efecto 5 (cañón), más fuerte
        dw EFECTO_CANON                 ; (desplaza.asm)
        include "filas_alto.asm"        ; volcado por filas, segunda parte (FDE8h)
        ifdef HW
        include "hw.asm"                ; scroll por hardware en MSX2+ (solo la ROM)
        endif
        endif
FIN_BLOQUE = FIN_AVANZA
        else
FIN_BLOQUE = FIN_SPRITES
        endif
        else
FIN_BLOQUE = FIN_ACELERA
        endif
        else
FIN_BLOQUE = FIN_JUEGO
        endif

        savebin "bloque_2328.bin",02328h,032C8h
        ifdef COLOREA
        savebin "bloque_55F0.bin",055F0h,08400h-055F0h
        else
        savebin "bloque_55F0.bin",055F0h,02A00h
        endif
        savebin "bloque_8400.bin",08400h,FIN_BLOQUE-08400h
