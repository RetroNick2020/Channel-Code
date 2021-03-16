rem color cycling demo by 
rem retronick's youtube channel

DEFINT A-Z
OPTION BASE 1

ON TIMER(1) GOSUB cycle

DIM image(247)
FOR i = 1 TO 247
  READ image(i)
NEXT

c = 0
SCREEN 13
PUT (50, 50), image, PSET

TIMER ON
WHILE INKEY$ = ""
WEND
END

cycle:
c = c + 1
IF c > 1 THEN c = 0
IF c = 0 THEN GOSUB pal1 ELSE GOSUB pal2
RETURN

pal2:
' QuickBASIC Palette Commands, 16 Colors, Format=6 Bit
PALETTE 10, 1381695
PALETTE 12, 1392405
RETURN

pal1:
' QuickBASIC Palette Commands, 16 Colors, Format=6 Bit
PALETTE 10, 1392405
PALETTE 12, 1381695
RETURN

bx2:
'  QuickBASIC\QB64, Array Size= 247 Width= 35 Height= 14 Colors= 256
'  bx2

DATA &H0118,&H000E,&H0A0A,&H0C00,&H000C,&H0A0A,&H0C00,&H000C
DATA &H0A0A,&H0C00,&H000C,&H0A0A,&H0C00,&H000C,&H0A0A,&H0C00
DATA &H000C,&H0A0A,&H0C00,&H0A0C,&H000A,&H0C0C,&H0A00,&H000A
DATA &H0C0C,&H0A00,&H000A,&H0C0C,&H0A00,&H000A,&H0C0C,&H0A00
DATA &H000A,&H0C0C,&H0A00,&H000A,&H0C0C,&H0000,&H0000,&H0000
DATA &H0000,&H0000,&H0000,&H0000,&H0000,&H0000,&H0000,&H0000
DATA &H0000,&H0000,&H0000,&H0000,&H0000,&H0000,&H0C00,&H000C
DATA &H0000,&H0000,&H0000,&H0000,&H0000,&H0000,&H0000,&H0000
DATA &H0000,&H0000,&H0000,&H0000,&H0000,&H0000,&H0000,&H0A0A
DATA &H0C0C,&H0000,&H0000,&H0000,&H0000,&H0000,&H0000,&H0000
DATA &H0000,&H0000,&H0000,&H0000,&H0000,&H0000,&H0000,&H0000
DATA &H0A00,&H000A,&H0000,&H0000,&H0000,&H0000,&H0000,&H0000
DATA &H0000,&H0000,&H0000,&H0000,&H0000,&H0000,&H0000,&H0000
DATA &H0000,&H0000,&H0000,&H0A0A,&H0000,&H0000,&H0000,&H0000
DATA &H0000,&H0000,&H0000,&H0000,&H0000,&H0000,&H0000,&H0000
DATA &H0000,&H0000,&H0000,&H0C00,&H0A0C,&H000A,&H0000,&H0000
DATA &H0000,&H0000,&H0000,&H0000,&H0000,&H0000,&H0000,&H0000
DATA &H0000,&H0000,&H0000,&H0000,&H0000,&H0C0C,&H0000,&H0000
DATA &H0000,&H0000,&H0000,&H0000,&H0000,&H0000,&H0000,&H0000
DATA &H0000,&H0000,&H0000,&H0000,&H0000,&H0000,&H0000,&H0C00
DATA &H000C,&H0000,&H0000,&H0000,&H0000,&H0000,&H0000,&H0000
DATA &H0000,&H0000,&H0000,&H0000,&H0000,&H0000,&H0000,&H0000
DATA &H0A0A,&H0C0C,&H0000,&H0000,&H0000,&H0000,&H0000,&H0000
DATA &H0000,&H0000,&H0000,&H0000,&H0000,&H0000,&H0000,&H0000
DATA &H0000,&H0A00,&H000A,&H0000,&H0000,&H0000,&H0000,&H0000
DATA &H0000,&H0000,&H0000,&H0000,&H0000,&H0000,&H0000,&H0000
DATA &H0000,&H0000,&H0000,&H0000,&H0A0A,&H0C00,&H000C,&H0A0A
DATA &H0C00,&H000C,&H0A0A,&H0C00,&H000C,&H0A0A,&H0C00,&H000C
DATA &H0A0A,&H0C00,&H000C,&H0A0A,&H0C00,&H0A0C,&H000A,&H0C0C
DATA &H0A00,&H000A,&H0C0C,&H0A00,&H000A,&H0C0C,&H0A00,&H000A
DATA &H0C0C,&H0A00,&H000A,&H0C0C,&H0A00,&H000A,&H0C0C
