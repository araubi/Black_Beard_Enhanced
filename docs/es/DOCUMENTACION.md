# Black Beard Enhanced: documentación técnica

Black Beard (Topo Soft, 1988), versión MSX. Este documento explica el desensamblado, lo que se ha encontrado en el juego y todo lo que cambia en la versión mejorada (Enhanced).

## 1. El juego original

### Créditos

Según la ficha de [Computer Emuzone](https://computeremuzone.com/ficha/242/black-beard&pg=manual):

* Programa: Carlos Arias Alonso.
* Gráficos: Roberto Potenciano Acebes. El juego escribe «ROBERTO P. ACEVES».
* Música: César Astudillo (Gominolas).
* Portada: Alfonso Azpiri.
* Software de apoyo: José Manuel Lazo.
* Distribuidor: Erbe Software.

La pantalla de carga va firmada «-ACE-», seguramente Roberto Potenciano Acebes (no comprobado).

### Versiones conocidas

| Versión | Qué tiene |
|---|---|
| `Blackbeard (1988)(Topo Soft)(ES)[RUN'CAS-'].cas` (SHA-1 aad3641a…) | Base del desensamblado. |
| `Black Beard (1988)(Topo Soft)(ES)[!][RUN'CAS-'][v0.8b].tsx` | **La cinta real.** Los bloques del juego van en formato Spectrum (bloques ID 10h de TZX) con un cargador propio. Solo cambia A5CFh-A66Dh (curiosidad 4). |
| `Black Beard (1988)(Topo Soft - Kixx)(GB)[RUN'CAS-'][v0.8.2b].tsx` | La Kixx real: igual que la española salvo los textos. |
| `Blackbeard (…)[Kixx edition][RUN'CAS-'][!].cas` | La Kixx en .cas. |
| Discos `(ES).dsk`, `[a].dsk`, `[a2].dsk` y ROM `(ES).rom` | Pasos a disco y ROM con **3 bits cambiados**: A7FBh E1→E0, B5BDh 81→01 y C8D2h 77→37. |
| ROM `[h tape2rom Kabish]` | Igual, pero solo con los dos últimos bits. |
| Disco `(ES)(en).dsk` | Textos en inglés distintos de los de Kixx, más los 3 bits. |
| ROM `[BetterMSX]` | ROM de 64 KB muy reorganizada; no analizada. |

**Los 3 bits** parecen errores de volcado heredados de una misma copia (cada uno cambia un único bit):

* En A7FBh, `POP HL` pasa a `RET PO`. Justo antes hay un `DEC C` que deja P/V a 0, así que el `RET PO` se cumple siempre y salta a una dirección de datos de la pila: esa rama del recorte de figuras debería colgarse o pintar basura (no probado).
* En B5BDh, `ADD A,C` pasa a ser un `LD BC,nn` que se traga el `AND 0FCh` siguiente. Ese código compara la posición del jugador con la de un objeto.
* C8D2h está en una tabla de datos.

Quizá sea el «bug de la versión MSX» que menciona Computer Emuzone. La cinta .cas y las dos TSX no lo tienen.

**La edición Kixx** solo cambia 202 bytes de textos (9ED0h-A3A0h) y el rótulo BALAS del marcador, que pasa a BULLETS (42 bytes en 6028h-63EEh). El .cas de la Kixx tiene un byte 1Fh de más delante de cada cabecera, que no afecta a la carga.

### Estructura de la cinta

1. **TOPO** (BASIC): `BLOAD"CAS:LOGOTOPO.CM",R`, el logotipo animado de Topo (9470h-A50Dh).
2. **BLACK** (BASIC): `BLOAD"CAS:LOAD.BIN"`, `BLOAD"CAS:TEST.BIN"` y `DEF USR=55000`.
3. **LOAD.BIN** (D6D8h): el cargador. Llama a la BIOS desde una rutina que monta en FC9Ah, que conmuta la página 0 entre BIOS y RAM en cada byte.
4. **TEST.BIN** (C350h): busca la RAM de las páginas 0, 1 y 2.
5. Cuatro bloques sin cabecera (FFh, datos y un byte XOR):
   * 9C40h, 7098 bytes: la pantalla de carga, que se ejecuta antes de seguir cargando. El color va comprimido (un byte por cada 8 líneas).
   * 2328h, 13000 bytes: losetas de 32x32, 144 bytes cada una (128 de patrón y 16 de color).
   * 55F0h, 10752 bytes: marcador, figuras y mapa.
   * 8400h, 20479 bytes: el código (hasta BA7Dh) y datos.

Al terminar salta a 92ACh con DI y las cuatro páginas en RAM. Durante la partida no se usa la BIOS: el juego escribe su propio `JP` en 0038h.

### Mapa de memoria durante la partida

* 03E8h-1C67h: búfer del área de juego, 28 bytes x 224 líneas (7x7 losetas).
* 1C68h-1F77h: búfer de color, que el original calcula pero no usa (curiosidad 2).
* 8E20h-8E6xh: variables (8E26h vidas, 8E45h puntero del mapa, 8E47h puntero del búfer, 8E23h/8E24h posición del jugador).
* 900Ch: tabla de enemigos (9 x 7 bytes).
* D3FFh-F37Fh: libre. FDE8h: pila.

### Curiosidades

1. **Truco de vidas infinitas.** Pulsa **U, X, Y y Z a la vez** durante la partida (la fila 5 del teclado tiene que valer 1Bh). El juego cambia el `DEC A` de 960Ah por `OR A` y las vidas ya no bajan. No lo hemos visto documentado.
2. **El área de juego iba a ser en color.** Detrás del `JP` que cierra `VUELCA_PANTALLA` (9BC5h) queda una rutina que vuelca la tabla de color y nunca se ejecuta. El juego sigue calculando cada vuelta ese búfer de color (`COLOR_LOSETA`, 9CC4h), cerca del 19 % del tiempo para nada. Si se reactiva, casi todo sale negro: `CONVIERTE_COLOR` (9C27h) busca dos veces la tinta en la tabla, así que tinta y papel salen iguales. Los colores de cada loseta son los atributos del Spectrum, idénticos byte a byte.
3. **Restos de una tecla STOP.** En 9363h se lee STOP (fila 7, bit 4), pero el salto que venía después se cambió por tres `NOP`.
4. **Cargador olvidado, y el .cas no es la cinta tal cual.** En A5CFh hay una copia sin usar de la rutina de carga. En la cinta real (TSX) LOAD.BIN usa un cargador tipo Spectrum que lee el bit 7 del registro 14 del PSG, con los bloques grabados con el formato y los tiempos del Spectrum. Quien pasó la cinta a .cas cambió ese cargador por uno que llama a la BIOS, en LOAD.BIN y en la copia de A5CFh. Con `-DCINTA_TSX`, el bloque 8400h sale idéntico al de la TSX.
5. **Vuelta al BASIC sin usar.** INICIO guarda la pila del BASIC en 9667h; en B00Ch hay una rutina que la recupera y vuelve, pero nadie la llama.
6. **Teclas por defecto del original: Q, A, O, P y ESPACIO** (tabla en 9C87h). También hay joystick.
7. **Traducción Kixx con fallos:** «YOUR AMMUNITION GO DOWN AND CANNOT OPEN THE CHEST», «THE TREASURE MAP IN IN YOURS HANDS» y «ESPACIO» sin traducir. En la española, «ESTA PORFIN EN TU PODER» va junto.
8. **El bucle principal no espera al barrido vertical**, así que la velocidad depende de lo que haya en pantalla.

### Música: MSX, Amstrad y Spectrum

* **MSX y Amstrad usan exactamente la misma música**: el mismo reproductor, los mismos 521 bytes de datos (8BF5h en MSX, 226Ah en el CPC) y la misma tabla de 94 notas. Ejecutando los dos reproductores 15.000 cuadros, los registros del PSG son idénticos (salvo el de ruido, que nunca se oye). La pieza dura 69,1 s.
* **El MSX suena afinado y el Amstrad casi una séptima más grave.** La tabla está calculada para un PSG de ~1,78 MHz (la primera nota, 3405, da Do1 a 32,85 Hz en el MSX). El CPC tiene el PSG a 1 MHz y usa la misma tabla, así que todo suena 10,1 semitonos más grave. El ritmo es el mismo.
* Según contó César Astudillo «Gominolas», la versión que suena como él la quería es la de CPC. Por eso la versión mejorada lleva la afinación del CPC (ver 3.10).
* En un MSX de 60 Hz la música va un 20 % más deprisa, porque avanza con la interrupción del VDP.
* La del Spectrum 48K va por el beeper con otro reproductor; parece otro arreglo y otra tonalidad.

## 2. El desensamblado

Las fuentes están en `src/`, para **sjasmplus 1.24.0**, unas 7000 líneas. `python3 build.py` rehace la cinta española **idéntica byte a byte** a la original (lo comprueba con el SHA-1). Con `python3 build.py kixx` salen los cuatro bloques de la Kixx, y con `-DCINTA_TSX` el bloque 8400h de la cinta real.

Cómo se sacó: trazado estático desde las entradas (92ACh, las dos interrupciones 8400h y A3CCh y la tabla de órdenes de la música 8926h), cobertura tomada en openMSX jugando y algunas entradas a mano (`src/herramientas/z80trace.py`, `hacer.py`, `post2.py`). Resultado: 10.273 bytes de código. Los textos salen como `db "..."`. Las rutinas conocidas llevan nombre en castellano y comentario; el resto queda como `Lxxxx`.

Los gráficos de las losetas y las figuras (`graficos/*.bin`) y los dos BASIC no van en el repositorio: se sacan de tu propia cinta con `tools/extrae_originales.py`.

### Perfilado del original (openMSX, MSX1 europeo, PAL)

| | Original |
|---|---|
| Vueltas por segundo | **5,1** (195 ms, unos 10 cuadros) |
| `DIBUJA_FONDO` (983Dh): redibuja el búfer entero | 95,5 ms (49 %) |
| `VUELCA_PANTALLA` (9BA7h): manda 3 x 1536 bytes al VDP | 63,7 ms (33 %) |
| Todo lo demás | 35 ms |

El original redibuja cada vuelta las 49 losetas del búfer y lo vuelca entero al VDP aunque no haya scroll. El scroll va a saltos de 8 líneas. Los personajes se pintan dentro del búfer con máscara.

### Figuras

El juego no usa sprites del VDP: dibuja las figuras en el búfer con máscara (cada línea, N bytes de máscara AND y N de dibujo OR). LAD5Bh recorta; 96BAh dibuja las de 24x24 y AC1Fh las demás. Hay 27 figuras de 24x24 en 4608h-55C7h, 7 en 55F0h-59DFh, 19 objetos de 16x16 (59E0h-5ADFh y 5AF0h-5EAFh) y la bala de 8x8 en 5AE0h.

## 3. La versión mejorada (Enhanced)

Todo lo nuevo entra con `python3 build.py color` (cinta) y `python3 rom/build_rom.py` (ROM). La lógica del juego no cambia salvo donde se dice.

### 3.1 Aceleración básica (`-DACELERA`)

* Se deja de calcular el búfer de color que el original no usa.
* El volcado al VDP se desenrolla: de 47 a 32 ciclos por byte (por encima de los ~29 que necesita el TMS9918 durante la imagen).
* Teclas por defecto: cursores y ESPACIO (H sigue siendo la pausa). Se pueden redefinir como antes.
* Resultado: un 29 % más de vueltas por segundo. Son las cintas «acelerado».

### 3.2 Área de juego en color (`-DCOLOREA`)

* Las 90 losetas del MSX son las del Spectrum con sus 16 atributos incluidos. El juego ya cambiaba el papel 0 y 1 por el color de cada casilla, como en Spectrum.
* Una tabla de 256 bytes (`tabla_color.asm`, de `herramientas/tabla_color.py`) pasa el atributo Spectrum a colores MSX: negro 1, azul 4/5, rojo 6/8, magenta D, verde C/3, cian 7, amarillo A/B y blanco E/F.
* Cada casilla recuerda qué loseta y qué color pintó: si no cambia, no se recalcula.

### 3.3 Sprites bajo los personajes (`-DFIGURAS_SPR`)

* El «blanco» de las figuras de 24x24 (donde la máscara borra y el dibujo no pinta) se rellena con sprites del VDP de color 9 (rojo claro); el del jugador en cian (7).
* 96BAh apunta cada figura dibujada (hasta 8 por vuelta); los patrones van en dos bancos (3800h y 3C00h) y los atributos se mandan con cada parte del volcado, para que el sprite no se adelante ni se retrase respecto a su figura.
* Si una figura se monta sobre otra, su patrón se arma leyendo el búfer, para no tapar la tinta de la de delante.
* El halo de las figuras se recorta según una hoja retocada por araubi (`graficos/figuras_retocadas_x4.png` → `herramientas/retoque_figuras.py` → `retoque_figuras.asm`): solo cambian bits de máscara.
* **Pócima:** mientras dura (8E3Ch, 100 vueltas) el jugador pasa a verde claro; en los 2 últimos segundos parpadea entre verde y cian cada ~0,25 s y vuelve a cian (`COLOR_JUGADOR`, `desplaza.asm`).
* **Antorcha en la mano** con sprite de color 8 y halo recortado (`antorcha.asm`, `herramientas/antorcha.py`).

### 3.4 Redibujado parcial y limitador (`-DSOLO_CAMBIOS`)

* Las figuras y los objetos apuntan qué caracteres pisan. En la vuelta siguiente solo se restauran esos desde las losetas, y al VDP solo van esos y los recién pintados (`parcial.asm`).
* Todo se rehace como antes cuando cambia el trozo de mapa, cuando se mueve la ventana o cuando algo escribe por su cuenta (transiciones, menús, textos).
* El color solo se manda donde cambia (`SOMBRA` guarda lo que ya hay en VRAM).
* **Limitador:** la interrupción cuenta imágenes y el volcado no empieza hasta que han pasado 5 desde el anterior (100 ms; a 60 Hz espera 6, así que el ritmo es el mismo). Tras una vuelta lenta, las siguientes no esperan hasta recuperar como mucho una vuelta. El cargador copia el byte 002Bh de la BIOS para saber la frecuencia. `limite=N` lo cambia.
* **DI al fijar la dirección del VDP:** la interrupción lee el puerto 99h; si llega entre los dos bytes de una dirección, la escritura cae en otro sitio (el original tiene el mismo fallo latente; aquí pintaba de rojo una botella del marcador).

### 3.5 Volcado por filas (`-DPORFILAS`)

Durante la partida hay una tabla de nombres por filas en 1C00h y cada fila se manda entera: patrones, color y los sprites que cambian a esa altura (`filas.asm`, `filas_alto.asm`). Lo que se ve a medias es, como mucho, una fila, y los sprites nunca quedan sobre un fondo que no les toca. Ver `LECCIONES.md`.

### 3.6 Scroll que sigue al jugador (`scroll.asm`, `desplaza.asm`)

* Un cuadrado de 72x72 en el centro de la ventana de 192x192: mientras el jugador está dentro, la pantalla no se mueve; cuando sale, la pantalla le sigue.
* **Vertical al píxel:** el búfer tiene 4 filas de margen, así que basta con volcar desde FINO líneas más abajo (0-7). La cámara sigue cada paso del jugador (6 px; `salto=N`). En SCREEN 2 cada carácter lleva 8-FINO líneas del atributo de su fila y FINO de la siguiente.
* **Horizontal de 8 en 8 píxeles** (al píxel costaría unos 90 ms más por vuelta).
* **Sin tirón al cambiar de loseta:** si el mapa se movió justo una fila o una columna, se desplazan los búferes y solo se dibujan las 7 losetas nuevas (de unos 92 a 59 ms).
* **Cañón:** con la antorcha, el disparo solo sale detrás del cañón y con la ventana arriba del todo. `CANON_QUIETO` deja la cámara quieta allí y durante el disparo, y el disparo suena con un cañonazo nuevo (`EFECTO_CANON`).

### 3.7 MSX2, MSX2+ y turbo R

* **Copia oculta** (`doble.asm`): con 002Dh ≥ 1 hay dos copias de la pantalla en VRAM (0000h y 4000h). Se vuelca en la que no se ve y la interrupción cambia los registros 2, 4, 5, 6 y 10: patrones, color y sprites aparecen a la vez.
* **Turbo R:** el slot 0 está expandido. TEST.BIN dejaba la página 0 sin BIOS y la primera interrupción colgaba; la ROM guarda SLTTBL antes y repone el subslot (`REPON_SLOT0`). Además llama a CHGCPU con 81h (R800) y la cámara sigue cada píxel.
* El scroll por hardware del V9958 (R#23, R#26/R#27, `hw.asm`) se probó y se descartó: obligaba a recomponer el marcador y quedaba feo. Sigue en las fuentes (`build.py ... hw`).

### 3.8 Escaleras, idioma y textos

* **Escaleras sin disparo:** basta con pisarlas (`escaleras.asm`); al llegar a la otra planta no rebota. El disparo siempre dispara.
* **Idioma en el menú:** «4.- ESPAÑOL» / «4.- ENGLISH» cambia todos los textos (con la Ñ dibujada, código 7Fh) y el rótulo BALAS/BULLETS (`idioma.asm`; la tabla va en E294h-E3FFh).
* Inglés corregido: «YOU HAVE RUN OUT OF AMMO AND CANNOT OPEN THE OTHER CHESTS», «BE MORE CAREFUL NEXT TIME», «THE TREASURE MAP IS AT LAST IN YOUR HANDS». En español, «POR FIN».

### 3.9 Marcador recoloreado (`-DMRUBEN`)

araubi recoloreó el marcador (calavera, botellas, retrato con sombrero y casaca, cara y loro). En SCREEN 2 cada línea de 8 píxeles admite 2 colores; las líneas con 3 se ajustaron al más parecido (`graficos/marcador_ruben_ajustado.png` → `herramientas/marcador.py` → `marcador.asm`).

### 3.10 Música con la afinación del CPC (`-DAFINA_CPC`)

La tabla de notas (8866h, 96 periodos) se multiplica por 1,7897725 (`afina_cpc.asm`, de `herramientas/afina_cpc.py`): las 7.176 notas salen a la misma frecuencia que en el CPC (13 cents como mucho). `musica_msx` deja la del MSX.

### 3.11 ROM

* **64 KB, mapper ASCII16.** BlueMSX trata cualquier ROM de 64 KB sin «AB» en 4000h como ASCII16, y openMSX lo deduce de las escrituras en 77FFh, así que los dos la reconocen solos. Banco 0 en 4000h; banco 1 (logo y lo que va a la página 3) y banco 2 (losetas) en 8000h. Se cambia de banco con la ROM aún en la página 1.
* Bloques comprimidos con **ZX0** (Einar Saukas; descompresor de Einar Saukas y Urusergi, licencia BSD de 3 cláusulas, `src/rom/LICENSE_ZX0.txt`).
* Hace lo mismo que la cinta: `COLOR 1,1,1:SCREEN 2`, logotipo de Topo, pantalla de carga y juego. Usa el propio TEST.BIN para buscar la RAM, así que pide 64 KB.
* Comprobada en openMSX con C-BIOS (MSX1 europeo y japonés, MSX2, MSX2+) y con BIOS reales de HB-20P, HB-F900, FS-A1ST y FS-A1GT: al llegar a 92ACh la RAM es idéntica a la que deja la cinta (salvo el byte de frecuencia) y el verificador de VRAM no da errores.

## 4. Velocidad: original frente a Enhanced

openMSX, MSX1 PAL (C-BIOS), mismo guion de teclas en la cinta original y en la ROM. Cuadros de 50 Hz por vuelta del bucle principal (9317h):

| Situación | Original | Enhanced | Tiempo por vuelta | Vueltas por segundo |
|---|---|---|---|---|
| Quieto | 9,20 | 5,04 | −45 % | +83 % |
| Andando | 9,28 | 5,37 | −42 % | +73 % |
| Escaleras (con scroll vertical) | 9,31 | 5,74 | −38 % | +62 % |
| **Media** | **9,30** | **5,25** | **−44 %** | **+77 %** |

Cruzar 48 px andando pasa de 1,46 s a 0,80 s; subir 90 px por la escalera, de 2,82 s a 2,14 s. El mínimo de 5 cuadros lo pone el limitador. Scripts en `tools/velocidad/`.

## 5. Cómo se ha probado

* `src/openmsx/verif_parcial.tcl`: tras cada vuelta compara la VRAM (patrones, color, tabla de nombres) con el búfer del juego. Miles de vueltas en HB-20P, HB-F900, FS-A1ST y FS-A1GT, con scroll en las dos direcciones, sin diferencias. Lanzador: `tools/pruebas/vp.sh`.
* `src/openmsx/cinta.tcl` + `cas_prep.py`: carga la cinta sin esperar (puntos de ruptura en TAPION/TAPIN) y vuelca la RAM al llegar a 92ACh; `compara_rom.py` la compara con los bloques.
* `src/openmsx/analiza.py`: comprueba que los sprites coinciden con el papel de las figuras y no tapan tinta.
* Repeticiones `.omr` de openMSX: para reproducir un fallo visto jugando se inyecta la instantánea en la ROM nueva, trasplantando solo los bytes que difieren entre las compilaciones.
* Máquinas C-BIOS de 50 Hz en `src/openmsx/*.xml` (crear las ROM con `tools/cbios50.py`).
