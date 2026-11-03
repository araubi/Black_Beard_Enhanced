import sys
for fn in sys.argv[1:]:
    v=[l.split() for l in open(fn) if l.startswith('V')]
    t=[float(a[1]) for a in v]; x=[int(a[2]) for a in v]; y=[int(a[3]) for a in v]; p=[int(a[4]) for a in v]
    print(fn)
    for nom,a,b in [('quieto',0.5,3),('derecha',3.5,12),('izquierda',12.7,21.2),('arriba',21.6,25.4),('abajo',25.8,29.5),('todo',0,30)]:
        idx=[i for i in range(1,len(t)) if a<=t[i-1] and t[i]<=b]
        d=[t[i]-t[i-1] for i in idx]
        if not d: continue
        m=sum(d)/len(d)
        print(f" {nom:10s} vueltas {len(d):4d}  media {m*1000:6.1f} ms = {m*50:5.2f} cuadros  min {min(d)*50:.2f} max {max(d)*50:.2f}  x {x[idx[0]-1]}->{x[idx[-1]]} y {y[idx[0]-1]}->{y[idx[-1]]} p {sorted(set(p[i] for i in idx))}")
