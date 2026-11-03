
; LOGOTOPO.CM: el logotipo animado de Topo con su música (común a otros juegos de Topo)
LOGO_TOPO:
        jp T95D1                        ; 9470
T9473:
        ld hl,02f78h                    ; 9473
        ld de,02fb8h                    ; 9476
        ld bc,000f7h                    ; 9479
T947C:
        and a                           ; 947C
        sbc hl,de                       ; 947D
        ret z                           ; 947F
        add hl,de                       ; 9480
        ld a,081h                       ; 9481
        call T94A6                      ; 9483
        push hl                         ; 9486
        add hl,bc                       ; 9487
        ld a,081h                       ; 9488
        call T94A6                      ; 948A
        pop hl                          ; 948D
        push hl                         ; 948E
        ld a,0f1h                       ; 948F
        call T94A6                      ; 9491
        add hl,bc                       ; 9494
        ld a,0f1h                       ; 9495
        call T94A6                      ; 9497
        pop hl                          ; 949A
        ei                              ; 949B
        push bc                         ; 949C
        ld b,003h                       ; 949D
T949F:
        halt                            ; 949F
        djnz T949F                      ; 94A0
        pop bc                          ; 94A2
        di                              ; 94A3
        jr T947C                        ; 94A4
T94A6:
        push bc                         ; 94A6
        ld b,008h                       ; 94A7
T94A9:
        call 0004dh                     ; 94A9
        inc hl                          ; 94AC
        djnz T94A9                      ; 94AD
        pop bc                          ; 94AF
        ret                             ; 94B0
T94B1:
        ld hl,00000h                    ; 94B1
        add hl,hl                       ; 94B4
        ld de,T96F8                     ; 94B5
        add hl,de                       ; 94B8
        ld (T96F6),hl                   ; 94B9
        ld hl,00000h                    ; 94BC
        add hl,hl                       ; 94BF
        ld de,T9694                     ; 94C0
        add hl,de                       ; 94C3
        ld e,(hl)                       ; 94C4
        inc hl                          ; 94C5
        ld d,(hl)                       ; 94C6
        ld hl,T9728                     ; 94C7
        add hl,de                       ; 94CA
        ld a,(hl)                       ; 94CB
        ld (094f1h),a                   ; 94CC
        inc hl                          ; 94CF
        ld a,(hl)                       ; 94D0
        ld (094ddh),a                   ; 94D1
        inc hl                          ; 94D4
        ld (T96F4),hl                   ; 94D5
        ld ix,(T96F6)                   ; 94D8
        ld c,00ah                       ; 94DC
T94DE:
        ld e,(ix+000h)                  ; 94DE
        inc ix                          ; 94E1
        ld d,(ix+000h)                  ; 94E3
        inc ix                          ; 94E6
        ld hl,00000h                    ; 94E8
        add hl,de                       ; 94EB
        ld de,(T96F4)                   ; 94EC
        ld b,000h                       ; 94F0
T94F2:
        ld a,(de)                       ; 94F2
T94F3:
        or (hl)                         ; 94F3
        inc de                          ; 94F4
        res 7,h                         ; 94F5
        res 6,h                         ; 94F7
        call 0004dh                     ; 94F9
        inc hl                          ; 94FC
        set 6,h                         ; 94FD
        set 7,h                         ; 94FF
        djnz T94F2                      ; 9501
        ld (T96F4),de                   ; 9503
        dec c                           ; 9507
        jr nz,T94DE                     ; 9508
        ret                             ; 950A
T950B:
        ld a,00fh                       ; 950B
        ld (T94B1+1),a                  ; 950D
        ld a,078h                       ; 9510
        ld (094e9h),a                   ; 9512
        xor a                           ; 9515
        ld (T94F3),a                    ; 9516
        ld hl,T96B2                     ; 9519
T951C:
        ld a,(hl)                       ; 951C
        cp 0ffh                         ; 951D
        ret z                           ; 951F
        ld (094bdh),a                   ; 9520
        push hl                         ; 9523
        ei                              ; 9524
        ld b,002h                       ; 9525
T9527:
        halt                            ; 9527
        djnz T9527                      ; 9528
        di                              ; 952A
        call T94B1                      ; 952B
        pop hl                          ; 952E
        inc hl                          ; 952F
        jr T951C                        ; 9530
T9532:
        ld a,007h                       ; 9532
        ld (094bdh),a                   ; 9534
        ld a,006h                       ; 9537
        ld (T94B1+1),a                  ; 9539
        ld a,000h                       ; 953C
T953E:
        cp 018h                         ; 953E
        ret z                           ; 9540
        ld (094e9h),a                   ; 9541
        push af                         ; 9544
        call T94B1                      ; 9545
        pop af                          ; 9548
        add a,008h                      ; 9549
        jr T953E                        ; 954B
T954D:
        ld a,009h                       ; 954D
        ld (094bdh),a                   ; 954F
        ld a,007h                       ; 9552
        ld (T94B1+1),a                  ; 9554
        ld a,090h                       ; 9557
