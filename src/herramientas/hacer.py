# Genera los fuentes de Black Beard a partir de los bloques de la cinta original
import sys
sys.path.insert(0, '.')
from gen2 import generar
from post2 import posprocesa
from nombres_juego import NOMBRES, COMENT

O = '../original/'
cov = [int(x) for x in open('cobertura_openmsx.txt')]
d = open(O + 'mem/8400.bin', 'rb').read()
tabla_musica = [d[0x8926-0x8400+2*i] | d[0x8927-0x8400+2*i] << 8 for i in range(15)]
manuales = [0x8428, 0x8866, 0x882A, 0x96F8, 0x9755, 0x9BC5, 0x9C02, 0x9C95, 0xA5CF, 0xAC51, 0xAC8A, 0xB00C]
n = generar(O + 'mem/8400.bin', 0x8400, [0x92AC, 0x8400, 0xA3CC] + cov + tabla_musica + manuales, 'juego')
eq = posprocesa('juego', NOMBRES, COMENT, 'cuerpo_juego.asm')
print('juego', n, 'bytes de código; equ:', eq)

# pantalla de carga (9C40): código hasta 9CF8, luego la imagen
n = generar(O + 'mem/9C40.bin', 0x9C40, [0x9C40], 'pantalla')
eq = posprocesa('pantalla', {0x9C40: 'PANTALLA_CARGA', 0x9CF9: 'IMAGEN_PATRONES', 0xB4F9: 'IMAGEN_COLOR'},
                {0x9C40: 'Vuelca la pantalla de carga: 6144 bytes de patrones y el color\ncomprimido en un byte por cada 8 líneas (dos nibbles a través de una tabla)'},
                'cuerpo_pantalla.asm', 'P')
print('pantalla', n, eq)

n = generar(O + '03_LOAD_D6D8.bin', 0xD6D8, [0xD6D8], 'load')
eq = posprocesa('load', {0xD6D8: 'CARGA', 0xD71F: 'LEE_BLOQUE'},
                {0xD6D8: 'LOAD.BIN: lee los cuatro bloques sin cabecera y salta al juego (92ACh)',
                 0xD71F: 'Carga DE bytes en IX con la BIOS (TAPION/TAPIN) llamada desde una\nrutina en FC9Ah que conmuta la página 0 entre BIOS y RAM en cada byte'},
                'cuerpo_load.asm', 'D')
print('load', n, eq)
n = generar(O + '04_TEST_C350.bin', 0xC350, [0xC350], 'test')
eq = posprocesa('test', {0xC350: 'BUSCA_RAM'},
                {0xC350: 'TEST.BIN: busca la ranura con RAM de las páginas 0, 1 y 2 (deja los\nvalores en E290h-E293h para LOAD.BIN)'}, 'cuerpo_test.asm', 'T')
print('test', n, eq)
n = generar(O + '01_LOGOTO_9470.bin', 0x9470, [0x9470], 'logo')
eq = posprocesa('logo', {0x9470: 'LOGO_TOPO'}, {0x9470: 'LOGOTOPO.CM: el logotipo animado de Topo con su música (común a otros juegos de Topo)'}, 'cuerpo_logo.asm', 'T')
print('logo', n, eq)
