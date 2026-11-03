import sys, re, subprocess
sys.path.insert(0, '.')
from z80trace import trace
def generar(binf, org, entradas, nombre):
    d = open(binf, 'rb').read()
    m = bytearray(0x10000); m[org:org+len(d)] = d
    LO, HI = org, org + len(d)
    code, tg = trace(m, [e for e in entradas if LO <= e < HI], LO, HI)
    es = set()
    for a, l in code.items(): es.update(range(a, a + l))
    rangos = []; a = LO
    while a < HI:
        t = a in es; b = a
        while b < HI and (b in es) == t: b += 1
        rangos.append((a, b, t)); a = b
    with open(f'bloques_{nombre}.txt', 'w') as f:
        for i, (a, b, t) in enumerate(rangos):
            f.write(f'b{i}: start 0x{a:04x} end 0x{b:04x} type {"code" if t else "bytedata"}\n')
    subprocess.run(['z80dasm', '-a', '-l', '-g', hex(org), '-b', f'bloques_{nombre}.txt', '-o', f'crudo_{nombre}.asm', binf], stderr=subprocess.DEVNULL, check=True)
    return len(es)
