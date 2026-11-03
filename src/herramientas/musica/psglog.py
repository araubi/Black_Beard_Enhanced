# Ejecuta el reproductor de música de Black Beard (MSX o CPC) a 50 Hz y apunta los registros del PSG
import z80, sys, json
RET = 0xFFF0
def nueva(mem):
    m = z80.Z80Machine(); m.set_memory_block(0, bytes(mem)); m.set_memory_block(RET, b'\x76')
    m.set_breakpoint(RET); return m
def llama(m, addr, a=None, de=None, sp=0xFF00):
    if a is not None: m.a = a
    if de is not None: m.de = de
    m.sp = sp - 2; m.memory[m.sp] = RET & 255; m.memory[m.sp+1] = RET >> 8
    m.pc = addr
    for _ in range(1000):
        m.ticks_to_stop = 10**7; m.run()
        if m.pc == RET: return
    raise RuntimeError('no vuelve %04X' % m.pc)
def msx(cuadros):
    mem = bytearray(65536); dat = open(sys.argv[2], 'rb').read(); mem[0x8400:0x8400+len(dat)] = dat
    m = nueva(mem); reg = [0]*16; st = {'sel': 0}
    def out(p, v):
        p &= 255
        if p == 0xA0: st['sel'] = v & 15
        elif p == 0xA1: reg[st['sel']] = v
    m.set_output_callback(out); m.set_input_callback(lambda p: 0xFF)
    for a, de in ((0, 0x8BF5), (1, 0x8CEA), (2, 0x8D03)): llama(m, 0x8454, a, de)
    fr = []
    for i in range(cuadros): llama(m, 0x8473); fr.append(list(reg))
    return fr
def cpc(cuadros):
    mem = bytearray(open(sys.argv[2], 'rb').read())
    m = nueva(mem); reg = [0]*16; st = {'sel': 0, 'dat': 0}
    def out(p, v):
        h = p >> 8
        if h == 0xF4: st['dat'] = v
        elif h == 0xF6:
            if v & 0xC0 == 0xC0: st['sel'] = st['dat'] & 15
            elif v & 0xC0 == 0x80: reg[st['sel']] = st['dat']
    m.set_output_callback(out); m.set_input_callback(lambda p: 0xFF)
    for a, de in ((0, 0x226A), (1, 0x235F), (2, 0x2378)): llama(m, 0x1AAB, a, de)
    fr = []
    for i in range(cuadros): llama(m, 0x1ACA); fr.append(list(reg))
    return fr
if __name__ == '__main__':
    fr = {'msx': msx, 'cpc': cpc}[sys.argv[1]](int(sys.argv[4]))
    json.dump(fr, open(sys.argv[3], 'w'))
    print(len(fr), 'cuadros; primeros:', fr[:3])
