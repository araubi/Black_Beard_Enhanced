# Ejecuta la música de beeper del fichero AY (48K) y guarda los cambios del altavoz (ciclo, nivel)
import z80, sys, struct, array
d = open(sys.argv[1], 'rb').read()
mem = bytearray(65536)
mem[0xE5E5:0xE5E5+0x710] = d[0x77:0x77+0x710]
mem[0x0280:0x0280+0x50] = d[0x787:0x787+0x50]
# AY: antes de INIT se rellena 0000-00FF con C9, 0100-3FFF con FF, 4000-FFFF con 0, y 0038 con FB C9 (IM1)
for i in range(0x100): mem[i] = mem[i] if 0x80 <= i < 0 else 0xC9
m = z80.Z80Machine()
base = bytearray(65536); base[0:0x100] = b'\xC9'*0x100; base[0x100:0x4000] = b'\xFF'*0x3F00
base[0xE5E5:0xE5E5+0x710] = d[0x77:0x77+0x710]; base[0x0280:0x0280+0x50] = d[0x787:0x787+0x50]
base[0x38] = 0xFB; base[0x39] = 0xC9
m.set_memory_block(0, bytes(base))
cambios = array.array('q'); t = [0]; ult = [-1]
def out(p, v):
    if p & 1 == 0:
        b = (v >> 4) & 1
        if b != ult[0]:
            cambios.append(t[0] + (TOT - m.ticks_to_stop)); cambios.append(b); ult[0] = b
m.set_output_callback(out); m.set_input_callback(lambda p: 0xFF)
m.sp = 0xF000; m.memory[0xEFFE] = 0; m.pc = 0xE5E5; m.sp = 0xEFFE
segs = float(sys.argv[3]); CUADRO = 69888; TOT = CUADRO
while t[0] < segs * 3500000:
    TOT = CUADRO; m.ticks_to_stop = TOT
    while m.ticks_to_stop > 0:
        m.run()
    t[0] += TOT
    m.on_handle_active_int()
open(sys.argv[2], 'wb').write(cambios.tobytes())
print(len(cambios)//2, 'cambios en', segs, 's; pc', hex(m.pc))
