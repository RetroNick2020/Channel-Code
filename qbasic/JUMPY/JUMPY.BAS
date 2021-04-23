DECLARE SUB UpdateJumpRight ()
DECLARE SUB StartJumpRight ()
DECLARE SUB Land ()
DECLARE FUNCTION CanLandOnPlatform% ()
DECLARE SUB JumpDown (num%)
DECLARE SUB UpdateKeyStatus ()
DECLARE SUB Fall ()
DECLARE FUNCTION CanFall% ()
DECLARE SUB UpdateJumpLeft ()
DECLARE SUB StartJumpLeft ()
DECLARE SUB StartJump ()
DECLARE SUB UpdateJump ()
DECLARE SUB Jump ()
DECLARE FUNCTION CanJump% ()
DECLARE SUB MoveDown ()
DECLARE FUNCTION CanMoveDown% ()
DECLARE SUB MoveUp ()
DECLARE FUNCTION CanMoveUp% ()
DECLARE SUB DrawMapValues ()
DECLARE SUB MoveRight ()
DECLARE SUB MoveLeft ()
DECLARE SUB MapMultiply (x%, y%, xmult%, ymult%, v%)
DECLARE FUNCTION CanMoveLeft% ()
DECLARE FUNCTION CanMoveRight% ()
DECLARE SUB Str2Map (mywidth%, myheight%)
DECLARE SUB DrawMapWorld (mywidth%, myheight%, xstep%, ystep%)
DECLARE SUB PutTrans (x%, y%, Image%(), Mask%())
DECLARE SUB Str2Mask16 (mywidth%, myheight%, Image%(), MaskChar$)
DECLARE SUB Char2Map (x%, y%, mapchar$)
DECLARE FUNCTION GetCharSetMask$ ()
DECLARE SUB Str2Mask32 (mywidth%, myheight%, Image%(), MaskChar$)
DECLARE FUNCTION GetCharSetMode% ()
DECLARE SUB DrawPatternTrans (x%, y%, x2%, y2%, Image%(), Mask%())
DECLARE SUB DrawPattern (x%, y%, x2%, y%, Image%())
DECLARE SUB SetMapCharMode (mode%, MaskChar$)
DECLARE SUB MapCharClear ()
DECLARE SUB MapCharToColor (cc$, col%)
DECLARE SUB Str2Image32 (mywidth%, myheight%, Image%())
DECLARE SUB StrImg2Int8 (StrImg$, i1%, i2%, i3%, i4%, i5%, i6%, i7%, i8%)
DECLARE SUB Str2Image16 (mywidth%, myheight%, Image%())
DECLARE SUB StrImg2Int4 (StrImg$, i1%, i2%, i3%, i4%)
DECLARE FUNCTION GetCharColor% (cc$)
CONST MAXCOLORMAP = 100
DIM SHARED ColorMapChar(MAXCOLORMAP) AS STRING * 1
DIM SHARED ColorMapColor(MAXCOLORMAP) AS INTEGER
DIM SHARED MapCharMask$
DIM SHARED MapCharMode%
DIM SHARED MapColorCount%
DIM SHARED MapWorld%(150, 180)
DIM SHARED MapTiles%(40, 40)


DIM SHARED PlayerOnLadder%
DIM SHARED PlayerOnJump%
DIM SHARED JumpPosition%
DIM SHARED JumpTimer!
DIM SHARED JumpStart!
DIM SHARED JumpDelay!
DIM SHARED JumpType%
DIM SHARED JumpOnAscend%
DIM SHARED JumpOnDescend%
DIM SHARED LeftKeyStatus%
DIM SHARED RightKeyStatus%
DIM SHARED UpKeyStatus%
DIM SHARED DownKeyStatus%
DIM SHARED XM%, YM%

DIM SHARED xpos%, ypos%, lastx%, lasty%


DIM SHARED JumpKeyStatus%
DIM SHARED QuitKeyStatus%

'$RESIZE:STRETCH
LeftKeyStatus% = 0
RightKeyStatus% = 0
UpKeyStatus% = 0
DownKeyStatus% = 0

JumpKeyStatus% = 0
QuitKeyStatus% = 0

JumpType% = 0
JumpPosition% = 0
JumpOnAscend% = 0
JumpOnDescend = 0

PlayerOnJump% = 0
PlayerOnLadder% = 0

MapColorCount% = 0
MapCharMode% = 0
MapCharMask$ = " "

XM% = 4
YM% = 4

SCREEN 7
RESTORE mushroom

DIM TImage%(500)
DIM TImage2%(500)
DIM TImage3%(500)
DIM MushRoomImg%(500)

DIM SHARED BorderImg%(500)
DIM SHARED BorderMask%(500)

DIM SHARED LadderImg%(500)
DIM SHARED LadderMask%(500)

DIM SHARED GuyStandImg%(500)
DIM SHARED GuyStandMask%(500)
DIM SHARED GuyWalkImg%(500)
DIM SHARED GuyWalkMask%(500)

DIM SHARED CurrentXPos%
DIM SHARED CurrentYPos%

CurrentXPos% = 10
CurrentYPos% = 10





RESTORE mushroom
CALL Str2Image16(16, 7, TImage%())
PUT (200, 150), TImage%


