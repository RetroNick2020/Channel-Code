'Laser Chess-
'Copyright 1987 Compute! Publications, Inc.
'All Rights Reserved-
CLEAR, 25000:CLEAR ,50000&
REM change DEFSNG r,g,b,mx to DEFSNG r,g,b because of conflict with Absoft AC Compiler
REM and it did not look like mx variable was being used in the program

DEFINT a-z:DEFSNG r,g,b :RANDOMIZE TIMER:SCREEN 1,320,200,4,1
WINDOW 3,,(0,0)-(311,186),16,1:WINDOW OUTPUT 3: COLOR ,0
DIM sn(8,3,1,1),es(155,1),shape(155,87),piece(9,9),orient(9,9),cLr(9,9)
DIM os(155),beamck(3,9,9),dirck(8,3,3),bmd0(158),bmd1(22),shpt(8)
DIM ddrcx(1,20),ddrcy(1,20),pt(14)
DIM s(255),n(255),sq(255),freq(20,4) ,shptx(8,19) ,shpty(8,19)
LOCATE 1,4:PRINT CHR$(169)"1987 Computel Publications, Inc."
LOCATE 3,11:PRINT"A11 Rights Reserved"
LOCATE 12,9:PRINT"(F)illed or (U)nfilled?"
WHILE NOT(k$="F" OR k$="U"):k$=UCASE$( INKEY$) :WEND:fL=k$="F"
PALETTE 0,.15,.05,.5:PALETTE 1,.15, .25, .95
FOR i=2 TO 14:PALETTE i,.15,.05,.5:NEXT:PALETTE 15, .15, .25, .95
ON TIMER(1) GOSUB CLock:ti=36-fL*10
COLOR 1,0:CLS:LOCATE 10,14:PRINT"PLEASE WAIT"
LOCATE 12,18:PRINT "seconds":TIMER ON
FOR i=0 TO 255:s(i)=127-i:NEXT:FOR i=0 TO 255:n(i)=127-RND*255:NEXT:WAVE 0,s
FOR i=0 TO 127:sq(i)=127-RND*50:NEXT:FOR i=128 TO 255:sq(i)=-128+RND*50:NEXT
cop(1)=4:cop(2)=6:GOSUB InitShapes:GOSUB InitObjectS:TIMER OFF:CLS
RESTORE PaLetteData:FOR i=2 TO 14:READ r,g,b:PALETTE i,r,g,b:NEXT

PaLetteData:
DATA 0,0,0, .3, .3, .3
DATA .6,0,0,1,0,0,0,.55,0,0,.9,0
DATA 1,1,0,1,1,0,.6, .6, .6,1,1,1
DATA 1,1,0,1,1,0,1,1,0

Start:
L(1)=1:L(2)=1:Lpx(1)=4:Lpy(1)=1:Lpx(2)=6:Lpy(2)=9
COLOR ,0:GOSUB DrawBoard:k=0:pL=1

Main:
pL=pL XOR 3:px=5:py=5:move=2:hycube=0:hysq=0:taken=0:fired=1
LINE(40,10)-(288,186),cop(pL),b:LINE(42,12)-(286,184),cop(pL),b

MovePiece: 
WHILE MOUSE(0)>-1:WEND:x=MOUSE(3):y=MOUSE(4)
px=INT((x-17)/27):py=INT((y+6)/19):moves=0

IF NOT((px>0 AND px<10) AND (py>0 AND py<10)) THEN Options
IF cLr(px,py)<>pL THEN MovePiece
piece=piece(px,py):rot=orient(px,py)
obindex=oi(piece,rot):spx=px:spy=py
IF NOT(obindex>0) THEN MovePiece

OBJECT.X obindex,x-14:OBJECT.Y obindex,y-10:OBJECT.ON obindex
WHILE MOUSE(0)<0
    OBJECT.X obindex,MOUSE(1)-14:OBJECT.Y obindex,MOUSE(2)-10
    IF INKEY$<>"" THEN 
        rot=(rot+1) AND turns(piece):j=obindex:obindex=oi(piece,rot)
        OBJECT.X obindex,MOUSE(1)-14:OBJECT.Y obindex,MOUSE(2)-10
        OBJECT.OFF j:WAVE 0,s:SOUND 4000,.1,255,0:OBJECT.ON obindex
    END IF
