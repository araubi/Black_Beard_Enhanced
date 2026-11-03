# Saca de TU cinta original de Black Beard (Topo Soft, 1988) los cuatro ficheros
# del juego que este repositorio no incluye, y comprueba que son los buenos.
# Extracts from YOUR original Black Beard tape the four game files this repository
# does not include, and checks them. / このリポジトリに含まれない4つのファイルを、
# 手持ちのオリジナルテープから取り出して確認します。
#
#   python3 tools/extrae_originales.py "Blackbeard (1988)(Topo Soft)(ES)[RUN'CAS-'].cas"
#
# Escribe / writes / 出力: src/basic/TOPO.asc, src/basic/BLACK.asc,
#   src/graficos/losetas_2328.bin, src/graficos/graficos_55F0.bin
import hashlib, os, sys

ESPERADO = {   # SHA-1
    'basic/TOPO.asc': '9950714ccfc17997e78b0e6b381d05af9ffaadcf',
    'basic/BLACK.asc': '05a32c20c16dc88daa86ac68fae443ab6495f717',
    'graficos/losetas_2328.bin': '9183f613044814123e8f39e94609c245c04379fc',
    'graficos/graficos_55F0.bin': 'd166e0fedb1a523fa54d47e2abbb52a5e2f0b398',
}
if len(sys.argv) != 2:
    sys.exit(__doc__ or 'uso: python3 tools/extrae_originales.py cinta.cas')
cas = open(sys.argv[1], 'rb').read()
CAB = bytes.fromhex('1FA6DEBACC137D74')
pos, i = [], 0
while (j := cas.find(CAB, i)) >= 0:
    pos.append(j); i = j + 8
pos.append(len(cas))
bloques = [cas[pos[k] + 8:pos[k + 1]] for k in range(len(pos) - 1)]

def basic(nombre):        # bloque ASCII de BASIC detrás de su cabecera EAh x 10
    for k, b in enumerate(bloques[:-1]):
        if b[:10] == b'\xea' * 10 and b[10:16] == nombre:
            return bloques[k + 1][:256]
    sys.exit(f'no encuentro el BASIC {nombre.decode()} / BASIC {nombre.decode()} not found')

sin_cab = [b for b in bloques if b[:1] == b'\xff']   # bloques del juego: FFh, datos, XOR
if len(sin_cab) < 4:
    sys.exit('no es la cinta de Black Beard / not a Black Beard tape')
datos = {
    'basic/TOPO.asc': basic(b'TOPO  '),
    'basic/BLACK.asc': basic(b'BLACK '),
    'graficos/losetas_2328.bin': sin_cab[1][1:1 + 13000],
    'graficos/graficos_55F0.bin': sin_cab[2][1:1 + 10752],
}
src = os.path.join(os.path.dirname(os.path.abspath(__file__)), '..', 'src')
mal = 0
for n, d in datos.items():
    ok = hashlib.sha1(d).hexdigest() == ESPERADO[n]
    mal += not ok
    print(f'{n:28s} {"OK" if ok else "DISTINTO / DIFFERENT / 不一致"}')
    if ok:
        os.makedirs(os.path.dirname(os.path.join(src, n)), exist_ok=True)
        open(os.path.join(src, n), 'wb').write(d)
sys.exit(1 if mal else 0)
