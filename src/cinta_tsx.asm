; Bytes de A5CFh-A66Dh tal como vienen en la cinta original (TSX [!] v0.8b).
; Es el cargador tipo Spectrum (lee el bit 7 del registro 14 del PSG) que usa
; el LOAD.BIN de la cinta real. El .cas que circula lo cambió por la versión que
; usa la BIOS, igual que en su LOAD.BIN. Se ensambla encima con -DCINTA_TSX.
        org 0A5CFh
CARGADOR_SPECTRUM:
        ld hl,0a678h                    ; A5CF
        push hl                         ; A5D2
        push af                         ; A5D3
        ld a,008h                       ; A5D4
        out (0abh),a                    ; A5D6
        ld a,00eh                       ; A5D8
        out (0a0h),a                    ; A5DA
        pop af                          ; A5DC
        inc d                           ; A5DD
        ex af,af'                       ; A5DE
        dec d                           ; A5DF
        di                              ; A5E0
        ld a,005h                       ; A5E1
        ld c,a                          ; A5E3
        cp a                            ; A5E4
SA5E5:
        call SA655                      ; A5E5
        jr nc,SA5E5                     ; A5E8
        ld hl,00415h                    ; A5EA
SA5ED:
        djnz SA5ED                      ; A5ED
        dec hl                          ; A5EF
        ld a,h                          ; A5F0
        or l                            ; A5F1
        jr nz,SA5ED                     ; A5F2
        call SA651                      ; A5F4
        jr nc,SA5E5                     ; A5F7
SA5F9:
        ld b,09ch                       ; A5F9
        call SA651                      ; A5FB
        jr nc,SA5E5                     ; A5FE
        ld a,0c6h                       ; A600
        cp b                            ; A602
        jr nc,SA5E5                     ; A603
        inc h                           ; A605
        jr nz,SA5F9                     ; A606
SA608:
        ld b,0c9h                       ; A608
        call SA655                      ; A60A
        jr nc,SA5E5                     ; A60D
        ld a,b                          ; A60F
        cp 0d4h                         ; A610
        jr nc,SA608                     ; A612
        call SA655                      ; A614
        ret nc                          ; A617
        ld h,000h                       ; A618
        ld b,0b0h                       ; A61A
        jr SA636                        ; A61C
SA61E:
        ex af,af'                       ; A61E
        jr nz,SA626                     ; A61F
        ld (ix+000h),l                  ; A621
        jr SA630                        ; A624
SA626:
        rr c                            ; A626
        xor l                           ; A628
        ret nz                          ; A629
        ld a,c                          ; A62A
        rla                             ; A62B
        ld c,a                          ; A62C
        inc de                          ; A62D
        jr SA632                        ; A62E
SA630:
        inc ix                          ; A630
SA632:
        dec de                          ; A632
        ex af,af'                       ; A633
        ld b,0b2h                       ; A634
SA636:
        ld l,001h                       ; A636
SA638:
        call SA651                      ; A638
        ret nc                          ; A63B
        ld a,0cbh                       ; A63C
        cp b                            ; A63E
        rl l                            ; A63F
        ld b,0b0h                       ; A641
        jp nc,SA638                     ; A643
        ld a,h                          ; A646
        xor l                           ; A647
        ld h,a                          ; A648
        ld a,d                          ; A649
        or e                            ; A64A
        jr nz,SA61E                     ; A64B
        ld a,h                          ; A64D
        cp 001h                         ; A64E
        ret                             ; A650
SA651:
        call SA655                      ; A651
        ret nc                          ; A654
SA655:
        ld a,016h                       ; A655
SA657:
        dec a                           ; A657
        jr nz,SA657                     ; A658
        and a                           ; A65A
SA65B:
        inc b                           ; A65B
        nop                             ; A65C
        ret z                           ; A65D
        ld a,000h                       ; A65E
        in a,(0a2h)                     ; A660
        cpl                             ; A662
        xor c                           ; A663
        and 080h                        ; A664
        jp z,SA65B                      ; A666
        ld a,c                          ; A669
        cpl                             ; A66A
        ld c,a                          ; A66B
        ld a,r                          ; A66C
