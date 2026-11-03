; Generado por herramientas/marcador.py: marcador recoloreado por araubi
; (graficos/marcador_ruben.png; ajustado a 2 colores por línea en
;  graficos/marcador_ruben_ajustado.png)

; Patrones nuevos de los caracteres fijos (en los gráficos del marcador)
        org 06100h                      ; fila 18, columna 26
        db 003h,005h,00Fh,01Eh,03Ch,038h,070h,0F2h
        org 061C0h                      ; fila 18, columna 27
        db 08Fh,07Eh,0FFh,071h,000h,000h,000h,000h
        org 06280h                      ; fila 18, columna 28
        db 000h,080h,040h,0E0h,070h,03Ch,00Eh,047h
        org 06400h                      ; fila 18, columna 30
        db 000h,000h,000h,000h,000h,000h,07Ch,0FEh
        org 06048h                      ; fila 19, columna 25
        db 001h,002h,007h,007h,00Dh,00Eh,00Eh,005h
        org 06108h                      ; fila 19, columna 26
        db 065h,0C0h,0A0h,050h,000h,000h,007h,078h
        org 061C8h                      ; fila 19, columna 27
        db 010h,020h,000h,041h,000h,0ECh,007h,0F9h
        org 06288h                      ; fila 19, columna 28
        db 023h,011h,001h,001h,001h,001h,001h,080h
        org 06348h                      ; fila 19, columna 29
        db 001h,0C0h,001h,003h,003h,003h,07Fh,03Fh
        org 06408h                      ; fila 19, columna 30
        db 0FFh,06Ah,0B3h,03Fh,03Fh,021h,05Fh,0BFh
        org 06110h                      ; fila 20, columna 26
        db 014h,031h,024h,00Eh,02Ch,017h,037h,013h
        org 061D0h                      ; fila 20, columna 27
        db 000h,0C0h,030h,090h,078h,0F7h,0B7h,097h
        org 06290h                      ; fila 20, columna 28
        db 038h,046h,051h,060h,0A0h,0A0h,0A0h,020h
        org 06350h                      ; fila 20, columna 29
        db 060h,0DFh,0C0h,009h,011h,011h,011h,010h
        org 06410h                      ; fila 20, columna 30
        db 0FFh,0BFh,0FFh,0BFh,07Fh,0BFh,07Fh,0BFh
        org 06058h                      ; fila 21, columna 25
        db 000h,000h,000h,003h,02Eh,0DEh,03Eh,07Dh
        org 06118h                      ; fila 21, columna 26
        db 018h,015h,00Eh,048h,02Eh,025h,027h,081h
        org 061D8h                      ; fila 21, columna 27
        db 048h,086h,071h,08Ah,071h,08Fh,0F5h,0DEh
        org 06298h                      ; fila 21, columna 28
        db 0D0h,058h,09Ch,0BCh,0BEh,03Eh,07Eh,07Fh
        org 06358h                      ; fila 21, columna 29
        db 008h,009h,005h,001h,083h,060h,01Fh,03Ah
        org 06418h                      ; fila 21, columna 30
        db 05Fh,0AFh,04Dh,0AAh,085h,013h,005h,0C3h
        org 06060h                      ; fila 22, columna 25
        db 07Dh,0F9h,0F3h,0F6h,06Eh,06Ch,073h,03Eh
        org 06120h                      ; fila 22, columna 26
        db 0F3h,0F0h,0E4h,0F4h,07Ah,072h,03Bh,0B5h
        org 061E0h                      ; fila 22, columna 27
        db 055h,08Ah,000h,002h,005h,00Dh,00Bh,01Bh
        org 062A0h                      ; fila 22, columna 28
        db 07Fh,07Dh,0F9h,079h,071h,0F0h,0F0h,0E2h
        org 06360h                      ; fila 22, columna 29
        db 009h,014h,086h,084h,082h,0D2h,008h,009h
        org 06420h                      ; fila 22, columna 30
        db 073h,053h,086h,01Eh,007h,00Dh,058h,000h

; NUEVA_PARTIDA pone el color por carácter y luego esta lista
        org 092EDh
        call COLOR_MARCADOR

        org FIN_PARCIAL
COLOR_MARCADOR:
        call L9DB2
        ld hl,LISTA_MARCADOR
.car:   ld e,(hl)
        inc hl
        ld d,(hl)
        inc hl
        ld a,d
        or a
        ret z
        ex de,hl
        call VDP_ESCRITURA
        ex de,hl
        ld b,8
.lin:   ld a,(hl)                        ; 37 ciclos por byte: vale para el TMS
        out (098h),a
        inc hl
        djnz .lin
        jr .car
