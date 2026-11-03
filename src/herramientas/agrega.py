import sys,re,bisect,collections
labs=[]
for fn in sys.argv[2:]:
    for l in open(fn):
        m=re.match(r'^(sub_|l)([0-9a-f]{4})h:',l)
        if m and m.group(1)=='sub_': labs.append(int(m.group(2),16))
labs=sorted(set(labs))
c=collections.Counter(); tot=0
for l in open(sys.argv[1]):
    pc=int(l.split()[0]); tot+=1
    i=bisect.bisect_right(labs,pc)-1
    c[labs[i] if i>=0 else 0]+=1
for a,n in c.most_common(30): print(f'{a:04X} {n:6d} {100*n/tot:5.1f}%')
print(tot)
