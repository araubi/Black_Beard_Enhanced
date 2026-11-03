
; Interrupción de la presentación: música mientras se espera una tecla
INT_PRESENTACION:
        di                              ; 8400
        push af                         ; 8401
        in a,(099h)                     ; 8402
        and a                           ; 8404
        jp p,L8425                      ; 8405
        push bc                         ; 8408
        push de                         ; 8409
        push hl                         ; 840A
        exx                             ; 840B
        ex af,af'                       ; 840C
        push af                         ; 840D
        push bc                         ; 840E
        push de                         ; 840F
        push hl                         ; 8410
        push ix                         ; 8411
        push iy                         ; 8413
        call L8473                      ; 8415
        pop iy                          ; 8418
        pop ix                          ; 841A
        pop hl                          ; 841C
        pop de                          ; 841D
        pop bc                          ; 841E
        pop af                          ; 841F
        exx                             ; 8420
        ex af,af'                       ; 8421
        pop hl                          ; 8422
        pop de                          ; 8423
        pop bc                          ; 8424
L8425:
        pop af                          ; 8425
        ei                              ; 8426
        ret                             ; 8427
        push af                         ; 8428
        push de                         ; 8429
        and 07fh                        ; 842A
        ld de,0002eh                    ; 842C
        call L8815                      ; 842F
        ld de,L8951                     ; 8432
        add hl,de                       ; 8435
        push hl                         ; 8436
        ld a,(hl)                       ; 8437
        inc hl                          ; 8438
        or (hl)                         ; 8439
        jr z,L844E                      ; 843A
        ld d,003h                       ; 843C
        ld hl,L8951                     ; 843E
        ld bc,0002eh                    ; 8441
L8444:
        inc hl                          ; 8444
        ld a,(hl)                       ; 8445
        dec hl                          ; 8446
        or (hl)                         ; 8447
        jr z,L8451                      ; 8448
        add hl,bc                       ; 844A
        dec d                           ; 844B
        jr nz,L8444                     ; 844C
L844E:
        pop hl                          ; 844E
        jr L8460                        ; 844F
L8451:
        pop de                          ; 8451
        jr L8460                        ; 8452
MUSICA_CANAL:
        push af                         ; 8454
        push de                         ; 8455
        ld de,0002eh                    ; 8456
        call L8815                      ; 8459
        ld de,L8951                     ; 845C
        add hl,de                       ; 845F
L8460:
        push hl                         ; 8460
        xor a                           ; 8461
        ld b,02eh                       ; 8462
L8464:
        ld (hl),a                       ; 8464
        inc hl                          ; 8465
        djnz L8464                      ; 8466
        pop hl                          ; 8468
        pop de                          ; 8469
        ld (hl),e                       ; 846A
        inc hl                          ; 846B
        ld (hl),d                       ; 846C
        inc hl                          ; 846D
        ld (hl),e                       ; 846E
        inc hl                          ; 846F
        ld (hl),d                       ; 8470
        pop af                          ; 8471
        ret                             ; 8472
L8473:
        push af                         ; 8473
        ld b,003h                       ; 8474
        xor a                           ; 8476
        ld ix,L8951                     ; 8477
        ld de,L8946                     ; 847B
        ld hl,L894E                     ; 847E
L8481:
        push af                         ; 8481
        push hl                         ; 8482
        push de                         ; 8483
        push bc                         ; 8484
        ld (L8944),a                    ; 8485
        ld a,(ix+004h)                  ; 8488
        or (ix+005h)                    ; 848B
        jp nz,L84EC                     ; 848E
        xor a                           ; 8491
        call L87B6                      ; 8492
        ld c,(ix+002h)                  ; 8495
        ld b,(ix+003h)                  ; 8498
        ld a,b                          ; 849B
        or c                            ; 849C
        jp z,L85A5                      ; 849D
L84A0:
        ld a,(bc)                       ; 84A0
        cp 080h                         ; 84A1
        jp c,L84AF                      ; 84A3
        sub 080h                        ; 84A6
        ld hl,TABLA_ORDENES_MUSICA      ; 84A8
        call L8844                      ; 84AB
        jp (hl)                         ; 84AE
L84AF:
        push af                         ; 84AF
        call L880A                      ; 84B0
        pop af                          ; 84B3
        add a,(hl)                      ; 84B4
        ld hl,L8866                     ; 84B5
        call L8844                      ; 84B8
        ld (ix+00ah),l                  ; 84BB
        ld (ix+00bh),h                  ; 84BE
        inc bc                          ; 84C1
L84C2:
        ld a,(ix+008h)                  ; 84C2
        call L87B6                      ; 84C5
        call L8621                      ; 84C8
        ld (ix+02ah),000h               ; 84CB
        call L8639                      ; 84CF
        ld (ix+02bh),000h               ; 84D2
        ld (ix+02ch),000h               ; 84D6
L84DA:
        ld (ix+002h),c                  ; 84DA
        ld (ix+003h),b                  ; 84DD
        ld l,(ix+006h)                  ; 84E0
        ld h,(ix+007h)                  ; 84E3
        ld (ix+004h),l                  ; 84E6
        ld (ix+005h),h                  ; 84E9
L84EC:
        ld l,(ix+004h)                  ; 84EC
        ld h,(ix+005h)                  ; 84EF
        dec hl                          ; 84F2
        ld (ix+004h),l                  ; 84F3
        ld (ix+005h),h                  ; 84F6
        push ix                         ; 84F9
        pop iy                          ; 84FB
        ld d,002h                       ; 84FD
        ld c,000h                       ; 84FF
L8501:
        ld a,(iy+00ch)                  ; 8501
        or a                            ; 8504
        jr z,L850E                      ; 8505
        dec a                           ; 8507
        ld (iy+00ch),a                  ; 8508
        inc c                           ; 850B
        jr L852F                        ; 850C
L850E:
        ld a,(iy+00eh)                  ; 850E
        or a                            ; 8511
        jr z,L852A                      ; 8512
        dec a                           ; 8514
        ld (iy+00eh),a                  ; 8515
        ld a,(ix+02ah)                  ; 8518
        add a,(iy+01bh)                 ; 851B
        ld (ix+02ah),a                  ; 851E
        ld a,(iy+020h)                  ; 8521
        ld (iy+00ch),a                  ; 8524
        inc c                           ; 8527
        jr L852F                        ; 8528
L852A:
        inc iy                          ; 852A
        dec d                           ; 852C
        jr nz,L8501                     ; 852D
L852F:
        ld a,c                          ; 852F
        or a                            ; 8530
        jr nz,L853A                     ; 8531
        bit 0,(ix+02dh)                 ; 8533
        call nz,L8621                   ; 8537
L853A:
        push ix                         ; 853A
        pop iy                          ; 853C
        ld d,003h                       ; 853E
        ld c,000h                       ; 8540
L8542:
        ld a,(iy+010h)                  ; 8542
        or a                            ; 8545
        jr z,L854F                      ; 8546
        dec a                           ; 8548
        ld (iy+010h),a                  ; 8549
        inc c                           ; 854C
        jr L859A                        ; 854D
L854F:
        ld a,(iy+013h)                  ; 854F
        or a                            ; 8552
        jr z,L8595                      ; 8553
        dec a                           ; 8555
        ld (iy+013h),a                  ; 8556
        ld a,(iy+01dh)                  ; 8559
        or a                            ; 855C
        jp p,L8579                      ; 855D
        ld a,(iy+01dh)                  ; 8560
        cpl                             ; 8563
        inc a                           ; 8564
        ld e,a                          ; 8565
        ld a,(ix+02bh)                  ; 8566
        sub e                           ; 8569
        ld (ix+02bh),a                  ; 856A
        ld a,(ix+02ch)                  ; 856D
        sbc a,000h                      ; 8570
        and 00fh                        ; 8572
        ld (ix+02ch),a                  ; 8574
        jr L858C                        ; 8577
L8579:
        ld a,(ix+02bh)                  ; 8579
        add a,(iy+01dh)                 ; 857C
        ld (ix+02bh),a                  ; 857F
        ld a,(ix+02ch)                  ; 8582
        adc a,000h                      ; 8585
        and 00fh                        ; 8587
        ld (ix+02ch),a                  ; 8589
L858C:
        ld a,(iy+022h)                  ; 858C
        ld (iy+010h),a                  ; 858F
        inc c                           ; 8592
        jr L859A                        ; 8593
L8595:
        inc iy                          ; 8595
        dec d                           ; 8597
        jr nz,L8542                     ; 8598
L859A:
        ld a,c                          ; 859A
        or a                            ; 859B
        jr nz,L85A5                     ; 859C
        bit 1,(ix+02dh)                 ; 859E
        call nz,L8639                   ; 85A2
L85A5:
        pop bc                          ; 85A5
        pop de                          ; 85A6
        pop hl                          ; 85A7
        ld a,(ix+009h)                  ; 85A8
        add a,(ix+02ah)                 ; 85AB
        and 00fh                        ; 85AE
        ld (hl),a                       ; 85B0
        ld a,(ix+00ah)                  ; 85B1
        add a,(ix+02bh)                 ; 85B4
        ld (de),a                       ; 85B7
        inc de                          ; 85B8
        ld a,(ix+00bh)                  ; 85B9
        adc a,(ix+02ch)                 ; 85BC
        ld (de),a                       ; 85BF
        inc de                          ; 85C0
        push de                         ; 85C1
        ld de,0002eh                    ; 85C2
        add ix,de                       ; 85C5
        pop de                          ; 85C7
        pop af                          ; 85C8
        inc a                           ; 85C9
        inc hl                          ; 85CA
        dec b                           ; 85CB
        jp nz,L8481                     ; 85CC
        ld iy,L89DB                     ; 85CF
        ld d,002h                       ; 85D3
        ld c,000h                       ; 85D5
L85D7:
        ld a,(iy+000h)                  ; 85D7
        or a                            ; 85DA
        jr z,L85E4                      ; 85DB
        dec a                           ; 85DD
        ld (iy+000h),a                  ; 85DE
        inc c                           ; 85E1
        jr L8605                        ; 85E2
L85E4:
        ld a,(iy+002h)                  ; 85E4
        or a                            ; 85E7
        jr z,L8600                      ; 85E8
        dec a                           ; 85EA
        ld (iy+002h),a                  ; 85EB
        ld a,(L89E7)                    ; 85EE
        add a,(iy+006h)                 ; 85F1
        ld (L89E7),a                    ; 85F4
        ld a,(iy+008h)                  ; 85F7
        ld (iy+000h),a                  ; 85FA
        inc c                           ; 85FD
        jr L8605                        ; 85FE
L8600:
        inc iy                          ; 8600
        dec d                           ; 8602
        jr nz,L85D7                     ; 8603
L8605:
        ld a,c                          ; 8605
        or a                            ; 8606
        jr nz,L8611                     ; 8607
        ld a,(L89E5)                    ; 8609
        bit 2,a                         ; 860C
        call nz,L8651                   ; 860E
L8611:
        ld a,(L89E6)                    ; 8611
        ld e,a                          ; 8614
        ld a,(L89E7)                    ; 8615
        add a,e                         ; 8618
        ld (L894C),a                    ; 8619
        call L8851                      ; 861C
        pop af                          ; 861F
        ret                             ; 8620
L8621:
        push ix                         ; 8621
        ld d,002h                       ; 8623
L8625:
        ld a,(ix+020h)                  ; 8625
        ld (ix+00ch),a                  ; 8628
        ld a,(ix+016h)                  ; 862B
        ld (ix+00eh),a                  ; 862E
        inc ix                          ; 8631
        dec d                           ; 8633
        jr nz,L8625                     ; 8634
        pop ix                          ; 8636
        ret                             ; 8638
L8639:
        ld d,003h                       ; 8639
        push ix                         ; 863B
L863D:
        ld a,(ix+022h)                  ; 863D
        ld (ix+010h),a                  ; 8640
        ld a,(ix+018h)                  ; 8643
        ld (ix+013h),a                  ; 8646
        inc ix                          ; 8649
        dec d                           ; 864B
        jr nz,L863D                     ; 864C
        pop ix                          ; 864E
        ret                             ; 8650
L8651:
        ld d,002h                       ; 8651
        push iy                         ; 8653
        ld iy,L89DB                     ; 8655
L8659:
        ld a,(iy+008h)                  ; 8659
        ld (iy+000h),a                  ; 865C
        ld a,(iy+004h)                  ; 865F
        ld (iy+002h),a                  ; 8662
        inc iy                          ; 8665
        dec d                           ; 8667
        jr nz,L8659                     ; 8668
        pop iy                          ; 866A
        ret                             ; 866C
        inc bc                          ; 866D
        ld a,(bc)                       ; 866E
        ld (ix+009h),a                  ; 866F
        inc bc                          ; 8672
        jp L84A0                        ; 8673
        inc bc                          ; 8676
        ld a,(bc)                       ; 8677
        ld de,(L8945)                   ; 8678
        ld d,000h                       ; 867C
        call L8815                      ; 867E
        ld (ix+006h),l                  ; 8681
        ld (ix+007h),h                  ; 8684
        inc bc                          ; 8687
        jp L84A0                        ; 8688
        inc bc                          ; 868B
        ld a,(bc)                       ; 868C
        and 009h                        ; 868D
        ld (ix+008h),a                  ; 868F
        inc bc                          ; 8692
        jp L84A0                        ; 8693
        push ix                         ; 8696
        pop hl                          ; 8698
        xor a                           ; 8699
        ld b,02eh                       ; 869A
L869C:
        ld (hl),a                       ; 869C
        inc hl                          ; 869D
        djnz L869C                      ; 869E
        ld a,(L8944)                    ; 86A0
        ld hl,L89E8                     ; 86A3
        xor (hl)                        ; 86A6
        jp nz,L85A5                     ; 86A7
        ld hl,L89DB                     ; 86AA
        ld de,L89DC                     ; 86AD
        ld bc,0000ah                    ; 86B0
        ld (hl),a                       ; 86B3
        ldir                            ; 86B4
        inc de                          ; 86B6
        ld (de),a                       ; 86B7
        jp L85A5                        ; 86B8
        inc bc                          ; 86BB
        ld a,(bc)                       ; 86BC
        push bc                         ; 86BD
        ld de,00010h                    ; 86BE
        call L8815                      ; 86C1
        ld bc,00bb8h                    ; 86C4
        push hl                         ; 86C7
        pop de                          ; 86C8
        call L882A                      ; 86C9
        ld a,c                          ; 86CC
        ld (L8945),a                    ; 86CD
        pop bc                          ; 86D0
        inc bc                          ; 86D1
        jp L84A0                        ; 86D2
        inc bc                          ; 86D5
        ld a,(bc)                       ; 86D6
        push af                         ; 86D7
        and 01fh                        ; 86D8
        ld (L89E6),a                    ; 86DA
        call L8651                      ; 86DD
        pop af                          ; 86E0
        inc bc                          ; 86E1
        or a                            ; 86E2
        jp m,L84A0                      ; 86E3
        jp L84C2                        ; 86E6
        inc bc                          ; 86E9
        jp L84DA                        ; 86EA
        ld c,(ix+000h)                  ; 86ED
        ld b,(ix+001h)                  ; 86F0
        ld (ix+002h),c                  ; 86F3
        ld (ix+003h),b                  ; 86F6
        jp L84A0                        ; 86F9
        inc bc                          ; 86FC
        ld a,(bc)                       ; 86FD
        inc bc                          ; 86FE
        ld de,00000h                    ; 86FF
L8702:
        push af                         ; 8702
        ld a,(bc)                       ; 8703
        push de                         ; 8704
        ld de,(L8945)                   ; 8705
        ld d,000h                       ; 8709
        call L8815                      ; 870B
        pop de                          ; 870E
        add hl,de                       ; 870F
        ex de,hl                        ; 8710
        inc bc                          ; 8711
        pop af                          ; 8712
        dec a                           ; 8713
        jr nz,L8702                     ; 8714
        ld (ix+006h),l                  ; 8716
        ld (ix+007h),h                  ; 8719
        jp L84A0                        ; 871C
        inc bc                          ; 871F
        ld a,(bc)                       ; 8720
        ld e,a                          ; 8721
        or (ix+02dh)                    ; 8722
        ld (ix+02dh),a                  ; 8725
        ld a,(L89E5)                    ; 8728
        or e                            ; 872B
        ld (L89E5),a                    ; 872C
        inc bc                          ; 872F
        jp L84A0                        ; 8730
        inc bc                          ; 8733
        res 0,(ix+02dh)                 ; 8734
        res 1,(ix+02dh)                 ; 8738
        ld a,(bc)                       ; 873C
        ld de,0000fh                    ; 873D
        call L8815                      ; 8740
        ld de,L89F2                     ; 8743
        add hl,de                       ; 8746
        push ix                         ; 8747
        ld d,00fh                       ; 8749
L874B:
        ld a,(hl)                       ; 874B
        ld (ix+016h),a                  ; 874C
        inc hl                          ; 874F
        inc ix                          ; 8750
        dec d                           ; 8752
        jp nz,L874B                     ; 8753
        pop ix                          ; 8756
        inc bc                          ; 8758
        ld (ix+00ch),000h               ; 8759
        ld (ix+00dh),000h               ; 875D
        ld (ix+010h),000h               ; 8761
        ld (ix+011h),000h               ; 8765
        ld (ix+012h),000h               ; 8769
        ld (ix+02ah),000h               ; 876D
        ld (ix+02bh),000h               ; 8771
        ld (ix+02ch),000h               ; 8775
        jp L84A0                        ; 8779
        inc bc                          ; 877C
        ld a,(L89E5)                    ; 877D
        res 2,a                         ; 8780
        ld (L89E5),a                    ; 8782
        ld a,(bc)                       ; 8785
        ld de,00006h                    ; 8786
        call L8815                      ; 8789
        ld de,L8A5B                     ; 878C
        add hl,de                       ; 878F
        ld iy,L89DB                     ; 8790
        ld (iy+000h),000h               ; 8794
        ld (iy+001h),000h               ; 8798
        ld d,006h                       ; 879C
L879E:
        ld a,(hl)                       ; 879E
        ld (iy+004h),a                  ; 879F
        inc hl                          ; 87A2
        inc iy                          ; 87A3
        dec d                           ; 87A5
        jr nz,L879E                     ; 87A6
        xor a                           ; 87A8
        ld (L89E7),a                    ; 87A9
        inc bc                          ; 87AC
        ld a,(L8944)                    ; 87AD
        ld (L89E8),a                    ; 87B0
        jp L84A0                        ; 87B3
L87B6:
        push de                         ; 87B6
        cpl                             ; 87B7
        ld e,a                          ; 87B8
        ld d,009h                       ; 87B9
        ld a,(L8944)                    ; 87BB
L87BE:
        dec a                           ; 87BE
        jp m,L87C9                      ; 87BF
        scf                             ; 87C2
        rl e                            ; 87C3
        sla d                           ; 87C5
        jr L87BE                        ; 87C7
L87C9:
        ld a,(L894D)                    ; 87C9
        or d                            ; 87CC
        and e                           ; 87CD
        ld (L894D),a                    ; 87CE
        pop de                          ; 87D1
        ret                             ; 87D2
        ld a,(L8944)                    ; 87D3
        inc bc                          ; 87D6
        add a,a                         ; 87D7
        ld l,a                          ; 87D8
        ld h,000h                       ; 87D9
        ld a,(bc)                       ; 87DB
        inc bc                          ; 87DC
        ld de,L89E9                     ; 87DD
        add hl,de                       ; 87E0
        ld (hl),c                       ; 87E1
        inc hl                          ; 87E2
        ld (hl),b                       ; 87E3
        ld hl,L8A67                     ; 87E4
        call L8844                      ; 87E7
        ld b,h                          ; 87EA
        ld c,l                          ; 87EB
        jp L84A0                        ; 87EC
        ld a,(L8944)                    ; 87EF
        add a,a                         ; 87F2
        ld l,a                          ; 87F3
        ld h,000h                       ; 87F4
        ld de,L89E9                     ; 87F6
        add hl,de                       ; 87F9
        ld c,(hl)                       ; 87FA
        inc hl                          ; 87FB
        ld b,(hl)                       ; 87FC
        jp L84A0                        ; 87FD
        inc bc                          ; 8800
        call L880A                      ; 8801
        ld a,(bc)                       ; 8804
        inc bc                          ; 8805
        ld (hl),a                       ; 8806
        jp L84A0                        ; 8807
L880A:
        ld a,(L8944)                    ; 880A
        ld l,a                          ; 880D
        ld h,000h                       ; 880E
        ld de,L89EF                     ; 8810
        add hl,de                       ; 8813
        ret                             ; 8814
L8815:
        ld hl,00000h                    ; 8815
        and a                           ; 8818
        ret z                           ; 8819
        push bc                         ; 881A
        ld b,008h                       ; 881B
L881D:
        srl a                           ; 881D
        jr nc,L8822                     ; 881F
        add hl,de                       ; 8821
L8822:
        sla e                           ; 8822
        rl d                            ; 8824
        djnz L881D                      ; 8826
        pop bc                          ; 8828
        ret                             ; 8829
L882A:
        push af                         ; 882A
        ld hl,00000h                    ; 882B
        ld a,b                          ; 882E
        ld b,010h                       ; 882F
L8831:
        rl c                            ; 8831
        rla                             ; 8833
        adc hl,hl                       ; 8834
        sbc hl,de                       ; 8836
        jr nc,L883B                     ; 8838
        add hl,de                       ; 883A
L883B:
        ccf                             ; 883B
        djnz L8831                      ; 883C
        rl c                            ; 883E
        rla                             ; 8840
        ld b,a                          ; 8841
        pop af                          ; 8842
        ret                             ; 8843
L8844:
        push af                         ; 8844
        add a,a                         ; 8845
        add a,l                         ; 8846
        ld l,a                          ; 8847
        jr nc,L884B                     ; 8848
        inc h                           ; 884A
L884B:
        ld a,(hl)                       ; 884B
        inc hl                          ; 884C
        ld h,(hl)                       ; 884D
        ld l,a                          ; 884E
        pop af                          ; 884F
        ret                             ; 8850
L8851:
        ld hl,L8946                     ; 8851
        ld a,000h                       ; 8854
        ld d,00bh                       ; 8856
L8858:
        push af                         ; 8858
        ld c,(hl)                       ; 8859
        out (0a0h),a                    ; 885A
        ld a,c                          ; 885C
        out (0a1h),a                    ; 885D
        pop af                          ; 885F
        inc a                           ; 8860
        inc hl                          ; 8861
        dec d                           ; 8862
        jr nz,L8858                     ; 8863
        ret                             ; 8865
L8866:
        xor 00eh                        ; 8866
        jr L8878                        ; 8868
TABLA_NOTAS_PSG:
        db 04Dh,00Dh,08Eh,00Ch,0DAh,00Bh,02Fh,00Bh,08Fh,00Ah,0F7h,009h,068h,009h; 886A
L8878:
        pop hl                          ; 8878
        ex af,af'                       ; 8879
        ld h,c                          ; 887A
        ex af,af'                       ; 887B
        jp (hl)                         ; 887C
        db 007h,077h,007h,00Ch,007h,0A7h,006h,047h,006h,0EDh,005h,098h,005h,047h,005h,0FCh; 887D
        db 004h,0B4h,004h,070h,004h,031h,004h,0F4h,003h,0BCh,003h,086h,003h,053h,003h,024h; 888D
        db 003h,0F6h,002h,0CCh,002h,0A4h,002h,07Eh,002h,05Ah,002h,038h,002h,018h,002h,0FAh; 889D
        db 001h,0DEh,001h,0C3h,001h,0AAh,001h,092h,001h,07Bh,001h,066h,001h,052h,001h,03Fh; 88AD
        db 001h,02Dh,001h,01Ch,001h,00Ch,001h,0FDh,000h,0EFh,000h,0E1h,000h,0D5h,000h,0C9h; 88BD
        db 000h,0BEh,000h,0B3h,000h,0A9h,000h,09Fh,000h,096h,000h,08Eh,000h,086h,000h,07Fh; 88CD
        db 000h,077h,000h,071h,000h,06Ah,000h,064h,000h,05Fh,000h,059h,000h,054h,000h,050h; 88DD
        db 000h,04Bh,000h,047h,000h,043h,000h,03Fh,000h,03Ch,000h,038h,000h,035h,000h,032h; 88ED
        db 000h,02Fh,000h,02Dh,000h,02Ah,000h,028h,000h,026h,000h,024h,000h,022h,000h,020h; 88FD
        db 000h,01Eh,000h,01Ch,000h,01Bh,000h,019h,000h,018h,000h,016h,000h,015h,000h,014h; 890D
        db 000h,013h,000h,012h,000h,011h,000h,010h,000h    ; 891D
TABLA_ORDENES_MUSICA:
        db 06Dh,086h,08Bh,086h,0EDh,086h,076h,086h,0E9h,086h,0BBh,086h,0FCh,086h,033h,087h; 8926
        db 0D5h,086h,07Ch,087h,01Fh,087h,096h,086h,0D3h,087h,0EFh,087h,000h,088h; 8936
L8944:
        db 000h                                            ; 8944
L8945:
        db 000h                                            ; 8945
L8946:
        db 000h,000h,000h,000h,000h,000h                   ; 8946
L894C:
        db 000h                                            ; 894C
L894D:
        db 000h                                            ; 894D
L894E:
        db 000h,000h,000h                                  ; 894E
L8951:
        db 000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h; 8951
        db 000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h; 8961
        db 000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h; 8971
        db 000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h; 8981
        db 000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h; 8991
        db 000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h; 89A1
        db 000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h; 89B1
        db 000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h; 89C1
        db 000h,000h,000h,000h,000h,000h,000h,000h,000h,000h; 89D1
L89DB:
        db 000h                                            ; 89DB
L89DC:
        db 000h,000h,000h,000h,000h,000h,000h,000h,000h    ; 89DC
L89E5:
        db 000h                                            ; 89E5
L89E6:
        db 000h                                            ; 89E6
L89E7:
        db 000h                                            ; 89E7
L89E8:
        db 000h                                            ; 89E8
L89E9:
        db 000h,000h,000h,000h,000h,000h                   ; 89E9
L89EF:
        db 000h,000h,000h                                  ; 89EF
L89F2:
        db 007h,000h,000h,000h,000h,0FEh,000h,000h,000h,000h,001h,000h,000h,000h,000h,00Ah; 89F2
        db 000h,000h,000h,000h,0FFh,000h,000h,000h,000h,002h,000h,000h,000h,000h,006h,000h; 8A02
        db 01Eh,000h,000h,0FEh,000h,0E2h,000h,000h,001h,000h,001h,000h,000h,001h,001h,000h; 8A12
        db 000h,000h,004h,0FCh,000h,000h,000h,001h,001h,000h,000h,000h,001h,001h,001h,001h; 8A22
        db 000h,004h,0FCh,003h,0FDh,000h,001h,001h,001h,001h,000h,001h,001h,014h,001h,000h; 8A32
        db 000h,0F1h,000h,000h,000h,003h,001h,000h,000h,000h,007h,000h,001h,001h,000h,0FFh; 8A42
        db 000h,001h,0FFh,000h,002h,000h,001h,001h,000h    ; 8A52
L8A5B:
        db 00Ah,000h,003h,000h,001h,000h,01Eh,000h,0F7h,000h,001h,000h; 8A5B
L8A67:
        db 091h,08Ah,0A2h,08Ah,0B3h,08Ah,0C4h,08Ah,0D5h,08Ah,0E6h,08Ah,005h,08Bh,0F7h,08Ah; 8A67
        db 0FEh,08Ah,071h,08Bh,091h,08Ah,091h,08Ah,091h,08Ah,091h,08Ah,091h,08Ah,091h,08Ah; 8A77
        db 091h,08Ah,091h,08Ah,091h,08Ah,091h,08Ah,091h,08Ah,087h,000h,080h,00Eh,083h,008h; 8A87
        db 081h,001h,08Ah,000h,021h,084h,024h,01Ch,084h,024h,08Dh,087h,000h,080h,00Eh,083h; 8A97
        db 008h,081h,001h,08Ah,000h,021h,084h,024h,01Ch,01Eh,020h,08Dh,087h,000h,080h,00Eh; 8AA7
        db 083h,008h,081h,001h,08Ah,000h,084h,084h,028h,084h,084h,028h,08Dh,087h,000h,080h; 8AB7
        db 00Eh,083h,008h,081h,001h,08Ah,000h,084h,084h    ; 8AC7
        db "(&$#"                                       ; 8AD0
        db 08Dh,087h,000h,080h,00Eh,083h,008h,081h,001h,08Ah,000h,024h,084h,028h,01Fh,084h; 8AD4
        db 028h,08Dh,087h,000h,080h,00Eh,083h,008h,081h,001h,08Ah,000h,024h,084h,028h,01Fh; 8AE4
        db 021h,023h,08Dh,084h,084h,02Bh,084h,084h,02Bh,08Dh,084h,084h; 8AF4
        db "+)(&"                                       ; 8B00
        db 08Dh,080h,00Eh,083h,0B8h,084h,083h,008h,01Ch,021h,084h,023h,024h,084h; 8B04
        db "&()'("                                      ; 8B12
        db 084h,01Ch,021h,084h,023h,024h,084h              ; 8B17
        db "&()'("                                      ; 8B1E
        db 084h,028h,02Dh,084h,02Dh,02Bh,084h,02Bh,028h,084h,028h,02Ah,084h,02Bh,083h,030h; 8B23
        db 08Ah,002h,02Ah,08Ah,000h,083h,008h              ; 8B33
        db "()(&$#!"                                    ; 8B3A
        db 084h,023h,024h,084h                             ; 8B41
        db "&()'("                                      ; 8B45
        db 084h,01Ch,021h,084h,023h,024h,084h              ; 8B4A
        db "&()'("                                      ; 8B51
        db 084h                                            ; 8B56
        db "(-+)+)()(&(&$&$#$#!#$#!"                    ; 8B57
        db 084h,084h,08Dh,083h,010h,029h,083h,008h,028h,083h,010h,029h,083h,008h,026h,083h; 8B6E
        db 010h,029h,083h,008h,02Dh,083h,010h,02Bh,083h,008h,029h,083h,010h,028h,083h,008h; 8B7E
        db 026h,083h,010h,024h,083h,008h,026h,083h,010h,028h,083h,008h,021h,083h,010h,023h; 8B8E
        db 083h,008h,024h,083h,010h,026h,083h,008h,025h,083h,010h,026h,083h,008h,025h,083h; 8B9E
        db 010h,026h,083h,008h,029h,083h,010h,028h,083h,008h,026h,083h,018h,025h,026h,083h; 8BAE
        db 010h,028h,083h,008h,025h,083h,010h,026h,083h,008h; 8BBE
        db "()&()&()-,-)&(!$(+)(-/0/-/,(/,(/,(20/"      ; 8BC8
        db 083h,060h,08Ah,002h,02Dh,08Ah,000h,08Dh         ; 8BED
L8BF5:
        db 085h,064h,08Eh,006h,08Ch,000h,08Ch,001h,08Ch,000h,08Ch,001h,08Ch,000h,08Ch,001h; 8BF5
        db 08Ch,000h,08Ch,001h,08Ch,000h,08Ch,004h,08Eh,0FCh,08Ch,004h,08Eh,0FEh,08Ch,004h; 8C05
        db 08Eh,006h,08Ch,000h,08Ch,001h,08Ch,000h,08Ch,001h,087h,006h,08Ah,000h,080h,00Dh; 8C15
        db 081h,001h,08Eh,006h                             ; 8C25
        db "!$($(+&)-!$(&)-!$(#(*("                     ; 8C29
        db 084h,084h,08Ch,000h,08Ch,001h,08Ch,000h,08Ch,001h,08Ch,000h,08Ch,001h,08Ch,000h; 8C3F
        db 08Ch,001h,08Ch,000h,08Ch,004h,08Eh,0FCh,08Ch,004h,08Eh,0FEh,08Ch,004h,08Eh,006h; 8C4F
        db 08Ch,000h,08Ch,001h,08Ch,000h,08Ch,001h,087h,006h,08Ah,000h,080h,00Dh,081h,001h; 8C5F
        db 08Eh,006h                                       ; 8C6F
        db "!$($(+&)-!$(&)-!$(#(*("                     ; 8C71
        db 084h,084h,08Eh,00Bh,08Ch,000h,08Ch,000h,08Eh,006h,08Ch,000h,08Ch,001h,08Eh,00Ah; 8C87
        db 08Ch,004h,08Ch,004h,08Eh,003h,08Ch,004h,08Ch,004h,08Eh,00Bh,08Ch,000h,08Ch,000h; 8C97
        db 08Eh,006h,08Ch,000h,08Ch,001h,08Eh,00Ah,08Ch,004h,08Ch,004h,08Eh,006h,08Ch,000h; 8CA7
        db 08Ch,001h,08Eh,00Bh,08Ch,000h,08Ch,000h,08Eh,006h,08Ch,000h,08Ch,001h,08Eh,00Ah; 8CB7
        db 08Ch,004h,08Ch,004h,08Eh,003h,08Ch,004h,08Ch,004h,08Eh,00Bh,08Ch,000h,08Ch,000h; 8CC7
        db 08Eh,006h,08Ch,000h,08Ch,001h,08Eh,00Ah,08Ch,004h,08Ch,004h,08Eh,006h,08Ch,000h; 8CD7
        db 08Ch,001h,082h                                  ; 8CE7
L8CEA:
        db 085h,064h,087h,006h,08Ah,000h,081h,001h,08Eh,012h,08Ch,006h,08Eh,006h,08Ch,006h; 8CEA
        db 08Eh,012h,08Ch,009h,08Eh,006h,08Ch,009h,082h    ; 8CFA
L8D03:
        db 085h,064h,08Eh,006h,08Ch,002h,08Ch,003h,08Ch,002h,08Ch,003h,08Ch,002h,08Ch,003h; 8D03
        db 08Ch,002h,08Ch,003h,08Ch,002h,08Ch,007h,08Eh,0FCh,08Ch,007h,08Eh,0FEh,08Ch,007h; 8D13
        db 08Eh,006h,08Ch,002h,08Ch,003h,08Ch,002h,08Ch,003h,087h,006h,080h,00Ah,08Ah,000h; 8D23
        db 081h,001h,08Eh,012h,01Ch,021h,024h,01Fh         ; 8D33
        db "$(!&)"                                      ; 8D3B
        db 01Ch                                            ; 8D40
        db "!$!$)"                                      ; 8D41
        db 01Ch,021h,024h,01Ch,020h,023h,021h,084h,084h,08Eh,006h,08Ch,002h,08Ch,003h,08Ch; 8D46
        db 002h,08Ch,003h,08Ch,002h,08Ch,003h,08Ch,002h,08Ch,003h,08Ch,002h,08Ch,007h,08Eh; 8D56
        db 0FCh,08Ch,007h,08Eh,0FEh,08Ch,007h,08Eh,006h,08Ch,002h,08Ch,003h,08Ch,002h,08Ch; 8D66
        db 003h,087h,006h,080h,00Ah,08Ah,000h,081h,001h,08Eh,012h,01Ch,021h,024h,01Fh; 8D76
        db "$(!&)"                                      ; 8D85
        db 01Ch                                            ; 8D8A
        db "!$!$)"                                      ; 8D8B
        db 01Ch,021h,024h,01Ch,020h,023h,021h,084h,084h,08Eh,00Bh,08Ch,002h,08Ch,002h,08Eh; 8D90
        db 006h,08Ch,002h,08Ch,003h,08Eh,00Ah,08Ch,007h,08Ch,007h,08Eh,006h,08Ch,002h,08Eh; 8DA0
        db 003h,08Ch,007h,08Eh,00Bh,08Ch,002h,08Ch,002h,08Eh,006h,08Ch,002h,08Ch,003h,08Eh; 8DB0
        db 00Ah,08Ch,007h,08Ch,007h,08Eh,006h,08Ch,002h,08Ch,003h,08Eh,00Bh,08Ch,002h,08Ch; 8DC0
        db 002h,08Eh,006h,08Ch,002h,08Ch,003h,08Eh,00Ah,08Ch,007h,08Ch,007h,08Eh,006h,08Ch; 8DD0
        db 002h,08Eh,003h,08Ch,007h,08Eh,00Bh,08Ch,002h,08Ch,002h,08Eh,006h,08Ch,002h,08Ch; 8DE0
        db 003h,08Eh,00Ah,08Ch,007h,08Ch,007h,08Eh,006h,08Ch,002h,08Ch,003h,082h; 8DF0
MUSICA_PARA:
        ld de,00000h                    ; 8DFE
        xor a                           ; 8E01
        call MUSICA_CANAL               ; 8E02
        ld de,00000h                    ; 8E05
        ld a,001h                       ; 8E08
        call MUSICA_CANAL               ; 8E0A
        ld de,00000h                    ; 8E0D
        ld a,002h                       ; 8E10
        call MUSICA_CANAL               ; 8E12
        ret                             ; 8E15
        db 0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh; 8E16
V_JUG_ESTADO:
        db 000h                                            ; 8E20
L8E21:
        db 000h                                            ; 8E21
L8E22:
        db 000h                                            ; 8E22
V_JUG_X:
        db 000h                                            ; 8E23
V_JUG_Y:
        db 000h                                            ; 8E24
L8E25:
        db 000h                                            ; 8E25
V_VIDAS:
        db 000h                                            ; 8E26
L8E27:
        db 000h                                            ; 8E27
L8E28:
        db 000h                                            ; 8E28
L8E29:
        db 000h,000h                                       ; 8E29
L8E2B:
        db 000h,000h                                       ; 8E2B
L8E2D:
        db 000h                                            ; 8E2D
L8E2E:
        db 000h                                            ; 8E2E
L8E2F:
        db 000h                                            ; 8E2F
L8E30:
        db 000h                                            ; 8E30
L8E31:
        db 000h                                            ; 8E31
L8E32:
        db 000h                                            ; 8E32
L8E33:
        db 000h,000h,000h                                  ; 8E33
V_COLOR_LOSETA:
        db 000h                                            ; 8E36
L8E37:
        db 000h                                            ; 8E37
L8E38:
        db 000h                                            ; 8E38
L8E39:
        db 000h                                            ; 8E39
L8E3A:
        db 000h,000h                                       ; 8E3A
L8E3C:
        db 000h                                            ; 8E3C