T9559:
        cp 050h                         ; 9559
        ret z                           ; 955B
        ld (094e9h),a                   ; 955C
        push af                         ; 955F
        ei                              ; 9560
        halt                            ; 9561
        di                              ; 9562
        call T94B1                      ; 9563
        pop af                          ; 9566
        sub 008h                        ; 9567
        jr T9559                        ; 9569
T956B:
        ld a,0b6h                       ; 956B
        ld (T94F3),a                    ; 956D
        ld a,008h                       ; 9570
        ld (094bdh),a                   ; 9572
        ld a,038h                       ; 9575
        ld (094e9h),a                   ; 9577
        ld a,000h                       ; 957A
T957C:
        cp 007h                         ; 957C
        jr z,T958B                      ; 957E
        ld (T94B1+1),a                  ; 9580
        push af                         ; 9583
        call T94B1                      ; 9584
        pop af                          ; 9587
        inc a                           ; 9588
        jr T957C                        ; 9589
T958B:
        jp T94B1                        ; 958B
T958E:
        ld a,00ah                       ; 958E
        ld (094bdh),a                   ; 9590
        ld hl,T96CC                     ; 9593
T9596:
        ld a,(hl)                       ; 9596
        cp 0ffh                         ; 9597
        jr z,T95AB                      ; 9599
        inc hl                          ; 959B
        ld (094e9h),a                   ; 959C
        ld a,(hl)                       ; 959F
        inc hl                          ; 95A0
        ld (T94B1+1),a                  ; 95A1
        push hl                         ; 95A4
        call T94B1                      ; 95A5
        pop hl                          ; 95A8
        jr T9596                        ; 95A9
T95AB:
        jp T94B1                        ; 95AB
T95AE:
        ld hl,T96E9                     ; 95AE
T95B1:
        ld a,(hl)                       ; 95B1
        cp 0ffh                         ; 95B2
        ret z                           ; 95B4
        push hl                         ; 95B5
        ld (094bdh),a                   ; 95B6
        ld a,0b0h                       ; 95B9
        ld (094e9h),a                   ; 95BB
        ld a,00dh                       ; 95BE
        ld (T94B1+1),a                  ; 95C0
        ei                              ; 95C3
        ld b,004h                       ; 95C4
T95C6:
        halt                            ; 95C6
        djnz T95C6                      ; 95C7
        di                              ; 95C9
        call T94B1                      ; 95CA
        pop hl                          ; 95CD
        inc hl                          ; 95CE
        jr T95B1                        ; 95CF
T95D1:
        di                              ; 95D1
        xor a                           ; 95D2
        ld (T94F3),a                    ; 95D3
        call T9602                      ; 95D6
        call T9532                      ; 95D9
        call T954D                      ; 95DC
        call T9688                      ; 95DF
        call T956B                      ; 95E2
        call T9688                      ; 95E5
        call T958E                      ; 95E8
        call T962B                      ; 95EB
        call T9614                      ; 95EE
        call T950B                      ; 95F1
        call T950B                      ; 95F4
        call T950B                      ; 95F7
        call T9473                      ; 95FA
        call T95AE                      ; 95FD
        ei                              ; 9600
        ret                             ; 9601
T9602:
        ld hl,02000h                    ; 9602
        ld bc,01800h                    ; 9605
T9608:
        ld a,0f0h                       ; 9608
        call 0004dh                     ; 960A
        inc hl                          ; 960D
        dec bc                          ; 960E
        ld a,b                          ; 960F
        or c                            ; 9610
        jr nz,T9608                     ; 9611
        ret                             ; 9613
T9614:
        ld hl,02f78h                    ; 9614
        ld a,081h                       ; 9617
        ld c,002h                       ; 9619
T961B:
        ld b,040h                       ; 961B
T961D:
        call 0004dh                     ; 961D
        inc hl                          ; 9620
        djnz T961D                      ; 9621
        ld de,000c0h                    ; 9623
        add hl,de                       ; 9626
        dec c                           ; 9627
        jr nz,T961B                     ; 9628
        ret                             ; 962A
T962B:
        ld de,00008h                    ; 962B
        ld hl,02658h                    ; 962E
T9631:
        push hl                         ; 9631
        ld b,005h                       ; 9632
        push de                         ; 9634
T9635:
        ld a,071h                       ; 9635
        call T967E                      ; 9637
        ld de,000f8h                    ; 963A
        add hl,de                       ; 963D
        djnz T9635                      ; 963E
        ld b,006h                       ; 9640
T9642:
        ld a,031h                       ; 9642
        call T967E                      ; 9644
        add hl,de                       ; 9647
        djnz T9642                      ; 9648
        pop de                          ; 964A
        pop hl                          ; 964B
        push hl                         ; 964C
        add hl,de                       ; 964D
        push de                         ; 964E
        ld b,005h                       ; 964F
T9651:
        ld a,071h                       ; 9651
        call T967E                      ; 9653
        ld de,000f8h                    ; 9656
        add hl,de                       ; 9659
        djnz T9651                      ; 965A
        ld b,006h                       ; 965C