RESTORE Border
CALL MapCharClear
CALL SetMapCharMode(0, " ")
CALL MapCharToColor("r", 7)
CALL MapCharToColor("R", 4)
CALL Str2Image16(16, 12, BorderImg%())
RESTORE Border
CALL Str2Mask16(16, 12, BorderMask%(), " ")





CALL SetMapCharMode(0, " ")
CALL MapCharToColor("X", 15)
RESTORE Ladder
CALL Str2Image16(16, 12, LadderImg%())
RESTORE Ladder
CALL Str2Mask16(16, 12, LadderMask%(), " ")



CALL MapCharClear
CALL SetMapCharMode(0, " ")
CALL MapCharToColor("R", 5)
CALL MapCharToColor("G", 6)
CALL MapCharToColor("B", 7)


RESTORE guywalkleft
CALL Str2Image16(16, 16, GuyStandImg%())
RESTORE guywalkleft
CALL Str2Mask16(16, 16, GuyStandMask%(), " ")
RESTORE guywalkleft2
CALL Str2Image16(16, 16, GuyWalkImg%())
RESTORE guywalkleft2
CALL Str2Mask16(16, 16, GuyWalkMask%(), " ")


RESTORE map
CALL Str2Map(16, 14)
CALL DrawMapWorld(16, 14, 16, 12)

xpos% = 40 * 4
ypos% = 17 * 4
lastx% = 0
lasty% = 0
frame% = 0

REM CALL DrawMapValues
KeyTimer! = TIMER

WHILE QuitKeyStatus% <> 1
    CALL UpdateKeyStatus

    IF TIMER > (KeyTimer! + .05) THEN
        KeyTimer! = TIMER

        REM a$ = INKEY$
        REM SCREEN 7, 0, 1, 1
        REM LOCATE 3, 1
        REM PRINT TIMER; " "; a$
        REM  SCREEN 7, 0, 1, 0
    
        IF JumpType% = 1 THEN
            CALL UpdateJump
        ELSEIF JumpType% = 2 THEN
            CALL UpdateJumpLeft
        ELSEIF JumpType% = 3 THEN
            CALL UpdateJumpRight
        END IF
 
        IF RightKeyStatus% = 1 THEN
            IF CanMoveRight% > 0 THEN
                CALL MoveRight
            END IF
        END IF
        IF LeftKeyStatus% = 1 THEN
            IF CanMoveLeft% > 0 THEN
                CALL MoveLeft
            END IF
        END IF
        IF DownKeyStatus% = 1 THEN
            IF CanMoveDown% > 0 THEN
                CALL MoveDown
            END IF

        END IF
        IF UpKeyStatus% = 1 THEN
            IF CanMoveUp% > 0 THEN
                CALL MoveUp
            END IF
        END IF

        IF JumpKeyStatus% = 1 THEN
            IF CanJump% > 0 THEN
                IF LeftKeyStatus% = 1 THEN
                    JumpType% = 2
                    CALL StartJumpLeft
                ELSEIF RightKeyStatus% = 1 THEN
                    JumpType% = 3
                    CALL StartJumpRight
                ELSE
                    JumpType% = 1
                    CALL StartJump
                END IF
            END IF
        END IF

        IF JumpOnDescend% = 1 THEN
            IF CanLandOnPlatform > 0 THEN
                CALL Land
            END IF
        END IF

        IF CanFall > 0 THEN
            Fall
        END IF
    END IF

    IF (lastx% <> xpos%) OR (lasty% <> ypos%) THEN
        SCREEN 7, 0, 1, 0
        PCOPY 0, 1
        IF frame% = 0 THEN
            PUT (xpos%, ypos% - 12), GuyStandMask%, AND
            PUT (xpos%, ypos% - 12), GuyStandImg%, OR
            frame% = 1
        ELSE
            PUT (xpos%, ypos% - 12), GuyWalkMask%, AND
            PUT (xpos%, ypos% - 12), GuyWalkImg%, OR
            frame% = 0
        END IF
    
        LINE (xpos%, ypos%)-(xpos% + 3, ypos% + 3), 15, BF
        SCREEN 7, 0, 0, 1
        lastx% = xpos%
        lasty% = ypos%
    END IF

WEND

Ladder:
DATA "X              X"
DATA "X              X"
DATA "XXXXXXXXXXXXXXXX"
DATA "X              X"
DATA "X              X"
DATA "X              X"
DATA "X              X"
DATA "X              X"
DATA "XXXXXXXXXXXXXXXX"
DATA "X              X"
DATA "X              X"
DATA "X              X"


Square:
DATA "XXXXXXXXXXXXXXXX"
DATA "X              X"
DATA "X              X"
DATA "X              X"
DATA "X              X"
DATA "X              X"
DATA "XXXXXXXXXXXXXXXX"


mushroom:
DATA "     XXXXXX     "
DATA "   XXXXXXXXXX   "
DATA "  XXXXXXXXXXXX  "
DATA "    XX XX XX    "
DATA "       XX       "
DATA "       XX       "
DATA "       XX       "

