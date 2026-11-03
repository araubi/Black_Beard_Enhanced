import sys,struct
d=open(sys.argv[1],'rb').read()
def rp(o):
    v=struct.unpack('>h',d[o:o+2])[0]; return o+v
def cstr(o):
    e=d.index(b'\0',o); return d[o:e].decode('latin1')
print('author',cstr(rp(12)),'| misc',cstr(rp(14)))
n=d[16]+1; print('songs',n,'first',d[17])
ps=rp(18)
for i in range(n):
    o=ps+4*i
    name=cstr(rp(o)); sd=rp(o+2)
    print('song',i,name)
    # song data: AChan,BChan,CChan,Noise (4 bytes), SongLength(2), FadeLength(2), HiReg, LoReg, PPoints(2), PAddresses(2)
    print(' chans',d[sd:sd+4].hex(),'len',struct.unpack('>H',d[sd+4:sd+6])[0],'fade',struct.unpack('>H',d[sd+6:sd+8])[0])
    pp=rp(sd+10); pa=rp(sd+12)
    sp,init,inter=struct.unpack('>HHH',d[pp:pp+6]); print(' sp %04X init %04X inter %04X'%(sp,init,inter))
    o=pa
    while True:
        a=struct.unpack('>H',d[o:o+2])[0]
        if a==0: break
        l=struct.unpack('>H',d[o+2:o+4])[0]; off=rp(o+4)
        print('  block %04X len %04X fileoff %X'%(a,l,off)); o+=6
