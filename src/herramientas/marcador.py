# Genera marcador.asm a partir de graficos/marcador_ruben_ajustado.png (64x192,
# columnas 24-31 de la pantalla, paleta de openMSX). Compara con
# graficos/marcador_original.png y, para cada carácter cambiado:
#  - si es fijo, rehace su patrón en los gráficos del marcador (5EF0h, por
#    columnas de 192 bytes) y le da color por línea;
#  - si el juego cambia su patrón (calavera, botellas), solo le da color.
# El color por línea va en una lista (dirección VRAM + 8 bytes) que se escribe
# tras el color por carácter de NUEVA_PARTIDA.
# Uso: python3 herramientas/marcador.py  (desde fuentes/)
from PIL import Image

PAL = [(0,0,0),(0,0,0),(33,200,66),(94,220,120),(84,85,237),(125,118,252),(212,82,77),(66,235,245),
       (252,85,84),(255,121,120),(212,193,84),(230,206,128),(33,176,59),(201,91,186),(204,204,204),(255,255,255)]
IDX = {c: i for i, c in enumerate(PAL) if i}
IDX[(0,0,0)] = 1

nuevo = Image.open('graficos/marcador_ruben_ajustado.png').convert('RGB').load()
viejo = Image.open('graficos/marcador_original.png').convert('RGB').load()
graf = open('graficos/graficos_55F0.bin', 'rb').read()
# color por carácter del marcador (LD26E, 8 columnas de 24): en cuerpo_juego.asm
ATRIBUTOS = open('bloque_8400.bin', 'rb').read()[0xD26E - 0x8400: 0xD26E - 0x8400 + 192]

# Caracteres (fila, columna 0-7) cuyo patrón dibuja el juego: calavera (vidas),
# botellas (energía), arma y cifras de las balas
DINAMICOS = {(r, c) for r in range(2, 6) for c in range(2, 6)} | \
            {(r, c) for r in (13, 14) for c in range(1, 7)} | {(9, 3), (9, 4), (10, 3), (10, 4), (16, 3), (16, 4)}
# Las seis botellas son iguales: la parte de arriba toma el color de la primera
COPIA = {(13, c): (13, 1) for c in range(2, 7)}

def pixeles(img, f, c):
    return [[IDX[img[c*8+x, f*8+l]] for x in range(8)] for l in range(8)]

def dir_patron(f, c):
    return 0x5EF0 + c*192 + f*8

lineas = ['; Generado por herramientas/marcador.py: marcador recoloreado por araubi',
          '; (graficos/marcador_ruben.png; ajustado a 2 colores por línea en', ';  graficos/marcador_ruben_ajustado.png)', '']
patrones, colores = [], []
cambiados = [(f, c) for f in range(24) for c in range(8) if pixeles(nuevo, f, c) != pixeles(viejo, f, c)]
for f, c in sorted(set(cambiados) | set(COPIA)):
    fuente = COPIA.get((f, c), (f, c))
    px = pixeles(nuevo, *fuente)
    pat_viejo = graf[dir_patron(f, c) - 0x55F0: dir_patron(f, c) - 0x55F0 + 8]
    pat, col = [], []
    for l in range(8):
        cs = sorted(set(px[l]))
        assert len(cs) <= 2, (f, c, l, cs)
        if (f, c) in DINAMICOS:
            # el patrón no es nuestro: el atributo original (D26Eh, por columnas)
            # dice qué color era tinta y cuál papel; se cambia cada uno por el nuevo
            atr = ATRIBUTOS[fuente[1] * 24 + fuente[0]]
            vis = pixeles(viejo, *fuente)[l]
            nt, np_ = set(), set()
            for x in range(8):
                (nt if vis[x] == atr >> 4 else np_).add(px[l][x])
            assert len(nt) <= 1 and len(np_) <= 1, (f, c, l, nt, np_)
            col.append(((nt.pop() if nt else 0) << 4) | (np_.pop() if np_ else 0))
            if l == 7:
                # líneas sin tinta o sin papel en la imagen: lo más usado en el carácter
                ts = [k >> 4 for k in col if k >> 4] or [atr >> 4]
                ps = [k & 15 for k in col if k & 15] or [atr & 15]
                t = max(set(ts), key=ts.count); q = max(set(ps), key=ps.count)
                col = [(k if k >> 4 else (t << 4) | k) for k in col]
                col = [(k if k & 15 else k | q) for k in col]
            continue
        # fijo: se elige qué color es tinta para cambiar los menos bits posibles
        mejor = None
        for tinta in cs:
            papel = [k for k in cs if k != tinta]
            papel = papel[0] if papel else tinta
            b = sum(1 << (7-x) for x in range(8) if px[l][x] == tinta and tinta != papel)
            if tinta == papel:
                b = pat_viejo[l]
            coste = bin(b ^ pat_viejo[l]).count('1')
            if mejor is None or coste < mejor[0]:
                mejor = (coste, b, (tinta << 4) | papel)
        pat.append(mejor[1])
        col.append(mejor[2])
    if pat:
        patrones.append((dir_patron(f, c), f, c, pat))
    vram = 0x2000 + (f // 8) * 0x800 + (24 + c) * 64 + (f % 8) * 8
    colores.append((vram, f, c, col))

lineas.append('; Patrones nuevos de los caracteres fijos (en los gráficos del marcador)')
for d, f, c, pat in patrones:
    lineas.append(f'        org 0{d:04X}h                      ; fila {f}, columna {24+c}')
    lineas.append('        db ' + ','.join(f'0{b:02X}h' for b in pat))
lineas += ['', '; NUEVA_PARTIDA pone el color por carácter y luego esta lista',
           '        org 092EDh', '        call COLOR_MARCADOR', '',
           '        org FIN_PARCIAL',
           'COLOR_MARCADOR:',
           '        call L9DB2',
           '        ld hl,LISTA_MARCADOR',
           '.car:   ld e,(hl)',
           '        inc hl',
           '        ld d,(hl)',
           '        inc hl',
           '        ld a,d',
           '        or a',
           '        ret z',
           '        ex de,hl',
           '        call VDP_ESCRITURA',
           '        ex de,hl',
           '        ld b,8',
           '.lin:   ld a,(hl)                        ; 37 ciclos por byte: vale para el TMS',
           '        out (098h),a',
           '        inc hl',
           '        djnz .lin',
           '        jr .car',
           'LISTA_MARCADOR:']
for vram, f, c, col in colores:
    lineas.append(f'        dw 0{vram:04X}h : db ' + ','.join(f'0{b:02X}h' for b in col) + f'   ; fila {f}, columna {24+c}')
lineas += ['        dw 0', 'FIN_MARCADOR:',
           '        assert FIN_MARCADOR <= 0E290h  ; E290h-E293h: TEST.BIN y el cargador de la ROM', '']
open('marcador.asm', 'w').write('\n'.join(lineas))
print(len(patrones), 'patrones,', len(colores), 'caracteres con color por línea')