Border:
DATA "RRRRRRRRRRRRRRRR"
DATA "RRRRRRRRRRRRRRRR"
DATA "RRR          RRR"
DATA "  RRR      RRR  "
DATA "    RRR  RRR    "
DATA "       RR       "
DATA "       RR       "
DATA "    RRR  RRR    "
DATA "  RRR      RRR  "
DATA "RRR          RRR"
DATA "RRRRRRRRRRRRRRRR"
DATA "RRRRRRRRRRRRRRRR"


guywalkleft:
DATA "     RRRRRR     "
DATA "  RRRRRRRRRR    "
DATA "    BGBBGGGG    "
DATA "  BBBGBBBGBGG   "
DATA " BBBGBBBGGBGG   "
DATA "  GGGGBBBBGGG   "
DATA "   BBBBBBBB     "
DATA "     GGRRGGGGG  "
DATA "BBBGGGRRRGGGGBBB"
DATA "BBGGRRRBRGGGBBBB"
DATA " GG RRRRRRRR BBB"
DATA " GGRRRRRRRRRR   "
DATA " GGRRRRRRRRRRR  "
DATA " GGRRRR  RRRGGG "
DATA "           GGGG "
DATA "          GGGG  "

guywalkleft2:
DATA "     RRRRRR     "
DATA "  RRRRRRRRRR    "
DATA "    BGBBGGGG    "
DATA "  BBBGBBBGBGG   "
DATA " BBBGBBBGGBGG   "
DATA "  GGGGBBBBGGG   "
DATA "   BBBBBBBB     "
DATA "     GGRRGGGGG  "
DATA "BBBGGGRRRGGGGBBB"
DATA "BBGGRRRBRGGGBBBB"
DATA " GG RRRRRRRR BBB"
DATA " GGRRRRRRRRRR   "
DATA " GGRRRRRRRRRRR  "
DATA " GGRRRR  RRRGGG "
DATA "   GGGG         "
DATA "  GGGG          "





map:
DATA "L###############################"
DATA "                 L              "
DATA "                 L              "
DATA "### ### ### ### #L              "
DATA "L                L              "
DATA "L                               "
DATA "###### #################        "
DATA "         L    L                 "
DATA "         L    L                 "
DATA "         L    L                 "
DATA "  #########$$@@                 "
DATA "    L                           "
DATA "    L                           "
DATA "################################"

FUNCTION CanFall%
    CurrentXPos% = xpos% / XM%
    CurrentYPos% = ypos% / YM%
    CanFall% = 0
    IF PlayerOnJump% = 0 AND MapWorld%(CurrentXPos%, CurrentYPos% + 1) = 0 THEN
        CanFall% = 1
    END IF
END FUNCTION

FUNCTION CanJump%
    CanJump% = 0
    IF PlayerOnLadder% = 0 THEN
        CanJump% = 1
    END IF
END FUNCTION

FUNCTION CanLandOnPlatform%
    CanLandOnPlatform% = 0
    CurrentXPos% = xpos% / XM%
    CurrentYPos% = ypos% / YM%

    IF MapWorld%(CurrentXPos%, CurrentYPos% + 1) = 1 AND MapWorld%(CurrentXPos%, CurrentYPos% + 2) = 1 AND MapWorld%(CurrentXPos%, CurrentYPos% + 3) = 1 THEN
        CanLandOnPlatform% = 1
    END IF
END FUNCTION

FUNCTION CanMoveDown%
    CanMoveDown% = 0
    CurrentXPos% = xpos% / XM%
    CurrentYPos% = ypos% / YM%
    IF PlayerOnLadder% > 0 AND MapWorld%(CurrentXPos%, CurrentYPos% + 1) <> 1 THEN
        CanMoveDown% = 1
    ELSEIF MapWorld%(CurrentXPos%, CurrentYPos% + 4) = 2 THEN
        CanMoveDown% = 1
    END IF
END FUNCTION

FUNCTION CanMoveLeft%
    CanMoveLeft% = 0
    CurrentXPos% = xpos% / XM%
    CurrentYPos% = ypos% / YM%
    LOCATE 1, 1
    PRINT xpos%, ypos%
    LOCATE 2, 1
    PRINT CurrentXPos%, CurrentYPos%
   
    IF MapWorld%(CurrentXPos% - 1, CurrentYPos% + 1) = 1 AND MapWorld%(CurrentXPos% - 1, CurrentYPos%) <> 1 THEN
        CanMoveLeft% = 1
    END IF
END FUNCTION

FUNCTION CanMoveRight%
    CanMoveRight% = 0
    CurrentXPos% = xpos% / XM%
    CurrentYPos% = ypos% / YM%

    IF MapWorld%(CurrentXPos% + 1, CurrentYPos% + 1) = 1 AND MapWorld%(CurrentXPos% + 1, CurrentYPos%) <> 1 THEN
        CanMoveRight% = 1
    END IF
END FUNCTION

FUNCTION CanMoveUp%
    CanMoveUp% = 0
    CurrentXPos% = xpos% / XM%
    CurrentYPos% = ypos% / YM%
    IF PlayerOnLadder% > 0 AND MapWorld%(CurrentXPos%, CurrentYPos%) <> 0 THEN
        CanMoveUp% = 1
    ELSEIF MapWorld%(CurrentXPos%, CurrentYPos% - 1) = 2 THEN
        CanMoveUp% = 1
    END IF
END FUNCTION

