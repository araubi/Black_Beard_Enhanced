# Nombres y comentarios del bloque principal (8400h)
NOMBRES = {
 0x8400: 'INT_PRESENTACION', 0x8454: 'MUSICA_CANAL', 0x8926: 'TABLA_ORDENES_MUSICA',
 0x886A: 'TABLA_NOTAS_PSG',
 0x8DFE: 'MUSICA_PARA', 0x8E20: 'V_JUG_ESTADO', 0x8E23: 'V_JUG_X', 0x8E24: 'V_JUG_Y',
 0x8E26: 'V_VIDAS', 0x8E36: 'V_COLOR_LOSETA', 0x8E45: 'V_PTR_MAPA', 0x8E47: 'V_PTR_BUFER',
 0x8E49: 'V_PTR_BUFCOLOR', 0x8E53: 'V_SEMILLA', 0x9667: 'V_SP_BASIC',
 0x92AC: 'INICIO', 0x92DA: 'NUEVA_PARTIDA', 0x9317: 'BUCLE_PRINCIPAL', 0x936A: 'TRUCO_VIDAS',
 0x9379: 'MUEVE_JUGADOR', 0x960A: 'RESTA_VIDA', 0x983D: 'DIBUJA_FONDO', 0x987F: 'COPIA_LOSETA',
 0x98B5: 'DIR_LOSETA', 0x98CB: 'SCROLL', 0x9BA7: 'VUELCA_PANTALLA', 0x9BC5: 'VUELCA_COLOR_SIN_USAR',
 0x9BE4: 'VUELCA_TERCIO', 0x9C02: 'VUELCA_TERCIO_COLOR', 0x9C27: 'CONVIERTE_COLOR',
 0x9C5F: 'LEE_CONTROLES', 0x9C7C: 'LEE_TECLA', 0x9C87: 'TABLA_TECLAS', 0x9C95: 'LEE_JOYSTICK',
 0x9CC4: 'COLOR_LOSETA', 0x9CEC: 'COLOR_LOSETA_INV', 0x9D19: 'COPIA_BYTE_COLOR',
 0x9FC7: 'ESPERA_TECLA', 0x9FCD: 'ESPERA_SUELTA', 0x9FD3: 'HAY_TECLA', 0x9FE4: 'MENU',
 0xA286: 'TXT_CREDITOS', 0xA2FA: 'TXT_SIN_MUNICION', 0xA36C: 'TXT_FINAL',
 0xA3CC: 'INT_JUEGO', 0xA40C: 'ESCRIBE_PSG', 0xA41C: 'ARRANCA_MUSICA', 0xA501: 'VDP_ESCRITURA',
 0xA560: 'INICIA_VDP', 0xA5CF: 'CARGADOR_CINTA_SIN_USAR', 0xB00C: 'VUELTA_BASIC_SIN_USAR',
 0x900C: 'TABLA_ENEMIGOS', 0xB228: 'MUEVE_ENEMIGOS',
}
COMENT = {
 0x8400: 'Interrupción de la presentación: música mientras se espera una tecla',
 0x92AC: 'Punto de entrada (LOAD.BIN salta aquí con las 4 páginas en RAM y DI)',
 0x9317: 'Bucle principal. NO espera al barrido vertical: cada vuelta dura lo que tarde\n'
          'todo (unos 190 ms, 9-10 cuadros en PAL). Casi todo se va en DIBUJA_FONDO y VUELCA_PANTALLA.',
 0x9363: 'Restos de una comprobación de STOP (fila 7 bit 4): el salto se cambió por NOP',
 0x936A: 'TRUCO: si la fila 5 del teclado vale 1Bh (U, X, Y y Z pulsadas a la vez)\n'
          'cambia el DEC A de RESTA_VIDA por OR A: vidas infinitas',
 0x960A: 'Este DEC A se convierte en OR A (B7h) con el truco',
 0x983D: 'Redibuja TODO el búfer de juego (7x7 losetas de 32x32) desde el mapa, cada vuelta.\n'
          'Patrones a 03E8h (28 bytes por línea) y color a 1C68h (que nunca se usa)',
 0x987F: 'Copia los 128 bytes de patrón de una loseta (bit 7 = dibujada al revés)',
 0x98B5: 'HL = 2328h + 144 * número de loseta (128 de patrón + 16 de color)',
 0x9BA7: 'Vuelca al VDP 3 tercios de 1536 bytes (24x24 caracteres), unos 47 T por byte',
 0x9BC5: 'CÓDIGO MUERTO: volcado de la tabla de color, detrás del JP. El área de juego\n'
          'quedó en blanco y negro; el color se sigue calculando en COLOR_LOSETA para nada',
 0x9CC4: 'Calcula el color de la loseta en el búfer 1C68h: trabajo perdido (~19 % del tiempo)',
 0x9C87: 'Teclas por defecto: ESPACIO, Q, A, O, P (fila de teclado, máscara)',
 0xA5CF: 'CÓDIGO MUERTO: copia de la rutina de carga de LOAD.BIN. En la cinta real es el\n'
          'cargador tipo Spectrum; el .cas lo cambió por el de la BIOS (ver cinta_tsx.asm)',
 0xB00C: 'CÓDIGO MUERTO: recupera la pila del BASIC (guardada en INICIO) y vuelve',
}
