'Original Code by Rich Geldreich to read actual GIF files
'Modified by RetroNick to read GIF from data statement
'Removed direct hardware access and other requirements like
'image having to be 320x200x256. Images can be smaller now
DEFINT A-Z

DECLARE SUB GifDataLoad ()
DECLARE FUNCTION shiftout(num as integer) 
DECLARE FUNCTION powersof2&(num as integer) 

DIM Prefix(4095) AS INTEGER, Suffix(4095) AS INTEGER, OutStack(4095) AS INTEGER
DIM ColPal(768) AS INTEGER

SCREEN 13
RESTORE TestImageLabel
GifDataLoad 

FUNCTION shiftout(num as integer) 
    SELECT CASE num
     CASE 1: shiftout=128
     CASE 2: shiftout=64
     CASE 3: shiftout=32
     CASE 4: shiftout=16
     CASE 5: shiftout=8
     CASE 6: shiftout=4
     CASE 7: shiftout=2
     CASE 8: shiftout=1
    END SELECT
END FUNCTION

FUNCTION powersof2&(num as integer) 
  powersof2&=2 ^ num
END FUNCTION

SUB GifDataLoad
DEFINT A-Z
DIM WorkCode AS LONG

a$ = ""
FOR ii = 1 TO 6
  GOSUB GetByte
  a$ = a$ + CHR$(a%)
NEXT ii

IF a$ <> "GIF87a" AND a$ <> "GIF89a" THEN PRINT "Not a GIF87a file.": END
GOSUB GetInteger
TotalX = a%

GOSUB GetInteger
TotalY = a%

GOSUB GetByte
NumColors = 2 ^ ((a% AND 7) + 1): NoPalette = (a% AND 128) = 0
GOSUB GetByte: Background = a%
GOSUB GetByte: IF a% <> 0 THEN PRINT "Bad screen descriptor.": END

IF NoPalette = 0 THEN 
  c=NumColors*3-1
  FOR ii=0 TO c
    GOSUB GetByte
    ColPal(ii)=a% 
  NEXT ii
END IF

DO
    GOSUB GetByte
    IF a% = 44 THEN
        GOTO exitdo
    ELSEIF a% <> 33 THEN
        PRINT "Unknown extension type.": END
    END IF
    GOSUB GetByte
    DO
      GOSUB GetByte
      a$ = SPACE$(a%)
      endloop = a%
      FOR i = 1 TO a%
        GOSUB GetByte
      NEXT i
    LOOP UNTIL endloop = 0
LOOP
exitdo:

GOSUB GetInteger
XStart = a%
GOSUB GetInteger
YStart = a%
GOSUB GetInteger
XLength = a%
GOSUB GetInteger
YLength = a%

XEnd = XStart + XLength: YEnd = YStart + YLength: GOSUB GetByte
IF a% AND 128 THEN PRINT "Can't handle local colormaps.": END
Interlaced = a% AND 64: PassNumber = 0: PassStep = 8
GOSUB GetByte
ClearCode = 2 ^ a%
EOSCode = ClearCode + 1
FirstCode = ClearCode + 2: NextCode = FirstCode
StartCodeSize = a% + 1: CodeSize = StartCodeSize
StartMaxCode = 2 ^ (a% + 1) - 1: MaxCode = StartMaxCode

BitsIn = 0: BlockSize = 0: BlockPointer = 1
x% = XStart: y% = YStart: Ybase = y% * 320

IF NoPalette = 0 THEN
    c%=NumColors-1
    FOR nn% = 0 TO c%
        r=ColPal(nn%*3)
        g=ColPal(nn%*3+1)
        b=ColPal(nn%*3+2)
        value&=65536 * b + 256 * g + r
        PALETTE nn%,_BGR(b,g,r)
    NEXT nn%
END IF

