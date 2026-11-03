# Trazador sencillo de código Z80: marca bytes de código siguiendo saltos y llamadas
import sys

def ilen(m, a):
    """Devuelve (longitud, tipo, destino) de la instrucción en a.
    tipo: None normal, 'jp','jpc','jr','jrc','call','callc','ret','retc','end','rst'"""
    op = m[a]
    if op == 0xCB: return 2, None, None
    if op == 0xED:
        o2 = m[(a+1) & 0xFFFF]
        if o2 in (0x43,0x4B,0x53,0x5B,0x63,0x6B,0x73,0x7B): return 4, None, None
        if o2 in (0x45,0x4D,0x55,0x5D,0x65,0x6D,0x75,0x7D): return 2, 'ret', None
        return 2, None, None
    if op in (0xDD, 0xFD):
        o2 = m[(a+1) & 0xFFFF]
        if o2 == 0xCB: return 4, None, None
        if o2 == 0xE9: return 2, 'end', None
        if o2 in (0xDD,0xFD,0xED): return 1, None, None
        l, t, d = ilen(m, (a+1) & 0xFFFF)
        uses_hl_mem = o2 in (0x34,0x35,0x36,0x46,0x4E,0x56,0x5E,0x66,0x6E,0x7E,0x86,0x8E,0x96,0x9E,0xA6,0xAE,0xB6,0xBE) or (0x70 <= o2 <= 0x77 and o2 != 0x76)
        return 1 + l + (1 if uses_hl_mem else 0), t, d
    w = m[(a+1)&0xFFFF] | (m[(a+2)&0xFFFF] << 8)
    r = (a + 2 + ((m[(a+1)&0xFFFF] ^ 0x80) - 0x80)) & 0xFFFF
    if op == 0xC3: return 3, 'jp', w
    if op & 0xC7 == 0xC2: return 3, 'jpc', w
    if op == 0xCD: return 3, 'call', w
    if op & 0xC7 == 0xC4: return 3, 'callc', w
    if op == 0x18: return 2, 'jr', r
    if op in (0x10,0x20,0x28,0x30,0x38): return 2, 'jrc', r
    if op == 0xC9: return 1, 'ret', None
    if op & 0xC7 == 0xC0: return 1, 'retc', None
    if op == 0xE9: return 1, 'end', None
    if op & 0xC7 == 0xC7: return 1, 'rst', op & 0x38
    # longitudes del resto
    if op in (0x01,0x11,0x21,0x31,0x22,0x2A,0x32,0x3A): return 3, None, None
    if op in (0x06,0x0E,0x16,0x1E,0x26,0x2E,0x36,0x3E,0xC6,0xCE,0xD6,0xDE,0xE6,0xEE,0xF6,0xFE,0xD3,0xDB): return 2, None, None
    return 1, None, None

def trace(m, entries, lo, hi, rst_returns=True):
    code = {}      # dir -> longitud
    targets = {}   # dir destino -> tipo de referencia ('call','jp')
    pend = list(entries)
    while pend:
        a = pend.pop()
        while lo <= a < hi and a not in code:
            l, t, d = ilen(m, a)
            code[a] = l
            if t in ('jp','jpc','jr','jrc','call','callc'):
                targets.setdefault(d, 'call' if t.startswith('call') else 'jp')
                if lo <= d < hi: pend.append(d)
            if t in ('jp','jr','ret','end'): break
            if t == 'rst' and not rst_returns: break
            a += l
    return code, targets
