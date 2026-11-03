import json, numpy as np, math, sys
N = ['Do','Do#','Re','Re#','Mi','Fa','Fa#','Sol','Sol#','La','La#','Si']
def nota(f):
    if f <= 0: return None
    m = 69 + 12 * math.log2(f / 440); k = round(m)
    return k, round((m - k) * 100)
def nombre(k): return f'{N[k % 12]}{k // 12 - 1}'
def canales(frames, reloj):
    res = []
    for r in frames:
        fila = []
        for c in range(3):
            tp = r[2*c] | (r[2*c+1] & 15) << 8
            on = not (r[7] >> c & 1) and (r[8+c] & 15) > 0 and tp > 0
            fila.append(nota(reloj / (16 * tp))[0] if on else None)
        res.append(fila)
    return res
def secuencia(col):
    out = []; prev = None
    for k in col:
        if k != prev and k is not None: out.append(k)
        prev = k
    return out
def beeper(cambios, reloj=3500000, hz=50):
    c = np.frombuffer(cambios, dtype=np.int64).reshape(-1, 2)
    t = c[:, 0]; res = []
    fin = t[-1]; paso = reloj // hz; i = 0
    for a in range(0, fin, paso):
        j = np.searchsorted(t, a + paso)
        d = np.diff(t[i:j]); i = j
        if len(d) < 4: res.append(None); continue
        f = reloj / (2 * np.median(d))
        res.append(nota(f)[0] if 30 < f < 5000 else None)
    return res
if __name__ == '__main__':
    msx = canales(json.load(open(sys.argv[1])), 1789772.5)
    for c in range(3):
        s = secuencia([f[c] for f in msx[:3456]])
        print('MSX canal', 'ABC'[c], len(s), ' '.join(nombre(k) for k in s[:40]))
    bz = beeper(open(sys.argv[2], 'rb').read())
    s = secuencia(bz[:3456]); print('ZX beeper', len(s), ' '.join(nombre(k) for k in s[:60]))