LINE (0, 0)-(319, 199), Background, BF
DO
    GOSUB GetCode
    IF Code <> EOSCode THEN
        IF Code = ClearCode THEN
            NextCode = FirstCode
            CodeSize = StartCodeSize
            MaxCode = StartMaxCode
            GOSUB GetCode
            CurCode = Code: LastCode = Code: LastPixel = Code
            PSET (x%, y%), LastPixel
            x% = x% + 1
            IF x% = XEnd THEN GOSUB NextScanLine
        ELSE
            CurCode = Code: StackPointer = 0
            IF Code > NextCode THEN goto exitdo2
            IF Code = NextCode THEN
                CurCode = LastCode
                OutStack(StackPointer) = LastPixel
                StackPointer = StackPointer + 1
            END IF

            WHILE (CurCode >= FirstCode) 
                OutStack(StackPointer) = Suffix(CurCode)
                StackPointer = StackPointer + 1
                CurCode = Prefix(CurCode)
            WEND

            LastPixel = CurCode
            PSET (x%, y%), LastPixel
            x% = x% + 1
            IF x% = XEnd THEN GOSUB NextScanLine
            StartLoop=StackPointer-1
            FOR a% = StartLoop TO 0 STEP -1
                PSET (x%, y%), OutStack(a%)
                x% = x% + 1
               IF x% = XEnd THEN GOSUB NextScanLine
            NEXT a%

            IF NextCode < 4096 THEN
                Prefix(NextCode) = LastCode
                Suffix(NextCode) = LastPixel
                NextCode = NextCode + 1
                IF NextCode > MaxCode AND CodeSize < 12 THEN
                    CodeSize = CodeSize + 1
                    MaxCode = MaxCode * 2 + 1
                END IF
            END IF
            LastCode = Code
        END IF
    END IF
LOOP UNTIL DoneFlag OR Code = EOSCode
exitdo2:
EXIT SUB

GetByte: READ a%: RETURN
GetInteger: READ t1%, t2%: a% = t2% * 256 + t1%: RETURN

NextScanLine:
    IF Interlaced THEN
        y% = y% + PassStep
        IF y% >= YEnd THEN
            PassNumber = PassNumber + 1
            SELECT CASE PassNumber
            CASE 1: y% = 4: PassStep = 8
            CASE 2: y% = 2: PassStep = 4
            CASE 3: y% = 1: PassStep = 2
            END SELECT
        END IF
    ELSE
        y% = y% + 1
    END IF
    x% = XStart: DoneFlag = y% > 199
RETURN
GetCode:
    IF BitsIn = 0 THEN
        GOSUB ReadBufferedByte
        LastChar = a%
        BitsIn = 8
    END IF
   
    WorkCode = LastChar \ shiftout(BitsIn)
    DO WHILE CodeSize > BitsIn
        GOSUB ReadBufferedByte: LastChar = a%
        WorkCode = WorkCode OR LastChar * powersof2&(BitsIn)
        BitsIn = BitsIn + 8
    LOOP
    BitsIn = BitsIn - CodeSize
    Code = WorkCode AND MaxCode
RETURN

ReadBufferedByte:
    IF BlockPointer > BlockSize THEN
       GOSUB GetByte: BlockSize = a%
       aa$ = ""
       FOR n = 1 TO BlockSize
       'a$ = SPACE$(BlockSize): GET #1, , a$
          GOSUB GetByte
          aa$ = aa$ + CHR$(a%)
       NEXT n
       a$ = aa$
       BlockPointer = 1
    END IF
    a% = ASC(MID$(a$, BlockPointer, 1)): BlockPointer = BlockPointer + 1
    'print "ReadBufferedByte value";a%
    'input dd$
RETURN
END SUB

