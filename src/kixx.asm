; Diferencias de la edición Kixx (textos en inglés y rótulo BULLETS del marcador).
; Se ensambla encima de la versión española con -DKIXX.

        org 09ED0h
        db "KEYS   "
        org 09EF2h
        db "KEYS  ",009h,"!0.- START"
        org 0A0D4h
        db 045h,005h,"BFIRE ",006h,"BUP    ",005h,"BDOWN ",009h,"BLEFT     ",007h,"BRIGHT  "
        org 0A28Fh
        db "MED BY: "
        org 0A2AAh
        db "PHICS BY: "
        org 0A2CEh
        db " BY:  "
        org 0A2FDh
        db "YOUR AMMUNITION GO DOWN AND  ",004h,01Fh,"   CANNOT OPEN THE CHEST    ",005h
        db 01Fh,"    GO CAREFULLY NEXT TIME    ",00Fh,"qPRESS ANY KEY  O!",002h
        db "THE TREASURE MAP IN IN YOURS",008h,01Fh,"         HANDS         "

        org 06028h
        db 01Eh,01Dh,01Dh,01Eh,019h,039h,03Eh
        org 060E8h
        db "mlllll8"
        org 061A8h
        db 0CEh,0C6h,0C6h,0C6h,0C6h,0D6h,0F7h
        org 06268h
        db ">>282",0BEh,0BEh
        org 06328h
        db 0FCh,0FDh,0B4h,"011x"
        org 063E8h
        db 0F0h,0D8h,0E8h,070h,0B8h,0F8h,0F0h
