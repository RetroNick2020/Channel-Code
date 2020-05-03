'Climber 5
'Copyright 1987
'Compute! Publications, Inc.
'All Rights Reserved . 

DEFINT a-z
men=5
SAY TRANSLATE$("climer five!")
DIM map(45,24),mdat(100),chk&(7),ex(4),ey(4),ty(4),old(2),mindex(4)
DIM shape(1599)
endmap=100
GOSUB DefinePLayFieLd
RESTORE mapdata:t=1:cm=1
WHILE t<>-1
    READ t
    mdat(c)=t 
    c=c+1
    IF t=0 THEN mindex(cm)=c:cm=cm+1
WEND

mapdata:
DATA 1,6, 1,12, 1,18, 2,2, 2,9,2,15, 3,6, 3,12, 3,18, 4,2, 4,9,4,15, 0
DATA 1,3, 1,16, 2,5, 2,15, 3,9,3,11, 4,7, 4,14, 0
DATA 1,9, 2,3, 2,13, 3,7, 3,17,4,14, 0
DATA 1,7, 2,17, 3,3, 3,10, 4,15,0
DATA 1,10, 2,4, 3,13, 4,9, -1

stand=0:c1= 867:rt1=313:rt2=420:duck=103:baLL=654:gird=603:hook=685
c2=974:Lt1=1081:Lt2=1188:shorthook=1371
GOSUB makeshapes

NewBoard:
GOSUB MakeMap:px=266:py=138:psn=313
PUT (px,py),shape(psn):cf=0
FOR i=0 TO 4:ex(i)=320:NEXT

main:
WHILE vnext=0
    'keyboard input
    kf=33:dx=0:dy=0:a=0
    WHILE dx=0 AND dy=0 AND kf>0

    a$=INKEY$:a=ASC(a$+" ")
    IF a=29 THEN dy=8:GOTO keypressed
    IF a=28 THEN dy=-8:GOTO keypressed
    IF a=31 THEN dx=-8:GOTO keypressed
    IF a=30 THEN dx=8
    kf=kf-1

    keypressed:
WEND

GOSUB pLayer
'hooks
FOR n = 0 TO 4 
    IF ex(n)<318 THEN onscreen
    PUT(ex(n),ey(n)),shape(hook),XOR
    t!=RND(1)
    IF t!>.3 THEN eskip
    IF t!>.2 THEN esn(n)=hook ELSE esn(n) = shorthook
    ex(n)=0:ty(n)=n*4+1:ey(n)=n*32+9
    PUT (ex(n),ey(n)),shape(esn(n)),XOR
    onscreen:
    th=esn(n)
    PUT(ex(n),ey(n)),shape(th),XOR
    ex(n) = ex(n)+16
    PUT (ex(n),ey(n)),shape(th),XOR
    tx=ex(n)/8:ty=ty(n)
    IF th=hook AND ( map(tx-1,ty+1)=2 OR map(tx,ty+1)=2 OR map(tx-2,ty+1)=2 ) THEN GOSUB kiLLed
    IF map(tx-1,ty)=2 OR map(tx,ty)=2 OR map(tx-2,ty)=2 THEN GOSUB kiLLed
    eskip:
NEXT
WEND
t$="I got the ball":IF building>0 THEN t$=t$+" again."
IF building=4 THEN t$="l am getting tired. "
IF vnext=2 THEN SAY TRANSLATE$(t$)
vnext=0
IF men>0 THEN NextMap
SAY TRANSLATE$( "game over.")
LOCATE 1,1:PRINT " (C)ontinue ":PRINT " (R)estart ":PRINT " (Q)uit "
men=5
Loopg: a$=INKEY$:IF a$="r" THEN building=0:GOTO NewBoard
IF a$ = "c" THEN GOTO NewBoard
IF a$="q" THEN CLS : CLEAR: STOP
GOTO Loopg

NextMap:
building=(building+1) MOD 5 
GOTO NewBoard