T965E:
        ld a,031h                       ; 965E
        call T967E                      ; 9660
        add hl,de                       ; 9663
        djnz T965E                      ; 9664
        pop de                          ; 9666
        pop hl                          ; 9667
        ld a,e                          ; 9668
        cp 098h                         ; 9669
        ret z                           ; 966B
        ei                              ; 966C
        ld b,004h                       ; 966D
T966F:
        halt                            ; 966F
        djnz T966F                      ; 9670
        di                              ; 9672
        add a,010h                      ; 9673
        ld e,a                          ; 9675
        push de                         ; 9676
        ld de,0fff8h                    ; 9677
        add hl,de                       ; 967A
        pop de                          ; 967B
        jr T9631                        ; 967C
T967E:
        ld c,008h                       ; 967E
T9680:
        call 0004dh                     ; 9680
        inc hl                          ; 9683
        dec c                           ; 9684
        jr nz,T9680                     ; 9685
        ret                             ; 9687
T9688:
        ld hl,00000h                    ; 9688
        ld de,0c000h                    ; 968B
        ld bc,01800h                    ; 968E
        jp 00059h                       ; 9691
T9694:
        db 000h,000h,082h,000h,004h,001h,086h,001h,008h,002h,08Ah,002h,00Ch,003h,08Eh,003h; 9694
        db 0A8h,006h,0EAh,007h,0CCh,009h,0FEh,00Bh,078h,00Ch,0F2h,00Ch,06Ch,00Dh; 96A4
T96B2:
        db 001h,001h,002h,002h,003h,003h,004h,004h,005h,005h,006h,006h,005h,005h,004h,004h; 96B2
        db 003h,003h,002h,002h,001h,001h,000h,000h,0FFh,0FFh; 96C2
T96CC:
        db 030h,006h,030h,005h,030h,004h,038h,004h,038h,003h,040h,002h,048h,002h,050h,001h; 96CC
        db 058h,002h,060h,002h,068h,003h,070h,004h,070h,005h,070h,006h,0FFh; 96DC
T96E9:
        db 00Bh,00Ch,00Dh,00Ch,00Bh,00Ch,00Dh,00Eh,0FFh,000h,000h; 96E9
T96F4:
        db 000h,000h                                       ; 96F4
T96F6:
        db 000h,000h                                       ; 96F6
T96F8:
        db 000h,0C0h,000h,0C1h,000h,0C2h,000h,0C3h,000h,0C4h,000h,0C5h,000h,0C6h,000h,0C7h; 96F8
        db 000h,0C8h,000h,0C9h,000h,0CAh,000h,0CBh,000h,0CCh,000h,0CDh,000h,0CEh,000h,0CFh; 9708
        db 000h,0D0h,000h,0D1h,000h,0D2h,000h,0D3h,000h,0D4h,000h,0D5h,000h,0D6h,000h,0D7h; 9718
