
; Vuelca la pantalla de carga: 6144 bytes de patrones y el color
; comprimido en un byte por cada 8 líneas (dos nibbles a través de una tabla)
PANTALLA_CARGA:
        ld hl,IMAGEN_PATRONES           ; 9C40
        ld de,00000h                    ; 9C43
        ld bc,01800h                    ; 9C46
        ex de,hl                        ; 9C49
        ld a,l                          ; 9C4A
        out (099h),a                    ; 9C4B
        ld a,h                          ; 9C4D
        and 03fh                        ; 9C4E
        or 040h                         ; 9C50
        out (099h),a                    ; 9C52
        ex (sp),hl                      ; 9C54
        ex (sp),hl                      ; 9C55
        ex de,hl                        ; 9C56
P9C57:
        ld a,(hl)                       ; 9C57
        out (098h),a                    ; 9C58
        inc hl                          ; 9C5A
        dec bc                          ; 9C5B
        ld a,b                          ; 9C5C
        or c                            ; 9C5D
        jr nz,P9C57                     ; 9C5E
        ld a,001h                       ; 9C60
        ld b,a                          ; 9C62
        ld c,007h                       ; 9C63
        ld a,b                          ; 9C65
        out (099h),a                    ; 9C66
        ld a,c                          ; 9C68
        or 080h                         ; 9C69
        out (099h),a                    ; 9C6B
        ld bc,00300h                    ; 9C6D
        ld de,02000h                    ; 9C70
        ld hl,IMAGEN_COLOR              ; 9C73
P9C76:
        push bc                         ; 9C76
        ld a,(hl)                       ; 9C77
        and a                           ; 9C78
        jr z,P9CA1                      ; 9C79
        push hl                         ; 9C7B
        push bc                         ; 9C7C
        ld b,a                          ; 9C7D
        and 007h                        ; 9C7E
        ld c,a                          ; 9C80
        ld a,b                          ; 9C81
        and 078h                        ; 9C82
        rrca                            ; 9C84
        rrca                            ; 9C85
        rrca                            ; 9C86
        ld l,a                          ; 9C87
        and 008h                        ; 9C88
        or c                            ; 9C8A
        ld c,a                          ; 9C8B
        ld a,l                          ; 9C8C
        ld hl,P9CCD                     ; 9C8D
        add a,l                         ; 9C90
        ld l,a                          ; 9C91
        ld b,(hl)                       ; 9C92
        ld hl,P9CCD                     ; 9C93
        ld a,c                          ; 9C96
        add a,l                         ; 9C97
        ld l,a                          ; 9C98
        ld a,(hl)                       ; 9C99
        rrca                            ; 9C9A
        rrca                            ; 9C9B
        rrca                            ; 9C9C
        rrca                            ; 9C9D
        or b                            ; 9C9E
        pop bc                          ; 9C9F
        pop hl                          ; 9CA0
P9CA1:
        ld bc,00008h                    ; 9CA1
        inc hl                          ; 9CA4
        ex de,hl                        ; 9CA5
        push bc                         ; 9CA6
        push af                         ; 9CA7
        ld a,l                          ; 9CA8
        out (099h),a                    ; 9CA9
        ld a,h                          ; 9CAB
        and 03fh                        ; 9CAC
        or 040h                         ; 9CAE
        out (099h),a                    ; 9CB0
        ex (sp),hl                      ; 9CB2
        ex (sp),hl                      ; 9CB3
        pop af                          ; 9CB4
        inc b                           ; 9CB5
P9CB6:
        out (098h),a                    ; 9CB6
        dec c                           ; 9CB8
        jp nz,P9CB6                     ; 9CB9
        dec b                           ; 9CBC
        jp nz,P9CB6                     ; 9CBD
        pop bc                          ; 9CC0
        add hl,bc                       ; 9CC1
        ex de,hl                        ; 9CC2
        pop bc                          ; 9CC3
        dec bc                          ; 9CC4
        ld a,b                          ; 9CC5
        or c                            ; 9CC6
        jr nz,P9C76                     ; 9CC7
        call P9CE8                      ; 9CC9
        ret                             ; 9CCC
P9CCD:
        db 001h,004h,006h,00Dh,00Ch,007h,00Ah,00Eh,001h,004h,006h,008h,002h,007h,00Bh,00Fh; 9CCD
        db 0DBh,099h,03Eh,0A2h,0D3h,099h,03Eh,081h,0D3h,099h,0C9h; 9CDD
P9CE8:
        in a,(099h)                     ; 9CE8
        and a                           ; 9CEA
        jp p,P9CE8                      ; 9CEB
        in a,(099h)                     ; 9CEE
        ld a,0e2h                       ; 9CF0
        out (099h),a                    ; 9CF2
        ld a,081h                       ; 9CF4
        out (099h),a                    ; 9CF6
        ret                             ; 9CF8
