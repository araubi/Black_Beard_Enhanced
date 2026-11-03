# Black Beard Enhanced: lecciones

Lo aprendido al desensamblar y mejorar Black Beard (Topo Soft, 1988), útil para otros juegos de MSX. El detalle técnico está en DOCUMENTACION.md.

## 1. Comprobar la pantalla en cada vuelta

1. **Verificador en openMSX.** Tras cada volcado compara la VRAM (patrones, color y tabla de nombres) con lo que el juego tiene en su búfer. Cuenta las vueltas con errores. Con varias tandas de teclas (horizontal, vertical, quieto) y en HB-20P, HB-F900 y FS-A1ST/GT, salen fallos que a ojo no se ven. Se pasa después de cada cambio, no solo al final.
2. **Cuando falla, que el verificador diga dónde.** Que apunte tercio/columna/línea de lo que está mal y vuelque las variables de la vuelta: banco, K, FINO, si se mandó entero o parcial y cuántos caracteres. Así un error de color raro se encontró en minutos. Era el atajo de «solo cambió FINO»: suponía que la VRAM seguía en el mismo orden, y la tabla de nombres acababa de volver a su sitio.
3. **Cualquier atajo («esto no ha cambiado, no lo mando») depende de que nada más haya cambiado.** Al añadir una forma nueva de mover la pantalla, repasa todos los atajos que ya había.

## 2. ROM de 32 KB sin mapper cuando no cabe

Orden de lo que más ayudó (ZX0 de Einar Saukas):

1. **Bloques seguidos en memoria, en un solo bloque comprimido.** Ejemplo: 8000h-83FFh y 8400h-CORTE.
2. **ZX0 con prefijo** (`zx0 +N`). Si un bloque se descomprime justo detrás de otro que ya está en RAM, el compresor puede copiar de él. Ojo: solo vale si esa RAM está visible al descomprimir; la página donde está la ROM no sirve.
3. **Comprimir también lo pequeño.** TEST.BIN y la tabla de idioma.
4. **Descomprimir directo al destino.** Por ejemplo, el logo a 9470h en vez de pasar por un búfer. Para eso ese dato tiene que ir en la mitad de la ROM que se ve en ese momento.
5. **Reglas de las dos mitades.** Lo que va a la página 2 tiene que ir en la mitad que se lee con la ROM en la página 1, y al revés. Lo que va a la página 3 puede ir en cualquiera. Un `CORTE` ajustable reparte el bloque grande entre las dos mitades. `display` de los bytes libres de cada mitad, y probar todas las ediciones (Kixx/Topo, opciones de compilación), que comprimen distinto.
6. Rellenar con ceros el código muerto apenas ganó unos bytes; no compensa.

## 3. Memoria libre y trampas del Z80/VDP

1. **RAM de la página 0 que el juego no usa.** Si el juego corre sin BIOS, 0040h-00FFh y otros huecos bajos sirven para código. Se encuentran con watchpoints de escritura durante partidas largas. Los cargadores (cinta y ROM) tienen que copiarlo ahí.
2. **Cargador de cinta muerto.** Muchos juegos de cinta llevan copiado el cargador y no lo usan: es sitio libre (aquí A5CFh-A66Dh).
3. **La interrupción lee 99h.** Si llega entre los dos bytes de una dirección de VRAM, la dirección sale mal. Hay que fijar la dirección con DI y restaurar el estado de interrupciones (`ld a,i` / `jp po`). Un parpadeo del marcador pintaba de rojo una botella por esto.
4. **TMS9918:** 29-31 ciclos entre OUT en zona visible. Bucle `out (98h),a / add a,h / djnz` = 31 ciclos.
5. **Pila del cargador:** comprobar con assert que el código no llega a donde LOAD.BIN tiene la pila.

## 4. Lo que no funcionó

**Girar la tabla de nombres para el scroll horizontal** (mandar solo las columnas nuevas):

