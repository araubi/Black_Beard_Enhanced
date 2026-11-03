; Generada por herramientas/afina_cpc.py
; Tabla de notas con la afinación del Amstrad CPC (la que Gominolas da por buena):
; periodo MSX = periodo original x 1,7897725 (PSG a 1 MHz en el CPC).
; Las 9 más graves (La#0-Fa#1) no caben en 12 bits y se quedan en 4095; la canción no baja de 804.
        org 08866h
        dw 4095,4095,4095,4095,4095,4095,4095,4095,4095,4068,3839,3624
        dw 3420,3229,3048,2876,2715,2563,2418,2284,2155,2033,1920,1811
        dw 1711,1614,1523,1439,1357,1281,1210,1142,1077,1017,959,906
        dw 856,807,762,719,678,641,605,571,539,508,480,453
        dw 428,403,381,360,340,320,302,285,268,254,240,227
        dw 213,202,190,179,170,159,150,143,134,127,120,113
        dw 107,100,95,89,84,81,75,72,68,64,61,57
        dw 54,50,48,45,43,39,38,36,34,32,30,29
        assert $ == TABLA_ORDENES_MUSICA