IMAGEN_PATRONES:
        db 000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h; 9CF9
        db 000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h; 9D09
        db 000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h; 9D19
        db 000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,00Ah; 9D29
        db 002h,001h,005h,010h,010h,024h,062h,01Fh,020h,013h,058h,020h,093h,058h,026h,0B4h; 9D39
        db 025h,07Ah,099h,025h,07Ah,099h,032h,0AAh,0B1h,0B7h,0D6h,0B1h,0B7h,0D6h,0DAh,0B3h; 9D49
        db 019h,0BFh,04Eh,019h,0BFh,04Eh,0C6h,0ACh,006h,0C9h,0DAh,006h,0C9h,0DAh,091h,075h; 9D59
        db 04Eh,0E4h,02Dh,01Eh,0C4h,06Dh,0EBh,09Dh,0F5h,06Dh,092h,0FEh,060h,09Ah,021h,02Eh; 9D69
        db 020h,09Ch,062h,000h,0B8h,064h,0B0h,010h,000h,000h,000h,000h,000h,000h,000h,000h; 9D79
        db 000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h; 9D89
        db 000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h; 9D99
        db 000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h; 9DA9
        db 000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h; 9DB9
        db 000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,007h; 9DC9
        db 000h,000h,000h,000h,000h,000h,003h,0FFh,000h,000h,000h,000h,000h,01Fh,0FDh,0AAh; 9DD9
        db 000h,000h,000h,007h,0FAh,0A8h,000h,000h,003h,00Ch,070h,080h,080h,000h,000h,000h; 9DE9
        db 000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h; 9DF9
        db 000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h; 9E09
        db 000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h; 9E19
        db 000h,000h,000h,001h,000h,000h,00Dh,048h,009h,004h,030h,022h,091h,011h,012h,08Dh; 9E29
        db 017h,0B6h,023h,084h,040h,04Ch,085h,0A7h,046h,0F3h,00Bh,0ABh,076h,0ECh,0B7h,09Bh; 9E39
        db 008h,020h,022h,0F8h,0ABh,065h,0FFh,069h,083h,02Ch,0CBh,0E8h,044h,0A6h,0D8h,071h; 9E49
        db 0F5h,094h,0FCh,02Dh,0EAh,0B5h,0A8h,05Dh,0EFh,0AAh,09Ah,0DDh,0A3h,027h,048h,094h; 9E59
        db 0EEh,036h,078h,09Ah,06Ah,03Fh,0FFh,047h,0DCh,0F7h,082h,045h,0D6h,0E9h,08Dh,0FFh; 9E69
        db 0FFh,0FFh,0FFh,04Fh,083h,0F1h,0FDh,0F9h,000h,000h,000h,000h,000h,000h,000h,000h; 9E79
        db 000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h; 9E89
        db 000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h; 9E99
        db 000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h; 9EA9
        db 000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,001h; 9EB9
        db 01Fh                                            ; 9EC9
        db "?5jU"                                       ; 9ECA
        db 0EAh,0D4h,0A8h,0FFh,0ADh,052h,0ADh,052h,080h,000h,000h,0BAh,055h,0AAh,010h,040h; 9ECE
        db 000h,000h,000h,0D0h,060h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h; 9EDE
        db 000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h; 9EEE
        db 000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h; 9EFE
        db 000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h; 9F0E
        db 000h,000h,000h,000h,002h,004h,004h,003h,002h,004h,008h,088h; 9F1E
        db "AHU/"                                       ; 9F2A
        db 0A7h,042h,0B4h,0B2h,093h,0EFh,014h,0F7h,07Ah,0FCh,0B5h,010h,05Ah,0DCh,0E6h,0C9h; 9F2E
        db 025h,0E6h,08Eh,07Fh,0A5h,05Eh,0EBh,0E5h,093h,07Bh,0FFh,03Ch,03Eh,074h,0FFh,090h; 9F3E
        db 0CDh,0D6h,084h,00Eh,024h,07Bh,058h,0D0h,0A0h,060h,0C0h,074h,0FAh,0F0h,0EDh,0D9h; 9F4E
        db 0F5h,0F7h,0FFh,0CCh,0B2h,056h,02Fh,031h,08Eh,0B7h,07Fh,0A5h,0F8h,0FFh,0FFh,0FFh; 9F5E
        db 0FFh,0FEh,0F8h,07Fh,051h,08Ah,0FFh,0FFh,0FFh,00Fh,007h,025h,04Bh,0FBh,0FBh,0F7h; 9F6E
        db 0F7h,0EFh,0EFh,000h,000h,000h,000h,000h,000h,002h,014h,000h,000h,000h,000h,000h; 9F7E
        db 01Bh,0A0h,000h,000h,000h,000h,003h,0B8h,000h,000h,000h,000h,000h,00Fh,0E0h,000h; 9F8E
        db 000h,000h,000h,000h,01Fh,0E0h,000h,000h,000h,000h,000h,000h,0FFh,000h,000h,000h; 9F9E
        db 000h,000h,000h,000h,080h,0FEh,001h,000h,000h,000h,000h,000h,000h,000h,0F0h,00Fh; 9FAE
        db 000h,000h,000h,003h,002h,007h,00Eh,00Dh,09Ah,01Dh,03Ah,054h,0A0h,040h,080h,000h; 9FBE
        db 04Ch,01Fh,01Fh,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h; 9FCE
        db 000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h; 9FDE
        db 000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h; 9FEE
        db 000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h; 9FFE
        db 000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h; A00E
        db 000h,000h,000h,015h,010h,000h,002h,00Dh,010h,000h,028h,04Dh,054h,08Bh,0F7h,034h; A01E
        db 09Dh,094h,0BDh,04Bh,0AEh,0C6h,0B3h,0F5h,0DBh,068h,078h,073h,08Bh,0A6h,0FFh,0E2h; A02E
        db 08Fh,0F4h,0E7h,016h,0DEh,0FDh,0DFh,0CEh,0B8h,0F8h,0E1h,003h,003h,006h,01Eh,036h; A03E
        db 058h,0A8h,0B0h,0BFh,07Fh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh; A04E
        db 0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FEh,0FCh,0F0h,0F2h,0FFh,0F8h,0F1h; A05E
        db "31x~}<"                                     ; A06B
        db 003h,08Dh,0DDh,0D9h,001h,023h,067h,077h,010h    ; A071
        db "0   @@"                                     ; A07A
        db 080h,040h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h; A080
        db 000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h; A090
        db 000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h; A0A0
        db 000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h; A0B0
        db 000h,034h,068h,054h,0ABh,0DFh,0BFh,0FFh,0BEh,03Fh,03Eh,0FCh,0FCh,0FEh,0FEh,09Fh; A0C0
        db 01Fh,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h; A0D0
        db 000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h; A0E0
        db 000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h; A0F0
        db 000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h; A100
        db 000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,006h,005h,001h,000h,000h; A110
        db 000h,016h,087h,061h,013h,02Eh,0F6h,05Ch,02Fh,0F6h,075h,09Eh,0B6h,0EDh,02Dh,0CEh; A120
        db 02Eh,01Bh                                       ; A130
        db "4PgR"                                       ; A132
        db 01Ah,001h,000h,008h,000h,001h,01Dh,0DAh,0E7h,05Ch,003h,002h,01Dh,0DBh,0A2h,058h; A136
        db 000h,000h,000h,0BFh,07Fh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh; A146
        db 0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh; A156
        db 0FFh,0FFh,0FFh,03Ch,09Eh,0CFh,0CFh,0E7h,0F3h,0F8h,0F8h,0F9h,051h,013h,006h,01Ch; A166
        db 078h,0E8h,090h,080h,000h,060h,0F8h              ; A176
        db "<T(0"                                       ; A17D
        db 000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h; A181
        db 000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,001h,00Bh,025h; A191
        db 000h,000h,000h,000h,00Ah,05Fh,0FFh,0FFh,000h,000h,000h,000h,0A0h,0D5h,0FAh,0FFh; A1A1
        db 000h,000h,000h,000h,000h,000h,0C0h,0A0h,001h,001h,001h,001h,001h,003h,002h,003h; A1B1
        db 0F8h,060h,0C0h,0C0h,0A0h,040h,0A0h,040h,00Eh,000h,000h,000h,000h,000h,000h,000h; A1C1
        db 000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h; A1D1
        db 000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h; A1E1
        db 000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h; A1F1
        db 000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h; A201
        db 000h,000h,000h,000h,000h,000h,000h,000h,003h,005h,004h,000h,000h,000h,003h,000h; A211
        db 05Dh,0DEh,0FAh,059h,02Ch,0BFh,056h,054h,0E3h,0BAh,04Ch,076h,042h,0D9h,032h,068h; A221
        db 060h,080h,000h,000h,080h,000h,080h,0C0h,000h,000h,000h,000h,000h,000h,000h,000h; A231
        db 003h,0FCh,0FFh,0FFh,0FFh,0FFh,0E7h,0CFh,0FFh,03Fh,0EFh,0F3h,0EEh,0C3h,0A8h,0A6h; A241
        db 0FFh,0FFh,0FFh,0FFh,07Fh,0DFh,0E7h,0F9h,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh; A251
        db 0FFh,0FFh,0E7h,0E6h,0F0h,0F9h,0F8h,0FCh,0F0h,0E2h,08Fh,03Eh,07Ch,0FDh,0FBh,0FBh; A261
        db 021h,0A6h,0D9h,080h,000h,000h,000h,000h,0C4h,03Eh,0FFh,07Fh,03Fh,01Fh,007h,002h; A271
        db 000h,000h,080h,0C0h,0F0h,0F8h,0FCh,0FEh,000h,000h,000h,000h,000h,000h,001h,0C7h; A281
        db 000h,002h,00Bh,017h,02Fh,0BFh,07Fh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh; A291
        db 0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh; A2A1
        db 0D0h,0E8h,0F0h,0E8h,0F4h,0F8h,0FCh,0FAh,006h,006h,00Dh,00Ah,015h,01Ah,035h,02Ah; A2B1
        db 080h,040h,000h,080h,000h,080h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h; A2C1
        db 000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h; A2D1
        db 000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h; A2E1
        db 000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h; A2F1
        db 000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h; A301
        db 000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h; A311
        db 073h,0CCh,07Dh,011h,008h,00Ah,000h,000h         ; A321
        db "T0(H"                                       ; A329
        db 000h,040h,040h,000h,0FFh,0FFh,0FFh,0FFh,0FEh,0F8h,0E0h,083h,0FFh,0FFh,0F0h,080h; A32D
        db 004h,038h,0F2h,0B1h,083h,007h,003h,001h,010h,050h,0FEh,0D5h,0FFh,0FFh,0FFh,0FFh; A33D
        db 07Fh,03Fh,01Fh,087h,05Fh,0D7h,0B6h,044h,0C2h,084h,084h,010h,000h,060h,016h,0C0h; A34D
        db 043h,0A8h,0E5h,0D0h,000h,000h,080h,02Dh,0C0h,0C0h,020h,0A0h,018h,030h,0C0h,000h; A35D
        db 000h,020h,090h,030h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h; A36D
        db 000h,000h,000h,000h,0BFh,07Fh,01Fh,00Fh,003h,001h,000h,000h,0A7h,0FFh,0FFh,0FFh; A37D
        db 0FFh,0FFh,0FFh,07Fh,0FFh,0FFh,0FFh,0FEh,0FCh,0F0h,0C0h,080h,0FFh,0FFh,0FFh,0BBh; A38D
        db 007h,003h,003h,003h,0FFh,0FFh,0FFh,0FFh,0FFh,0FCh,0F8h,0F0h,0FFh,0FFh,0FFh,0FFh; A39D
        db 06Fh,003h,000h,000h,0FCh,0FEh,0FCh,0FAh,0FDh,0FDh,0FBh,07Ah,054h,062h,0D0h,0A0h; A3AD
        db 040h,0A0h,040h,080h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h; A3BD
        db 000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h; A3CD
        db 000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h; A3DD
        db 000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h; A3ED
        db 000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h; A3FD
        db 000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h; A40D
        db 000h,000h,000h,000h,000h,000h,000h,000h,000h,001h,001h,005h,007h,01Fh,078h,0E5h; A41D
        db 0CFh,09Eh,0BDh,07Dh,04Ch,0B0h,060h,0E0h,042h,084h,088h,010h,017h; A42D
        db ",(P`@"                                      ; A43A
        db 000h,000h,002h,000h,000h,000h,008h,000h,000h,000h,0CDh,026h,057h,00Bh,00Bh,007h; A43F
        db 00Dh,005h,000h,000h,000h,000h,003h,001h,001h,001h,0EFh,07Fh,07Fh,09Ch,07Bh,0E5h; A44F
        db 0DEh,0BEh,0A0h,090h,0C9h,0D6h,0CAh,0D5h,030h,0E9h,0A8h,098h,050h,028h,098h,0ACh; A45F
        db 094h,018h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h; A46F
        db 000h,000h,001h,002h,003h,007h,006h,00Eh,00Dh,01Dh,0BFh,0FFh,05Fh,0DEh,0BFh,0BFh; A47F
        db 03Fh,01Fh,000h,080h,000h,000h,000h,001h,0A3h,0FFh,007h,00Bh,01Fh,00Fh,05Fh,0FFh; A48F
        db 0FFh,0FCh,0F0h,0F0h,0F0h,0F8h,0FCh,0FFh,0FEh,0FFh,000h,000h,000h,001h,001h,003h; A49F
        db 0D7h,0FFh,077h,076h,0EDh,0EAh,0D4h,0D9h,0B4h,0A8h,040h,0A0h,040h,080h,000h,000h; A4AF
        db 000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h; A4BF
        db 000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h; A4CF
        db 000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h; A4DF
        db 000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h; A4EF
        db 001h,000h,000h,000h,003h,00Ch,020h,080h,000h,000h,000h,077h,080h,000h,000h,000h; A4FF
        db 000h,000h,000h,0F0h,007h,000h,000h,000h,000h,000h,000h,000h,0A0h,01Fh,000h,000h; A50F
        db 000h,000h,00Dh,01Ah                             ; A51F
        db ":;;{"                                       ; A523
        db 0F7h,0F7h,0FEh,0F8h,0F0h,0E0h,0E0h,0C0h,080h,000h,010h,020h,002h,017h,05Ch,0B0h; A527
        db 060h,0C0h,000h,000h,000h,080h,006h,003h,000h,000h,000h,000h,000h,000h,000h,000h; A537
        db 000h,000h,00Bh,007h,002h,005h,003h,005h,003h,005h,000h,004h; A547
        db " D`A!A"                                     ; A553
        db 0E7h,0D8h,0CFh,077h,078h,0BFh,02Dh,055h,090h,054h,0D3h,0A0h,068h,0C8h,0A4h,048h; A559
        db 004h,089h,0C5h,0EBh,0F7h,0E3h,088h,008h,080h,080h,080h,080h,080h,080h,080h,000h; A569
        db 000h,000h,000h,000h,000h,000h,000h,001h,01Ah    ; A579
        db ":4th"                                       ; A582
        db 0E8h,091h,053h,01Fh,01Fh,03Fh,03Fh,03Fh,07Fh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh; A586
        db 0FFh,0FFh,0FFh,0F8h,0F0h,0E0h,0E0h,0C0h,080h,000h,000h,0FFh,07Fh,07Fh,07Fh,03Fh; A596
        db 03Fh,03Fh,01Fh,0FFh,0FFh,0FEh,0FEh,0FDh,0FDh,0FBh,0C2h,050h,068h,0D0h,0A0h,048h; A5A6
        db 0A0h,050h,080h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h; A5B6
        db 000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h; A5C6
        db 000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h; A5D6
        db 000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h; A5E6
        db 000h,000h,000h,004h,000h,008h,010h,000h,020h,000h,000h,000h,000h,000h,000h,000h; A5F6
        db 000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h; A606
        db 000h,000h,000h,003h,007h,00Fh,00Fh,01Fh,03Fh,03Fh,05Fh,0FFh,0FEh,0FEh,0FCh,0FCh; A616
        db 0FCh,0F8h,0F8h,001h,002h,001h,003h,005h,003h,005h,002h,080h,080h,000h,000h,000h; A626
        db 000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,020h,010h,018h; A636
        db 015h,00Ah,00Dh,00Bh,007h,00Bh,017h,02Dh,057h,0ADh; A646
        db "ZaA!"                                       ; A650
        db 091h,0A1h,0B1h,0A1h,0B1h,0CAh,0B4h,06Fh,0F5h,08Eh,091h,0E9h,052h,034h,0A6h,026h; A654
        db 0AAh,0D5h,0D9h,0A1h,0D1h,014h,02Ch,00Ah,034h,004h,000h,000h,000h,000h,000h,000h; A664
        db 000h,000h,000h,001h,003h,001h,002h,002h,004h,034h,068h,0C8h,090h,035h,019h,02Dh; A674
        db 075h,078h,0E0h,0F0h,0E0h,0FFh,0FFh,0F0h,080h,000h,000h,001h,001h,0FEh,0FEh,07Fh; A684
        db 0FFh,0FFh,0FFh,0FFh,0FFh,000h,00Ch,00Eh,0FFh,0FFh,0FFh,0FFh,0FFh,01Fh,01Eh,03Eh; A694
        db 0FFh,0FFh,0FFh,0FEh,0FEh,087h,006h,00Dh,00Eh,01Bh,01Dh,03Fh,03Fh,000h,080h,000h; A6A4
        db 000h,000h,0F0h,0F8h,0FCh,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h; A6B4
        db 000h,000h,000h,000h,000h,004h,000h,000h,000h,004h,000h,000h,000h,000h,000h,000h; A6C4
        db 000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h; A6D4
        db 000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h; A6E4
        db 000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h; A6F4
        db 000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h; A704
        db 000h,000h,000h,000h,000h                        ; A714
        db "?_?};};w"                                   ; A719
        db 0F0h,0F0h,0E0h,0E0h,0C0h,0C0h,0C0h,080h,006h,002h,006h,002h,006h,004h,005h,004h; A721
        db 000h,000h,000h,000h,000h,000h,050h,0A4h,000h,000h,000h,000h,000h,000h,000h,000h; A731
        db 00Eh,005h,006h,007h,006h,003h,003h,001h,0B3h,079h,0A2h,069h,0D2h,0C9h,092h,0A5h; A741
        db 0A1h,091h,0A3h,0B3h,0A3h,093h,083h,053h,037h,0B2h,029h,0AAh,0D5h,064h,055h,0B5h; A751
        db 0F8h,0E8h                                       ; A761
        db "P8T8t8"                                     ; A763
        db 000h,000h,000h,000h,003h,007h,01Fh,03Fh,00Fh,03Fh,07Eh,0FFh,0FFh,0FCh,0F8h,0E0h; A769
        db 091h,0A3h,027h,047h,047h,08Eh,09Eh,01Fh,0C0h,0A0h,0C0h,040h,080h,080h,000h,000h; A779
        db 001h,001h,000h,000h,000h,000h,000h,000h,0FFh,0FFh,0FFh,07Fh,079h,079h,0FBh,073h; A789
        db 0FFh,0FFh,0FFh,0FCh,0ECh,0CEh,0DEh,0CEh,0FCh,0F8h,0F8h,0F8h,0F1h,0F1h,0E3h,073h; A799
        db 07Fh,07Fh,0E8h,0D5h,0AAh,0D4h,060h,0A0h,0FEh,01Fh,00Fh,007h,007h,003h,003h,001h; A7A9
        db 000h,000h,080h,080h,0C0h,0C0h,0E0h,0E0h,000h,000h,000h,000h,000h,000h,000h,000h; A7B9
        db 004h,004h,004h,004h,000h,004h,004h,004h,000h,000h,000h,000h,000h,000h,000h,000h; A7C9
        db 000h,000h,000h,000h,000h,000h,000h,003h,000h,000h,000h,000h,000h,000h,000h,000h; A7D9
        db 000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h; A7E9
        db 000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h; A7F9
        db 000h,000h,000h,000h,000h,000h,000h,000h,0FFh,0FFh,0FFh,0FFh,0FDh,0FDh,0FCh,0F8h; A809
        db 044h,0A8h,040h,080h,040h,0A0h,040h,0A0h,090h,010h,020h,050h,0E0h,0E0h,0D0h,060h; A819
        db 005h,006h,005h,006h,005h,00Eh,00Ch,00Ah,002h,084h,002h,004h,002h,004h,000h,000h; A829
        db 000h,000h,000h,000h,000h,000h,000h,000h,003h,001h,003h,001h,001h,003h,003h,003h; A839
        db 093h,0A1h,053h,085h,053h,085h,048h,084h,0CBh,043h,0E3h,063h,0A1h,0F1h,0B1h,0D9h; A849
        db 0A8h,050h,0A8h,0B0h,0D8h,0A0h,0D1h,030h,094h,095h,0DDh,04Dh,0E9h,0ACh,046h,004h; A859
        db 0FFh,0FEh,0C4h,090h,030h,070h,0F0h,0C0h,0C1h,002h,002h,004h,004h,009h,009h,013h; A869
        db 03Eh,07Ah,06Ch,0F4h,0E8h,0F8h,0E0h,0D0h,000h,000h,000h,000h,000h,000h,000h,000h; A879
        db 000h,000h,000h,000h,000h,000h,000h,000h,0EAh,0F0h,000h,000h,000h,000h,000h,000h; A889
        db 09Ch,000h,000h,000h,000h,000h,000h,000h,007h,006h,00Dh,00Eh,01Dh,01Ah,035h,03Ah; A899
        db 040h,080h,040h,0A0h,000h,080h,000h,080h,001h,000h,000h,000h,000h,000h,003h,007h; A8A9
        db 0F3h,0F7h,0FFh,07Fh,07Fh,0F8h,0E0h,0C0h,080h,080h,0C0h,080h,004h,000h,001h,000h; A8B9
        db 000h,000h,004h,004h,004h,004h,004h,08Eh,000h,000h,000h,000h,003h,00Bh,017h,02Fh; A8C9
        db 00Fh,015h,06Bh,0BEh,07Ah,0FCh,0F4h,0E8h,000h,000h,000h,000h,000h,000h,000h,000h; A8D9
        db 000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h; A8E9
        db 000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h; A8F9
        db 000h,000h,000h,000h,000h,000h,000h,000h,0FDh,0F4h,0F8h,0F5h,0F8h,0E0h,0F0h,0E1h; A909
        db 050h,0A0h,010h,0A0h,010h,088h,090h,008h,0D0h,0E0h,0D0h,0E8h,0D0h,0E8h,074h,0E8h; A919
        db 01Ch,018h,010h                                  ; A929
        db "0 ``"                                       ; A92C
        db 0F0h,000h,000h,008h,010h,010h,020h,020h,020h,000h,000h,000h,000h,020h,010h,010h; A930
        db 010h,0FCh,0F8h,0F8h,0F0h,0F0h,0E0h,0C0h,080h,00Ah,002h,001h,084h,091h,08Ah,092h; A940
        db 088h,0A9h,0DDh,0ADh,0DFh,0AFh,0C7h,0ABh,0C7h    ; A950
        db "P0PzT"                                      ; A959
        db 010h,031h,083h,005h,003h,001h,003h,006h,03Ch,01Ch,00Dh,040h,000h,000h,034h,0C8h; A95E
        db 060h,090h,080h,013h                             ; A96E
        db "''ON"                                       ; A972
        db 09Dh,09Ah,025h,0E0h,0A0h,0C0h,040h,080h,080h,000h,000h,000h,000h,000h,000h,000h; A976
        db 000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h; A986
        db 000h,000h,000h,000h,000h,000h,000h,001h,001h,002h,003h,068h,054h,0E8h,0D4h,0A0h; A996
        db 050h,080h,000h,000h,000h,000h,000h,000h,000h,000h,000h,007h,003h,000h,006h,000h; A9A6
        db 000h,000h,000h,0C0h,080h,000h,039h,000h,000h,000h,000h,000h,000h,000h,0DFh,000h; A9B6
        db 000h,001h,002h,06Eh,07Eh,03Bh,0E7h,05Fh,07Fh,06Fh,08Eh,0DFh,0DFh,082h,0FFh,080h; A9C6
        db 0BFh,0DEh,0D8h,0F8h,0F0h,000h,0F9h,000h,000h,000h,000h,000h,000h,000h,0F9h,000h; A9D6
        db 000h,000h,000h,000h,000h,000h,00Ch,000h,000h,000h,000h,000h,000h,000h,000h,000h; A9E6
        db 000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h; A9F6
        db 000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,0D0h,0E0h,0D0h,0E1h,0A0h; AA06
        db 0C8h,099h,0B8h,0C0h,080h,041h,002h,001h,0C3h,007h,0C2h,075h,0EAh,075h,0EEh,0FFh; AA16
        db 0FFh,07Eh,0FFh,060h,0D0h,068h,0F0h,068h,0D0h,0C2h,044h,000h,000h,000h,000h,000h; AA26
        db 0C0h,000h,000h,008h,008h,009h,009h,005h,004h,004h,004h,0FFh,0FFh,0FFh,0FFh,0FFh; AA36
        db 07Eh,018h,000h,091h,088h,091h,00Ah,011h,022h,071h,0E1h,08Bh,0C5h,08Bh,0C5h,082h; AA46
        db 0C5h,082h,085h,0DDh,0BBh,0C0h,00Dh,056h,044h,0E2h,0E0h,000h,000h,000h,000h,000h; AA56
        db 000h,000h,000h,001h,000h,000h,000h,001h,003h,033h,068h,01Ch,01Eh,038h,0B8h,0B4h; AA66
        db 074h,06Ch,06Eh,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h; AA76
        db 000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h; AA86
        db 000h,000h,000h,006h,005h,00Ah,00Ch,01Ah,015h,030h,035h,080h,000h,000h,000h,000h; AA96
        db 000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h; AAA6
        db 000h,000h,000h,000h,000h,000h,000h,003h,007h,01Fh,03Fh,00Dh,01Eh,07Fh,0FFh,0FFh; AAB6
        db 0FFh,0FFh,0FEh,075h,0F5h,0F5h,0F4h,0F4h,0F4h,064h,084h,020h,0D0h,080h,004h,002h; AAC6
        db 001h,000h,000h,000h,000h,000h,000h,000h,000h,000h,040h,000h,000h,000h,000h,000h; AAD6
        db 000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h; AAE6
        db 000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h; AAF6
        db 00Eh,017h,02Bh,000h,000h,000h,000h,000h,000h,040h,020h,091h,0F1h,0B0h,070h,030h; AB06
        db 065h,0E5h,069h,087h,040h,0A0h,0D0h,0A0h,0D0h,068h,0F8h,03Eh,01Fh,01Fh,01Dh,01Fh; AB16
        db 00Fh,003h,003h,0C8h,090h,090h,0B0h,0A0h,060h,060h,030h,000h,000h,000h,000h,000h; AB26
        db 000h,004h,006h,004h,000h,000h,000h,000h,000h,000h,000h,080h,0C0h,0E0h,0F0h,0F8h; AB36
        db 0FCh,0FEh,0FFh,043h,0A5h,003h,017h              ; AB46
        db "[&O/"                                       ; AB4D
        db 082h,084h,000h,000h,000h,001h,001h,001h,0A0h,0D0h,0B0h,050h,0F8h,0F7h,0E5h,0DBh; AB51
        db 000h,000h,000h,001h,001h,001h,083h,0E3h,0FCh,0DDh,0C3h,0AFh,0DCh,093h,0CFh,0BEh; AB61
        db 046h,08Eh,0DCh,064h,0F8h,03Ch,0CCh,072h,000h,000h,000h,000h,000h,000h,000h,000h; AB71
        db 000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h; AB81
        db 000h,000h,000h,000h,000h,000h,000h,001h         ; AB91
        db "*ujQ"                                       ; AB99
        db 0E8h,0D4h,0E8h,0C0h,080h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h; AB9D
        db 000h,000h,001h,003h,000h,001h,007h,00Fh,03Fh,07Fh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh; ABAD
        db 0FEh,0FFh,0FEh,0F8h,0FBh,0F4h,0D8h,0A0h,0C0h,000h,000h,000h,004h,004h,004h,000h; ABBD
        db 004h,004h,004h,004h,000h,000h,000h,000h,000h,000h,000h,000h,020h,000h,000h,000h; ABCD
        db 000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h; ABDD
        db 000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h; ABED
        db 000h,000h,000h,000h,01Bh                        ; ABFD
        db "UMMMU"                                      ; AC02
        db 01Bh,02Bh,090h,0A8h,088h,0B4h,0AAh,0B4h,0BDh,07Eh,045h,0C9h,090h,088h,090h,020h; AC07
        db 010h,0A0h,0F4h,0FAh,0EDh,0F6h,0F6h,0FDh,07Bh,03Eh,001h,000h,001h,001h,000h,000h; AC17
        db 080h,080h,018h,08Ch,040h,060h,0F0h,0BCh,0DAh,0EDh,002h,003h,001h,001h,000h,000h; AC27
        db 008h,004h,000h,000h,000h,080h,0C0h,020h,010h,000h,000h,000h,000h,000h,000h,000h; AC37
        db 000h,000h,019h,092h,091h,0DAh,0C8h,0CCh,0EAh,0EDh,003h,003h,003h,007h,007h,00Eh; AC47
        db 00Dh,01Bh,0ABh,0DDh,0FEh,0F8h,0F6h,0EEh,0ECh,0F1h,0C7h,03Eh,07Fh,06Fh,0DEh,0BFh; AC57
        db 0FFh,0DFh,079h,067h,09Fh,0BAh,07Dh,060h,01Ch,063h,0BCh,0DCh,0EEh,0F6h,0F4h,0F0h; AC67
        db 060h,060h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h; AC77
        db 000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,001h,003h,003h,007h,006h,00Dh; AC87
        db 01Ah,029h,0A0h,050h,0A0h,048h,080h,000h,020h,000h,000h,000h,000h,000h,003h,007h; AC97
        db 01Fh,03Fh,00Fh,01Fh,07Fh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FEh,0FCh,0F0h; ACA7
        db 0E0h,080h,0F0h,0C0h,080h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h; ACB7
        db 000h,000h,000h,000h,004h,004h,000h,000h,004h,004h,000h,000h,000h,000h,000h,000h; ACC7
        db 000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h; ACD7
        db 000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h; ACE7
        db 000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,017h,00Eh,001h,000h,000h,000h; ACF7
        db 000h,000h,07Dh,0FEh,0BFh,05Eh,02Fh,017h,065h,073h,090h,080h,080h,000h,004h,044h; AD07
        db 042h,026h,0FDh,0FEh,07Dh,05Eh,0BFh              ; AD17
        db "/?/@"                                       ; AD1E
        db 000h,000h,080h,040h,0A0h,040h,0A0h,0D7h         ; AD22
        db "gqX,*$"                                     ; AD2A
        db 016h,044h,0A2h,0C2h,0A3h,0E9h,0F8h,05Eh,077h,000h,000h,000h,000h,010h,0A8h,050h; AD30
        db 068h,000h,000h,000h,000h,000h,000h,000h,000h,0E6h,0E5h,0E7h,0E3h,0E3h,0E3h,0E1h; AD40
        db 0F1h,01Dh                                       ; AD50
        db ";?^_"                                       ; AD52
        db 09Eh,09Bh,0D7h,0FCh,0C9h,05Ch,0CAh,070h,0D0h,046h,0EAh,0BEh,07Eh,0EEh,0BEh,07Ch; AD56
        db 0B0h,008h,038h,094h,045h,01Bh,0BBh,01Ah,0AAh,044h,018h,040h,040h,040h,000h,000h; AD66
        db 000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h; AD76
        db 000h,000h,000h,000h,000h,000h,001h,007h,00Eh    ; AD86
        db ";T4h"                                       ; AD8F
        db 0D0h,0A0h,050h,0A8h,051h,082h,000h,001h,007h,00Fh,03Fh,07Fh,0FFh,0FEh,0FFh,0FFh; AD93
        db 0FCh,0FFh,0F7h,0DFh,07Eh,0F8h,0DFh,0FCh,0F8h,0E0h,0C0h,000h,001h,03Eh,000h,000h; ADA3
        db 000h,000h,001h,01Eh,0E0h,000h,000h,000h,003h,03Ch,0C0h,000h,000h,000h,000h,01Fh; ADB3
        db 0E0h,000h,000h,000h,000h,000h,071h,080h,004h,000h,000h,000h,000h,000h,0FEh,001h; ADC3
        db 000h,000h,000h,000h,000h,000h,000h,0FFh,000h,000h,000h,000h,000h,000h,000h,000h; ADD3
        db 0C0h,020h,010h,004h,000h,001h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h; ADE3
        db 000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,0FEh,0F8h; ADF3
        db 0F9h,0F5h,0F8h,0F4h,0F8h,0FCh,082h,089h,085h,084h,0C4h,0C3h,0C1h,063h,00Ch,006h; AE03
        db 00Ah,007h,015h,00Bh,095h,0EBh,03Fh,01Fh,01Fh,00Fh,00Fh,08Bh,08Fh,08Bh,0D4h,0BAh; AE13
        db 0D4h,0FAh,0D5h,0DAh,0D9h,0EEh,013h,005h,003h,088h,04Dh,0ACh,026h,026h,001h,041h; AE23
        db 080h,0C0h,040h,0E0h,030h,050h,0B4h,0EAh,07Dh,01Eh,003h,001h,000h,000h,000h,080h; AE33
        db 000h,0A0h,0C0h,0A8h,0D5h,07Fh,0F1h,0F0h,0F0h,0F8h,0F8h,0F8h,0FCh,0FCh,004h,04Ah; AE43
        db 004h,0E2h,0F5h,0FEh,0FFh,0FFh,0D7h,0DEh,0BEh,0BCh,09Dh,0C9h,001h,003h,018h,0ECh; AE53
        db 0ECh,0CCh,0ECh,0C0h,0E0h,0F0h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h; AE63
        db 000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,001h,002h; AE73
        db 00Ch,019h,03Fh,078h,0E0h,0C0h,088h,083h,03Ch,0E0h,003h,004h,01Bh,027h,00Fh,09Bh; AE83
        db 06Fh,0FFh,07Eh,0F9h,0E3h,0CFh,0F9h,0F7h,0DFh,0BEh,07Ch,0F2h,0E5h,081h,0F3h,0C0h; AE93
        db 0A0h,020h,0C0h,0C0h,080h,080h,0C0h,000h,000h,000h,000h,000h,000h,000h,000h,000h; AEA3
        db 000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h; AEB3
        db 000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h; AEC3
        db 000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h; AED3
        db 000h,000h,000h,000h,000h,000h,080h,080h,040h,020h,010h,010h,008h,006h,000h,000h; AEE3
        db 000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,005h,0FAh,0FCh; AEF3
        db 0F8h,0FCh,0F8h,0F8h,0F8h,0F8h,0E3h,032h,003h,082h,054h,086h,052h,00Ch,07Fh,0FFh; AF03
        db 04Dh,0D6h,09Dh,0DDh,090h,0D2h,0C5h,046h,0E2h,0E3h,071h,0F8h,0FCh,0FFh,0E9h,0EDh; AF13
        db 0F5h,07Eh,07Fh,07Fh,07Fh,03Fh,036h,037h,0B3h,0F3h,071h,071h,0B8h,0D8h,028h,016h; AF23
        db 00Bh,081h,080h,080h,0C0h,0C0h,000h,000h,000h,0C0h,060h,004h,000h,000h,000h,000h; AF33
        db 000h,000h,008h,000h,001h,000h,0FFh,001h,000h,000h,01Fh,0F5h,0AAh,000h,0FFh,0FFh; AF43
        db 01Fh,007h,083h,0F1h,0BCh,06Eh,003h,006h,000h,003h,000h,000h,000h,080h,090h,030h; AF53
        db 0E0h,080h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h; AF63
        db 000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,001h,002h,0C0h,061h; AF73
        db 036h,009h,037h,04Fh,0BEh,07Ch,0DFh,03Eh,0F8h,0F3h,0C7h,09Fh,03Eh,0F8h,01Fh,07Ch; AF83
        db 0F8h,0E0h,0C1h,000h,0E2h,01Fh,013h,00Bh,047h,016h; AF93
        db ".V.V"                                       ; AF9D
        db 000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h; AFA1
        db 000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h; AFB1
        db 000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h; AFC1
        db 000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h; AFD1
        db 000h,000h,000h,000h,000h,000h,000h,000h,001h,000h,000h,000h,000h,000h,000h,000h; AFE1
        db 0B0h,005h,000h,000h,000h,000h,000h,000h,008h,000h,010h,020h,080h,000h,000h,000h; AFF1
        db 03Ch,0CDh,0FCh,0FDh,0FCh,0FCh,0FEh,0FEh,054h,0C8h,0C4h,0E1h,0C1h,061h,0D1h,060h; B001
        db 093h,081h,0C0h,088h,004h,08Ah,000h,022h,0CFh,0E6h; B011
        db "B@($("                                      ; B01B
        db 004h,0DFh,07Fh,0FFh,04Fh,0A0h,0CBh,013h,05Bh,0E8h,098h,098h,0CCh,084h,0C0h,0F0h; B020
        db 0F0h                                            ; B030
        db "@@`0"                                       ; B031
        db 018h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,006h,000h,000h; B035
        db 000h,000h,007h,01Eh,000h,090h,02Dh,000h,003h,03Fh,0F5h,0A0h,017h,00Bh,007h,002h; B045
        db 0E9h,043h,00Ch,052h,07Fh,07Fh,03Fh,01Fh,09Fh,00Fh,00Fh,0CFh,000h,000h,000h,000h; B055
        db 000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h; B065
        db 003h,004h,01Bh,027h,00Dh,013h,06Fh,09Dh,07Ah,0D5h,0A3h,04Fh,0F1h,0E7h,08Fh,03Eh; B075
        db 07Ch,0F0h,0E0h,080h,0F0h,0C0h,080h,000h,000h,000h,000h,000h,001h,000h,000h,000h; B085
        db 000h,000h,000h,000h,0ACh,05Ch,03Ch,038h,018h,018h,010h,030h,000h,000h,000h,000h; B095
        db 000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h; B0A5
        db 000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h; B0B5
        db 000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h; B0C5
        db 000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h; B0D5
        db 000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h; B0E5
        db 000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,0FEh,0FEh,0FEh,0FFh; B0F5
        db 0FFh,0FFh,0FFh,0FFh,0F4h,05Ah,065h,020h,0E0h,0E1h,0E0h,0F1h,000h,082h,006h,006h; B105
        db 086h,00Ch,08Ch,048h,008h,004h                   ; B115
        db "@@@aa!"                                     ; B11B
        db 0B6h,03Dh,075h,06Bh,0F5h,0F9h,0BDh,035h,0BCh,0EFh,0DBh,0ADh,0DFh,0F5h,0AFh,0EEh; B121
        db 008h,014h,008h,004h,082h,085h,082h,0C1h,000h,000h,000h,000h,001h,001h,001h,041h; B131
        db 03Dh,068h,0F0h,0C0h,0A0h,0C0h,080h,041h,001h,006h,00Ah,034h,050h,0C0h,085h,00Dh; B141
        db 08Ch,092h,029h,06Bh,094h,0D6h,03Fh,0DFh,090h,0E0h,080h,000h,0C0h,0E0h,038h,09Eh; B151
        db 000h,01Ch,074h,0E0h,0F0h,079h,03Eh,00Fh,000h,001h,006h,00Dh,03Ch,0CCh,02Eh,057h; B161
        db 0DDh,036h,0A8h,053h,087h,01Fh,03Eh,0F8h,09Fh,07Ch,0FAh,0E1h,0C0h,000h,000h,000h; B171
        db 000h,000h,000h,0E0h,01Fh,000h,000h,000h,000h,000h,000h,000h,001h,0FEh,000h,000h; B181
        db 000h,000h,001h,00Eh,0F0h,000h,000h,000h,020h,040h,080h,000h,000h,000h,000h,000h; B191
        db 000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h; B1A1
        db 000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h; B1B1
        db 000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h; B1C1
        db 000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h; B1D1
        db 000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h; B1E1
        db 000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h; B1F1
        db 000h,000h,000h,000h,000h,000h,000h,000h,0F0h,0F1h,0F0h,0F1h,0F0h,0F9h,0F8h,0F8h; B201
        db 0CCh,058h,094h,08Ah,095h,08Ah,080h,040h,027h,027h,007h,087h,00Fh,00Fh,00Eh,07Fh; B211
        db "3IeAiC#C"                                   ; B221
        db 097h,0CBh,0DCh,0ABh,0CDh,089h,0DCh,0C8h,0A0h,0E0h,0A0h,0F0h,0F0h,0F0h,0F0h,0FCh; B229
        db 0A1h,051h,000h,000h,000h,002h,001h,002h,082h,003h,002h,001h,002h,000h,002h,001h; B239
        db 09Ah,01Bh                                       ; B249
        db "4&qMR8J"                                    ; B24B
        db 095h,0DBh,03Dh,0BEh,07Fh,07Fh,07Fh,05Fh,097h,0E7h,0FAh,0FFh,07Fh,0FFh,0DFh,017h; B252
        db 08Bh,0C5h,0F2h,0FCh,0EEh,09Fh,0EFh,0BAh,0DDh,0EEh,0F6h,0FAh,07Dh,07Eh,07Eh,0F0h; B262
        db 0C0h,080h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h; B272
        db 000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h; B282
        db 000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h; B292
        db 000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h; B2A2
        db 000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h; B2B2
        db 000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h; B2C2
        db 000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h; B2D2
        db 000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h; B2E2
        db 000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h; B2F2
        db 000h,000h,000h,000h,000h,000h,000h,0F8h,0F8h,0F8h,0F8h,0FCh,0FCh,0FCh,0FCh,0C1h; B302
        db 076h,0E9h,055h,027h,006h,007h,07Fh,0FBh,0DAh,0D2h,082h,04Bh,072h,01Fh,08Eh; B312
        db "cS#S+S+C"                                   ; B321
        db 088h,048h,098h,0D0h,090h,050h,090h,090h,014h,036h,013h,031h,011h,023h,021h,063h; B329
        db 001h,002h,001h,0E0h,0FFh,0FFh,0FFh,0FFh,002h,0A1h,050h,02Ah,000h,0FEh,0FFh,0FFh; B339
        db 043h,016h,033h,00Dh,033h,02Dh,0E3h,0FDh,0FFh,0FFh,0EBh,0B5h,02Fh,017h,007h,0CBh; B349
        db 0FDh,0FEh,0DEh,0EFh,0EBh,07Fh,0BBh,0BBh,0EFh,0FFh,0DEh,0BEh,05Eh,0DCh,0D9h,0A3h; B359
        db 0FBh,0FBh,0F9h,0F9h,0F9h,0F3h,0F3h,0F3h,000h,000h,000h,000h,000h,000h,000h,000h; B369
        db 000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h; B379
        db 000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h; B389
        db 000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h; B399
        db 000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h; B3A9
        db 000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h; B3B9
        db 000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h; B3C9
        db 000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h; B3D9
        db 000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h; B3E9
        db 000h,000h,000h,000h,008h,015h,0DDh,015h,000h,000h,000h,000h,0B0h,020h,033h,0B8h; B3F9
        db 000h,001h,001h,001h,001h,001h,001h,001h         ; B409
        db "`@`@`@`@"                                   ; B411
        db 0FEh,0FCh,0FEh,0FDh,0FEh,0FDh,0FEh,0FDh,023h,043h,023h,003h,007h,007h,006h,007h; B419
        db 0D0h,011h,092h,091h,010h,081h,000h,000h,020h,063h,024h,001h,080h,001h,080h,001h; B429
        db 000h,000h,000h,080h,000h,080h,000h,080h,000h,000h,002h,005h,003h,005h,007h,003h; B439
        db 076h,01Bh,0ADh,075h,0F5h,0F5h,0F3h,0E7h,0E7h,066h,093h,0E0h,0F8h,0FFh,0FFh,00Fh; B449
        db 05Bh,036h,054h,001h,007h,0FFh,0FFh,0FFh,0AFh,09Fh,07Fh,0FFh,0FFh,0FFh,0FFh,0FFh; B459
        db 0FFh,0FEh,0FEh,0FCh,0FCh,0F8h,0F0h,0E0h,000h,000h,000h,000h,000h,000h,000h,000h; B469
        db 000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h; B479
        db 000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h; B489
        db 000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h; B499
        db 000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h; B4A9
        db 000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h; B4B9
        db 000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h; B4C9
        db 000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h; B4D9
        db 000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h; B4E9
