DECLARE SUB PrintN ()
REM Parts of the mouse code taken from the following article
REM https://jeffpar.github.io/kbarchive/kb/042/Q42587/

'$INCLUDE: 'QB.BI'
' The following $INCLUDE filename would be 'QBX.BI' if you
' are using the BASIC PDS 7.00:

DEFINT A-Z
DIM Image%(34), TImage%(34)
DIM MyMouse%(32)
COMMON MyMouse%()

DECLARE SUB DrawLine (x%, y%, LineImg%())
DECLARE SUB ImageToMouseShape (Image%(), MouseShape%())
DECLARE SUB PackedToSingle (pline%, uline%(), offset%)

DECLARE FUNCTION bin2dec% (b$)
DECLARE FUNCTION dec2bin$ (n#)

DECLARE SUB Mouse (m1%, m2%, m3%, m4%)
DECLARE FUNCTION MouseInit% ()
DECLARE SUB MouseShow ()
DECLARE SUB MouseButPos (ButStat%, CurHor%, CurVert%)

SCREEN 1
LINE (0, 0)-(150, 50), 2, BF
LINE (100, 50)-(150, 100), 1, BF
LINE (100, 100)-(150, 150), 3, BF
LOCATE 20, 1
' this part initializes the mouse
IF MouseInit = 0 THEN
  PRINT "can not initialize mouse"
  END
END IF

RESTORE m5
FOR i = 0 TO 33
  READ Image%(i)
NEXT i

'CALL PrintN
'LOCATE 20, 1
'GET (0, 0)-(15, 15), TImage%
CALL ImageToMouseShape(Image%(), MyMouse%())

' this is the part that makes the shape
m1 = 9
m2 = 7
m3 = 7
m4 = VARPTR(MyMouse%(0))
CALL Mouse(m1, m2, m3, m4)
MouseShow

INPUT a$

m5:
'  QuickBASIC\QB64, Array Size= 34 Width= 16 Height= 16 Colors= 4
'  m5

DATA &H0020,&H0010,&HAAAA,&HAAAA,&HFFBF,&HEAFF,&H00B0,&HCA00
DATA &HAAB2,&HCAAA,&HAAB2,&HCAAA,&H95B2,&HCA5A,&H95B2,&HCA5A
DATA &H95B2,&HCA5A,&H95B2,&HCA5A,&H95B2,&HCA5A,&HAAB2,&HCAAA
DATA &HAAB2,&HCAAA,&HAAB2,&HCAAA,&HFFBF,&HCAFF,&H00A0,&H0A00
DATA &HAAAA,&HAAAA

m4:
'  QuickBASIC\QB64, Array Size= 34 Width= 16 Height= 16 Colors= 4
'  m4

DATA &H0020,&H0010,&HAFAA,&HAAEA,&HF0AA,&HAA3E,&HCFAA,&HAACE
DATA &HFFAB,&HAAFF,&H55AC,&HEA54,&H41AC,&HEA04,&H41AC,&HEA04
DATA &H55AC,&HEA54,&HFFAC,&HEAFC,&HCCAC,&HEACC,&HCCAC,&HEACC
DATA &HCCAB,&HAACF,&HC0AA,&HAA0E,&HF0AA,&HAA3E,&HAFAA,&HAAEA
DATA &HAAAA,&HAAAA

m3:
'  QuickBASIC\QB64, Array Size= 34 Width= 16 Height= 16 Colors= 4
'  m3

DATA &H0020,&H0010,&HAFAA,&HAAEA,&HBFAA,&HAAFA,&HB3AA,&HAA3A
DATA &HBFAA,&HAAFA,&HACAA,&HAAEA,&HAFAA,&HAAEA,&HABAA,&HAAAA
DATA &HFFAF,&HFAFF,&HABAA,&HAAAA,&HABAA,&HAAAA,&HABAA,&HAAAA
DATA &HABAA,&HAAAA,&HABAA,&HAAAA,&HFFAB,&HAAFF,&HAAAA,&HAAAA
DATA &HAAAA,&HAAAA

FUNCTION bin2dec (b$)
  FOR i = LEN(b$) TO 1 STEP -1
    d$ = MID$(b$, i, 1)
    d = VAL(d$) * 2 ^ a
    dec = dec + d
    a = a + 1
  NEXT i
  bin2dec = dec
END FUNCTION

FUNCTION dec2bin$ (n#)
Temp# = n#
Out3$ = ""
IF Temp# >= False THEN
    Digits = False
    DO
	IF 2 ^ (Digits + 1) > Temp# THEN
	    EXIT DO
	END IF
	Digits = Digits + 1
    LOOP
    FOR Power = Digits TO 0 STEP -1
	IF Temp# - 2 ^ Power >= False THEN
	    Temp# = Temp# - 2 ^ Power
	    Out3$ = Out3$ + "1"
	ELSE
	    Out3$ = Out3$ + "0"
	END IF
    NEXT
END IF
  dec2bin = RIGHT$("00000000" + Out3$, 8)
END FUNCTION

SUB DrawLine (x, y, LineImg%())
 FOR i = 0 TO 15
  PSET (x + i, y), LineImg%(i)
 NEXT i
END SUB

SUB ImageToMouseShape (Image%(), MouseShape%())
  DIM i%, j%, c%
  DIM MImage$, MMask$
  DIM count%, position%, offset%
  DIM ImageLine%(16)
    
  count% = 0
  position% = 2

  FOR j% = 1 TO 16
     twobyte$ = MKI$(Image%(position%))
     b1% = ASC(MID$(twobyte$, 1, 1))
     b2% = ASC(MID$(twobyte$, 2, 1))
    
     CALL PackedToSingle(b1%, ImageLine%(), 0)
     CALL PackedToSingle(b2%, ImageLine%(), 4)

     twobyte$ = MKI$(Image%(position% + 1))
     b1% = ASC(MID$(twobyte$, 1, 1))
     b2% = ASC(MID$(twobyte$, 2, 1))
     
     CALL PackedToSingle(b1%, ImageLine%(), 8)
     CALL PackedToSingle(b2%, ImageLine%(), 12)

     position% = position% + 2

     REM CALL DrawLine(200, 10 + j%, ImageLine%())
    
     MImage$ = "1111111111111111"
     MMask$ = "0000000000000000"
     
     FOR i% = 0 TO 15
       IF ImageLine%(i%) = 0 THEN
	  REM  0 is black
		MID$(MImage$, i% + 1, 1) = "0"
		MID$(MMask$, i% + 1, 1) = "0"
       ELSEIF ImageLine%(i%) = 3 THEN
		REM  3 is white
		MID$(MImage$, i% + 1, 1) = "0"
		MID$(MMask$, i% + 1, 1) = "1"
       ELSEIF ImageLine(i%) = 2 THEN
		REM  2 pink / tranparent
		MID$(MImage$, i% + 1, 1) = "1"
		MID$(MMask$, i% + 1, 1) = "0"
       ELSE
		REM XOR the bits on this part of the mouse shape
		MID$(MImage$, i% + 1, 1) = "1"
		MID$(MMask$, i% + 1, 1) = "1"
       END IF
     NEXT i%
     MouseShape%(count%) = bin2dec(MImage$)
     MouseShape%(count% + 16) = bin2dec(MMask$)
     count% = count% + 1
  NEXT j%
END SUB

SUB Mouse (m1, m2, m3, m4)
  DIM InRegs AS RegType
  InRegs.ax = m1
  InRegs.bx = m2
  InRegs.cx = m3
  InRegs.dx = m4
  CALL INTERRUPT(51, InRegs, InRegs)
  m1 = InRegs.ax
  m2 = InRegs.bx
  m3 = InRegs.cx
  m4 = InRegs.dx
END SUB

SUB MouseButPos (ButStat, CurHor, CurVert)
  m1 = 3
  CALL Mouse(m1, m2, m3, m4)
  ButStat = m2
  CurHor = m3
  CurVert = m4
END SUB

FUNCTION MouseInit
   m1 = 0
   CALL Mouse(m1, m2, m3, m4)
   MouseInit = m1
END FUNCTION

SUB MouseShow
  m1 = 1
  CALL Mouse(m1, m2, m3, m4)
END SUB

SUB PackedToSingle (pline%, uline%(), offset%)
  p# = pline%
  binpline$ = dec2bin(p#)
  uline%(offset%) = bin2dec(MID$(binpline$, 1, 2))
  uline%(offset% + 1) = bin2dec(MID$(binpline$, 3, 2))
  uline%(offset% + 2) = bin2dec(MID$(binpline$, 5, 2))
  uline%(offset% + 3) = bin2dec(MID$(binpline$, 7, 2))
END SUB

SUB PrintN
  LOCATE 1, 1
  PRINT "N"
END SUB