WEND

OBJECT.OFF obindex
GOSUB EraseSquare
px=INT((MOUSE(5)-17)/27):py=INT((MOUSE(6)+6)/19)
GOSUB CheckMove
GOSUB PutShape
IF piece(px,py)=2 THEN Lpx(pL)=px:Lpy(pL)=py

EndMove:
IF k THEN EndGame
move=move-moves:IF move=1 THEN LINE(40,10)-(288,186), 0,b
IF move>0 THEN MovePiece
GOTO Main

CLock:
ti=ti-1:LOCATE 12,14:PRINT STR$(ti)" ":RETURN

InitShapes:
LINE(0,0)-(0,0),10,bf:GET(0,0)-(0,0),pt:PUT(0,0),pt
LINE(0,0)-(0,18),10:GET(0,0)-(0,18),bmd0:PUT(0,0),bmd0
LINE(0,0)-(26,0),10:GET(0,0)-(26,0) ,bmd1 :PUT(0,0) ,bmd1
LINE(0,0)-(26,18),2,bf:GET(0,0)-(26,18),es(0,0)
LINE(0,0)-(26,18),3,bf:GET(0,0)-(26,18),es(0,1)
RESTORE LaserDir:FOR i=0 TO 3:READ dirx(i),diry(i):NEXT

LaserDir:
DATA 0,-1,1,0,0,1,-1,0
RESTORE ShapePts
k=0:x=0:y=0:FOR i=1 TO 8:READ turns(i),shpt(i)
FOR j=0 TO shpt(i)+1:READ shptx(i,j),shpty(i,j):NEXT
GOSUB GetShapes:NEXT
RESTORE ShapeRefLect
FOR i=1 TO 8:FOR j=0 TO turns(i):FOR k=0 TO 3:READ dirck(i,j,k):
NEXT k,j,i
RETURN

ShapePts:
DATA 1,1,-1,17,17,1,0,0
DATA 3,6,7,17,9,1,11,17,7,17,1,15,17,15,11,17,9,9
DATA 1,1,-1,9,17,9,0,0
DATA 0,7,5,9,9,5,13,9,9,13,5,9,13,9,9,13,9,5,0,0
DATA 3,6,1,2,17,2,17,17,1,17,1,2,-1,1,17,1,9,9
DATA 0,4,1,1,17,1,17,17,1,17,1,1,0,0
DATA 3,6,2,1,16,1,9,8,2,1,-1,1,-9,9,17,1,9,4
DATA 3,5,2,17,17,17,17,2,2,17,-1,17,17,1,13,13

ShapeRefLect:
DATA 1,0,3,2,3,2,1,0,-1,-1,-1,-1,-1,-1,-1,-1
DATA -1,-1,-1,-1,-1,-1,-1,-1,2,1,0,3,0,3,2,1
DATA -1,-1,-1,-1,-1,-1,0,-1,-1,-1,-1,1,2,-1,-1,-1
DATA -1,3,-1,-1,0,1,2,3,-2,2,-1,2,3,-2,3,-1
DATA -1,0,-2,0,1,-1,1,-2,-1,0,3,-1,-1,-1,1,0
DATA 1,-1,-1,2,3,2,-1,-1

GetShapes:
FOR angLe=0 TO turns(i):FOR bkgd=0 TO 1:FOR pL=1 TO 2
co=cop(pL):PUT(0,0),es(0,bkgd),PSET 
ON angLe+1 GOSUB rotate0,rotate90,rotate180,rotate270
sn(i,angLe,pL-1,bkgd)=k:GET(0,0)-(26,18),shape(0,k):k=k+1
NEXT pL,bkgd,angLe:RETURN

rotate0:
FOR j=1 TO shpt(i):IF shptx(i,j-1)<0 THEN hue=co+1 ELSE hue=co
LINE(ABS(shptx(i,j-1))+4+x,shpty(i,j-1)+y)-(ABS(shptx(i,j))+4+x,shpty(i,j)+y),hue:NEXT
IF shptx(i,shpt(i)+1)>0 AND fL THEN PAINT(shptx(i,shpt(i)+1)+4+x,shpty(i,shpt(i)+1)+y),co,co
RETURN