L8E3D:
        db 000h                                            ; 8E3D
L8E3E:
        db 000h                                            ; 8E3E
L8E3F:
        db 000h                                            ; 8E3F
L8E40:
        db 000h                                            ; 8E40
L8E41:
        db 000h                                            ; 8E41
L8E42:
        db 000h                                            ; 8E42
L8E43:
        db 000h                                            ; 8E43
L8E44:
        db 000h                                            ; 8E44
V_PTR_MAPA:
        db 000h,000h                                       ; 8E45
V_PTR_BUFER:
        db 000h,000h                                       ; 8E47
V_PTR_BUFCOLOR:
        db 000h,000h                                       ; 8E49
L8E4B:
        db 000h                                            ; 8E4B
L8E4C:
        db 000h                                            ; 8E4C
L8E4D:
        db 000h                                            ; 8E4D
L8E4E:
        db 000h                                            ; 8E4E
L8E4F:
        db 000h                                            ; 8E4F
L8E50:
        db 000h                                            ; 8E50
L8E51:
        db 000h                                            ; 8E51
L8E52:
        db 000h                                            ; 8E52
V_SEMILLA:
        db 000h,000h                                       ; 8E53
L8E55:
        db 000h,000h                                       ; 8E55
L8E57:
        db 000h                                            ; 8E57
L8E58:
        db 000h                                            ; 8E58
L8E59:
        db 000h                                            ; 8E59
L8E5A:
        db 000h                                            ; 8E5A
L8E5B:
        db 08Eh,0C1h,09Eh,0C6h,026h,0C9h,036h,0CEh         ; 8E5B
L8E63:
        db 024h,012h,024h,01Eh                             ; 8E63
L8E67:
        db 000h                                            ; 8E67
L8E68:
        db 000h                                            ; 8E68
L8E69:
        db 000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h; 8E69
        db 000h,000h,000h,000h,000h,000h,000h,000h,000h,000h; 8E79
L8E83:
        db 000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h; 8E83
        db 000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h; 8E93
        db 000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h; 8EA3
        db 000h,000h,000h,000h,000h,000h,000h,000h         ; 8EB3
L8EBB:
        db 000h                                            ; 8EBB
L8EBC:
        db 000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h; 8EBC
        db 000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h; 8ECC
        db 000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h; 8EDC
        db 000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h; 8EEC
        db 000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h; 8EFC
        db 000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h; 8F0C
        db 000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h; 8F1C
        db 000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h; 8F2C
        db 000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h; 8F3C
        db 000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h; 8F4C
        db 000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h; 8F5C
        db 000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h; 8F6C
        db 000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h; 8F7C
        db 000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h; 8F8C
        db 000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h; 8F9C
        db 000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h; 8FAC
        db 000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h; 8FBC
        db 000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h; 8FCC
        db 000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h; 8FDC
        db 000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h; 8FEC
        db 000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,0FFh; 8FFC
TABLA_ENEMIGOS:
        db 000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h; 900C
        db 000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h; 901C
        db 000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h; 902C
        db 000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h; 903C
L904B:
        db 038h,028h,000h,002h,00Bh,007h,064h,028h,000h,002h,017h,007h,038h,028h,002h,000h; 904B
        db 00Bh,007h,068h,028h,002h,000h,016h,007h,00Ch,00Ch,002h,003h,001h,001h,00Ch,00Ch; 905B
        db 003h,002h,001h,001h                             ; 906B
L906F:
        db 001h,001h,001h,001h,001h,001h,001h,002h,002h,004h,004h,001h,001h,002h,002h,005h; 906F
        db 004h,001h,001h,001h,002h,002h,002h,002h,004h,004h,005h,001h,001h,002h,002h,004h; 907F
        db 004h,004h,005h,005h,005h,005h,005h,005h         ; 908F
L9097:
        db 007h,029h,006h,059h,007h,00Eh,010h,07Dh,00Fh,028h,017h,021h,022h,048h,024h,05Ch; 9097
        db 023h,080h,020h,00Ch,028h,06Eh,032h,081h,030h,002h; 90A7
        db ";!>Q?"                                      ; 90B1
        db 018h                                            ; 90B6
L90B7:
        db 01Bh,019h,015h,042h,014h,02Ch,01Ch,018h         ; 90B7
L90BF:
        db 033h,00Dh,020h,020h                             ; 90BF
L90C3:
        db 003h,054h,002h,08Bh,002h,030h,00Fh,047h,016h,056h,016h,074h,01Fh; 90C3
        db "H.R.a"                                      ; 90D0
        db 01Fh,08Bh                                       ; 90D5
        db "1 BaC!0"                                    ; 90D7
        db 018h,028h,089h                                  ; 90DE
L90E1:
        db 03Ch,019h,015h,030h,038h,019h,03Dh,051h         ; 90E1
L90E9:
        db 004h                                            ; 90E9
        db "sC.B"                                       ; 90EA
        db 004h,042h,05Eh                                  ; 90EE
L90F1:
        db 005h,05Ah,015h,05Eh,021h,066h,005h,06Eh,006h,06Eh,021h,073h,015h,02Ah,00Eh; 90F1
L9100:
        db 000h,009h,009h,000h,000h,000h,000h,00Bh,009h,000h,000h,000h,000h,008h,009h,000h; 9100
        db 000h,000h,000h,00Ah,00Ah,000h,000h,000h,000h,00Bh,00Ah,000h,000h,000h,000h,01Bh; 9110
        db 006h,000h,000h,000h,000h,01Bh,00Dh,000h,000h,000h,000h,01Eh,00Dh,000h,000h,000h; 9120
        db 000h,01Bh,00Eh,000h,000h,000h,000h,01Ch,00Eh,000h,000h,000h,000h,01Eh,00Eh,000h; 9130
        db 000h,000h,002h,012h,007h,000h,000h,000h,002h,013h,006h,000h,000h,000h,002h,015h; 9140
        db 006h,000h,000h,000h,002h,017h,006h,000h,000h,000h,002h,015h,007h,000h,000h,000h; 9150
        db 002h,017h,00Dh,000h,000h,000h,002h,013h,00Ch,000h,000h,000h,002h,014h,00Ch,000h; 9160
        db 000h,000h,002h,015h,00Ch,000h,000h,000h,0FFh    ; 9170
L9179:
        db 001h,001h,001h,001h,001h,001h,001h,001h,001h,001h,001h,001h,001h,001h,001h,001h; 9179
        db 001h,001h,001h,001h,001h,001h,001h,001h,001h,001h,001h,001h,001h,001h,001h,001h; 9189
        db 001h,001h,001h,001h,001h,001h,001h,001h,001h,001h,001h,001h,001h,001h,001h,001h; 9199
        db 001h,001h,001h,001h,001h,001h,001h,001h,001h,001h,001h,001h; 91A9
L91B5:
        db 001h,010h                                       ; 91B5
L91B7:
        db 008h,000h,012h,00Ch,001h,040h,008h,000h,042h,00Ch,001h,02Ch,030h,000h,02Eh,034h; 91B7
        db 001h,004h,03Ch,000h,004h,040h,001h,040h,040h,000h,03Eh,040h,002h,030h,014h,000h; 91C7
        db 035h,015h,002h,004h,040h,000h,004h,042h,002h,07Ch,040h,000h,081h,040h,003h,044h; 91D7
        db 010h,000h,042h,010h,003h,05Ch,038h              ; 91E7
L91EE:
        db 009h,05Dh,03Ch,01Bh,01Ch                        ; 91EE
L91F3:
        db 01Ah,000h,01Ah,000h,01Ah,000h,01Ah,000h,01Ah,000h,01Ah,000h,01Ah,000h,01Ah,000h; 91F3
        db 01Ah,000h,01Ah,000h                             ; 9203
L9207:
        db 007h,007h,007h,007h,008h,008h,008h,008h,006h    ; 9207
L9210:
        db 006h,005h,004h,003h,000h,001h,001h,002h,002h,002h,001h,001h,000h,000h; 9210
L921E:
        db 000h,000h,000h,000h,001h,001h,001h,001h,001h,001h,001h,001h,001h,001h; 921E
L922C:
        db 08Eh,0BCh,010h,002h,0CEh,0BCh,010h,002h,00Eh,0BDh,010h,002h,04Eh,0BDh,018h,003h; 922C
        db 0DEh,0BDh,018h,003h,06Eh,0BEh,018h,003h,0FEh,0BEh,018h,003h,000h,000h,000h,000h; 923C
        db 000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h; 924C
        db 000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h; 925C
        db 000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h; 926C
        db 000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h; 927C
        db 000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h; 928C
        db 000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h; 929C

; Punto de entrada (LOAD.BIN salta aquí con las 4 páginas en RAM y DI)
INICIO:
        di                              ; 92AC
        ld (V_SP_BASIC),sp              ; 92AD
        ld sp,0fde8h                    ; 92B1
        call ARRANCA_MUSICA             ; 92B4
        ei                              ; 92B7
        call ESPERA_TECLA               ; 92B8
        call MUSICA_PARA                ; 92BB
        halt                            ; 92BE
        di                              ; 92BF
        call INICIA_VDP                 ; 92C0
        ld a,0c3h                       ; 92C3
        ld (00038h),a                   ; 92C5
        ld hl,INT_JUEGO                 ; 92C8
        ld (00039h),hl                  ; 92CB
        ld hl,04600h                    ; 92CE
        ld de,05ef0h                    ; 92D1
        ld bc,LC008                     ; 92D4
        call L9D71                      ; 92D7
NUEVA_PARTIDA:
        di                              ; 92DA
        ld sp,0fde8h                    ; 92DB
        call L9E6A                      ; 92DE
        call L9F4C                      ; 92E1
        ld bc,01808h                    ; 92E4
        ld hl,02600h                    ; 92E7
        ld de,LD26E                     ; 92EA
        call L9DB2                      ; 92ED
        ld a,r                          ; 92F0
        ld l,a                          ; 92F2
        ld a,r                          ; 92F3
        ld h,a                          ; 92F5
        ld (V_SEMILLA),hl               ; 92F6
        call LB012                      ; 92F9
        call LB5D2                      ; 92FC
        call LB631                      ; 92FF
        call L97C7                      ; 9302
        call LADD8                      ; 9305
        call LB4BA                      ; 9308
        call LA9AA                      ; 930B
        call L9DD1                      ; 930E
        call LBA1A                      ; 9311
        call LA545                      ; 9314

; Bucle principal. NO espera al barrido vertical: cada vuelta dura lo que tarde
; todo (unos 190 ms, 9-10 cuadros en PAL). Casi todo se va en DIBUJA_FONDO y VUELCA_PANTALLA.
BUCLE_PRINCIPAL:
        ld sp,0fde8h                    ; 9317
        ei                              ; 931A
        call TRUCO_VIDAS                ; 931B
        call LA3BB                      ; 931E
        call LBA3E                      ; 9321
        call LB8A9                      ; 9324
        call L9E09                      ; 9327
        call LB9EF                      ; 932A
        call SCROLL                     ; 932D
        call LB15E                      ; 9330
        call LB64D                      ; 9333
        call LB05F                      ; 9336
        call L9ADC                      ; 9339
        call DIBUJA_FONDO               ; 933C
        call LACDD                      ; 933F
        call MUEVE_ENEMIGOS             ; 9342
        call LAB46                      ; 9345
        call LB6D5                      ; 9348
        call MUEVE_JUGADOR              ; 934B
        call LB8FC                      ; 934E
        call LAEE1                      ; 9351
        call LB9A2                      ; 9354
        call LB93A                      ; 9357
        call VUELCA_PANTALLA            ; 935A
        ld a,0f7h                       ; 935D
        out (0aah),a                    ; 935F
        in a,(0a9h)                     ; 9361

; Restos de una comprobación de STOP (fila 7 bit 4): el salto se cambió por NOP
L9363:
        bit 4,a                         ; 9363
        nop                             ; 9365
        nop                             ; 9366
        nop                             ; 9367
        jr BUCLE_PRINCIPAL              ; 9368

; TRUCO: si la fila 5 del teclado vale 1Bh (U, X, Y y Z pulsadas a la vez)
; cambia el DEC A de RESTA_VIDA por OR A: vidas infinitas
TRUCO_VIDAS:
        ld a,0f5h                       ; 936A
        out (0aah),a                    ; 936C
        in a,(0a9h)                     ; 936E
        cp 01bh                         ; 9370
        ret nz                          ; 9372
        ld a,0b7h                       ; 9373
        ld (RESTA_VIDA),a               ; 9375
        ret                             ; 9378
MUEVE_JUGADOR:
        ld a,(L8E38)                    ; 9379
        and a                           ; 937C
        jp nz,L95D9                     ; 937D
        call LEE_CONTROLES              ; 9380
        call LB861                      ; 9383
        ld a,e                          ; 9386
        ld (L8E40),a                    ; 9387
        call L93FC                      ; 938A
        ld bc,(V_JUG_X)                 ; 938D
        ld (L8E2D),bc                   ; 9391
        call L93CE                      ; 9395
L9398:
        call LB8B4                      ; 9398
        ld a,(L8E22)                    ; 939B
        ld (L8E4B),a                    ; 939E
        ld a,(V_JUG_ESTADO)             ; 93A1
        ld hl,L93AE                     ; 93A4
        ld bc,(V_JUG_X)                 ; 93A7
        jp L968F                        ; 93AB
L93AE:
        db 0B6h,093h,0BEh,093h,0B6h,093h,0C6h,093h,008h,046h,098h,046h,028h,047h,098h,046h; 93AE
        db 0B8h,047h,048h,048h,0D8h                        ; 93BE
        db "HHHhI"                                      ; 93C3
        db 0F8h,049h,088h,04Ah,0F8h,049h                   ; 93C8
L93CE:
        ld a,(L8E40)                    ; 93CE
        and 00fh                        ; 93D1
        jr z,L93FB                      ; 93D3
        cp 009h                         ; 93D5
        jp z,L94ED                      ; 93D7
        cp 005h                         ; 93DA
        jp z,L9545                      ; 93DC
        cp 006h                         ; 93DF
        jp z,L9571                      ; 93E1
        cp 00ah                         ; 93E4
        jp z,L9519                      ; 93E6
        cp 008h                         ; 93E9
        jp z,L94B7                      ; 93EB
        cp 004h                         ; 93EE
        jp z,L9481                      ; 93F0
        cp 002h                         ; 93F3
        jr z,L944B                      ; 93F5
        cp 001h                         ; 93F7
        jr z,L9414                      ; 93F9
L93FB:
        ret                             ; 93FB
L93FC:
        bit 4,e                         ; 93FC
        jr nz,L9405                     ; 93FE
        xor a                           ; 9400
        ld (L8E3F),a                    ; 9401
        ret                             ; 9404
L9405:
        ld a,(L8E3F)                    ; 9405
        and a                           ; 9408
        ret nz                          ; 9409
        cpl                             ; 940A
        ld (L8E3F),a                    ; 940B
        call LA9E2                      ; 940E
        jp LAAA0                        ; 9411
L9414:
        ld a,(V_JUG_ESTADO)             ; 9414
        cp 003h                         ; 9417
        jr z,L9441                      ; 9419
        ld a,001h                       ; 941B
        ld (V_JUG_ESTADO),a             ; 941D
        call L959D                      ; 9420
        call L9A5A                      ; 9423
        ret nz                          ; 9426
        ld a,(L8E22)                    ; 9427
        inc a                           ; 942A
        and 003h                        ; 942B
        ld (L8E22),a                    ; 942D
L9430:
        ld a,(V_JUG_X)                  ; 9430
        add a,006h                      ; 9433
        ld (V_JUG_X),a                  ; 9435
        cp 088h                         ; 9438
        ret c                           ; 943A
        ld a,007h                       ; 943B
        ld (L8E30),a                    ; 943D
        ret                             ; 9440
L9441:
        ld a,002h                       ; 9441
        ld (V_JUG_ESTADO),a             ; 9443
        inc a                           ; 9446
        ld (L8E21),a                    ; 9447
        ret                             ; 944A
L944B:
        ld a,(V_JUG_ESTADO)             ; 944B
        cp 001h                         ; 944E
        jr z,L9478                      ; 9450
        ld a,003h                       ; 9452
        ld (V_JUG_ESTADO),a             ; 9454
        call L95AF                      ; 9457
        call L9A6B                      ; 945A
        ret nz                          ; 945D
        ld a,(L8E22)                    ; 945E
        inc a                           ; 9461
        and 003h                        ; 9462
        ld (L8E22),a                    ; 9464
L9467:
        ld a,(V_JUG_X)                  ; 9467
        sub 006h                        ; 946A
        ld (V_JUG_X),a                  ; 946C
        cp 020h                         ; 946F
        ret nc                          ; 9471
        ld a,0fah                       ; 9472
        ld (L8E30),a                    ; 9474
        ret                             ; 9477
L9478:
        xor a                           ; 9478
        ld (V_JUG_ESTADO),a             ; 9479
        inc a                           ; 947C
        ld (L8E21),a                    ; 947D
        ret                             ; 9480
L9481:
        ld a,(V_JUG_ESTADO)             ; 9481
        and a                           ; 9484
        jr z,L94AD                      ; 9485
        ld a,002h                       ; 9487
        ld (V_JUG_ESTADO),a             ; 9489
        call L95CB                      ; 948C
        call L9A8D                      ; 948F
        ret nz                          ; 9492
        ld a,(L8E22)                    ; 9493
        inc a                           ; 9496
        and 003h                        ; 9497
        ld (L8E22),a                    ; 9499
L949C:
        ld a,(V_JUG_Y)                  ; 949C
        add a,006h                      ; 949F
        ld (V_JUG_Y),a                  ; 94A1
        cp 088h                         ; 94A4
        ret c                           ; 94A6
        ld a,007h                       ; 94A7
        ld (L8E2F),a                    ; 94A9
        ret                             ; 94AC
L94AD:
        ld a,003h                       ; 94AD
        ld (V_JUG_ESTADO),a             ; 94AF
        xor a                           ; 94B2
        ld (L8E21),a                    ; 94B3
        ret                             ; 94B6
L94B7:
        ld a,(V_JUG_ESTADO)             ; 94B7
        cp 002h                         ; 94BA
        jr z,L94E3                      ; 94BC
        xor a                           ; 94BE
        ld (V_JUG_ESTADO),a             ; 94BF
        call L95BD                      ; 94C2
        call L9A7C                      ; 94C5
        ret nz                          ; 94C8
        ld a,(L8E22)                    ; 94C9
        inc a                           ; 94CC
        and 003h                        ; 94CD
        ld (L8E22),a                    ; 94CF
L94D2:
        ld a,(V_JUG_Y)                  ; 94D2
        sub 006h                        ; 94D5
        ld (V_JUG_Y),a                  ; 94D7
        cp 020h                         ; 94DA
        ret nc                          ; 94DC
        ld a,0fah                       ; 94DD
        ld (L8E2F),a                    ; 94DF
        ret                             ; 94E2
L94E3:
        ld a,001h                       ; 94E3
        ld (V_JUG_ESTADO),a             ; 94E5
        inc a                           ; 94E8
        ld (L8E21),a                    ; 94E9
        ret                             ; 94EC
L94ED:
        ld a,(V_JUG_ESTADO)             ; 94ED
        ld c,a                          ; 94F0
        cp 003h                         ; 94F1
        jr nz,L94F7                     ; 94F3
        ld c,000h                       ; 94F5
L94F7:
        cp 002h                         ; 94F7
        jr nz,L94FC                     ; 94F9
        dec c                           ; 94FB
L94FC:
        ld a,c                          ; 94FC
        ld (V_JUG_ESTADO),a             ; 94FD
        call L959D                      ; 9500
        call L95BD                      ; 9503
        call L9AC0                      ; 9506
        ret nz                          ; 9509
        ld a,(L8E22)                    ; 950A
        inc a                           ; 950D
        and 003h                        ; 950E
        ld (L8E22),a                    ; 9510
        call L9430                      ; 9513
        jp L94D2                        ; 9516
L9519:
        ld a,(V_JUG_ESTADO)             ; 9519
        ld c,a                          ; 951C
        cp 001h                         ; 951D
        jr nz,L9523                     ; 951F
        ld c,000h                       ; 9521
L9523:
        cp 002h                         ; 9523
        jr nz,L9528                     ; 9525
        inc c                           ; 9527
L9528:
        ld a,c                          ; 9528
        ld (V_JUG_ESTADO),a             ; 9529
        call L95AF                      ; 952C
        call L95BD                      ; 952F
        call L9AC7                      ; 9532
        ret nz                          ; 9535
        ld a,(L8E22)                    ; 9536
        inc a                           ; 9539
        and 003h                        ; 953A
        ld (L8E22),a                    ; 953C
        call L9467                      ; 953F
        jp L94D2                        ; 9542
L9545:
        ld a,(V_JUG_ESTADO)             ; 9545
        ld c,a                          ; 9548
        cp 003h                         ; 9549
        jr nz,L954F                     ; 954B
        ld c,002h                       ; 954D
L954F:
        cp 000h                         ; 954F
        jr nz,L9554                     ; 9551
        inc c                           ; 9553
L9554:
        ld a,c                          ; 9554
        ld (V_JUG_ESTADO),a             ; 9555
        call L959D                      ; 9558
        call L95CB                      ; 955B
        call L9ACE                      ; 955E
        ret nz                          ; 9561
        ld a,(L8E22)                    ; 9562
        inc a                           ; 9565
        and 003h                        ; 9566
        ld (L8E22),a                    ; 9568
        call L9430                      ; 956B
        jp L949C                        ; 956E
L9571:
        ld a,(V_JUG_ESTADO)             ; 9571
        ld c,a                          ; 9574
        cp 000h                         ; 9575
        jr nz,L957B                     ; 9577
        ld c,003h                       ; 9579
L957B:
        cp 001h                         ; 957B
        jr nz,L9580                     ; 957D
        inc c                           ; 957F
L9580:
        ld a,c                          ; 9580
        ld (V_JUG_ESTADO),a             ; 9581
        call L95AF                      ; 9584
        call L95CB                      ; 9587
        call L9AD5                      ; 958A
        ret nz                          ; 958D
        ld a,(L8E22)                    ; 958E
        inc a                           ; 9591
        and 003h                        ; 9592
        ld (L8E22),a                    ; 9594
        call L9467                      ; 9597
        jp L949C                        ; 959A
L959D:
        ld hl,L8E31                     ; 959D
        ld a,(L8E44)                    ; 95A0
        sub 005h                        ; 95A3
        cp (hl)                         ; 95A5
        ret nz                          ; 95A6
        ld a,(V_JUG_X)                  ; 95A7
        cp 0a2h                         ; 95AA
        ret c                           ; 95AC
        pop hl                          ; 95AD
        ret                             ; 95AE
L95AF:
        ld a,(L8E31)                    ; 95AF
        cp 001h                         ; 95B2
        ret nz                          ; 95B4
        ld a,(V_JUG_X)                  ; 95B5
        cp 002h                         ; 95B8
        ret nc                          ; 95BA
        pop hl                          ; 95BB
        ret                             ; 95BC
L95BD:
        ld a,(L8E32)                    ; 95BD
        cp 001h                         ; 95C0
        ret nz                          ; 95C2
        ld a,(V_JUG_Y)                  ; 95C3
        cp 00ah                         ; 95C6
        ret nc                          ; 95C8
        pop hl                          ; 95C9
        ret                             ; 95CA
L95CB:
        ld a,(L8E32)                    ; 95CB
        cp 00dh                         ; 95CE
        ret nz                          ; 95D0
        ld a,(V_JUG_Y)                  ; 95D1
        cp 0a2h                         ; 95D4
        ret c                           ; 95D6
        pop hl                          ; 95D7
        ret                             ; 95D8
L95D9:
        dec a                           ; 95D9
        ld (L8E38),a                    ; 95DA
        jp z,L95F8                      ; 95DD
        ld hl,(L8E3A)                   ; 95E0
        ld a,(hl)                       ; 95E3
        inc hl                          ; 95E4
        ld (L8E3A),hl                   ; 95E5
        ld (L8E4B),a                    ; 95E8
        ld hl,L967B                     ; 95EB
        ld bc,(V_JUG_X)                 ; 95EE
        ld a,(L8E39)                    ; 95F2
        jp L968F                        ; 95F5
L95F8:
        call LB631                      ; 95F8
        call LB63F                      ; 95FB
        xor a                           ; 95FE
        ld (LA443),a                    ; 95FF
        ld a,0c0h                       ; 9602
        ld (L8E25),a                    ; 9604
        ld a,(V_VIDAS)                  ; 9607

; Este DEC A se convierte en OR A (B7h) con el truco
RESTA_VIDA:
        dec a                           ; 960A
        ld (V_VIDAS),a                  ; 960B
        jr z,L9664                      ; 960E
        ld b,002h                       ; 9610
L9612:
        push bc                         ; 9612
        call L9DFD                      ; 9613
        pop bc                          ; 9616
        djnz L9612                      ; 9617
        ld de,LBAFE                     ; 9619
        cp 002h                         ; 961C
        jr z,L962A                      ; 961E
        ld de,LBB7E                     ; 9620
        cp 001h                         ; 9623
        jr z,L962A                      ; 9625
        ld de,LBA7E                     ; 9627
L962A:
        call L9DD4                      ; 962A
        xor a                           ; 962D
        ld (L8E28),a                    ; 962E
        ld a,(L8E39)                    ; 9631
        and a                           ; 9634
        ret nz                          ; 9635
        ld a,(L8E41)                    ; 9636
        and a                           ; 9639
        jr nz,L963D                     ; 963A
        inc a                           ; 963C
L963D:
        inc a                           ; 963D
        ld (L8E41),a                    ; 963E
        ld e,a                          ; 9641
        ld d,000h                       ; 9642
        ld hl,L8E63                     ; 9644
        add hl,de                       ; 9647
        ld de,L8E44                     ; 9648
        ldi                             ; 964B
        add a,a                         ; 964D
        ld e,a                          ; 964E
        ld d,000h                       ; 964F
        ld hl,L8E5B                     ; 9651
        add hl,de                       ; 9654
        ld a,(hl)                       ; 9655
        inc hl                          ; 9656
        ld h,(hl)                       ; 9657
        ld l,a                          ; 9658
        ld bc,(L8E31)                   ; 9659
        call LA9C5                      ; 965D
        ld (V_PTR_MAPA),hl              ; 9660
        ret                             ; 9663
L9664:
        jp NUEVA_PARTIDA                ; 9664
V_SP_BASIC:
        db 000h,000h                                       ; 9667
L9669:
        db 000h,000h,000h,001h,001h,001h,002h,002h,003h,003h; 9669
L9673:
        db 000h,000h,001h,001h,002h,002h,003h,003h         ; 9673
L967B:
        db 07Fh,096h,087h,096h,098h,046h,0F0h,055h,080h,056h,010h,057h,0A0h,057h,030h,058h; 967B
        db 0C0h,058h,050h,059h                             ; 968B
L968F:
        push af                         ; 968F
        add a,a                         ; 9690
        ld e,a                          ; 9691
        ld d,000h                       ; 9692
        add hl,de                       ; 9694
        ld a,(hl)                       ; 9695
        inc hl                          ; 9696
        ld h,(hl)                       ; 9697
        ld l,a                          ; 9698
        ld a,(L8E4B)                    ; 9699
        add a,a                         ; 969C
        ld e,a                          ; 969D
        ld d,000h                       ; 969E
        add hl,de                       ; 96A0
        ld a,(hl)                       ; 96A1
        inc hl                          ; 96A2
        ld h,(hl)                       ; 96A3
        ld l,a                          ; 96A4
        ld (L8E2B),hl                   ; 96A5
        ex de,hl                        ; 96A8
        ld a,018h                       ; 96A9
        ld (L8E33),a                    ; 96AB
        pop af                          ; 96AE
        cp 002h                         ; 96AF
        jp z,L97AD                      ; 96B1
        ld hl,00318h                    ; 96B4
        call LAD5B                      ; 96B7
L96BA:
        ld (L8E2B),de                   ; 96BA
        ld a,l                          ; 96BE
        ld (L8E33),a                    ; 96BF
        ld a,b                          ; 96C2
        ld (L8E2E),a                    ; 96C3
        ld a,c                          ; 96C6
        ld (L8E2D),a                    ; 96C7
        call L9B74                      ; 96CA
        ld a,(L8E2D)                    ; 96CD
        and 007h                        ; 96D0
        sub 008h                        ; 96D2
        neg                             ; 96D4
        dec a                           ; 96D6
        add a,a                         ; 96D7
        add a,a                         ; 96D8
        add a,a                         ; 96D9
        ld (L96F6+1),a                  ; 96DA
        ld (L9753+1),a                  ; 96DD
        ld a,(L8E33)                    ; 96E0
        ld b,a                          ; 96E3
L96E4:
        push bc                         ; 96E4
        push hl                         ; 96E5
        ld hl,(L8E2B)                   ; 96E6
        ld e,(hl)                       ; 96E9
        inc hl                          ; 96EA
        ld d,(hl)                       ; 96EB
        inc hl                          ; 96EC
        ld c,(hl)                       ; 96ED
        inc hl                          ; 96EE
        ld (L8E2B),hl                   ; 96EF
        pop hl                          ; 96F2
        ld b,0ffh                       ; 96F3
        scf                             ; 96F5
L96F6:
        jr L96F6                        ; 96F6
        rr e                            ; 96F8
        rr d                            ; 96FA
        rr c                            ; 96FC
        rr b                            ; 96FE
        rr e                            ; 9700
        rr d                            ; 9702
        rr c                            ; 9704
        rr b                            ; 9706
        rr e                            ; 9708
        rr d                            ; 970A
        rr c                            ; 970C
        rr b                            ; 970E
        rr e                            ; 9710
        rr d                            ; 9712
        rr c                            ; 9714
        rr b                            ; 9716
        rr e                            ; 9718
        rr d                            ; 971A
        rr c                            ; 971C
        rr b                            ; 971E
        rr e                            ; 9720
        rr d                            ; 9722
        rr c                            ; 9724
        rr b                            ; 9726
        rr e                            ; 9728
        rr d                            ; 972A
        rr c                            ; 972C
        rr b                            ; 972E
        ld a,e                          ; 9730
        and (hl)                        ; 9731
        ld (hl),a                       ; 9732
        inc hl                          ; 9733
        ld a,d                          ; 9734
        and (hl)                        ; 9735
        ld (hl),a                       ; 9736
        inc hl                          ; 9737
        ld a,c                          ; 9738
        and (hl)                        ; 9739
        ld (hl),a                       ; 973A
        inc hl                          ; 973B
        ld a,b                          ; 973C
        and (hl)                        ; 973D
        ld (hl),a                       ; 973E
        dec hl                          ; 973F
        dec hl                          ; 9740
        dec hl                          ; 9741
        push hl                         ; 9742
        ld hl,(L8E2B)                   ; 9743
        ld e,(hl)                       ; 9746
        inc hl                          ; 9747
        ld d,(hl)                       ; 9748
        inc hl                          ; 9749
        ld c,(hl)                       ; 974A
        inc hl                          ; 974B
        ld (L8E2B),hl                   ; 974C
        pop hl                          ; 974F
        and a                           ; 9750
        ld b,000h                       ; 9751
L9753:
        jr L9753                        ; 9753
        rr e                            ; 9755
        rr d                            ; 9757
        rr c                            ; 9759
        rr b                            ; 975B
        rr e                            ; 975D
        rr d                            ; 975F
        rr c                            ; 9761
        rr b                            ; 9763
        rr e                            ; 9765
        rr d                            ; 9767
        rr c                            ; 9769
        rr b                            ; 976B
        rr e                            ; 976D
        rr d                            ; 976F
        rr c                            ; 9771
        rr b                            ; 9773
        rr e                            ; 9775
        rr d                            ; 9777
        rr c                            ; 9779
        rr b                            ; 977B
        rr e                            ; 977D
        rr d                            ; 977F
        rr c                            ; 9781
        rr b                            ; 9783
        rr e                            ; 9785
        rr d                            ; 9787
        rr c                            ; 9789
        rr b                            ; 978B
        ld a,e                          ; 978D
        or (hl)                         ; 978E
        ld (hl),a                       ; 978F
        inc hl                          ; 9790
        ld a,d                          ; 9791
        or (hl)                         ; 9792
        ld (hl),a                       ; 9793
        inc hl                          ; 9794
        ld a,c                          ; 9795
        or (hl)                         ; 9796
        ld (hl),a                       ; 9797
        inc hl                          ; 9798
        ld a,b                          ; 9799
        or (hl)                         ; 979A
        ld (hl),a                       ; 979B
        ld bc,00019h                    ; 979C
        add hl,bc                       ; 979F
        pop bc                          ; 97A0
        dec b                           ; 97A1
        jp nz,L96E4                     ; 97A2
        ld de,00019h                    ; 97A5
        ld (0979dh),de                  ; 97A8
        ret                             ; 97AC
L97AD:
        ld a,(L8E33)                    ; 97AD
        dec a                           ; 97B0
        add a,b                         ; 97B1
        ld b,a                          ; 97B2
        ld de,0ffe1h                    ; 97B3
        ld (0979dh),de                  ; 97B6
        ld de,(L8E2B)                   ; 97BA
        ld hl,00318h                    ; 97BE
        call LAD8E                      ; 97C1
        jp L96BA                        ; 97C4
L97C7:
        ld a,046h                       ; 97C7
        ld (V_JUG_X),a                  ; 97C9
        ld a,09ah                       ; 97CC
        ld (V_JUG_Y),a                  ; 97CE
        ld a,0bfh                       ; 97D1
        ld (L8E25),a                    ; 97D3
        ld a,003h                       ; 97D6
        ld (V_VIDAS),a                  ; 97D8
        ld a,001h                       ; 97DB
        ld (L8E27),a                    ; 97DD
        ld (L8E22),a                    ; 97E0
        ld a,030h                       ; 97E3
        ld (L8E29),a                    ; 97E5
        ld a,000h                       ; 97E8
        ld (V_JUG_ESTADO),a             ; 97EA
        ld a,0ffh                       ; 97ED
        ld (L8E21),a                    ; 97EF
        cpl                             ; 97F2
        ld (L8E28),a                    ; 97F3
        ld (L8E57),a                    ; 97F6
        ld (L8E58),a                    ; 97F9
        ld (L8E38),a                    ; 97FC
        ld (L8E3E),a                    ; 97FF
        ld (L8E3D),a                    ; 9802
        ld a,032h                       ; 9805
        ld (L8E37),a                    ; 9807
        xor a                           ; 980A
        ld (L8E41),a                    ; 980B
        ld hl,LC18E                     ; 980E
        ld (V_PTR_MAPA),hl              ; 9811
        ld a,001h                       ; 9814
        ld (L8E31),a                    ; 9816
        ld a,001h                       ; 9819
        ld (L8E32),a                    ; 981B
        ld a,024h                       ; 981E
        ld (L8E44),a                    ; 9820
        xor a                           ; 9823
        ld (L8E42),a                    ; 9824
        ld (L8E43),a                    ; 9827
        ld (L8E2F),a                    ; 982A
        ld (L8E30),a                    ; 982D
        ld hl,003e8h                    ; 9830
        ld (V_PTR_BUFER),hl             ; 9833
        ld hl,01c68h                    ; 9836
        ld (V_PTR_BUFCOLOR),hl          ; 9839
        ret                             ; 983C

; Redibuja TODO el búfer de juego (7x7 losetas de 32x32) desde el mapa, cada vuelta.
; Patrones a 03E8h (28 bytes por línea) y color a 1C68h (que nunca se usa)
DIBUJA_FONDO:
        exx                             ; 983D
        ld de,01c68h                    ; 983E
        exx                             ; 9841
        ld de,003e8h                    ; 9842
        ld hl,(V_PTR_MAPA)              ; 9845
        ld c,007h                       ; 9848
L984A:
        ld b,007h                       ; 984A
L984C:
        push bc                         ; 984C
        ld a,(hl)                       ; 984D
        ld (V_COLOR_LOSETA),a           ; 984E
        inc hl                          ; 9851
        ld a,(hl)                       ; 9852
        ex af,af'                       ; 9853
        push hl                         ; 9854
        call DIR_LOSETA                 ; 9855
        ex af,af'                       ; 9858
        call COPIA_LOSETA               ; 9859
        pop hl                          ; 985C
        inc hl                          ; 985D
        pop bc                          ; 985E
        djnz L984C                      ; 985F
        exx                             ; 9861
        ld hl,00054h                    ; 9862
        add hl,de                       ; 9865
        ex de,hl                        ; 9866
        exx                             ; 9867
        push hl                         ; 9868
        ld hl,00364h                    ; 9869
        add hl,de                       ; 986C
        ex de,hl                        ; 986D
        pop hl                          ; 986E
        ld a,(L8E44)                    ; 986F
        sub 007h                        ; 9872
        add a,a                         ; 9874
        add a,l                         ; 9875
        ld l,a                          ; 9876
        ld a,h                          ; 9877
        adc a,000h                      ; 9878
        ld h,a                          ; 987A
        dec c                           ; 987B
        jr nz,L984A                     ; 987C
        ret                             ; 987E

; Copia los 128 bytes de patrón de una loseta (bit 7 = dibujada al revés)
COPIA_LOSETA:
        bit 7,a                         ; 987F
        jr nz,L9899                     ; 9881
        ld a,020h                       ; 9883
L9885:
        ldi                             ; 9885
        ldi                             ; 9887
        ldi                             ; 9889
        ldi                             ; 988B
        ld bc,00018h                    ; 988D
        ex de,hl                        ; 9890
        add hl,bc                       ; 9891
        ex de,hl                        ; 9892
        dec a                           ; 9893
        jr nz,L9885                     ; 9894
        jp COLOR_LOSETA                 ; 9896
L9899:
        ld bc,00364h                    ; 9899
        ex de,hl                        ; 989C
        add hl,bc                       ; 989D
        ex de,hl                        ; 989E
        ld a,020h                       ; 989F
L98A1:
        ldi                             ; 98A1
        ldi                             ; 98A3
        ldi                             ; 98A5
        ldi                             ; 98A7
        ld bc,0ffe0h                    ; 98A9
        ex de,hl                        ; 98AC
        add hl,bc                       ; 98AD
        ex de,hl                        ; 98AE
        dec a                           ; 98AF
        jr nz,L98A1                     ; 98B0
        jp COLOR_LOSETA_INV             ; 98B2

