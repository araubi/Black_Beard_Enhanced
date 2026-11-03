# Sintetiza a WAV: registros del PSG por cuadro (json) o cambios del beeper (bin)
import sys, json, wave, numpy as np
SR = 44100
VOL = [0, .0078, .011, .0156, .022, .031, .044, .062, .088, .125, .177, .25, .35, .5, .71, 1.0]
def ay(frames, reloj, hz, segs):
    n = int(segs * SR); out = np.zeros(n); spf = SR / hz
    fase = [0.0, 0.0, 0.0]
    for i, r in enumerate(frames[:int(segs * hz)]):
        a0 = int(i * spf); a1 = int((i + 1) * spf); t = np.arange(a1 - a0)
        for c in range(3):
            if r[7] >> c & 1: continue                     # tono apagado
            v = VOL[r[8 + c] & 15]
            tp = r[2 * c] | (r[2 * c + 1] & 15) << 8
            if v == 0 or tp == 0: continue
            f = reloj / (16 * tp)
            if f > SR / 2: continue
            ph = fase[c] + t * f / SR
            out[a0:a1] += v * (np.floor(ph * 2) % 2 * 2 - 1)
            fase[c] = (fase[c] + (a1 - a0) * f / SR) % 1
    return out / 3
def beeper(cambios, segs, reloj=3500000):
    c = np.frombuffer(cambios, dtype=np.int64).reshape(-1, 2)
    n = int(segs * SR); niv = np.zeros(n)
    # nivel por muestra (sin promediar dentro de la muestra: basta para oírlo)
    idx = (c[:, 0] * SR // reloj).astype(np.int64)
    k = 0; cur = 0
    for j in range(len(c)):
        s = min(idx[j], n)
        niv[k:s] = cur; k = s; cur = c[j, 1]
        if k >= n: break
    niv[k:] = cur
    niv = niv - np.convolve(niv, np.ones(2205) / 2205, 'same')        # quita la continua
    return niv * 0.8
def guarda(x, f):
    x = np.clip(x, -1, 1); w = wave.open(f, 'wb'); w.setnchannels(1); w.setsampwidth(2); w.setframerate(SR)
    w.writeframes((x * 30000).astype('<i2').tobytes()); w.close()
if __name__ == '__main__':
    modo, ent, sal, segs = sys.argv[1], sys.argv[2], sys.argv[3], float(sys.argv[4])
    if modo == 'beeper': guarda(beeper(open(ent, 'rb').read(), segs), sal)
    else:
        reloj, hz = float(sys.argv[5]), float(sys.argv[6])
        guarda(ay(json.load(open(ent)), reloj, hz, segs), sal)