- En openMSX bajaba la vuelta de 146 a 101 ms y el verificador daba 0 errores.
- El probador (araubi) lo rechazó porque en MSX1 se ve mal: la tabla de nombres cambia de golpe mientras los patrones llegan por tercios.
- **Lección:** las medidas y el verificador no ven el resultado en pantalla durante la imagen. Antes de dar por buena una técnica de volcado, mirarla en MSX1 a velocidad real o con capturas por cuadro.

## 5. Entregas

1. **Recompilar desde lo entregado.** Descomprímelo en una carpeta vacía y comprueba que da el mismo SHA-1 que la ROM. A un paquete de fuentes le faltaba doble.asm y nadie lo notó hasta que hizo falta volver atrás.
2. **Guardar las fuentes de cada prueba que se manda.** Copia de las fuentes, no solo la ROM. Si el probador (araubi) rechaza la siguiente, se vuelve atrás sin reconstruir.
3. **Guardar también las herramientas.** Los scripts de prueba y las teclas de cada prueba van con las fuentes (aquí `src/openmsx/` y `tools/`).

## 6. MSX2, MSX2+ y turbo R

1. **Turbo R: el slot 0 está expandido.** El TEST.BIN de la cinta busca RAM con ENASLT y solo repone A8h y los subslots de la página 3. En el turbo R dejaba la página 0 sin BIOS y colgaba en la primera interrupción. Guarda SLTTBL (FCC5h) al empezar y repón el subslot del slot 0 antes del EI. En el turbo R, CHGCPU 81h (R800 ROM) si 002Dh ≥ 3. Prueba siempre con BIOS reales del turbo R, no solo C-BIOS.
2. **V9958, R#23 (scroll vertical) mueve también los sprites.** Suma R23 a la Y de la SAT. Si da D0h, pon D1h, porque D0h corta la lista. Con R25/R26/R27 (horizontal), compara sin signo (`jr c`, no `jp m`), o en el borde derecho salta.
3. **MSX2+: el probador (araubi) rechaza repintar el marco para tapar el scroll por hardware.** Queda feo. Si el juego tiene marco y marcador dentro de la pantalla, mejor un buen scroll por software igual para todos los MSX.
4. **Referencia buena: Pac-Mania de MSX2.** Mapa entero prerenderizado en las páginas 2-3. Cada imagen copia la ventana con HMMM, pinta las figuras con LMMM TIMP y cambia de página con R#2. Unas 7,5 imágenes/s, pasos de 2 px en X y 6 px en Y. El marco y el marcador no se repintan nunca.
5. **Copia oculta en MSX2** (doble.asm): dos bancos de VRAM. Se vuelca en el oculto y la interrupción cambia R2/4/5/6/10 al terminar. Así no se ve nada a medias.

## 7. Ritmo y comparativas de velocidad

1. **Limitador con compensación.** Cada vuelta dura al menos N cuadros (aquí 5 = 100 ms). Si una vuelta se pasa (scroll), las siguientes recortan hasta igualar la media. El juego va igual de rápido en MSX1, MSX2 y turbo R, y nunca más rápido de lo jugable. En el turbo R el R800 permite subir la finura del scroll (salto 1 en vez de 6).
2. **Comparar original y versión nueva con el mismo guion de teclas.** Punto de ruptura en la vuelta del bucle principal y registro del tiempo y la posición del jugador. Resultado en cuadros por vuelta y en % (Black Beard: 9,30 → 5,25 cuadros, −44 % de tiempo, +77 % de vueltas/s). Mide también recorridos reales (tiempo en cruzar X píxeles), porque el scroll puede añadir vueltas. Usa las teclas propias de cada versión (el original usaba Q/A/O/P).

## 8. Herramientas de prueba que ahorraron horas

