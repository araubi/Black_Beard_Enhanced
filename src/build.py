# Ensambla Black Beard y rehace la cinta (.cas).
#   python build.py            -> versión española (idéntica a la original)
#   python build.py kixx       -> edición Kixx en inglés
#   python build.py acelera    -> prueba más rápida (se puede combinar: kixx acelera)
#   python build.py color      -> acelerada y con el área de juego en color
#   La de color lleva sprites de color 9 bajo los personajes («sin_sprites» los quita)
#   y solo redibuja lo que cambia, a «limite=N» imágenes por vuelta como mínimo
#   a 50 Hz (5 por defecto, 100 ms; a 60 Hz espera 6); «completo» lo redibuja todo como antes.
#   Con el redibujado parcial va el marcador recoloreado por araubi («marcador_original» lo quita).
#   Con el redibujado parcial va también la opción de idioma del menú (idioma.asm).
#   Las mejoradas llevan la música con la afinación del Amstrad; «musica_msx» deja la del MSX.
# Necesita sjasmplus (1.24.0) en el PATH o en la variable SJASMPLUS.
import os, sys, subprocess, hashlib
os.chdir(os.path.dirname(os.path.abspath(__file__)))
SJ = os.environ.get('SJASMPLUS', 'sjasmplus')
ops = [a.lower() for a in sys.argv[1:]]
musica_cpc = ('acelera' in ops or 'color' in ops) and 'musica_msx' not in ops
kixx = 'kixx' in ops; color = 'color' in ops; acel = 'acelera' in ops or color

def asm(f, *defs, sym=None):
    r = subprocess.run([SJ, '--nologo', '--msg=war'] + [f'-D{d}' for d in defs] + ([f'--sym={sym}'] if sym else []) + [f])
    if r.returncode: sys.exit(f'error al ensamblar {f}')

sprites = color and 'sin_sprites' not in ops
cambios = sprites and 'completo' not in ops   # «completo»: redibuja y vuelca todo cada vuelta, como antes
limite = [int(a[7:]) for a in ops if a.startswith('limite=')] or [5]
salto = [int(a[6:]) for a in ops if a.startswith('salto=')] or [6]   # scroll.asm: SALTO_V (araubi eligió 12; 6 desde el 28-10: sigue cada paso)
defs = [*(['ACELERA'] if acel else []), *(['COLOREA'] if color else []), *(['AFINA_CPC'] if musica_cpc else []), *(['FIGURAS_SPR'] if sprites else []),
        *(['SOLO_CAMBIOS', 'PORFILAS', f'LIMITE={limite[0]}', f'SALTO_V={salto[0]}'] if cambios else []),
        *(['MRUBEN'] if cambios and 'marcador_original' not in ops else []),
        *(['HW'] if cambios and 'hw' in ops else [])]   # «hw»: scroll por hardware en MSX2+ (hw.asm, descartado por araubi)
if cambios:   # idioma.asm: primero la otra edición, para la tabla de lo que cambia
    asm('blackbeard.asm', *([] if kixx else ['KIXX']), *defs)
    otra = [open(f, 'rb').read() for f in ('bloque_55F0.bin', 'bloque_8400.bin')]
    doble = open('doble_F480.bin', 'rb').read()
    junto = open('junto_FDE8.bin', 'rb').read()
    hw = [open(f, 'rb').read() for f in ('hw_F000.bin', 'hw_F800.bin')] if 'HW' in defs else []
asm('blackbeard.asm', *(['KIXX'] if kixx else []), *defs, sym='bb.sym')
idioma = b''
if cambios:
    assert open('doble_F480.bin', 'rb').read() == doble   # doble.asm no cambia con el idioma
    assert open('junto_FDE8.bin', 'rb').read() == junto   # ni filas.asm
    if hw: assert [open(f, 'rb').read() for f in ('hw_F000.bin', 'hw_F800.bin')] == hw   # ni hw.asm
    for base, f, o in zip((0x55F0, 0x8400), ('bloque_55F0.bin', 'bloque_8400.bin'), otra):
        d = open(f, 'rb').read()
        assert len(d) == len(o)
        trozos = []
        for i in (i for i in range(len(d)) if d[i] != o[i]):
            if trozos and i - trozos[-1][1] < 3: trozos[-1][1] = i + 1   # juntar sale más corto
            else: trozos.append([i, i + 1])
        for a, z in trozos:
            assert not a <= 0x9ECB - base < z and not a <= 0x9ED8 - base < z   # el menú cambia esos dos
            idioma += (base + a).to_bytes(2, 'little') + bytes([z - a]) + o[a:z]
    idioma += b'\0\0'
    assert len(idioma) <= 0xE400 - 0xE294, 'la tabla de idioma no cabe en E294h-E3FFh'
    open('idioma_E294.bin', 'wb').write(idioma)
elif os.path.exists('idioma_E294.bin'): os.remove('idioma_E294.bin')
for f in ('doble_F480.bin', 'junto_FDE8.bin', 'hw_F000.bin', 'hw_F800.bin'):
    if (not cambios or f.startswith('hw') and not hw) and os.path.exists(f): os.remove(f)
