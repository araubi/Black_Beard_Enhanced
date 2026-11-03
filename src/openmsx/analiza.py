import sys
d=sys.argv[1]
import glob
for n in range(1,len(glob.glob(d+"/v*.bin"))+1):
    v=open(f'{d}/v{n}.bin','rb').read(); r=open(f'{d}/r{n}.bin','rb').read()
    def pix(x,y):
        ch=(y>>3)*32+(x>>3); p=v[0x1800+ch]+256*(y>>6)
        return (v[p*8+(y&7)]>>(7-(x&7)))&1
    spr=set()
    sat=[]
    for i in range(4*r[0x2130]):
        Y,X,P,C=v[0x1B00+4*i:0x1B04+4*i]
        if Y==0xD0: break
        sat.append((Y,X,P,C))
        for yy in range(16):
            for xx in range(16):
                b=v[0x3800+P*8+(xx//8)*16+yy]
                if (b>>(7-xx%8))&1: spr.add((X+xx,(Y+1+yy)&255))
    nf=r[0x2130]
    print(f'volcado {n}: {nf} figuras, {len(sat)} sprites')
    esper=set()
    for i in range(nf):
        e=r[0x2100+6*i:0x2106+6*i]; ptr=e[0]+256*e[1]; L,y,x,fl=e[2],e[3],e[4],e[5]
        top = y
        ok=tot=0
        for row in range(L):
            line = L-1-row if fl&1 else row
            for c in range(24):
                m=(r[ptr+6*line+c//8]>>(7-c%8))&1; dd=(r[ptr+6*line+3+c//8]>>(7-c%8))&1
                X,Y=x+c,top+row
                if X>=192 or Y>191: continue
                if dd: tot+=1; ok+=pix(X,Y)
                if not m and not dd: esper.add((X,Y))
        print(f'  fig {i}: ptr {ptr:04X} L {L} y {y} x {x} flip {fl:02X} tinta en pantalla {ok}/{tot}')
    ink_bajo=sum(pix(X,Y) for (X,Y) in spr if X<256 and Y<192)
    print(f'  sprite px {len(spr)}, esperados {len(esper)}, sobran {len(spr-esper)}, faltan {len(esper-spr)}, sprite sobre tinta {ink_bajo}')
