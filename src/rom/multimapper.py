# Black Beard v1.1: hace que la ROM funcione con el mapper que elija el cargador
# (ASCII16, ASCII8, Konami SCC o Konami), no solo con ASCII16.
#
# Por qué: en el One Chip MSX (OCM) las ROM se cargan desde la SD con programas que
# adivinan el mapper. SofaROM tomaba la ROM por ASCII8 «wide» (y parcheaba sus
# LD (nn),A) y mglOCM, por Konami; la ROM cambiaba de banco escribiendo en 77FFh,
# que en esos mappers es otro registro, y se colgaba tras el logo o el pirata.
#
# Qué hace (sobre la ROM que deja rom.asm):
#  * ARRANQUE (4011h): en vez de «xor a / ld (6000h),a / inc a / ld (77FFh),a»,
#    escribe 1 en 6800h (por si es ASCII8 con la página 0 también en 6000h) y llama a un
#    instalador en el relleno de la mitad 1 (7A60h), que copia multimapper.asm a E580h
#    (detrás del cargador) y ejecuta DETECTA.
#  * Los dos «ld (77FFh),a» del cargador pasan a llamar a PAG2, que cambia la página
#    8000h con los registros del mapper detectado, siempre con LD (HL),n.
#  * Marca 16h en el banco 3 (vacío) para distinguir ASCII16 de ASCII8, y un relleno de
#    LD (7000h),A / LD (6000h),A (nunca se ejecuta) para que openMSX la siga tomando
#    por ASCII16; solo direcciones estándar, para que SofaROM no pase a su modo «wide».
#
#   python3 multimapper.py BlackBeard_color.rom      (la reescribe)
# Necesita pasmo (variable PASMO).
import os, sys, subprocess, tempfile
aqui = os.path.dirname(os.path.abspath(__file__))
PASMO = os.environ.get('PASMO', 'pasmo')
rom = sys.argv[1]
d = bytearray(open(rom, 'rb').read())
assert len(d) == 0x10000
INST, DAT = 0x3A60, 0x3A80            # ROM 7A60h: instalador; 7A80h: lo que va a E580h
MARCA = 0x16
assert d[0x6000] not in (MARCA, d[0]), 'el byte 6000h de la ROM no sirve de marca'
with tempfile.TemporaryDirectory() as t:
    subprocess.run([PASMO, '--equ', f'MARCA_8K3={d[0x6000]}', '--bin',
                    os.path.join(aqui, 'multimapper.asm'), os.path.join(t, 'mm.bin'),
                    os.path.join(t, 'mm.sym')], check=True, stdout=subprocess.DEVNULL)
    mm = open(os.path.join(t, 'mm.bin'), 'rb').read()
    sym = {l.split()[0]: int(l.split()[2][:-1], 16) for l in open(os.path.join(t, 'mm.sym')) if 'EQU' in l}
DET, PAG2 = sym['DETECTA'], sym['PAG2']
assert sym['MAPA'] == 0xE580 and sym['FIN'] <= 0xE600          # E600h: copia oculta
assert all(b == 0xFF for b in d[INST:0x4000]), 'el relleno de la mitad 1 no está libre'
assert all(b == 0xFF for b in d[0xC000:0x10000]), 'el banco 3 no está vacío'
d[INST:INST+14] = bytes([0x21, DAT & 255, 0x40 | DAT >> 8, 0x11, 0x80, 0xE5, 0x01, len(mm), 0x00,
                         0xED, 0xB0, 0xC3, DET & 255, DET >> 8])   # ld hl / ld de / ld bc / ldir / jp DETECTA
d[DAT:DAT+len(mm)] = mm
assert d[0x11:0x19] == bytes.fromhex('af3200603c32ff77')
d[0x11:0x19] = bytes([0x21, 0x00, 0x68, 0x36, 0x01, 0xCD, INST & 255, 0x40 | INST >> 8])
o = 0xE4E2 - 0xE400 + 0x84                                      # BANCOS_23
assert d[o:o+6] == bytes.fromhex('3e0132ff77c9')
d[o:o+6] = bytes([0x3E, 1, 0xC3, PAG2 & 255, PAG2 >> 8, 0])
o = 0xE48D - 0xE400 + 0x84                                      # banco 2 antes de quitar la ROM
assert d[o:o+5] == bytes.fromhex('3e0232ff77')
d[o:o+5] = bytes([0x3E, 2, 0xCD, PAG2 & 255, PAG2 >> 8])
d[0xC000] = MARCA
r = bytes.fromhex('320070') * 8 + bytes.fromhex('320060') * 6
d[0xC010:0xC010+len(r)] = r
open(rom, 'wb').write(d)