TestImageLabel:
' test Size=1312
DATA 71,73,70,56,57,97,64,0,64,0
DATA 247,0,0,0,0,0,0,0,170,232
DATA 170,0,0,170,170,170,0,0,170,123
DATA 170,80,85,0,170,170,170,85,85,85
DATA 85,85,255,85,255,85,85,255,255,255
DATA 85,85,255,85,255,255,255,85,255,255
DATA 255,0,0,0,20,20,20,32,32,32
DATA 44,44,44,56,56,56,68,68,68,80
DATA 80,80,96,96,96,112,112,112,128,128
DATA 128,144,144,144,160,160,160,180,180,180
DATA 200,200,200,224,224,224,252,252,252,0
DATA 0,252,64,0,252,124,0,252,188,0
DATA 252,252,0,252,252,0,188,252,0,124
DATA 252,0,64,252,0,0,252,64,0,252
DATA 124,0,252,188,0,252,252,0,188,252
DATA 0,124,252,0,64,252,0,0,252,0
DATA 0,252,64,0,252,124,0,252,188,0
DATA 252,252,0,188,252,0,124,252,0,64
DATA 252,124,124,252,156,124,252,188,124,252
DATA 220,124,252,252,124,252,252,124,220,252
DATA 124,188,252,124,156,252,124,124,252,156
DATA 124,252,188,124,252,220,124,252,252,124
DATA 220,252,124,188,252,124,156,252,124,124
DATA 252,124,124,252,156,124,252,188,124,252
DATA 220,124,252,252,124,220,252,124,188,252
DATA 124,156,252,180,180,252,196,180,252,216
DATA 180,252,232,180,252,252,180,252,252,180
DATA 232,252,180,216,252,180,196,252,180,180
DATA 252,196,180,252,216,180,252,232,180,252
DATA 252,180,232,252,180,216,252,180,196,252
DATA 180,180,252,180,180,252,196,180,252,216
DATA 180,252,232,180,252,252,180,232,252,180
DATA 216,252,180,196,252,0,0,112,28,0
DATA 112,56,0,112,84,0,112,112,0,112
DATA 112,0,84,112,0,56,112,0,28,112
DATA 0,0,112,28,0,112,56,0,112,84
DATA 0,112,112,0,84,112,0,56,112,0
DATA 28,112,0,0,112,0,0,112,28,0
DATA 112,56,0,112,84,0,112,112,0,84
DATA 112,0,56,112,0,28,112,56,56,112
DATA 68,56,112,84,56,112,96,56,112,112
DATA 56,112,112,56,96,112,56,84,112,56
DATA 68,112,56,56,112,68,56,112,84,56
DATA 112,96,56,112,112,56,96,112,56,84
DATA 112,56,68,112,56,56,112,56,56,112
DATA 68,56,112,84,56,112,96,56,112,112
DATA 56,96,112,56,84,112,56,68,112,80
DATA 80,112,88,80,112,96,80,112,104,80
DATA 112,112,80,112,112,80,104,112,80,96
DATA 112,80,88,112,80,80,112,88,80,112
DATA 96,80,112,104,80,112,112,80,104,112
DATA 80,96,112,80,88,112,80,80,112,80
DATA 80,112,88,80,112,96,80,112,104,80
DATA 112,112,80,104,112,80,96,112,80,88
DATA 112,0,0,64,16,0,64,32,0,64
DATA 48,0,64,64,0,64,64,0,48,64
DATA 0,32,64,0,16,64,0,0,64,16
DATA 0,64,32,0,64,48,0,64,64,0
DATA 48,64,0,32,64,0,16,64,0,0
DATA 64,0,0,64,16,0,64,32,0,64
DATA 48,0,64,64,0,48,64,0,32,64
DATA 0,16,64,32,32,64,40,32,64,48
DATA 32,64,56,32,64,64,32,64,64,32
DATA 56,64,32,48,64,32,40,64,32,32
DATA 64,40,32,64,48,32,64,56,32,64
DATA 64,32,56,64,32,48,64,32,40,64
DATA 32,32,64,32,32,64,40,32,64,48
DATA 32,64,56,32,64,64,32,56,64,32
DATA 48,64,32,40,64,44,44,64,48,44
DATA 64,52,44,64,60,44,64,64,44,64
DATA 64,44,60,64,44,52,64,44,48,64
DATA 44,44,64,48,44,64,52,44,64,60
DATA 44,64,64,44,60,64,44,52,64,44
DATA 48,64,44,44,64,44,44,64,48,44
DATA 64,52,44,64,60,44,64,64,44,60
DATA 64,44,52,64,44,48,64,0,0,0
DATA 0,0,0,0,0,0,0,0,0,0
DATA 0,0,0,0,0,0,0,0,109,109
DATA 109,33,249,4,4,255,255,0,0,44
DATA 0,0,0,0,64,0,64,0,7,8
DATA 255,0,1,8,28,72,176,160,193,131
DATA 8,19,42,92,200,176,161,195,135,16
DATA 35,74,156,72,177,162,197,139,24,51
DATA 106,220,200,177,163,199,143,32,67,138
DATA 28,73,178,164,201,147,40,83,170,76
DATA 200,161,67,134,149,12,15,108,32,248
DATA 224,129,7,134,26,8,230,36,89,147
DATA 195,192,154,55,21,106,120,224,19,192
DATA 208,162,34,123,254,180,185,240,168,64
DATA 167,35,149,10,4,218,148,232,83,171
DATA 81,177,2,160,170,240,0,86,175,72
DATA 67,74,221,202,84,33,7,172,103,195
DATA 130,28,203,149,37,90,173,98,31,116
DATA 208,160,225,108,89,129,25,60,120,64
DATA 154,86,96,95,129,29,108,170,197,88
DATA 179,112,225,160,2,63,200,149,235,247
DATA 109,209,127,134,59,112,52,108,24,241
DATA 6,166,30,30,52,46,250,55,240,135
DATA 161,31,38,219,212,240,178,109,96,159
DATA 153,27,31,80,157,216,170,226,157,25
DATA 217,222,205,124,224,128,226,198,59,207
DATA 238,172,249,15,0,237,141,178,17,83
DATA 254,240,82,55,238,169,154,125,195,189
DATA 24,252,231,135,3,176,1,24,151,254
DATA 32,231,208,228,138,7,87,108,62,21
DATA 241,103,234,185,171,3,253,200,80,182
DATA 102,116,230,90,219,50,253,151,185,184
DATA 120,240,137,67,123,77,174,145,59,128
DATA 192,29,20,7,157,62,253,116,102,196
DATA 25,157,54,80,126,0,218,101,217,119
DATA 0,108,128,160,116,138,125,208,27,76
DATA 16,157,7,225,132,20,86,104,225,133
DATA 27,185,160,225,134,28,186,48,145,0
DATA 32,134,24,226,69,29,150,200,33,68
DATA 34,166,8,98,69,38,182,168,161,67
DATA 42,198,56,145,139,52,50,20,227,141
DATA 17,209,168,163,66,55,246,8,145,142
DATA 53,38,212,35,142,3,169,96,228,145
DATA 42,16,4,228,142,8,13,41,35,0
DATA 72,70,105,164,64,75,6,121,144,147
DATA 42,66,41,165,148,0,84,233,162,144
DATA 88,138,184,229,152,94,182,8,102,152
DATA 32,142,185,101,153,38,158,25,166,154
DATA 107,178,217,161,155,88,194,41,165,156
DATA 115,54,137,166,0,118,222,137,167,135
DATA 60,162,217,103,148,127,2,26,168,147
DATA 90,14,58,37,158,48,14,41,144,162
DATA 71,82,89,38,138,68,38,170,232,64
DATA 94,118,4,233,148,74,90,201,209,166
DATA 73,82,8,169,133,163,146,218,39,134
DATA 150,110,137,106,145,92,174,186,82,64
DATA 0,59