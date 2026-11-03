# Mapas completos de las 4 plantas de Black Beard tal como los pinta la cinta
# original (tinta negra, papel blanco).
# Uso: python3 mapas_original.py carpeta_salida cpu.bin
import os, sys
from PIL import Image
F = os.path.join(os.path.dirname(os.path.abspath(__file__)), '..')
leer = lambda n: open(os.path.join(F, n), 'rb').read()
mem = bytearray(open(sys.argv[2], 'rb').read())   # RAM de la cinta original al llegar a 92ACh
TMS = [(0,0,0),(0,0,0),(33,200,66),(94,220,120),(84,85,237),(125,118,252),(212,82,77),(66,235,245),
       (252,85,84),(255,121,120),(212,193,84),(230,206,128),(33,176,59),(201,91,186),(204,204,204),(255,255,255)]
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
            tinta, papel = 1, 15
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
    im.save(os.path.join(sal, f'black_beard_original_planta{n + 1}.png'))
    print(n + 1, im.size)
