'Demonstrates changing EGA screen modes with vga palettes
'See video https://youtu.be/ymStJI8dmzU

DECLARE SUB SetVGAColor (ColorIndex%, r%, g%, b%)
REM $INCLUDE: 'qb.bi'

DECLARE SUB SetVGAColor (attr AS INTEGER, r AS INTEGER, g AS INTEGER, b AS INTEGER)
PALETTE
'try switching the various screen modes 7,8,9,12,13
SCREEN 7

FOR i% = 0 TO 15
  READ r%, g%, b%
  CALL SetVGAColor(i%, r%, g%, b%)
  LINE (i% * 15, 0)-(i% * 15 + 14, 50), i%, BF
NEXT i%

'INPUT a$

PaletteLabel:
' QuickBASIC Palette,  Size= 48 Colors= 16 Format=6 Bit
DATA 0, 0, 0
DATA 42, 63, 21
DATA 42, 42, 21
DATA 63, 42, 21
DATA 63, 63, 63
DATA 21, 21, 21
DATA 63, 63, 42
DATA 63, 42, 0
DATA 63, 63, 63
DATA 63, 21, 21
DATA 42, 42, 42
DATA 21, 42, 63
DATA 0, 42, 42
DATA 63, 21, 0
DATA 42, 21, 21
DATA 63, 63, 63


SUB SetVGAColor (ColorIndex%, r%, g%, b%)
'Works in screen modes 7,8,9,12,13
DIM Reg AS RegType
DIM OReg AS RegType

Reg.ax = &H1000
Reg.bx = 256 * ColorIndex% + ColorIndex%
CALL INTERRUPT(&H10, Reg, OReg)

Reg.ax = &H1010
Reg.bx = ColorIndex%
Reg.dx = 256 * r%
Reg.cx = 256 * g% + b%
CALL INTERRUPT(&H10, Reg, OReg)

'Second Interrupt call can be replaced by these serious of OUT's
'Color index (0 to 255,rgb value 0 to 63)
'OUT &H3C8, ColorIndex%
'OUT &H3C9, r%
'OUT &H3C9, g%
'OUT &H3C9, b%

END SUB

