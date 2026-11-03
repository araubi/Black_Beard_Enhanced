# Lee la hoja x4 retocada por araubi: verde = papel, negro = tinta, magenta = transparente
import sys
from PIL import Image
im=Image.open(sys.argv[1]).convert('RGB'); W,H=im.size; px=im.load()
FIG={(170,40,170):'T',(0,0,0):'K',(33,200,66):'P',(240,240,240):'P'}
def es(x,y): return 0<=x<W and 0<=y<H and px[x,y] in FIG
celdas=[]
for y in range(H):
    for x in range(W):
        if es(x,y) and not es(x-1,y) and not es(x,y-1):
            w=0
            while es(x+w,y): w+=1
            h=0
            while es(x,y+h): h+=1
            if w==96 and h==96: celdas.append((y,x))
celdas.sort()
print(len(celdas),'celdas de 24x24', file=sys.stderr)
dirs=[0x4608+k*144 for k in range(27)]+[0x55F0+k*144 for k in range(7)]
assert len(celdas)==34
out={}
for (y0,x0),a in zip(celdas,dirs):
    fil=[]
    for r in range(24):
        fil.append(''.join(FIG[px[x0+4*c+1,y0+4*r+1]] for c in range(24)))
    out[a]=fil
import json; json.dump({hex(a):f for a,f in out.items()},open(sys.argv[2],"w"),indent=0)