SUB Char2Map (x%, y%, mapchar$)
    IF mapchar$ = "#" THEN
        CALL MapMultiply(x% * 4, y% * 3, 4, 3, 1)
        MapTiles%(x%, y%) = 1
    ELSEIF mapchar$ = "$" THEN
        MapTiles%(x%, y%) = 4
        CALL MapMultiply(x% * 4, y% * 3 - 1, 4, 3, 1)
    ELSEIF mapchar$ = "@" THEN
        MapTiles%(x%, y%) = 5
        CALL MapMultiply(x% * 4, y% * 3 - 2, 5, 3, 1)
    ELSEIF mapchar$ = "L" THEN
        MapTiles%(x%, y%) = 2
        CALL MapMultiply(x% * 4, y% * 3, 4, 3, 2)
    ELSEIF mapchar$ = "M" THEN
        MapTiles%(x%, y%) = 3
        CALL MapMultiply(x% * 4, y% * 3, 4, 3, 3)
    END IF
END SUB

SUB DrawMapValues
    DIM i%, j%
    REM LINE (0, 0)-(40, 40), 1, BF
    FOR j% = 0 TO 40
        FOR i% = 0 TO 60
            IF MapWorld%(i%, j%) = 1 THEN
                cl% = 1
            ELSEIF MapWorld%(i%, j%) = 2 THEN
                cl% = 2
            ELSEIF MapWorld%(i%, j%) = 3 THEN
                cl% = 3
            END IF


            LINE (i% * 4, j% * 4)-(i% * 4 + 3, j% * 4 + 3), cl%, B
            cl% = 0
        NEXT i%
    NEXT j%
END SUB

SUB DrawMapWorld (mywidth%, myheight%, xstep%, ystep%)
    DIM i%, j%, x%, y%
    x% = 0
    y% = 0

    FOR j% = 0 TO myheight% - 1
        x% = 0
        FOR i% = 0 TO mywidth% - 1

            IF MapTiles%(i%, j%) = 1 THEN
                CALL PutTrans(x%, y%, BorderImg%(), BorderMask%())
            ELSEIF MapTiles%(i%, j%) = 2 THEN
                CALL PutTrans(x%, y%, LadderImg%(), LadderMask%())
            ELSEIF MapTiles%(i%, j%) = 4 THEN
                CALL PutTrans(x%, y% - 4, BorderImg%(), BorderMask%())
            ELSEIF MapTiles%(i%, j%) = 5 THEN
                CALL PutTrans(x%, y% - 8, BorderImg%(), BorderMask%())
            END IF
      
            x% = x% + 16
        NEXT i%
        y% = y% + 12
    
    NEXT j%
END SUB

SUB DrawPattern (x%, y%, x2%, y2%, Image%())
    DIM xstep%, ystep%, i%, j&
    xstep% = Image%(0)
    ystep% = Image%(1)
    REM LINE (x% - 1, y% - 1)-(x2% + 1, y2% + 1), 4, BF
    FOR j% = y% TO y2% STEP ystep%
        FOR i% = x% TO x2% STEP xstep%
            PUT (i%, j%), Image%, PSET
        NEXT i%
    NEXT j%
END SUB

SUB DrawPatternTrans (x%, y%, x2%, y2%, Image%(), Mask%())
    DIM xstep%, ystep%, i%, j&
    xstep% = Image%(0)
    ystep% = Image%(1)
    REM LINE (x% - 1, y% - 1)-(x2% + 1, y2% + 1), 4, BF
    FOR j% = y% TO y2% STEP ystep%
        FOR i% = x% TO x2% STEP xstep%
            PUT (i%, j%), Mask%, AND
            PUT (i%, j%), Image%, OR
        NEXT i%
    NEXT j%
END SUB

SUB Fall
    ypos% = ypos% + 1

    CurrentYPos% = ypos% / YM%
    CurrentXPos% = xpos% / XM%

    IF MapWorld%(CurrentXPos%, CurrentYPos% + 1) <> 0 THEN
        ypos% = (CurrentYPos%) * YM%
        EXIT SUB
    END IF
END SUB

FUNCTION GetCharColor% (cc$)
    FOR i = 1 TO MapColorCount%
        IF (ColorMapChar(i) = cc$) THEN
            GetCharColor = ColorMapColor(i)
            EXIT FUNCTION
        END IF
    NEXT i
    GetCharColor = 0
END FUNCTION

FUNCTION GetCharSetMask$
    GetCharSetMask$ = MapCharMask$
END FUNCTION

FUNCTION GetCharSetMode%
    GetCharSetMode% = MapCharMode%
END FUNCTION

SUB JumpDown (num%)
    DIM i%
    FOR i% = 1 TO num%
        ypos% = ypos% + 1
        CurrentXPos% = xpos% / XM%
        CurrentYPos% = ypos% / YM%
        IF MapWorld%(CurrentXPos%, CurrentYPos% + 1) <> 0 THEN
            ypos% = (CurrentYPos%) * YM%
            EXIT SUB
        END IF
    NEXT i%
END SUB

SUB JumpUp (num)

END SUB

SUB Land
    CALL JumpDown(4)
    JumpOnDescend% = 0
    PlayerOnJump% = 0
END SUB

SUB MapCharClear
    MapColorCount% = 0
END SUB