; HL = 2328h + 144 * número de loseta (128 de patrón + 16 de color)
DIR_LOSETA:
        ld a,(hl)                       ; 98B5
        res 7,a                         ; 98B6
        ld l,a                          ; 98B8
        ld h,000h                       ; 98B9
        ld b,004h                       ; 98BB
L98BD:
        add hl,hl                       ; 98BD
        djnz L98BD                      ; 98BE
        push hl                         ; 98C0
        add hl,hl                       ; 98C1
        add hl,hl                       ; 98C2
        add hl,hl                       ; 98C3
        pop bc                          ; 98C4
        add hl,bc                       ; 98C5
        ld bc,02328h                    ; 98C6
        add hl,bc                       ; 98C9
        ret                             ; 98CA
SCROLL:
        ld a,(L8E2F)                    ; 98CB
        and a                           ; 98CE
        jp z,L99A1                      ; 98CF
        jp m,L993B                      ; 98D2
        dec a                           ; 98D5
        ld (L8E2F),a                    ; 98D6
        ld a,(L8E32)                    ; 98D9
        sub 00dh                        ; 98DC
        ld c,a                          ; 98DE
        ld a,(L8E43)                    ; 98DF
        or c                            ; 98E2
        jr nz,L98EB                     ; 98E3
        ld (L8E2F),a                    ; 98E5
        jp L99A1                        ; 98E8
L98EB:
        ld b,0f8h                       ; 98EB
        call LA96A                      ; 98ED
        ld hl,(V_PTR_BUFER)             ; 98F0
        ld de,000e0h                    ; 98F3
        add hl,de                       ; 98F6
        ld (V_PTR_BUFER),hl             ; 98F7
        ld hl,(V_PTR_BUFCOLOR)          ; 98FA
        ld de,0001ch                    ; 98FD
        add hl,de                       ; 9900
        ld (V_PTR_BUFCOLOR),hl          ; 9901
        ld a,(L8E43)                    ; 9904
        inc a                           ; 9907
        and 003h                        ; 9908
        ld (L8E43),a                    ; 990A
        jp nz,L99A1                     ; 990D
        ld hl,(V_PTR_BUFER)             ; 9910
        ld de,0fc80h                    ; 9913
        add hl,de                       ; 9916
        ld (V_PTR_BUFER),hl             ; 9917
        ld hl,(V_PTR_BUFCOLOR)          ; 991A
        ld de,0ff90h                    ; 991D
        add hl,de                       ; 9920
        ld (V_PTR_BUFCOLOR),hl          ; 9921
        ld hl,(V_PTR_MAPA)              ; 9924
        ld a,(L8E44)                    ; 9927
        add a,a                         ; 992A
        ld e,a                          ; 992B
        ld d,000h                       ; 992C
        add hl,de                       ; 992E
        ld (V_PTR_MAPA),hl              ; 992F
        ld a,(L8E32)                    ; 9932
        inc a                           ; 9935
        ld (L8E32),a                    ; 9936
        jr L99A1                        ; 9939
L993B:
        inc a                           ; 993B
        ld (L8E2F),a                    ; 993C
        ld a,(L8E32)                    ; 993F
        dec a                           ; 9942
        ld c,a                          ; 9943
        ld a,(L8E43)                    ; 9944
        or c                            ; 9947
        jr nz,L9950                     ; 9948
        ld (L8E2F),a                    ; 994A
        jp L99A1                        ; 994D
L9950:
        ld b,008h                       ; 9950
        call LA96A                      ; 9952
        ld hl,(V_PTR_BUFER)             ; 9955
        ld de,0ff20h                    ; 9958
        add hl,de                       ; 995B
        ld (V_PTR_BUFER),hl             ; 995C
        ld hl,(V_PTR_BUFCOLOR)          ; 995F
        ld de,0ffe4h                    ; 9962
        add hl,de                       ; 9965
        ld (V_PTR_BUFCOLOR),hl          ; 9966
        ld a,(L8E43)                    ; 9969
        dec a                           ; 996C
        and 003h                        ; 996D
        ld (L8E43),a                    ; 996F
        cp 003h                         ; 9972
        jr nz,L99A1                     ; 9974
        ld hl,(V_PTR_BUFER)             ; 9976
        ld de,00380h                    ; 9979
        add hl,de                       ; 997C
        ld (V_PTR_BUFER),hl             ; 997D
        ld hl,(V_PTR_BUFCOLOR)          ; 9980
        ld de,00070h                    ; 9983
        add hl,de                       ; 9986
        ld (V_PTR_BUFCOLOR),hl          ; 9987
        ld hl,(V_PTR_MAPA)              ; 998A
        ld a,(L8E44)                    ; 998D
        add a,a                         ; 9990
        ld e,a                          ; 9991
        ld d,000h                       ; 9992
        and a                           ; 9994
        sbc hl,de                       ; 9995
        ld (V_PTR_MAPA),hl              ; 9997
        ld a,(L8E32)                    ; 999A
        dec a                           ; 999D
        ld (L8E32),a                    ; 999E
L99A1:
        ld a,(L8E30)                    ; 99A1
        and a                           ; 99A4
        ret z                           ; 99A5
        jp m,L9A04                      ; 99A6
        dec a                           ; 99A9
        ld (L8E30),a                    ; 99AA
        ld a,(L8E44)                    ; 99AD
        sub 005h                        ; 99B0
        ld c,a                          ; 99B2
        ld a,(L8E31)                    ; 99B3
        sub c                           ; 99B6
        ld c,a                          ; 99B7
        ld a,(L8E42)                    ; 99B8
        or c                            ; 99BB
        jr nz,L99C2                     ; 99BC
        ld (L8E30),a                    ; 99BE
        ret                             ; 99C1
L99C2:
        ld b,0f8h                       ; 99C2
        call LA92A                      ; 99C4
        ld hl,(V_PTR_BUFER)             ; 99C7
        inc hl                          ; 99CA
        ld (V_PTR_BUFER),hl             ; 99CB
        ld hl,(V_PTR_BUFCOLOR)          ; 99CE
        inc hl                          ; 99D1
        ld (V_PTR_BUFCOLOR),hl          ; 99D2
        ld a,(L8E42)                    ; 99D5
        inc a                           ; 99D8
        and 003h                        ; 99D9
        ld (L8E42),a                    ; 99DB
        ret nz                          ; 99DE
        ld hl,(V_PTR_BUFER)             ; 99DF
        ld de,0fffch                    ; 99E2
        add hl,de                       ; 99E5
        ld (V_PTR_BUFER),hl             ; 99E6
        ld hl,(V_PTR_BUFCOLOR)          ; 99E9
        ld de,0fffch                    ; 99EC
        add hl,de                       ; 99EF
        ld (V_PTR_BUFCOLOR),hl          ; 99F0
        add hl,de                       ; 99F3
        ld hl,(V_PTR_MAPA)              ; 99F4
        inc hl                          ; 99F7
        inc hl                          ; 99F8
        ld (V_PTR_MAPA),hl              ; 99F9
        ld a,(L8E31)                    ; 99FC
        inc a                           ; 99FF
        ld (L8E31),a                    ; 9A00
        ret                             ; 9A03
L9A04:
        inc a                           ; 9A04
        ld (L8E30),a                    ; 9A05
        ld a,(L8E31)                    ; 9A08
        dec a                           ; 9A0B
        ld c,a                          ; 9A0C
        ld a,(L8E42)                    ; 9A0D
        or c                            ; 9A10
        jr nz,L9A17                     ; 9A11
        ld (L8E30),a                    ; 9A13
        ret                             ; 9A16
L9A17:
        ld hl,(V_PTR_BUFER)             ; 9A17
        dec hl                          ; 9A1A
        ld (V_PTR_BUFER),hl             ; 9A1B
        ld hl,(V_PTR_BUFCOLOR)          ; 9A1E
        dec hl                          ; 9A21
        ld (V_PTR_BUFCOLOR),hl          ; 9A22
        ld b,008h                       ; 9A25
        call LA92A                      ; 9A27
        ld a,(L8E42)                    ; 9A2A
        dec a                           ; 9A2D
        and 003h                        ; 9A2E
        ld (L8E42),a                    ; 9A30
        cp 003h                         ; 9A33
        ret nz                          ; 9A35
        ld hl,(V_PTR_BUFER)             ; 9A36
        ld de,00004h                    ; 9A39
        add hl,de                       ; 9A3C
        ld (V_PTR_BUFER),hl             ; 9A3D
        ld hl,(V_PTR_BUFCOLOR)          ; 9A40
        ld de,00004h                    ; 9A43
        add hl,de                       ; 9A46
        ld (V_PTR_BUFCOLOR),hl          ; 9A47
        ld hl,(V_PTR_MAPA)              ; 9A4A
        dec hl                          ; 9A4D
        dec hl                          ; 9A4E
        ld (V_PTR_MAPA),hl              ; 9A4F
        ld a,(L8E31)                    ; 9A52
        dec a                           ; 9A55
        ld (L8E31),a                    ; 9A56
        ret                             ; 9A59
L9A5A:
        ld bc,(L8E2D)                   ; 9A5A
        ld a,018h                       ; 9A5E
        add a,c                         ; 9A60
        ld c,a                          ; 9A61
        ld a,b                          ; 9A62
        add a,008h                      ; 9A63
        ld b,a                          ; 9A65
        ld de,00102h                    ; 9A66
        jr L9A9C                        ; 9A69
L9A6B:
        ld bc,(L8E2D)                   ; 9A6B
        ld a,c                          ; 9A6F
        sub 000h                        ; 9A70
        ld c,a                          ; 9A72
        ld a,b                          ; 9A73
        add a,008h                      ; 9A74
        ld b,a                          ; 9A76
        ld de,00102h                    ; 9A77
        jr L9A9C                        ; 9A7A
L9A7C:
        ld bc,(L8E2D)                   ; 9A7C
        ld de,00201h                    ; 9A80
        ld a,b                          ; 9A83
        sub 000h                        ; 9A84
        ld b,a                          ; 9A86
        ld a,c                          ; 9A87
        add a,008h                      ; 9A88
        ld c,a                          ; 9A8A
        jr L9A9C                        ; 9A8B
L9A8D:
        ld bc,(L8E2D)                   ; 9A8D
        ld a,b                          ; 9A91
        add a,018h                      ; 9A92
        ld b,a                          ; 9A94
        ld a,c                          ; 9A95
        add a,008h                      ; 9A96
        ld c,a                          ; 9A98
        ld de,00201h                    ; 9A99
L9A9C:
        srl c                           ; 9A9C
        srl c                           ; 9A9E
        srl c                           ; 9AA0
        srl b                           ; 9AA2
        srl b                           ; 9AA4
        srl b                           ; 9AA6
L9AA8:
        push de                         ; 9AA8
        call L9B90                      ; 9AA9
        pop bc                          ; 9AAC
        ld a,01ch                       ; 9AAD
        sub b                           ; 9AAF
        ld e,a                          ; 9AB0
        ld d,000h                       ; 9AB1
        ld a,b                          ; 9AB3
L9AB4:
        ld b,a                          ; 9AB4
L9AB5:
        bit 6,(hl)                      ; 9AB5
        ret nz                          ; 9AB7
        inc hl                          ; 9AB8
        djnz L9AB5                      ; 9AB9
        add hl,de                       ; 9ABB
        dec c                           ; 9ABC
        jr nz,L9AB4                     ; 9ABD
        ret                             ; 9ABF
L9AC0:
        call L9A5A                      ; 9AC0
        ret nz                          ; 9AC3
        jp L9A7C                        ; 9AC4
L9AC7:
        call L9A6B                      ; 9AC7
        ret nz                          ; 9ACA
        jp L9A7C                        ; 9ACB
L9ACE:
        call L9A5A                      ; 9ACE
        ret nz                          ; 9AD1
        jp L9A8D                        ; 9AD2
L9AD5:
        call L9A6B                      ; 9AD5
        ret nz                          ; 9AD8
        jp L9A8D                        ; 9AD9
L9ADC:
        ld a,(L8E41)                    ; 9ADC
        and a                           ; 9ADF
        jr nz,L9AFF                     ; 9AE0
        call L9B1F                      ; 9AE2
        cp 000h                         ; 9AE5
        ret nz                          ; 9AE7
        call L9B2D                      ; 9AE8
        cp 01ch                         ; 9AEB
        ret c                           ; 9AED
        cp 026h                         ; 9AEE
        ret nc                          ; 9AF0
        ld a,0a2h                       ; 9AF1
        ld hl,LC69E                     ; 9AF3
        ld bc,0120dh                    ; 9AF6
        ld e,001h                       ; 9AF9
        call L9B38                      ; 9AFB
        ret                             ; 9AFE
L9AFF:
        cp 001h                         ; 9AFF
        ret nz                          ; 9B01
        call L9B1F                      ; 9B02
        cp 044h                         ; 9B05
        ret nz                          ; 9B07
        call L9B2D                      ; 9B08
        cp 019h                         ; 9B0B
        ret c                           ; 9B0D
        cp 027h                         ; 9B0E
        ret nc                          ; 9B10
        ld a,00ch                       ; 9B11
        ld hl,LC18E                     ; 9B13
        ld bc,02401h                    ; 9B16
        ld e,000h                       ; 9B19
        call L9B38                      ; 9B1B
        ret                             ; 9B1E
L9B1F:
        call LADB5                      ; 9B1F
        ld a,(V_JUG_X)                  ; 9B22
        srl a                           ; 9B25
        srl a                           ; 9B27
        srl a                           ; 9B29
        add a,l                         ; 9B2B
        ret                             ; 9B2C
L9B2D:
        ld a,(V_JUG_Y)                  ; 9B2D
        srl a                           ; 9B30
        srl a                           ; 9B32
        srl a                           ; 9B34
        add a,h                         ; 9B36
        ret                             ; 9B37
L9B38:
        ld (V_JUG_X),a                  ; 9B38
        ld a,b                          ; 9B3B
        ld (L8E44),a                    ; 9B3C
        ld a,e                          ; 9B3F
        ld (L8E41),a                    ; 9B40
        ld a,(L8E32)                    ; 9B43
        ld b,a                          ; 9B46
        ld (L8E31),bc                   ; 9B47
        call LA9C5                      ; 9B4B
        ld (V_PTR_MAPA),hl              ; 9B4E
        call LB631                      ; 9B51
        call LB63F                      ; 9B54
        ret                             ; 9B57
        db 001h,004h,006h,00Dh,00Ch,007h,00Ah,00Eh,001h,005h,009h,00Dh,003h,007h,00Bh,00Fh; 9B58
L9B68:
        db 019h,019h,019h,019h                             ; 9B68
L9B6C:
        db 099h,099h,099h,099h                             ; 9B6C
L9B70:
        db 019h,019h,019h,019h                             ; 9B70
L9B74:
        ld l,b                          ; 9B74
        ld h,000h                       ; 9B75
        add hl,hl                       ; 9B77
        add hl,hl                       ; 9B78
        push hl                         ; 9B79
        add hl,hl                       ; 9B7A
        ld e,l                          ; 9B7B
        ld d,h                          ; 9B7C
        add hl,hl                       ; 9B7D
        add hl,de                       ; 9B7E
        pop de                          ; 9B7F
        add hl,de                       ; 9B80
        ld de,(V_PTR_BUFER)             ; 9B81
        add hl,de                       ; 9B85
        ld b,000h                       ; 9B86
        srl c                           ; 9B88
        srl c                           ; 9B8A
        srl c                           ; 9B8C
        add hl,bc                       ; 9B8E
        ret                             ; 9B8F
L9B90:
        ld l,b                          ; 9B90
        ld h,000h                       ; 9B91
        add hl,hl                       ; 9B93
        add hl,hl                       ; 9B94
        push hl                         ; 9B95
        add hl,hl                       ; 9B96
        push hl                         ; 9B97
        add hl,hl                       ; 9B98
        pop de                          ; 9B99
        add hl,de                       ; 9B9A
        pop de                          ; 9B9B
        add hl,de                       ; 9B9C
        ld de,(V_PTR_BUFCOLOR)          ; 9B9D
        add hl,de                       ; 9BA1
        ld e,c                          ; 9BA2
        ld d,000h                       ; 9BA3
        add hl,de                       ; 9BA5
        ret                             ; 9BA6

; Vuelca al VDP 3 tercios de 1536 bytes (24x24 caracteres), unos 47 T por byte
VUELCA_PANTALLA:
        di                              ; 9BA7
        ld hl,(V_PTR_BUFER)             ; 9BA8
        ld de,00000h                    ; 9BAB
        call VUELCA_TERCIO              ; 9BAE
        ld de,006e8h                    ; 9BB1
        add hl,de                       ; 9BB4
        ld de,00800h                    ; 9BB5
        call VUELCA_TERCIO              ; 9BB8
        ld de,006e8h                    ; 9BBB
        add hl,de                       ; 9BBE
        ld de,01000h                    ; 9BBF
        jp VUELCA_TERCIO                ; 9BC2

; CÓDIGO MUERTO: volcado de la tabla de color, detrás del JP. El área de juego
; quedó en blanco y negro; el color se sigue calculando en COLOR_LOSETA para nada
VUELCA_COLOR_SIN_USAR:
        ld hl,(V_PTR_BUFCOLOR)          ; 9BC5
        ld de,02000h                    ; 9BC8
        call VUELCA_TERCIO_COLOR        ; 9BCB
        ld de,000c8h                    ; 9BCE
        add hl,de                       ; 9BD1
        ld de,02800h                    ; 9BD2
        call VUELCA_TERCIO_COLOR        ; 9BD5
        ld de,000c8h                    ; 9BD8
        add hl,de                       ; 9BDB
        ld de,03000h                    ; 9BDC
        call VUELCA_TERCIO_COLOR        ; 9BDF
        ei                              ; 9BE2
        ret                             ; 9BE3
VUELCA_TERCIO:
        ex de,hl                        ; 9BE4
        call VDP_ESCRITURA              ; 9BE5
        ex de,hl                        ; 9BE8
        ld c,018h                       ; 9BE9
L9BEB:
        ld b,040h                       ; 9BEB
        push bc                         ; 9BED
        ld de,0001ch                    ; 9BEE
        ld c,098h                       ; 9BF1
L9BF3:
        ld a,(hl)                       ; 9BF3
        out (c),a                       ; 9BF4
        add hl,de                       ; 9BF6
        djnz L9BF3                      ; 9BF7
        ld de,0f901h                    ; 9BF9
        add hl,de                       ; 9BFC
        pop bc                          ; 9BFD
        dec c                           ; 9BFE
        jr nz,L9BEB                     ; 9BFF
        ret                             ; 9C01
VUELCA_TERCIO_COLOR:
        ex de,hl                        ; 9C02
        call VDP_ESCRITURA              ; 9C03
        ex de,hl                        ; 9C06
        ld b,018h                       ; 9C07
L9C09:
        push bc                         ; 9C09
        ld b,008h                       ; 9C0A
        ld de,0001ch                    ; 9C0C
L9C0F:
        ld c,008h                       ; 9C0F
L9C11:
        ld a,(hl)                       ; 9C11
        call CONVIERTE_COLOR            ; 9C12
        out (098h),a                    ; 9C15
        ex (sp),hl                      ; 9C17
        ex (sp),hl                      ; 9C18
        dec c                           ; 9C19
        jr nz,L9C11                     ; 9C1A
        add hl,de                       ; 9C1C
        djnz L9C0F                      ; 9C1D
        ld de,0ff21h                    ; 9C1F
        add hl,de                       ; 9C22
        pop bc                          ; 9C23
        djnz L9C09                      ; 9C24
        ret                             ; 9C26
CONVIERTE_COLOR:
        push hl                         ; 9C27
        push bc                         ; 9C28
        ld b,a                          ; 9C29
        and 007h                        ; 9C2A
        ld c,a                          ; 9C2C
        ld a,b                          ; 9C2D
        and 078h                        ; 9C2E
        rrca                            ; 9C30
        rrca                            ; 9C31
        rrca                            ; 9C32
        ld l,a                          ; 9C33
        and 010h                        ; 9C34
        or c                            ; 9C36
        ld c,a                          ; 9C37
        ld a,l                          ; 9C38
        ld hl,L9C4F                     ; 9C39
        ld a,c                          ; 9C3C
        add a,l                         ; 9C3D
        ld l,a                          ; 9C3E
        ld b,(hl)                       ; 9C3F
        ld hl,L9C4F                     ; 9C40
        ld a,c                          ; 9C43
        add a,l                         ; 9C44
        ld l,a                          ; 9C45
        ld a,(hl)                       ; 9C46
        rlca                            ; 9C47
        rlca                            ; 9C48
        rlca                            ; 9C49
        rlca                            ; 9C4A
        or b                            ; 9C4B
        pop bc                          ; 9C4C
        pop hl                          ; 9C4D
        ret                             ; 9C4E
L9C4F:
        db 001h,004h,006h,00Dh,00Ch,005h,00Ah,00Eh,001h,004h,006h,008h,002h,007h,00Bh,00Fh; 9C4F
LEE_CONTROLES:
        ld ix,TABLA_TECLAS              ; 9C5F
        ld e,000h                       ; 9C63
        ld b,005h                       ; 9C65
L9C67:
        call LEE_TECLA                  ; 9C67
        jr nz,L9C72                     ; 9C6A
        scf                             ; 9C6C
        rl e                            ; 9C6D
        jp L9C75                        ; 9C6F
L9C72:
        and a                           ; 9C72
        rl e                            ; 9C73
L9C75:
        inc ix                          ; 9C75
        inc ix                          ; 9C77
        djnz L9C67                      ; 9C79
        ret                             ; 9C7B
LEE_TECLA:
        ld a,(ix+000h)                  ; 9C7C
        out (0aah),a                    ; 9C7F
        in a,(0a9h)                     ; 9C81
        and (ix+001h)                   ; 9C83
        ret                             ; 9C86

; Teclas por defecto: ESPACIO, Q, A, O, P (fila de teclado, máscara)
TABLA_TECLAS:
        db 0F8h,001h,0F4h,040h,0F2h,040h,0F4h,010h,0F4h,020h; 9C87
L9C91:
        db 0F3h,020h                                       ; 9C91
L9C93:
        db 03Eh,007h                                       ; 9C93
LEE_JOYSTICK:
        out (0a0h),a                    ; 9C95
        in a,(0a2h)                     ; 9C97
        or 0c0h                         ; 9C99
        push af                         ; 9C9B
        ld a,007h                       ; 9C9C
        out (0a0h),a                    ; 9C9E
        pop af                          ; 9CA0
        out (0a1h),a                    ; 9CA1
        ld a,00eh                       ; 9CA3
        out (0a0h),a                    ; 9CA5
        in a,(0a2h)                     ; 9CA7
        ld e,000h                       ; 9CA9
        rra                             ; 9CAB
        jr c,L9CB0                      ; 9CAC
        set 3,e                         ; 9CAE
L9CB0:
        rra                             ; 9CB0
        jr c,L9CB5                      ; 9CB1
        set 2,e                         ; 9CB3
L9CB5:
        rra                             ; 9CB5
        jr c,L9CBA                      ; 9CB6
        set 1,e                         ; 9CB8
L9CBA:
        rra                             ; 9CBA
        jr c,L9CBF                      ; 9CBB
        set 0,e                         ; 9CBD
L9CBF:
        rra                             ; 9CBF
        ret c                           ; 9CC0
        set 4,e                         ; 9CC1
        ret                             ; 9CC3

; Calcula el color de la loseta en el búfer 1C68h: trabajo perdido (~19 % del tiempo)
COLOR_LOSETA:
        push hl                         ; 9CC4
        exx                             ; 9CC5
        pop hl                          ; 9CC6
        ld a,004h                       ; 9CC7
L9CC9:
        ex af,af'                       ; 9CC9
        call COPIA_BYTE_COLOR           ; 9CCA
        call COPIA_BYTE_COLOR           ; 9CCD
        call COPIA_BYTE_COLOR           ; 9CD0
        call COPIA_BYTE_COLOR           ; 9CD3
        ex af,af'                       ; 9CD6
        ld bc,00018h                    ; 9CD7
        ex de,hl                        ; 9CDA
        add hl,bc                       ; 9CDB
        ex de,hl                        ; 9CDC
        dec a                           ; 9CDD
        jr nz,L9CC9                     ; 9CDE
        ld hl,0ff94h                    ; 9CE0
        add hl,de                       ; 9CE3
        ex de,hl                        ; 9CE4
        exx                             ; 9CE5
        ld hl,0fc84h                    ; 9CE6
        add hl,de                       ; 9CE9
        ex de,hl                        ; 9CEA
        ret                             ; 9CEB
COLOR_LOSETA_INV:
        push hl                         ; 9CEC
        exx                             ; 9CED
        ld hl,00054h                    ; 9CEE
        add hl,de                       ; 9CF1
        ex de,hl                        ; 9CF2
        pop hl                          ; 9CF3
        ld a,004h                       ; 9CF4
L9CF6:
        ex af,af'                       ; 9CF6
        call COPIA_BYTE_COLOR           ; 9CF7
        call COPIA_BYTE_COLOR           ; 9CFA
        call COPIA_BYTE_COLOR           ; 9CFD
        call COPIA_BYTE_COLOR           ; 9D00
        ex af,af'                       ; 9D03
        ld bc,0ffe0h                    ; 9D04
        ex de,hl                        ; 9D07
        add hl,bc                       ; 9D08
        ex de,hl                        ; 9D09
        dec a                           ; 9D0A
        jr nz,L9CF6                     ; 9D0B
        ld hl,00020h                    ; 9D0D
        add hl,de                       ; 9D10
        ex de,hl                        ; 9D11
        exx                             ; 9D12
        ld hl,00020h                    ; 9D13
        add hl,de                       ; 9D16
        ex de,hl                        ; 9D17
        ret                             ; 9D18
COPIA_BYTE_COLOR:
        ld a,(hl)                       ; 9D19
        and 038h                        ; 9D1A
        cp 010h                         ; 9D1C
        jr nc,L9D3F                     ; 9D1E
        bit 3,a                         ; 9D20
        jr z,L9D33                      ; 9D22
        ld a,(hl)                       ; 9D24
        and 0c7h                        ; 9D25
        ld c,a                          ; 9D27
        ld a,(V_COLOR_LOSETA)           ; 9D28
        rra                             ; 9D2B
L9D2C:
        and 038h                        ; 9D2C
        or c                            ; 9D2E
        ld (de),a                       ; 9D2F
        inc hl                          ; 9D30
        inc de                          ; 9D31
        ret                             ; 9D32
L9D33:
        ld a,(hl)                       ; 9D33
        and 0c7h                        ; 9D34
        ld c,a                          ; 9D36
        ld a,(V_COLOR_LOSETA)           ; 9D37
        rla                             ; 9D3A
        rla                             ; 9D3B
        rla                             ; 9D3C
        jr L9D2C                        ; 9D3D
L9D3F:
        ld a,(hl)                       ; 9D3F
        ld (de),a                       ; 9D40
        inc hl                          ; 9D41
        inc de                          ; 9D42
        ret                             ; 9D43
L9D44:
        di                              ; 9D44
L9D45:
        push bc                         ; 9D45
L9D46:
        inc de                          ; 9D46
        djnz L9D46                      ; 9D47
        pop bc                          ; 9D49
        push bc                         ; 9D4A
        push hl                         ; 9D4B
L9D4C:
        call VDP_ESCRITURA              ; 9D4C
        ld a,(de)                       ; 9D4F
        out (098h),a                    ; 9D50
        inc de                          ; 9D52
        ld a,l                          ; 9D53
        add a,040h                      ; 9D54
        ld l,a                          ; 9D56
        jr nc,L9D5A                     ; 9D57
        inc h                           ; 9D59
L9D5A:
        djnz L9D4C                      ; 9D5A
        pop hl                          ; 9D5C
        call L9DA4                      ; 9D5D
        pop bc                          ; 9D60
        dec c                           ; 9D61
        jr nz,L9D45                     ; 9D62
        ei                              ; 9D64
        ret                             ; 9D65
L9D66:
        ld hl,04ec8h                    ; 9D66
        ld bc,01002h                    ; 9D69
        ld e,011h                       ; 9D6C
        jp L9D8B                        ; 9D6E
L9D71:
        push bc                         ; 9D71
        push hl                         ; 9D72
        di                              ; 9D73
L9D74:
        call VDP_ESCRITURA              ; 9D74
        ld a,(de)                       ; 9D77
        out (098h),a                    ; 9D78
        call L9DA4                      ; 9D7A
        inc de                          ; 9D7D
        djnz L9D74                      ; 9D7E
        pop hl                          ; 9D80
        ld bc,00040h                    ; 9D81
        add hl,bc                       ; 9D84
        pop bc                          ; 9D85
        dec c                           ; 9D86
        jr nz,L9D71                     ; 9D87
        ei                              ; 9D89
        ret                             ; 9D8A
L9D8B:
        push bc                         ; 9D8B
        push hl                         ; 9D8C
        di                              ; 9D8D
L9D8E:
        call VDP_ESCRITURA              ; 9D8E
        ld a,e                          ; 9D91
        out (098h),a                    ; 9D92
        call L9DA4                      ; 9D94
        djnz L9D8E                      ; 9D97
        pop hl                          ; 9D99
        ld bc,00040h                    ; 9D9A
        add hl,bc                       ; 9D9D
        pop bc                          ; 9D9E
        dec c                           ; 9D9F
        jr nz,L9D8B                     ; 9DA0
        ei                              ; 9DA2
        ret                             ; 9DA3
L9DA4:
        inc l                           ; 9DA4
        ld a,l                          ; 9DA5
        and 03fh                        ; 9DA6
        ret nz                          ; 9DA8
        ld a,l                          ; 9DA9
        sub 040h                        ; 9DAA
        ld l,a                          ; 9DAC
        ld a,008h                       ; 9DAD
        add a,h                         ; 9DAF
        ld h,a                          ; 9DB0
        ret                             ; 9DB1
L9DB2:
        push bc                         ; 9DB2
        push hl                         ; 9DB3
L9DB4:
        call VDP_ESCRITURA              ; 9DB4
        ld c,008h                       ; 9DB7
L9DB9:
        ld a,(de)                       ; 9DB9
        out (098h),a                    ; 9DBA
        inc hl                          ; 9DBC
        dec c                           ; 9DBD
        jr nz,L9DB9                     ; 9DBE
        inc de                          ; 9DC0
        dec hl                          ; 9DC1
        call L9DA4                      ; 9DC2
        djnz L9DB4                      ; 9DC5
        pop hl                          ; 9DC7
        ld bc,00040h                    ; 9DC8
        add hl,bc                       ; 9DCB
        pop bc                          ; 9DCC
        dec c                           ; 9DCD
        jr nz,L9DB2                     ; 9DCE
        ret                             ; 9DD0
L9DD1:
        ld de,LBA7E                     ; 9DD1
L9DD4:
        ld hl,04690h                    ; 9DD4
        ld bc,02004h                    ; 9DD7
        call L9D71                      ; 9DDA
L9DDD:
        ld b,006h                       ; 9DDD
        ld hl,04e68h                    ; 9DDF
L9DE2:
        push bc                         ; 9DE2
        push hl                         ; 9DE3
        ld de,LBC7E                     ; 9DE4
        ld bc,01001h                    ; 9DE7
        call L9D71                      ; 9DEA
        pop hl                          ; 9DED
        ld bc,00040h                    ; 9DEE
        add hl,bc                       ; 9DF1
        pop bc                          ; 9DF2
        djnz L9DE2                      ; 9DF3
L9DF5:
        ld a,(L8E27)                    ; 9DF5
        and a                           ; 9DF8
        ret z                           ; 9DF9
        jp LB784                        ; 9DFA
L9DFD:
        ld hl,08000h                    ; 9DFD
        ld de,08000h                    ; 9E00
        ld bc,04000h                    ; 9E03
        ldir                            ; 9E06
        ret                             ; 9E08
L9E09:
        ld a,(LA3BA)                    ; 9E09
        inc a                           ; 9E0C
        and 007h                        ; 9E0D
        ld (LA3BA),a                    ; 9E0F
        ret nz                          ; 9E12
        ld a,(L8E25)                    ; 9E13
        dec a                           ; 9E16
        ld (L8E25),a                    ; 9E17
        and 01fh                        ; 9E1A
        ret nz                          ; 9E1C
        ld a,(L8E25)                    ; 9E1D
        ld hl,04e68h                    ; 9E20
        rlca                            ; 9E23
        rlca                            ; 9E24
        rlca                            ; 9E25
        ld bc,00040h                    ; 9E26
L9E29:
        and a                           ; 9E29
        jr z,L9E30                      ; 9E2A
        add hl,bc                       ; 9E2C
        dec a                           ; 9E2D
        jr L9E29                        ; 9E2E
L9E30:
        ld bc,01001h                    ; 9E30
        ld e,000h                       ; 9E33
        call L9D8B                      ; 9E35
        ld a,(L8E25)                    ; 9E38
        and a                           ; 9E3B
        ret nz                          ; 9E3C
        ld a,001h                       ; 9E3D
        ld (L8E39),a                    ; 9E3F
        ld a,008h                       ; 9E42
        ld (L8E38),a                    ; 9E44
        ld hl,L9673                     ; 9E47
        ld (L8E3A),hl                   ; 9E4A
        ret                             ; 9E4D
L9E4E:
        call LA220                      ; 9E4E
        ld b,064h                       ; 9E51
L9E53:
        push bc                         ; 9E53
        ld hl,00000h                    ; 9E54
        ld de,00000h                    ; 9E57
        ld bc,04000h                    ; 9E5A
        ldir                            ; 9E5D
        pop bc                          ; 9E5F
        call HAY_TECLA                  ; 9E60
        jr nz,L9E67                     ; 9E63
        djnz L9E53                      ; 9E65
L9E67:
        call ESPERA_SUELTA              ; 9E67
L9E6A:
        call L9F4C                      ; 9E6A
L9E6D:
        ld bc,003e8h                    ; 9E6D
L9E70:
        ld (LA2F8),bc                   ; 9E70
        call L9EA6                      ; 9E74
        call L9F39                      ; 9E77
        ld a,e                          ; 9E7A
        push af                         ; 9E7B
        ld hl,L9E94                     ; 9E7C
        push hl                         ; 9E7F
        bit 0,a                         ; 9E80
        jr nz,L9EA3                     ; 9E82
        bit 1,a                         ; 9E84
        jp nz,L9F03                     ; 9E86
        bit 2,a                         ; 9E89
        jp nz,L9F17                     ; 9E8B
        bit 3,a                         ; 9E8E
        jp nz,L9F28                     ; 9E90
        pop hl                          ; 9E93
L9E94:
        pop af                          ; 9E94
        and a                           ; 9E95
        jr nz,L9E6D                     ; 9E96
        ld bc,(LA2F8)                   ; 9E98
        dec bc                          ; 9E9C
        ld a,b                          ; 9E9D
        or c                            ; 9E9E
        jr z,L9E4E                      ; 9E9F
        jr L9E70                        ; 9EA1
L9EA3:
        pop hl                          ; 9EA3
        pop af                          ; 9EA4
        ret                             ; 9EA5
L9EA6:
        ld hl,001e0h                    ; 9EA6
        ld de,L9ECA                     ; 9EA9
        call L9F8D                      ; 9EAC
        ld hl,001f0h                    ; 9EAF
        ld de,L9ED7                     ; 9EB2
        call L9F8D                      ; 9EB5
        ld hl,009d8h                    ; 9EB8
        ld de,L9EE5                     ; 9EBB
        call L9F8D                      ; 9EBE
        ld hl,009f0h                    ; 9EC1
        ld de,L9EF8                     ; 9EC4
        jp L9F8D                        ; 9EC7
L9ECA:
        db 00Bh                                            ; 9ECA
L9ECB:
        db 081h                                            ; 9ECB
        db "1.- TECLADO"                                ; 9ECC
L9ED7:
        db 00Ch                                            ; 9ED7
L9ED8:
        db 0A1h                                            ; 9ED8
        db "2.- JOYSTICK"                               ; 9ED9
L9EE5:
        db 011h,0A1h                                       ; 9EE5
        db "3.- DEFINE TECLAS"                          ; 9EE7
L9EF8:
        db 009h                                            ; 9EF8
        db "!0.- JUGAR"                                 ; 9EF9
L9F03:
        call MENU                       ; 9F03
        ld a,081h                       ; 9F06
        ld (L9ECB),a                    ; 9F08
        ld a,0a1h                       ; 9F0B
        ld (L9ED8),a                    ; 9F0D
        ld hl,LEE_CONTROLES             ; 9F10
        ld (09381h),hl                  ; 9F13
        ret                             ; 9F16
L9F17:
        ld hl,L9C93                     ; 9F17
        ld (09381h),hl                  ; 9F1A
        ld a,081h                       ; 9F1D
        ld (L9ED8),a                    ; 9F1F
        ld a,0a1h                       ; 9F22
        ld (L9ECB),a                    ; 9F24
        ret                             ; 9F27
L9F28:
        ld hl,LEE_CONTROLES             ; 9F28
        ld (09381h),hl                  ; 9F2B
        ld a,081h                       ; 9F2E
        ld (L9ECB),a                    ; 9F30
        ld a,0a1h                       ; 9F33
        ld (L9ED8),a                    ; 9F35
        ret                             ; 9F38
L9F39:
        ld ix,L9F44                     ; 9F39
        ld e,000h                       ; 9F3D
        ld b,004h                       ; 9F3F
        jp L9C67                        ; 9F41
L9F44:
        db 0F0h,002h,0F0h,004h,0F0h,008h,0F0h,001h         ; 9F44
L9F4C:
        ld hl,06000h                    ; 9F4C
        call VDP_ESCRITURA              ; 9F4F
        ld bc,01800h                    ; 9F52
L9F55:
        ld a,011h                       ; 9F55
        out (098h),a                    ; 9F57
        ex (sp),hl                      ; 9F59
        ex (sp),hl                      ; 9F5A
        dec bc                          ; 9F5B
        ld a,b                          ; 9F5C
        or c                            ; 9F5D
        jr nz,L9F55                     ; 9F5E
        ret                             ; 9F60
