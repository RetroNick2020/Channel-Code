' Point/Circle Collision Detection
' Based on Code by Jeffrey Thompson - https://www.jeffreythompson.org/collision-detection/
' Converted to QBasic by RetroNick - Aug 6 - 2021
'

DECLARE FUNCTION pointCircle% (px%, py%, cx%, cy%, r%)
SCREEN 7

x% = 98
y% = 100
lastx% = 0
lasty% = 0
hit$ = ""
a$ = ""
WHILE (a$ <> "q")
  a$ = INKEY$
  IF RIGHT$(a$, 1) = "K" THEN x% = x% - 1
  IF RIGHT$(a$, 1) = "M" THEN x% = x% + 1
  IF RIGHT$(a$, 1) = "P" THEN y% = y% + 1
  IF RIGHT$(a$, 1) = "H" THEN y% = y% - 1
 
  IF (lastx% <> x%) OR (lasty% <> y%) THEN
    lastx% = x%
    lasty% = y%
    CLS
    
    IF pointCircle(x%, y%, 150, 100, 50) = 1 THEN
      COLOR 2
      hit$ = "HIT"
    ELSE
      COLOR 1
      hit$ = "NO HIT"
    END IF
    CIRCLE (150, 100), 50, , , , 1
    PSET (x%, y%), 4   'red
 
    LOCATE 1, 1
    COLOR 1
    PRINT "X= "; x%; " Y="; y%; "  "; hit$
  
    LOCATE 22, 1
    PRINT "arrow keys to move red pixel"
    PRINT "q to quit";

  END IF
WEND

FUNCTION pointCircle% (px%, py%, cx%, cy%, r%)
  'get distance between the point and circle's center
  'using the Pythagorean Theorem
  distX% = px% - cx%
  distY% = py% - cy%
  distance% = SQR((distX% * distX%) + (distY% * distY%))

  'if the distance is less than the circle's
  'radius the point is inside!
  IF (distance% <= r%) THEN
    pointCircle% = 1
  ELSE
    pointCircle% = 0
  END IF
END FUNCTION