SUB MapCharToColor (cc$, col%)
    MapColorCount% = MapColorCount% + 1
    ColorMapChar(MapColorCount%) = cc$
    ColorMapColor(MapColorCount%) = col%
END SUB

SUB MapMultiply (x%, y%, xmult%, ymult%, v%)
    DIM i%, j%
    FOR i% = 1 TO xmult%
        FOR j% = 1 TO ymult%
            MapWorld%(x% + i% - 1, y% + j% - 1) = v%
        NEXT j%
    NEXT i%
END SUB

SUB MoveDown
    ypos% = ypos% + YM%
    PlayerOnLadder% = 1
      
END SUB

SUB MoveLeft
    xpos% = xpos% - XM%
    PlayerOnLadder% = 0
END SUB

SUB MoveRight
    xpos% = xpos% + XM%
    PlayerOnLadder% = 0
END SUB

SUB MoveUp
    ypos% = ypos% - YM%
    PlayerOnLadder% = 1
END SUB

SUB PutTrans (x%, y%, Image%(), Mask%())
    IF (x% > 300 OR y% > 180) THEN
        EXIT SUB
    END IF

    REM PRINT x%, y%
    REM INPUT a$
    PUT (x%, y%), Mask%, AND
    PUT (x%, y%), Image%, OR

END SUB

SUB SetMapCharMode (mode%, MaskChar$)
    MapCharMode% = mode%
    MapCharMask$ = MaskChar$
END SUB

SUB StartJump
    IF PlayerOnJump% = 0 THEN
        PlayerOnJump% = 1
        JumpPosition% = 1
        JumpStart! = TIMER
        JumpDelay! = .1
        ypos% = ypos% - 1
    END IF
END SUB

SUB StartJumpLeft
    IF PlayerOnJump% = 0 THEN
        PlayerOnJump% = 1
        JumpPosition% = 1
        JumpStart! = TIMER
        JumpDelay! = .1
        ypos% = ypos% - 2
        xpos% = xpos% - 4
    END IF
END SUB

SUB StartJumpRight
    IF PlayerOnJump% = 0 THEN
        PlayerOnJump% = 1
        JumpPosition% = 1
        JumpStart! = TIMER
        JumpDelay! = .1
        ypos% = ypos% - 2
        xpos% = xpos% + 4
    END IF
END SUB

SUB Str2Image16 (mywidth%, myheight%, Image%())
    DIM i%, ImageStr$, pcount%
    pcount% = 2
    Image%(0) = mywidth%
    Image%(1) = myheight%
    FOR i% = 1 TO myheight%
        READ ImageStr$
        CALL StrImg2Int4(ImageStr$, Image%(pcount%), Image%(pcount% + 1), Image%(pcount% + 2), Image%(pcount% + 3))
        pcount% = pcount% + 4
    NEXT i%
END SUB

SUB Str2Image32 (mywidth%, myheight%, Image%())
    DIM i%, ImageStr$, pcount%
    pcount% = 2
    Image%(0) = mywidth%
    Image%(1) = myheight%

    FOR i% = 1 TO myheight%
        READ ImageStr$
        CALL StrImg2Int8(ImageStr$, Image%(pcount%), Image%(pcount% + 1), Image%(pcount% + 2), Image%(pcount% + 3), Image%(pcount% + 4), Image%(pcount% + 5), Image%(pcount% + 6), Image%(pcount% + 7))
        pcount% = pcount% + 8
    NEXT i%
END SUB

SUB Str2Map (mywidth%, myheight%)
    DIM i%, j%, mapchar$, mapstr$
    FOR j% = 0 TO myheight% - 1
        READ mapstr$
        FOR i% = 1 TO mywidth%
            mapchar$ = MID$(mapstr$, i%, 1)
            CALL Char2Map(i% - 1, j%, mapchar$)
        NEXT i%
    NEXT j%
END SUB

SUB Str2Mask16 (mywidth%, myheight%, Image%(), MaskChar$)
    DIM CMaskMode%, CMaskChar$
    CMaskMode% = GetCharSetMode%
    CMaskChar$ = GetCharSetMask$
  
    CALL SetMapCharMode(1, MaskChar$)
    CALL Str2Image16(mywidth%, myheight%, Image%())
    CALL SetMapCharMode(CMaskMode%, CMaskChar$)
END SUB

SUB Str2Mask32 (mywidth%, myheight%, Image%(), MaskChar$)
    DIM CMaskMode%, CMaskChar$
    CMaskMode% = GetCharSetMode%
    CMaskChar$ = GetCharSetMask$
  
    CALL SetMapCharMode(1, MaskChar$)
    CALL Str2Image32(mywidth%, myheight%, Image%())
    CALL SetMapCharMode(CMaskMode%, CMaskChar$)
END SUB

