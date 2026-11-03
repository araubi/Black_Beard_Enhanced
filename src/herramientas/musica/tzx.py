import sys,struct
d=open(sys.argv[1],'rb').read()
print(d[:10])
p=10;i=0;out=[]
while p<len(d):
    t=d[p];p+=1
    if t==0x10:
        pause,l=struct.unpack('<HH',d[p:p+4]);data=d[p+4:p+4+l];p+=4+l
    elif t==0x11:
        l=d[p+15]|d[p+16]<<8|d[p+17]<<16;data=d[p+18:p+18+l];p+=18+l
    elif t==0x14:
        l=d[p+7]|d[p+8]<<8|d[p+9]<<16;data=d[p+10:p+10+l];p+=10+l
    elif t==0x30:
        l=d[p];print('text',d[p+1:p+1+l]);p+=1+l;continue
    elif t==0x32:
        l=struct.unpack('<H',d[p:p+2])[0];print('archive',d[p:p+2+l]);p+=2+l;continue
    elif t==0x20: p+=2;continue
    elif t==0x21: l=d[p];print('group',d[p+1:p+1+l]);p+=1+l;continue
    elif t==0x22: continue
    elif t==0x12: p+=4;continue
    elif t==0x13: n=d[p];p+=1+2*n;continue
    else: print('unk',hex(t));break
    print(i,hex(t),len(data),data[:1].hex(), data[1:18] if data[0]==0 else '')
    open(f'{sys.argv[2]}/b{i:02d}.bin','wb').write(data);i+=1