IMAGEN_COLOR:
        db 007h,007h,007h,007h,007h,007h,047h,003h,003h,003h,018h,018h; B4F9
        db "XXXX"                                       ; B505
        db 003h,006h,003h,003h,003h,003h,003h,003h,003h,003h,003h,047h,047h,047h,007h,007h; B509
        db 007h,007h,007h,007h,007h,007h,042h,043h,003h,003h,003h,003h,018h,018h,018h,018h; B519
        db 030h,006h,003h,003h,003h,007h,007h,007h,007h    ; B529
        db "GGGGG"                                      ; B532
        db 003h,003h,007h,007h,007h,007h,007h              ; B537
        db "CCCC"                                       ; B53E
        db 003h,003h,006h,018h,018h,038h,038h,030h,007h,007h,007h,007h,007h,007h,007h,007h; B542
        db 047h,047h,003h,003h,003h,003h,003h,007h,007h,007h,007h,007h; B552
        db "CCCCC"                                      ; B55E
        db 006h                                            ; B563
        db "88888"                                      ; B564
        db 007h,007h,007h,007h,007h,007h,007h,007h,007h,047h,047h,007h,007h,007h,007h,007h; B569
        db 007h,007h,007h,007h,043h,043h,043h,006h,006h,006h; B579
        db "88888"                                      ; B583
        db 007h,007h,007h,003h,005h,007h,007h,007h,007h,047h,047h,047h,007h,007h,007h,007h; B588
        db 007h,007h,007h,007h,007h                        ; B598
        db "CCCC"                                       ; B59D
        db 003h,038h,010h,038h,010h,038h,038h,007h,007h,007h,007h,007h,007h,007h,007h,007h; B5A1
        db 047h,047h,007h,007h,007h,007h,007h,007h,007h,007h,007h,007h,006h; B5B1
        db "CC(((*"                                     ; B5BE
        db 010h,006h,006h,006h,007h,007h,007h,007h,007h,007h,007h,007h,007h,047h,006h,007h; B5C4
        db 007h,007h,007h,007h,007h,007h,007h,007h,007h,005h,005h,005h; B5D4
        db "0000"                                       ; B5E0
        db 016h,006h,006h,045h,007h,007h,045h,007h,007h,007h,007h,007h,007h,047h,007h,007h; B5E4
        db 007h,007h,007h,007h,007h,007h,007h,007h,007h,007h,005h; B5F4
        db "50000"                                      ; B5FF
        db 010h,006h,006h,042h,002h,045h,045h,007h,007h,007h,007h,007h,047h,007h,007h,007h; B604
        db 007h,007h,007h,007h,007h,007h,007h,007h,005h,005h; B614
        db "500000"                                     ; B61E
        db 010h,045h,045h,005h,007h,007h,002h,007h,007h,007h,007h,047h,047h,007h,007h,005h; B624
        db 007h,007h,007h,007h,007h,007h,007h,007h,005h,005h; B634
        db "50000("                                     ; B63E
        db 010h,045h,045h,007h,007h,002h,002h,007h,007h,007h,007h,047h,047h,047h,007h,007h; B644
        db 007h,045h,045h,007h,007h,007h,007h,007h         ; B654
        db "h(00000("                                   ; B65C
        db 010h,045h,045h,007h,002h,002h,005h,005h,007h,007h,047h,007h; B664
        db "GGGGEEE"                                    ; B670
        db 007h,007h,007h,007h,007h                        ; B677
        db "h(0000"                                     ; B67C
        db 006h,028h,010h,045h,045h,045h,002h,002h,005h,005h,005h,047h,047h,007h; B682
        db "GGGGEE"                                     ; B690
        db 007h,005h,007h,007h,007h,007h                   ; B696
        db "h(0000(("                                   ; B69C
        db 010h,045h,042h,006h,006h,005h,005h,005h,005h,047h,007h,007h,007h; B6A4
        db "EEEG"                                       ; B6B1
        db 005h,007h,007h,007h,007h,005h                   ; B6B5
        db "Bh((000.("                                  ; B6BB
        db 010h,005h,006h,006h,006h,005h,005h,005h,047h,047h,007h; B6C4
        db "EEEE"                                       ; B6CF
        db 007h,007h,005h,007h,007h,007h,007h,005h         ; B6D3
        db "BEh(0000"                                   ; B6DB
        db 006h,015h,005h,006h,006h,006h,005h,005h,005h    ; B6E3
        db "GGEEEEGE"                                   ; B6EC
        db 007h,045h,007h,007h,007h,007h,005h              ; B6F4
        db "Bhh((000"                                   ; B6FB
        db 006h,015h,005h,006h,005h,005h,005h,005h         ; B703
        db "GGEEEEGGGGG"                                ; B70B
        db 007h,007h,007h,007h                             ; B716
        db "XXhhh(((0"                                  ; B71A
        db 006h,028h,005h,005h,001h,005h,005h              ; B723
        db "GEEEEEE"                                    ; B72A
        db 007h,007h,007h,007h,007h,007h,007h,041h,007h    ; B731
        db "XXXhh(((((("                                ; B73A
        db 005h,005h,005h,005h                             ; B745
        db "EEEEG"                                      ; B749
        db 007h,007h,007h,007h,007h,007h,007h,007h,007h,041h,007h,007h; B74E
        db "XXXXX((((((("                               ; B75A
        db 005h,005h                                       ; B766
        db "EEEE"                                       ; B768
        db 007h,047h,007h,007h,007h,007h,007h,007h,007h,007h,007h,007h,007h,007h; B76C
        db "XXXX"                                       ; B77A
        db 018h,018h                                       ; B77E
        db "((((("                                      ; B780
        db 005h                                            ; B785
        db "FEEE"                                       ; B786
        db 007h,007h,007h,007h,007h,007h,007h,007h,007h,007h,007h,007h,007h,007h,007h,007h; B78A
        db 007h,058h,058h,058h,018h,018h                   ; B79A
        db "+((("                                       ; B7A0
        db 006h,006h,006h,046h,045h,007h,007h,007h,007h,007h,007h,007h,007h,007h,007h,007h; B7A4
        db 007h,007h,007h,007h,007h                        ; B7B4
        db "GGXX"                                       ; B7B9
        db 018h,018h,018h,018h,028h,028h,028h,006h,006h,006h,07Eh,046h,007h,007h,007h,007h; B7BD
        db 007h,007h,007h,007h,007h,007h,007h,007h,007h,007h,007h,007h,007h,047h,047h,047h; B7CD
        db 018h,018h,018h,018h,003h                        ; B7DD
        db "FFFFFF"                                     ; B7E2
        db 006h,007h,007h,007h,007h,007h,007h,007h,007h,007h,007h,007h,007h,007h,007h,007h; B7E8
        db 007h,000h                                       ; B7F8
