# Mapas completos de las 4 plantas de Black Beard con el color de la versión
# coloreada (misma regla que color.asm: papel 0 y 1 de cada loseta sustituidos
# por el color de la casilla, atributo Spectrum -> MSX con TABLA_COLOR).
# Uso: python3 mapas.py carpeta_salida  (tras «python3 build.py color»)
import os, sys
from PIL import Image
F = os.path.join(os.path.dirname(os.path.abspath(__file__)), '..')
leer = lambda n: open(os.path.join(F, n), 'rb').read()
mem = bytearray(65536)
for a, n in ((0x2328, 'bloque_2328.bin'), (0x55F0, 'bloque_55F0.bin'), (0x8400, 'bloque_8400.bin')):
    d = leer(n); mem[a:a + len(d)] = d
TMS = [(0,0,0),(0,0,0),(33,200,66),(94,220,120),(84,85,237),(125,118,252),(212,82,77),(66,235,245),
       (252,85,84),(255,121,120),(212,193,84),(230,206,128),(33,176,59),(201,91,186),(204,204,204),(255,255,255)]
TABLA = mem[0x8000:0x8100]
PLANTAS = [(0xC18E, 36), (0xC69E, 18), (0xC926, 36), (0xCE36, 30)]   # L8E5B y L8E63
FILAS = 18
def loseta(t, col):
    base = 0x2328 + 144 * (t & 127)
    pat = mem[base:base + 128]; atr = mem[base + 128:base + 144]
    b = (col >> 1) & 0x38; c = (col << 3) & 0x38
    im = Image.new('RGB', (32, 32))
    px = im.load()
    for l in range(32):
        sl = 31 - l if t & 128 else l
        for x in range(4):
            a = atr[(sl // 8) * 4 + x]
            if not a & 0x30:
                a = (a & 0xC7) | (b if a & 8 else c)
            m = TABLA[a]; tinta, papel = m >> 4, m & 15
            byte = pat[sl * 4 + x]
            for bit in range(8):
                px[x * 8 + bit, l] = TMS[tinta if byte & (0x80 >> bit) else papel]
    return im
sal = sys.argv[1]; os.makedirs(sal, exist_ok=True)
for n, (dir_, ancho) in enumerate(PLANTAS):
    im = Image.new('RGB', (ancho * 32, FILAS * 32))
    for f in range(FILAS):
        for c in range(ancho):
            p = dir_ + (f * ancho + c) * 2
            im.paste(loseta(mem[p + 1], mem[p]), (c * 32, f * 32))
    im.save(os.path.join(sal, f'black_beard_planta{n + 1}.png'))
    print(n + 1, im.size)
