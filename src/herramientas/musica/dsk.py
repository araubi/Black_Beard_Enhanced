import sys,struct,os
d=open(sys.argv[1],'rb').read(); out=sys.argv[2]; os.makedirs(out,exist_ok=True)
ntr=d[0x30]; nsd=d[0x31]; sizes=d[0x34:0x34+ntr*nsd]
tracks={}; off=0x100
for t in range(ntr*nsd):
    if sizes[t]==0: continue
    tb=d[off:off+sizes[t]*256]; off+=sizes[t]*256
    tn=tb[0x10]; ns=tb[0x15]; secs={}; p=0x100
    for s in range(ns):
        si=tb[0x18+8*s:0x20+8*s]; ln=struct.unpack('<H',si[6:8])[0] or (128<<si[3])
        secs[si[2]]=tb[p:p+ln]; p+=ln
    tracks[tn]=secs
print('tracks',len(tracks),'first ids',sorted(tracks[0].keys()))
ids=sorted(tracks[0].keys()); base=ids[0]
spt=len(ids)
sysoff = 0 if base==0xC1 else 2
def block(n):
    # 1K block = 2 sectors
    r=b''
    for k in range(2):
        ls=n*2+k
        tr=sysoff+ls//spt; sc=base+ls%spt
        r+=tracks[tr][sc]
    return r
dirb=block(0)+block(1)
files={}
for i in range(64):
    e=dirb[i*32:i*32+32]
    if e[0]==0xE5: continue
    name=(e[1:9].decode('latin1').strip()+'.'+bytes(c&0x7f for c in e[9:12]).decode('latin1').strip())
    ext=e[12]; rc=e[15]; bl=[b for b in e[16:32] if b]
    files.setdefault(name,[]).append((ext,rc,bl))
for name,ents in files.items():
    data=b''
    for ext,rc,bl in sorted(ents):
        dd=b''.join(block(b) for b in bl); data+=dd[:rc*128]
    hdr=''
    if sum(data[:67])&0xffff==struct.unpack('<H',data[67:69])[0]:
        typ=data[18]; load=struct.unpack('<H',data[21:23])[0]; ln=struct.unpack('<H',data[24:26])[0]; ex=struct.unpack('<H',data[26:28])[0]
        hdr='AMSDOS type %d load %04X len %04X exec %04X'%(typ,load,ln,ex); body=data[128:128+ln]
    else: body=data
    open(os.path.join(out,name),'wb').write(body)
    print(name,len(data),hdr)
