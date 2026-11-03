# tools

| | Español | English | 日本語 |
|---|---|---|---|
| `extrae_originales.py` | Saca de tu cinta original los 4 ficheros del juego que no van en el repositorio. | Extracts from your original tape the 4 game files not included in the repository. | リポジトリにないゲームの4ファイルを手持ちのテープから取り出します。 |
| `cbios50.py` | Hace las C-BIOS de 50 Hz para las máquinas de `src/openmsx/*.xml` (cópialas a `~/.openMSX/share/machines`). | Makes the 50 Hz C-BIOS ROMs for the machines in `src/openmsx/*.xml` (copy them to `~/.openMSX/share/machines`). | `src/openmsx/*.xml` のマシン用 50 Hz C-BIOS を作ります（`~/.openMSX/share/machines` にコピー）。 |
| `velocidad/` | Comparativa de velocidad: `cinta_mide.tcl` (cinta original) o `-cart` (ROM) + `mide.tcl`; `an.py` resume. Variables `LOG`, `TPULSA`, `KD/KI/KA/KB` (teclas). | Speed comparison: `cinta_mide.tcl` (original tape) or `-cart` (ROM) + `mide.tcl`; `an.py` summarises. Variables `LOG`, `TPULSA`, `KD/KI/KA/KB` (keys). | 速度比較：`cinta_mide.tcl`（オリジナルのテープ）か `-cart`（ROM）＋ `mide.tcl`。`an.py` で集計。変数 `LOG`、`TPULSA`、`KD/KI/KA/KB`（キー）。 |
| `pruebas/` | Verificador de VRAM por vuelta: `simbolos.sh` y luego `vp.sh MAQUINA ROM LOG`. | Per-loop VRAM checker: `simbolos.sh`, then `vp.sh MACHINE ROM LOG`. | ループごとの VRAM 検証：`simbolos.sh` の後に `vp.sh マシン ROM ログ`。 |

Ejemplo / example / 例 (openMSX, `xvfb-run` sin pantalla / headless):

```sh
cd tools/velocidad
LOG=rom.txt TPULSA=15 KD="8 0x80" KI="8 0x10" KA="8 0x20" KB="8 0x40" \
  openmsx -machine CB1_EU -cart ../../releases/BlackBeard_color.rom -script mide.tcl
python3 an.py rom.txt
```
