# Genera afina_cpc.asm: la tabla de notas (8866h, 96 periodos) pasada a la afinación del Amstrad.
# El CPC usa la misma tabla con el PSG a 1 MHz; en el MSX (1,7897725 MHz) hay que multiplicar
# cada periodo por 1,7897725 para que suene igual (unos 10 semitonos más grave).
import os, struct
aqui = os.path.dirname(os.path.abspath(__file__))
TABLA = [3822, 3608, 3405, 3214, 3034, 2863, 2703, 2551, 2408, 2273, 2145, 2025, 1911, 1804,
         1703, 1607, 1517, 1432, 1351, 1276, 1204, 1136, 1073, 1012, 956, 902,
         851, 804, 758, 716, 676, 638, 602, 568, 536, 506, 478, 451,
         426, 402, 379, 358, 338, 319, 301, 284, 268, 253, 239, 225,
         213, 201, 190, 179, 169, 159, 150, 142, 134, 127, 119, 113,
         106, 100, 95, 89, 84, 80, 75, 71, 67, 63, 60, 56,
         53, 50, 47, 45, 42, 40, 38, 36, 34, 32, 30, 28,
         27, 25, 24, 22, 21, 20, 19, 18, 17, 16]
assert len(TABLA) == 96
nueva = [min(4095, round(p * 1789772.5 / 1000000)) for p in TABLA]
with open(os.path.join(aqui, '..', 'afina_cpc.asm'), 'w') as f:
    f.write('; Generada por herramientas/afina_cpc.py\n')
    f.write('; Tabla de notas con la afinación del Amstrad CPC (la que Gominolas da por buena):\n')
    f.write('; periodo MSX = periodo original x 1,7897725 (PSG a 1 MHz en el CPC).\n')
    f.write('; Las 9 más graves (La#0-Fa#1) no caben en 12 bits y se quedan en 4095; la canción no baja de 804.\n')
    f.write('        org 08866h\n')
    for i in range(0, 96, 12):
        f.write('        dw ' + ','.join(str(p) for p in nueva[i:i + 12]) + '\n')
    f.write('        assert $ == TABLA_ORDENES_MUSICA\n')
