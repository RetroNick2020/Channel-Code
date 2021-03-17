DECLARE FUNCTION stackpoint.count% ()

TYPE pt
     x AS INTEGER
     y AS INTEGER
END TYPE

DIM SHARED plist(1000) AS pt


DECLARE SUB stackpoint.init ()
DECLARE SUB stackpoint.pop (mypt AS pt)
DECLARE SUB stackpoint.push (mypt AS pt)
DECLARE SUB floodfill (px AS INTEGER, py AS INTEGER, replacementColor AS INTEGER)



SCREEN 9
LINE (0, 0)-(639, 349), 15, B
LINE (100, 100)-(150, 150), 15, B
LINE (11, 11)-(120, 120), 15, B
LINE (200, 60)-(600, 120), 15, B
LINE (250, 20)-(620, 48), 15, B
LINE (170, 125)-(300, 330), 15, B

CIRCLE (180, 50), 30
CIRCLE (80, 250), 50
CIRCLE (400, 250), 70
CIRCLE (500, 300), 70

CALL floodfill(10, 10, 2)

SUB floodfill (px AS INTEGER, py AS INTEGER, replacementColor AS INTEGER)
  DIM temp  AS pt
  DIM txy AS pt
  DIM y1    AS INTEGER
  DIM spanLeft AS INTEGER
  DIM spanRight AS INTEGER
  DIM targetColor AS INTEGER
  DIM GetMaxX AS INTEGER
  DIM GetMaxY AS INTEGER

  GetMaxX = 639
  GetMaxY = 349

  true = -1
  false = 0


  CALL stackpoint.init
  txy.x = px
  txy.y = py
  targetColor = POINT(txy.x, txy.y)
  IF (targetColor = replacementColor) THEN
    EXIT SUB
  END IF

  CALL stackpoint.init
  CALL stackpoint.push(txy)
  WHILE (stackpoint.count <> 0)
    CALL stackpoint.pop(temp)
    y1 = temp.y
    WHILE (y1 >= 0) AND (POINT(temp.x, y1) = targetColor)
      y1 = y1 - 1
    WEND
    y1 = y1 + 1
    spanLeft = false
    spanRight = false
    WHILE (y1 < GetMaxY) AND (POINT(temp.x, y1) = targetColor)
 
      PSET (temp.x, y1), replacementColor
      IF (NOT spanLeft) AND (temp.x > 0) AND (POINT((temp.x - 1), y1) = targetColor) THEN
        txy.x = temp.x - 1
        txy.y = y1
        CALL stackpoint.push(txy)
        spanLeft = true
      ELSEIF (spanLeft = true) AND ((temp.x - 1) = 0) AND (POINT((temp.x - 1), y1) <> targetColor) THEN
        spanLeft = false
      END IF
     
      IF (NOT spanRight) AND (temp.x < (GetMaxX - 1)) AND (POINT(temp.x + 1, y1) = targetColor) THEN
        txy.x = temp.x + 1
        txy.y = y1
        CALL stackpoint.push(txy)
        spanRight = true
      ELSEIF (spanRight = true) AND (temp.x < (GetMaxX - 1)) AND (POINT(temp.x + 1, y1) <> targetColor) THEN
        spanRight = false
      END IF
      y1 = y1 + 1
    WEND
  WEND
END SUB

FUNCTION stackpoint.count%
 SHARED c%
 stackpoint.count = c%
END FUNCTION

SUB stackpoint.init
SHARED c%
 c% = 0
END SUB

SUB stackpoint.pop (mypt AS pt)
SHARED c%
 IF c% > 0 THEN
    mypt = plist(c%)
    c% = c% - 1
 END IF
END SUB

SUB stackpoint.push (mypt AS pt)
SHARED c%
 c% = c% + 1
 IF c% > 999 THEN END
 plist(c%) = mypt
END SUB

