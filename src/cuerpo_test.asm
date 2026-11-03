
; TEST.BIN: busca la ranura con RAM de las páginas 0, 1 y 2 (deja los
; valores en E290h-E293h para LOAD.BIN)
BUSCA_RAM:
        di                              ; C350
        ld a,(08000h)                   ; C351
        push af                         ; C354
        call TC395                      ; C355
        ld hl,00024h                    ; C358
        ld (0c3b3h),hl                  ; C35B
        ld hl,04000h                    ; C35E
        call TC3A7                      ; C361
        ld hl,08000h                    ; C364
        call TC3A7                      ; C367
        ld hl,TC3D2                     ; C36A
        ld de,0afc8h                    ; C36D
        ld bc,0007ah                    ; C370
        ldir                            ; C373
        ld hl,0afc8h                    ; C375
        ld (0c3b3h),hl                  ; C378
        ld hl,00000h                    ; C37B
        call TC3A7                      ; C37E
        call TC39A                      ; C381
        ld a,(0e290h)                   ; C384
        out (0a8h),a                    ; C387
        ld a,(0e291h)                   ; C389
        ld (0ffffh),a                   ; C38C
        pop af                          ; C38F
        ld (08000h),a                   ; C390
        ei                              ; C393
        ret                             ; C394
TC395:
        ld hl,0e290h                    ; C395
        jr TC39D                        ; C398
TC39A:
        ld hl,0e292h                    ; C39A
TC39D:
        in a,(0a8h)                     ; C39D
        ld (hl),a                       ; C39F
        inc hl                          ; C3A0
        ld a,(0ffffh)                   ; C3A1
        cpl                             ; C3A4
        ld (hl),a                       ; C3A5
        ret                             ; C3A6
TC3A7:
        ld a,080h                       ; C3A7
        ld c,004h                       ; C3A9
TC3AB:
        and 083h                        ; C3AB
        ld b,004h                       ; C3AD
TC3AF:
        push af                         ; C3AF
        push bc                         ; C3B0
        push hl                         ; C3B1
        call 00024h                     ; C3B2
        pop hl                          ; C3B5
        ld (hl),020h                    ; C3B6
        ld a,(hl)                       ; C3B8
        cp 020h                         ; C3B9
        jr nz,TC3C4                     ; C3BB
        ld (hl),0fah                    ; C3BD
        ld a,(hl)                       ; C3BF
        cp 0fah                         ; C3C0
        jr z,TC3CF                      ; C3C2
TC3C4:
        pop bc                          ; C3C4
        pop af                          ; C3C5
        add a,004h                      ; C3C6
        djnz TC3AF                      ; C3C8
        inc a                           ; C3CA
        dec c                           ; C3CB
        jr nz,TC3AB                     ; C3CC
        ret                             ; C3CE
TC3CF:
        pop bc                          ; C3CF
        pop af                          ; C3D0
        ret                             ; C3D1
TC3D2:
        db 0CDh,0E8h,0AFh,0FAh,0D5h,0AFh,0DBh,0A8h,0A1h,0B0h,0D3h,0A8h,0C9h,0E5h,0CDh,00Ch; C3D2
        db 0B0h,04Fh,006h,000h,07Dh,0A4h,0B2h,021h,0C5h,0FCh,009h,077h,0E1h,079h,018h,0E0h; C3E2
        db 0F5h,07Ch,007h,007h,0E6h,003h,05Fh,03Eh,0C0h,007h,007h,01Dh,0F2h,0F1h,0AFh,05Fh; C3F2
        db 02Fh,04Fh,0F1h,0F5h,0E6h,003h,03Ch,047h,03Eh,0ABh,0C6h,055h,010h,0FCh,057h,0A3h; C402
        db 047h,0F1h,0A7h,0C9h,0F5h,07Ah,0E6h,0C0h,04Fh,0F1h,0F5h,057h,0DBh,0A8h,047h,0E6h; C412
        db 03Fh,0B1h,0D3h,0A8h,07Ah,00Fh,00Fh,0E6h,003h,057h,03Eh,0ABh,0C6h,055h,015h,0F2h; C422
        db 024h,0B0h,0A3h                                  ; C432
        db "W{/g:"                                      ; C435
        db 0FFh,0FFh,02Fh,06Fh,0A4h,0B2h,032h,0FFh,0FFh,078h,0D3h,0A8h,0F1h,0E6h,003h,0C9h; C43A
        db 0FFh,0FFh,0E1h                                  ; C44A
