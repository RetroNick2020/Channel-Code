;Set EGA Palette with RGB values - Code for GW-BASIC By RetroNick
;Format: Call SetERGB(C%,R%,G%,B%) from GW-BASIC
;C% = Color 0 to 15, R% = 0 to 3, G% = 0 to 3, B% = 0 to 3
;Created Dec 16 - 2022
;Last Update Dec 16 - 2022
;MIT License
;See video Link
;
;Compile with TASM, tasm setergb.asm, link with TLINK, tlink setergb.obj creates setergb.exe
;use EXE2BIN tool to comvert setergb.exe to setergb.com
;use BIN2BSV tool convert GW-BASIC bsave/bload format file to setergb.bsv
;
;from GW-BASIC
;
;10 REM DRAW GREEN BOX - CHANGES RGB value of color 2 to Gray - box is Gray now
;20 DIM CODE%(200):REM 200 is just example - should be big enough to load file
;30 BLOAD "SETERGB.BSV",VARPTR(CODE%(0))
;40 SCREEN 9:REM EGA 640x350x16
;50 LINE(0,0)-(100,100),2,BF
;60 INPUT A$
;70 C%=2:R%=2:G%=2:B%=2
;80 SETERGB=VARPTR(CODE%(0)):CALL SETERGB(C%,R%,G%,B%)



code segment
assume cs:code,ds:code,es:code,ss:code


SETERGB PROC FAR
        PUBLIC SETERGB

          PUSH   BP
          MOV    BP,SP
          MOV    DL,0

TestBlueBit1:
          MOV    SI,[BP + 6] ;B
          MOV    AX,[SI]

          TEST   AL,1
          JNZ    BlueBitOn1

TestBlueBit2:
          TEST   AL,2
          JNZ    BlueBitOn2

TestGreenBit1:
          MOV    SI,[BP + 8] ;G
          MOV    AX,[SI]
          TEST   AL,1
          JNZ    GreenBitOn1

TestGreenBit2:
          TEST   AL,2
          JNZ    GreenBitOn2

TestRedBit1:
          MOV    SI,[BP + 10] ;R
          MOV    AX,[SI]
          TEST   AL,1
          JNZ    RedBitOn1

TestRedBit2:
          TEST   AL,2
          JNZ    RedBitOn2
          JMP    Done

BlueBitOn1:
          ADD    DL, 8
          JMP    TestBlueBit2

BlueBitOn2:
          ADD    DL, 1
          JMP    TestGreenBit1

GreenBitOn1:
          ADD    DL, 16
          JMP    TestGreenBit2

GreenBitOn2:
          ADD    DL, 2
          JMP    TestRedBit1

RedBitOn1:
          ADD    DL, 32
          JMP    TestRedBit2

RedBitOn2:
          ADD    DL,4

Done:
          MOV    SI,[BP + 12] ;Index Color
          MOV    CX,[SI]
          MOV    BL,CL
          MOV    BH,DL
          MOV    AH,10h
          MOV    AL,0
          INT    10h

          POP    BP
          RET    8

SETERGB ENDP

code ends
END
