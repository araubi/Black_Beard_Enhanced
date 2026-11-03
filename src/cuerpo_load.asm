
; LOAD.BIN: lee los cuatro bloques sin cabecera y salta al juego (92ACh)
CARGA:
        call 0c350h                     ; D6D8
        call DD7E6                      ; D6DB
        call DD7EB                      ; D6DE
        call DD7F0                      ; D6E1
        ld ix,09c40h                    ; D6E4
        ld de,01bbah                    ; D6E8
        ld a,0ffh                       ; D6EB
        scf                             ; D6ED
        call LEE_BLOQUE                 ; D6EE
        call 09c40h                     ; D6F1
        ld ix,02328h                    ; D6F4
        ld de,032c8h                    ; D6F8
        ld a,0ffh                       ; D6FB
        scf                             ; D6FD
        call LEE_BLOQUE                 ; D6FE
        ld ix,055f0h                    ; D701
        ld de,02a00h                    ; D705
        ld a,0ffh                       ; D708
        scf                             ; D70A
        call LEE_BLOQUE                 ; D70B
        ld ix,08400h                    ; D70E
        ld de,04fffh                    ; D712
        ld a,0ffh                       ; D715
        scf                             ; D717
        call LEE_BLOQUE                 ; D718
        di                              ; D71B
        jp 092ach                       ; D71C

; Carga DE bytes en IX con la BIOS (TAPION/TAPIN) llamada desde una
; rutina en FC9Ah que conmuta la página 0 entre BIOS y RAM en cada byte
LEE_BLOQUE:
        di                              ; D71F
        ex af,af'                       ; D720
        exx                             ; D721
        push bc                         ; D722
        push de                         ; D723
        push hl                         ; D724
        ld hl,0fca6h                    ; D725
        ld b,00ch                       ; D728
DD72A:
        dec hl                          ; D72A
        ld d,(hl)                       ; D72B
        dec hl                          ; D72C
        ld e,(hl)                       ; D72D
        push de                         ; D72E
        djnz DD72A                      ; D72F
        ld a,h                          ; D731
        ld h,b                          ; D732
        ld l,b                          ; D733
        add hl,sp                       ; D734
        ld sp,0fca4h                    ; D735
        ld de,0c961h                    ; D738
        push de                         ; D73B
        ld de,0edd9h                    ; D73C
        push de                         ; D73F
        ld de,000e1h                    ; D740
        push de                         ; D743
        ld de,0cdd9h                    ; D744
        push de                         ; D747
        ld de,069edh                    ; D748
        push de                         ; D74B
        push hl                         ; D74C
        exx                             ; D74D
        ld c,0a8h                       ; D74E
        in h,(c)                        ; D750
        and h                           ; D752
        ld l,a                          ; D753
        call 0fc9ah                     ; D754
        jr c,DD79A                      ; D757
        ld a,0e4h                       ; D759
        ld (0fc9eh),a                   ; D75B
        call 0fc9ah                     ; D75E
        jr c,DD79A                      ; D761
        ld b,a                          ; D763
        ex af,af'                       ; D764
        cp b                            ; D765
        scf                             ; D766
        jr nz,DD79A                     ; D767
        jr DD787                        ; D769
DD76B:
        pop af                          ; D76B
        push ix                         ; D76C
        exx                             ; D76E
        pop bc                          ; D76F
        ld hl,00372h                    ; D770
        add hl,bc                       ; D773
        jr nc,DD782                     ; D774
        ex de,hl                        ; D776
        ld hl,0ffe8h                    ; D777
        add hl,de                       ; D77A
        jr c,DD782                      ; D77B
        pop hl                          ; D77D
        push hl                         ; D77E
        add hl,de                       ; D77F
        ld (hl),a                       ; D780
        ld a,(bc)                       ; D781
DD782:
        ld (bc),a                       ; D782
        exx                             ; D783
        inc ix                          ; D784
        dec de                          ; D786
DD787:
        call 0fc9ah                     ; D787
        jr c,DD79A                      ; D78A
        push af                         ; D78C
        xor b                           ; D78D
        ld b,a                          ; D78E
        ld a,e                          ; D78F
        out (099h),a                    ; D790
        or d                            ; D792
        ld a,087h                       ; D793
        out (099h),a                    ; D795
        jr nz,DD76B                     ; D797
        pop af                          ; D799
DD79A:
        sbc a,a                         ; D79A
        or b                            ; D79B
        ex af,af'                       ; D79C
        ld a,0f3h                       ; D79D
        ld (0fc9eh),a                   ; D79F
        xor a                           ; D7A2
        call 0fc9ah                     ; D7A3
        exx                             ; D7A6
        pop hl                          ; D7A7
        ld sp,hl                        ; D7A8
        ld hl,0fc8eh                    ; D7A9
        ld b,00ch                       ; D7AC
DD7AE:
        pop de                          ; D7AE
        ld (hl),e                       ; D7AF
        inc hl                          ; D7B0
        ld (hl),d                       ; D7B1
        inc hl                          ; D7B2
        djnz DD7AE                      ; D7B3
        pop hl                          ; D7B5
        pop de                          ; D7B6
        pop bc                          ; D7B7
        exx                             ; D7B8
        ex af,af'                       ; D7B9
        cp 001h                         ; D7BA
        ret                             ; D7BC
        db 05Fh,0E6h,00Fh,0D3h,099h,03Eh,087h,0D3h,099h,037h,0C9h,01Eh,013h,03Eh,009h,0D3h; D7BD
        db 0ABh,03Eh,001h,0D3h,099h,03Eh,087h,0D3h,099h,0C9h,021h,091h,0E2h,018h,019h,021h; D7CD
        db 091h,0E2h,018h,01Ah,021h,091h,0E2h,018h,01Bh    ; D7DD
DD7E6:
        ld hl,0e293h                    ; D7E6
        jr DD7F5                        ; D7E9
DD7EB:
        ld hl,0e293h                    ; D7EB
        jr DD7FB                        ; D7EE
DD7F0:
        ld hl,0e293h                    ; D7F0
        jr DD801                        ; D7F3
DD7F5:
        ld d,003h                       ; D7F5
        ld e,0fch                       ; D7F7
        jr DD805                        ; D7F9
DD7FB:
        ld d,00ch                       ; D7FB
        ld e,0f3h                       ; D7FD
        jr DD805                        ; D7FF
DD801:
        ld d,030h                       ; D801
        ld e,0cfh                       ; D803
DD805:
        di                              ; D805
        ld a,(hl)                       ; D806
        and d                           ; D807
        ld b,a                          ; D808
        ld a,(0ffffh)                   ; D809
        cpl                             ; D80C
        and e                           ; D80D
        or b                            ; D80E
        ld (0ffffh),a                   ; D80F
        dec hl                          ; D812
        ld a,(hl)                       ; D813
        and d                           ; D814
        ld b,a                          ; D815
        in a,(0a8h)                     ; D816
        and e                           ; D818
        or b                            ; D819
        out (0a8h),a                    ; D81A
        ret                             ; D81C
