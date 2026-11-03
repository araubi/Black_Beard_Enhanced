# Genera retoque_figuras.asm desde graficos/figuras_retocadas_x4.png (hoja de araubi):
# verde = papel, negro = tinta, magenta = transparente. Solo cambian bits de máscara.
import json, os, subprocess, sys
aqui = os.path.dirname(os.path.abspath(__file__)); F = os.path.dirname(aqui)
subprocess.run([sys.executable, '-I', os.path.join(aqui, 'leer_hoja_figuras.py'),
                os.path.join(F, 'graficos', 'figuras_retocadas_x4.png'), '/dev/stdout'], check=True, stdout=open(os.path.join(aqui, 'hoja.json'), 'w'))
n = json.load(open(os.path.join(aqui, 'hoja.json'))); os.remove(os.path.join(aqui, 'hoja.json'))
mem = bytearray(65536)
for a, f in ((0x2328, 'losetas_2328.bin'), (0x55F0, 'graficos_55F0.bin')):
    d = open(os.path.join(F, 'graficos', f), 'rb').read(); mem[a:a + len(d)] = d
out = ['; Generado por herramientas/retoque_figuras.py: halo exterior recortado (araubi, 2026-10-24).',
       '; Solo bytes de máscara (1 = transparente) de las figuras de 24x24.']
for a in sorted(n, key=lambda s: int(s, 16)):
    A = int(a, 16)
    for r in range(24):
        for k in range(3):
            m = 0
            for c in range(8):
                p = n[a][r][8 * k + c]; d = (mem[A + 6 * r + 3 + k] >> (7 - c)) & 1
                assert (p == 'K') == bool(d), (a, r, k)
                m |= (p == 'T') << (7 - c)
            if m != mem[A + 6 * r + k]:
                out.append(f'        org 0{A + 6 * r + k:04X}h\n        db 0{m:02X}h')
open(os.path.join(F, 'retoque_figuras.asm'), 'w').write('\n'.join(out) + '\n')
print(len(out) - 2, 'bytes de máscara cambiados')
