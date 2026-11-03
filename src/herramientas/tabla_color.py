# Genera tabla_color.asm: atributo de Spectrum (FBPPPIII) -> byte de color MSX (tinta<<4 | papel)
import os
NORMAL = [0x1, 0x4, 0x6, 0xD, 0xC, 0x7, 0xA, 0xE]   # negro azul rojo magenta verde cian amarillo blanco
BRILLO = [0x1, 0x5, 0x8, 0xD, 0x3, 0x7, 0xB, 0xF]
t = []
for a in range(256):
    pal = BRILLO if a & 0x40 else NORMAL
    t.append(pal[a & 7] << 4 | pal[(a >> 3) & 7])
with open(os.path.join(os.path.dirname(os.path.abspath(__file__)), '..', 'tabla_color.asm'), 'w') as f:
    f.write('; Generada por herramientas/tabla_color.py: atributo Spectrum -> color MSX\n')
    for i in range(0, 256, 16):
        f.write('        db ' + ','.join('0%02Xh' % b for b in t[i:i + 16]) + '\n')