kiLLed:
SAY TRANSLATE$("ouch.")
PUT (px,py), shape(psn),XOR
FOR i=0 TO 2
    map(mx,my+i-2)=old(i) 
    old(i)=0
NEXT 
PUT (ex(4),ey(4)),shape(esn(4)),XOR
px=266:py=138
ex(4)=318:psn=stand:cf=0
PUT (px,py),shape(psn):men=men-1

IF men=<0 THEN vnext=1:men=0
LOCATE 23,8:PRINT " Climbers ";men; " Level " ;building+1;
RETURN

pLayer:
WHILE INKEY$<>""
WEND
mx=px/8:my=(py+17)/8
map(mx,my-2)=old(0)
map(mx,my-1)=old(1)
map(mx,my)=old(2)

IF dy AND cf=0 THEN GOSUB trycLimb
ON cf GOTO cLimbing,ducking

IF dx THEN movepLay
sf=sf+1:REM standing on girder
IF sf>2 THEN PUT (px,py),shape(psn),XOR:PUT(px,py),shape(stand):sf=1:psn=stand
GOTO oLdmap

trycLimb:
t=my:IF dy>0 THEN t=my+1
IF map(mx,t)=1 THEN cf=1:RETURN
IF dy>0 THEN PUT (px,py),shape(psn),XOR:PUT (px,py),shape(duck):psn=duck:cf=2
RETURN

movepLay:
sf=0 :pb=rt1:IF dx<0 THEN pb=Lt1
tx=px+dx:ty=py
IF tx<8 OR tx>300 THEN tx=px
IF tx=10 AND ty=10 THEN fr=1:pb=duck:vnext=2
GOTO animate

ducking:
IF dx OR dy<0 THEN cf=0:psn=duck:RETURN
GOSUB oLdmap 
map(mx,my-2)=0
RETURN

cLimbing:
IF dy=0 THEN oLdmap
pb=c1:tx=px:ty=py+dy:tmy=(ty+17)/8
IF (tmy AND 3)=3 THEN cf=0:pb=stand:fr=1 
GOTO animate

animate:
PUT (px,py),shape(psn),XOR
fr=1-fr:psn=pb+fr*107
PUT (tx,ty),shape(psn)
px=tx:py=ty:mx=px/8:my=(py+17)/8

oLdmap:
old(0)=map(mx,my-2):map(mx,my-2)=2
old(1)=map(mx,my-1):map(mx,my-1)=2
old(2)=map(mx,my):map(mx,my)=2
RETURN 

MakeMap:
FOR i= 0 TO 39:FOR j=0 TO 24
map(i,j)=0:NEXT:NEXT
c = mindex(building):CLS :yc=0
FOR y=yc TO yc+180 STEP 32:FOR x=0 TO 319 STEP 8
PUT (x,y),shape(gird):NEXT:NEXT

WHILE mdat(c)>0
    y2=mdat(c):x2=mdat(c+1)*2:my=y2*4
    FOR j=my TO my+3:map(x2,j)=1:NEXT 
    tx=x2*8:ty=y2*32-5
    LINE (tx,ty)-(tx+16,ty+36) ,0,bf
    LINE (tx,ty)-(tx+2,ty+36),8,bf
    LINE (tx+14,ty)-(tx+16,ty+36),8,bf
    FOR j=ty+4 TO ty+28 STEP 8
    LINE (tx+2,j)-(tx+14,j),8,b:NEXT
    temp:
    c=c+2
WEND
PUT(20,28),shape(baLL):map(0,0)=-1
LOCATE 23,8:PRINT " Climbers ";men;" Level ";building+1;
RETURN 

makeshapes:
i2=0 :RESTORE makeshapes:CLS
LOCATE 10,2:PRINT "Copyright 1987 Compute! Publications"
LOCATE 12,10:PRINT "All rights reserved." 
FOR i=0 TO 7:READ chk&(i) :NEXT