LISTA_MARCADOR:
        dw 02718h : db 01Eh,01Eh,01Eh,01Eh,01Eh,01Eh,01Eh,01Eh   ; fila 3, columna 28
        dw 02758h : db 01Eh,01Eh,01Eh,01Eh,01Eh,01Eh,01Eh,01Eh   ; fila 3, columna 29
        dw 02720h : db 01Eh,01Eh,01Eh,01Eh,01Eh,01Eh,01Eh,01Eh   ; fila 4, columna 28
        dw 02E68h : db 071h,071h,071h,071h,071h,071h,071h,071h   ; fila 13, columna 25
        dw 02EA8h : db 071h,071h,071h,071h,071h,071h,071h,071h   ; fila 13, columna 26
        dw 02EE8h : db 071h,071h,071h,071h,071h,071h,071h,071h   ; fila 13, columna 27
        dw 02F28h : db 071h,071h,071h,071h,071h,071h,071h,071h   ; fila 13, columna 28
        dw 02F68h : db 071h,071h,071h,071h,071h,071h,071h,071h   ; fila 13, columna 29
        dw 02FA8h : db 071h,071h,071h,071h,071h,071h,071h,071h   ; fila 13, columna 30
        dw 03690h : db 041h,041h,041h,041h,041h,041h,041h,041h   ; fila 18, columna 26
        dw 036D0h : db 041h,041h,044h,041h,011h,011h,011h,011h   ; fila 18, columna 27
        dw 03710h : db 011h,041h,041h,041h,041h,041h,041h,041h   ; fila 18, columna 28
        dw 03790h : db 011h,011h,011h,011h,011h,011h,021h,021h   ; fila 18, columna 30
        dw 03658h : db 041h,041h,041h,041h,041h,041h,041h,041h   ; fila 19, columna 25
        dw 03698h : db 041h,041h,041h,041h,011h,011h,041h,041h   ; fila 19, columna 26
        dw 036D8h : db 041h,041h,011h,041h,011h,041h,041h,041h   ; fila 19, columna 27
        dw 03718h : db 041h,041h,041h,041h,041h,041h,041h,041h   ; fila 19, columna 28
        dw 03758h : db 021h,011h,0A1h,0A1h,0A1h,0A1h,014h,014h   ; fila 19, columna 29
        dw 03798h : db 022h,021h,021h,02Ah,02Ah,0A1h,021h,021h   ; fila 19, columna 30
        dw 036A0h : db 0B1h,0B1h,0B1h,0B1h,0B1h,0B1h,0B1h,0B1h   ; fila 20, columna 26
        dw 036E0h : db 011h,0B1h,0B1h,0B1h,0B1h,0B1h,0B1h,0B1h   ; fila 20, columna 27
        dw 03720h : db 041h,0B1h,0B1h,0B1h,0B1h,0B1h,0B1h,0B1h   ; fila 20, columna 28
        dw 03760h : db 041h,014h,0B1h,021h,021h,021h,021h,021h   ; fila 20, columna 29
        dw 037A0h : db 022h,021h,022h,021h,021h,021h,021h,021h   ; fila 20, columna 30
        dw 03668h : db 011h,011h,011h,041h,041h,041h,041h,041h   ; fila 21, columna 25
        dw 036A8h : db 0E1h,0E1h,0E1h,0E1h,0E1h,0E1h,0E1h,041h   ; fila 21, columna 26
        dw 036E8h : db 0B1h,0E1h,0E1h,0E1h,0E1h,0E1h,0E1h,0E1h   ; fila 21, columna 27
        dw 03728h : db 0B1h,041h,041h,041h,041h,041h,041h,041h   ; fila 21, columna 28
        dw 03768h : db 021h,021h,021h,0A1h,0A1h,041h,041h,041h   ; fila 21, columna 29
        dw 037A8h : db 021h,021h,021h,021h,0A1h,0A1h,0A1h,0A1h   ; fila 21, columna 30
        dw 03670h : db 041h,041h,041h,041h,041h,041h,041h,041h   ; fila 22, columna 25
        dw 036B0h : db 041h,041h,041h,041h,041h,041h,041h,041h   ; fila 22, columna 26
        dw 036F0h : db 0E1h,0E1h,011h,041h,041h,041h,041h,041h   ; fila 22, columna 27
        dw 03730h : db 041h,041h,041h,041h,041h,041h,041h,041h   ; fila 22, columna 28
        dw 03770h : db 041h,041h,041h,041h,041h,041h,041h,041h   ; fila 22, columna 29
        dw 037B0h : db 0A1h,0A1h,0A1h,0A1h,0A1h,0A1h,0A1h,011h   ; fila 22, columna 30
        dw 0
FIN_MARCADOR:
        assert FIN_MARCADOR <= 0E290h  ; E290h-E293h: TEST.BIN y el cargador de la ROM