sim = {l.split()[0][:-1]: l.split()[2] for l in open('bb.sym') if l.split()[0] in ('FRECUENCIA:', 'SALTO:', 'V_MSX:', 'DOBLE:', 'REINICIA_VDP:', 'MODO_INICIAL_HW:')} if cambios else {}
open('frecuencia.inc', 'w').write(f'        define DIR_FRECUENCIA {sim["FRECUENCIA"]}\n        define DIR_SALTO {sim["SALTO"]}\n'
                                  f'        define DIR_MSX {sim["V_MSX"]}\n        define DIR_DOBLE {sim["DOBLE"]}\n'
                                  f'        define LARGO_DOBLE {len(doble)}\n        define DIR_JUNTO 0FDE8h\n'
                                  f'        define LARGO_JUNTO {len(junto)}\n'
                                  + (f'        define QHW_REINICIA {sim["REINICIA_VDP"]}\n        define QHW_MODO {sim["MODO_INICIAL_HW"]}\n'
                                     f'        define QHW_LARGO1 {len(hw[0])}\n        define QHW_LARGO2 {len(hw[1])}\n' if hw else '') if sim else '; sin redibujado parcial\n')
os.remove('bb.sym')
ORG_LOAD = 0xE400 if cambios else 0xD900 if sprites else 0xD6D8   # el bloque 8400h crece
asm('pantalla.asm'); asm('load.asm', f'ORG_LOAD=0{ORG_LOAD:X}h'); asm('test.asm'); asm('logo.asm')
leer = lambda f: open(f, 'rb').read()

CAB = bytes.fromhex('1FA6DEBACC137D74')
def cab_bin(nombre, ini, datos, ejec):
    fin = ini + len(datos) - 1
    return [b'\xd0' * 10 + nombre, ini.to_bytes(2, 'little') + fin.to_bytes(2, 'little') + ejec.to_bytes(2, 'little') + datos]
def sin_cab(datos):
    x = 0xFF
    for b in datos: x ^= b
    return [b'\xff' + datos + bytes([x])]

bloques = []
bloques += [b'\xea' * 10 + (b'BLACK ' if kixx else b'TOPO  '), leer('basic/TOPO.asc')]
bloques += cab_bin(b'LOGOTO', 0x9470, leer('LOGOTOPO.CM'), 0x9470)
basic = leer('basic/BLACK.asc')
assert b'DEF USR=55000!' in basic
basic = basic.replace(b'DEF USR=55000!', b'DEF USR=%d!' % ORG_LOAD)
bloques += [b'\xea' * 10 + (b'LOAD  ' if kixx else b'BLACK '), basic]
load = bytearray(leer('LOAD.BIN'))
largo = len(leer('bloque_8400.bin'))         # LD DE,largo del último bloque (D712h)
assert load[0xD712 - 0xD6D8] == 0x11         # mismas distancias en cualquier ORG_LOAD
load[0xD713 - 0xD6D8:0xD715 - 0xD6D8] = largo.to_bytes(2, 'little')
largo = len(leer('bloque_55F0.bin'))         # LD DE,largo del bloque 55F0h (D705h)
assert load[0xD705 - 0xD6D8] == 0x11
load[0xD706 - 0xD6D8:0xD708 - 0xD6D8] = largo.to_bytes(2, 'little')
assert 0x8400 + len(leer('bloque_8400.bin')) <= ORG_LOAD
if cambios: assert 0x8400 + len(leer('bloque_8400.bin')) <= 0xE270   # pila de LOAD.BIN bajo E290h
if idioma:   # la tabla de idioma.asm viaja delante de LOAD.BIN, en E294h
    load = idioma + bytes(ORG_LOAD - 0xE294 - len(idioma)) + load
if cambios:  # doble.asm viaja detrás de LOAD.BIN; LOAD.BIN lo copia a F480h
    load += doble + junto
bloques += cab_bin(b'LOAD  ', 0xE294 if idioma else ORG_LOAD, bytes(load), ORG_LOAD)
bloques += cab_bin(b'TEST  ', 0xC350, leer('TEST.BIN'), 0xC350)
bloques += sin_cab(leer('bloque_9C40.bin'))
bloques += sin_cab(leer('bloque_2328.bin'))
bloques += sin_cab(leer('bloque_55F0.bin'))
bloques += sin_cab(leer('bloque_8400.bin'))
cas = bytearray()
for b in bloques:
    while len(cas) % 8: cas.append(0)
    cas += CAB + b
nombre = 'BlackBeard' + ('_kixx' if kixx else '') + ('_color' if color else '_acelerado' if acel else '') + '.cas'
open(nombre, 'wb').write(cas)
print(nombre, len(cas), 'bytes, SHA-1', hashlib.sha1(cas).hexdigest())
if not kixx and not acel:
    ok = hashlib.sha1(cas).hexdigest() == 'aad3641ad18ae365984678e2c2bd96dcadfbb01b'
    print('IDÉNTICA a la cinta original' if ok else 'OJO: distinta de la cinta original')