SUB StrImg2Int4 (StrImg$, i1%, i2%, i3%, i4%)
    DIM i AS INTEGER
    DIM col AS INTEGER
    DIM charcolor AS STRING * 1
    DIM bitvalue AS INTEGER

    i1% = 0
    i2% = 0
    i3% = 0
    i4% = 0

    FOR i = 1 TO 16
        charcolor = MID$(StrImg$, i, 1)
        col = GetCharColor(charcolor)

        IF MapCharMode% = 1 THEN
            IF charcolor = MapCharMask$ THEN
                col = 15
            ELSE
                col = 0
            END IF
        END IF

        bitvalue = 0
        IF (i = 1) THEN
            bitvalue = 128
        ELSEIF (i = 2) THEN
            bitvalue = 64
        ELSEIF (i = 3) THEN
            bitvalue = 32
        ELSEIF (i = 4) THEN
            bitvalue = 16
        ELSEIF (i = 5) THEN
            bitvalue = 8
        ELSEIF (i = 6) THEN
            bitvalue = 4
        ELSEIF (i = 7) THEN
            bitvalue = 2
        ELSEIF (i = 8) THEN
            bitvalue = 1
        ELSEIF (i = 9) THEN
            bitvalue = -32768
        ELSEIF (i = 10) THEN
            bitvalue = 16384
        ELSEIF (i = 11) THEN
            bitvalue = 8192
        ELSEIF (i = 12) THEN
            bitvalue = 4096
        ELSEIF (i = 13) THEN
            bitvalue = 2048
        ELSEIF (i = 14) THEN
            bitvalue = 1024
        ELSEIF (i = 15) THEN
            bitvalue = 512
        ELSEIF (i = 16) THEN
            bitvalue = 256
        END IF

        IF col = 1 THEN
            i1% = i1% + bitvalue
        ELSEIF col = 2 THEN
            i2% = i2% + bitvalue
        ELSEIF col = 3 THEN
            i1% = i1% + bitvalue
            i2% = i2% + bitvalue
        ELSEIF col = 4 THEN
            i3% = i3% + bitvalue
        ELSEIF col = 5 THEN
            i1% = i1% + bitvalue
            i3% = i3% + bitvalue
        ELSEIF col = 6 THEN
            i2% = i2% + bitvalue
            i3% = i3% + bitvalue
        ELSEIF col = 7 THEN
            i1% = i1% + bitvalue
            i2% = i2% + bitvalue
            i3% = i3% + bitvalue
        ELSEIF col = 8 THEN
            i4% = i4% + bitvalue
        ELSEIF col = 9 THEN
            i1% = i1% + bitvalue
            i4% = i4% + bitvalue
        ELSEIF col = 10 THEN
            i2% = i2% + bitvalue
            i4% = i4% + bitvalue
        ELSEIF col = 11 THEN
            i1% = i1% + bitvalue
            i2% = i2% + bitvalue
            i4% = i4% + bitvalue
        ELSEIF col = 12 THEN
            i3% = i3% + bitvalue
            i4% = i4% + bitvalue
        ELSEIF col = 13 THEN
            i1% = i1% + bitvalue
            i3% = i3% + bitvalue
            i4% = i4% + bitvalue
        ELSEIF col = 14 THEN
            i2% = i2% + bitvalue
            i3% = i3% + bitvalue
            i4% = i4% + bitvalue
        ELSEIF col = 15 THEN
            i1% = i1% + bitvalue
            i2% = i2% + bitvalue
            i3% = i3% + bitvalue
            i4% = i4% + bitvalue
        END IF

    NEXT i
END SUB

