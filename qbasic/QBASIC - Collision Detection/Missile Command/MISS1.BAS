DECLARE SUB DrawSendMissile (sx%, sy%, ex%, ey%)
'RetroNick's Mini Missile Command to demo
'point/circle collisions

DECLARE SUB PrintHUD ()
DECLARE SUB CheckForHit (x%, y%)
DECLARE FUNCTION pointCircle% (px%, py%, cx%, cy%, r%)
DECLARE SUB DrawImpactArea ()
DECLARE SUB UpdateEnemyMissiles ()
DECLARE SUB DrawEnemyMissiles ()
DECLARE SUB InitEnemyMissiles ()
DECLARE SUB DrawDefenseMissile (sx%, sy%, ex%, ey%)
DECLARE SUB DrawCrossHair ()

CONST MissileCount = 5

TYPE MissileType
  sx AS INTEGER
  sy AS INTEGER
  cx AS SINGLE
  cy AS SINGLE
  xstep AS SINGLE
  ystep AS SINGLE
  launchtime AS SINGLE
  active AS INTEGER
  hit AS INTEGER
END TYPE

DIM SHARED x%
DIM SHARED y%
DIM SHARED hit$
DIM SHARED Missile(MissileCount) AS MissileType

RANDOMIZE TIMER
InitEnemyMissiles

SCREEN 7, 1, 0, 1
ON TIMER(1) GOSUB UpdateEnemy
TIMER ON

x% = 160
y% = 100

hit$ = ""
a$ = ""
col% = 1
WHILE (a$ <> "q")
  a$ = INKEY$
  IF RIGHT$(a$, 1) = "K" THEN x% = x% - 3
  IF RIGHT$(a$, 1) = "M" THEN x% = x% + 3
  IF RIGHT$(a$, 1) = "P" THEN y% = y% + 3
  IF RIGHT$(a$, 1) = "H" THEN y% = y% - 3
  IF a$ = "f" THEN
   fire% = 1
  END IF

  CLS
  PrintHUD
  DrawEnemyMissiles

  IF (fire% = 1) THEN
     CALL DrawDefenseMissile(160, 199, x%, y%)
     CALL DrawImpactArea
     CALL CheckForHit(x%, y%)
     fire% = 0
  END IF

  DrawCrossHair
  PCOPY 0, 1
WEND
END

UpdateEnemy:
   UpdateEnemyMissiles
   RETURN

SUB CheckForHit (x%, y%)
hit$ = "NO HIT"
FOR i = 0 TO MissileCount - 1
  IF Missile(i).active = 1 AND pointCircle(x%, y%, INT(Missile(i).cx), INT(Missile(i).cy), 10) = 1 THEN
     Missile(i).hit = 1
     Missile(i).active = 0
     hit$ = "HIT"
     SOUND 100, 1
  END IF
NEXT i

END SUB

SUB DrawCrossHair
  LINE (x% - 5, y%)-(x% + 5, y%), 4
  LINE (x%, y% - 5)-(x%, y% + 5), 4

END SUB

SUB DrawDefenseMissile (sx%, sy%, ex%, ey%)
  LINE (sx%, sy%)-(ex%, ey%), 2
END SUB

SUB DrawEnemyMissiles
 FOR i = 0 TO MissileCount - 1
   IF Missile(i).active = 1 THEN
     LINE (Missile(i).sx, Missile(i).sy)-(Missile(i).cx, Missile(i).cy), 15
   END IF
NEXT i
END SUB

SUB DrawImpactArea
  CIRCLE (x%, y%), 10, 4, , , 1
END SUB

SUB InitEnemyMissiles
  FOR i = 0 TO MissileCount - 1
     Missile(i).sy = 10
     Missile(i).sx = INT(RND * 319)
     Missile(i).cy = Missile(i).sy + 1
     Missile(i).cx = Missile(i).sx + 1

     Missile(i).active = 0
     Missile(i).hit = 0
     Missile(i).launchtime = TIMER + RND * 20
     Missile(i).xstep = RND * 2
     Missile(i).ystep = 5
  NEXT i
END SUB

FUNCTION pointCircle% (px%, py%, cx%, cy%, r%)
  'get distance between the point and circle's center
  'using the Pythagorean Theorem
  distX! = px% - cx%
  distY! = py% - cy%

' PRINT distX%
' PRINT distY%
 pointCircle% = 0
 'IF distX% < 0 OR distY% < 0 THEN EXIT FUNCTION
  distance! = SQR((distX! * distX!) + (distY! * distY!))

  'if the distance is less than the circle's
  'radius the point is inside!
  IF (distance! <= r%) THEN
    pointCircle% = 1
  ELSE
    pointCircle% = 0
  END IF
END FUNCTION

SUB PrintHUD
   LOCATE 1, 1
   COLOR 1
   PRINT "X= "; x%; " Y="; y%; "  "; hit$
 
   LOCATE 22, 1
   PRINT "arrow keys to select target"
   PRINT "f to fire  -  q to quit";
END SUB

SUB UpdateEnemyMissiles
 ct = TIMER
 FOR i = 0 TO MissileCount - 1
  IF Missile(i).active = 1 THEN
     Missile(i).cx = Missile(i).cx + Missile(i).xstep
     Missile(i).cy = Missile(i).cy + Missile(i).ystep
  ELSE
     IF ct > Missile(i).launchtime AND Missile(i).hit = 0 THEN
       Missile(i).active = 1
     END IF
  END IF
 NEXT i
END SUB