'checksums
DATA 445496, 818859, 1393851
DATA 1902864, 2002109, 2100910
DATA 2406221, 2606260 


'shape 0 man standing still
m=102:m2=58:GOSUB ReadCompressed
DATA 14 , 22 , 4 , 40002 , 256 ,896 , 1408 , 3968 
DATA 1792 , 8160 , 16368 , 30664,-4124 , 32756 , 15736 , 8176 
DATA 3040 , 2400 ,736 , 2240 ,2784 , 3808 ,7920 , 15480 
DATA 40002 ,768 , 3968 , 1280 ,3840 ,768 , 3840 , 8160 
DATA 16368 , 30680 , 14296 , 6832 , 2080 , 1024 , 1664 , 3072 
DATA 1568 , 1024 , 40007 , 1280, 3840 ,768 , 1536 , 0 
DATA 2080 , 4112 , 0 , 2720 , 4064 , 1728 , 1728 , 3136 
DATA 1632 , 1088 , 40037

'shape 1 cLimbing
m=102:m2=43:GOSUB ReadCompressed
DATA 14 , 22 , 4 , 40007 , 128 ,448 , 640 , 1920 
DATA 896 , 8176 , 16376 , 16376, 16376 , 16376 , 8176 , 8176 
DATA 7280 ,7280 , 31868 , 40007, 384 , 1984 , 640 , 1920 
DATA 128 , 896 , 8176 , 5008 , 4368 , 12312 , 4112 , 40013 
DATA 640 , 1920 , 128 , 896 , 256,0, 3104 , 15288 
DATA 6448 , 2080 , 2080 , 40036

' shape 2 ducking
m=106:m2=56:GOSUB ReadCompressed
DATA 14 , 23 , 4 , 40003 , 8192, 29440 , 30592 , 22400 
DATA 29440 , 27872 , 24720 , 13640 , 6728 , 3832 , 3432 , 7664 
DATA 7024 , 5808 , 4848 , 6896 ,7920 , 7920 , 7776 , 3072 
DATA 40004 , 8960 , 1920 , 8192, 8960 , 13056 , 16352 , 8176 
DATA 2032 , 2032 , 656 , 528 , 1152 , 2112 , 3072 , 1024 
DATA 40008 , 8192 , 40002 , 768, 4864 , 0 , 2048 , 1056 
DATA 0 , 640 , 4080 , 3296 , 3168 , 3104 , 3168 , 3072 
DATA 40038 

' shape 3 run right
m=106:m2=63:GOSUB ReadCompressed
DATA 13 , 23 , 4 , 0 , 512 , 3328 , 8064 , 7424 
DATA 8064 , 3856 , 5688 , 14200, 25584 ,-8288 , 32704 , 16128 
DATA 7936 , 8064 , 6080 , 9184 ,19952 , 23008 ,-27712 ,-2176 
DATA 29568 , 14816 , 0 , 1536 ,3840 , 8128 , 1280 , 1920 
DATA 3584 , 1552 , 7728 , 16224, 28480 , 14080 , 6656 , 3072 
DATA 0 , 2048 , 7168 , 12288 , 8192 , 24576 , 40007 , 1280 
DATA 1920 , 3584 , 1552 , 16 , 0, 64 , 0 , 2048 
DATA 3072 , 768 , 2944 , 7616 ,12384 , 8384 , 24960 , 40038 

'shape 4 running right second frame
m=182:m2=95:GOSUB ReadCompressed
DATA 25 , 20 , 4 , 40002 , 32 ,0 , 112 , 0 
DATA 254 , 0 , 232 , 0 , 252 , 0, 120 , 0 
DATA 240 , 0 , 944 , 0 , 1919 ,-32768 , 3519 ,-16384 
DATA 4031 ,-32768 , 2040 ,0,1023 , 0 , 383 ,-16384 
DATA 15871 ,-16384 , 32739 ,-8192 ,-64 ,-512 ,-6208 , 32256 
DATA 384 , 28672 , 40002 , 48 ,0 , 120 , 0 , 254 
DATA 0 , 40 , 0 , 60 , 0 , 112 ,0 , 112 
DATA 0 , 224 , 0 , 688 , 0 , 1759 ,-32768 , 608 
DATA 0 , 768 , 40003 , 128 , 40019 , 40 , 0 , 60 
DATA 0 , 112 , 0 , 48 , 40004 ,-32768 , 513 ,-16384 
DATA 0 ,-32768 , 768 , 0 , 752 ,0 , 239 , 0 
DATA 227 ,-32768 , 1216 ,-16384, 1920 , 16384 , 384 , 40063 