L9F61:
        push hl                         ; 9F61
        ld l,a                          ; 9F62
        ld h,000h                       ; 9F63
        add hl,hl                       ; 9F65
        add hl,hl                       ; 9F66
        add hl,hl                       ; 9F67
        ld de,LBEAE                     ; 9F68
        add hl,de                       ; 9F6B
        ex de,hl                        ; 9F6C
        pop hl                          ; 9F6D
        call VDP_ESCRITURA              ; 9F6E
        ld b,008h                       ; 9F71
L9F73:
        ld a,(de)                       ; 9F73
        out (098h),a                    ; 9F74
        ex (sp),hl                      ; 9F76
        ex (sp),hl                      ; 9F77
        inc de                          ; 9F78
        djnz L9F73                      ; 9F79
        set 5,h                         ; 9F7B
        call VDP_ESCRITURA              ; 9F7D
        res 5,h                         ; 9F80
        ld b,008h                       ; 9F82
        ex af,af'                       ; 9F84
L9F85:
        out (098h),a                    ; 9F85
        ex (sp),hl                      ; 9F87
        ex (sp),hl                      ; 9F88
        djnz L9F85                      ; 9F89
        ex af,af'                       ; 9F8B
        ret                             ; 9F8C
L9F8D:
        ld a,(de)                       ; 9F8D
        ld c,a                          ; 9F8E
        inc de                          ; 9F8F
        ex af,af'                       ; 9F90
        ld a,(de)                       ; 9F91
        ex af,af'                       ; 9F92
        inc de                          ; 9F93
L9F94:
        push bc                         ; 9F94
        ld a,(de)                       ; 9F95
        cp 020h                         ; 9F96
        jr c,L9FAA                      ; 9F98
        push hl                         ; 9F9A
        push de                         ; 9F9B
        call L9F61                      ; 9F9C
        pop de                          ; 9F9F
        pop hl                          ; 9FA0
        call L9FB2                      ; 9FA1
L9FA4:
        inc de                          ; 9FA4
        pop bc                          ; 9FA5
        dec c                           ; 9FA6
        jr nz,L9F94                     ; 9FA7
        ret                             ; 9FA9
L9FAA:
        ld b,a                          ; 9FAA
L9FAB:
        call L9FB2                      ; 9FAB
        djnz L9FAB                      ; 9FAE
        jr L9FA4                        ; 9FB0
L9FB2:
        push bc                         ; 9FB2
        ld bc,00040h                    ; 9FB3
        add hl,bc                       ; 9FB6
        pop bc                          ; 9FB7
        ld a,l                          ; 9FB8
        and 0c0h                        ; 9FB9
        ret nz                          ; 9FBB
        ld a,h                          ; 9FBC
        and 007h                        ; 9FBD
        ret nz                          ; 9FBF
        push bc                         ; 9FC0
        ld bc,0f808h                    ; 9FC1
        add hl,bc                       ; 9FC4
        pop bc                          ; 9FC5
        ret                             ; 9FC6
ESPERA_TECLA:
        call HAY_TECLA                  ; 9FC7
        ret nz                          ; 9FCA
        jr ESPERA_TECLA                 ; 9FCB
ESPERA_SUELTA:
        call HAY_TECLA                  ; 9FCD
        ret z                           ; 9FD0
        jr ESPERA_SUELTA                ; 9FD1
HAY_TECLA:
        ld c,0f0h                       ; 9FD3
L9FD5:
        ld a,c                          ; 9FD5
        out (0aah),a                    ; 9FD6
        in a,(0a9h)                     ; 9FD8
        cp 0ffh                         ; 9FDA
        ret nz                          ; 9FDC
        inc c                           ; 9FDD
        ld a,0f9h                       ; 9FDE
        cp c                            ; 9FE0
        ret z                           ; 9FE1
        jr L9FD5                        ; 9FE2
MENU:
        call L9F4C                      ; 9FE4
        call LA183                      ; 9FE7
        ld hl,041a0h                    ; 9FEA
        ld de,LA0D5                     ; 9FED
        call L9F8D                      ; 9FF0
        call LA194                      ; 9FF3
        ld a,0f1h                       ; 9FF6
        ex af,af'                       ; 9FF8
        ld a,(LA21F)                    ; 9FF9
        ld hl,04460h                    ; 9FFC
        cp 024h                         ; 9FFF
        push af                         ; A001
        call c,LA0BC                    ; A002
        pop af                          ; A005
        jr c,LA00B                      ; A006
        call L9F61                      ; A008
LA00B:
        ld hl,041b0h                    ; A00B
        ld de,LA0DC                     ; A00E
        call L9F8D                      ; A011
        call LA194                      ; A014
        ld a,0f1h                       ; A017
        ex af,af'                       ; A019
        ld a,(LA21F)                    ; A01A
        ld hl,04470h                    ; A01D
        cp 024h                         ; A020
        push af                         ; A022
        call c,LA0BC                    ; A023
        pop af                          ; A026
        jr c,LA02C                      ; A027
        call L9F61                      ; A029
LA02C:
        ld hl,04980h                    ; A02C
        ld de,LA0E4                     ; A02F
        call L9F8D                      ; A032
        call LA194                      ; A035
        ld a,0f1h                       ; A038
        ex af,af'                       ; A03A
        ld a,(LA21F)                    ; A03B
        ld hl,04c40h                    ; A03E
        cp 024h                         ; A041
        push af                         ; A043
        call c,LA0BC                    ; A044
        pop af                          ; A047
        jr c,LA04D                      ; A048
        call L9F61                      ; A04A
LA04D:
        ld hl,04990h                    ; A04D
        ld de,LA0EB                     ; A050
        call L9F8D                      ; A053
        call LA194                      ; A056
        ld a,0f1h                       ; A059
        ex af,af'                       ; A05B
        ld a,(LA21F)                    ; A05C
        ld hl,04c50h                    ; A05F
        cp 024h                         ; A062
        push af                         ; A064
        call c,LA0BC                    ; A065
        pop af                          ; A068
        jr c,LA06E                      ; A069
        call L9F61                      ; A06B
LA06E:
        ld hl,049a0h                    ; A06E
        ld de,LA0F6                     ; A071
        call L9F8D                      ; A074
        call LA194                      ; A077
        ld a,0f1h                       ; A07A
        ex af,af'                       ; A07C
        ld a,(LA21F)                    ; A07D
        ld hl,04c60h                    ; A080
        cp 024h                         ; A083
        push af                         ; A085
        call c,LA0BC                    ; A086
        pop af                          ; A089
        jr c,LA08F                      ; A08A
        call L9F61                      ; A08C
LA08F:
        ld hl,049b0h                    ; A08F
        ld de,LA0CE                     ; A092
        call L9F8D                      ; A095
        call LA194                      ; A098
        ld a,0f1h                       ; A09B
        ex af,af'                       ; A09D
        ld a,(LA21F)                    ; A09E
        ld hl,04c70h                    ; A0A1
        cp 024h                         ; A0A4
        push af                         ; A0A6
        call c,LA0BC                    ; A0A7
        pop af                          ; A0AA
        jr c,LA0B0                      ; A0AB
        call L9F61                      ; A0AD
LA0B0:
        call ESPERA_SUELTA              ; A0B0
        call ESPERA_TECLA               ; A0B3
        call L9F4C                      ; A0B6
        jp L9EA6                        ; A0B9
LA0BC:
        ld d,000h                       ; A0BC
        push hl                         ; A0BE
        ld b,a                          ; A0BF
        ld hl,LA0FF                     ; A0C0
LA0C3:
        ld e,(hl)                       ; A0C3
        inc e                           ; A0C4
        inc e                           ; A0C5
        add hl,de                       ; A0C6
        djnz LA0C3                      ; A0C7
        ex de,hl                        ; A0C9
        pop hl                          ; A0CA
        jp L9F8D                        ; A0CB
LA0CE:
        db 005h                                            ; A0CE
        db "BPAUSA"                                     ; A0CF
LA0D5:
        db 005h                                            ; A0D5
        db "BFUEGO"                                     ; A0D6
LA0DC:
        db 006h                                            ; A0DC
        db "BARRIBA"                                    ; A0DD
LA0E4:
        db 005h                                            ; A0E4
        db "BABAJO"                                     ; A0E5
LA0EB:
        db 009h                                            ; A0EB
        db "BIZQUIERDA"                                 ; A0EC
LA0F6:
        db 007h                                            ; A0F6
        db "BDERECHA"                                   ; A0F7
LA0FF:
        db 001h,001h,001h,005h,0F1h                        ; A0FF
        db "SHIFT"                                      ; A104
        db 004h,0F1h                                       ; A109
        db "CTRL"                                       ; A10B
        db 005h,0F1h                                       ; A10F
        db "GRAPH"                                      ; A111
        db 004h,0F1h                                       ; A116
        db "CAPS"                                       ; A118
        db 001h,0F1h,020h,003h,0F1h,046h,020h,031h,003h,0F1h,046h,020h,032h,003h,0F1h,046h; A11C
        db 020h,033h,003h,0F1h,046h,020h,034h,003h,0F1h,046h,020h,035h,006h,0F1h; A12C
        db "ESCAPE"                                     ; A13A
        db 003h,0F1h,054h,041h,042h,004h,0F1h              ; A140
        db "STOP"                                       ; A147
        db 002h,0F1h,042h,053h,006h,0F1h                   ; A14B
        db "SELECT"                                     ; A151
        db 005h,0F1h                                       ; A157
        db "ENTER"                                      ; A159
        db 007h,0F1h                                       ; A15E
        db "ESPACIO"                                    ; A160
        db 004h,0F1h                                       ; A167
        db "HOME"                                       ; A169
        db 003h,0F1h,049h,04Eh,053h,003h,0F1h,044h,045h,04Ch,001h,0F1h,00Dh,001h,0F1h,00Dh; A16D
        db 001h,0F1h,00Dh,001h,0F1h,00Dh                   ; A17D
LA183:
        ld hl,TABLA_TECLAS              ; A183
        ld (LA21D),hl                   ; A186
        ld hl,LA1D5                     ; A189
        ld b,048h                       ; A18C
LA18E:
        res 7,(hl)                      ; A18E
        inc hl                          ; A190
        djnz LA18E                      ; A191
        ret                             ; A193
LA194:
        ld hl,(LA21D)                   ; A194
        call ESPERA_SUELTA              ; A197
LA19A:
        ld de,0f000h                    ; A19A
LA19D:
        ld a,d                          ; A19D
        out (0aah),a                    ; A19E
        in a,(0a9h)                     ; A1A0
        ld b,008h                       ; A1A2
LA1A4:
        rrca                            ; A1A4
        jr nc,LA1B2                     ; A1A5
        inc e                           ; A1A7
        djnz LA1A4                      ; A1A8
        inc d                           ; A1AA
        ld a,d                          ; A1AB
        cp 0f9h                         ; A1AC
        jr nz,LA19D                     ; A1AE
        jr LA19A                        ; A1B0
LA1B2:
        ld a,000h                       ; A1B2
        scf                             ; A1B4
LA1B5:
        rra                             ; A1B5
        djnz LA1B5                      ; A1B6
        ld (hl),d                       ; A1B8
        inc hl                          ; A1B9
        ld (hl),a                       ; A1BA
        inc hl                          ; A1BB
        push hl                         ; A1BC
        ld d,000h                       ; A1BD
        ld hl,LA1D5                     ; A1BF
        add hl,de                       ; A1C2
        ld a,(hl)                       ; A1C3
        bit 7,a                         ; A1C4
        jr z,LA1CB                      ; A1C6
        pop hl                          ; A1C8
        jr LA194                        ; A1C9
LA1CB:
        ld (LA21F),a                    ; A1CB
        set 7,(hl)                      ; A1CE
        pop hl                          ; A1D0
        ld (LA21D),hl                   ; A1D1
        ret                             ; A1D4
LA1D5:
        db "0123456789-="                               ; A1D5
        db 05Ch                                            ; A1E1
        db "{};: ,./^ABCDEFGHIJKLMNOPQRSTUVWXYZ"        ; A1E2
        db 001h,002h,003h,004h,005h,006h,007h,008h,009h,00Ah,00Bh,00Ch,00Dh,00Eh,00Fh,010h; A205
        db 011h,012h,013h,014h,015h,016h,017h,018h         ; A215
LA21D:
        db 000h,000h                                       ; A21D
LA21F:
        db 000h                                            ; A21F
LA220:
        call L9F4C                      ; A220
        ld de,TXT_CREDITOS              ; A223
        ld hl,04050h                    ; A226
        call L9F8D                      ; A229
        ld de,LA297                     ; A22C
        ld hl,041e0h                    ; A22F
        call L9F8D                      ; A232
        ld de,LA2A5                     ; A235
        ld hl,04078h                    ; A238
        call L9F8D                      ; A23B
        ld de,LA2B4                     ; A23E
        ld hl,049c8h                    ; A241
        call L9F8D                      ; A244
        ld de,LA2C7                     ; A247
        ld hl,04858h                    ; A24A
        call L9F8D                      ; A24D
        ld de,LA2D4                     ; A250
        ld hl,049e8h                    ; A253
        call L9F8D                      ; A256
        ld de,LA2DF                     ; A259
        ld hl,04ab8h                    ; A25C
        call L9F8D                      ; A25F
        ld de,LA2F4                     ; A262
        ld hl,04b78h                    ; A265
        call L9F8D                      ; A268
        ld de,LA2E4                     ; A26B
        ld hl,05280h                    ; A26E
        call L9F8D                      ; A271
        ld de,LA2F1                     ; A274
        ld hl,05340h                    ; A277
        call L9F8D                      ; A27A
        ld de,LA2E9                     ; A27D
        ld hl,05400h                    ; A280
        jp L9F8D                        ; A283
TXT_CREDITOS:
        db 00Fh,081h                                       ; A286
        db "PROGRAMADO POR:"                            ; A288
LA297:
        db 00Ch,0F1h                                       ; A297
        db "CARLOS ARIAS"                               ; A299
LA2A5:
        db 00Dh,081h                                       ; A2A5
        db "GRAFICOS POR:"                              ; A2A7
LA2B4:
        db 011h,0F1h                                       ; A2B4
        db "ROBERTO P. ACEVES"                          ; A2B6
LA2C7:
        db 00Bh,081h                                       ; A2C7
        db "MUSICA POR:"                                ; A2C9
LA2D4:
        db 009h,0F1h                                       ; A2D4
        db "GOMINOLAS"                                  ; A2D6
LA2DF:
        db 003h,041h,021h,022h,023h                        ; A2DF
LA2E4:
        db 003h                                            ; A2E4
        db "A&'("                                       ; A2E5
LA2E9:
        db 006h,0F1h                                       ; A2E9
        db "/ 1988"                                     ; A2EB
LA2F1:
        db 001h,041h,029h                                  ; A2F1
LA2F4:
        db 002h,041h,024h,025h                             ; A2F4
LA2F8:
        db 000h,000h                                       ; A2F8
TXT_SIN_MUNICION:
        db 05Ch,081h,002h                                  ; A2FA
        db "TE QUEDASTE SIN MUNICION PARA"              ; A2FD
        db 004h,01Fh                                       ; A31A
        db "ABRIR EL RESTO DE LOS COFRES"               ; A31C
        db 005h,01Fh                                       ; A338
        db "LA PROXIMA VEZ TEN MAS CUIDADO"             ; A33A
LA358:
        db 00Fh                                            ; A358
        db "qPULSA UNA TECLA"                           ; A359
LA369:
        db 04Fh,021h,002h                                  ; A369
TXT_FINAL:
        db "EL CODICIADO MAPA DEL TESORO"               ; A36C
        db 008h,01Fh                                       ; A388
        db "ESTA PORFIN EN TU PODER"                    ; A38A
        db 009h,01Fh                                       ; A3A1
        db "                       "                    ; A3A3
LA3BA:
        db 000h                                            ; A3BA
LA3BB:
        ld hl,L9C91                     ; A3BB
        ld a,(hl)                       ; A3BE
        out (0aah),a                    ; A3BF
        in a,(0a9h)                     ; A3C1
        inc hl                          ; A3C3
        and (hl)                        ; A3C4
        ret nz                          ; A3C5
        call ESPERA_SUELTA              ; A3C6
        jp ESPERA_TECLA                 ; A3C9
INT_JUEGO:
        di                              ; A3CC
        push af                         ; A3CD
        in a,(099h)                     ; A3CE
        and a                           ; A3D0
        jp p,LA409                      ; A3D1
        push ix                         ; A3D4
        push iy                         ; A3D6
        push hl                         ; A3D8
        push de                         ; A3D9
        push bc                         ; A3DA
        exx                             ; A3DB
        ex af,af'                       ; A3DC
        push af                         ; A3DD
        push hl                         ; A3DE
        push de                         ; A3DF
        push bc                         ; A3E0
        ld a,(LA43F)                    ; A3E1
        cp 0ffh                         ; A3E4
        jr z,LA3FC                      ; A3E6
        add a,a                         ; A3E8
        ld e,a                          ; A3E9
        ld d,000h                       ; A3EA
        ld hl,LA444                     ; A3EC
        add hl,de                       ; A3EF
        ld e,(hl)                       ; A3F0
        inc hl                          ; A3F1
        ld d,(hl)                       ; A3F2
        ex de,hl                        ; A3F3
        ld a,0ffh                       ; A3F4
        ld (LA43F),a                    ; A3F6
        call ESCRIBE_PSG                ; A3F9
LA3FC:
        pop bc                          ; A3FC
        pop de                          ; A3FD
        pop hl                          ; A3FE
        pop af                          ; A3FF
        ex af,af'                       ; A400
        exx                             ; A401
        pop bc                          ; A402
        pop de                          ; A403
        pop hl                          ; A404
        pop iy                          ; A405
        pop ix                          ; A407
LA409:
        pop af                          ; A409
        ei                              ; A40A
        ret                             ; A40B
ESCRIBE_PSG:
        ld b,(hl)                       ; A40C
        inc hl                          ; A40D
LA40E:
        push bc                         ; A40E
        ld a,(hl)                       ; A40F
        inc hl                          ; A410
        ld c,(hl)                       ; A411
        inc hl                          ; A412
        out (0a0h),a                    ; A413
        ld a,c                          ; A415
        out (0a1h),a                    ; A416
        pop bc                          ; A418
        djnz LA40E                      ; A419
        ret                             ; A41B
ARRANCA_MUSICA:
        di                              ; A41C
        ld a,0c3h                       ; A41D
        ld (00038h),a                   ; A41F
        ld hl,INT_PRESENTACION          ; A422
        ld (00039h),hl                  ; A425
        ld de,L8BF5                     ; A428
        xor a                           ; A42B
        call MUSICA_CANAL               ; A42C
        ld de,L8CEA                     ; A42F
        inc a                           ; A432
        call MUSICA_CANAL               ; A433
        ld de,L8D03                     ; A436
        inc a                           ; A439
        call MUSICA_CANAL               ; A43A
        ei                              ; A43D
        ret                             ; A43E
LA43F:
        db 0FFh,03Fh,0A4h,000h                             ; A43F
LA443:
        db 001h                                            ; A443
LA444:
        db 054h,0A4h,0AAh,0A4h,0B9h,0A4h,072h,0A4h,063h,0A4h,09Dh,0A4h,081h,0A4h,08Eh,0A4h; A444
        db 007h,004h,032h,005h,003h,00Ah,010h,00Bh,032h,00Ch,003h,00Dh,001h,007h,03Bh,007h; A454
        db 002h,04Ah,003h,000h,009h,010h,00Bh,000h,00Ch,007h,00Dh,001h,007h,03Dh,007h,000h; A464
        db 04Ah,001h,002h,008h,010h,00Bh,000h,00Ch,005h,00Dh,001h,007h,03Eh,006h,006h,01Eh; A474
        db 009h,010h,00Bh,0FFh,00Ch,005h,00Dh,001h,007h,02Fh,007h,004h,000h,005h,00Fh,00Ah; A484
        db 010h,00Bh,000h,00Ch,032h,00Dh,001h,007h,03Bh,006h,006h,00Ah,009h,010h,00Bh,000h; A494
        db 00Ch,01Eh,00Dh,001h,007h,02Fh,007h,000h,000h,001h,007h,008h,010h,00Bh,000h,00Ch; A4A4
        db 01Eh,00Dh,001h,007h,03Eh,007h,000h,000h,001h,00Ah,008h,010h,00Bh,000h,00Ch,01Eh; A4B4
        db 00Dh,001h,007h,03Eh                             ; A4C4
LA4C8:
        di                              ; A4C8
        ld hl,00000h                    ; A4C9
        call VDP_ESCRITURA              ; A4CC
        ld hl,064f0h                    ; A4CF
        ld bc,01800h                    ; A4D2
        call LA4E7                      ; A4D5
        ld hl,02000h                    ; A4D8
        call VDP_ESCRITURA              ; A4DB
        ld hl,07cf0h                    ; A4DE
        ld bc,00300h                    ; A4E1
        jp LA4F1                        ; A4E4
LA4E7:
        ld a,(hl)                       ; A4E7
        out (098h),a                    ; A4E8
        inc hl                          ; A4EA
        dec bc                          ; A4EB
        ld a,b                          ; A4EC
        or c                            ; A4ED
        jr nz,LA4E7                     ; A4EE
        ret                             ; A4F0
LA4F1:
        push bc                         ; A4F1
        ld b,008h                       ; A4F2
LA4F4:
        ld a,(hl)                       ; A4F4
        out (098h),a                    ; A4F5
        djnz LA4F4                      ; A4F7
        inc hl                          ; A4F9
        pop bc                          ; A4FA
        dec bc                          ; A4FB
        ld a,b                          ; A4FC
        or c                            ; A4FD
        jr nz,LA4F1                     ; A4FE
        ret                             ; A500
VDP_ESCRITURA:
        push af                         ; A501
        in a,(099h)                     ; A502
        ld a,l                          ; A504
        out (099h),a                    ; A505
        ld a,h                          ; A507
        and 07fh                        ; A508
        or 040h                         ; A50A
        out (099h),a                    ; A50C
        pop af                          ; A50E
        ret                             ; A50F
LA510:
        in a,(099h)                     ; A510
        ld a,l                          ; A512
        out (099h),a                    ; A513
        ld a,h                          ; A515
        and 03fh                        ; A516
        out (099h),a                    ; A518
        ret                             ; A51A
LA51B:
        call LA510                      ; A51B
LA51E:
        in a,(098h)                     ; A51E
        ld (de),a                       ; A520
        inc de                          ; A521
        dec bc                          ; A522
        ld a,b                          ; A523
        or c                            ; A524
        jr nz,LA51E                     ; A525
        ret                             ; A527
LA528:
        ex de,hl                        ; A528
        call VDP_ESCRITURA              ; A529
        ex de,hl                        ; A52C
LA52D:
        ld a,(hl)                       ; A52D
        out (098h),a                    ; A52E
        inc hl                          ; A530
        dec bc                          ; A531
        ld a,b                          ; A532
        or c                            ; A533
        jr nz,LA52D                     ; A534
        ret                             ; A536
LA537:
        call VDP_ESCRITURA              ; A537
        ex (sp),hl                      ; A53A
        ex (sp),hl                      ; A53B
LA53C:
        ld a,e                          ; A53C
        out (098h),a                    ; A53D
        dec bc                          ; A53F
        ld a,b                          ; A540
        or c                            ; A541
        jr nz,LA53C                     ; A542
        ret                             ; A544
LA545:
        ld hl,02000h                    ; A545
        ld bc,00600h                    ; A548
        ld e,01fh                       ; A54B
        push bc                         ; A54D
        call LA537                      ; A54E
        pop bc                          ; A551
        ld hl,02800h                    ; A552
        push bc                         ; A555
        call LA537                      ; A556
        pop bc                          ; A559
        ld hl,03000h                    ; A55A
        jp LA537                        ; A55D
INICIA_VDP:
        call LA571                      ; A560
        call LA58C                      ; A563
        call LA5AB                      ; A566
        ld b,0f1h                       ; A569
        call LA596                      ; A56B
        jp LA5C4                        ; A56E
LA571:
        ld c,099h                       ; A571
        ld hl,LA584                     ; A573
        ld b,008h                       ; A576
LA578:
        outi                            ; A578
        ld a,b                          ; A57A
        or 080h                         ; A57B
        out (c),a                       ; A57D
        and 07fh                        ; A57F
        jr nz,LA578                     ; A581
        ret                             ; A583
LA584:
        db 001h,007h,036h,003h,0FFh,006h,080h,002h         ; A584
LA58C:
        ld hl,00000h                    ; A58C
        ld de,04000h                    ; A58F
        ld b,000h                       ; A592
        jr LA59E                        ; A594
LA596:
        ld hl,02000h                    ; A596
        ld de,01800h                    ; A599
        ld b,011h                       ; A59C
LA59E:
        call VDP_ESCRITURA              ; A59E
        ld c,098h                       ; A5A1
LA5A3:
        out (c),b                       ; A5A3
        dec de                          ; A5A5
        ld a,d                          ; A5A6
        or e                            ; A5A7
        jr nz,LA5A3                     ; A5A8
        ret                             ; A5AA
LA5AB:
        ld hl,01800h                    ; A5AB
        call VDP_ESCRITURA              ; A5AE
        ld a,098h                       ; A5B1
        ld b,003h                       ; A5B3
LA5B5:
        xor a                           ; A5B5
LA5B6:
        out (c),a                       ; A5B6
        add a,008h                      ; A5B8
        jr nc,LA5B6                     ; A5BA
        inc a                           ; A5BC
        cp 008h                         ; A5BD
        jr nz,LA5B6                     ; A5BF
        djnz LA5B5                      ; A5C1
        ret                             ; A5C3
LA5C4:
        ld c,099h                       ; A5C4
        ld b,0e2h                       ; A5C6
        out (c),b                       ; A5C8
        ld b,081h                       ; A5CA
        out (c),b                       ; A5CC
        ret                             ; A5CE

; CÓDIGO MUERTO: copia de la rutina de carga de LOAD.BIN. En la cinta real es el
; cargador tipo Spectrum; el .cas lo cambió por el de la BIOS (ver cinta_tsx.asm)
CARGADOR_CINTA_SIN_USAR:
        di                              ; A5CF
        ex af,af'                       ; A5D0
        exx                             ; A5D1
        push bc                         ; A5D2
        push de                         ; A5D3
        push hl                         ; A5D4
        ld hl,0fca6h                    ; A5D5
        ld b,00ch                       ; A5D8
LA5DA:
        dec hl                          ; A5DA
        ld d,(hl)                       ; A5DB
        dec hl                          ; A5DC
        ld e,(hl)                       ; A5DD
        push de                         ; A5DE
        djnz LA5DA                      ; A5DF
        ld a,h                          ; A5E1
        ld h,b                          ; A5E2
        ld l,b                          ; A5E3
        add hl,sp                       ; A5E4
        ld sp,0fca4h                    ; A5E5
        ld de,LC961                     ; A5E8
        push de                         ; A5EB
        ld de,0edd9h                    ; A5EC
        push de                         ; A5EF
        ld de,000e1h                    ; A5F0
        push de                         ; A5F3
        ld de,LCDD9                     ; A5F4
        push de                         ; A5F7
        ld de,069edh                    ; A5F8
        push de                         ; A5FB
        push hl                         ; A5FC
        exx                             ; A5FD
        ld c,0a8h                       ; A5FE
        in h,(c)                        ; A600
        and h                           ; A602
        ld l,a                          ; A603
        call 0fc9ah                     ; A604
        jr c,LA64A                      ; A607
        ld a,0e4h                       ; A609
        ld (0fc9eh),a                   ; A60B
        call 0fc9ah                     ; A60E
        jr c,LA64A                      ; A611
        ld b,a                          ; A613
        ex af,af'                       ; A614
        cp b                            ; A615
        scf                             ; A616
        jr nz,LA64A                     ; A617
        jr LA637                        ; A619
LA61B:
        pop af                          ; A61B
        push ix                         ; A61C
        exx                             ; A61E
        pop bc                          ; A61F
        ld hl,00372h                    ; A620
        add hl,bc                       ; A623
        jr nc,LA632                     ; A624
        ex de,hl                        ; A626
        ld hl,0ffe8h                    ; A627
        add hl,de                       ; A62A
        jr c,LA632                      ; A62B
        pop hl                          ; A62D
        push hl                         ; A62E
        add hl,de                       ; A62F
        ld (hl),a                       ; A630
        ld a,(bc)                       ; A631
LA632:
        ld (bc),a                       ; A632
        exx                             ; A633
        inc ix                          ; A634
        dec de                          ; A636
LA637:
        call 0fc9ah                     ; A637
        jr c,LA64A                      ; A63A
        push af                         ; A63C
        xor b                           ; A63D
        ld b,a                          ; A63E
        ld a,e                          ; A63F
        out (099h),a                    ; A640
        or d                            ; A642
        ld a,087h                       ; A643
        out (099h),a                    ; A645
        jr nz,LA61B                     ; A647
        pop af                          ; A649
LA64A:
        sbc a,a                         ; A64A
        or b                            ; A64B
        ex af,af'                       ; A64C
        ld a,0f3h                       ; A64D
        ld (0fc9eh),a                   ; A64F
        xor a                           ; A652
        call 0fc9ah                     ; A653
        exx                             ; A656
        pop hl                          ; A657
        ld sp,hl                        ; A658
        ld hl,0fc8eh                    ; A659
        ld b,00ch                       ; A65C
LA65E:
        pop de                          ; A65E
        ld (hl),e                       ; A65F
        inc hl                          ; A660
        ld (hl),d                       ; A661
        inc hl                          ; A662
        djnz LA65E                      ; A663
        pop hl                          ; A665
        pop de                          ; A666
        pop bc                          ; A667
        exx                             ; A668
        ex af,af'                       ; A669
        cp 001h                         ; A66A
        ret                             ; A66C
        db 0F8h,0E6h,00Fh,0D3h,099h,03Eh,057h,0D3h,099h,037h,0C9h,01Eh,013h,03Eh,009h,0D3h; A66D
        db 0ABh,03Eh,001h,0D3h,099h,03Eh                   ; A67D
LA683:
        db 057h,0D3h                                       ; A683
LA685:
        db 099h,0C9h,0F0h,05Dh,002h,010h,0F0h,05Ah,002h,010h,070h,05Ch,002h,010h,030h,05Eh; A685
        db 002h,010h,030h,05Eh,002h,010h,0E0h,059h,002h,010h,08Eh,0BFh,001h,010h,02Eh,0D3h; A695
        db 002h,010h,06Eh,0D3h,003h,018h                   ; A6A5
LA6AB:
        call LA713                      ; A6AB
LA6AE:
        ld a,(L8E4E)                    ; A6AE
        dec a                           ; A6B1
        ld (L8E4E),a                    ; A6B2
        ret z                           ; A6B5
        call LA767                      ; A6B6
        call L9398                      ; A6B9
        call VUELCA_PANTALLA            ; A6BC
        ld a,(0a7d7h)                   ; A6BF
        sub 008h                        ; A6C2
        ld (0a7d7h),a                   ; A6C4
        ld (LA887+1),a                  ; A6C7
        ld a,(0a7dbh)                   ; A6CA
        add a,008h                      ; A6CD
        ld (0a7dbh),a                   ; A6CF
        ld (0a88ch),a                   ; A6D2
        ld a,(LA7E7+1)                  ; A6D5
        dec a                           ; A6D8
        ld (LA7E7+1),a                  ; A6D9
        ld (LA896+1),a                  ; A6DC
        ld a,(0a7ech)                   ; A6DF
        inc a                           ; A6E2
        ld (0a7ech),a                   ; A6E3
        ld (0a89bh),a                   ; A6E6
        ld a,(LA82C+1)                  ; A6E9
        dec a                           ; A6EC
        ld (LA82C+1),a                  ; A6ED
        ld (LA8E0+1),a                  ; A6F0
        ld a,(0a831h)                   ; A6F3
        inc a                           ; A6F6
        ld (0a831h),a                   ; A6F7
        ld (0a8e5h),a                   ; A6FA
        ld a,(LA83B+1)                  ; A6FD
        dec a                           ; A700
        ld (LA83B+1),a                  ; A701
        ld (LA8EF+1),a                  ; A704
        ld a,(0a840h)                   ; A707
        inc a                           ; A70A
        ld (0a840h),a                   ; A70B
        ld (0a8f4h),a                   ; A70E
        jr LA6AE                        ; A711
LA713:
        ld a,(L8E43)                    ; A713
        ld b,a                          ; A716
        rlca                            ; A717
        rlca                            ; A718
        rlca                            ; A719
        ld c,a                          ; A71A
        ld a,058h                       ; A71B
        add a,c                         ; A71D
        ld (0a7d7h),a                   ; A71E
        ld (LA887+1),a                  ; A721
        ld a,068h                       ; A724
        add a,c                         ; A726
        ld (0a7dbh),a                   ; A727
        ld (0a88ch),a                   ; A72A
        ld a,00bh                       ; A72D
        add a,b                         ; A72F
        ld (LA82C+1),a                  ; A730
        ld (LA8E0+1),a                  ; A733
        ld a,00dh                       ; A736
        add a,b                         ; A738
        ld (0a831h),a                   ; A739
        ld (0a8e5h),a                   ; A73C
        ld a,(L8E42)                    ; A73F
        ld c,a                          ; A742
        ld a,00bh                       ; A743
        add a,c                         ; A745
        ld (LA7E7+1),a                  ; A746
        ld (LA83B+1),a                  ; A749
        ld (LA896+1),a                  ; A74C
        ld (LA8EF+1),a                  ; A74F
        ld a,00dh                       ; A752
        add a,c                         ; A754
        ld (0a7ech),a                   ; A755
        ld (0a840h),a                   ; A758
        ld (0a89bh),a                   ; A75B
        ld (0a8f4h),a                   ; A75E
        ld a,00dh                       ; A761
        ld (L8E4E),a                    ; A763
        ret                             ; A766
LA767:
        xor a                           ; A767
        ld (L8E4F),a                    ; A768
        ld (L8E50),a                    ; A76B
        exx                             ; A76E
        ld de,01c68h                    ; A76F
        exx                             ; A772
        ld de,003e8h                    ; A773
        ld hl,(V_PTR_MAPA)              ; A776
        ld c,007h                       ; A779
LA77B:
        ld b,007h                       ; A77B
LA77D:
        push bc                         ; A77D
        ld a,(hl)                       ; A77E
        ld (V_COLOR_LOSETA),a           ; A77F
        inc hl                          ; A782
        ld a,(hl)                       ; A783
        ex af,af'                       ; A784
        push hl                         ; A785
        call DIR_LOSETA                 ; A786
        ex af,af'                       ; A789
        call LA7CC                      ; A78A
        ld a,(L8E4F)                    ; A78D
        sub 020h                        ; A790
        ld (L8E4F),a                    ; A792
        ld a,(L8E50)                    ; A795
        add a,004h                      ; A798
        ld (L8E50),a                    ; A79A
        pop hl                          ; A79D
        inc hl                          ; A79E
        pop bc                          ; A79F
        djnz LA77D                      ; A7A0
        exx                             ; A7A2
        ld hl,00054h                    ; A7A3
        add hl,de                       ; A7A6
        ex de,hl                        ; A7A7
        exx                             ; A7A8
        xor a                           ; A7A9
        ld (L8E50),a                    ; A7AA
        ld a,(L8E4F)                    ; A7AD
        add a,020h                      ; A7B0
        ld (L8E4F),a                    ; A7B2
        push hl                         ; A7B5
        ld hl,00364h                    ; A7B6
        add hl,de                       ; A7B9
        ex de,hl                        ; A7BA
        pop hl                          ; A7BB
        ld a,(L8E44)                    ; A7BC
        sub 007h                        ; A7BF
        add a,a                         ; A7C1
        add a,l                         ; A7C2
        ld l,a                          ; A7C3
        ld a,h                          ; A7C4
        adc a,000h                      ; A7C5
        ld h,a                          ; A7C7
        dec c                           ; A7C8
        jr nz,LA77B                     ; A7C9
        ret                             ; A7CB
LA7CC:
        ld b,020h                       ; A7CC
        bit 7,a                         ; A7CE
        jp nz,LA876                     ; A7D0
LA7D3:
        ld a,(L8E4F)                    ; A7D3
        cp 000h                         ; A7D6
        jr c,LA801                      ; A7D8
        cp 000h                         ; A7DA
        jr nc,LA801                     ; A7DC
        inc a                           ; A7DE
        ld (L8E4F),a                    ; A7DF
        ld c,008h                       ; A7E2
        ld a,(L8E50)                    ; A7E4
LA7E7:
        cp 000h                         ; A7E7
        jr c,LA819                      ; A7E9
        cp 000h                         ; A7EB
        jr nc,LA819                     ; A7ED
        inc a                           ; A7EF
        ldi                             ; A7F0
LA7F2:
        dec c                           ; A7F2
        jr nz,LA7E7                     ; A7F3
        push hl                         ; A7F5
        ld hl,00018h                    ; A7F6
        add hl,de                       ; A7F9
        ex de,hl                        ; A7FA
        pop hl                          ; A7FB
LA7FC:
        djnz LA7D3                      ; A7FC
        jp LA81F                        ; A7FE
LA801:
        add a,008h                      ; A801
        ld (L8E4F),a                    ; A803
        push hl                         ; A806
        ld hl,000e0h                    ; A807
        add hl,de                       ; A80A
        ex de,hl                        ; A80B
        pop hl                          ; A80C
        push de                         ; A80D
        ld de,00020h                    ; A80E
        add hl,de                       ; A811
        pop de                          ; A812
        ld a,b                          ; A813
        sub 007h                        ; A814
        ld b,a                          ; A816
        jr LA7FC                        ; A817
LA819:
        inc hl                          ; A819
        inc de                          ; A81A
        inc a                           ; A81B
        dec bc                          ; A81C
        jr LA7F2                        ; A81D
LA81F:
        push hl                         ; A81F
        exx                             ; A820
        pop hl                          ; A821
        ld c,004h                       ; A822
        ld a,(L8E4F)                    ; A824
        rrca                            ; A827
        rrca                            ; A828
        rrca                            ; A829
        sub 004h                        ; A82A
LA82C:
        cp 000h                         ; A82C
        jr c,LA864                      ; A82E
        cp 000h                         ; A830
        jr nc,LA864                     ; A832
        inc a                           ; A834
        push af                         ; A835
        ld b,004h                       ; A836
        ld a,(L8E50)                    ; A838
