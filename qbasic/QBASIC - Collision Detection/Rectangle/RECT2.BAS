DECLARE FUNCTION rectRect% (r1x%, r1y%, r1w%, r1h%, r2x%, r2y%, r2w%, r2h%)
' Point/Circle Collision Detection
' Based on Code by Jeffrey Thompson - https://www.jeffreythompson.org/collision-detection/
' Converted to QBasic by RetroNick - Aug 6 - 2021
'

DECLARE FUNCTION circleCircle% (c1x%, c1y%, c1r%, c2x%, c2y%, c2r%)

SCREEN 7

x% = 98
y% = 100
w% = 20
h% = 10



rx% = 100
ry% = 50
rwidth% = 100
rheight% = 50



lastx% = 0
lasty% = 0
lastw% = 0
lasth% = 0

a$ = ""



WHILE (a$ <> "q")
  a$ = INKEY$
  IF RIGHT$(a$, 1) = "K" THEN x% = x% - 1
  IF RIGHT$(a$, 1) = "M" THEN x% = x% + 1
  IF RIGHT$(a$, 1) = "P" THEN y% = y% + 1
  IF RIGHT$(a$, 1) = "H" THEN y% = y% - 1
 
  IF a$ = "s" THEN
     w% = w% - 1
     h% = h% - 1
  END IF

  IF a$ = "b" THEN
     w% = w% + 1
     h% = h% + 1
  END IF

  IF (lastx% <> x%) OR (lasty% <> y%) OR (lastw% <> w%) OR (lasth% <> h%) THEN
    lastx% = x%
    lasty% = y%
    lastw% = w%
    lasth% = h%
    CLS
    
    IF rectRect%(x%, y%, w%, h%, rx%, ry%, rwidth%, rheight%) = 1 THEN
       col% = 2 'green
       hit$ = "HIT"
    ELSE
       col% = 1 'blue
       hit$ = "NO HIT"
    END IF
    
    LINE (rx%, ry%)-(rx% + rwidth%, ry% + rheight%), col%, B
    LINE (x%, y%)-(x% + w%, y% + h%), 4, B
 
   
    LOCATE 1, 1
    COLOR 1
    PRINT "X= "; x%; " Y="; y%; "  "; hit$
  
    LOCATE 22, 1
    PRINT "arrow keys to move red circle"
    PRINT "s or b to make big or small"
    PRINT "q to quit";
  END IF

WEND

' RECTANGLE/RECTANGLE
FUNCTION rectRect% (r1x%, r1y%, r1w%, r1h%, r2x%, r2y%, r2w%, r2h%)

  ' are the sides of one rectangle touching the other?
  ' r1 right edge past r2 left
  ' r1 left edge past r2 right
  ' r1 top edge past r2 bottom
  ' r1 bottom edge past r2 top

  IF (r1x% + r1w% >= r2x%) AND (r1x% <= r2x% + r2w%) AND (r1y% + r1h% >= r2y%) AND (r1y% <= r2y% + r2h%) THEN
      rectRect% = 1
  ELSE
      rectRect% = 0
  END IF
END FUNCTION

