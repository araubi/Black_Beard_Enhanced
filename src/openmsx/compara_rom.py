import sys
m=open(sys.argv[1],'rb').read(); F=sys.argv[2]
r=lambda n: open(F+n,'rb').read()
t=r('bloque_2328.bin'); g=r('bloque_55F0.bin'); d=r('bloque_8400.bin')
mal=0
import os
bl=[(0x2328,t),(0x55F0,g),(0x8400,d)]
if os.path.exists(F+'idioma_E294.bin'): bl.append((0xE294,r('idioma_E294.bin')))
if os.path.exists(F+'doble_F480.bin'):   # doble.asm: el código (las variables cambian)
    dd=r('doble_F480.bin'); bl.append((0xF498,dd[0x18:0x280])); bl.append((0xF730,dd[0x2B0:]))  # sin MARCAS (F700h-F72Fh)
if os.path.exists(F+'junto_FDE8.bin'):  # filas_alto.asm (FDE8h)
    bl.append((0xFDE8,r('junto_FDE8.bin')))
if os.path.exists(F+'bajo_0040.bin'):   # lateral.asm: el código (K_BANCO, F_D y F_C cambian)
    bl.append((0x0044,r('bajo_0040.bin')[4:])); bl.append((0x0326,r('bajo_0326.bin')))
for a,b in bl:
    x=m[a:a+len(b)]; k=sum(1 for i in range(len(b)) if x[i]!=b[i]); mal+=k
    print('%04X'%a, 'diferencias', k)
print('OK' if mal==0 else 'MAL')