LA83B:
        cp 000h                         ; A83B
        jr c,LA872                      ; A83D
        cp 000h                         ; A83F
        jr nc,LA872                     ; A841
        push bc                         ; A843
        push af                         ; A844
        call COPIA_BYTE_COLOR           ; A845
        pop af                          ; A848
        pop bc                          ; A849
LA84A:
        inc a                           ; A84A
        djnz LA83B                      ; A84B
        push hl                         ; A84D
        ld hl,00018h                    ; A84E
        add hl,de                       ; A851
        ex de,hl                        ; A852
        pop hl                          ; A853
        pop af                          ; A854
LA855:
        dec c                           ; A855
        jr nz,LA82C                     ; A856
        ld hl,0ff94h                    ; A858
        add hl,de                       ; A85B
        ex de,hl                        ; A85C
        exx                             ; A85D
        ld hl,0fc84h                    ; A85E
        add hl,de                       ; A861
        ex de,hl                        ; A862
        ret                             ; A863
LA864:
        push hl                         ; A864
        ld hl,0001ch                    ; A865
        add hl,de                       ; A868
        ex de,hl                        ; A869
        pop hl                          ; A86A
        inc hl                          ; A86B
        inc hl                          ; A86C
        inc hl                          ; A86D
        inc hl                          ; A86E
        inc a                           ; A86F
        jr LA855                        ; A870
LA872:
        inc hl                          ; A872
        inc de                          ; A873
        jr LA84A                        ; A874
LA876:
        ld bc,00364h                    ; A876
        ex de,hl                        ; A879
        add hl,bc                       ; A87A
        ex de,hl                        ; A87B
        ld b,020h                       ; A87C
        ld a,(L8E4F)                    ; A87E
        add a,020h                      ; A881
        ld (L8E4F),a                    ; A883
        dec a                           ; A886
LA887:
        cp 000h                         ; A887
        jr c,LA8B1                      ; A889
        cp 000h                         ; A88B
        jr nc,LA8B1                     ; A88D
        dec a                           ; A88F
        ex af,af'                       ; A890
        ld c,008h                       ; A891
        ld a,(L8E50)                    ; A893
LA896:
        cp 000h                         ; A896
        jr c,LA8C8                      ; A898
        cp 000h                         ; A89A
        jr nc,LA8C8                     ; A89C
        inc a                           ; A89E
        ldi                             ; A89F
LA8A1:
        dec c                           ; A8A1
        jr nz,LA896                     ; A8A2
        push hl                         ; A8A4
        ld hl,0ffe0h                    ; A8A5
        add hl,de                       ; A8A8
        ex de,hl                        ; A8A9
        pop hl                          ; A8AA
        ex af,af'                       ; A8AB
LA8AC:
        djnz LA887                      ; A8AC
        jp LA8CE                        ; A8AE
LA8B1:
        sub 008h                        ; A8B1
        push hl                         ; A8B3
        ld hl,0ff20h                    ; A8B4
        add hl,de                       ; A8B7
        ex de,hl                        ; A8B8
        pop hl                          ; A8B9
        push de                         ; A8BA
        ld de,00020h                    ; A8BB
        add hl,de                       ; A8BE
        pop de                          ; A8BF
        ex af,af'                       ; A8C0
        ld a,b                          ; A8C1
        sub 007h                        ; A8C2
        ld b,a                          ; A8C4
        ex af,af'                       ; A8C5
        jr LA8AC                        ; A8C6
LA8C8:
        inc hl                          ; A8C8
        inc de                          ; A8C9
        inc a                           ; A8CA
        dec bc                          ; A8CB
        jr LA8A1                        ; A8CC
LA8CE:
        push hl                         ; A8CE
        exx                             ; A8CF
        ld bc,00054h                    ; A8D0
        ex de,hl                        ; A8D3
        add hl,bc                       ; A8D4
        ex de,hl                        ; A8D5
        pop hl                          ; A8D6
        ld c,004h                       ; A8D7
        ld a,(L8E4F)                    ; A8D9
        rrca                            ; A8DC
        rrca                            ; A8DD
        rrca                            ; A8DE
        dec a                           ; A8DF
LA8E0:
        cp 000h                         ; A8E0
        jr c,LA918                      ; A8E2
        cp 000h                         ; A8E4
        jr nc,LA918                     ; A8E6
        dec a                           ; A8E8
        push af                         ; A8E9
        ld b,004h                       ; A8EA
        ld a,(L8E50)                    ; A8EC
LA8EF:
        cp 000h                         ; A8EF
        jr c,LA926                      ; A8F1
        cp 000h                         ; A8F3
        jr nc,LA926                     ; A8F5
        push bc                         ; A8F7
        push af                         ; A8F8
        call COPIA_BYTE_COLOR           ; A8F9
        pop af                          ; A8FC
        pop bc                          ; A8FD
LA8FE:
        inc a                           ; A8FE
        djnz LA8EF                      ; A8FF
        push hl                         ; A901
        ld hl,0ffe0h                    ; A902
        add hl,de                       ; A905
        ex de,hl                        ; A906
        pop hl                          ; A907
        pop af                          ; A908
LA909:
        dec c                           ; A909
        jr nz,LA8E0                     ; A90A
        ld hl,00020h                    ; A90C
        add hl,de                       ; A90F
        ex de,hl                        ; A910
        exx                             ; A911
        ld hl,00020h                    ; A912
        add hl,de                       ; A915
        ex de,hl                        ; A916
        ret                             ; A917
LA918:
        push hl                         ; A918
        ld hl,0ffe4h                    ; A919
        add hl,de                       ; A91C
        ex de,hl                        ; A91D
        pop hl                          ; A91E
        inc hl                          ; A91F
        inc hl                          ; A920
        inc hl                          ; A921
        inc hl                          ; A922
        dec a                           ; A923
        jr LA909                        ; A924
LA926:
        inc hl                          ; A926
        inc de                          ; A927
        jr LA8FE                        ; A928
LA92A:
        push ix                         ; A92A
        push bc                         ; A92C
        push de                         ; A92D
        ld a,(V_JUG_X)                  ; A92E
        add a,b                         ; A931
        ld (V_JUG_X),a                  ; A932
        ld c,b                          ; A935
        ld b,00ch                       ; A936
        ld de,00007h                    ; A938
        ld hl,L8E68                     ; A93B
LA93E:
        ld a,(hl)                       ; A93E
        add a,c                         ; A93F
        ld (hl),a                       ; A940
        add hl,de                       ; A941
        djnz LA93E                      ; A942
        sra c                           ; A944
        sra c                           ; A946
        sra c                           ; A948
        ld b,009h                       ; A94A
        ld de,00007h                    ; A94C
        ld ix,TABLA_ENEMIGOS            ; A94F
LA953:
        ld a,(ix+001h)                  ; A953
        add a,c                         ; A956
        ld (ix+001h),a                  ; A957
        add ix,de                       ; A95A
        djnz LA953                      ; A95C
        ld a,(L8E59)                    ; A95E
        add a,c                         ; A961
        ld (L8E59),a                    ; A962
        pop de                          ; A965
        pop bc                          ; A966
        pop ix                          ; A967
        ret                             ; A969
LA96A:
        push ix                         ; A96A
        push bc                         ; A96C
        push de                         ; A96D
        ld a,(V_JUG_Y)                  ; A96E
        add a,b                         ; A971
        ld (V_JUG_Y),a                  ; A972
        ld c,b                          ; A975
        ld b,00ch                       ; A976
        ld de,00007h                    ; A978
        ld hl,L8E69                     ; A97B
LA97E:
        ld a,(hl)                       ; A97E
        add a,c                         ; A97F
        ld (hl),a                       ; A980
        add hl,de                       ; A981
        djnz LA97E                      ; A982
        sra c                           ; A984
        sra c                           ; A986
        sra c                           ; A988
        ld ix,TABLA_ENEMIGOS            ; A98A
        ld b,009h                       ; A98E
        ld de,00007h                    ; A990
LA993:
        ld a,(ix+002h)                  ; A993
        add a,c                         ; A996
        ld (ix+002h),a                  ; A997
        add ix,de                       ; A99A
        djnz LA993                      ; A99C
        ld a,(L8E5A)                    ; A99E
        add a,c                         ; A9A1
        ld (L8E5A),a                    ; A9A2
        pop de                          ; A9A5
        pop bc                          ; A9A6
        pop ix                          ; A9A7
        ret                             ; A9A9
LA9AA:
        ld hl,003e8h                    ; A9AA
        ld de,003e9h                    ; A9AD
        ld bc,0187fh                    ; A9B0
        ld (hl),000h                    ; A9B3
        ldir                            ; A9B5
        ld hl,01c68h                    ; A9B7
        ld de,01c69h                    ; A9BA
        ld bc,0030fh                    ; A9BD
        ld (hl),007h                    ; A9C0
        ldir                            ; A9C2
        ret                             ; A9C4
LA9C5:
        dec b                           ; A9C5
        dec c                           ; A9C6
        ld a,b                          ; A9C7
        cp 000h                         ; A9C8
        jr z,LA9D9                      ; A9CA
        ld a,(L8E44)                    ; A9CC
        ld e,a                          ; A9CF
        ld d,000h                       ; A9D0
        sla e                           ; A9D2
        rl d                            ; A9D4
LA9D6:
        add hl,de                       ; A9D6
        djnz LA9D6                      ; A9D7
LA9D9:
        ld e,c                          ; A9D9
        ld d,000h                       ; A9DA
        sla e                           ; A9DC
        rl d                            ; A9DE
        add hl,de                       ; A9E0
        ret                             ; A9E1
LA9E2:
        ld a,(L8E41)                    ; A9E2
        ld h,a                          ; A9E5
        ld a,(L8E31)                    ; A9E6
        sla a                           ; A9E9
        sla a                           ; A9EB
        ld c,a                          ; A9ED
        ld a,(V_JUG_X)                  ; A9EE
        srl a                           ; A9F1
        srl a                           ; A9F3
        srl a                           ; A9F5
        add a,c                         ; A9F7
        ld c,a                          ; A9F8
        ld a,(L8E42)                    ; A9F9
        add a,c                         ; A9FC
        ld c,a                          ; A9FD
        ld a,(L8E32)                    ; A9FE
        sla a                           ; AA01
        sla a                           ; AA03
        ld b,a                          ; AA05
        ld a,(V_JUG_Y)                  ; AA06
        srl a                           ; AA09
        srl a                           ; AA0B
        srl a                           ; AA0D
        add a,b                         ; AA0F
        ld b,a                          ; AA10
        ld a,(L8E43)                    ; AA11
        add a,b                         ; AA14
        ld l,a                          ; AA15
        ld b,006h                       ; AA16
        ld ix,L904B                     ; AA18
        ld de,00006h                    ; AA1C
LAA1F:
        ld a,h                          ; AA1F
        cp (ix+002h)                    ; AA20
        jr nz,LAA31                     ; AA23
        ld a,c                          ; AA25
        cp (ix+000h)                    ; AA26
        jr nz,LAA31                     ; AA29
        ld a,l                          ; AA2B
        cp (ix+001h)                    ; AA2C
        jr z,LAA36                      ; AA2F
LAA31:
        add ix,de                       ; AA31
        djnz LAA1F                      ; AA33
        ret                             ; AA35
LAA36:
        pop bc                          ; AA36
        ld a,(V_JUG_X)                  ; AA37
        srl a                           ; AA3A
        srl a                           ; AA3C
        srl a                           ; AA3E
        sub 00bh                        ; AA40
        ld (L8E30),a                    ; AA42
        ld a,(V_JUG_Y)                  ; AA45
        srl a                           ; AA48
        srl a                           ; AA4A
        srl a                           ; AA4C
        sub 00bh                        ; AA4E
        ld (L8E2F),a                    ; AA50
LAA53:
        ld bc,(L8E2F)                   ; AA53
        ld a,b                          ; AA57
        or c                            ; AA58
        jr z,LAA69                      ; AA59
        call SCROLL                     ; AA5B
        call DIBUJA_FONDO               ; AA5E
        call L9398                      ; AA61
        call VUELCA_PANTALLA            ; AA64
        jr LAA53                        ; AA67
LAA69:
        ld a,(ix+003h)                  ; AA69
        ld (L8E41),a                    ; AA6C
        ld e,a                          ; AA6F
        ld d,000h                       ; AA70
        ld hl,L8E63                     ; AA72
        add hl,de                       ; AA75
        ld de,L8E44                     ; AA76
        ldi                             ; AA79
        add a,a                         ; AA7B
        ld e,a                          ; AA7C
        ld d,000h                       ; AA7D
        ld hl,L8E5B                     ; AA7F
        add hl,de                       ; AA82
        ld a,(hl)                       ; AA83
        inc hl                          ; AA84
        ld h,(hl)                       ; AA85
        ld l,a                          ; AA86
        ld c,(ix+004h)                  ; AA87
        ld b,(ix+005h)                  ; AA8A
        ld (L8E31),bc                   ; AA8D
        call LA9C5                      ; AA91
        ld (V_PTR_MAPA),hl              ; AA94
        call LB631                      ; AA97
        call LB63F                      ; AA9A
        jp LA6AB                        ; AA9D
LAAA0:
        ld a,(L8E27)                    ; AAA0
        and a                           ; AAA3
        ret z                           ; AAA4
        ld ix,L8E67                     ; AAA5
        ld b,004h                       ; AAA9
        ld de,00007h                    ; AAAB
LAAAE:
        ld a,(ix+000h)                  ; AAAE
        and a                           ; AAB1
        jr z,LAAB9                      ; AAB2
        add ix,de                       ; AAB4
        djnz LAAAE                      ; AAB6
        ret                             ; AAB8
LAAB9:
        ld a,(L8E27)                    ; AAB9
        cp 001h                         ; AABC
        jr nz,LAAD3                     ; AABE
        ld a,(L8E29)                    ; AAC0
        dec a                           ; AAC3
        daa                             ; AAC4
        ld (L8E29),a                    ; AAC5
        jr nz,LAAD1                     ; AAC8
        xor a                           ; AACA
        ld (L8E27),a                    ; AACB
        call L9D66                      ; AACE
LAAD1:
        ld a,001h                       ; AAD1
LAAD3:
        ld (ix+000h),a                  ; AAD3
        ld a,(V_JUG_X)                  ; AAD6
        add a,004h                      ; AAD9
        ld (ix+001h),a                  ; AADB
        ld a,(V_JUG_Y)                  ; AADE
        add a,004h                      ; AAE1
        ld (ix+002h),a                  ; AAE3
        xor a                           ; AAE6
        ld (ix+003h),a                  ; AAE7
        ld (ix+004h),a                  ; AAEA
        ld (ix+005h),a                  ; AAED
        ld a,(V_JUG_ESTADO)             ; AAF0
        ld (ix+006h),a                  ; AAF3
        and a                           ; AAF6
        jr z,LAB0F                      ; AAF7
        cp 001h                         ; AAF9
        jr z,LAB08                      ; AAFB
        cp 002h                         ; AAFD
        jr z,LAB16                      ; AAFF
        ld a,0f4h                       ; AB01
        ld (ix+004h),a                  ; AB03
        jr LAB1B                        ; AB06
LAB08:
        ld a,00ch                       ; AB08
        ld (ix+004h),a                  ; AB0A
        jr LAB1B                        ; AB0D
LAB0F:
        ld a,0f4h                       ; AB0F
        ld (ix+005h),a                  ; AB11
        jr LAB1B                        ; AB14
LAB16:
        ld a,00ch                       ; AB16
        ld (ix+005h),a                  ; AB18
LAB1B:
        ld d,00ch                       ; AB1B
        ld e,0f4h                       ; AB1D
        ld a,(L8E40)                    ; AB1F
        bit 0,a                         ; AB22
        jr z,LAB29                      ; AB24
        ld (ix+004h),d                  ; AB26
LAB29:
        bit 1,a                         ; AB29
        jr z,LAB30                      ; AB2B
        ld (ix+004h),e                  ; AB2D
LAB30:
        bit 2,a                         ; AB30
        jr z,LAB37                      ; AB32
        ld (ix+005h),d                  ; AB34
LAB37:
        bit 3,a                         ; AB37
        jp z,LAB3F                      ; AB39
        ld (ix+005h),e                  ; AB3C
LAB3F:
        xor a                           ; AB3F
        ld (LA43F),a                    ; AB40
        jp LBA1A                        ; AB43
LAB46:
        ld b,00ch                       ; AB46
        ld ix,L8E67                     ; AB48
LAB4C:
        push bc                         ; AB4C
        ld a,(ix+000h)                  ; AB4D
        and a                           ; AB50
        jr nz,LAB5C                     ; AB51
LAB53:
        ld de,00007h                    ; AB53
        add ix,de                       ; AB56
        pop bc                          ; AB58
        djnz LAB4C                      ; AB59
        ret                             ; AB5B
LAB5C:
        ld a,(ix+001h)                  ; AB5C
        add a,(ix+004h)                 ; AB5F
        ld (ix+001h),a                  ; AB62
        ld c,a                          ; AB65
        ld a,(ix+002h)                  ; AB66
        add a,(ix+005h)                 ; AB69
        ld (ix+002h),a                  ; AB6C
        ld b,a                          ; AB6F
        push bc                         ; AB70
        ld a,(ix+000h)                  ; AB71
        cp 001h                         ; AB74
        call z,LB4F4                    ; AB76
        pop bc                          ; AB79
        push bc                         ; AB7A
        ld de,00101h                    ; AB7B
        call L9A9C                      ; AB7E
        pop bc                          ; AB81
        jr nz,LAB89                     ; AB82
        call LAC0E                      ; AB84
        jr nc,LAB8F                     ; AB87
LAB89:
        ld (ix+000h),000h               ; AB89
        jr LAB53                        ; AB8D
LAB8F:
        ld a,(ix+000h)                  ; AB8F
        cp 001h                         ; AB92
        jr z,LABD6                      ; AB94
        cp 002h                         ; AB96
        jr z,LABA2                      ; AB98
        ld hl,LAC02                     ; AB9A
        ld de,LABF6                     ; AB9D
        jr LABA8                        ; ABA0
LABA2:
        ld hl,LABEA                     ; ABA2
        ld de,LABDE                     ; ABA5
LABA8:
        ld a,(ix+003h)                  ; ABA8
        inc a                           ; ABAB
        cp 003h                         ; ABAC
        jr c,LABB1                      ; ABAE
        xor a                           ; ABB0
LABB1:
        ld (ix+003h),a                  ; ABB1
        bit 0,(ix+006h)                 ; ABB4
        jr z,LABD3                      ; ABB8
LABBA:
        add a,a                         ; ABBA
        add a,a                         ; ABBB
        ld e,a                          ; ABBC
        ld d,000h                       ; ABBD
        add hl,de                       ; ABBF
        ld e,(hl)                       ; ABC0
        inc hl                          ; ABC1
        ld d,(hl)                       ; ABC2
        inc hl                          ; ABC3
        ld a,(hl)                       ; ABC4
        inc hl                          ; ABC5
        ld l,(hl)                       ; ABC6
        ld h,a                          ; ABC7
LABC8:
        ld c,(ix+001h)                  ; ABC8
        ld b,(ix+002h)                  ; ABCB
        call LAC1F                      ; ABCE
        jr LAB53                        ; ABD1
LABD3:
        ex de,hl                        ; ABD3
        jr LABBA                        ; ABD4
LABD6:
        ld de,05ae0h                    ; ABD6
        ld hl,00108h                    ; ABD9
        jr LABC8                        ; ABDC
LABDE:
        db 0F0h,05Ah,002h,010h,030h,05Bh,002h,010h,070h,05Bh,002h,010h; ABDE
LABEA:
        db 0B0h,05Bh,002h,010h,0F0h,05Bh,002h,010h,030h,05Ch,002h,010h; ABEA
LABF6:
        db 070h,05Ch,002h,010h,0B0h,05Ch,002h,010h,0F0h,05Ch,002h,010h; ABF6
LAC02:
        db 030h,05Dh,002h,010h,070h,05Dh,002h,010h,0B0h,05Dh,002h,010h; AC02
LAC0E:
        ld a,0b8h                       ; AC0E
        cp c                            ; AC10
        jr nc,LAC17                     ; AC11
        ld a,c                          ; AC13
        cp 0f9h                         ; AC14
        ret c                           ; AC16
LAC17:
        ld a,0b8h                       ; AC17
        cp b                            ; AC19
        ret nc                          ; AC1A
        ld a,b                          ; AC1B
        cp 0f9h                         ; AC1C
        ret                             ; AC1E
LAC1F:
        ld (L8E2D),bc                   ; AC1F
        call LAD5B                      ; AC23
        push hl                         ; AC26
        push de                         ; AC27
        call L9B74                      ; AC28
        pop de                          ; AC2B
        call LACC2                      ; AC2C
        ld a,(L8E2D)                    ; AC2F
        pop bc                          ; AC32
        and 007h                        ; AC33
        sub 008h                        ; AC35
        cpl                             ; AC37
        add a,a                         ; AC38
        add a,a                         ; AC39
        ld (LAC4F+1),a                  ; AC3A
        ld (LAC88+1),a                  ; AC3D
        push bc                         ; AC40
        exx                             ; AC41
        pop bc                          ; AC42
LAC43:
        push bc                         ; AC43
        ld e,b                          ; AC44
        exx                             ; AC45
        ld a,(L8E51)                    ; AC46
        ld b,a                          ; AC49
        ld c,000h                       ; AC4A
        push hl                         ; AC4C
        push hl                         ; AC4D
LAC4E:
        ld a,(de)                       ; AC4E
LAC4F:
        jr LAC4F                        ; AC4F
        srl a                           ; AC51
        rr c                            ; AC53
        srl a                           ; AC55
        rr c                            ; AC57
        srl a                           ; AC59
        rr c                            ; AC5B
        srl a                           ; AC5D
        rr c                            ; AC5F
        srl a                           ; AC61
        rr c                            ; AC63
        srl a                           ; AC65
        rr c                            ; AC67
        srl a                           ; AC69
        rr c                            ; AC6B
        or b                            ; AC6D
        and (hl)                        ; AC6E
        ld (hl),a                       ; AC6F
        inc hl                          ; AC70
        ld b,c                          ; AC71
        ld c,000h                       ; AC72
        inc de                          ; AC74
        exx                             ; AC75
        dec b                           ; AC76
        exx                             ; AC77
        jr nz,LAC4E                     ; AC78
        ld a,(L8E52)                    ; AC7A
        or b                            ; AC7D
        and (hl)                        ; AC7E
        ld (hl),a                       ; AC7F
        pop hl                          ; AC80
        exx                             ; AC81
        ld b,e                          ; AC82
        exx                             ; AC83
        ld bc,00000h                    ; AC84
LAC87:
        ld a,(de)                       ; AC87
LAC88:
        jr LAC88                        ; AC88
        srl a                           ; AC8A
        rr c                            ; AC8C
        srl a                           ; AC8E
        rr c                            ; AC90
        srl a                           ; AC92
        rr c                            ; AC94
        srl a                           ; AC96
        rr c                            ; AC98
        srl a                           ; AC9A
        rr c                            ; AC9C
        srl a                           ; AC9E
        rr c                            ; ACA0
        srl a                           ; ACA2
        rr c                            ; ACA4
        or b                            ; ACA6
        or (hl)                         ; ACA7
        ld (hl),a                       ; ACA8
        inc hl                          ; ACA9
        ld b,c                          ; ACAA
        ld c,000h                       ; ACAB
        inc de                          ; ACAD
        exx                             ; ACAE
        dec b                           ; ACAF
        exx                             ; ACB0
        jr nz,LAC87                     ; ACB1
        ld a,b                          ; ACB3
        or (hl)                         ; ACB4
        ld (hl),a                       ; ACB5
        ld bc,0001ch                    ; ACB6
        pop hl                          ; ACB9
        add hl,bc                       ; ACBA
        exx                             ; ACBB
        pop bc                          ; ACBC
        dec c                           ; ACBD
        jr nz,LAC43                     ; ACBE
        exx                             ; ACC0
        ret                             ; ACC1
LACC2:
        push bc                         ; ACC2
        ld a,(L8E2D)                    ; ACC3
        cpl                             ; ACC6
        and 007h                        ; ACC7
        ld c,0feh                       ; ACC9
        ld b,a                          ; ACCB
        and a                           ; ACCC
        jr z,LACD3                      ; ACCD
LACCF:
        sla c                           ; ACCF
        djnz LACCF                      ; ACD1
LACD3:
        ld a,c                          ; ACD3
        ld (L8E51),a                    ; ACD4
        cpl                             ; ACD7
        ld (L8E52),a                    ; ACD8
        pop bc                          ; ACDB
        ret                             ; ACDC
LACDD:
        ld ix,L8EBB                     ; ACDD
        call LADB5                      ; ACE1
LACE4:
        ld a,(ix+000h)                  ; ACE4
        and a                           ; ACE7
        jr z,LAD1C                      ; ACE8
        cp 0ffh                         ; ACEA
        ret z                           ; ACEC
        ld a,(L8E41)                    ; ACED
        cp (ix+005h)                    ; ACF0
        jr nz,LAD1C                     ; ACF3
        ld a,(ix+001h)                  ; ACF5
        add a,(ix+003h)                 ; ACF8
        dec a                           ; ACFB
        cp l                            ; ACFC
        jr c,LAD1C                      ; ACFD
        ld a,(ix+001h)                  ; ACFF
        cp c                            ; AD02
        jr nc,LAD1C                     ; AD03
        ld a,(ix+004h)                  ; AD05
        srl a                           ; AD08
        srl a                           ; AD0A
        srl a                           ; AD0C
        add a,(ix+002h)                 ; AD0E
        dec a                           ; AD11
        cp h                            ; AD12
        jr c,LAD1C                      ; AD13
        ld a,(ix+002h)                  ; AD15
        cp b                            ; AD18
        call c,LAD23                    ; AD19
LAD1C:
        ld de,00006h                    ; AD1C
        add ix,de                       ; AD1F
        jr LACE4                        ; AD21
LAD23:
        push bc                         ; AD23
        push hl                         ; AD24
        ld a,(ix+001h)                  ; AD25
        sub l                           ; AD28
        sla a                           ; AD29
        sla a                           ; AD2B
        sla a                           ; AD2D
        ld c,a                          ; AD2F
        ld a,(ix+002h)                  ; AD30
        sub h                           ; AD33
        sla a                           ; AD34
        sla a                           ; AD36
        sla a                           ; AD38
        ld b,a                          ; AD3A
        ld a,(ix+000h)                  ; AD3B
        call LAD4D                      ; AD3E
        ld l,(ix+004h)                  ; AD41
        ld h,(ix+003h)                  ; AD44
        call LAC1F                      ; AD47
        pop hl                          ; AD4A
        pop bc                          ; AD4B
        ret                             ; AD4C
LAD4D:
        add a,a                         ; AD4D
        add a,a                         ; AD4E
        ld hl,LA683                     ; AD4F
        ld e,a                          ; AD52
        ld d,000h                       ; AD53
        add hl,de                       ; AD55
        ld e,(hl)                       ; AD56
        inc hl                          ; AD57
        ld d,(hl)                       ; AD58
        inc hl                          ; AD59
        ret                             ; AD5A
LAD5B:
        ld a,0b8h                       ; AD5B
        cp c                            ; AD5D
        jr nc,LAD66                     ; AD5E
        ld a,c                          ; AD60
        neg                             ; AD61
        add a,0b8h                      ; AD63
        ld c,a                          ; AD65
LAD66:
        ld a,0bfh                       ; AD66
        cp b                            ; AD68
        jr nc,LAD84                     ; AD69
        ld a,b                          ; AD6B
        neg                             ; AD6C
        ld b,a                          ; AD6E
        sub l                           ; AD6F
        neg                             ; AD70
        ld l,a                          ; AD72
        push hl                         ; AD73
        ld l,h                          ; AD74
        sla l                           ; AD75
        xor a                           ; AD77
LAD78:
        add a,l                         ; AD78
        djnz LAD78                      ; AD79
        ld l,a                          ; AD7B
        ld h,000h                       ; AD7C
        add hl,de                       ; AD7E
        ex de,hl                        ; AD7F
        pop hl                          ; AD80
        ld b,000h                       ; AD81
        ret                             ; AD83
LAD84:
        ld a,l                          ; AD84
        add a,b                         ; AD85
        sub 0c0h                        ; AD86
        ret c                           ; AD88
        sub l                           ; AD89
        neg                             ; AD8A
        ld l,a                          ; AD8C
        ret                             ; AD8D
LAD8E:
        ld a,0bfh                       ; AD8E
        cp b                            ; AD90
        jr nc,LADAC                     ; AD91
        ld a,b                          ; AD93
        sub 0bfh                        ; AD94
        ld b,a                          ; AD96
        sub l                           ; AD97
        neg                             ; AD98
        ld l,a                          ; AD9A
        push hl                         ; AD9B
        ld l,h                          ; AD9C
        ld h,000h                       ; AD9D
        sla l                           ; AD9F
        xor a                           ; ADA1
LADA2:
        add a,l                         ; ADA2
        djnz LADA2                      ; ADA3
        ld l,a                          ; ADA5
        add hl,de                       ; ADA6
        ex de,hl                        ; ADA7
        pop hl                          ; ADA8
        ld b,0bfh                       ; ADA9
        ret                             ; ADAB
LADAC:
        ld a,l                          ; ADAC
        dec a                           ; ADAD
        sub b                           ; ADAE
        ret c                           ; ADAF
        sub l                           ; ADB0
        neg                             ; ADB1
        ld l,a                          ; ADB3
        ret                             ; ADB4
LADB5:
        ld a,(L8E31)                    ; ADB5
        dec a                           ; ADB8
        sla a                           ; ADB9
        sla a                           ; ADBB
        ld l,a                          ; ADBD
        ld a,(L8E42)                    ; ADBE
        add a,l                         ; ADC1
        ld l,a                          ; ADC2
        add a,018h                      ; ADC3
        ld c,a                          ; ADC5
        ld a,(L8E32)                    ; ADC6
        dec a                           ; ADC9
        sla a                           ; ADCA
        sla a                           ; ADCC
        ld h,a                          ; ADCE
        ld a,(L8E43)                    ; ADCF
        add a,h                         ; ADD2
        ld h,a                          ; ADD3
        add a,018h                      ; ADD4
        ld b,a                          ; ADD6
        ret                             ; ADD7
LADD8:
        ld hl,L9097                     ; ADD8
        ld b,06ah                       ; ADDB
LADDD:
        res 7,(hl)                      ; ADDD
        inc hl                          ; ADDF
        inc hl                          ; ADE0
        djnz LADDD                      ; ADE1
        ld hl,L8EBB                     ; ADE3
        ld de,L8EBC                     ; ADE6
        ld bc,000efh                    ; ADE9
        ld (hl),000h                    ; ADEC
        ldir                            ; ADEE
        ld a,00fh                       ; ADF0
        ld (0ae91h),a                   ; ADF2
        ld hl,L906F                     ; ADF5
        ld (L8E51),hl                   ; ADF8
        xor a                           ; ADFB
        ld (L8E4D),a                    ; ADFC
        ld hl,L9097                     ; ADFF
        ld (L8E4B),hl                   ; AE02
        ld b,00bh                       ; AE05
        ld ix,L8EBB                     ; AE07
        call LAE82                      ; AE0B
        ld a,003h                       ; AE0E
        ld (0ae91h),a                   ; AE10
        ld b,004h                       ; AE13
        ld a,001h                       ; AE15
        ld (L8E4D),a                    ; AE17
        ld hl,L90B7                     ; AE1A
        ld (L8E4B),hl                   ; AE1D
        call LAE82                      ; AE20
        ld a,001h                       ; AE23
        ld (0ae91h),a                   ; AE25
        ld b,002h                       ; AE28
        ld hl,L90BF                     ; AE2A
        ld (L8E4B),hl                   ; AE2D
        call LAE82                      ; AE30
        ld a,00fh                       ; AE33
        ld (0ae91h),a                   ; AE35
        ld b,007h                       ; AE38
        ld a,002h                       ; AE3A
        ld (L8E4D),a                    ; AE3C
        ld hl,L90C3                     ; AE3F
        ld (L8E4B),hl                   ; AE42
        call LAE82                      ; AE45
        ld a,003h                       ; AE48
        ld (0ae91h),a                   ; AE4A
        ld b,003h                       ; AE4D
        ld hl,L90E1                     ; AE4F
        ld (L8E4B),hl                   ; AE52
        call LAE82                      ; AE55
        ld a,003h                       ; AE58
        ld (0ae91h),a                   ; AE5A
        ld b,004h                       ; AE5D
        ld a,003h                       ; AE5F
        ld (L8E4D),a                    ; AE61
        ld hl,L90E9                     ; AE64
        ld (L8E4B),hl                   ; AE67
        call LAE82                      ; AE6A
        ld a,007h                       ; AE6D
        ld (0ae91h),a                   ; AE6F
        ld b,008h                       ; AE72
        ld hl,L90F1                     ; AE74
        ld (L8E4B),hl                   ; AE77
        call LAE82                      ; AE7A
        ld (L8E55),ix                   ; AE7D
        ret                             ; AE81
LAE82:
        ld hl,(L8E51)                   ; AE82
        ld a,(hl)                       ; AE85
        ld (ix+000h),a                  ; AE86
        inc hl                          ; AE89
        ld (L8E51),hl                   ; AE8A
LAE8D:
        call LAECC                      ; AE8D
        and 00fh                        ; AE90
        add a,a                         ; AE92
        ld hl,(L8E4B)                   ; AE93
        ld e,a                          ; AE96
        ld d,000h                       ; AE97
        add hl,de                       ; AE99
        ld a,(hl)                       ; AE9A
        bit 7,a                         ; AE9B
        jr nz,LAE8D                     ; AE9D
        set 7,(hl)                      ; AE9F
        ld (ix+002h),a                  ; AEA1
        dec hl                          ; AEA4
        ld a,(hl)                       ; AEA5
        ld (ix+001h),a                  ; AEA6
        ld a,(L8E4D)                    ; AEA9
        ld (ix+005h),a                  ; AEAC
        ld a,(ix+000h)                  ; AEAF
        add a,a                         ; AEB2
        add a,a                         ; AEB3
        ld e,a                          ; AEB4
        ld d,000h                       ; AEB5
        ld hl,LA685                     ; AEB7
        add hl,de                       ; AEBA
        ld a,(hl)                       ; AEBB
        ld (ix+003h),a                  ; AEBC
        inc hl                          ; AEBF
        ld a,(hl)                       ; AEC0
        ld (ix+004h),a                  ; AEC1
        ld de,00006h                    ; AEC4
        add ix,de                       ; AEC7
        djnz LAE82                      ; AEC9
        ret                             ; AECB
LAECC:
        push hl                         ; AECC
        ld hl,(V_SEMILLA)               ; AECD
        ld a,h                          ; AED0
        and 01fh                        ; AED1
        ld h,a                          ; AED3
        ld a,000h                       ; AED4
        xor (hl)                        ; AED6
        inc hl                          ; AED7
        xor (hl)                        ; AED8
        inc hl                          ; AED9
        add a,h                         ; AEDA
        sub l                           ; AEDB
        ld (V_SEMILLA),hl               ; AEDC
        pop hl                          ; AEDF
        ret                             ; AEE0
LAEE1:
        call LB9CF                      ; AEE1
        ld ix,L8EBB                     ; AEE4
LAEE8:
        ld a,(ix+000h)                  ; AEE8
        and a                           ; AEEB
        jr z,LAF09                      ; AEEC
        cp 0ffh                         ; AEEE
        ret z                           ; AEF0
        ld a,(L8E41)                    ; AEF1
        cp (ix+005h)                    ; AEF4
        jr nz,LAF09                     ; AEF7
        ld a,(ix+001h)                  ; AEF9
        res 0,a                         ; AEFC
        cp l                            ; AEFE
        jr nz,LAF09                     ; AEFF
        ld a,(ix+002h)                  ; AF01
        res 0,a                         ; AF04
        cp h                            ; AF06
        jr z,LAF10                      ; AF07
LAF09:
        ld de,00006h                    ; AF09
        add ix,de                       ; AF0C
        jr LAEE8                        ; AF0E
LAF10:
        ld a,(ix+000h)                  ; AF10
        cp 007h                         ; AF13
        jr z,LAF73                      ; AF15
        ld hl,LA43F                     ; AF17
        ld (hl),004h                    ; AF1A
        cp 008h                         ; AF1C
        jr z,LAF9D                      ; AF1E
        cp 009h                         ; AF20
        jp z,LAFAB                      ; AF22
        cp 006h                         ; AF25
        jr z,LAF69                      ; AF27
        cp 004h                         ; AF29
        ld (ix+000h),000h               ; AF2B
        jr nc,LAF59                     ; AF2F
        ld (L8E27),a                    ; AF31
        cp 001h                         ; AF34
        jp nz,LAF4D                     ; AF36
        ld a,030h                       ; AF39
        ld (L8E29),a                    ; AF3B
        call LBA1A                      ; AF3E
        ld a,(L8E3E)                    ; AF41
        inc a                           ; AF44
        ld (L8E3E),a                    ; AF45
        ld a,001h                       ; AF48
        jp LB784                        ; AF4A
LAF4D:
        xor a                           ; AF4D
        ld (L8E29),a                    ; AF4E
        call LBA1A                      ; AF51
        ld a,002h                       ; AF54
        jp LB784                        ; AF56
LAF59:
        jr nz,LAF63                     ; AF59
        ld a,0c0h                       ; AF5B
        ld (L8E25),a                    ; AF5D
        jp L9DDD                        ; AF60
LAF63:
        ld a,014h                       ; AF63
        ld (L8E28),a                    ; AF65
        ret                             ; AF68
LAF69:
        ld a,0ffh                       ; AF69
        ld (L8E58),a                    ; AF6B
        ld (ix+000h),000h               ; AF6E
        ret                             ; AF72
LAF73:
        ld a,(V_VIDAS)                  ; AF73
        inc a                           ; AF76
        ld (V_VIDAS),a                  ; AF77
        ld (ix+000h),000h               ; AF7A
        ld de,LBAFE                     ; AF7E
        cp 002h                         ; AF81
        jr z,LAF8F                      ; AF83
        ld de,LBB7E                     ; AF85
        cp 001h                         ; AF88
        jr z,LAF8F                      ; AF8A
        ld de,LBA7E                     ; AF8C
