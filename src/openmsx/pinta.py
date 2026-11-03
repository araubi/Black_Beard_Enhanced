# Pinta un volcado de VRAM (SCREEN 2 + sprites 16x16) con y sin sprites
import sys
from PIL import Image
PAL=[(0,0,0),(0,0,0),(33,200,66),(94,220,120),(84,85,237),(125,118,252),(212,82,77),(66,235,245),
     (252,85,84),(255,121,120),(212,193,84),(230,206,128),(33,176,59),(201,91,186),(204,204,204),(255,255,255)]
def pinta(v,spr):
    im=Image.new('RGB',(256,192))
    px=im.load()
    bd=v_reg7=1
    for y in range(192):
        for x in range(256):
            ch=(y>>3)*32+(x>>3); p=v[0x1800+ch]+256*(y>>6)
            b=(v[p*8+(y&7)]>>(7-(x&7)))&1; c=v[0x2000+p*8+(y&7)]
            col=(c>>4) if b else (c&15)
            px[x,y]=PAL[col]
    if spr:
        for i in reversed(range(32)):
            Y,X,P,C=v[0x1B00+4*i:0x1B04+4*i]
            if Y==0xD0: break
        n=i if Y==0xD0 else 32
        lin=[0]*256
        for i in range(n):
            Y,X,P,C=v[0x1B00+4*i:0x1B04+4*i]
            for yy in range(16):
                y=(Y+1+yy)&255
                if y>=192: continue
                lin[y]+=1
                if lin[y]>4: continue
                for xx in range(16):
                    b=v[0x3800+(P&0xFC)*8+(xx//8)*16+yy]
                    if (b>>(7-xx%8))&1 and X+xx<256 and (C&15):
                        px[X+xx,y]=PAL[C&15]
    return im
v=open(sys.argv[1],'rb').read()
a=pinta(v,False).crop((0,0,192,192)); b=pinta(v,True).crop((0,0,192,192))
m=Image.new('RGB',(192*2+8,192),(40,40,40)); m.paste(a,(0,0)); m.paste(b,(200,0))
m.resize((m.width*int(sys.argv[3]),m.height*int(sys.argv[3])),Image.NEAREST).save(sys.argv[2])
