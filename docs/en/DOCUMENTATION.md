# Black Beard Enhanced: technical documentation

Black Beard (Topo Soft, 1988), MSX version. This document explains the disassembly, what was found in the game and everything that changes in the Enhanced version. Labels and comments in the source code are in Spanish; the names used here are the ones in the code.

## 1. The original game

### Credits

According to [Computer Emuzone](https://computeremuzone.com/ficha/242/black-beard&pg=manual):

* Program: Carlos Arias Alonso.
* Graphics: Roberto Potenciano Acebes. The game writes "ROBERTO P. ACEVES".
* Music: César Astudillo (Gominolas).
* Cover: Alfonso Azpiri.
* Support software: José Manuel Lazo.
* Publisher: Erbe Software.

The loading screen is signed "-ACE-", probably Roberto Potenciano Acebes (not confirmed).

### Known versions

| Version | Notes |
|---|---|
| `Blackbeard (1988)(Topo Soft)(ES)[RUN'CAS-'].cas` (SHA-1 aad3641a…) | Base of the disassembly. |
| `Black Beard (1988)(Topo Soft)(ES)[!][RUN'CAS-'][v0.8b].tsx` | **The real tape.** The game blocks use the Spectrum format (TZX ID 10h blocks) with their own loader. Only A5CFh-A66Dh differs (curiosity 4). |
| `Black Beard (1988)(Topo Soft - Kixx)(GB)[RUN'CAS-'][v0.8.2b].tsx` | The real Kixx tape: same as the Spanish one except the texts. |
| `Blackbeard (…)[Kixx edition][RUN'CAS-'][!].cas` | The Kixx edition as .cas. |
| Disks `(ES).dsk`, `[a].dsk`, `[a2].dsk` and ROM `(ES).rom` | Disk and ROM conversions with **3 changed bits**: A7FBh E1→E0, B5BDh 81→01 and C8D2h 77→37. |
| ROM `[h tape2rom Kabish]` | The same, but only with the last two bits. |
| Disk `(ES)(en).dsk` | English texts different from Kixx, plus the 3 bits. |
| ROM `[BetterMSX]` | Heavily reorganised 64 KB ROM; not analysed. |

**The 3 bits** look like dump errors inherited from a single copy (each one flips one bit):

* At A7FBh, `POP HL` becomes `RET PO`. Just before it a `DEC C` leaves P/V at 0, so the `RET PO` is always taken and jumps to a data address on the stack: that branch of the figure clipping should crash or draw garbage (not tested).
* At B5BDh, `ADD A,C` becomes an `LD BC,nn` that swallows the following `AND 0FCh`. That code compares the player's position with an object's.
* C8D2h is inside a data table.

This might be the "MSX version bug" that Computer Emuzone mentions. The .cas and both TSX tapes don't have it.

**The Kixx edition** only changes 202 bytes of text (9ED0h-A3A0h) and the BALAS label in the status panel, which becomes BULLETS (42 bytes at 6028h-63EEh). The Kixx .cas has an extra 1Fh byte before each header, which doesn't affect loading.

### Tape structure

1. **TOPO** (BASIC): `BLOAD"CAS:LOGOTOPO.CM",R`, the animated Topo logo (9470h-A50Dh).
2. **BLACK** (BASIC): `BLOAD"CAS:LOAD.BIN"`, `BLOAD"CAS:TEST.BIN"` and `DEF USR=55000`.
3. **LOAD.BIN** (D6D8h): the loader. It calls the BIOS through a routine it sets up at FC9Ah, which switches page 0 between BIOS and RAM for every byte.
4. **TEST.BIN** (C350h): looks for the RAM of pages 0, 1 and 2.
5. Four headerless blocks (FFh, data and an XOR byte):
   * 9C40h, 7098 bytes: the loading screen, run before loading continues. The colour is compressed (one byte per 8 lines).
   * 2328h, 13000 bytes: 32x32 tiles, 144 bytes each (128 of pattern and 16 of colour).
   * 55F0h, 10752 bytes: status panel, figures and map.
   * 8400h, 20479 bytes: the code (up to BA7Dh) and data.

At the end it jumps to 92ACh with DI and all four pages in RAM. The BIOS is not used during the game: the game writes its own `JP` at 0038h.

### Memory map during the game

* 03E8h-1C67h: play area buffer, 28 bytes x 224 lines (7x7 tiles).
* 1C68h-1F77h: colour buffer, computed by the original but never used (curiosity 2).
* 8E20h-8E6xh: variables (8E26h lives, 8E45h map pointer, 8E47h buffer pointer, 8E23h/8E24h player position).
* 900Ch: enemy table (9 x 7 bytes).
* D3FFh-F37Fh: free. FDE8h: stack.

### Curiosities

1. **Infinite lives cheat.** Press **U, X, Y and Z together** during the game (keyboard row 5 must read 1Bh). The game replaces the `DEC A` at 960Ah with `OR A` and lives no longer go down. We haven't seen it documented.
2. **The play area was meant to be in colour.** After the `JP` that ends `VUELCA_PANTALLA` (9BC5h) there is a routine that sends the colour table, and it never runs. The game still computes that colour buffer every loop (`COLOR_LOSETA`, 9CC4h), about 19 % of the time for nothing. If it is re-enabled almost everything turns black: `CONVIERTE_COLOR` (9C27h) looks up the ink twice in the table, so ink and paper come out the same. The colours of each tile are the Spectrum attributes, identical byte for byte.
3. **Leftovers of a STOP key.** STOP is read at 9363h (row 7, bit 4), but the jump that followed was replaced by three `NOP`s.
4. **A forgotten loader, and the .cas is not the tape as it was.** At A5CFh there is an unused copy of the loading routine. On the real tape (TSX), LOAD.BIN uses a Spectrum-style loader that reads bit 7 of PSG register 14, with the blocks recorded in the Spectrum format and timings. Whoever converted the tape to .cas replaced that loader with one that calls the BIOS, both in LOAD.BIN and in the copy at A5CFh. With `-DCINTA_TSX`, block 8400h comes out identical to the TSX one.
5. **An unused return to BASIC.** INICIO saves the BASIC stack at 9667h; at B00Ch there is a routine that restores it and returns, but nothing calls it.
6. **Default keys of the original: Q, A, O, P and SPACE** (table at 9C87h). There is also joystick support.
7. **Kixx translation mistakes:** "YOUR AMMUNITION GO DOWN AND CANNOT OPEN THE CHEST", "THE TREASURE MAP IN IN YOURS HANDS" and "ESPACIO" left untranslated. The Spanish one writes "PORFIN" as one word.
8. **The main loop doesn't wait for the vertical blank**, so the speed depends on what is on screen.

### Music: MSX, Amstrad and Spectrum

* **MSX and Amstrad use exactly the same music**: the same player, the same 521 bytes of data (8BF5h on MSX, 226Ah on the CPC) and the same 94-note table. Running both players for 15,000 frames, the PSG registers are identical (except the noise register, which is never heard). The piece lasts 69.1 s.
* **The MSX is in tune and the Amstrad is almost a seventh lower.** The table is computed for a ~1.78 MHz PSG (the first note, 3405, gives C1 at 32.85 Hz on the MSX). The CPC has its PSG at 1 MHz and uses the same table, so everything sounds 10.1 semitones lower. The tempo is the same.
* According to César Astudillo "Gominolas", the version that sounds the way he wanted is the CPC one. That's why the Enhanced version uses the CPC tuning (see 3.10).
* On a 60 Hz MSX the music plays 20 % faster, because it advances with the VDP interrupt.
* The Spectrum 48K one uses the beeper with a different player; it seems to be another arrangement in another key.

## 2. The disassembly

The sources are in `src/`, for **sjasmplus 1.24.0**, about 7000 lines. `python3 build.py` rebuilds the Spanish tape **byte for byte identical** to the original (it checks the SHA-1). `python3 build.py kixx` produces the four Kixx blocks, and `-DCINTA_TSX` the 8400h block of the real tape.

How it was done: static tracing from the entry points (92ACh, the two interrupts at 8400h and A3CCh and the music command table at 8926h), coverage taken in openMSX while playing, and a few entry points added by hand (`src/herramientas/z80trace.py`, `hacer.py`, `post2.py`). Result: 10,273 bytes of code. Texts appear as `db "..."`. Known routines have Spanish names and comments; the rest remain `Lxxxx`.

The tile and figure graphics (`graficos/*.bin`) and the two BASIC loaders are not in the repository: extract them from your own tape with `tools/extrae_originales.py`.

### Profile of the original (openMSX, European MSX1, PAL)

| | Original |
|---|---|
| Loops per second | **5.1** (195 ms, about 10 frames) |
| `DIBUJA_FONDO` (983Dh): redraws the whole buffer | 95.5 ms (49 %) |
| `VUELCA_PANTALLA` (9BA7h): sends 3 x 1536 bytes to the VDP | 63.7 ms (33 %) |
| Everything else | 35 ms |

Every loop the original redraws the 49 tiles of the buffer and sends it all to the VDP, even without scrolling. Scrolling moves in steps of 8 lines. The characters are drawn into the buffer with masks.

### Figures

The game doesn't use VDP sprites: it draws the figures into the buffer with masks (each line, N bytes of AND mask and N bytes of OR drawing). LAD5Bh clips; 96BAh draws the 24x24 ones and AC1Fh the rest. There are 27 24x24 figures at 4608h-55C7h, 7 at 55F0h-59DFh, 19 16x16 objects (59E0h-5ADFh and 5AF0h-5EAFh) and the 8x8 bullet at 5AE0h.

## 3. The Enhanced version

Everything new is built with `python3 build.py color` (tape) and `python3 rom/build_rom.py` (ROM). The game logic doesn't change except where noted.

### 3.1 Basic speed-up (`-DACELERA`)

* The unused colour buffer is no longer computed.
* The VDP transfer is unrolled: from 47 to 32 cycles per byte (above the ~29 the TMS9918 needs during the active display).
* Default keys: cursor keys and SPACE (H is still pause). They can be redefined as before.
* Result: 29 % more loops per second. These are the "acelerado" tapes.

### 3.2 Play area in colour (`-DCOLOREA`)

* The 90 MSX tiles are the Spectrum ones, with their 16 attributes included. The game already replaced paper 0 and 1 with the colour of each map cell, like on the Spectrum.
* A 256-byte table (`tabla_color.asm`, from `herramientas/tabla_color.py`) maps Spectrum attributes to MSX colours: black 1, blue 4/5, red 6/8, magenta D, green C/3, cyan 7, yellow A/B and white E/F.
* Each cell remembers which tile and colour it drew: if nothing changes, nothing is recomputed.

### 3.3 Sprites under the characters (`-DFIGURAS_SPR`)

* The "white" of the 24x24 figures (where the mask clears and the drawing doesn't paint) is filled with colour 9 (light red) VDP sprites; the player's in cyan (7).
* 96BAh records every figure it draws (up to 8 per loop); the patterns use two banks (3800h and 3C00h) and the attributes are sent with each part of the transfer, so a sprite is never ahead of or behind its figure.
* If one figure overlaps another, its pattern is built by reading the buffer, so it doesn't cover the ink of the one in front.
* The halo of the figures is trimmed following a sheet retouched by araubi (`graficos/figuras_retocadas_x4.png` → `herramientas/retoque_figuras.py` → `retoque_figuras.asm`): only mask bits change.
* **Potion:** while it lasts (8E3Ch, 100 loops) the player turns light green; in the last 2 seconds it blinks between green and cyan every ~0.25 s and goes back to cyan (`COLOR_JUGADOR`, `desplaza.asm`).
* **Torch in hand** with a colour 8 sprite and trimmed halo (`antorcha.asm`, `herramientas/antorcha.py`).

### 3.4 Partial redraw and frame limiter (`-DSOLO_CAMBIOS`)

* Figures and objects record which characters they cover. In the next loop only those are restored from the tiles, and only those and the newly drawn ones are sent to the VDP (`parcial.asm`).
* Everything is redone as before when the map section changes, when the window moves, or when something writes on its own (transitions, menus, texts).
* Colour is only sent where it changes (`SOMBRA` keeps what is already in VRAM).
* **Limiter:** the interrupt counts frames and the transfer doesn't start until 5 have passed since the previous one (100 ms; at 60 Hz it waits 6, so the pace is the same). After a slow loop, the next ones don't wait until at most one loop is recovered. The loader copies BIOS byte 002Bh to know the frequency. `limite=N` changes it.
* **DI when setting the VDP address:** the interrupt reads port 99h; if it arrives between the two bytes of an address, the write lands somewhere else (the original has the same latent bug; here it painted a bottle of the status panel red).

### 3.5 Row-by-row transfer (`-DPORFILAS`)

During the game there is a row-ordered name table at 1C00h and each row is sent complete: patterns, colour and the sprites that change at that height (`filas.asm`, `filas_alto.asm`). At most one row is seen half-drawn, and sprites never sit on a background that isn't theirs. See `LESSONS.md`.

### 3.6 Scrolling that follows the player (`scroll.asm`, `desplaza.asm`)

* A 72x72 square in the centre of the 192x192 window: while the player is inside, the screen doesn't move; when the player leaves it, the screen follows.
* **Vertical, pixel by pixel:** the buffer has 4 spare character rows, so it is enough to start the transfer FINO lines lower (0-7). The camera follows each player step (6 px; `salto=N`). In SCREEN 2 each character takes 8-FINO lines of its row's attribute and FINO of the next one.
* **Horizontal, 8 pixels at a time** (pixel scrolling would cost about 90 ms more per loop).
* **No hiccup when the map moves a tile:** if the map moved exactly one row or one column, the buffers are shifted and only the 7 new tiles are drawn (from about 92 to 59 ms).
* **Cannon:** with the torch, the shot only fires from behind the cannon and with the window at the very top. `CANON_QUIETO` keeps the camera still there and during the shot, and the shot plays a new cannon blast (`EFECTO_CANON`).

### 3.7 MSX2, MSX2+ and turbo R

* **Hidden page** (`doble.asm`): with 002Dh ≥ 1 there are two copies of the screen in VRAM (0000h and 4000h). The transfer goes to the hidden one and the interrupt switches registers 2, 4, 5, 6 and 10: patterns, colour and sprites appear at once.
* **Turbo R:** slot 0 is expanded. TEST.BIN left page 0 without the BIOS and the first interrupt hung; the ROM saves SLTTBL beforehand and restores the subslot (`REPON_SLOT0`). It also calls CHGCPU with 81h (R800) and the camera follows every pixel.
* V9958 hardware scrolling (R#23, R#26/R#27, `hw.asm`) was tried and dropped: it required rebuilding the status panel and looked ugly. It is still in the sources (`build.py ... hw`).

### 3.8 Stairs, language and texts

* **Stairs without fire:** just step on them (`escaleras.asm`); arriving on the other deck doesn't bounce back. Fire always shoots.
* **Language in the menu:** "4.- ESPAÑOL" / "4.- ENGLISH" switches all texts (with a hand-drawn Ñ, code 7Fh) and the BALAS/BULLETS label (`idioma.asm`; the table is at E294h-E3FFh).
* Corrected English: "YOU HAVE RUN OUT OF AMMO AND CANNOT OPEN THE OTHER CHESTS", "BE MORE CAREFUL NEXT TIME", "THE TREASURE MAP IS AT LAST IN YOUR HANDS". In Spanish, "POR FIN".

### 3.9 Recoloured status panel (`-DMRUBEN`)

araubi recoloured the status panel (skull, bottles, portrait with hat and coat, face and parrot). In SCREEN 2 each 8-pixel line allows 2 colours; lines with 3 were adjusted to the closest one (`graficos/marcador_ruben_ajustado.png` → `herramientas/marcador.py` → `marcador.asm`).

### 3.10 Music with the CPC tuning (`-DAFINA_CPC`)

The note table (8866h, 96 periods) is multiplied by 1.7897725 (`afina_cpc.asm`, from `herramientas/afina_cpc.py`): the 7,176 notes play at the same frequency as on the CPC (13 cents at most). `musica_msx` keeps the MSX tuning.

### 3.11 ROM

* **64 KB, ASCII16 mapper.** BlueMSX treats any 64 KB ROM without "AB" at 4000h as ASCII16, and openMSX deduces it from the writes to 77FFh, so both detect it on their own. Bank 0 at 4000h; bank 1 (logo and what goes to page 3) and bank 2 (tiles) at 8000h. Banks are switched while the ROM is still in page 1.
* Blocks compressed with **ZX0** (Einar Saukas; decompressor by Einar Saukas and Urusergi, BSD 3-Clause licence, `src/rom/LICENSE_ZX0.txt`).
* It does the same as the tape: `COLOR 1,1,1:SCREEN 2`, Topo logo, loading screen and game. It uses the tape's own TEST.BIN to find the RAM, so it needs 64 KB.
* Tested in openMSX with C-BIOS (European and Japanese MSX1, MSX2, MSX2+) and with the real BIOS of HB-20P, HB-F900, FS-A1ST and FS-A1GT: on reaching 92ACh the RAM is identical to what the tape leaves (except the frequency byte) and the VRAM checker reports no errors.

## 4. Speed: original vs Enhanced

openMSX, MSX1 PAL (C-BIOS), the same key script on the original tape and on the ROM. 50 Hz frames per main loop (9317h):

| Situation | Original | Enhanced | Time per loop | Loops per second |
|---|---|---|---|---|
| Standing still | 9.20 | 5.04 | −45 % | +83 % |
| Walking | 9.28 | 5.37 | −42 % | +73 % |
| Stairs (with vertical scroll) | 9.31 | 5.74 | −38 % | +62 % |
| **Average** | **9.30** | **5.25** | **−44 %** | **+77 %** |

Walking 48 px goes from 1.46 s to 0.80 s; climbing 90 px of stairs, from 2.82 s to 2.14 s. The 5-frame minimum is set by the limiter. Scripts in `tools/velocidad/`.

## 5. How it was tested

* `src/openmsx/verif_parcial.tcl`: after every loop it compares the VRAM (patterns, colour, name table) with the game buffer. Thousands of loops on HB-20P, HB-F900, FS-A1ST and FS-A1GT, scrolling in both directions, with no differences. Launcher: `tools/pruebas/vp.sh`.
* `src/openmsx/cinta.tcl` + `cas_prep.py`: load the tape instantly (breakpoints on TAPION/TAPIN) and dump the RAM on reaching 92ACh; `compara_rom.py` compares it with the blocks.
* `src/openmsx/analiza.py`: checks that the sprites match the paper of the figures and don't cover ink.
* openMSX `.omr` replays: to reproduce a bug seen while playing, the snapshot is injected into the new ROM, transplanting only the bytes that differ between builds.
* 50 Hz C-BIOS machines in `src/openmsx/*.xml` (create the ROMs with `tools/cbios50.py`).