rotate90:
FOR j=1 TO shpt(i):IF shptx(i,j-1)<0 THEN hue=co+1 ELSE hue=co
LINE(18-shpty(i,j-1)+4+x,ABS(shptx(i,j-1))+y)-(18-shpty(i,j)+4+x,ABS(shptx(i,j))+y),hue:NEXT
IF shptx(i,shpt(i)+1)>0 AND fL THEN PAINT(18-shpty(i,shpt(i)+1)+4+x,shptx(i,shpt(i)+1)+y),co,co
RETURN

rotate180:
FOR j=1 TO shpt(i):IF shptx(i,j-1)<0 THEN hue=co+1 ELSE hue=co
LINE(18-ABS(shptx(i, j-1) )+4+x, 18-shpty(i,j-1)+y)-(18-ABS(shptx(i,j))+4+x,18-shpty(i,j)+y),hue:NEXT
IF shptx(i,shpt(i)+1)>0 AND fL THEN PAINT(18-shptx(i,shpt(i)+1)+4+x,18-shpty(i,shpt(i)+1)+y),co,co
RETURN

rotate270:
FOR j=1 TO shpt(i):IF shptx(i,j-1)<0 THEN hue=co+1 ELSE hue=co
LINE(shpty(i,j-1)+4+x,18-ABS(shptx(i, j-1) )+y)-(shpty(i, j)+4+x, 18-ABS(shptx(i,j))+y),hue:NEXT
IF shptx(i,shpt(i)+1)>0 AND fL THEN PAINT(shpty(i, shpt(i)+1)+4+x,18-shptx(i,shpt(i)+1)+y),co,co
RETURN

REM changed seLec to seLected because of conflict trying to compile under Absoft AC Compiler
InitObjects:
k=1:si$=STRING$(26,0):POKE SADD(si$)+11,4:POKE SADD( si$ )+15,27
POKE SADD(si$)+19,19:POKE SADD(si$)+21,24:POKE SADD(si$)+23,15
FOR piece=1 TO 8
    FOR angLe=0 TO turns(piece)
        seLected=sn(piece,angLe,0,0)
        PUT(0,0),es(0,0),PSET
        PUT(0,0),shape(0,seLected)
        oi(piece,angLe)=k
        GET(0,0)-(26,18),os
        sd$=""
        FOR i=3 TO 154
            sd$=sd$+MKI$(os(i))
        NEXT
        OBJECT.SHAPE k,si$+sd$:OBJECT.PLANES k,3,8
        k=k+1
    NEXT angLe
NEXT piece
RETURN


DrawBoard:
COLOR 3,2:LINE(11,54)-STEP(16,11),,b:PAINT(12,55),2,3:LOCATE 8,3:PRINT"Q"
LINE(11,94)-STEP(16,10),,b:PAINT(12,95),2,3:LOCATE 13,3:PRINT"R"
LINE(11,134)-STEP(16,10),,b:PAINT(12,135),2,3:LOCATE 18,3:PRINT"L"
FOR py=1 TO 9:FOR px=1 TO 9:GOSUB EraseSquare:NEXT px,py
LINE(151,89)-(177,107),0,bf
RESTORE ShapePos:FOR py=1 TO 2:FOR px=1 TO 9:cLr(px,py)=1:cLr(px,py+7)=2
READ piece(px,py),orient(px,py),orient(10-px,10-py)
piece(10-px,10-py)=piece(px,py):NEXT px,py
FOR px=1 TO 9:FOR py=1 TO 9:IF piece(px,py)>0 THEN GOSUB PutShape
NEXT py,px

ShapePos:
DATA 8,2,0,8,2,0,1,1,1,2,2,0,4,0,0,6,0,0
DATA 1,0,0,8,3,1,8,3,1,8,3,1,5,2,0,5,2,0
DATA 7,2,0,3,0,0,3,1,1,5,2,0,5,2,0,8,2,0
RETURN

PutShape:
x=px*27+16:y=py*19-6:bkgd=(px+py+1) AND 1
PUT(x,y),shape(0,sn(piece(px,py),orient(px,py),cLr(px,py)-1, bkgd)),PSET
RETURN


