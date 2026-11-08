# Black Beard Enhanced: lessons

What we learned while disassembling and enhancing Black Beard (Topo Soft, 1988), useful for other MSX games. The technical details are in DOCUMENTATION.md.

## 1. Check the screen every loop

1. **A checker in openMSX.** After every transfer, compare the VRAM (patterns, colour and name table) with what the game has in its buffer, and count the loops with errors. With several key scripts (horizontal, vertical, standing still) and on HB-20P, HB-F900 and FS-A1ST/GT, it finds bugs you can't see by eye. Run it after every change, not only at the end.
2. **When it fails, make the checker say where.** Have it report the third/column/line that is wrong and dump the loop's variables: bank, K, FINO, whether the transfer was full or partial and how many characters. That way a strange colour bug was found in minutes. It was the "only FINO changed" shortcut: it assumed the VRAM was still in the same order, but the name table had just been reset.
3. **Every shortcut ("this hasn't changed, don't send it") depends on nothing else having changed.** When you add a new way of moving the screen, review all the existing shortcuts.

## 2. A 32 KB ROM without a mapper when it doesn't fit

What helped most, in order (ZX0 by Einar Saukas):

1. **Contiguous memory in a single compressed block.** For example 8000h-83FFh and 8400h-CORTE.
2. **ZX0 with a prefix** (`zx0 +N`). If a block is decompressed right after another one already in RAM, the compressor can copy from it. Careful: it only works if that RAM is visible while decompressing; the page holding the ROM doesn't count.
3. **Compress the small things too.** TEST.BIN and the language table.
4. **Decompress straight to the destination.** For example the logo to 9470h instead of through a buffer. For that, the data must be in the half of the ROM that is visible at that moment.
5. **Rules of the two halves.** What goes to page 2 must be in the half read with the ROM in page 1, and vice versa. What goes to page 3 can be in either. An adjustable `CORTE` splits the big block between both halves. `display` the free bytes of each half, and test every edition (Kixx/Topo, build options), as they compress differently.
6. Zeroing dead code barely saved a few bytes; not worth it.

## 3. Free memory and Z80/VDP traps

1. **Page 0 RAM the game doesn't use.** If the game runs without the BIOS, 0040h-00FFh and other low gaps can hold code. Find them with write watchpoints during long games. Both loaders (tape and ROM) must copy the code there.
2. **A dead tape loader.** Many tape games carry a copy of their loader and never use it: free space (here A5CFh-A66Dh).
3. **The interrupt reads port 99h.** If it arrives between the two bytes of a VRAM address, the address is wrong. Set the address with DI and restore the interrupt state (`ld a,i` / `jp po`). Because of this, a blinking icon in the status panel painted a bottle red.
4. **TMS9918:** 29-31 cycles between OUTs during the active display. The loop `out (98h),a / add a,h / djnz` takes 31 cycles.
5. **Loader stack:** check with an assert that the code doesn't reach the place where LOAD.BIN keeps its stack.

## 4. What didn't work

**Rotating the name table for horizontal scrolling** (sending only the new columns):

- In openMSX the loop went from 146 to 101 ms and the checker reported 0 errors.
- The tester (araubi) rejected it because it looks bad on MSX1: the name table changes all at once while the patterns arrive third by third.
- **Lesson:** measurements and the checker don't see what is on screen during the frame. Before accepting a transfer technique, watch it on MSX1 at real speed or with frame-by-frame captures.

## 5. Deliveries

1. **Rebuild from what you delivered.** Unpack it in an empty folder and check it gives the same SHA-1 as the ROM. A source package was missing doble.asm and nobody noticed until it was needed to go back.
2. **Keep the sources of every test build you send.** A copy of the sources, not just the ROM. If the tester (araubi) rejects the next one, you can go back without rebuilding.
3. **Keep the tools too.** The test scripts and the keys of each test go with the sources (here `src/openmsx/` and `tools/`).

## 6. MSX2, MSX2+ and turbo R

1. **Turbo R: slot 0 is expanded.** The tape's TEST.BIN looks for RAM with ENASLT and only restores A8h and the subslots of page 3. On turbo R it left page 0 without the BIOS and hung at the first interrupt. Save SLTTBL (FCC5h) at start-up and restore slot 0's subslot before the EI. On turbo R, call CHGCPU 81h (R800 ROM) if 002Dh ≥ 3. Always test with the real turbo R BIOS, not only C-BIOS.
2. **V9958: R#23 (vertical scroll) also moves the sprites.** Add R23 to the Y in the sprite attribute table. If it gives D0h, use D1h, because D0h ends the list. With R25/R26/R27 (horizontal), compare unsigned (`jr c`, not `jp m`), or it jumps at the right edge.
3. **MSX2+: the tester (araubi) rejects redrawing the frame to hide hardware scrolling.** It looks ugly. If the game has a frame and status panel inside the screen, a good software scroll that is the same on every MSX is better.
4. **A good reference: Pac-Mania for MSX2.** The whole map is pre-rendered in pages 2-3. Each frame copies the window with HMMM, draws the characters with LMMM TIMP and flips the page with R#2. About 7.5 frames/s, steps of 2 px in X and 6 px in Y. The frame and the status panel are never redrawn.
5. **Hidden page on MSX2** (doble.asm): two VRAM banks. The transfer goes to the hidden one and the interrupt switches R2/4/5/6/10 when it's done. Nothing is ever seen half-drawn.

## 7. Pace and speed comparisons