SUB StrImg2Int8 (StrImg$, i1%, i2%, i3%, i4%, i5%, i6%, i7%, i8%)
    DIM i AS INTEGER
    DIM col AS INTEGER
    DIM charcolor AS STRING * 1
    DIM bitvalue AS INTEGER
    DIM bitvalue2 AS INTEGER

    i1% = 0
    i2% = 0
    i3% = 0
    i4% = 0
    i5% = 0
    i6% = 0
    i7% = 0
    i8% = 0

    FOR i = 1 TO 32
        bitvalue = 0
        bitvalue2 = 0
        charcolor = MID$(StrImg$, i, 1)
  
        col = GetCharColor(charcolor)

        IF MapCharMode% = 1 THEN
            IF charcolor = MapCharMask$ THEN
                col = 15
            ELSE
                col = 0
            END IF
        END IF

        IF (i = 1) THEN
            bitvalue = 128
        ELSEIF (i = 2) THEN
            bitvalue = 64
        ELSEIF (i = 3) THEN
            bitvalue = 32
        ELSEIF (i = 4) THEN
            bitvalue = 16
        ELSEIF (i = 5) THEN
            bitvalue = 8
        ELSEIF (i = 6) THEN
            bitvalue = 4
        ELSEIF (i = 7) THEN
            bitvalue = 2
        ELSEIF (i = 8) THEN
            bitvalue = 1
        ELSEIF (i = 9) THEN
            bitvalue = -32768
        ELSEIF (i = 10) THEN
            bitvalue = 16384
        ELSEIF (i = 11) THEN
            bitvalue = 8192
        ELSEIF (i = 12) THEN
            bitvalue = 4096
        ELSEIF (i = 13) THEN
            bitvalue = 2048
        ELSEIF (i = 14) THEN
            bitvalue = 1024
        ELSEIF (i = 15) THEN
            bitvalue = 512
        ELSEIF (i = 16) THEN
            bitvalue = 256
        ELSEIF (i = 17) THEN
            bitvalue2 = 128
        ELSEIF (i = 18) THEN
            bitvalue2 = 64
        ELSEIF (i = 19) THEN
            bitvalue2 = 32
        ELSEIF (i = 20) THEN
            bitvalue2 = 16
        ELSEIF (i = 21) THEN
            bitvalue2 = 8
        ELSEIF (i = 22) THEN
            bitvalue2 = 4
        ELSEIF (i = 23) THEN
            bitvalue2 = 2
        ELSEIF (i = 24) THEN
            bitvalue2 = 1
        ELSEIF (i = 25) THEN
            bitvalue2 = -32768
        ELSEIF (i = 26) THEN
            bitvalue2 = 16384
        ELSEIF (i = 27) THEN
            bitvalue2 = 8192
        ELSEIF (i = 28) THEN
            bitvalue2 = 4096
        ELSEIF (i = 29) THEN
            bitvalue2 = 2048
        ELSEIF (i = 30) THEN
            bitvalue2 = 1024
        ELSEIF (i = 31) THEN
            bitvalue2 = 512
        ELSEIF (i = 32) THEN
            bitvalue2 = 256
        END IF

        IF col = 1 THEN
            i1% = i1% + bitvalue
            i2% = i2% + bitvalue2
        ELSEIF col = 2 THEN
            i3% = i3% + bitvalue
            i4% = i4% + bitvalue2
        ELSEIF col = 3 THEN
            i1% = i1% + bitvalue
            i3% = i3% + bitvalue
            i2% = i2% + bitvalue2
            i4% = i4% + bitvalue2
        ELSEIF col = 4 THEN
            i5% = i5% + bitvalue
            i6% = i6% + bitvalue2
        ELSEIF col = 5 THEN
            i1% = i1% + bitvalue
            i5% = i5% + bitvalue
            i2% = i2% + bitvalue2
            i6% = i6% + bitvalue2
        ELSEIF col = 6 THEN
            i3% = i3% + bitvalue
            i5% = i5% + bitvalue
            i4% = i4% + bitvalue2
            i6% = i6% + bitvalue2
        ELSEIF col = 7 THEN
            i1% = i1% + bitvalue
            i3% = i3% + bitvalue
            i5% = i5% + bitvalue
            i2% = i2% + bitvalue2
            i4% = i4% + bitvalue2
            i6% = i6% + bitvalue2
        ELSEIF col = 8 THEN
            i7% = i7% + bitvalue
            i8% = i8% + bitvalue2
        ELSEIF col = 9 THEN
            i1% = i1% + bitvalue
            i7% = i7% + bitvalue
            i2% = i2% + bitvalue2
            i8% = i8% + bitvalue2
        ELSEIF col = 10 THEN
            i3% = i3% + bitvalue
            i7% = i7% + bitvalue
            i4% = i4% + bitvalue2
            i8% = i8% + bitvalue2
        ELSEIF col = 11 THEN
            i1% = i1% + bitvalue
            i3% = i3% + bitvalue
            i7% = i7% + bitvalue
            i2% = i2% + bitvalue2
            i4% = i4% + bitvalue2
            i8% = i8% + bitvalue2
        ELSEIF col = 12 THEN
            i5% = i5% + bitvalue
            i7% = i7% + bitvalue
            i6% = i6% + bitvalue2
            i8% = i8% + bitvalue2
        ELSEIF col = 13 THEN
            i1% = i1% + bitvalue
            i5% = i5% + bitvalue
            i7% = i7% + bitvalue
            i2% = i2% + bitvalue2
            i6% = i6% + bitvalue2
            i8% = i8% + bitvalue2
        ELSEIF col = 14 THEN
            i3% = i3% + bitvalue
            i5% = i5% + bitvalue
            i7% = i7% + bitvalue
            i4% = i4% + bitvalue2
            i6% = i6% + bitvalue2
            i8% = i8% + bitvalue2
        ELSEIF col = 15 THEN
            i1% = i1% + bitvalue
            i3% = i3% + bitvalue
            i5% = i5% + bitvalue
            i7% = i7% + bitvalue
            i2% = i2% + bitvalue2
            i4% = i4% + bitvalue2
            i6% = i6% + bitvalue2
            i8% = i8% + bitvalue2
        END IF
    NEXT i
END SUB

SUB UpdateJump
    IF PlayerOnJump% > 0 THEN
        JumpTimer! = TIMER
        IF JumpTimer! > (JumpStart! + JumpDelay!) THEN
            JumpPosition% = JumpPosition% + 1
            JumpStart! = TIMER
            IF JumpPosition% = 2 THEN
                JumpDelay! = .1
                ypos% = ypos% - 4
            ELSEIF JumpPosition% = 3 THEN
                JumpDelay! = .1
                ypos% = ypos% - 6
            ELSEIF JumpPosition% = 4 THEN
                JumpDelay! = .08
                REM ypos% = ypos% + 1
                CALL JumpDown(2)
            ELSEIF JumpPosition% = 5 THEN
                JumpDelay! = .07
                REM ypos% = ypos% + 1
                CALL JumpDown(2)
            ELSEIF JumpPosition% = 6 THEN
                JumpDelay! = .06
                REM ypos% = ypos% + 1
                CALL JumpDown(2)
            ELSEIF JumpPosition% = 7 THEN
                JumpDelay! = .04
                REM ypos% = ypos% + 1
                CALL JumpDown(2)
            ELSEIF JumpPosition% = 8 THEN
                JumpDelay! = .02
                REM ypos% = ypos% + 1
                CALL JumpDown(2)
            ELSEIF JumpPosition% = 9 THEN
                JumpDelay! = .01
                REM ypos% = ypos% + 1
                CALL JumpDown(2)
                PlayerOnJump% = 0
            END IF
        END IF
    END IF