EraseSquare:
x=px*27+16
y=py*19-6
bkgd=(px+py+1) AND 1
PUT(x,y),es(0,bkgd),PSET
RETURN

Fire:
px=Lpx(pL):py=Lpy(pL):Lx(1)=px:Ly(1)=py:dir(1)=orient(px, py)
FOR i=1 TO 3:aLive(i)=0:term(i)=0:NEXT:aLive(1)=1
WHILE (aLive(1)=1) OR (aLive(2)=1) OR (aLive(3)=1)
FOR i=1 TO 3:IF aLive(i)<1 THEN AdvBeam
nLx(i)=Lx(i)+dirx(dir(i)):nLy(i)=Ly(i)+diry(dir(i) )
IF beamck(dir(i),Lx(i),Ly(i))=1 THEN EndBeam
beamck(dir(i),Lx(i),Ly(i))=1:GOTO DrawBeam

Hit:
term(i)=1:drk(i)=tdir:IF d THEN EndBeam
tx=px:ty=py:px=Lx(i):py=Ly(i):IF piece(px,py)=4 THEN k=k+cLr(px,pY)
IF piece(px,py)=2 THEN L(cLr(px,py))=0
x=px*27 + 16 :y=py*19-6
m=piece(px,py):shpt(0)=shpt(m):FOR j=0 TO Shpt(0)+1:shptx(0,j)=Shptx(m,j)
shpty(0,j)=shpty(m,j)::NEXT:t=i:i=0:co=8
ON orient(px,py)+1 GOSUB rotate0,rotate90,rotate180,rotate270
i=t:px=tx:py=ty

EndBeam: 
aLive( i)=-1
AdvBeam:NEXT:WEND
RETURN

DrawBeam:
x=Lx(i)*27+29:y=Ly(i)*19+3
ON dir(i) GOTO BRt,BDn,BLt

BUp:
PUT(x,y-19),bmd0:GOTO CkBeam

BRt:
PUT(x,y+1),bmd1:GOTO CkBeam

BDn:
PUT(x+1,y),bmd0:GOTO CkBeam

BLt:
PUT(x-27,y),bmd1:GOTO CkBeam

CkBeam:
IF (nLx(i)>9) OR (nLy(i)>9) OR (nLx(i)<1) OR (nLy(i)<1) THEN EndBeam
IF nLx(i)=5 AND nLy(i)=5 THEN EndBeam
Lx(i)=nLx(i):Ly(i)=nLy(i):IF piece(nLx(i),nLy(i))=0 THEN AdvBeam
tdir=dir(i):dir(i)=dirck(piece(Lx(i),Ly(i)),orient(Lx(i),Ly(i)),dir(i))
IF dir(i)=-1 THEN Hit
IF dir(i)>-2 THEN AdvBeam
IF aLive(2)=0 THEN j=2 ELSE j=3 
aLive(j)=1:Lx(j)=Lx(i):Ly(j)=Ly(i)
dir(i)=tdir+1 AND 3:dir(j)=tdir-1 AND 3
GOTO AdvBeam

Laser:
k=0:d=0:GOSUB Fire
FOR i=0 TO 3:FOR x=1 TO 9:FOR y=1 TO 9:beamck(i,x,y)=0:NEXT y,x,i

FOR i=1 TO 3
IF term(i)=1 THEN
    IF piece(Lx(i),Ly(i)) > 0 THEN
        tx=px:ty=py:px=Lx(i):py=Ly(i):GOSUB ExpLode:px=tx:py=ty
    END IF
END IF
NEXT


TIMER OFF:d=1:GOSUB Fire
FOR i=1 TO 3
    IF term(i)=1 THEN
        IF piece(Lx(i),Ly(i)) > 0 THEN
            tx=px:ty=py:px=Lx(i):py=Ly(i):piece(px,py)=0:cLr(px,py)=0
            GOSUB EraseSquare:px=tx:py=ty
        END IF
    END IF
NEXT

FOR i=0 TO 3:FOR x=1 TO 9:FOR y=1 to 9:beamck(i,x,y)=0:NEXT y,x,i
RETURN

