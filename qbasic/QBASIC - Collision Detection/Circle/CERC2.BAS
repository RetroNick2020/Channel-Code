' Point/Circle Collision Detection
' Based on Code by Jeffrey Thompson - https://www.jeffreythompson.org/collision-detection/
' Converted to QBasic by RetroNick - Aug 6 - 2021
'

DECLARE FUNCTION circleCircle% (c1x%, c1y%, c1r%, c2x%, c2y%, c2r%)

SCREEN 7

x% = 90
y% = 100
r% = 5
lastx% = 0
lasty% = 0
lastr% = 0
a$ = ""
WHILE (a$ <> "q")
  a$ = INKEY$
  IF RIGHT$(a$, 1) = "K" THEN x% = x% - 1
  IF RIGHT$(a$, 1) = "M" THEN x% = x% + 1
  IF RIGHT$(a$, 1) = "P" THEN y% = y% + 1
  IF RIGHT$(a$, 1) = "H" THEN y% = y% - 1
  IF a$ = "s" THEN r% = r% - 1
  IF a$ = "b" THEN r% = r% + 1
  IF (lastx% <> x%) OR (lasty% <> y%) OR (lastr% <> r%) THEN
    lastx% = x%
    lasty% = y%
    lastr% = r%
    CLS
    
    IF circleCircle%(x%, y%, r%, 150, 100, 50) = 1 THEN
       COLOR 2  'green
       hit$ = "HIT"
    ELSE
       COLOR 1  'blue
       hit$ = "NO HIT"
    END IF
    CIRCLE (150, 100), 50, , , , 1  ' blue or green
    CIRCLE (x%, y%), r%, 4, , , 1   ' 4 is for color red
    
   
    LOCATE 1, 1
    COLOR 1
    PRINT "X= "; x%; " Y="; y%; "  "; hit$
  
    LOCATE 22, 1
    PRINT "arrow keys to move red circle"
    PRINT "s or b to make big or small"
    PRINT "q to quit";
  END IF

WEND

' CIRCLE/CIRCLE
FUNCTION circleCircle% (c1x%, c1y%, c1r%, c2x%, c2y%, c2r%)
  ' get distance between the circle's centers
  ' use the Pythagorean Theorem to compute the distance
  distX% = c1x% - c2x%
  distY% = c1y% - c2y%
  distance% = SQR((distX% * distX%) + (distY% * distY%))

  ' if the distance is less than the sum of the circle's
  ' radii, the circles are touching!
  IF (distance% <= c1r% + c2r%) THEN
    circleCircle% = 1
  ELSE
    circleCircle% = 0
  END IF
END FUNCTION