LAF8F:
        ld hl,04690h                    ; AF8F
        ld bc,02004h                    ; AF92
        ld a,003h                       ; AF95
        ld (LA43F),a                    ; AF97
        jp L9D71                        ; AF9A
LAF9D:
        ld a,064h                       ; AF9D
        ld (L8E3C),a                    ; AF9F
        ld (ix+000h),000h               ; AFA2
        ld a,008h                       ; AFA6
        jp LB78B                        ; AFA8
LAFAB:
        call DIBUJA_FONDO               ; AFAB
        call MUEVE_ENEMIGOS             ; AFAE
        call LAB46                      ; AFB1
        call L9398                      ; AFB4
        call VUELCA_PANTALLA            ; AFB7
        call MUSICA_PARA                ; AFBA
        call LB002                      ; AFBD
        call L9F4C                      ; AFC0
        ld hl,04000h                    ; AFC3
        ld de,003e8h                    ; AFC6
        ld bc,01800h                    ; AFC9
        call LA51B                      ; AFCC
        ld de,LA369                     ; AFCF
        ld hl,04800h                    ; AFD2
        call L9F8D                      ; AFD5
        call LB002                      ; AFD8
        call L9F4C                      ; AFDB
        call LA4C8                      ; AFDE
        ld de,LA358                     ; AFE1
        ld hl,05238h                    ; AFE4
        call L9F8D                      ; AFE7
        call ESPERA_SUELTA              ; AFEA
        call ESPERA_TECLA               ; AFED
        call L9F4C                      ; AFF0
        ld hl,003e8h                    ; AFF3
        ld de,04000h                    ; AFF6
        ld bc,01800h                    ; AFF9
        call LA528                      ; AFFC
        jp NUEVA_PARTIDA                ; AFFF
LB002:
        ld b,00ah                       ; B002
LB004:
        push bc                         ; B004
        call L9DFD                      ; B005
        pop bc                          ; B008
        djnz LB004                      ; B009
        ret                             ; B00B

; CÓDIGO MUERTO: recupera la pila del BASIC (guardada en INICIO) y vuelve
VUELTA_BASIC_SIN_USAR:
        di                              ; B00C
        ld sp,(V_SP_BASIC)              ; B00D
        ret                             ; B011
LB012:
        ld hl,LC1CB                     ; B012
        ld (hl),02fh                    ; B015
        ld ix,L9100                     ; B017
        ld hl,L9179                     ; B01B
LB01E:
        ld a,(ix+000h)                  ; B01E
        cp 0ffh                         ; B021
        ret z                           ; B023
        ld e,a                          ; B024
        ld d,000h                       ; B025
        push hl                         ; B027
        ld hl,L8E63                     ; B028
        add hl,de                       ; B02B
        ld a,(hl)                       ; B02C
        ld (L8E44),a                    ; B02D
        sla e                           ; B030
        ld d,000h                       ; B032
        ld hl,L8E5B                     ; B034
        add hl,de                       ; B037
        ld a,(hl)                       ; B038
        inc hl                          ; B039
        ld h,(hl)                       ; B03A
        ld l,a                          ; B03B
        ld c,(ix+001h)                  ; B03C
        ld b,(ix+002h)                  ; B03F
        call LA9C5                      ; B042
        inc hl                          ; B045
        ld (hl),023h                    ; B046
        pop hl                          ; B048
        ld a,(hl)                       ; B049
        ld (ix+003h),a                  ; B04A
        inc hl                          ; B04D
        ld a,(hl)                       ; B04E
        ld (ix+004h),a                  ; B04F
        inc hl                          ; B052
        ld a,(hl)                       ; B053
        ld (ix+005h),a                  ; B054
        inc hl                          ; B057
        ld de,00006h                    ; B058
        add ix,de                       ; B05B
        jr LB01E                        ; B05D
LB05F:
        ld a,(V_JUG_X)                  ; B05F
        srl a                           ; B062
        srl a                           ; B064
        srl a                           ; B066
        inc a                           ; B068
        ld c,a                          ; B069
        ld a,(L8E42)                    ; B06A
        add a,c                         ; B06D
        ld c,a                          ; B06E
        and 003h                        ; B06F
        cp 001h                         ; B071
        jr z,LB078                      ; B073
        cp 002h                         ; B075
        ret nz                          ; B077
LB078:
        srl c                           ; B078
        srl c                           ; B07A
        ld a,(L8E31)                    ; B07C
        add a,c                         ; B07F
        ld c,a                          ; B080
        ld a,(V_JUG_Y)                  ; B081
        srl a                           ; B084
        srl a                           ; B086
        srl a                           ; B088
        inc a                           ; B08A
        ld b,a                          ; B08B
        ld a,(L8E43)                    ; B08C
        add a,b                         ; B08F
        ld b,a                          ; B090
        and 003h                        ; B091
        cp 001h                         ; B093
        jr z,LB09A                      ; B095
        cp 002h                         ; B097
        ret nz                          ; B099
LB09A:
        srl b                           ; B09A
        srl b                           ; B09C
        ld a,(L8E32)                    ; B09E
        add a,b                         ; B0A1
        ld b,a                          ; B0A2
        ld ix,L9100                     ; B0A3
LB0A7:
        ld a,(ix+000h)                  ; B0A7
        cp 0ffh                         ; B0AA
        ret z                           ; B0AC
        ld a,(L8E41)                    ; B0AD
        cp (ix+000h)                    ; B0B0
        jr nz,LB110                     ; B0B3
        ld a,(ix+001h)                  ; B0B5
        cp c                            ; B0B8
        jp nz,LB110                     ; B0B9
        ld a,(ix+002h)                  ; B0BC
        cp b                            ; B0BF
        jr nz,LB110                     ; B0C0
        ld a,(ix+003h)                  ; B0C2
        and a                           ; B0C5
        jr z,LB0ED                      ; B0C6
        dec a                           ; B0C8
        ld (ix+003h),a                  ; B0C9
        and a                           ; B0CC
        ret nz                          ; B0CD
        ld a,021h                       ; B0CE
LB0D0:
        ex af,af'                       ; B0D0
        ld a,(L8E41)                    ; B0D1
        add a,a                         ; B0D4
        ld e,a                          ; B0D5
        ld d,000h                       ; B0D6
        ld hl,L8E5B                     ; B0D8
        add hl,de                       ; B0DB
        ld a,(hl)                       ; B0DC
        inc hl                          ; B0DD
        ld h,(hl)                       ; B0DE
        ld l,a                          ; B0DF
        ld c,(ix+001h)                  ; B0E0
        ld b,(ix+002h)                  ; B0E3
        call LA9C5                      ; B0E6
        inc hl                          ; B0E9
        ex af,af'                       ; B0EA
        ld (hl),a                       ; B0EB
        ret                             ; B0EC
LB0ED:
        ld a,(ix+004h)                  ; B0ED
        and a                           ; B0F0
        jr z,LB0FD                      ; B0F1
        dec a                           ; B0F3
        ld (ix+004h),a                  ; B0F4
        and a                           ; B0F7
        ret nz                          ; B0F8
        ld a,026h                       ; B0F9
        jr LB0D0                        ; B0FB
LB0FD:
        ld a,(ix+005h)                  ; B0FD
        and a                           ; B100
        jr z,LB117                      ; B101
        dec a                           ; B103
        ld (ix+005h),a                  ; B104
        and a                           ; B107
        ret nz                          ; B108
        call LB117                      ; B109
        ld a,025h                       ; B10C
        jr LB0D0                        ; B10E
LB110:
        ld de,00006h                    ; B110
        add ix,de                       ; B113
        jr LB0A7                        ; B115
LB117:
        ld a,(L8E38)                    ; B117
        and a                           ; B11A
        ret nz                          ; B11B
        ld (L8E39),a                    ; B11C
        ld a,00ah                       ; B11F
        ld (L8E38),a                    ; B121
        ld a,(V_JUG_X)                  ; B124
        and 0f8h                        ; B127
        ld (V_JUG_X),a                  ; B129
        ld a,(V_JUG_Y)                  ; B12C
        and 0f8h                        ; B12F
        ld (V_JUG_Y),a                  ; B131
        ld hl,L9669                     ; B134
        ld (L8E3A),hl                   ; B137
        ld a,001h                       ; B13A
        ld (LA43F),a                    ; B13C
        ret                             ; B13F
LB140:
        ld a,030h                       ; B140
        cp c                            ; B142
        jr nc,LB14A                     ; B143
        ld a,c                          ; B145
        cp 0e8h                         ; B146
        jr c,LB152                      ; B148
LB14A:
        ld a,030h                       ; B14A
        cp b                            ; B14C
        ret nc                          ; B14D
        ld a,b                          ; B14E
        cp 0e8h                         ; B14F
        ret nc                          ; B151
LB152:
        ld (ix+000h),000h               ; B152
        ld a,(L8E37)                    ; B156
        inc a                           ; B159
        ld (L8E37),a                    ; B15A
        ret                             ; B15D
LB15E:
        ld b,009h                       ; B15E
        ld ix,TABLA_ENEMIGOS            ; B160
LB164:
        push bc                         ; B164
LB165:
        ld a,(ix+000h)                  ; B165
        and a                           ; B168
        jr z,LB174                      ; B169
LB16B:
        ld de,00007h                    ; B16B
        add ix,de                       ; B16E
        pop bc                          ; B170
        djnz LB164                      ; B171
        ret                             ; B173
LB174:
        ld a,(L8E37)                    ; B174
        and a                           ; B177
        jr nz,LB17C                     ; B178
        pop bc                          ; B17A
        ret                             ; B17B
LB17C:
        dec a                           ; B17C
        ld (L8E37),a                    ; B17D
        ex af,af'                       ; B180
        ld a,b                          ; B181
        ex af,af'                       ; B182
        call LAECC                      ; B183
        bit 0,a                         ; B186
        jr z,LB19E                      ; B188
        bit 1,a                         ; B18A
        jr z,LB19A                      ; B18C
        ld b,0f6h                       ; B18E
LB190:
        call LAECC                      ; B190
        and 03fh                        ; B193
        sub 014h                        ; B195
        ld c,a                          ; B197
        jr LB1B2                        ; B198
LB19A:
        ld b,022h                       ; B19A
        jr LB190                        ; B19C
LB19E:
        bit 1,a                         ; B19E
        jr z,LB1AE                      ; B1A0
        ld c,022h                       ; B1A2
LB1A4:
        call LAECC                      ; B1A4
        and 03fh                        ; B1A7
        sub 014h                        ; B1A9
        ld b,a                          ; B1AB
        jr LB1B2                        ; B1AC
LB1AE:
        ld c,0f6h                       ; B1AE
        jr LB1A4                        ; B1B0
LB1B2:
        call LB480                      ; B1B2
        jr nc,LB165                     ; B1B5
        ld (ix+001h),c                  ; B1B7
        ld (ix+002h),b                  ; B1BA
        call LAECC                      ; B1BD
        and 001h                        ; B1C0
        inc a                           ; B1C2
        ld (ix+000h),a                  ; B1C3
        ld (ix+003h),000h               ; B1C6
        ld (ix+005h),000h               ; B1CA
        call LB1D3                      ; B1CE
        jr LB16B                        ; B1D1
LB1D3:
        ld b,(ix+002h)                  ; B1D3
        ld a,018h                       ; B1D6
        add a,b                         ; B1D8
        ld b,a                          ; B1D9
        ld a,(V_JUG_Y)                  ; B1DA
        srl a                           ; B1DD
        srl a                           ; B1DF
        srl a                           ; B1E1
        add a,018h                      ; B1E3
        ld e,a                          ; B1E5
        ld c,(ix+001h)                  ; B1E6
        ld a,018h                       ; B1E9
        add a,c                         ; B1EB
        ld c,a                          ; B1EC
        ld a,(V_JUG_X)                  ; B1ED
        srl a                           ; B1F0
        srl a                           ; B1F2
        srl a                           ; B1F4
        add a,018h                      ; B1F6
        cp c                            ; B1F8
        ld a,e                          ; B1F9
        jr z,LB218                      ; B1FA
        jr c,LB20B                      ; B1FC
        cp b                            ; B1FE
        ld a,001h                       ; B1FF
        jr z,LB224                      ; B201
        ld a,004h                       ; B203
        jr c,LB224                      ; B205
        ld a,005h                       ; B207
        jr LB224                        ; B209
LB20B:
        cp b                            ; B20B
        ld a,003h                       ; B20C
        jr z,LB224                      ; B20E
        ld a,007h                       ; B210
        jr c,LB224                      ; B212
        ld a,006h                       ; B214
        jr LB224                        ; B216
LB218:
        cp b                            ; B218
        ld a,(ix+004h)                  ; B219
        jr z,LB224                      ; B21C
        ld a,000h                       ; B21E
        jr c,LB224                      ; B220
        ld a,002h                       ; B222
LB224:
        ld (ix+004h),a                  ; B224
        ret                             ; B227
MUEVE_ENEMIGOS:
        ld ix,TABLA_ENEMIGOS            ; B228
        ld a,009h                       ; B22C
LB22E:
        ex af,af'                       ; B22E
        ld a,(ix+000h)                  ; B22F
        cp 001h                         ; B232
        jr z,LB249                      ; B234
        cp 002h                         ; B236
        jp z,LB35A                      ; B238
        and a                           ; B23B
        jp nz,LB3D5                     ; B23C
LB23F:
        ld de,00007h                    ; B23F
        add ix,de                       ; B242
        ex af,af'                       ; B244
        dec a                           ; B245
        jr nz,LB22E                     ; B246
        ret                             ; B248
LB249:
        ld a,080h                       ; B249
        ld (L8E4C),a                    ; B24B
        ld a,020h                       ; B24E
        ld (L8E4D),a                    ; B250
        ld a,(ix+006h)                  ; B253
        dec a                           ; B256
        and 03fh                        ; B257
        ld (ix+006h),a                  ; B259
        push af                         ; B25C
        call z,LB1D3                    ; B25D
        pop af                          ; B260
        jr nz,LB26B                     ; B261
        call LAECC                      ; B263
        and 03fh                        ; B266
        ld (ix+006h),a                  ; B268
LB26B:
        ld a,003h                       ; B26B
        ld hl,LB410                     ; B26D
LB270:
        push hl                         ; B270
        push af                         ; B271
        ld c,(ix+001h)                  ; B272
        ld b,(ix+002h)                  ; B275
        call LB454                      ; B278
        jr c,LB286                      ; B27B
        ld (ix+000h),000h               ; B27D
        pop af                          ; B281
        pop hl                          ; B282
        jp LB23F                        ; B283
LB286:
        ld hl,L8E4C                     ; B286
        ld a,(ix+003h)                  ; B289
        ld (L8E4B),a                    ; B28C
        ld a,(ix+004h)                  ; B28F
        cp 000h                         ; B292
        jr nz,LB29B                     ; B294
        call LB37B                      ; B296
        jr LB2E0                        ; B299
LB29B:
        cp 001h                         ; B29B
        jr nz,LB2A4                     ; B29D
        call LB392                      ; B29F
        jr LB2E0                        ; B2A2
LB2A4:
        cp 002h                         ; B2A4
        jr nz,LB2AD                     ; B2A6
        call LB3A8                      ; B2A8
        jr LB2E0                        ; B2AB
LB2AD:
        cp 003h                         ; B2AD
        jr nz,LB2B6                     ; B2AF
        call LB3BF                      ; B2B1
        jr LB2E0                        ; B2B4
LB2B6:
        cp 004h                         ; B2B6
        jr nz,LB2C2                     ; B2B8
        call LB392                      ; B2BA
        call LB37B                      ; B2BD
        jr LB2E0                        ; B2C0
LB2C2:
        cp 005h                         ; B2C2
        jr nz,LB2CE                     ; B2C4
        call LB392                      ; B2C6
        call LB3A8                      ; B2C9
        jr LB2E0                        ; B2CC
LB2CE:
        cp 006h                         ; B2CE
        jr nz,LB2DA                     ; B2D0
        call LB3BF                      ; B2D2
        call LB3A8                      ; B2D5
        jr LB2E0                        ; B2D8
LB2DA:
        call LB3BF                      ; B2DA
        call LB37B                      ; B2DD
LB2E0:
        ld a,(ix+005h)                  ; B2E0
        inc a                           ; B2E3
        pop hl                          ; B2E4
        and h                           ; B2E5
        ld (ix+005h),a                  ; B2E6
        call z,LB79E                    ; B2E9
        pop hl                          ; B2EC
        call LB140                      ; B2ED
        jp c,LB23F                      ; B2F0
        push hl                         ; B2F3
        call LB450                      ; B2F4
        pop hl                          ; B2F7
        ld a,(ix+003h)                  ; B2F8
        jr c,LB314                      ; B2FB
        ld a,014h                       ; B2FD
        ld (ix+006h),a                  ; B2FF
        ld a,r                          ; B302
        and 007h                        ; B304
        ld (ix+004h),a                  ; B306
        ld c,(ix+001h)                  ; B309
        ld b,(ix+002h)                  ; B30C
        ld a,(L8E4B)                    ; B30F
        jr LB326                        ; B312
LB314:
        ld (ix+001h),c                  ; B314
        ld (ix+002h),b                  ; B317
        and 003h                        ; B31A
        inc a                           ; B31C
        and 003h                        ; B31D
        ld e,a                          ; B31F
        ld a,(ix+003h)                  ; B320
        and 0fch                        ; B323
        or e                            ; B325
LB326:
        ld (ix+003h),a                  ; B326
        and 003h                        ; B329
        ld (L8E4B),a                    ; B32B
        ld a,c                          ; B32E
        cp 0feh                         ; B32F
        cp 017h                         ; B331
        jp nc,LB23F                     ; B333
        ld a,b                          ; B336
        cp 017h                         ; B337
        jp nc,LB23F                     ; B339
        ld a,(ix+003h)                  ; B33C
        rlca                            ; B33F
        rl c                            ; B340
        rlca                            ; B342
        rl c                            ; B343
        sla c                           ; B345
        rlca                            ; B347
        rl b                            ; B348
        rlca                            ; B34A
        rl b                            ; B34B
        sla b                           ; B34D
        ld a,(ix+004h)                  ; B34F
        and 003h                        ; B352
        call L968F                      ; B354
        jp LB23F                        ; B357
LB35A:
        ld a,040h                       ; B35A
        ld (L8E4C),a                    ; B35C
        ld a,010h                       ; B35F
        ld (L8E4D),a                    ; B361
        ld a,(ix+006h)                  ; B364
        and a                           ; B367
        jr z,LB370                      ; B368
        dec a                           ; B36A
        ld (ix+006h),a                  ; B36B
        jr LB373                        ; B36E
LB370:
        call LB1D3                      ; B370
LB373:
        ld a,007h                       ; B373
        ld hl,LB430                     ; B375
        jp LB270                        ; B378
LB37B:
        ld a,(ix+003h)                  ; B37B
        and 030h                        ; B37E
        jr nz,LB383                     ; B380
        dec b                           ; B382
LB383:
        inc hl                          ; B383
        sub (hl)                        ; B384
        and 030h                        ; B385
        ld e,a                          ; B387
        ld a,(ix+003h)                  ; B388
        and 0cfh                        ; B38B
        or e                            ; B38D
        ld (ix+003h),a                  ; B38E
        ret                             ; B391
LB392:
        ld a,(ix+003h)                  ; B392
        and 0c0h                        ; B395
        add a,(hl)                      ; B397
        and 0c0h                        ; B398
        ld e,a                          ; B39A
        jr nz,LB39E                     ; B39B
        inc c                           ; B39D
LB39E:
        ld a,(ix+003h)                  ; B39E
        and 03fh                        ; B3A1
        or e                            ; B3A3
        ld (ix+003h),a                  ; B3A4
        ret                             ; B3A7
LB3A8:
        ld a,(ix+003h)                  ; B3A8
        and 030h                        ; B3AB
        inc hl                          ; B3AD
        add a,(hl)                      ; B3AE
        and 030h                        ; B3AF
        ld e,a                          ; B3B1
        jr nz,LB3B5                     ; B3B2
        inc b                           ; B3B4
LB3B5:
        ld a,(ix+003h)                  ; B3B5
        and 0cfh                        ; B3B8
        or e                            ; B3BA
        ld (ix+003h),a                  ; B3BB
        ret                             ; B3BE
LB3BF:
        ld a,(ix+003h)                  ; B3BF
        and 0c0h                        ; B3C2
        jr nz,LB3C7                     ; B3C4
        dec c                           ; B3C6
LB3C7:
        sub (hl)                        ; B3C7
        and 0c0h                        ; B3C8
        ld e,a                          ; B3CA
        ld a,(ix+003h)                  ; B3CB
        and 03fh                        ; B3CE
        or e                            ; B3D0
        ld (ix+003h),a                  ; B3D1
        ret                             ; B3D4
LB3D5:
        and 0f0h                        ; B3D5
        sub 010h                        ; B3D7
        jr nz,LB3E2                     ; B3D9
        ld (ix+000h),000h               ; B3DB
        jp LB23F                        ; B3DF
LB3E2:
        ld c,a                          ; B3E2
        ld a,(ix+000h)                  ; B3E3
        and 00fh                        ; B3E6
        or c                            ; B3E8
        ld (ix+000h),a                  ; B3E9
        bit 4,a                         ; B3EC
        jp z,LB23F                      ; B3EE
        and 00fh                        ; B3F1
        ld hl,LB410                     ; B3F3
        cp 001h                         ; B3F6
        jr z,LB3FD                      ; B3F8
        ld hl,LB430                     ; B3FA
LB3FD:
        ld c,(ix+001h)                  ; B3FD
        ld b,(ix+002h)                  ; B400
        ld a,(ix+003h)                  ; B403
        ld (L8E4B),a                    ; B406
        ld a,0ffh                       ; B409
        push hl                         ; B40B
        push af                         ; B40C
        jp LB2E0                        ; B40D
LB410:
        db 018h,0B4h,020h,0B4h,018h,0B4h,028h,0B4h,028h,050h,0B8h,050h,048h,051h,0B8h,050h; B410
        db 0D8h,051h,068h,052h,0F8h,052h,068h,052h,088h,053h,018h,054h,0A8h,054h,018h,054h; B420
LB430:
        db 038h,0B4h,040h,0B4h,038h,0B4h,048h,0B4h,018h,04Bh,0A8h,04Bh,038h,04Ch,0A8h,04Bh; B430
        db 0C8h,04Ch,058h,04Dh,0E8h                        ; B440
        db "MXMxN"                                      ; B445
        db 008h,04Fh,098h,04Fh,008h,04Fh                   ; B44A
LB450:
        call LB480                      ; B450
        ret nc                          ; B453
LB454:
        ld a,017h                       ; B454
        cp c                            ; B456
        ret c                           ; B457
        ld a,015h                       ; B458
        cp b                            ; B45A
        jr c,LB46C                      ; B45B
        ld e,003h                       ; B45D
LB45F:
        ld d,003h                       ; B45F
        push bc                         ; B461
        call L9AA8                      ; B462
        pop bc                          ; B465
        jr nz,LB46A                     ; B466
        scf                             ; B468
        ret                             ; B469
LB46A:
        xor a                           ; B46A
        ret                             ; B46B
LB46C:
        ld a,017h                       ; B46C
        cp b                            ; B46E
        jr c,LB477                      ; B46F
        ld a,018h                       ; B471
        sub b                           ; B473
        ld e,a                          ; B474
        jr LB45F                        ; B475
LB477:
        ld a,b                          ; B477
        cp 0feh                         ; B478
        ret c                           ; B47A
        add a,003h                      ; B47B
        ld e,a                          ; B47D
        jr LB45F                        ; B47E
LB480:
        push iy                         ; B480
        push bc                         ; B482
        ld a,c                          ; B483
        and 0fch                        ; B484
        ld c,a                          ; B486
        ld a,b                          ; B487
        and 0fch                        ; B488
        ld b,a                          ; B48A
        ld l,009h                       ; B48B
        ld iy,TABLA_ENEMIGOS            ; B48D
        ld de,00007h                    ; B491
        ex af,af'                       ; B494
        ld h,a                          ; B495
        ex af,af'                       ; B496
LB497:
        ld a,l                          ; B497
        cp h                            ; B498
        jr z,LB4AB                      ; B499
        ld a,(iy+001h)                  ; B49B
        and 0fch                        ; B49E
        cp c                            ; B4A0
        jr nz,LB4AB                     ; B4A1
        ld a,(iy+002h)                  ; B4A3
        and 0fch                        ; B4A6
        cp b                            ; B4A8
        jr z,LB4B5                      ; B4A9
LB4AB:
        add iy,de                       ; B4AB
        dec l                           ; B4AD
        jr nz,LB497                     ; B4AE
        pop bc                          ; B4B0
        pop iy                          ; B4B1
        scf                             ; B4B3
        ret                             ; B4B4
LB4B5:
        pop bc                          ; B4B5
        pop iy                          ; B4B6
        xor a                           ; B4B8
        ret                             ; B4B9
LB4BA:
        ld hl,L9207                     ; B4BA
        ld b,009h                       ; B4BD
LB4BF:
        res 7,(hl)                      ; B4BF
        inc hl                          ; B4C1
        djnz LB4BF                      ; B4C2
        ld ix,L91B5                     ; B4C4
        ld b,009h                       ; B4C8
        ld d,000h                       ; B4CA
LB4CC:
        res 7,(ix+002h)                 ; B4CC
        call LAECC                      ; B4D0
LB4D3:
        and 00fh                        ; B4D3
        cp 009h                         ; B4D5
        jr c,LB4DB                      ; B4D7
        sub 007h                        ; B4D9
LB4DB:
        ld e,a                          ; B4DB
        ld hl,L9207                     ; B4DC
        add hl,de                       ; B4DF
        ld c,(hl)                       ; B4E0
        bit 7,c                         ; B4E1
        jr z,LB4E8                      ; B4E3
        dec a                           ; B4E5
        jr LB4D3                        ; B4E6
LB4E8:
        ld (ix+003h),c                  ; B4E8
        set 7,(hl)                      ; B4EB
        ld e,006h                       ; B4ED
        add ix,de                       ; B4EF
        djnz LB4CC                      ; B4F1
        ret                             ; B4F3
LB4F4:
        call LADB5                      ; B4F4
        ld a,l                          ; B4F7
        ld (L8E4B),a                    ; B4F8
        ld a,h                          ; B4FB
        ld (L8E4C),a                    ; B4FC
        ld c,(ix+001h)                  ; B4FF
        ld b,(ix+002h)                  ; B502
        srl c                           ; B505
        srl c                           ; B507
        srl c                           ; B509
        srl b                           ; B50B
        srl b                           ; B50D
        srl b                           ; B50F
        ld a,(L8E4B)                    ; B511
        add a,c                         ; B514
        and 0fch                        ; B515
        ld c,a                          ; B517
        ld a,(L8E4C)                    ; B518
        add a,b                         ; B51B
        and 0fch                        ; B51C
        ld b,a                          ; B51E
        ld hl,L91B5                     ; B51F
        ld a,009h                       ; B522
LB524:
        ex af,af'                       ; B524
        ld a,(L8E41)                    ; B525
        cp (hl)                         ; B528
        jr nz,LB59E                     ; B529
        inc hl                          ; B52B
        ld a,(hl)                       ; B52C
        cp c                            ; B52D
        jr nz,LB59F                     ; B52E
        inc hl                          ; B530
        ld a,(hl)                       ; B531
        cp b                            ; B532
        jr nz,LB5A0                     ; B533
        push bc                         ; B535
        call LB5AA                      ; B536
        pop bc                          ; B539
        ret z                           ; B53A
        ld (ix+000h),000h               ; B53B
        set 7,(hl)                      ; B53F
        inc hl                          ; B541
LB542:
        srl c                           ; B542
        srl c                           ; B544
        srl b                           ; B546
        srl b                           ; B548
        inc b                           ; B54A
        inc c                           ; B54B
        ld a,(L8E41)                    ; B54C
        add a,a                         ; B54F
        ld e,a                          ; B550
        ld d,000h                       ; B551
        push hl                         ; B553
        ld hl,L8E5B                     ; B554
        add hl,de                       ; B557
        ld a,(hl)                       ; B558
        inc hl                          ; B559
        ld h,(hl)                       ; B55A
        ld l,a                          ; B55B
        push hl                         ; B55C
        push bc                         ; B55D
        call LA9C5                      ; B55E
        inc hl                          ; B561
        ld (hl),01bh                    ; B562
        pop bc                          ; B564
        pop hl                          ; B565
        dec b                           ; B566
        call LA9C5                      ; B567
        inc hl                          ; B56A
        ld (hl),01ch                    ; B56B
        pop hl                          ; B56D
        ld a,(hl)                       ; B56E
        push af                         ; B56F
        ld de,(L8E55)                   ; B570
        ld bc,00003h                    ; B574
        ldir                            ; B577
        pop af                          ; B579
        add a,a                         ; B57A
        add a,a                         ; B57B
        ld hl,LA685                     ; B57C
        ld c,a                          ; B57F
        ld b,000h                       ; B580
        add hl,bc                       ; B582
        ldi                             ; B583
        ldi                             ; B585
        ld a,(L8E41)                    ; B587
        ld (de),a                       ; B58A
        inc de                          ; B58B
        ld (L8E55),de                   ; B58C
        ld a,(L8E3D)                    ; B590
        inc a                           ; B593
        ld (L8E3D),a                    ; B594
        ld a,007h                       ; B597
        ld (LA43F),a                    ; B599
        ex af,af'                       ; B59C
        ret                             ; B59D
LB59E:
        inc hl                          ; B59E
LB59F:
        inc hl                          ; B59F
LB5A0:
        ld de,00004h                    ; B5A0
        add hl,de                       ; B5A3
        ex af,af'                       ; B5A4
        dec a                           ; B5A5
        jp nz,LB524                     ; B5A6
        ret                             ; B5A9
LB5AA:
        ld bc,(V_JUG_X)                 ; B5AA
        srl c                           ; B5AE
        srl c                           ; B5B0
        srl c                           ; B5B2
        srl b                           ; B5B4
        srl b                           ; B5B6
        srl b                           ; B5B8
        ld a,(L8E4B)                    ; B5BA
        add a,c                         ; B5BD
        and 0fch                        ; B5BE
        ld c,a                          ; B5C0
        ld a,(L8E4C)                    ; B5C1
        add a,b                         ; B5C4
        add a,004h                      ; B5C5
        and 0fch                        ; B5C7
        ld b,a                          ; B5C9
        ld a,(hl)                       ; B5CA
        cp b                            ; B5CB
        ret nz                          ; B5CC
        dec hl                          ; B5CD
        ld a,(hl)                       ; B5CE
        inc hl                          ; B5CF
        cp c                            ; B5D0
        ret                             ; B5D1
LB5D2:
        ld hl,L91B7                     ; B5D2
        ld b,00ah                       ; B5D5
        ld de,00006h                    ; B5D7
LB5DA:
        res 7,(hl)                      ; B5DA
        add hl,de                       ; B5DC
        djnz LB5DA                      ; B5DD
        ld de,L91F3                     ; B5DF
        ld b,00ah                       ; B5E2
        ld ix,L91B5                     ; B5E4
LB5E8:
        push bc                         ; B5E8
        ld a,(ix+000h)                  ; B5E9
        ld c,a                          ; B5EC
        ld b,000h                       ; B5ED
        ld hl,L8E63                     ; B5EF
        add hl,bc                       ; B5F2
        ld a,(hl)                       ; B5F3
        ld (L8E44),a                    ; B5F4
        sla c                           ; B5F7
        ld hl,L8E5B                     ; B5F9
        add hl,bc                       ; B5FC
        ld a,(hl)                       ; B5FD
        inc hl                          ; B5FE
        ld h,(hl)                       ; B5FF
        ld l,a                          ; B600
        push hl                         ; B601
        push de                         ; B602
        ld c,(ix+001h)                  ; B603
        ld b,(ix+002h)                  ; B606
        srl c                           ; B609
        srl c                           ; B60B
        srl b                           ; B60D
        srl b                           ; B60F
        inc b                           ; B611
        inc c                           ; B612
        push bc                         ; B613
        call LA9C5                      ; B614
        pop bc                          ; B617
        pop de                          ; B618
        ld a,(de)                       ; B619
        inc de                          ; B61A
        inc hl                          ; B61B
        ld (hl),a                       ; B61C
        pop hl                          ; B61D
        dec b                           ; B61E
        push de                         ; B61F
        call LA9C5                      ; B620
        pop de                          ; B623
        ld a,(de)                       ; B624
        inc de                          ; B625
        inc hl                          ; B626
        ld (hl),a                       ; B627
        ld bc,00006h                    ; B628
        add ix,bc                       ; B62B
        pop bc                          ; B62D
        djnz LB5E8                      ; B62E
        ret                             ; B630
LB631:
        ld hl,TABLA_ENEMIGOS            ; B631
        ld b,009h                       ; B634
        ld de,00007h                    ; B636
LB639:
        ld (hl),000h                    ; B639
        add hl,de                       ; B63B
        djnz LB639                      ; B63C
        ret                             ; B63E
LB63F:
        ld hl,L8E67                     ; B63F
        ld de,00007h                    ; B642
        ld b,00ch                       ; B645
LB647:
        ld (hl),000h                    ; B647
        add hl,de                       ; B649
        djnz LB647                      ; B64A
        ret                             ; B64C
LB64D:
        push iy                         ; B64D
        ld ix,L8E67                     ; B64F
        ld b,004h                       ; B653
LB655:
        push bc                         ; B655
        ld a,(ix+000h)                  ; B656
        and a                           ; B659
        jr nz,LB667                     ; B65A
LB65C:
        ld de,00007h                    ; B65C
        add ix,de                       ; B65F
        pop bc                          ; B661
        djnz LB655                      ; B662
        pop iy                          ; B664
        ret                             ; B666
LB667:
        ld iy,TABLA_ENEMIGOS            ; B667
        ld b,009h                       ; B66B
LB66D:
        push bc                         ; B66D
        ld a,(iy+000h)                  ; B66E
        cp 001h                         ; B671
        jr z,LB67B                      ; B673
        cp 002h                         ; B675
        jr z,LB67B                      ; B677
        jr LB6A9                        ; B679
LB67B:
        ld a,(iy+001h)                  ; B67B
        add a,018h                      ; B67E
        ld c,a                          ; B680
        ld a,(iy+002h)                  ; B681
        add a,018h                      ; B684
        ld b,a                          ; B686
        ld e,(ix+001h)                  ; B687
        ld d,(ix+002h)                  ; B68A
        srl e                           ; B68D
        srl e                           ; B68F
        srl e                           ; B691
        srl d                           ; B693
        srl d                           ; B695
        srl d                           ; B697
        ld a,018h                       ; B699
        add a,e                         ; B69B
        ld e,a                          ; B69C
        ld a,018h                       ; B69D
        add a,d                         ; B69F
        ld d,a                          ; B6A0
        ld hl,00202h                    ; B6A1
        call LB6C7                      ; B6A4
        jr nc,LB6B3                     ; B6A7
LB6A9:
        pop bc                          ; B6A9
        ld de,00007h                    ; B6AA
        add iy,de                       ; B6AD
        djnz LB66D                      ; B6AF
        jr LB65C                        ; B6B1
LB6B3:
        ld (ix+000h),000h               ; B6B3
        ld a,(iy+000h)                  ; B6B7
        or 070h                         ; B6BA
        ld (iy+000h),a                  ; B6BC
        xor a                           ; B6BF
        ld (LA43F),a                    ; B6C0
        pop bc                          ; B6C3
        jp LB65C                        ; B6C4
LB6C7:
        ld a,e                          ; B6C7
        cp c                            ; B6C8
        ret c                           ; B6C9
        ld a,c                          ; B6CA
        add a,l                         ; B6CB
        cp e                            ; B6CC
        ret c                           ; B6CD
        ld a,d                          ; B6CE
        cp b                            ; B6CF
        ret c                           ; B6D0
        ld a,b                          ; B6D1
        add a,h                         ; B6D2
        cp d                            ; B6D3
        ret                             ; B6D4
LB6D5:
        ld a,(L8E38)                    ; B6D5
        and a                           ; B6D8
        ret nz                          ; B6D9
        ld a,(V_JUG_X)                  ; B6DA
        srl a                           ; B6DD
        srl a                           ; B6DF
        srl a                           ; B6E1
        add a,019h                      ; B6E3
        ld e,a                          ; B6E5
        ld a,(V_JUG_Y)                  ; B6E6
        srl a                           ; B6E9
        srl a                           ; B6EB
        srl a                           ; B6ED
        add a,019h                      ; B6EF
        ld d,a                          ; B6F1
        ld b,009h                       ; B6F2
        ld ix,TABLA_ENEMIGOS            ; B6F4
LB6F8:
        push bc                         ; B6F8
        ld a,(ix+000h)                  ; B6F9
        and a                           ; B6FC
        jr z,LB723                      ; B6FD
        ld a,(ix+001h)                  ; B6FF
        add a,018h                      ; B702
        ld c,a                          ; B704
        ld a,(ix+002h)                  ; B705
        add a,018h                      ; B708
        ld b,a                          ; B70A
        ld hl,00202h                    ; B70B
        call LB6C7                      ; B70E
        jr c,LB723                      ; B711
        ld a,(ix+000h)                  ; B713
        ld c,a                          ; B716
        and 0f0h                        ; B717
        jr nz,LB723                     ; B719
        ld a,c                          ; B71B
        or 070h                         ; B71C
        ld (ix+000h),a                  ; B71E
        jr LB767                        ; B721
LB723:
        ld bc,00007h                    ; B723
        add ix,bc                       ; B726
        pop bc                          ; B728
        djnz LB6F8                      ; B729
        ld b,008h                       ; B72B
        ld ix,L8E83                     ; B72D
LB731:
        push bc                         ; B731
        ld a,(ix+000h)                  ; B732
        and a                           ; B735
        jr z,LB75E                      ; B736
        ld a,(ix+001h)                  ; B738
        srl a                           ; B73B
        srl a                           ; B73D
        srl a                           ; B73F
        add a,018h                      ; B741
        ld c,a                          ; B743
        ld a,(ix+002h)                  ; B744
        srl a                           ; B747
        srl a                           ; B749
        srl a                           ; B74B
        add a,018h                      ; B74D
        ld b,a                          ; B74F
        ld hl,00101h                    ; B750
        call LB6C7                      ; B753
        jr c,LB75E                      ; B756
        ld (ix+000h),000h               ; B758
        jr LB767                        ; B75C
