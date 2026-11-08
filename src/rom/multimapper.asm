; Black Beard: la ROM averigua con qué mapper la ha cargado el ordenador o el
; cargador (ASCII16, ASCII8, Konami SCC o Konami) y cambia la página 2 con los
; registros de ese mapper. Va en RAM (E580h), detrás del cargador (E400h-E578h).
MARCA_A16 equ 016h      ; byte 0C000h de la ROM (banco 3 de 16K)
; MARCA_8K3 (byte 06000h de la ROM, página 3 de 8K) lo pasa multimapper.py con --equ

        org 0E580h
MAPA:   db 0            ; 0 ASCII16, 1 ASCII8, 2 Konami SCC, 3 Konami

; Llamada desde ARRANQUE (que corre en la página 1; esto corre en RAM).
; Al salir, la página 1 tiene los primeros 16K de la ROM y la 2 el banco 1.
DETECTA:
        ld hl,06000h
        ld (hl),3       ; ASCII16: 4000h = banco 3; ASCII8/Konami: 4000h-5FFFh = pág. 3 o nada
        ld a,(04000h)
        ld b,0
        cp MARCA_A16
        jr z,FIJA
        inc b
        cp MARCA_8K3
        jr z,FIJA
        ld hl,05000h    ; Konami SCC: 4000h-5FFFh = pág. 3; Konami: no hace nada
        ld (hl),3
        ld a,(04000h)
        ld b,2
        cp MARCA_8K3
        jr z,FIJA
        inc b
FIJA:   ld a,b
        ld (MAPA),a
        ; página 1 otra vez con los primeros 16K de la ROM
        ld a,(MAPA)
        ld hl,06000h
        cp 2
        jr nc,KON
        ld (hl),0       ; ASCII16 y ASCII8: 6000h <- 0
        or a
        jr z,P2
        ld hl,06800h
        ld (hl),1       ; solo ASCII8: 6000h-7FFFh <- pág. 1
        jr P2
KON:    jr nz,K4
        ld hl,05000h    ; Konami SCC
        ld (hl),0
        ld hl,07000h
        ld (hl),1
        jr P2
K4:     ld (hl),1       ; Konami: 6000h-7FFFh <- pág. 1 (4000h fijo)
P2:     ld a,1          ; página 2 = banco 1 (como hacía ARRANQUE)

; Pone el banco A (de 16K) en 8000h-BFFFh. La ROM tiene que estar en la página 2
; (y en la 1 para ASCII16/ASCII8, cuyos registros están en 6000h-7FFFh).
PAG2:   push hl
        push bc
        ld c,a
        ld a,(MAPA)
        or a
        jr nz,P2_8
        ld hl,07000h
        ld (hl),c
        jr P2_FIN
P2_8:   ld hl,07000h    ; ASCII8: 7000h y 7800h
        ld b,008h
        dec a
        jr z,P2_PAR
        ld hl,09000h    ; Konami SCC: 9000h y B000h
        ld b,020h
        dec a
        jr z,P2_PAR
        ld hl,08000h    ; Konami: 8000h y A000h
P2_PAR: ld a,c
        add a,a
        ld (hl),a
        inc a
        add hl,bc       ; (B = 08h o 20h, C = banco: se suma C a L, que vale 00h)
        ld l,0
        ld (hl),a
P2_FIN: pop bc
        pop hl
        ret
FIN:
