'PAINT Pattern command test code
'check out video for more information on the format

DECLARE SUB ReadPattern (pat$, size%)

SCREEN 1
CIRCLE (106, 100), 75, 1
LINE (138, 35)-(288, 165), 1, B

pat$ = ""

DIM im%(18)
FOR i = 0 TO 17
 READ im%(i)
NEXT i
PUT (20, 20), im%


RESTORE
CALL ReadPattern(pat$, 18)
INPUT x$
PAINT (160, 100), pat$, 1

'  QuickBASIC\QB64, Array Size= 18 Width= 8 Height= 8 Colors= 16
'  pat16

DATA &H0008,&H0008,&HFF00,&H0000,&H8100,&H0000,&H8100,&H3C3C
DATA &H9900,&H3C3C,&H9900,&H3C3C,&H8100,&H3C3C,&H8100,&H0000
DATA &HFF00,&H0000

SUB ReadPattern (pat$, size%)
 pat$ = ""
 READ patline%   'width  of image - we do not need for pattern - must 8 pixels wide
 READ patline%   'height
 
 FOR i = 1 TO size% - 2
   READ patline%
   pat$ = pat$ + MKI$(patline%)
 NEXT i
END SUB