LB75E:
        ld bc,00007h                    ; B75E
        add ix,bc                       ; B761
        pop bc                          ; B763
        djnz LB731                      ; B764
        ret                             ; B766
LB767:
        ld a,(L8E3C)                    ; B767
        and a                           ; B76A
        jr nz,LB782                     ; B76B
        ld a,002h                       ; B76D
        ld (LA43F),a                    ; B76F
        ld a,001h                       ; B772
        ld (L8E39),a                    ; B774
        ld a,008h                       ; B777
        ld (L8E38),a                    ; B779
        ld hl,L9673                     ; B77C
        ld (L8E3A),hl                   ; B77F
LB782:
        pop bc                          ; B782
        ret                             ; B783
LB784:
        ld c,a                          ; B784
        ld a,(L8E3C)                    ; B785
        and a                           ; B788
        ret nz                          ; B789
        ld a,c                          ; B78A
LB78B:
        call LAD4D                      ; B78B
        ld b,(hl)                       ; B78E
        inc hl                          ; B78F
        ld c,(hl)                       ; B790
        push bc                         ; B791
        push de                         ; B792
        call L9D66                      ; B793
        pop de                          ; B796
        pop bc                          ; B797
        ld hl,04ec8h                    ; B798
        jp L9D44                        ; B79B
LB79E:
        ld a,015h                       ; B79E
        cp c                            ; B7A0
        ret c                           ; B7A1
        cp b                            ; B7A2
        ret c                           ; B7A3
        ld a,(V_JUG_X)                  ; B7A4
        srl a                           ; B7A7
        srl a                           ; B7A9
        srl a                           ; B7AB
        sub c                           ; B7AD
        cp 002h                         ; B7AE
        jr c,LB7B6                      ; B7B0
        cp 0ffh                         ; B7B2
        jr c,LB7CE                      ; B7B4
LB7B6:
        ld a,(V_JUG_Y)                  ; B7B6
        srl a                           ; B7B9
        srl a                           ; B7BB
        srl a                           ; B7BD
        cp b                            ; B7BF
        ld a,(ix+004h)                  ; B7C0
        jr nc,LB7C9                     ; B7C3
        and a                           ; B7C5
        ret nz                          ; B7C6
        jr LB7F6                        ; B7C7
LB7C9:
        cp 002h                         ; B7C9
        ret nz                          ; B7CB
        jr LB7F6                        ; B7CC
LB7CE:
        ld a,(V_JUG_Y)                  ; B7CE
        srl a                           ; B7D1
        srl a                           ; B7D3
        srl a                           ; B7D5
        sub b                           ; B7D7
        cp 002h                         ; B7D8
        jr c,LB7DF                      ; B7DA
        cp 0ffh                         ; B7DC
        ret c                           ; B7DE
LB7DF:
        ld a,(V_JUG_X)                  ; B7DF
        srl a                           ; B7E2
        srl a                           ; B7E4
        srl a                           ; B7E6
        cp c                            ; B7E8
        ld a,(ix+004h)                  ; B7E9
        jr nc,LB7F3                     ; B7EC
        cp 003h                         ; B7EE
        ret nz                          ; B7F0
        jr LB7F6                        ; B7F1
LB7F3:
        cp 001h                         ; B7F3
        ret nz                          ; B7F5
LB7F6:
        push bc                         ; B7F6
        ld hl,L8E83                     ; B7F7
        ld b,008h                       ; B7FA
LB7FC:
        ld a,(hl)                       ; B7FC
        and a                           ; B7FD
        jr z,LB808                      ; B7FE
        ld de,00007h                    ; B800
        add hl,de                       ; B803
        djnz LB7FC                      ; B804
        pop bc                          ; B806
        ret                             ; B807
LB808:
        ld a,(ix+000h)                  ; B808
        cp 001h                         ; B80B
        ld c,002h                       ; B80D
        jr z,LB813                      ; B80F
        ld c,003h                       ; B811
LB813:
        ld (hl),c                       ; B813
        inc hl                          ; B814
        ld a,(ix+001h)                  ; B815
        inc a                           ; B818
        ld c,(ix+003h)                  ; B819
        rlc c                           ; B81C
        rla                             ; B81E
        rlc c                           ; B81F
        rla                             ; B821
        sla a                           ; B822
        ld (hl),a                       ; B824
        inc hl                          ; B825
        ld a,(ix+002h)                  ; B826
        rlc c                           ; B829
        rla                             ; B82B
        rlc c                           ; B82C
        rla                             ; B82E
        sla a                           ; B82F
        ld (hl),a                       ; B831
        inc hl                          ; B832
        ld (hl),000h                    ; B833
        inc hl                          ; B835
        ld a,(ix+004h)                  ; B836
        ld c,008h                       ; B839
        ld b,000h                       ; B83B
        cp 001h                         ; B83D
        jr z,LB851                      ; B83F
        ld c,0f8h                       ; B841
        cp 003h                         ; B843
        jr z,LB851                      ; B845
        ld c,000h                       ; B847
        ld b,008h                       ; B849
        cp 002h                         ; B84B
        jr z,LB851                      ; B84D
        ld b,0f8h                       ; B84F
LB851:
        ld (hl),c                       ; B851
        inc hl                          ; B852
        ld (hl),b                       ; B853
        inc hl                          ; B854
        ld a,(ix+004h)                  ; B855
        and 003h                        ; B858
        ld (hl),a                       ; B85A
        xor a                           ; B85B
        ld (LA43F),a                    ; B85C
        pop bc                          ; B85F
        ret                             ; B860
LB861:
        ld a,(L8E28)                    ; B861
        and a                           ; B864
        ret z                           ; B865
        ld a,(LB8A8)                    ; B866
        inc a                           ; B869
        and 003h                        ; B86A
        ld (LB8A8),a                    ; B86C
        jr nz,LB878                     ; B86F
        ld a,(L8E28)                    ; B871
        dec a                           ; B874
        ld (L8E28),a                    ; B875
LB878:
        call LAECC                      ; B878
        bit 0,a                         ; B87B
        ret z                           ; B87D
        bit 1,a                         ; B87E
        jr z,LB895                      ; B880
        call LAECC                      ; B882
        res 4,a                         ; B885
        or e                            ; B887
        ld e,a                          ; B888
        bit 0,e                         ; B889
        jr z,LB88F                      ; B88B
        res 1,e                         ; B88D
LB88F:
        bit 2,e                         ; B88F
        ret z                           ; B891
        res 3,e                         ; B892
        ret                             ; B894
LB895:
        call LAECC                      ; B895
        res 4,a                         ; B898
        or e                            ; B89A
        ld e,a                          ; B89B
        bit 1,e                         ; B89C
        jr z,LB8A2                      ; B89E
        res 0,e                         ; B8A0
LB8A2:
        bit 3,e                         ; B8A2
        ret z                           ; B8A4
        res 2,e                         ; B8A5
        ret                             ; B8A7
LB8A8:
        db 000h                                            ; B8A8
LB8A9:
        ld a,(L8E57)                    ; B8A9
        and a                           ; B8AC
        ret nz                          ; B8AD
        ld a,0c8h                       ; B8AE
        ld (L8E37),a                    ; B8B0
        ret                             ; B8B3
LB8B4:
        ld a,(L8E58)                    ; B8B4
        cp 0ffh                         ; B8B7
        ret nz                          ; B8B9
        ld bc,(V_JUG_X)                 ; B8BA
        ld a,(V_JUG_ESTADO)             ; B8BE
        and a                           ; B8C1
        jr nz,LB8CD                     ; B8C2
        ld a,c                          ; B8C4
        sub 004h                        ; B8C5
        ld c,a                          ; B8C7
        ld de,059e0h                    ; B8C8
        jr LB8F6                        ; B8CB
LB8CD:
        cp 001h                         ; B8CD
        jr nz,LB8DE                     ; B8CF
        ld a,b                          ; B8D1
        sub 004h                        ; B8D2
        ld b,a                          ; B8D4
        ld a,c                          ; B8D5
        add a,004h                      ; B8D6
        ld c,a                          ; B8D8
        ld de,05a20h                    ; B8D9
        jr LB8F6                        ; B8DC
LB8DE:
        cp 002h                         ; B8DE
        jr nz,LB8EF                     ; B8E0
        ld a,c                          ; B8E2
        sub 004h                        ; B8E3
        ld c,a                          ; B8E5
        ld a,b                          ; B8E6
        add a,008h                      ; B8E7
        ld b,a                          ; B8E9
        ld de,05a60h                    ; B8EA
        jr LB8F6                        ; B8ED
LB8EF:
        ld de,05aa0h                    ; B8EF
        ld a,b                          ; B8F2
        sub 004h                        ; B8F3
        ld b,a                          ; B8F5
LB8F6:
        ld hl,00210h                    ; B8F6
        jp LAC1F                        ; B8F9
LB8FC:
        ld a,(L8E58)                    ; B8FC
        cp 0ffh                         ; B8FF
        ret nz                          ; B901
        call LB9CF                      ; B902
        ld a,(L8E41)                    ; B905
        and a                           ; B908
        ret nz                          ; B909
        ld a,078h                       ; B90A
        cp l                            ; B90C
        ret nz                          ; B90D
        ld a,012h                       ; B90E
        cp h                            ; B910
        ret nz                          ; B911
        call LADB5                      ; B912
        ld a,079h                       ; B915
        sub l                           ; B917
        ld (L8E59),a                    ; B918
        ld a,00ah                       ; B91B
        sub h                           ; B91D
        ld (L8E5A),a                    ; B91E
        cp 00ah                         ; B921
        jr c,LB934                      ; B923
        cp 017h                         ; B925
        jr nc,LB934                     ; B927
        ld a,00eh                       ; B929
        ld (L8E58),a                    ; B92B
        ld a,005h                       ; B92E
        ld (LA43F),a                    ; B930
        ret                             ; B933
LB934:
        ld a,0ffh                       ; B934
        ld (L8E2F),a                    ; B936
        ret                             ; B939
LB93A:
        ld a,(L8E58)                    ; B93A
        and a                           ; B93D
        ret z                           ; B93E
        cp 0ffh                         ; B93F
        ret z                           ; B941
        dec a                           ; B942
        ld (L8E58),a                    ; B943
        ld e,a                          ; B946
        ld d,000h                       ; B947
        ld hl,L9210                     ; B949
        add hl,de                       ; B94C
        ld a,(hl)                       ; B94D
        add a,a                         ; B94E
        add a,a                         ; B94F
        ld e,a                          ; B950
        ld hl,L922C                     ; B951
        add hl,de                       ; B954
        ld e,(hl)                       ; B955
        inc hl                          ; B956
        ld d,(hl)                       ; B957
        inc hl                          ; B958
        ld c,(hl)                       ; B959
        inc hl                          ; B95A
        ld b,(hl)                       ; B95B
        push bc                         ; B95C
        ld a,(L8E58)                    ; B95D
        ld c,a                          ; B960
        ld b,000h                       ; B961
        ld hl,L921E                     ; B963
        add hl,bc                       ; B966
        ld b,(hl)                       ; B967
        pop hl                          ; B968
        ld a,(L8E5A)                    ; B969
        sub b                           ; B96C
        ld (L8E5A),a                    ; B96D
        cp 017h                         ; B970
        jr nc,LB98C                     ; B972
        sla a                           ; B974
        sla a                           ; B976
        sla a                           ; B978
        ld b,a                          ; B97A
        ld a,(L8E59)                    ; B97B
        cp 017h                         ; B97E
        jr nc,LB98C                     ; B980
        sla a                           ; B982
        sla a                           ; B984
        sla a                           ; B986
        ld c,a                          ; B988
        call LAC1F                      ; B989
LB98C:
        ld a,(L8E58)                    ; B98C
        cp 002h                         ; B98F
        ret nz                          ; B991
        ld a,0ffh                       ; B992
        ld (L8E57),a                    ; B994
        ld hl,LC1CB                     ; B997
        ld (hl),035h                    ; B99A
        ld a,006h                       ; B99C
        ld (LA43F),a                    ; B99E
        ret                             ; B9A1
LB9A2:
        ld a,(L8E3C)                    ; B9A2
        and a                           ; B9A5
        ret z                           ; B9A6
        dec a                           ; B9A7
        ld (L8E3C),a                    ; B9A8
        jr z,LB9C0                      ; B9AB
        ld de,L9B68                     ; B9AD
        bit 0,a                         ; B9B0
        jr z,LB9B7                      ; B9B2
        ld de,L9B6C                     ; B9B4
LB9B7:
        ld hl,06ec8h                    ; B9B7
        ld bc,00202h                    ; B9BA
        jp L9DB2                        ; B9BD
LB9C0:
        ld de,L9B70                     ; B9C0
        ld hl,06ec8h                    ; B9C3
        ld bc,00202h                    ; B9C6
        call L9DB2                      ; B9C9
        jp L9DF5                        ; B9CC
LB9CF:
        call LADB5                      ; B9CF
        ld a,(V_JUG_X)                  ; B9D2
        srl a                           ; B9D5
        srl a                           ; B9D7
        srl a                           ; B9D9
        add a,l                         ; B9DB
        inc a                           ; B9DC
        ld l,a                          ; B9DD
        res 0,l                         ; B9DE
        ld a,(V_JUG_Y)                  ; B9E0
        srl a                           ; B9E3
        srl a                           ; B9E5
        srl a                           ; B9E7
        add a,h                         ; B9E9
        inc a                           ; B9EA
        ld h,a                          ; B9EB
        res 0,h                         ; B9EC
        ret                             ; B9EE
LB9EF:
        ld a,(L8E41)                    ; B9EF
        cp 003h                         ; B9F2
        ret nz                          ; B9F4
        ld a,(L8E3D)                    ; B9F5
        cp 009h                         ; B9F8
        ret nz                          ; B9FA
        ld a,(L8E37)                    ; B9FB
        and a                           ; B9FE
        ret nz                          ; B9FF
        ld hl,TABLA_ENEMIGOS            ; BA00
        ld de,00007h                    ; BA03
        ld b,009h                       ; BA06
LBA08:
        ld a,(hl)                       ; BA08
        and a                           ; BA09
        ret nz                          ; BA0A
        add hl,de                       ; BA0B
        djnz LBA08                      ; BA0C
        ld b,001h                       ; BA0E
        ld hl,L91EE                     ; BA10
        ex af,af'                       ; BA13
        ld bc,0385ch                    ; BA14
        jp LB542                        ; BA17
LBA1A:
        ld hl,L8E29                     ; BA1A
        ld a,030h                       ; BA1D
        rld                             ; BA1F
        push af                         ; BA21
        push hl                         ; BA22
        ex af,af'                       ; BA23
        ld a,081h                       ; BA24
        ex af,af'                       ; BA26
        ld hl,056c0h                    ; BA27
        call L9F61                      ; BA2A
        pop hl                          ; BA2D
        pop af                          ; BA2E
        rld                             ; BA2F
        push af                         ; BA31
        push hl                         ; BA32
        ld hl,05700h                    ; BA33
        call L9F61                      ; BA36
        pop hl                          ; BA39
        pop af                          ; BA3A
        rld                             ; BA3B
        ret                             ; BA3D
LBA3E:
        ld a,(L8E3E)                    ; BA3E
        cp 00eh                         ; BA41
        ret nz                          ; BA43
        ld a,(L8E3D)                    ; BA44
        cp 009h                         ; BA47
        ret z                           ; BA49
        ld hl,04000h                    ; BA4A
        ld de,003e8h                    ; BA4D
        ld bc,01800h                    ; BA50
        ldir                            ; BA53
        call L9F4C                      ; BA55
        ld de,TXT_SIN_MUNICION          ; BA58
        ld hl,04800h                    ; BA5B
        call L9F8D                      ; BA5E
        ld de,LA358                     ; BA61
        ld hl,05238h                    ; BA64
        call L9F8D                      ; BA67
        call ESPERA_SUELTA              ; BA6A
        call ESPERA_TECLA               ; BA6D
        ld hl,003e8h                    ; BA70
        ld de,04000h                    ; BA73
        ld bc,01800h                    ; BA76
        ldir                            ; BA79
        jp NUEVA_PARTIDA                ; BA7B
LBA7E:
        db 0FCh,0FEh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FCh,0FCh,0FFh,0FFh,0FFh,0FFh,0FFh; BA7E
        db 0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FCh,0FCh,0FFh,0FFh,0FFh,0FFh,0CFh,003h,000h,000h; BA8E
        db 000h,000h,0C0h,0F8h,0FFh,0FFh,0FFh,0FFh,03Fh,03Fh,01Fh,088h,0D0h,0ECh,0EEh,0E0h; BA9E
        db 0F1h,0F8h,0FDh,0EAh,0C8h,08Ch,01Fh,03Fh,03Fh,03Fh,0FFh,0FFh,0FFh,0FFh,03Fh,007h; BAAE
        db 000h,000h,000h,03Fh,0FFh,0FFh,0FFh,0FFh,0FCh,0FCh,0F8h,011h,00Bh,06Fh,0EFh,00Fh; BABE
        db 01Fh,03Fh,07Fh,0AFh,027h,063h,0F0h,0F8h,0F9h,0FFh,0FFh,0FFh,0FFh,0FFh,0FEh,0E0h; BACE
        db 000h,000h,01Fh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,07Fh,07Fh,0FFh,0FFh,0FFh,0FFh,0FFh; BADE
        db 0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FCh,0E0h,000h,000h; BAEE
LBAFE:
        db 0FCh,0FEh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FCh,0FCh,0FFh,0FFh,0FFh,0FFh,0FFh; BAFE
        db 0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0CFh,003h,000h,000h; BB0E
        db 000h,000h,0C0h,0F8h,0FFh,0FFh,0FFh,0FFh,03Fh,03Fh,01Fh,088h,0D0h,0ECh,0EEh,0E0h; BB1E
        db 0F1h,0F8h,0FDh,0FAh,0F8h,0FCh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,03Fh,007h; BB2E
        db 000h,000h,000h,03Fh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,01Fh,00Fh,06Fh,0EFh,00Fh; BB3E
        db 01Fh,03Fh,07Fh,0AFh,027h,063h,0F0h,0F8h,0F9h,0FFh,0FFh,0FFh,0FFh,0FFh,0FEh,0E0h; BB4E
        db 000h,000h,01Fh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh; BB5E
        db 0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FCh,0E0h,000h,000h; BB6E
LBB7E:
        db 0FCh,0FEh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh; BB7E
        db 0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0CFh,003h,000h,000h; BB8E
        db 000h,000h,0C0h,0F8h,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0F8h,0F0h,0ECh,0EEh,0E0h; BB9E
        db 0F1h,0F8h,0FDh,0FAh,0F8h,0FCh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,03Fh,007h; BBAE
        db 000h,000h,000h,03Fh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,01Fh,00Fh,06Fh,0EFh,00Fh; BBBE
        db 01Fh,03Fh,07Fh,0BFh,03Fh,07Fh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FEh,0E0h; BBCE
        db 000h,000h,01Fh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh; BBDE
        db 0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FCh,0E0h,000h,000h; BBEE
        db 0FCh,0FEh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh; BBFE
        db 0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0CFh,003h,000h,000h; BC0E
        db 000h,000h,0C0h,0F8h,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh; BC1E
        db 0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,03Fh,007h; BC2E
        db 000h,000h,000h,03Fh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh; BC3E
        db 0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FEh,0E0h; BC4E
        db 000h,000h,01Fh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh; BC5E
        db 0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FCh,0E0h,000h,000h; BC6E
LBC7E:
        db 000h,03Ch,034h,018h,018h                        ; BC7E
        db "4zz:ZZZ:z~"                                 ; BC83
        db 000h,0FFh,0FFh,000h,000h,0FFh,0FFh,000h,000h,0FFh,0FFh,000h,000h,0FCh,07Fh,000h; BC8D
        db 000h,0FBh,0BFh,003h,080h,0F4h,0DFh,004h,0C0h,0EDh,0EFh,00Dh,0E0h,0EFh,0EFh,00Fh; BC9D
        db 0E0h,0EFh,0EFh,00Fh,0E0h,0F7h,0DFh,007h,0C0h,0FBh,0BFh,003h,080h,0FCh,07Fh,000h; BCAD
        db 000h,0FFh,0FFh,000h,000h,0FFh,0FFh,000h,000h,0FFh,0FFh,000h,000h,0FFh,0FFh,000h; BCBD
        db 000h,0FFh,0FFh,000h,000h,0FFh,0FFh,000h,000h,0F8h,03Fh,000h,000h,0F7h,0DFh,007h; BCCD
        db 0C0h,0ECh,0EFh,00Ch,0E0h,0D9h,0F7h,019h,0F0h,0DBh,0F7h,01Bh,0F0h,0DFh,0F7h,01Fh; BCDD
        db 0F0h,0DFh,0F7h,01Fh,0F0h,0DFh,0F7h,01Fh,0F0h,0EFh,0EFh,00Fh,0E0h,0F7h,0DFh,007h; BCED
        db 0C0h,0F8h,03Fh,000h,000h,0FFh,0FFh,000h,000h,0FFh,0FFh,000h,000h,0FFh,0FFh,000h; BCFD
        db 000h,0FFh,0FFh,000h,000h,0FCh,07Fh,000h,000h,0F3h,09Fh,003h,080h,0EFh,0EFh,00Fh; BD0D
        db 0E0h,0D9h,0F7h,019h,0F0h,0D3h,0F7h,013h,0F0h,0B3h,0FBh,033h,0F8h,0BFh,0FBh,03Fh; BD1D
        db 0F8h,0BFh,0FBh,03Fh,0F8h,0DFh,0F7h,01Fh,0F0h,0DFh,0F7h,01Fh,0F0h,0EFh,0EFh,00Fh; BD2D
        db 0E0h,0F3h,09Fh,003h,080h,0FCh,07Fh,000h,000h,0FFh,0FFh,000h,000h,0FFh,0FFh,000h; BD3D
        db 000h,0EFh,0FFh,0E7h,000h,000h,000h,0D7h,0FFh,0DBh,010h,000h,018h,0BBh,0FFh,0B5h; BD4D
        db 038h,000h,034h,06Bh,0FFh,0BEh,068h,000h,03Eh,07Dh,0FFh,0DDh,07Ch,000h,01Ch,0BDh; BD5D
        db 0FFh,013h,03Ch,000h,010h,0DDh,0FEh,0CFh,01Ch,000h,0C0h,0E5h,0D2h,0BFh,004h,000h; BD6D
        db 080h,0FBh,0ADh,07Fh,000h,02Ch,000h,0FFh,07Ch,0FFh,000h,07Ch,000h,0DEh,0FFh,07Fh; BD7D
        db 000h,0FFh,000h,0AEh,0FFh,06Fh,020h,0FFh,000h,0DDh,0FFh,097h,001h,0FFh,090h,0FDh; BD8D
        db 0FFh,0AFh,001h,0FFh,080h,0FEh,0FFh,03Fh,000h,0FFh,000h,0FFh,07Fh,03Fh,000h,07Fh; BD9D
        db 000h,0FFh,09Eh,0BFh,000h,01Eh,000h,0FDh,0E9h,05Fh,000h,008h,040h,0CAh,0F7h,067h; BDAD
        db 002h,000h,060h,0B6h,0FFh,09Bh,036h,000h,018h,0BDh,0FFh,0BDh,03Ch,000h,03Ch,05Dh; BDBD
        db 0FFh,0BDh,05Ch,000h,03Ch,0B3h,0FFh,0DBh,030h,000h,018h,0CFh,0FFh,0E7h,000h,000h; BDCD
        db 000h,0CFh,0FFh,0F8h,000h,000h,000h,0B7h,0FFh,0F6h,030h,000h,006h,057h,0FFh,0EAh; BDDD
        db 050h,000h,00Ah,097h,003h,0F5h,010h,000h,004h,0ECh,0FCh,07Bh,000h,0FCh,000h,0FBh; BDED
        db 0FFh,0BFh,003h,0FFh,080h,0F7h,0FFh,0BFh,007h,0FFh,080h,0F7h,0FFh,0DFh,007h,0FFh; BDFD
        db 0C0h,0F7h,0FFh,0EFh,007h,0FFh,0E0h,0F7h,0FFh,0DFh,007h,0FFh,0C0h,0F7h,0D7h,0EFh; BE0D
        db 007h,0D7h,0E0h,0F7h,0EFh,0DFh,007h,0EFh,0C0h,0EBh,0F7h,0EFh,00Bh,0F7h,0E0h,0EFh; BE1D
        db 0FFh,0F7h,00Fh,0FFh,0F0h,0EFh,0FFh,0F7h,00Fh,0FFh,0F0h,0EFh,0FFh,0EFh,00Fh,0FFh; BE2D
        db 0E0h,0F7h,0FFh,0EFh,007h,0FFh,0E0h,0FBh,0FFh,0DFh,003h,0FFh,0C0h,0FBh,0FDh,0BFh; BE3D
        db 003h,0FDh,080h,0CDh,0FAh,063h,001h,0FAh,000h,0B6h,005h,0EDh,030h,000h,00Ch,097h; BE4D
        db 0FFh,0EBh,010h,000h,008h,06Fh,0FFh,0F5h,060h,000h,004h,09Fh,0FFh,0FBh,000h,000h; BE5D
        db 000h,0DFh,0FFh,0FCh,000h,000h,000h,0AFh,0FFh,0FAh,020h,000h,002h,0D8h,03Fh,0F5h; BE6D
        db 000h,000h,004h,0B7h,0C4h,01Bh,027h,0C0h,000h,0EEh,0FBh,0EFh,00Eh,0FBh,0E0h,0EDh; BE7D
        db 077h,057h,00Dh,077h,050h,0DAh,0AAh,0BBh,01Ah,0AAh,0B8h,0D5h,055h,05Bh,015h,055h; BE8D
        db 058h,0DAh,0BAh,0ABh,01Ah,0AAh,0A8h,0B5h,07Fh    ; BE9D
        db "U5ET"                                       ; BEA6
        db 0AAh,0BFh,0ADh,02Ah                             ; BEAA
LBEAE:
        db 0A0h,0ACh,0B5h,07Fh,0D5h,035h,040h,054h,0BAh,0FFh,0ADh,03Ah,080h,0ACh,0D5h,07Fh; BEAE
        db 05Bh,015h,051h,058h,0DAh,0AEh,0BBh,01Ah,0AAh,0B8h,0DDh,055h,057h,01Dh,055h,050h; BEBE
        db 0EAh,0AAh,0B7h,00Ah,0AAh,0B0h,0EDh,055h,06Fh,00Dh,055h,060h,0F6h,0AAh,0AFh,006h; BECE
        db 0AAh,0A0h,0F5h,05Dh,05Fh,005h,05Dh,040h,0D6h,0BFh,0BBh,006h,0BFh,080h,0A9h,0E0h; BEDE
        db 075h,021h,0E0h,004h,05Eh,01Fh,0EAh,040h,000h,00Ah,03Fh,0FFh,0F5h,000h,000h,000h; BEEE
        db 0FFh,0FFh,0FFh,000h,000h,000h,0F8h,0F0h,0FFh,000h,000h,000h,0E5h,04Fh,07Fh,005h; BEFE
        db 00Fh,000h,0DEh,0AAh,0BFh,01Eh,02Ah,080h,0D5h,055h,06Fh,015h,015h,000h,0EAh,0EAh; BF0E
        db 0D7h,00Ah,002h,010h,0D5h,0FDh,0ABh,014h,000h,028h,0EBh,0FFh,0D7h,028h,000h,014h; BF1E
        db 0D7h,0FFh,0EBh,010h,000h,008h,0EFh,0FFh,0DFh,000h,000h,01Ch,0FFh,0FFh,0ABh,000h; BF2E
        db 000h,028h,0DFh,0FFh,0D7h,000h,000h,014h,0AFh,0FFh,0EFh,020h,000h,00Ch,0DFh,0FFh; BF3E
        db 0D7h,000h,000h,014h,0AFh,0FFh,0EFh,020h,000h,028h,05Fh,0FFh,0DFh,050h,000h,010h; BF4E
        db 0AFh,0FFh,0EFh,020h,000h,000h,057h,0FFh,0FFh,050h,000h,000h,0ABh,0FFh,0BFh,02Ah; BF5E
        db 000h,010h,0B5h,0FDh,05Fh,034h,000h,050h,0BAh,0FAh,0BFh,03Ah,002h,0A0h,0D5h,0F5h; BF6E
        db 05Fh,014h,005h,040h,0EAh,0FAh,0BFh,002h,08Ah,0A0h,0FDh,07Fh,0FFh,000h,000h,000h; BF7E
        db 0E3h,000h,0DDh,01Ch,0BEh,03Eh,07Fh,07Fh,094h,014h,0AAh; BF8E
        db "*wwuu"                                      ; BF99
        db 0BDh,0BDh,0A6h,0A6h,0BCh,0BCh,05Dh,01Ch,0D5h,014h,0D5h,014h,0D5h,014h,0B6h,036h; BF9E
        db 000h,000h,000h,000h,000h,000h,000h,000h,000h,03Eh,03Eh,02Eh,0DFh,0AEh,09Ch,084h; BFAE
        db 000h,000h,000h,000h,058h,0BDh,05Ah,03Eh,000h,000h,000h,000h,0B1h,07Ah,0B5h,01Ch; BFBE
        db 000h,004h,000h,004h,064h,0F5h,07Eh,03Fh,000h,000h,000h,040h,000h,000h,000h,0EEh; BFCE
        db 0FFh,03Ch,03Eh,02Fh,017h,012h,00Dh,002h,0FFh,0FAh,07Ah,055h,082h,0FAh,05Bh,032h; BFDE
        db 0FFh,0F5h,07Ah,051h,080h,000h,000h,000h,0FEh,0F5h,0D4h,024h,004h,000h,004h,004h; BFEE
        db 000h,000h,080h,000h,000h,000h,000h,000h,000h,018h; BFFE
LC008:
        db 018h,07Eh,07Eh,018h,018h,000h,000h,000h,000h,000h,018h,018h,018h,030h,000h,000h; C008
        db 000h,03Eh,03Eh,000h,000h,000h,000h,000h,000h,000h,000h,018h,018h,000h,01Ch,022h; C018
        db 059h,051h,059h,022h,01Ch,000h                   ; C028
        db "<~fff~<"                                    ; C02E
        db 000h,018h,038h,038h,018h,018h,018h,03Ch,000h,03Ch,07Eh,046h,00Ch,030h,07Eh,07Eh; C035
        db 000h,03Ch,07Eh,062h,00Ch,062h,07Eh,03Ch,000h,00Ch,01Ch; C045
        db ",L~~"                                       ; C050
        db 018h,000h                                       ; C054
        db "~~@|"                                       ; C056
        db 002h,042h,07Ch,000h                             ; C05A
        db "<|@|bb<"                                    ; C05E
        db 000h,07Eh,07Eh,006h,00Ch,018h,010h,010h,000h    ; C065
        db "<ff<ff<"                                    ; C06E
        db 000h                                            ; C075
        db "<ff>"                                       ; C076
        db 006h,066h,03Ch,000h,000h,000h,018h,018h,000h,018h,018h,000h,000h,000h,030h,030h; C07A
        db 000h,030h,030h,060h,000h,004h,00Ch,018h,030h,018h,00Ch,000h,000h,000h,03Eh,03Eh; C08A
        db 000h,03Eh,03Eh,000h,000h,010h,018h,00Ch,006h,00Ch,018h,000h,018h,018h,000h,018h; C09A
        db 018h,018h,018h,018h,018h,018h,018h,018h,018h,000h,018h,018h,010h,010h,010h,044h; C0AA
        db 044h,0D6h,0C6h,000h,054h,0C6h,0C2h,0D4h,0C2h,0C6h,0D4h,000h,054h,0C6h,0C2h,0C0h; C0BA
        db 0C2h,0C6h,054h,000h,050h,0C4h,0C2h,0C2h,0C2h,0C4h,0D0h,000h,056h,0C2h,0C0h,0D0h; C0CA
        db 0C0h,0C2h,056h,000h,054h,0C2h,0C0h,0C0h,0D0h,0C0h,0C0h,000h,054h,0C6h,0C2h,0C0h; C0DA
        db 0C6h,0C6h,054h,000h,0C2h,0C2h,0C2h,0D6h,0C2h,0C2h,0C2h,000h,0DEh,018h,018h,018h; C0EA
        db 018h,018h,0DEh,000h,016h,006h,002h,002h,0C2h,0C6h,054h,000h,0C4h,0C4h,0D0h,0D0h; C0FA
        db 0C0h,0C4h,0C4h,000h                             ; C10A
        db "`````bj"                                    ; C10E
        db 000h,082h,0C6h,0C6h,0D6h,0D6h,0C6h,0C6h,000h,086h,0C6h,0C6h,0D6h,0DEh,0CEh,0C6h; C115
        db 000h,054h,0C6h,0C2h,0C2h,0C2h,0C6h,054h,000h,0D4h,0C6h,0C2h,0C6h,0D4h,0C0h,0C0h; C125
        db 000h,054h,0C6h,0C2h,0C2h,0D2h,0CEh,054h,000h,0D4h,0C6h,0C2h,0C2h,0D4h,0C4h,0C2h; C135
        db 000h,06Ch,0ECh,0C0h,06Ch,082h,0EEh,06Ch,000h,05Ah,05Ah,05Ah,018h,018h,018h,03Ch; C145
        db 000h,044h,0C6h,0C6h,0C6h,0C6h,0C6h,06Ch,000h,082h,0C2h,0C6h,0C6h,0C6h,06Ch,028h; C155
        db 000h,082h,0C6h,0C6h,0D6h,0D6h,0D6h,044h,000h,082h,0C6h; C165
        db "l((l"                                       ; C170
        db 0C6h,000h,082h,0C6h,054h,010h,010h,010h,038h,000h,0F6h,076h,004h,008h,010h,076h; C174
        db 0F6h,000h,09Ah,0C6h,0C6h,0D6h,0DEh,0CEh,0C6h,000h; C184
LC18E:
        db 000h,03Dh,000h,093h,066h,014h,000h,093h,000h,093h,000h,093h,000h,093h,000h,093h; C18E
        db 000h,093h,066h,014h,000h,093h,000h,093h,000h,093h,000h,093h,000h,093h,066h,014h; C19E
        db 000h,093h,000h,093h,000h,093h,000h,093h,000h,093h,066h,014h,000h,093h,000h,093h; C1AE
        db 000h,093h,000h,093h,000h,093h,000h,093h,000h,093h,000h,093h,066h; C1BE
