# Convierte la salida de z80dasm en un fuente legible para sjasmplus
import re

def posprocesa(nb, NOMBRES, COMENT, salida_f, prefijo='L'):
    crudo = open(f'crudo_{nb}.asm').read().split('\n')
    bloques = {}
    for l in open(f'bloques_{nb}.txt'):
        n, _, s, _, e, _, t = l.split()
        bloques[n[:-1] + '_start'] = int(s, 16); bloques[n[:-1] + '_end'] = int(e, 16)
    def addr_of(lbl):
        m = re.fullmatch(r'(?:sub_|l)([0-9a-f]{4})h', lbl)
        if m: return int(m.group(1), 16)
        return bloques.get(lbl)
    def ren(lbl):
        a = addr_of(lbl)
        if a is None: return lbl
        return NOMBRES.get(a) or ('%s%04X' % (prefijo, a))
    tok = re.compile(r'\b(sub_[0-9a-f]{4}h|l[0-9a-f]{4}h|b\d+_(?:start|end))\b')
    # etiquetas referenciadas
    usadas = set()
    for l in crudo:
        if re.match(r'^\S+:\s*$', l) or l.startswith(';'): continue
        for k in tok.findall(l):
            a = addr_of(k)
            if a is not None: usadas.add(a)
    usadas |= set(NOMBRES) | set(COMENT)
    out = []; datos = []
    def vacia():
        nonlocal datos
        i = 0
        imp = lambda b: 32 <= b < 127 and b not in (34, 92)
        while i < len(datos):
            a0 = datos[i][0]; j = i
            while j < len(datos) and imp(datos[j][1]) and j - i < 40: j += 1
            if j - i >= 4:
                s = ''.join(chr(b) for _, b in datos[i:j])
                out.append(f'        db "{s}"'.ljust(56) + f'; {a0:04X}'); i = j; continue
            j = i + 1
            while j < len(datos) and j - i < 16:
                if j + 4 <= len(datos) and all(imp(datos[k][1]) for k in range(j, j + 4)): break
                j += 1
            out.append('        db ' + ','.join('%03Xh' % b for _, b in datos[i:j]).ljust(48) + f'; {a0:04X}')
            i = j
        datos = []
    hechas = set()
    def pon_etiqueta(a):
        if a in hechas or a not in usadas: return
        hechas.add(a); vacia()
        if a in COMENT:
            out.append('')
            for c in COMENT[a].split('\n'): out.append('; ' + c)
        out.append(f'{NOMBRES.get(a) or ("%s%04X" % (prefijo, a))}:')
    for l in crudo:
        if l.startswith(';') or not l.strip() or l.strip().startswith('org'): continue
        if re.match(r'^(\S+):\s*$', l): continue
        m = re.match(r'^\s+defb (0[0-9a-f]{2}h)\s*;([0-9a-f]{4})$', l)
        if m:
            a = int(m.group(2), 16); pon_etiqueta(a)
            datos.append((a, int(m.group(1)[:-1], 16))); continue
        m = re.match(r'^\s+(.*?)\s*;([0-9a-f]{4})$', l)
        if m:
            ins, a = m.group(1).strip(), int(m.group(2), 16)
            pon_etiqueta(a); vacia()
            ins = tok.sub(lambda k: ren(k.group(1)), ins)
            ins = re.sub(r'\s+', ' ', ins, count=1)
            out.append(f'        {ins}'.ljust(40) + f'; {a:04X}')
            continue
        raise SystemExit('línea no reconocida: ' + l)
    vacia()
    falta = sorted(usadas - hechas)
    equs = [f'{NOMBRES.get(a) or ("%s%04X" % (prefijo, a))} equ 0{a:04X}h' for a in falta if not (a in COMENT and a not in NOMBRES)]
    open(salida_f, 'w').write('\n'.join(out) + '\n')
    return equs