T9728:
        db 040h,002h,000h,000h,000h,01Fh                   ; 9728
        db "?xp?"                                       ; 972E
        db 000h,000h,000h,0E0h,0F8h,03Ch,001h,0FDh,000h,000h,000h,01Fh,07Fh,0F8h,0C0h,080h; 9732
        db 000h,000h,000h,0F0h,0FCh,03Eh,007h,003h,000h,000h,000h,003h,007h,01Eh,038h,03Fh; 9742
        db 000h,000h,000h,0FFh,0FFh,000h,000h,080h,000h,000h,000h,09Fh,09Fh,090h,000h,000h; 9752
        db 000h,000h,000h,0FEh,0FEh,0C2h,0C0h,0C0h,00Fh,070h,038h,01Fh,007h,000h,000h,000h; 9762
        db 0FDh,01Ch,038h,0F0h,0C0h,000h,000h,000h,0C0h,0F0h,07Ch,01Fh,007h,000h,000h,000h; 9772
        db 007h,01Eh,07Ch,0F0h,0C0h,000h,000h,000h         ; 9782
        db "?0000"                                      ; 978A
        db 000h,000h,000h,080h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h; 978F
        db 000h,000h,000h,0C0h,0C0h,0C0h,0C0h,0C0h,000h,000h,000h,040h,002h,000h,000h,000h; 979F
        db 000h,000h,000h,01Fh,078h,000h,000h,000h,000h,000h,000h,0E0h,03Ch,000h,000h,000h; 97AF
        db 000h,000h,000h,01Fh,0F8h,000h,000h,000h,000h,000h,000h,0F0h,01Eh,000h,000h,000h; 97BF
        db 000h,000h,000h,003h,01Eh,000h,000h,000h,000h,000h,000h,0FFh,000h,000h,000h,000h; 97CF
        db 000h,000h,000h,09Fh,090h,000h,000h,000h,000h,000h,000h,0FEh,0C2h,03Fh,070h,01Fh; 97DF
        db 000h,000h,000h,000h,000h,0FDh,01Ch,0F0h,000h,000h,000h,000h,000h,080h,0F0h,03Fh; 97EF
        db 000h,000h,000h,000h,000h,003h,01Eh,0F8h,000h,000h,000h,000h,000h,03Fh,030h,030h; 97FF
        db 000h,000h,000h,000h,000h,080h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h; 980F
        db 000h,000h,000h,000h,000h,0C0h,0C0h,0C0h,000h,000h,000h,000h,000h,040h,002h,000h; 981F
        db 000h,000h,000h,000h,000h,000h,01Fh,000h,000h,000h,000h,000h,000h,000h,0E0h,000h; 982F
        db 000h,000h,000h,000h,000h,000h,07Fh,000h,000h,000h,000h,000h,000h,000h,0FCh,000h; 983F
        db 000h,000h,000h,000h,000h,000h,003h,000h,000h,000h,000h,000h,000h,000h,0FFh,000h; 984F
        db 000h,000h,000h,000h,000h,000h,09Fh,000h,000h,000h,000h,000h,000h,000h,0FEh,03Fh; 985F
        db 01Fh,000h,000h,000h,000h,000h,000h,0FDh,0F0h,000h,000h,000h,000h,000h,000h,0C0h; 986F
        db 07Fh,000h,000h,000h,000h,000h,000h,007h,0FCh,000h,000h,000h,000h,000h,000h,03Fh; 987F
        db 030h,000h,000h,000h,000h,000h,000h,080h,000h,000h,000h,000h,000h,000h,000h,000h; 988F
        db 000h,000h,000h,000h,000h,000h,000h,0C0h,0C0h,000h,000h,000h,000h,000h,000h,040h; 989F
        db 002h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h; 98AF
        db 000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h; 98BF
        db 000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h; 98CF
        db 000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h; 98DF
        db 000h,03Fh,000h,000h,000h,000h,000h,000h,000h,0FDh,000h,000h,000h,000h,000h,000h; 98EF
        db 000h,0FFh,000h,000h,000h,000h,000h,000h,000h,0FFh,000h,000h,000h,000h,000h,000h; 98FF
        db 000h,03Fh,000h,000h,000h,000h,000h,000h,000h,0FFh,000h,000h,000h,000h,000h,000h; 990F
        db 000h,09Fh,000h,000h,000h,000h,000h,000h,000h,0FEh,000h,000h,000h,000h,000h,000h; 991F
        db 000h,040h,002h,000h,000h,000h,000h,000h,000h,000h,01Fh,000h,000h,000h,000h,000h; 992F
        db 000h,000h,0F0h,000h,000h,000h,000h,000h,000h,000h,07Fh,000h,000h,000h,000h,000h; 993F
        db 000h,000h,0FCh,000h,000h,000h,000h,000h,000h,000h,030h,000h,000h,000h,000h,000h; 994F
        db 000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h; 995F
        db 000h,000h,0C0h,03Fh,01Fh,000h,000h,000h,000h,000h,000h,0FDh,0E0h,000h,000h,000h; 996F
        db 000h,000h,000h,0C0h,07Fh,000h,000h,000h,000h,000h,000h,007h,0FCh,000h,000h,000h; 997F
        db 000h,000h,000h,03Fh,003h,000h,000h,000h,000h,000h,000h,080h,0FFh,000h,000h,000h; 998F
        db 000h,000h,000h,000h,09Fh,000h,000h,000h,000h,000h,000h,0C0h,0FEh,000h,000h,000h; 999F
        db 000h,000h,000h,040h,002h,000h,000h,000h,000h,000h,000h,01Fh,070h,000h,000h,000h; 99AF
        db 000h,000h,000h,0F0h,01Ch,000h,000h,000h,000h,000h,000h,03Fh,0F0h,000h,000h,000h; 99BF
        db 000h,000h,000h,0F8h,01Eh,000h,000h,000h,000h,000h,000h,030h,030h,000h,000h,000h; 99CF
        db 000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h; 99DF
        db 000h,000h,000h,0C0h,0C0h,03Fh,078h,01Fh,000h,000h,000h,000h,000h,0FDh,03Ch,0E0h; 99EF
        db 000h,000h,000h,000h,000h,080h,0F8h,01Fh,000h,000h,000h,000h,000h,003h,01Eh,0F0h; 99FF
        db 000h,000h,000h,000h,000h,03Fh,01Eh,003h,000h,000h,000h,000h,000h,080h,000h,0FFh; 9A0F
        db 000h,000h,000h,000h,000h,000h,090h,09Fh,000h,000h,000h,000h,000h,0C0h,0C2h,0FEh; 9A1F
        db 000h,000h,000h,000h,000h,040h,002h,000h,000h,000h,007h,01Fh,038h,070h,00Fh,000h; 9A2F
        db 000h,000h,0C0h,0F0h,038h,01Ch,0FDh,000h,000h,000h,007h,01Fh,07Ch,0F0h,0C0h,000h; 9A3F
        db 000h,000h,0C0h,0F0h,07Ch,01Eh,007h,000h,000h,000h; 9A4F
        db "0000?"                                      ; 9A59
        db 000h,000h,000h,000h,000h,000h,000h,080h,000h,000h,000h,000h,000h,000h,000h,000h; 9A5E
        db 000h,000h,000h,0C0h,0C0h,0C0h,0C0h,0C0h         ; 9A6E
        db "?px?"                                       ; 9A76
        db 01Fh,000h,000h,000h,0FDh,001h,03Ch,0F8h,0E0h,000h,000h,000h,080h,0C0h,0F8h,07Fh; 9A7A
        db 01Fh,000h,000h,000h,003h,007h,03Eh,0FCh,0F0h,000h,000h,000h,03Fh,038h,01Eh,007h; 9A8A
        db 003h,000h,000h,000h,080h,000h,000h,0FFh,0FFh,000h,000h,000h,000h,000h,090h,09Fh; 9A9A
        db 09Fh,000h,000h,000h,0C0h,0C0h,0C2h,0FEh,0FEh,000h,000h,000h,048h,00Bh,000h,000h; 9AAA
        db 000h,000h,000h,000h,000h,000h,000h,000h,003h,002h,002h,002h,002h,002h,000h,000h; 9ABA
        db 0FFh,000h,07Fh,03Fh,01Fh,000h,000h,000h,0FFh,000h,070h,0DDh,072h,000h,000h,000h; 9ACA
        db 0FFh,000h,000h,050h,0A8h,001h,000h,000h,0F0h,010h,010h,050h,0D0h,0D0h,000h,000h; 9ADA
        db 000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h; 9AEA
        db 000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,002h,002h; 9AFA
        db 002h,002h,002h,002h,002h,002h,00Fh,008h,084h,08Ah,041h,08Ah,045h,088h,0FFh,000h; 9B0A
        db 000h,000h,000h,000h,000h,080h,0FDh,005h,005h,005h,005h,005h,005h,005h,0D0h,0D0h; 9B1A
        db 0D0h,090h,0D0h,0D0h,050h,0D0h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h; 9B2A
        db 000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h; 9B3A
        db 000h,000h,000h,000h,000h,000h,002h,002h,002h,002h,002h,002h; 9B4A
        db "> EJ"                                       ; 9B56
        db 0CDh,0A8h,0EDh,06Ah,0CDh,0EAh,000h,000h,040h,080h,040h,020h,040h,0A0h,004h,005h; 9B5A
        db 005h,005h,004h,005h,005h,005h,090h,0D0h,050h,0D0h,090h,0D0h,050h,0C0h,000h,000h; 9B6A
        db 000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h; 9B7A
        db 000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h; 9B8A
        db "'#!    (m"                                  ; 9B98
        db 0AAh,0CDh,00Eh,0FFh,0FEh,0FFh,0FFh,010h,0A8h,044h,0A8h,050h,0AAh,045h,0AAh,004h; 9BA1
        db 005h,004h,004h,007h,000h,000h,000h,0B8h,07Ch,0F8h,000h,0F0h,020h,020h,040h,000h; 9BB1
        db 000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h; 9BC1
        db 000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h; 9BD1
        db " ($($($("                                   ; 9BE0
        db 0FFh,0FFh,0FFh,0BFh,0BFh,0BFh,09Fh,087h,0D1h,0EAh,0D5h,0EAh,0F4h,0FEh,0FFh,0FFh; 9BE8
        db 040h,020h,050h,0A8h,004h,0ABh,0D0h,0F8h,040h,080h,080h,080h,080h,000h,000h,000h; 9BF8
        db 000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h; 9C08
        db 000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h; 9C18
        db "$($(&$.*"                                   ; 9C28
        db 080h,080h,080h,080h,080h,080h,0FCh,004h,000h,000h,000h,000h,000h,000h,000h,000h; 9C30
        db 000h,001h,001h,001h,001h,000h,003h,00Fh,000h,000h,000h,000h,080h,080h,080h,080h; 9C40
        db 000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h; 9C50
        db 000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h; 9C60
        db "-+& ?"                                      ; 9C70
        db 000h,000h,000h,064h,0C4h,086h,002h,082h,083h,081h,0C1h,000h,000h,003h,007h,01Fh; 9C75
        db 03Fh,0FFh,0FFh,07Fh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0C0h,0C0h,0E0h,0E0h,0F0h; 9C85
        db 0F8h,0F8h,0FCh,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h; 9C95
        db 000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h; 9CA5
        db 000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h; 9CB5
        db "A@` 0"                                      ; 9CC0
        db 012h,019h,00Ah,0FFh,0FFh,0FFh,07Fh,07Fh,03Fh,03Fh,09Fh,0FFh,0FFh,0FFh,0FFh,0FFh; 9CC5
        db 0FFh,0FFh,0FFh,0FEh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,000h,000h,0C0h,0F0h,0FCh; 9CD5
        db 0FFh,0FFh,0FFh,000h,000h,000h,000h,000h,0C0h,0FFh,0FFh,000h,000h,000h,001h,007h; 9CE5
        db 07Fh,0FFh,0FFh,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h; 9CF5
        db 000h,000h,000h,00Dh,006h,002h,003h,001h,000h,000h,000h,04Fh,08Fh,057h,02Bh,095h; 9D05
        db 0CEh,05Bh,06Eh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,07Fh,0BFh,0FFh,0FFh,0FFh,0FFh,0FFh; 9D15
        db 0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FEh,0FDh,0FAh; 9D25
        db 0FDh,0FAh,0F5h,0FAh,0D5h,0AAh,055h,0AAh,055h,0AAh,055h,000h,000h,000h,000h,000h; 9D35
        db 000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h; 9D45
        db 000h,000h,000h,037h,01Ah,00Dh,006h,003h,000h,000h,000h,0DFh,0EFh,0F3h,07Dh,0BEh; 9D55
        db 0DFh,067h,03Bh,0FFh,0FFh,0FFh,0FFh,07Fh,09Fh,0E7h,0E8h,0FFh,0FFh,0FFh,0FFh,0FFh; 9D65
        db 0FFh,0FFh,0FFh,0FAh,0F5h,0EAh,0F5h,0EAh,0F5h,0EAh,0D5h,0AAh,055h,0AAh,055h,0AAh; 9D75
        db 055h,0AAh,055h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h; 9D85
        db 000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h; 9D95
        db 000h,000h,000h,00Ch,007h,001h,000h,000h,000h,000h,000h,0FEh,02Bh,0CEh,071h,01Eh; 9DA5
        db 003h,000h,000h,01Fh,040h,0AAh,015h,000h,0C0h,07Eh,003h,0EAh,0D5h,000h,000h,000h; 9DB5
        db 000h,000h,0FFh,0AAh,040h,000h,000h,000h,000h,00Fh,0F8h,028h,007h,000h,000h,000h; 9DC5
        db 000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h; 9DD5
        db 000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h; 9DE5
        db 000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h; 9DF5
        db 000h,000h,000h,000h,00Fh,000h,000h,000h,000h,000h,000h,0FFh,080h,000h,000h,000h; 9E05
        db 000h,000h,000h,0E0h,03Eh,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,003h; 9E15
        db 006h,00Ch,008h,000h,000h,038h,0E0h,080h,000h,000h,001h,00Ah,035h,00Ah,015h,00Ah; 9E25
        db 000h,02Ah,055h,0AAh,055h,083h,07Ch,0BBh,07Fh,086h,041h,080h,000h,080h,0E0h,038h; 9E35
        db 08Ch,0F4h,0F8h,078h,038h,000h,001h,003h,003h,007h,00Fh,00Fh,01Fh,06Ah,0F5h,0FAh; 9E45
        db 0F5h,0FAh,0F5h,0FAh,0FDh,0AAh,055h,0AAh,055h,0AAh,055h,0AAh,055h,0A0h,040h,0A8h; 9E55
        db 050h,0A0h,054h,0A8h,055h,008h,000h,000h,000h,000h,000h,000h,008h,01Fh; 9E65
        db "????"                                       ; 9E73
        db 07Fh,03Fh,00Fh,0FEh,0FDh,0FEh,0FFh,0FEh,0FFh,0FFh,0FFh,0AAh,055h,0AAh,055h,0AAh; 9E77
        db 0D5h,0FAh,0FFh,0AAh,055h,0AAh,055h,0AAh,055h,0AAh,0D0h,014h,038h,0B4h,03Ah,09Dh; 9E87
        db 02Ah,01Fh,00Eh,000h,010h,028h,010h,008h,004h,00Ah,001h,000h,000h,000h,000h,000h; 9E97
        db 000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h; 9EA7
        db 000h,000h,000h,000h,040h,000h                   ; 9EB7
        db "@hTz]"                                      ; 9EBD
        db 00Ah,004h,002h,001h,002h,001h,000h,000h,080h,040h,020h,050h,0AAh,055h,0A8h,055h; 9EC2
        db 000h,000h,000h,000h,080h,050h,0AAh,045h,000h,000h,000h,000h,000h,000h,000h,055h; 9ED2
        db 077h,07Fh                                       ; 9EE2
        db "^v|xxp"                                     ; 9EE4
        db 000h,000h,000h,000h,000h,000h,000h,000h,00Ah,005h,000h,000h,000h,000h,000h,000h; 9EEA
        db 0AAh,055h,0A2h,015h,000h,000h,000h,000h,02Ah,054h,0A8h,000h,000h,000h,000h,000h; 9EFA
        db 040h,000h,000h,000h,000h,000h,000h,000h,030h,00Ah,000h,000h,000h,000h,000h,000h; 9F0A
        db 000h,000h,000h,000h,000h,000h,000h,000h,000h,00Fh,000h,000h,000h,000h,000h,000h; 9F1A
        db 0FFh,080h,000h,000h,000h,000h,000h,000h,0E0h,03Eh,000h,000h,000h,000h,000h,000h; 9F2A
        db 000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,003h,006h,004h,000h; 9F3A
        db 000h,000h,038h,0E0h,080h,000h,000h,002h,00Fh,03Fh,002h,015h,00Ah,000h,015h,0AAh; 9F4A
        db 055h,0AAh,083h,07Ch,0ADh,03Fh,046h,001h,000h,000h,080h,0E0h,038h,0CCh,0F4h,0F8h; 9F5A
        db 078h,038h,000h,000h,000h,000h,000h,000h,000h,000h,000h,001h,003h,003h,001h,000h; 9F6A
        db 000h,008h,07Fh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,07Fh,0D5h,0EAh,0D5h,0EAh,0D5h,0AAh; 9F7A
        db 0D5h,0AAh,000h,000h,000h,000h,040h,080h,040h,080h,008h,000h,000h,000h,000h,008h; 9F8A
        db 004h,00Ah,000h,000h,000h,000h,000h,000h,000h,000h,014h,038h,034h,03Ah,01Dh,02Ah; 9F9A
        db 01Fh,00Eh,07Fh                                  ; 9FAA
        db "????"                                       ; 9FAD
        db 01Fh,00Fh,003h,0D5h,0EAh,0D5h,0EAh,0F5h,0FAh,0FDh,0FEh,050h,0A0h,050h,0A8h,051h; 9FB1
        db 0A8h,054h,0A8h,014h,02Ah,015h,03Eh,03Fh,07Fh,03Fh,00Eh,000h,000h,000h,000h,000h; 9FC1
        db 000h,000h,000h,000h,040h,000h                   ; 9FD1
        db "@hTz]"                                      ; 9FD7
        db 000h,050h,050h,050h,0A0h,0A0h,0A0h,0AAh,000h,000h,000h,000h,000h,000h,000h,0A0h; 9FDC
        db 000h,001h,001h,001h,000h,000h,000h,000h,000h,000h,000h,004h,082h,095h,0AAh,095h; 9FEC
        db 000h,000h,000h,000h,000h,000h,000h,000h,077h,07Fh; 9FFC
        db "^v}zyr"                                     ; A006
        db 015h,06Ah,095h,02Ah,015h,0AAh,055h,0AAh,051h,0AAh,055h,0AAh,055h,0AAh,055h,0AAh; A00C
        db 040h,0AAh,055h,0AAh,055h,0AAh,055h,0AAh,04Ah,0D5h,06Ah,0A4h,074h,0B8h,078h,0F0h; A01C
        db 000h,000h,000h,000h,000h,000h,000h,000h         ; A02C
        db "E*UjujuzU"                                  ; A034
        db 0AAh,055h,0AAh,057h,0AFh,05Fh,0BFh,055h,0AAh,05Fh,0BFh,0FFh,0F8h,0F8h,0FAh,055h; A03D
        db 0FFh,0FEh,0F9h,0C2h,005h,002h,000h,0C0h,0B8h,068h,0B8h,0E0h,048h,038h,0E0h,000h; A04D
        db 000h,000h,000h,000h,000h,000h,000h              ; A05D
        db "?W+U+U*U"                                   ; A064
        db 0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FBh,0FBh,0FBh,0FBh,0F1h,0E0h,0C0h,080h; A06C
        db 003h,09Eh,0B0h,0A0h,0A0h,020h,060h,0C0h,080h,000h,000h,000h,000h,000h,000h,000h; A07C
        db 000h,000h,000h,000h,000h,000h,000h,000h         ; A08C
        db "*U*U*U(C"                                   ; A094
        db 0FFh,07Eh,0F8h,075h,08Ah,035h,0E8h,0B3h,001h,043h,0A6h,04Ch,0B8h,060h,0C0h,080h; A09C
        db 080h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h; A0AC
        db 000h,000h,000h,000h,000h,000h,000h,000h,01Fh,07Fh,07Eh,071h,00Fh,078h,0C0h,000h; A0BC
        db 0E6h,09Ch,070h,0C0h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h; A0CC
        db 000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h; A0DC
        db 000h,000h,000h,000h,000h,000h,000h,000h,038h,00Ah,000h,000h,000h,000h,000h,000h; A0EC
        db 000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h; A0FC
        db 000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h; A10C
        db 000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h; A11C
        db 000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h; A12C
        db 000h,000h,000h,000h,000h,000h,000h,000h,000h,00Fh,000h,000h,000h,000h,000h,000h; A13C
        db 0FFh,080h,000h,000h,000h,000h,000h,000h,0F0h,03Eh,000h,000h,000h,000h,000h,000h; A14C
        db 000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h; A15C
        db 000h,000h,000h,000h,003h,006h,004h,000h,000h,000h,038h,0E0h,080h,000h,000h,003h; A16C
        db 00Fh,03Fh,001h,02Ah,045h,000h,028h,0D4h,0AAh,0D5h,043h,0ACh,05Bh,03Fh,006h,001h; A17C
        db 000h,000h,080h,0E0h,038h,0CCh,0B6h,0FBh,07Dh,03Eh,000h,000h,000h,000h,000h,000h; A18C
        db 080h,0C0h,000h,000h,000h,000h,000h,000h,000h,000h,000h,001h,003h,003h,001h,008h; A19C
        db 004h,00Ah,07Fh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,07Fh,0AAh,0D5h,0AAh,0D5h,0EAh,0D5h; A1AC
        db 0EAh,0F5h,000h,000h,000h,000h,080h,000h,080h,040h,00Fh,007h,003h,003h,001h,000h; A1BC
        db 000h,000h,060h,0B0h,0D0h,058h,0C8h,06Ch,0F4h,056h,000h,000h,000h,000h,000h,000h; A1CC
        db 000h,000h,014h,02Ah,015h,03Eh,03Fh,07Fh,03Fh,00Eh,07Fh; A1DC
        db "????"                                       ; A1E7
        db 0DFh,08Fh,003h,0EAh,0F5h,0FAh,0FDh,0FFh,0FFh,0FFh,0FFh,0A0h,050h,0A8h,055h,0AAh; A1EB
        db 0D5h,0FAh,0FFh,000h,001h,003h,011h,0ACh,054h,0B8h,0E0h,07Ah,0B2h,0AAh,093h,0A9h; A1FB
        db 095h,049h,041h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,004h,002h; A20B
        db 015h,02Ah,015h,000h,010h,010h,010h,0A0h,0A0h,0A4h,06Ah,000h,000h,000h,000h,000h; A21B
        db 000h,000h,080h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h; A22B
        db 000h,000h,000h                                  ; A23B
        db "AAAA"                                       ; A23E
        db 0A1h,093h,0AAh,092h,000h,000h,000h,000h,000h,000h,000h,000h,00Ah,015h,00Ah,004h; A242
        db 005h,003h,003h,001h,055h,06Ah,0F5h,0FEh,0FFh,0FFh,0FFh,0FFh,050h,0A8h,055h,0AAh; A252
        db 055h,0EAh,0F5h,0FAh,000h,000h,000h,080h,040h,080h,040h,0A0h,001h,001h,002h,002h; A262
        db 005h,00Bh,009h,037h,02Ah,056h,0A4h,0CCh,068h,0D8h,0D0h,030h,000h,000h,000h,000h; A272
        db 000h,000h,000h,000h,000h,000h,000h,000h,004h,006h,003h,000h,07Fh,03Fh,00Fh,003h; A282
        db 000h,005h,082h,0E5h,0FDh,0FAh,0FDh,0FFh,03Fh,040h,0ADh,057h,050h,0A9h,05Eh,0F9h; A292
        db 087h,05Fh,0F7h,07Ch,04Bh,0BEh,07Dh,0FBh,0F6h,0CCh,038h,0E0h,060h,0C0h,080h,000h; A2A2
        db 000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h; A2B2
        db 000h,000h,000h,000h,038h,00Fh,000h,000h,000h,000h,000h,000h,02Dh,080h,0FFh,000h; A2C2
        db 000h,000h,000h,000h,0C3h,03Eh,0E0h,000h,000h,000h,000h,000h,080h,000h,000h,000h; A2D2
        db 000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h; A2E2
        db 000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h; A2F2
        db 000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h; A302
        db 000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h; A312
        db 000h,000h,000h,000h,018h,005h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h; A322
        db 000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h; A332
        db 000h,000h,000h,000h,000h,001h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h; A342
        db 000h,000h,000h,000h,000h,000h,001h,001h,000h,0FEh,0FEh,0C2h,0C0h,0C1h,000h,000h; A352
        db 000h,000h,0F0h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,0C1h,0C0h; A362
        db 0C0h,0C0h,0C0h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h; A372
        db 000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h; A382
        db 000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,018h,005h; A392
        db 000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h; A3A2
        db 000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,001h,001h,001h,001h; A3B2
        db 000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h; A3C2
        db 001h,001h,000h,0FEh,0FEh,0C2h,0C0h,0C1h,000h,000h,040h,000h,0FEh,000h,000h,040h; A3D2
        db 000h,000h,000h,000h,000h,000h,000h,000h,0C1h,0C1h,0C1h,0C1h,0C0h,000h,000h,000h; A3E2
        db 000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h; A3F2
        db 000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h; A402
        db 000h,000h,000h,000h,000h,000h,000h,000h,018h,005h,000h,000h,000h,000h,000h,000h; A412
        db 000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h; A422
        db 000h,000h,000h,000h,001h,001h,001h,001h,001h,001h,000h,000h,000h,000h,000h,000h; A432
        db 000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,001h,011h,000h,0FEh,0FEh,0C2h; A442
        db 0C0h,0C9h,000h,020h,040h,000h,0FFh,000h,000h,040h,000h,000h,000h,000h,080h,000h; A452
        db 000h,000h,0C1h,0C1h,0C1h,0C1h,0C1h,001h,000h,000h,020h,000h,000h,000h,000h,000h; A462
        db 000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h; A472
        db 000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h; A482
        db 000h,000h,018h,005h,000h,000h,000h,000h,000h,000h,001h,001h,000h,000h,000h,000h; A492
        db 000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,001h,001h,001h,001h; A4A2
        db 001h,001h,001h,001h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h; A4B2
        db 000h,000h,000h,000h,021h,011h,000h,0FEh,0FEh,0C2h,0C0h,0C9h,010h,020h,040h,000h; A4C2
        db 0FFh,000h,000h,040h,000h,000h,000h,000h,0F0h,000h,000h,000h,0D1h,0C1h,0C1h,0C1h; A4D2
        db 0C1h,001h,001h,001h,020h,010h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h; A4E2
        db 000h,000h,000h,000h,001h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h; A4F2
        db 000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h; A502
