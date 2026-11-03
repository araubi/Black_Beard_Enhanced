# Genera antorcha_datos.asm desde graficos/figuras_retocadas_x4.png (hoja de araubi):
# las 4 antorchas de 16x16 (59E0h, 5A20h, 5A60h, 5AA0h: 2 bytes de máscara y 2 de
# dibujo por línea). Magenta = transparente (bit de máscara a 1), verde = papel
# (va en el sprite de color 8), negro = tinta (no cambia).
import os
from PIL import Image
aqui = os.path.dirname(os.path.abspath(__file__)); F = os.path.dirname(aqui)
im = Image.open(os.path.join(F, 'graficos', 'figuras_retocadas_x4.png')).convert('RGB'); px = im.load(); W, H = im.size
FIG = {(170,40,170): 'T', (0,0,0): 'K', (33,200,66): 'P', (240,240,240): 'P'}
def es(x, y): return 0 <= x < W and 0 <= y < H and px[x, y] in FIG
cel = []
for y in range(H):
    for x in range(W):
        if es(x, y) and not es(x-1, y) and not es(x, y-1):
            w = h = 0
            while es(x+w, y): w += 1
            while es(x, y+h): h += 1
            if w == 64 and h == 64: cel.append((y, x))
cel.sort()
g = open(os.path.join(F, 'graficos', 'graficos_55F0.bin'), 'rb').read()
out = ['; Generado por herramientas/antorcha.py (hoja de araubi, 2026-10-24)', '; Máscaras de las antorchas con el halo recortado']
pat = []
for (y0, x0), A in zip(cel[:4], (0x59E0, 0x5A20, 0x5A60, 0x5AA0)):
    izq, der = [], []
    for r in range(16):
        s = [FIG[px[x0+4*c+1, y0+4*r+1]] for c in range(16)]
        for k in range(2):
            m0 = g[A - 0x55F0 + 4*r + k]; d = g[A - 0x55F0 + 4*r + 2 + k]; m = 0; p = 0
            for c in range(8):
                v = s[8*k + c]; bd = (d >> (7-c)) & 1; bm = (m0 >> (7-c)) & 1
                assert (v == 'K') == bool(bd), (hex(A), r, k, c)
                m |= (1 if v == 'T' else bm if v == 'K' else 0) << (7-c)
                p |= (v == 'P') << (7-c)
            if m != m0: out.append(f'        org 0{A + 4*r + k:04X}h\n        db 0{m:02X}h')
            (izq if k == 0 else der).append(p)
    pat.append(izq + der)
lineas = ['ANT_TABLA:']
for p in pat: lineas.append('        db ' + ','.join(f'0{b:02X}h' for b in p))
open(os.path.join(F, 'antorcha_mascaras.asm'), 'w').write('\n'.join(out) + '\n')
open(os.path.join(F, 'antorcha_tabla.asm'), 'w').write('; Generado por herramientas/antorcha.py: papel de las 4 antorchas (sprite 16x16)\n' + '\n'.join(lineas) + '\n')
print(len(out) - 2, 'bytes de máscara cambiados')
