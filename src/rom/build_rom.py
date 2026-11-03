# Hace la ROM de 64 KB (ASCII16) de Black Beard a partir de la versión de cinta.
#   python build_rom.py            -> en color, acelerada y con música de CPC (BlackBeard_color.rom)
#   python build_rom.py kixx       -> lo mismo, edición Kixx
#   (cualquier otra opción de build.py se pasa tal cual, p. ej. «acelera» o «musica_msx»)
# Necesita sjasmplus (variable SJASMPLUS) y el compresor zx0 de Einar Saukas (variable ZX0).
import os, sys, subprocess, hashlib
aqui = os.path.dirname(os.path.abspath(__file__)); fuentes = os.path.dirname(aqui)
SJ = os.environ.get('SJASMPLUS', 'sjasmplus'); ZX0 = os.environ.get('ZX0', 'zx0')
ops = [a.lower() for a in sys.argv[1:]]
if not any(o in ops for o in ('acelera', 'color')): ops.append('color')
subprocess.run([sys.executable, os.path.join(fuentes, 'build.py')] + ops, check=True)
leer = lambda f: open(os.path.join(fuentes, f), 'rb').read()
t, g = leer('bloque_2328.bin'), leer('bloque_55F0.bin')
assert len(t) == 0x55F0 - 0x2328 and len(g) == 0x8400 - 0x55F0, 'hace falta la versión en color (bloque 55F0h hasta 8400h)'
CORTE = 0xD100                 # bloque 8400h: C000h-CORTE en la primera mitad de la ROM, el resto en la segunda
partes = {'pantalla_9C40': leer('bloque_9C40.bin'), 'bloque_2328': t + g[:0x8000 - 0x55F0],
          'bloque_8000': g[0x8000 - 0x55F0:], 'bloque_8400': leer('bloque_8400.bin')[:0xC000 - 0x8400],
          'bloque_C000': leer('bloque_8400.bin')[0xC000 - 0x8400:CORTE - 0x8400],
          'bloque_D000': leer('bloque_8400.bin')[CORTE - 0x8400:], 'logo_9470': leer('LOGOTOPO.CM')}
if os.path.exists(os.path.join(fuentes, 'doble_F480.bin')): partes['doble_F480'] = leer('doble_F480.bin') + leer('junto_FDE8.bin')   # copia oculta (MSX2)
for n, d in partes.items():
    open(os.path.join(aqui, n + '.bin'), 'wb').write(d)
    subprocess.run([ZX0, '-f', n + '.bin', n + '.zx0'], cwd=aqui, check=True, stdout=subprocess.DEVNULL)
idioma = [f'-DIDIOMA_LARGO={len(leer("idioma_E294.bin"))}'] if os.path.exists(os.path.join(fuentes, 'idioma_E294.bin')) else []
r = subprocess.run([SJ, '--nologo', '--msg=war', f'-DCORTE={CORTE}', f'-DLARGO_LOGO_CM={len(partes["logo_9470"])}', *idioma, 'rom.asm'], cwd=aqui)
if r.returncode: sys.exit('error al ensamblar rom.asm')
nombre = 'BlackBeard' + ('_kixx' if 'kixx' in ops else '') + ('_color' if 'color' in ops else '_acelerado') + '.rom'
rom = open(os.path.join(aqui, 'BlackBeard.rom'), 'rb').read() + open(os.path.join(aqui, 'extra.bin'), 'rb').read()
ov = os.path.join(aqui, 'overlay.bin')      # banco 3 (vacío)
rom += (open(ov, 'rb').read() if os.path.exists(ov) else b'') .ljust(0x4000, b'\xff')
assert len(rom) == 0x10000
open(os.path.join(aqui, nombre), 'wb').write(rom); os.remove(os.path.join(aqui, 'BlackBeard.rom'))
rom = open(os.path.join(aqui, nombre), 'rb').read()
print(nombre, len(rom), 'bytes, SHA-1', hashlib.sha1(rom).hexdigest())
