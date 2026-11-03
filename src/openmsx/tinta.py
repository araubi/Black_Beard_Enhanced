import sys,glob
d=sys.argv[1]
for n in range(1,len(glob.glob(d+"/v*.bin"))+1):
    v=open(f'{d}/v{n}.bin','rb').read()
    def pix(x,y):
        ch=(y>>3)*32+(x>>3); p=v[0x1800+ch]+256*(y>>6)
        return (v[p*8+(y&7)]>>(7-(x&7)))&1
    spr=set(); k=0
    for i in range(32):
        Y,X,P,C=v[0x1B00+4*i:0x1B04+4*i]
        if Y==0xD0: break
        k+=1
        for yy in range(16):
            for xx in range(16):
                if (v[0x3800+P*8+(xx//8)*16+yy]>>(7-xx%8))&1: spr.add((X+xx,(Y+1+yy)&255))
    print(n,k,'px',len(spr),'sobre tinta',sum(pix(x,y) for x,y in spr if x<256 and y<192))
