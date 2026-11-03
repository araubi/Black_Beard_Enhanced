import sys,os
d=open(sys.argv[1],'rb').read(); out=sys.argv[2]; os.makedirs(out,exist_ok=True)
h=bytes.fromhex('1FA6DEBACC137D74')
pos=[];i=0
while (j:=d.find(h,i))>=0: pos.append(j); i=j+8
pos.append(len(d))
blocks=[d[pos[k]+8:pos[k+1]] for k in range(len(pos)-1)]
k=0;n=0
while k<len(blocks):
    b=blocks[k]
    if len(b)>=16 and b[:10] in (b'\xd0'*10,b'\xd3'*10,b'\xea'*10):
        t={0xd0:'bin',0xd3:'bas',0xea:'asc'}[b[0]]; name=b[10:16].decode('latin1')
        data=blocks[k+1]; k+=2
        if t=='bin':
            s,e,x=[int.from_bytes(data[i:i+2],'little') for i in (0,2,4)]
            body=data[6:6+e-s+1]
            print(f'{n:02d} BIN "{name}" {s:04X}-{e:04X} exec {x:04X}  bloque {len(data)} trail {len(data)-6-(e-s+1)}')
            open(f'{out}/{n:02d}_{name.strip()}_{s:04X}.bin','wb').write(body)
        else:
            print(f'{n:02d} {t} "{name}" {len(data)}'); open(f'{out}/{n:02d}_{name.strip()}.{t}','wb').write(data)
    else:
        print(f'{n:02d} SIN CABECERA {len(b)} bytes, primeros {b[:8].hex()}'); open(f'{out}/{n:02d}_raw.bin','wb').write(b); k+=1
    n+=1
