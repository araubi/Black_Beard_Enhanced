# Saca de un .cas: LOAD.BIN y TEST.BIN (con su dirección) y los bloques sin cabecera para cinta.tcl
import sys
cas=open(sys.argv[1],'rb').read(); out=sys.argv[2]
CAB=bytes.fromhex('1FA6DEBACC137D74')
pos=[i for i in range(0,len(cas),8) if cas[i:i+8]==CAB]
bl=[cas[p+8:(pos[k+1] if k+1<len(pos) else len(cas))] for k,p in enumerate(pos)]
bins={}
for k,b in enumerate(bl):
    if b[:10]==b'\xd0'*10:
        d=bl[k+1]; ini=d[0]|d[1]<<8; fin=d[2]|d[3]<<8
        bins[b[10:16].decode().strip()]=(ini,d[6:6+fin-ini+1])
        if b[10:16]==b'LOAD  ': open(f'{out}/ejec.txt','w').write('%d'%(d[4]|d[5]<<8))
    if b[:10]==b'\xea'*10: print('BASIC',b[10:16], [l for l in bl[k+1].split(b'\r\n') if b'USR' in l])
for n,(ini,d) in bins.items():
    open(f'{out}/{n}_{ini:04X}.bin','wb').write(d); print(n,hex(ini),len(d))
sin=[b for b in bl if b[:1]==b'\xff']
s=b''.join(sin); open(f'{out}/flujo.bin','wb').write(s)
o=0; offs=[]
for b in sin: offs.append(o); o+=len(b)
open(f'{out}/offs.txt','w').write(' '.join(map(str,offs))); print('bloques sin cabecera',len(sin),[len(b) for b in sin])
