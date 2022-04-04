'Demonstrates changing EGA screen mode Palette with vga palettes
'SetVGAColor allow you to set using rgb values
'PaletteX works the same way as QuickBasic's Palette command
'Turbo/Power Basic's Palette command only works with EGA values
'PaletteX works with VGA values just like QuickBasic

'Used for REG command to make it easier to remember register names
%FLAGS=0
%AX=1
%BX=2
%CX=3
%DX=4
%SI=5
%DI=6
%BP=7
%DS=8
%ES=9

'try switching the various screen modes 7,8,9,12
SCREEN 7

'Set Palette using SetVGAColor
FOR i% = 0 TO 15
  READ r%, g%, b%
  Call SetVGAColor(i%, r%, g%, b%)
  LINE (i% * 15, 0)-(i% * 15 + 14, 50), i%, BF
NEXT i%

LOCATE 12,1
PRINT "Press Enter to Set default Palette Using PaletteX commands"
INPUT a$

'Set Palette using PaletteX
' Power/Turbo BASIC Palette Commands,  Size= 48 Colors= 16 Format=6 Bit
Call PaletteX (0, 0)
Call PaletteX( 1, 2752512)
Call PaletteX(2, 10752)
Call PaletteX(3, 2763264)
Call PaletteX(4, 42)
Call PaletteX(5, 2752554)
Call PaletteX(6, 5418)
Call PaletteX(7, 2763306)
Call PaletteX(8, 1381653)
Call PaletteX(9, 4134165)
Call PaletteX(10, 1392405)
Call PaletteX(11, 4144917)
Call PaletteX(12, 1381695)
Call PaletteX(13, 4134207)
Call PaletteX(14, 1392447)
Call PaletteX(15, 4144959)


INPUT a$

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

SUB PaletteX (ColorIndex%, ColorValue&)
  r%= 63 AND ColorValue&
  g%= (16128 AND ColorValue&) / 256
  b% =(4128768 and ColorValue&) / 65536   'this line overflows in TurboBasic.Use Alternate below
  Call SetVGAColor(ColorIndex%,r%,g%,b%)
END SUB

'Alternative PaletteX for TurboBasic
'SUB PaletteX (ColorIndex%, ColorValue&)
' o%=VARPTR(ColorValue&)
' s%=VARSEG(ColorValue&)
' DEF SEG = s%
' r%=PEEK(o%)
' g%=PEEK(o%+1)
' b%=PEEK(o%+2)
' Call SetVGAColor(ColorIndex%,r%,g%,b%)
'END SUB

SUB SetVGAColor(ColorIndex%, r%, g%, b%)
'Works in screen modes 7,8,9,12,13

'First Interrupt
 REG %AX, &H1000
 REG %BX, 256 * ColorIndex% + ColorIndex%
 CALL INTERRUPT &H10

'Second Interrupt
 REG %AX,  &H1010
 REG %BX, ColorIndex%
 REG %DX, 256 * r%
 REG %CX, 256 * g% + b%
 CALL INTERRUPT &H10

'Second Interrupt call can be replaced by these serious of OUT's
'Color index (0 to 255,rgb value 0 to 63)
'OUT &H3C8, ColorIndex%
'OUT &H3C9, r%
'OUT &H3C9, g%
'OUT &H3C9, b%
END SUB
