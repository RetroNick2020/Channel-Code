DECLARE FUNCTION pointRect% (px%, py%, rx%, ry%, rw%, rh%)
' Point/Rectangle Collision Detection
' Based on Code by Jeffrey Thompson - https://www.jeffreythompson.org/collision-detection/
' Converted to QBasic by RetroNick - Aug 6 - 2021
'

SCREEN 7

x% = 98
y% = 100

rx% = 100
ry% = 50
rwidth% = 100
rheight% = 50

lastx% = 0
lasty% = 0
hit$ = ""
a$ = ""
col% = 1
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
    
    IF pointRect(x%, y%, rx%, ry%, rwidth%, rheight%) = 1 THEN
      col% = 2
      hit$ = "HIT"
    ELSE
      col% = 1
      hit$ = "NO HIT"
    END IF
    LINE (rx%, ry%)-(rx% + rwidth%, ry% + rheight%), col%, B
    PSET (x%, y%), 4   'red
 
    LOCATE 1, 1
    COLOR 1
    PRINT "X= "; x%; " Y="; y%; "  "; hit$
  
    LOCATE 22, 1
    PRINT "arrow keys to move red pixel"
    PRINT "q to quit";

  END IF
WEND

' POINT/RECTANGLE
FUNCTION pointRect% (px%, py%, rx%, ry%, rw%, rh%)

  ' is the point inside the rectangle's bounds?
  ' right of the left edge AND
  ' left of the right edge AND
  ' below the top AND
  ' above the bottom

  IF (px% >= rx%) AND (px% <= rx% + rw%) AND (py% >= ry%) AND (py% <= ry% + rh%) THEN
      pointRect% = 1
  ELSE
      pointRect% = 0
  END IF
END FUNCTION