1. **Limiter with compensation.** Each loop lasts at least N frames (here 5 = 100 ms). If a loop takes longer (scrolling), the next ones are shortened until the average is met. The game runs at the same speed on MSX1, MSX2 and turbo R, and never faster than playable. On turbo R the R800 allows a finer scroll (step 1 instead of 6).
2. **Compare the original and the new version with the same key script.** A breakpoint on the main loop logs the time and the player's position. Results in frames per loop and in % (Black Beard: 9.30 → 5.25 frames, −44 % time, +77 % loops per second). Also measure real journeys (time to cross X pixels), because scrolling can add loops. Use each version's own keys (the original used Q/A/O/P).

## 8. Test tools that saved hours

1. **Load the original tape without waiting.** Breakpoints on TAPION (00E1h) and TAPIN (00E4h) serve the .cas bytes from Tcl (`src/openmsx/cinta.tcl` + `cas_prep.py`). The game starts in seconds, and the original's RAM can be dumped at start-up.
2. **The tester's .omr replays.** They are gzipped XML with snapshots that include RAM and VRAM. To reproduce a bug in a new ROM, inject the snapshot. If the ROM has changed since the recording, don't load its RAM as is: rebuild the version used for the recording (same SHA-1) and transplant only the bytes that differ between the two builds.
3. **Maps from RAM.** With the game's RAM at start-up and the tile drawing routine ported to Python, you get the full maps as PNG (herramientas/mapas.py and mapas_original.py).
4. **Sound effects from a PSG table.** Each entry has the number of pairs followed by register/value pairs. If the number doesn't match the pairs, it writes to registers that don't exist. A "cannon blast" uses noise (R6), all three voices on the envelope (R8-R10 = 10h), a slow R11-R13 and mixer 04h.
5. **Check the game logic before blaming the drawing.** "The torch doesn't disappear" turned out to be the camera removing the cannon's condition (window at the very top). Read what the original routine needs (here LB8FC) and check the new version doesn't break it.

## 9. Scrolling and transfers on MSX1: row-by-row transfer

araubi approved Black Beard's "row-by-row transfer" as the base for MSX1. What worked:

1. **A name table that serves the transfer.** If the game builds the screen by columns (character = column x 8 + row), use an alternative name table during the game (another VRAM area, changing R#2) where each character row is contiguous in VRAM. Each row is then sent in one go and at most one row is seen half-drawn. Go back to the original table when clearing the screen or when the game writes patterns on its own (menus, texts).
2. **Patterns, colour and sprites of the same row together.** First the row's patterns, then its colour, then the attributes of the sprites that change at that height. No more "colour jumps" (new drawing with old colour), and a sprite never sits on a background that isn't its own.
3. **Sprites in fixed slots.** Old ones in slots 0..N-1 and new ones hidden (Y=BFh) behind them; for each row only the Y bytes change (new visible, old hidden). Linked lists per row (first/next) avoid scanning all 32. If they don't fit (more than 32 old plus new), fall back to rewriting the table row by row.
4. **Always measure**: the time of a full transfer (breakpoints in openMSX) and an objective error metric (sprite pixels on the wrong ink). It went from 2322 to 658 pixels with 5 % more time.
5. **TMS9918: the fastest loop must leave 29 cycles between OUTs.** A 25-cycle loop worked on MSX2 and failed on MSX1, real or emulated: add a NOP.
6. **sjasmplus replaces defines inside other names** (-DFILAS broke VOLCADO_FILAS): use names that don't appear in labels (PORFILAS).
7. What did NOT work: rotating the name table by columns for horizontal steps (lateral.asm): it looks very bad on MSX1. Less work per frame, well ordered, is better than tricks that change the whole screen at once.

## 10. 64 KB ROM: always ASCII16

When the 32 KB ROM became too small it moved to 64 KB with a Konami mapper, and BlueMSX wouldn't start it. BlueMSX doesn't guess the mapper of a 64 KB ROM: without "AB" at 4000h it treats it as ASCII16. openMSX does count `LD (nn),A` writes to mapper registers. With ASCII16 and bank switches through `LD (77FFh),A`, both detect it on their own. Careful: the ASCII16 registers are at 6000h-7FFFh, so the bank switch has to happen while the ROM is still visible in page 1.

## 11. One Chip MSX loaders guess (and patch) the mapper

On a real One Chip MSX v1.0 hung, although it ran fine in openMSX and BlueMSX. The hardware was not to blame: the program that loads the ROM from SD was. SofaROM took it for "wide" ASCII8 and mglOCM, in automatic mode, for Konami. The bank switch at 77FFh, which moves page 8000h in ASCII16, hits another register in those mappers. Besides, SofaROM patches the `LD (nn),A` instructions it believes switch pages, and with unusual addresses (77FFh) it switches to a mode that patches more, including false sequences inside the compressed data.

* Make the ROM detect the mapper at boot and work with any of them (`multimapper.asm`).
* Switch banks with `LD (HL),n` and only at the standard addresses (ASCII16 6000h/7000h, ASCII8 6000h/6800h/7000h/7800h, SCC 5000h/7000h/9000h/B000h).
* Write 1 to 6800h before running anything at 6000h-7FFFh: an ASCII8 cartridge may boot with page 0 there too.
* Test in the emulator forcing each mapper (`openmsx -romtype ascii8 / konamiscc / konami`), because no emulator imitates those loaders.
* To diagnose remotely without the machine: a ROM that paints the border a different colour at each loading step, plus a video from the user.