' shape 5 girder
m=50:m2=25:GOSUB ReadCompressed
DATA 8,9,4,0, 1024 ,-1024, 30720 , 13056 
DATA -30976 ,-12544 , 4096 , 40002 , 8192 , 40005 ,-32256 , 0 
DATA -256 ,-256 , 768 ,-30976 ,-13312 , 30720 , 12288 ,-256 
DATA -256 , 40021

' shape 6 ball
m=30:m2=14:GOSUB ReadCompressed
DATA 5,4,4, 30720 , 18432 ,22528 , 30720 , 12288 
DATA 30720 , 30720 , 12288 , 18432 , 40002 , 1843 2 , 40016 

' shape 7 hook
m=182:m2= 53:GOSUB ReadCompressed
DATA 15 , 20 , 4 , 4088 , 2032 ,992 , 448 , 448 
DATA 448 , 448 , 448 , 448 , 992, 480 , 448 , 4032 
DATA 16352 , 30720 ,-4096 ,-4096, 28672 , 14340 , 4088 , 4096 
DATA 2496 , 1152 , 512 , 40006 ,512 , 0 , 4128 , 16384 
DATA -32768 , 2048 , 0 ,-30720 ,17416 , 4100 , 4096 , 2048 
DATA 1024 , 512 , 40006 , 512 ,0 , 4128 , 16384 ,-32768 
DATA 2048 , 0 ,-30720 , 17416 ,4100 , 40120 

PUT (0,0),shape(206):PUT (30,0),shape(rt1 )
PUT (60,0),shape(rt2):PUT (90,0),shape(hook)
GET (90,12)-(105,20),shape(shorthook) 
GET (0,0)-(14,23),shape(c1)
x2=0:y2=0:y3=40:psn=c2:nx=14:ny=23:GOSUB ReverseBob
x2=30:psn=Lt1:nx=13:ny=23:GOSUB ReverseBob
x2=60:psn=Lt2:nx=25:ny=20:GOSUB ReverseBob
RETURN

ReverseBob:
FOR i= 0 TO nx-1
FOR j=0 TO ny-1
t=POINT (i+x2,j+y2)
PRESET (x2+nx-i,j+y3),t
NEXT j
NEXT i
GET (x2,y3)-(x2+nx,y3+ny),shape(psn)
RETURN

ReadCompressed: 
FOR j=0 TO m2 
READ t&:s&=s&+t&
IF t&<40000& THEN shape(i2)=t&:i2=i2+1 ELSE FOR i=0 TO t&-40000&:shape(i+i2)=0:NEXT:i2=i2+t&-40000&
NEXT
IF chk&(ns)<>s& THEN PRINT "error in checksum";ns:PRINT " or inshape";ns;"data statements":STOP
ns=ns+1
RETURN

DefinePLayFieLd:
SCREEN 1,320,200,4,1
WINDOW 1,"Climber 5",,2,1
RESTORE DefinePLayFieLd
FOR i=0 TO 7
READ a!,b!,c!
PALETTE i,a!,b!,c!
PALETTE i+8,a!,b!,c!
NEXT :PALETTE 8,.25,.25,.25
DATA .45, .45, .6, .1, .1, .1, .85, .85, .8, .8, .7, .7
DATA .85, .1, .1, .6, .45, .4, .45, .4, .3, 1, .6, .5
RETURN