ExpLode:
FOR j=0 TO 4:vol(4-j)=(j+1)*40:NEXT:ch=0
FOR j=0 TO 20:t=900-INT(RND*8)*100:FOR m=0 TO 4:freq(j,m)=t:NEXT m, j
Lv=120:cx=px*27+29:cy=py*19+3:WAVE 0,n:WAVE 1,n
IF dirx(drk(i))=0 THEN
    FOR j=0 TO 20:ddrcy(0,j)=INT(RND*10)*diry(drk(i))+cy
        ddrcx(0,j)=cx+10-INT(RND*20)
        ddrcy(1,j)=INT(RND*20)*diry(drk(i))+cy
        ddrcx(1,j)=cx+20-INT(RND*40):NEXT
ELSE
FOR j=0 TO 20:ddrcx(0,j)=INT(RND*10)*dirx(drk(i))+cx
    ddrcy(0,j)=cy+10-INT(RND*20)
    ddrcx(1,j)=INT(RND*20)*dirx(drk(i))+cx
    ddrcy(1,j)=cy+20-INT(RND*40):NEXT
END IF
GOSUB EraseSquare

FOR j=0 TO 20:PUT(ddrcx(0,j),ddrcy(0,j)),pt:IF (j AND 4)=4 THEN GOSUB ExpSnd
NEXT
FOR j=0 TO 20:PUT(ddrcx(0,j),ddrcy(0,j)),pt:PUT(ddrcx(1,j),ddrcy(1,j)),pt
IF (j AND 4)=4 THEN GOSUB ExpSnd

NEXT:FOR j=0 TO 20:PUT(ddrcx(1,j),ddrcy(1,j)),pt:NEXT
RETURN

ExpSnd:
ch=1-ch:FOR m=0 TO 4:SOUND freq(j,m),.05,vol(m),ch:NEXT:RETURN

CheckMove:
dx=ABS(px-spx):dy=ABS(py-spy)
moves=dx+dy+ABS(rot<>orient(spx,spy))

IF dx=0 AND dy=0 THEN VaLidMove
IF NOT(px>0 AND px<10 AND py>0 AND py<10) THEN InVaLidMove
IF moves>move THEN InVaLidMove
IF moves=2 THEN 
   midx=(px+spx)/2:midy=(py+spy)/2
   IF midx=5 AND midy=5 THEN InVaLidMove
   IF dx=2 THEN IF piece(midx,py)<> 0 THEN InVaLidMove
   IF dy=2 THEN IF piece(px,midy)<> 0 THEN InVaLidMove
   IF dx=1 AND dy=1 THEN 
      IF ((piece(px,spy)<>0) OR (px=5 AND spy=5)) AND ((piece(spx,py)<>0) OR (spx=5 AND py=5)) THEN InVaLidMove
   END IF
END IF

IF piece(px,py)<>0 THEN
IF piece=4 OR piece=5 THEN
IF taken THEN InVaLidMove
    IF piece(px,py)=4 THEN k=cLr(px,py)
    IF piece(px,py)=2 THEN L(cLr(px,py))=0

    WAVE 0,n:WAVE 1,n
    FOR i=255 TO 10 STEP -20:SOUND 400,.1,i,0:SOUND 400,.1,i,1:NEXT
    taken=1:GOTO VaLidMove
ELSEIF piece=6 THEN
    IF hycube THEN InVaLidMove
        hycube=1:GOTO HyperCube
    ELSE
        GOTO InVaLidMove
    END IF
END IF
IF NOT(px=5 AND py=5) THEN VaLidMove
IF hysq THEN InVaLidMove
WHILE (px=5 AND py=5) OR piece(px, py) <> 0
    px=INT(RND*9+1):py=INT(RND*9+1)
WEND
WAVE 0,n:FOR i=250 TO 0 STEP -2:SOUND 100+i*2,.03,i,0:NEXT:WAVE 1,n
GOSUB VaLidMove:FOR i=0 TO 250 STEP 2:SOUND 100+500-i*2,.03,i,1:NEXT
hysq=1:GOSUB PutShape
RETURN