1. **Cargar la cinta original sin esperar.** Puntos de ruptura en TAPION (00E1h) y TAPIN (00E4h) que sirven los bytes del .cas desde Tcl (`src/openmsx/cinta.tcl` + `cas_prep.py`). Se llega al juego en segundos, y así se puede volcar la RAM del original al empezar.
2. **Repeticiones .omr del probador.** Son XML con gzip y llevan instantáneas con RAM y VRAM. Para reproducir un fallo en una ROM nueva se inyecta la instantánea. Si la ROM ha cambiado desde la grabación, no metas su RAM tal cual. Recompila la versión que se usó al grabar (mismo SHA-1) y trasplanta solo los bytes que difieren entre las dos compilaciones.
3. **Mapas desde la RAM.** Con la RAM del juego al empezar y la rutina de pintar losetas pasada a Python se sacan los mapas completos en PNG (herramientas/mapas.py y mapas_original.py).
4. **Efectos de sonido por tabla PSG.** Cada entrada lleva el número de pares y luego pares registro/valor. Si el número no cuadra con los pares, escribe en registros que no existen. Un «cañonazo» sale con ruido (R6), las tres voces con envolvente (R8-R10 = 10h), R11-R13 lenta y mezclador 04h.
5. **Comprobar la lógica del juego antes de culpar al dibujo.** «La antorcha no desaparece» era que la cámara quitaba la condición del cañón (ventana arriba del todo). Lee qué exige la rutina original (aquí LB8FC) y comprueba que la versión nueva no lo rompe.

## 9. Scroll y volcado en MSX1: el volcado por filas

araubi aprobó el «volcado por filas» de Black Beard como base para MSX1. Lo que funcionó:

1. **Tabla de nombres al servicio del volcado.** Si el juego compone la pantalla por
   columnas (carácter = columna x 8 + fila), pon durante la partida una tabla de
   nombres alternativa (otra zona de VRAM, cambiando R#2) en la que cada fila de
   caracteres sea seguida en VRAM. Así cada fila se manda de una vez y lo que se ve
   a medias es, como mucho, una fila. Vuelve a la tabla original al limpiar la
   pantalla o cuando el juego escribe patrones por su cuenta (menús, textos).
2. **Patrones, color y sprites de la misma fila juntos.** Manda primero los patrones
   de la fila, luego su color y luego los atributos de los sprites que cambian a esa
   altura. Se acaban los «saltos de color» (dibujo nuevo con color viejo) y el sprite
   nunca queda sobre un fondo que no le toca.
3. **Sprites en huecos fijos.** Viejos en los huecos 0..N-1 y nuevos ocultos (Y=BFh)
   detrás; en cada fila solo se cambian los bytes Y (nuevo visible, viejo oculto).
   Listas enlazadas por fila (primero/siguiente) para no recorrer los 32. Si no caben
   (más de 32 entre viejos y nuevos), volver a reescribir la tabla por filas.
4. **Medir siempre**: tiempo del volcado completo (puntos de ruptura en openMSX) y una
   métrica objetiva de errores (píxeles de sprite sobre tinta equivocada). Pasó de
   2322 a 658 píxeles con un 5 % más de tiempo.
5. **TMS9918: el bucle más rápido tiene que dejar 29 ciclos entre OUT.** Un bucle de 25
   ciclos funcionaba en MSX2 y fallaba en MSX1 real/emulado: añadir un NOP.
6. **sjasmplus sustituye los define dentro de otros nombres** (-DFILAS rompía
   VOLCADO_FILAS): usar nombres que no aparezcan en etiquetas (PORFILAS).
7. Lo que NO funcionó: girar la tabla de nombres por columnas para el paso lateral
   (lateral.asm): en MSX1 se ve muy mal. Mejor menos trabajo por cuadro bien
   ordenado que trucos que cambian toda la pantalla de golpe.

## 10. ROM de 64 KB: siempre ASCII16

Cuando la ROM de 32 KB se quedó pequeña pasó a 64 KB con mapper Konami, y BlueMSX no la arrancaba. BlueMSX no adivina el mapper de una ROM de 64 KB: si no hay «AB» en 4000h la trata como ASCII16. openMSX sí cuenta las escrituras `LD (nn),A` a registros de mapper. Con ASCII16 y los cambios de banco en `LD (77FFh),A` los dos la reconocen solos. Ojo: los registros ASCII16 están en 6000h-7FFFh, así que el cambio de banco tiene que hacerse mientras la ROM sigue visible en la página 1.