LC1CB:
        db 02Fh,000h,093h,000h,093h,000h,093h,000h,093h,000h,093h,066h,006h,066h,007h,066h; C1CB
        db 009h,066h,007h,066h,007h,066h,007h,066h,007h,066h,007h,066h,007h,066h,009h,066h; C1DB
        db 007h,066h,007h,066h,007h,066h,007h,066h,007h,066h,009h,066h,007h,066h,007h,066h; C1EB
        db 007h,066h,007h,066h,007h,066h,009h,066h,007h,066h,007h,066h,007h,066h,007h,066h; C1FB
        db 007h,066h,007h,066h,007h,066h,007h,066h,000h,066h,007h,066h,007h,000h,031h,000h; C20B
        db 032h,000h,033h,066h,00Ch,066h,000h,066h,00Ah,066h,020h,066h,000h,066h,000h,066h; C21B
        db 000h,066h,000h,066h,000h,066h,00Ah              ; C22B
        db "d9d9f"                                      ; C232
        db 000h,066h,000h,066h,000h,066h,00Ah,066h,000h,066h,000h,066h,000h,066h,000h,066h; C237
        db 000h,066h,00Ah                                  ; C247
        db "f f f"                                      ; C24A
        db 000h,066h,000h,066h,000h,066h,000h,066h,000h,066h,000h,066h,036h,066h,000h,066h; C24F
        db 000h,066h,000h,066h,000h,000h,034h,067h,016h,067h,02Eh,066h,000h,066h,020h,066h; C25F
        db 000h,066h,000h,066h,000h,066h,000h,066h,000h,066h,000h,066h,000h,033h,038h,066h; C26F
        db 000h,066h,000h,066h,000h,066h,000h,066h,000h,066h,000h,066h,000h,066h,001h,066h; C27F
        db 000h,066h,000h                                  ; C28F
        db "f f f"                                      ; C292
        db 000h,066h,000h,066h,000h,066h,001h,066h,001h,066h,000h,066h,037h,066h,001h,066h; C297
        db 000h,066h,000h,066h,000h,055h,038h,067h,016h,066h,02Eh,066h,000h,066h,000h,067h; C2A7
        db 02Eh,066h,000h,066h,000h,066h,000h,066h,000h,066h,000h,066h,000h,066h,001h,067h; C2B7
        db 038h,066h,000h,066h,000h,066h,000h,066h,000h,066h,001h,067h,02Eh,066h,001h,066h; C2C7
        db 000h,066h,000h                                  ; C2D7
        db "f f '"                                      ; C2DA
        db 0A7h,027h,0A8h,027h,0A8h,027h,0A9h,066h,001h,066h,000h,066h,00Ah,066h,020h,066h; C2DF
        db 001h,066h,001h,066h,000h,055h,038h,067h,016h,066h,000h,066h,000h,067h,02Eh,066h; C2EF
        db 000h,066h,000h,066h,000h,066h,002h,066h,003h    ; C2FF
        db "D8e.e.38f"                                  ; C308
        db 000h,066h,000h,066h,000h,066h,000h              ; C311
        db "g.g.g.f"                                    ; C318
        db 000h,066h,000h,066h,000h,066h,000h,027h,022h    ; C31F
        db "'#'#'$f"                                    ; C328
        db 000h,066h,000h,066h,000h,066h,020h,066h,000h,066h,000h,066h,000h,064h,001h,066h; C32F
        db 00Ch,066h,000h,066h,000h,066h,000h,066h,000h,066h,000h,066h,000h,066h,020h,066h; C33F
        db 000h,066h,001h,066h,000h,044h,038h,066h,000h,066h,000h,066h,000h,066h,000h,066h; C34F
        db 000h,066h,000h,066h,000h,066h,000h,066h,000h,066h,000h,066h,000h,066h,000h,027h; C35F
        db 022h                                            ; C36F
        db "'#'#'$f"                                    ; C370
        db 000h,066h,000h,066h,000h,066h,000h,066h,000h,066h,000h,066h,000h,065h,001h,066h; C377
        db 000h,066h,002h,066h,003h,066h,000h,065h,02Eh,066h,000h,027h,0A7h,027h,0A8h,027h; C387
        db 0A8h,027h,0A8h,027h,0A8h,027h,0A9h,066h,000h,066h,000h,066h,000h,011h,02Ah,011h; C397
        db 02Bh,011h,02Bh,011h,02Bh,011h,02Bh,011h,02Ch,011h,02Dh,066h,000h,066h,000h; C3A7
        db "'''('(')f"                                  ; C3B6
        db 000h,066h,000h,066h,000h,007h                   ; C3BF
        db "8f8f8d"                                     ; C3C5
        db 000h,064h,001h,066h,000h,066h,000h,066h,000h,066h,000h,066h,000h,066h,000h,027h; C3CB
        db 022h                                            ; C3DB
        db "'#'#'#'#'$f"                                ; C3DC
        db 000h,066h,000h,066h,000h,011h,0AAh,011h,0ABh,011h,0ABh,011h,0ABh,011h,0ABh,011h; C3E7
        db 0ACh,011h,0ADh,064h,02Eh,066h,001h,067h,02Eh,066h,001h,066h,000h,066h,000h,066h; C3F7
        db 000h,066h,000h,066h,000h,066h,038h,066h,000h,066h,000h,066h,000h,064h,001h,066h; C407
        db 000h,066h,000h,066h,001h,066h,001h,066h,000h,066h,000h,027h,022h; C417
        db "'#'#'#'#'$f"                                ; C424
        db 000h,067h,004h,066h,000h,066h,000h,066h,000h,066h,000h,066h,000h,066h,000h,066h; C42F
        db 000h,066h,000h,066h,001h,066h,000h,066h,004h,066h,000h,066h,000h,066h,000h,066h; C43F
        db 000h,066h,000h,066h,000h                        ; C44F
        db "f8w8f8w8f"                                  ; C454
        db 000h,066h,00Ch,066h,000h,066h,001h,066h,002h,066h,003h,066h,000h; C45D
        db "'''('('('(')f"                              ; C46A
        db 000h,066h,000h,066h,000h,011h,02Ah,011h,02Bh,011h,02Bh,011h,02Bh,011h,02Bh,011h; C477
        db 02Ch,011h,02Dh,066h,000h,066h,000h,066h,000h,066h,000h,066h,000h,066h,000h,066h; C487
        db 000h,066h,000h,066h,000h,066h,000h,066h,000h,066h,000h,066h,000h,067h,001h,066h; C497
        db 00Ch,066h,000h,066h,000h,066h,000h,066h,000h,066h,000h,066h,000h,066h,000h,066h; C4A7
        db 000h                                            ; C4B7
        db "e.d.f"                                      ; C4B8
        db 000h,066h,000h,066h,000h,066h,000h,011h,0AAh,011h,0ABh,011h,0ABh,011h,0ABh,011h; C4BD
        db 0ABh,011h,0ACh,011h,0ADh,066h,000h,066h,000h,066h,000h,027h,0A7h,027h,0A8h,027h; C4CD
        db 0A8h,027h,0A8h,027h,0A8h,027h,0A9h,066h,000h    ; C4DD
        db "d9g.f"                                      ; C4E6
        db 000h,067h,001h,067h,016h,066h,000h,066h,000h,066h,000h,066h,000h,066h,000h,066h; C4EB
        db 000h,066h,001h,066h,020h,066h,001h,066h,000h,066h,000h,066h,000h,066h,000h,066h; C4FB
        db 000h,066h,000h,066h,000h,066h,000h,066h,000h,066h,000h,066h,000h,066h,000h,066h; C50B
        db 000h,066h,000h,066h,000h,027h,022h              ; C51B
        db "'#'#'#'#'$f"                                ; C522
        db 000h,066h,000h,067h,02Eh,066h,000h,065h,001h,067h,016h,066h,000h,066h,020h,066h; C52D
        db 000h,066h,000h,066h,000h,066h,000h,066h,000h,066h,000h,066h,000h,066h,001h,066h; C53D
        db 000h,007h,038h,066h,000h,066h,000h              ; C54D
        db "e.e.e.e.e.f"                                ; C554
        db 000h,066h,000h,066h,000h,066h,000h,066h,000h,027h,022h; C55F
        db "'#'#'#'#'$f"                                ; C56A
        db 000h                                            ; C575
        db "g.g.f"                                      ; C576
        db 000h,064h,039h,067h,016h,066h,020h,066h,000h,066h,000h,066h,001h,066h,000h,066h; C57B
        db 000h,065h,02Eh,066h,000h,066h,000h,066h,000h,066h,000h,066h,000h,066h,000h,066h; C58B
        db 000h,066h,000h,066h,000h,065h,02Eh,066h,000h,066h,000h,066h,000h,066h,000h,066h; C59B
        db 000h,066h,000h,066h,000h                        ; C5AB
        db "'''('('('(')f"                              ; C5B0
        db 000h                                            ; C5BD
        db "g.g.f"                                      ; C5BE
        db 000h,064h,039h,066h,00Ch,066h,000h,066h,08Ah,066h,000h,066h,020h,066h,000h,066h; C5C3
        db 000h                                            ; C5D3
        db "f f f"                                      ; C5D4
        db 08Ah,066h,000h,066h,000h,066h,000h,066h,000h,066h,000h,066h,08Ah,066h,000h,066h; C5D9
        db 000h,066h,000h,066h,000h,067h,02Eh,066h,08Ah,066h,000h,066h,000h,066h,000h,066h; C5E9
        db 000h,066h,000h,066h,000h,066h,000h,066h,000h,066h,08Ah,066h,000h,066h,000h,066h; C5F9
        db 000h,066h,000h,000h,0B4h,006h,086h,066h,087h,066h,089h,066h,087h,066h,087h,066h; C609
        db 087h,066h,087h,066h,087h,066h,087h,066h,089h,066h,087h,066h,087h,066h,087h,066h; C619
        db 087h,066h,087h,066h,089h,066h,087h,066h,087h,066h,087h,066h,087h,066h,087h,066h; C629
        db 089h,066h,087h,066h,087h,066h,087h,066h,087h,066h,087h,066h,087h,066h,087h,066h; C639
        db 087h,066h,089h,066h,087h,066h,087h,000h,0B1h,000h,0B2h,000h,0B3h,000h,0BDh,066h; C649
        db 013h,066h,094h,066h,013h,066h,013h,066h,013h,066h,013h,066h,013h,066h,013h,066h; C659
        db 094h,066h,013h,066h,013h,066h,013h,066h,013h,066h,013h,066h,094h,066h,013h,066h; C669
        db 013h,066h,013h,066h,013h,066h,013h,066h,094h,066h,013h,066h,013h,066h,013h,066h; C679
        db 013h,066h,013h,066h,013h,066h,013h,066h,013h,066h,094h,066h,013h,066h,013h,066h; C689
        db 013h,066h,013h,066h,013h                        ; C699
LC69E:
        db 076h,08Fh,076h,08Bh,076h,08Bh,076h,099h,076h,099h,076h,012h,076h,08Bh,076h,08Bh; C69E
        db 076h,099h,076h,08Bh,076h,099h,076h,08Bh,076h,099h,076h,08Bh,076h,099h,076h,08Bh; C6AE
        db 076h,08Bh,076h,090h,076h,00Ch,075h,005h,077h,000h,077h,000h,076h,000h,076h,012h; C6BE
        db 077h,000h,077h,000h,077h,000h,077h,000h,077h,000h,077h,000h,077h,000h,077h,000h; C6CE
        db 077h,000h,077h,000h,076h,000h,076h,00Dh,076h,016h,077h,000h,077h,000h,077h,000h; C6DE
        db 076h,01Ah,076h,012h,077h,000h,077h,000h,077h,000h,075h,005h,077h,000h,077h,000h; C6EE
        db 077h,000h,077h,000h,036h,038h,077h,000h,076h,01Ah,076h,00Dh,076h,00Ch,077h,000h; C6FE
        db 077h,000h,077h,000h,077h,000h,076h,012h,077h,000h,074h,02Eh,077h,000h,077h,000h; C70E
        db 077h,000h,077h,000h,077h,000h,077h,000h,077h,000h,077h,000h,077h,000h,076h,00Dh; C71E
        db 076h,016h,077h,000h,076h,005h,077h,000h,075h,001h,076h,012h,077h,000h,074h,02Eh; C72E
        db 077h,000h,077h,000h,077h,000h,077h,000h,077h,000h,077h,000h,077h,000h,075h,005h; C73E
        db 077h,000h,076h,00Dh,076h,00Ch,077h,000h,077h,000h,077h,000h,075h,001h,076h,012h; C74E
        db 077h,000h,074h,02Eh,077h,000h,077h,000h,076h,081h,075h,001h,075h,001h,077h,000h; C75E
        db 077h,000h,077h,000h,077h,000h,076h,00Dh,076h,016h,074h,02Eh,077h,000h,074h,02Eh; C76E
        db 075h,001h,076h,012h,076h,011h,076h,01Fh,077h,000h,076h,012h,076h,011h,076h,098h; C77E
        db 076h,011h,076h,011h,076h,011h,076h,011h,076h,011h,076h,011h,076h,016h,077h,000h; C78E
        db 077h,000h,077h,000h,075h,001h,076h,012h,077h,000h,077h,000h,077h,000h,076h,012h; C79E
        db 075h,02Eh,077h,000h,077h,000h                   ; C7AE
        db "u9u9w"                                      ; C7B4
        db 000h,077h,000h,077h,000h,076h,00Ch,027h,0A7h,027h,0A9h,077h,000h,074h,030h,076h; C7B9
        db 012h,077h,000h,075h,002h,075h,003h,076h,012h,075h,02Eh,077h,000h,077h,000h,077h; C7C9
        db 000h,077h,000h,077h,000h,077h,017h,077h,000h,076h,016h; C7D9
        db "''')w"                                      ; C7E4
        db 000h,075h,001h,076h,012h,075h,002h,075h,003h,077h,000h,076h,012h,075h,02Eh,077h; C7E9
        db 000h,077h,000h,077h,000h,077h,000h,077h,000h,077h,000h,077h,000h,076h,00Ch,077h; C7F9
        db 000h,077h,000h,077h,000h,075h,001h,076h,012h,077h,000h,077h,000h,077h,000h,076h; C809
        db 012h,076h,011h,076h,011h,076h,012h,076h,011h,076h,01Fh,076h,000h,076h,01Eh,076h; C819
        db 090h,076h,016h,077h,000h,077h,000h,077h,000h,075h,001h,076h,012h,076h,01Fh,077h; C829
        db 000h,076h,01Eh,076h,03Bh,077h,000h,076h,000h,076h,012h,077h,000h,077h,000h,077h; C839
        db 000h,077h,000h,076h,00Dh,076h,00Ch,077h,000h,077h,000h,077h,000h,075h,001h,076h; C849
        db 012h,075h,030h,077h,000h,077h,000h,075h,001h,077h,000h,076h,01Ah,076h,012h,077h; C859
        db 000h,077h,000h,075h,005h,077h,000h,076h,00Dh,076h,016h,077h,000h,074h,02Eh,077h; C869
        db 000h,077h,000h,076h,012h,077h,000h,077h,000h,077h,000h,075h,001h,077h,000h,077h; C879
        db 000h,076h,012h,077h,000h,077h,000h,077h,000h,077h,000h,076h,00Dh,076h,00Ch,076h; C889
        db 000h,077h,000h,077h,000h,077h,000h,076h,03Bh,077h,000h,077h,000h,077h,000h,075h; C899
        db 001h,075h,001h,077h,000h,076h,03Bh,075h,001h,077h,000h,077h,000h,077h,000h,076h; C8A9
        db 00Dh,076h,016h,076h,01Ah,077h,000h,077h,000h,077h,000h,077h,000h,077h,000h,075h; C8B9
        db 005h,077h,000h,077h,000h,077h,000h,077h,000h,077h,000h,077h,000h,075h,001h,077h; C8C9
        db 000h,076h,000h,076h,00Dh,076h,00Ch,077h,000h,077h,000h,075h,005h,077h,000h,076h; C8D9
        db 0BBh,077h,000h,077h,000h,077h,000h,077h,000h,077h,000h,077h,000h,076h,0BBh,077h; C8E9
        db 000h,077h,000h,077h,000h,076h,01Ah,076h,00Dh,076h,00Fh,076h,00Bh,076h,019h,076h; C8F9
        db 019h,076h,019h,076h,012h,076h,00Bh,076h,00Bh,076h,019h,076h,019h,076h,019h,076h; C909
        db 00Bh,076h,012h,076h,00Bh,076h,019h,076h,019h,076h,019h,076h,010h,032h,08Fh,032h; C919
        db 099h,032h,08Bh,032h,08Bh,032h,099h,032h,08Bh,032h,099h,022h,012h,032h,08Bh,032h; C929
        db 08Bh,032h,00Eh,032h,08Bh,032h,08Bh,032h,00Eh,032h,08Bh,032h,08Bh,032h,00Eh,032h; C939
        db 08Bh,032h,08Bh,032h,00Eh,032h,08Bh,032h,08Bh,032h,00Eh,032h,08Bh,032h,08Bh,032h; C949
        db 00Eh,032h,08Bh,032h,08Bh,032h,08Bh,032h         ; C959
LC961:
        db 08Bh,032h,08Bh,032h,08Bh,032h,08Bh,032h,08Bh,032h,08Bh,032h,090h,032h,00Ch,033h; C961
        db 000h,033h,000h,033h,000h,036h,005h,033h,000h,033h,000h,022h,012h,033h,000h,033h; C971
        db 000h,033h,00Ah,033h,000h,033h,020h,033h,00Ah,033h,020h,033h,000h,033h,00Ah,033h; C981
        db 000h,033h,000h,033h,00Ah,033h,000h,033h,020h,033h,00Ah,033h,000h,033h,000h,033h; C991
        db 00Ah,033h,000h,033h,000h,033h,000h,033h,000h,033h,000h,033h,000h,033h,000h,036h; C9A1
        db 000h,033h,039h,032h,00Dh,032h,016h,033h,000h,022h,004h,033h,000h,033h,000h,033h; C9B1
        db 000h,033h,000h,022h,012h,033h,020h,033h,000h,033h,000h,033h,020h,033h,000h,033h; C9C1
        db 000h,033h,000h,033h,000h,033h,000h,033h,020h,033h,000h,033h,000h,033h,000h,033h; C9D1
        db 000h,033h,000h,033h,020h,033h,000h,033h,000h    ; C9E1
        db "3 3 3"                                      ; C9EA
        db 000h,033h,000h,033h,000h,033h,000h,033h,000h,036h,000h,033h,000h,032h,00Dh,032h; C9EF
        db 00Ch,033h,000h,033h,000h,032h,000h,033h,000h,032h,02Eh,033h,000h,022h,012h,033h; C9FF
        db 000h,033h,000h,033h,000h,033h,001h,033h,001h,033h,000h,033h,001h,033h,000h,033h; CA0F
        db 000h,033h,020h,033h,000h,033h,000h,033h,000h,033h,000h,033h,000h,033h,020h,033h; CA1F
        db 000h,033h,000h,033h,000h,033h,000h,033h,000h,033h,000h,004h,038h,033h,000h,033h; CA2F
        db 000h,033h,000h,033h,000h,032h,00Dh,032h,016h,033h,000h,033h,000h,032h,000h,033h; CA3F
        db 000h,033h,000h,033h,000h,022h,012h,033h,000h,033h,000h,033h,000h,033h,001h,036h; CA4F
        db 000h,033h,000h,033h,001h,033h,000h,027h,0A7h,027h,0A8h,027h,0A8h,027h,0A8h,027h; CA5F
        db 0A8h,027h,0A8h,027h,0A8h,027h,0A9h,033h,000h,033h,000h,033h,000h,033h,000h,033h; CA6F
        db 000h,004h,038h,033h,000h,033h,000h,033h,000h,033h,000h,033h,000h,032h,08Dh,032h; CA7F
        db 00Ch                                            ; CA8F
        db "2.7.6.5.3"                                  ; CA90
        db 000h,033h,000h,022h,012h,033h,000h,033h,000h,033h,000h,033h,001h,036h,01Ah,036h; CA99
        db 000h,033h,001h,033h,000h,027h,022h              ; CAA9
        db "'#'#'#'#'#'#'$3"                            ; CAB0
        db 000h,033h,039h,033h,000h,033h,000h,004h         ; CABF
        db "8583"                                       ; CAC7
        db 000h,033h,000h,004h,038h,033h,000h,033h,000h,032h,00Dh,032h,00Ch,033h,000h,033h; CACB
        db 000h,037h,000h,032h,000h,033h,000h,037h,030h,022h,012h,033h,000h,033h,000h,033h; CADB
        db 000h,033h,001h,033h,001h,033h,001h,033h,001h,033h,000h,027h,022h; CAEB
        db "'#'#'#'#'#'#'$3"                            ; CAF8
        db 000h,033h,039h,033h,000h,027h,0A7h,027h,0A8h,027h,0A8h,027h,0A8h,027h,0A9h,033h; CB07
        db 000h,033h,000h,033h,000h,032h,00Dh,032h,03Ah,032h,011h,032h,01Fh,032h,000h,032h; CB17
        db 01Eh,032h,011h,032h,011h,032h,03Bh,033h,000h,033h,000h,033h,000h,033h,000h,033h; CB27
        db 000h,033h,000h,033h,000h,033h,000h              ; CB37
        db "'''('('('('('(')3"                          ; CB3E
        db 000h,033h,000h,033h,000h,027h,022h              ; CB4F
        db "'#'#'#'$3"                                  ; CB56
        db 000h,033h,000h,033h,000h,032h,00Dh,032h,00Ch,032h,000h,032h,000h,033h,000h,032h; CB5F
        db 000h,033h,000h,033h,000h,033h,000h,033h,000h,033h,000h,033h,000h,033h,000h,033h; CB6F
        db 000h,033h,000h,033h,000h,033h,000h,033h,000h,033h,080h,033h,000h,033h,000h,033h; CB7F
        db 000h,033h,000h,033h,000h,033h,000h,033h,000h,033h,000h,033h,000h,027h,022h; CB8F
        db "'#'#'#'$3"                                  ; CB9E
        db 080h,033h,000h,033h,001h,032h,00Dh,032h,03Ah,032h,01Fh,032h,000h,032h,01Eh,032h; CBA7
        db 011h,032h,011h,032h,011h,032h,0BBh,033h,000h,033h,000h,033h,000h,033h,000h,033h; CBB7
        db 000h,035h,008h,033h,000h,033h,000h,033h,000h,033h,000h,033h,000h,033h,000h,033h; CBC7
        db 000h,033h,000h,033h,000h,033h,000h,033h,000h,033h,008h,033h,000h,027h,022h; CBD7
        db "'#'#'#'$3"                                  ; CBE6
        db 000h,035h,02Eh,033h,000h,032h,00Dh,032h,00Ch,033h,000h,032h,000h,033h,000h,032h; CBEF
        db 000h,032h,005h,033h,000h,032h,012h,033h,000h,033h,000h,033h,000h,033h,000h,033h; CBFF
        db 000h,033h,000h,033h,000h,033h,000h,027h,0A7h,027h,0A8h,027h,0A8h,027h,0A8h,027h; CC0F
        db 0A8h,027h,0A8h,027h,0A8h,027h,0A9h,033h,000h,033h,000h,033h,000h,027h,022h; CC1F
        db "'#'#'#'$3"                                  ; CC2E
        db 001h,033h,000h,033h,000h,032h,00Dh,032h,00Ch,037h,000h,032h,000h,033h,000h,032h; CC37
        db 000h,033h,000h,033h,000h,022h,012h              ; CC47
        db "7.7.3"                                      ; CC4E
        db 000h,033h,000h,033h,000h,033h,000h,033h,000h,033h,000h,027h,022h; CC53
        db "'#'#'#'#'#'#'$3"                            ; CC60
        db 000h,033h,000h,033h,000h                        ; CC6F
        db "'''('('(')3"                                ; CC74
        db 001h,033h,000h,033h,000h,032h,00Dh,032h,00Ch,033h,000h,032h,000h,033h,000h,032h; CC7F
        db 000h                                            ; CC8F
        db "7.7."                                       ; CC90
        db 022h,012h,033h,000h,033h,000h,033h,000h,033h,000h,033h,000h,033h,000h,033h,000h; CC94
        db 033h,000h,027h,022h,027h,0A3h                   ; CCA4
        db "'#'#'#'#'#'$3"                              ; CCAA
        db 000h,033h,039h,033h,000h,033h,000h,033h,000h,033h,000h,033h,000h,033h,001h,033h; CCB7
        db 000h,033h,000h,033h,000h,032h,00Dh,032h,016h,033h,000h,032h,000h,033h,000h,033h; CCC7
        db 000h,033h,000h,033h,000h,022h,012h,033h,000h,033h,000h,033h,000h,033h,000h,037h; CCD7
        db 030h,033h,000h,033h,000h,033h,000h              ; CCE7
        db "'''('('('('('(')39393"                      ; CCEE
        db 000h,033h,000h,033h,001h,033h,000h,032h,01Eh,032h,011h,032h,011h,032h,011h,032h; CD03
        db 011h,032h,03Ch,032h,00Ch,032h,000h,032h,001h,033h,000h,032h,000h,032h,000h,037h; CD13
        db 02Eh,022h,012h,037h,02Eh,033h,000h,033h,000h,033h,000h,033h,000h,033h,000h,033h; CD23
        db 020h,033h,000h,033h,000h,033h,020h,033h,000h,033h,000h,033h,000h,033h,000h,033h; CD33
        db 000h,033h,000h,033h,000h,033h,000h,033h,000h,033h,039h,033h,000h,033h,000h,033h; CD43
        db 000h,033h,000h,033h,000h,033h,000h,037h,030h,032h,00Dh,032h,016h,036h,000h,032h; CD53
        db 001h,033h,000h,032h,001h,032h,000h,033h,000h,022h,012h,033h,020h,033h,000h,033h; CD63
        db 000h,033h,000h,033h,020h,033h,000h,033h,020h,033h,000h,033h,000h,033h,020h,033h; CD73
        db 000h,033h,020h,033h,000h,033h,020h,033h,000h,033h,000h,033h,020h,033h,000h,033h; CD83
        db 000h,033h,039h,033h,000h,033h,000h,032h,0BBh,036h,000h,033h,000h,033h,000h,033h; CD93
        db 000h,032h,00Dh,032h,00Ch,036h,01Ah,032h,001h,033h,000h,032h,000h,032h,000h,037h; CDA3
        db 030h,022h,012h,033h,000h,033h,000h,033h,08Ah,033h,000h,033h,000h,033h,08Ah,033h; CDB3
        db 000h,033h,000h,033h,08Ah,033h,000h,033h,000h,033h,08Ah,033h,000h,033h,000h,033h; CDC3
        db 08Ah,033h,000h,033h,020h,033h                   ; CDD3
LCDD9:
        db 08Ah,033h,000h,033h,000h,033h,000h,033h,000h,022h,012h,036h,000h,033h,000h,033h; CDD9
        db 000h,033h,000h,032h,00Dh,032h,00Fh,032h,00Bh,032h,019h,032h,00Bh,032h,019h,032h; CDE9
        db 00Bh,032h,019h,022h,012h,032h,00Bh,032h,00Bh,032h,08Eh,032h,00Bh,032h,00Bh,032h; CDF9
        db 08Eh,032h,00Bh,032h,00Bh,032h,08Eh,032h,00Bh,032h,00Bh,032h,08Eh,032h,00Bh,032h; CE09
        db 00Bh,032h,08Eh,032h,00Bh,032h,00Bh,032h,08Eh,032h,00Bh,032h,00Bh,032h,00Bh,032h; CE19
        db 00Bh,022h,012h,032h,00Bh,032h,00Bh,032h,00Bh,032h,00Bh,032h,010h,022h,08Fh,022h; CE29
        db 08Bh,022h,08Bh,022h,08Bh,022h,08Bh,022h,08Bh,022h,08Bh,022h,08Bh,022h,08Bh,022h; CE39
        db 08Bh,022h,08Bh,022h,08Bh,022h,08Bh,022h,08Bh,022h,08Bh,022h,08Bh,022h,08Bh,022h; CE49
        db 08Bh,022h,08Bh,022h,08Bh,022h,08Bh,022h,012h,022h,08Bh,022h,08Bh,022h,08Bh,022h; CE59
        db 08Bh,022h,08Bh,022h,08Bh,022h,08Bh,022h,090h,022h,00Ch,022h,000h,022h,000h,022h; CE69
        db 001h,022h,000h,022h,000h,022h,000h,022h,000h,022h,000h,022h,000h,022h,000h,022h; CE79
        db 000h,022h,000h,022h,000h,022h,000h,022h,000h,022h,000h,022h,000h,022h,001h,022h; CE89
        db 000h,022h,000h,022h,012h,025h,030h,020h,000h,025h,030h,020h,000h,025h,030h,020h; CE99
        db 000h,025h,030h,022h,00Dh,022h,00Ch,022h,000h,022h,008h,022h,002h,022h,003h,022h; CEA9
        db 000h,022h,000h,022h,000h,022h,000h,022h,000h,022h,000h,023h,02Eh,022h,000h,022h; CEB9
        db 000h,022h,000h,022h,000h,022h,000h,022h,000h,023h,02Eh,022h,000h,022h,000h,022h; CEC9
        db 012h,025h,030h,020h,000h,025h,030h,020h,000h,025h,030h,020h,080h,025h,030h,022h; CED9
        db 00Dh,022h,00Ch,022h,000h,022h,000h,022h,001h,022h,000h,022h,000h,022h,000h,022h; CEE9
        db 039h,022h,000h,025h,02Eh,022h,000h              ; CEF9
        db "'0#."                                       ; CF00
        db 022h,000h,022h,000h,022h,000h,022h,000h,026h,000h,022h,02Eh,022h,000h,022h,000h; CF04
        db 022h,012h,025h,030h,020h,000h,025h,030h,020h,000h,025h,030h,020h,000h,025h,030h; CF14
        db 022h,00Dh,022h,00Ch,022h,000h,022h,000h,023h,02Eh,022h,000h,022h,000h,022h,000h; CF24
        db 022h,039h,022h,039h,022h,000h,022h,000h         ; CF34
        db "#.&.#.#.&."                                 ; CF3C
        db 022h,000h,026h,01Ah,022h,02Eh,022h,000h,022h,000h,022h,012h,025h,030h,020h,000h; CF46
        db 025h,030h,020h,000h,025h,030h,020h,000h,025h,030h,022h,00Dh,022h,00Ch,022h,000h; CF56
        db 022h,000h,022h,001h,022h,000h,022h,000h,022h,000h,022h,000h,022h,039h,022h,000h; CF66
        db 022h,000h,022h,000h,022h,000h,022h,000h         ; CF76
        db "#.'0"                                       ; CF7E
        db 022h,02Eh,023h,02Eh,022h,000h,022h,000h,022h,000h,022h,012h,020h,000h,020h,000h; CF82
        db 020h,000h,020h,000h,020h,000h,020h,000h,020h,000h,022h,00Dh,022h,00Ch,022h,000h; CF92
        db 022h,000h,022h,001h,022h,000h,022h,038h,022h,000h,022h,000h,022h,039h,022h,000h; CFA2
        db 022h,000h,022h,000h,022h,000h,022h,000h,022h,000h,022h,000h,022h,000h,022h,000h; CFB2
        db 022h,000h,022h,000h,022h,000h,022h,012h,025h,030h,020h,000h,025h,030h,020h,000h; CFC2
        db 025h,030h,020h,000h,025h,030h,022h,00Dh,022h,00Ch,022h,000h,022h,000h,022h,000h; CFD2
        db 022h,002h,022h,003h,022h,000h,022h,000h,022h,039h,022h,000h,022h,000h,022h,000h; CFE2
        db 022h,000h,022h,000h,022h,000h,022h,039h,022h,039h,022h,000h,022h,039h,022h,039h; CFF2
        db 022h,000h,022h,012h,025h,030h,020h,000h,025h,030h,020h,000h,025h,030h,020h,080h; D002
        db 025h,030h,022h,00Dh,022h,00Ch,022h,000h,022h,000h,022h,000h,022h,000h,022h,001h; D012
        db 022h,000h,022h,000h,022h,038h,022h,000h,022h,000h,022h,000h,026h,005h,022h,000h; D022
        db 022h,000h,022h,000h,022h,039h,022h,000h,022h,039h,022h,039h,022h,000h,022h,012h; D032
        db 025h,030h,020h,000h,025h,030h,020h,000h,025h,030h,020h,000h,025h,030h,022h,00Dh; D042
        db 022h,00Ch,022h,000h,022h,000h,022h,000h,022h,000h,022h,02Eh,022h,000h,022h,000h; D052
        db 022h,039h,022h,000h,022h,000h,022h,000h,022h,000h,022h,000h,022h,000h,022h,000h; D062
        db 022h,000h,022h,000h,022h,039h,022h,000h,022h,000h,022h,03Bh,022h,011h,022h,011h; D072
        db 022h,01Fh,020h,000h,022h,01Eh,022h,011h,022h,011h,022h,03Ch,022h,00Ch,022h,000h; D082
        db 022h,000h,022h,000h,022h,000h,022h,001h,022h,000h,022h,000h,022h,000h,022h,039h; D092
        db 022h,000h,022h,000h,022h,000h,022h,000h,022h,000h,026h,038h,022h,000h,022h,000h; D0A2
        db 022h,000h,022h,000h,022h,000h,022h,000h,020h,000h,020h,080h,020h,000h,022h,000h; D0B2
        db 022h,000h,020h,000h,022h,000h,022h,00Dh,022h,03Ah,022h,011h,022h,098h,022h,011h; D0C2
        db 022h,098h,022h,011h,022h,01Fh,022h,000h,022h,01Eh,022h,011h,022h,012h,022h,000h; D0D2
        db 022h,000h,022h,000h                             ; D0E2
        db "#.&8"                                       ; D0E6
        db 022h,000h,023h,02Eh,022h,000h,022h,000h,022h,000h; D0EA
        db "D8D8"                                       ; D0F4
        db 004h,038h,044h,038h,022h,000h,022h,000h,022h,000h,022h,000h,022h,00Dh,022h,00Ch; D0F8
        db 022h,000h,022h,000h,022h,000h,022h,000h,022h,000h,022h,000h,022h,000h,022h,000h; D108
        db 022h,000h,022h,012h,022h,000h,022h,000h,007h,038h,022h,000h,022h,001h,022h,000h; D118
        db 026h,038h,022h,001h,022h,001h,022h,001h,044h,038h,022h,000h,025h,000h,044h,038h; D128
        db 022h,000h,022h,000h,022h,000h,022h,000h,022h,00Dh,022h,00Ch,022h,036h,022h,000h; D138
        db 022h,036h,022h,000h,022h,036h,022h,000h,022h,036h,022h,000h,022h,020h,022h,012h; D148
        db 022h,000h,022h,000h,022h,000h,022h,000h,026h,038h,022h,000h,022h,000h,022h,000h; D158
        db 022h,000h,022h,000h,022h,000h,022h,000h,025h,01Ah,044h,038h,022h,000h,022h,000h; D168
        db 022h,000h,022h,000h,022h,00Dh,022h,00Ch,022h,037h,022h,000h,022h,037h,022h,000h; D178
        db 022h,037h,022h,000h,022h,037h,022h,000h,022h,020h,022h,012h,022h,039h,022h,000h; D188
        db 022h,000h,022h,000h                             ; D198
        db "#.&8#."                                     ; D19C
        db 022h,001h,022h,038h,022h,0B8h,022h,000h,022h,000h,022h,000h,044h,038h,022h,000h; D1A2
        db 022h,001h,022h,001h,022h,001h,022h,00Dh,022h,00Ch,022h,00Ah,022h,000h,022h,00Ah; D1B2
        db 022h,000h,022h,00Ah,022h,000h,022h,00Ah,022h,000h,022h,000h,022h,092h,022h,039h; D1C2
        db 022h,000h,022h,000h,022h,000h,022h,000h,022h,000h,022h,000h,022h,000h,022h,000h; D1D2
        db 022h,000h,022h,000h,020h,000h,022h,000h,044h,038h,022h,001h,022h,001h,022h,000h; D1E2
        db 022h,000h,022h,00Dh,022h,00Ch,022h,000h,022h,020h,022h,000h,022h,020h,022h,000h; D1F2
        db 022h,020h,022h,000h,022h,020h,025h,02Eh,022h,012h,022h,000h,022h,000h,004h,038h; D202
        db 004h,038h,022h,000h,022h,000h,022h,000h,022h,000h,022h,000h,022h,000h,022h,000h; D212
        db 020h,000h,022h,000h,022h,000h,022h,000h,022h,000h,022h,000h,022h,000h,022h,00Dh; D222
        db 022h,00Fh,022h,00Bh,022h,00Bh,022h,00Bh,022h,00Bh,022h,00Bh,022h,00Bh,022h,00Bh; D232
        db 022h,00Bh,022h,00Bh,022h,012h,022h,00Bh,022h,00Bh,022h,00Bh,022h,00Bh,022h,00Bh; D242
        db 022h,00Bh,022h,00Bh,022h,00Bh,022h,00Bh,022h,00Bh,022h,00Bh,022h,00Bh,022h,00Bh; D252
        db 022h,00Bh,022h,00Bh,022h,00Bh,022h,00Bh,022h,00Bh,022h,010h; D262
LD26E:
        db 01Bh,01Bh,01Bh,01Bh,01Bh,01Bh,01Bh,01Bh,01Bh,01Bh,01Bh,01Bh,01Bh,01Bh,01Bh,01Bh; D26E
        db 01Bh,01Bh,01Bh,01Bh,01Bh,01Bh,01Bh,01Bh,01Bh,01Eh,01Eh,017h,01Fh,01Fh,07Fh,01Ah; D27E
        db 01Ah,01Ah,01Ah,01Ah,01Ah,0F1h,0E1h,0D1h,091h,01Ah,0F1h,0F1h,0E1h,0F1h,0F1h,01Bh; D28E
        db 01Bh,0E7h,017h,01Fh,01Fh,01Fh,07Fh,01Ah,019h,019h,019h,019h,01Ah,0F1h,0E1h,0D1h; D29E
        db 091h,01Ah,0F1h,0F1h,0F1h,0F1h,0F1h,01Bh,01Bh,0F7h,017h,01Fh,01Fh,01Fh,07Fh,01Ah; D2AE
        db 019h,019h,019h,019h,01Ah,0F1h,0E1h,0D1h,091h,01Ah,0E1h,0E1h,0E1h,0E1h,0E1h,01Bh; D2BE
        db 01Bh,0F7h,017h,01Fh,01Fh,01Eh,07Fh,01Ah,019h,019h,019h,019h,01Ah,0F1h,0E1h,0D1h; D2CE
        db 091h,01Ah,0E1h,0E1h,0E1h,0E1h,0E1h,01Bh,01Bh,0F7h,017h,01Fh,01Fh,017h,07Eh,01Ah; D2DE
        db 019h,019h,019h,019h,01Ah,0F1h,0E1h,0D1h,091h,01Ah,0E1h,0E1h,0E1h,0E1h,0E1h,01Bh; D2EE
        db 01Bh,017h,01Eh,01Eh,01Eh,01Eh,01Eh,01Ah,01Ah,01Ah,01Ah,01Ah,01Ah,0F1h,0E1h,0D1h; D2FE
        db 091h,01Ah,0F1h,0E1h,0E1h,0E1h,0E1h,01Bh,01Bh,01Bh,01Bh,01Bh,01Bh,01Bh,01Bh,01Bh; D30E
        db 01Bh,01Bh,01Bh,01Bh,01Bh,01Bh,01Bh,01Bh,01Bh,01Bh,01Bh,01Bh,01Bh,01Bh,01Bh,01Bh; D31E
        db 0FFh,0FFh,000h,000h,0FCh,03Fh,000h,000h,0FBh,0DFh,003h,0C0h,0F4h,02Fh,004h,020h; D32E
        db 0FBh,0DFh,003h,0C0h,0FBh,05Fh,003h,040h,0FAh,05Fh,002h,040h,0FBh,05Fh,003h,040h; D33E
        db 0F6h,02Fh,006h,020h,0ECh,0D7h,00Ch,0D0h,0EEh,057h,00Eh,050h,0ECh,017h,00Ch,010h; D34E
        db 0EEh,017h,00Eh,010h,0F7h,0AFh,007h,0A0h,0FBh,0DFh,003h,0C0h,0FCh,03Fh,000h,000h; D35E
        db 0FFh,0FFh,0FFh,000h,000h,000h,0FFh,0FEh,003h,000h,000h,000h,0F8h,079h,0FDh,000h; D36E
        db 001h,0FCh,0F7h,086h,005h,007h,086h,004h,0EAh,0FAh,04Dh,00Ah,0FAh,04Ch,0ECh,000h; D37E
        db 00Bh,00Ch,000h,008h,0D8h,006h,017h,018h,006h,010h,0D4h,0F0h,08Bh,014h,0F0h,088h; D38E
        db 0D9h,09Eh,04Bh,019h,09Eh,048h,0D1h,003h,05Bh,011h,003h,058h,0D9h,015h,017h,019h; D39E
        db 015h,010h,0D0h,089h,097h,010h,089h,090h,0ECh,094h,097h,00Ch,094h,090h,0E8h,0C1h; D3AE
        db 0AFh,008h,0C1h,0A0h,0ECh,061h,097h,00Ch,061h,090h,0E8h,03Ch,0D3h,008h,03Ch,0D0h; D3BE
        db 0ECh,007h,05Dh,00Ch,007h,05Ch,0E9h,081h,08Ah,009h,081h,08Ah,0D4h,010h,01Ah,014h; D3CE
        db 010h,01Ah,0D9h,024h,00Eh,019h,024h,00Eh,0D0h,061h,016h,010h,061h,016h,0DBh,0DEh; D3DE
        db 0EDh,01Bh,0DEh,0ECh,0EEh,021h,01Bh,00Eh,000h,018h,0F1h,0FFh,0E7h,000h,000h,000h; D3EE
        db 000h                                            ; D3FE