END SUB

SUB UpdateJumpLeft
    IF PlayerOnJump% > 0 THEN
        IF JumpPosition% > 4 THEN
            JumpOnDescend% = 1
        END IF
        JumpTimer! = TIMER
        IF JumpTimer! > (JumpStart! + JumpDelay!) THEN
            JumpPosition% = JumpPosition% + 1
            JumpStart! = TIMER
            IF JumpPosition% = 2 THEN
                JumpDelay! = .1
                ypos% = ypos% - 4
                xpos% = xpos% - 4
            ELSEIF JumpPosition% = 3 THEN
                JumpDelay! = .1
                ypos% = ypos% - 6
                xpos% = xpos% - 4
            ELSEIF JumpPosition% = 4 THEN
                JumpOnDescend% = 1
                JumpDelay! = .08
                REM ypos% = ypos% + 1
                xpos% = xpos% - 4
                CALL JumpDown(2)
            ELSEIF JumpPosition% = 5 THEN
                JumpDelay! = .07
                REM ypos% = ypos% + 1
                xpos% = xpos% - 4
                CALL JumpDown(2)
            ELSEIF JumpPosition% = 6 THEN
                JumpDelay! = .06
                REM ypos% = ypos% + 1
                xpos% = xpos% - 4
                CALL JumpDown(2)
            ELSEIF JumpPosition% = 7 THEN
                JumpDelay! = .04
                REM ypos% = ypos% + 1
                xpos% = xpos% - 4
                CALL JumpDown(2)
            ELSEIF JumpPosition% = 8 THEN
                JumpDelay! = .02
                REM ypos% = ypos% + 1
                xpos% = xpos% - 4
                CALL JumpDown(2)
            ELSEIF JumpPosition% = 9 THEN
                JumpDelay! = .01
                REM ypos% = ypos% + 1
                xpos% = xpos% - 4
                CALL JumpDown(2)
                PlayerOnJump% = 0
            END IF
        END IF
    END IF
END SUB

SUB UpdateJumpRight
    IF PlayerOnJump% > 0 THEN
        IF JumpPosition% > 4 THEN
            JumpOnDescend% = 1
        END IF
        JumpTimer! = TIMER
        IF JumpTimer! > (JumpStart! + JumpDelay!) THEN
            JumpPosition% = JumpPosition% + 1
            JumpStart! = TIMER
            IF JumpPosition% = 2 THEN
                JumpDelay! = .1
                ypos% = ypos% - 4
                xpos% = xpos% + 4
            ELSEIF JumpPosition% = 3 THEN
                JumpDelay! = .1
                ypos% = ypos% - 6
                xpos% = xpos% + 4
            ELSEIF JumpPosition% = 4 THEN
                JumpDelay! = .08
                JumpOnDescend% = 1
                REM ypos% = ypos% + 2
                CALL JumpDown(2)
                xpos% = xpos% + 4
            ELSEIF JumpPosition% = 5 THEN
                JumpDelay! = .07
                REM ypos% = ypos% + 2
                xpos% = xpos% + 4
                CALL JumpDown(2)
            ELSEIF JumpPosition% = 6 THEN
                JumpDelay! = .06
                REM ypos% = ypos% + 2
                xpos% = xpos% + 4
                CALL JumpDown(2)
            ELSEIF JumpPosition% = 7 THEN
                JumpDelay! = .04
                REM ypos% = ypos% + 2
                xpos% = xpos% + 4
                CALL JumpDown(2)
            ELSEIF JumpPosition% = 8 THEN
                JumpDelay! = .02
                REM ypos% = ypos% + 2
                xpos% = xpos% + 4
                CALL JumpDown(2)
            ELSEIF JumpPosition% = 9 THEN
                JumpDelay! = .01
                REM ypos% = ypos% + 2
                xpos% = xpos% + 4
                CALL JumpDown(2)
                PlayerOnJump% = 0
            END IF
        END IF
    END IF
END SUB

SUB UpdateKeyStatus
    k = INP(&H60)
    
    IF k = 30 THEN
        LeftKeyStatus% = 1
    ELSEIF k = 158 THEN
        LeftKeyStatus% = 0
    ELSEIF k = 31 THEN
        RightKeyStatus% = 1
    ELSEIF k = 159 THEN
        RightKeyStatus% = 0
    ELSEIF k = 36 THEN
        JumpKeyStatus% = 1
    ELSEIF k = 164 THEN
        JumpKeyStatus% = 0
    ELSEIF k = 17 THEN
        UpKeyStatus% = 1
    ELSEIF k = 145 THEN
        UpKeyStatus% = 0
    ELSEIF k = 44 THEN
        DownKeyStatus% = 1
    ELSEIF k = 172 THEN
        DownKeyStatus% = 0
    ELSEIF k = 16 THEN
         QuitKeyStatus% = 1
    END IF
END SUB