HyperCube:
nx=INT(RND*9+1):ny=INT(RND*9+1)
IF (nx=5 AND ny=5) OR piece(nx,ny)<>0 THEN HyperCube
WAVE 0,n:FOR i=250 TO 0 STEP -2:SOUND 100+1*2,.03,i,0:NEXT:WAVE 1,n
piece(nx,ny)=piece(px,py):orient(nx,ny)=orient(px,py):cLr(nx,ny)=cLr(px,py)
GOSUB VaLidMove:FOR i=0 TO 250 STEP 2:SOUND 100+500-i*2,.03,i,1:NEXT
GOSUB PutShape:piece(spx,spy)=0:cLr(spx,Spy)=3:px=nx:py=ny
RETURN

VaLidMove:
piece(px,py)=piece:orient(px,py)=rot:cLr(px,py)=cLr(spx, spy)
IF dx>0 OR dy>0 THEN piece(spx,spy)=0:cLr (spx, spy)=0
RETURN

InValidMove:
px=spx:py=spy :moves=0 : RETURN

Confirm:
WINDOW 2,,(114,82)-(216,105),0,1:WINDOW OUTPUT 2:PRINT"Are you sure?"
COLOR 3,2:LINE(27,14)-STEP(16,10),,b:PAINT(28,15),2,3:LOCATE 3,5:PRINT"Y"
LINE(59,14)-STEP(16,10),,b:PAINT(68,15), 2, 3: LOCATE 3 , 9 :PRINT"N"

CkCon:
WHILE MOUSE(0)>-1:WEND:x=MOUSE(3):y=MOUSE(4):co=POINT(x,y)
IF NOT(co=2 OR co=3) THEN CkCon
IF X>27 AND x<43 THEN
 c=1
ELSEIF x>59 AND x<75 THEN
 c=0
ELSE
 GOTO CkCon
END IF
WINDOW CLOSE 2:WHILE MOUSE(0)<>0:WEND:RETURN

Options:
co=POINT(x,y) :moves=0
IF NOT(co=2 OR CO=3) THEN MovePiece
IF y>133 AND y<145 AND fired AND L(pL) THEN
    fired=0:PALETTE 10,1,1,0:PALETTE 15,1,1,0
    WAVE 2,sq:WAVE 3,sq:ON TIMER(1) GOSUB LSnd:Lv=200:GOSUB LSnd:TIMER ON
    GOSUB Laser:
    moves=1
    PALETTE 10,.6,.6,.6:PALETTE 15,.15,.25,.95
ELSEIF y>93 AND y<105 THEN
    GOSUB Confirm:IF c THEN Restart
ELSEIF y>53 AND y<66 THEN
    GOSUB Confirm:IF C THEN SCREEN CLOSE 1:WINDOW CLOSE 3:CLEAR,25000:END
END IF
GOTO EndMove

LSnd:
SOUND 120,18.2,Lv,2:SOUND 121,18.2,Lv,3:RETURN

Border:
LINE(40,10)-(288,186),,b:LINE(42,12)-(286,184),,b:RETURN

Restart:
COLOR ,0:CLS:FOR i=1 TO 9:FOR j=1 TO 9:piece(i,j)=0:cLr(i,j)=0:NEXT j,i
GOTO Start

EGOpt:
co=POINT(x,y)
IF co=2 OR co=3 THEN
    IF y>93 AND y<105 THEN Restart
    IF y>53 AND y<66 THEN SCREEN CLOSE 1:WINDOW CLOSE 3:CLEAR,25000:END
END IF
GOTO EndGWait

EndGame:
IF k=3 THEN
    COLOR 10,0:GOSUB Border:COLOR 11:LOCATE 1,19:PRINT"Draw"
ELSE
    IF k=2 THEN COLOR 4,0:GOSUB Border:COLOR 5:LOCATE 1,16:PRINT"Red";
IF k=1 THEN COLOR 6,0:GOSUB Border:COLOR 7:LOCATE 1,15:PRINT "Green";
    PRINT "  victory"
END IF

EndGWait:
WHILE MOUSE(0)>-1:WEND:x=MOUSE(3):y=MOUSE(4)
px=INT((x-8)/27):py=INT((y+6)/19):moves=0
IF NOT((px>0 AND px<10) AND (py>0 AND py<10)) THEN EGOpt
GOTO EndGWait
