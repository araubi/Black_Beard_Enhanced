# Hace las C-BIOS de 50 Hz que usan las máquinas de src/openmsx (CB1_EU, CB2_EU, CB2P_EU):
# copia cbios_main_msx1.rom, cbios_main_msx2.rom y cbios_main_msx2+.rom con el bit 7 del
# byte 002Bh a 1 (50 Hz, PAL). C-BIOS viene con openMSX (licencia BSD).
# Makes the 50 Hz C-BIOS copies used by the machines in src/openmsx.
# src/openmsx のマシン用に 50 Hz 版の C-BIOS を作ります。
#   python3 tools/cbios50.py /usr/share/openmsx/systemroms ~/.openMSX/share/systemroms
import os, sys
ori, dest = sys.argv[1], sys.argv[2]
os.makedirs(dest, exist_ok=True)
for n in ('msx1', 'msx2', 'msx2+'):
    d = bytearray(open(os.path.join(ori, f'cbios_main_{n}.rom'), 'rb').read())
    d[0x2B] |= 0x80
    open(os.path.join(dest, f'cbios_main_{n}_eu50.rom'), 'wb').write(d)
    print(f'cbios_main_{n}_eu50.rom')
