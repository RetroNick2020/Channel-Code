'Save and Load in all QBasic screen modes

DECLARE SUB SaveScreenFile (filename$, ScreenMode%)
DECLARE SUB ReadScreenFile (filename$)
DECLARE FUNCTION GetScreenWidth% (ScreenMode%)
DECLARE FUNCTION GetScreenHeight% (ScreenMode%)
DECLARE FUNCTION ImageBufferSize& (x%, y%, x2%, y2%, ScreenMode%)

SCREEN 1
LINE (0, 0)-(319, 199), 1, B
CIRCLE (100, 100), 40
CIRCLE (150, 50), 40
CIRCLE (100, 150), 40

CALL SaveScreenFile("screen.img", 1)

SCREEN 13
SCREEN 1

CALL ReadScreenFile("screen.img")
SLEEP 5

FUNCTION GetScreenHeight% (ScreenMode%)
    SELECT CASE ScreenMode%
        CASE 1, 2, 7, 8, 13: GetScreenHeight% = 200
        CASE 9, 10: GetScreenHeight% = 350
        CASE 11, 12: GetScreenHeight% = 480
        CASE ELSE: GetScreenHeight% = 0
    END SELECT
END FUNCTION

FUNCTION GetScreenWidth% (ScreenMode%)
    SELECT CASE ScreenMode%
        CASE 1, 7, 13: GetScreenWidth% = 320
        CASE 2, 8, 9, 10, 11, 12: GetScreenWidth% = 640
        CASE ELSE: GetScreenWidth% = 0
    END SELECT
END FUNCTION

FUNCTION ImageBufferSize& (x%, y%, x2%, y2%, ScreenMode%)
  myWidth& = ABS(x2% - x%) + 1
  myHeight& = ABS(y2% - y%) + 1
    SELECT CASE ScreenMode%
        CASE 1: BPPlane = 2: Planes = 1
        CASE 2, 3, 4, 11: BPPlane = 1: Planes = 1
        CASE 7, 8, 9, 12: BPPlane = 1: Planes = 4
        CASE 10: BPPlane = 1: Planes = 2
        CASE 13: BPPlane = 8: Planes = 1
        CASE ELSE: BPPlane = 0
    END SELECT
    ImageBufferSize& = 4 + INT((myWidth& * BPPlane + 7) / 8) * (myHeight& * Planes) 'return the value to function name.
 
END FUNCTION

SUB ReadScreenFile (filename$)
    OPEN "R", #1, filename$, 2
    FIELD #1, 2 AS c$

    GET #1
    ScreenMode% = CVI(c$)
    GET #1
    myWidth% = CVI(c$)
    GET #1
    myHeight% = CVI(c$)

    size% = ImageBufferSize&(1, 1, myWidth%, 1, ScreenMode%) / 2 - 2
    DIM ImageBuf%(size% + 2)
    pad% = LBOUND(ImageBuf%)

    ImageBuf%(pad%) = myWidth%
    IF ScreenMode% = 1 THEN ImageBuf%(pad%) = myWidth% * 2
    IF ScreenMode% = 13 THEN ImageBuf%(pad%) = myWidth% * 8
    ImageBuf%(pad% + 1) = 1

    FOR j% = 0 TO myHeight% - 1
       FOR i% = 0 TO size% - 1
          GET #1
          ImageBuf%(pad% + i% + 2) = CVI(c$)
       NEXT i%
       PUT (0, j%), ImageBuf%
    NEXT j%
    CLOSE #1
END SUB

SUB SaveScreenFile (filename$, ScreenMode%)
    myWidth% = GetScreenWidth(ScreenMode%)
    myHeight% = GetScreenHeight(ScreenMode%)
   
    size% = ImageBufferSize&(1, 1, myWidth%, 1, ScreenMode%) / 2 - 2
    DIM ImageBuf%(size% + 2)
    pad% = LBOUND(ImageBuf%)
   
    OPEN "R", #1, filename$, 2
    FIELD #1, 2 AS c$

    LSET c$ = MKI$(ScreenMode%)  'screen mode
    PUT #1

    LSET c$ = MKI$(myWidth%)  'width
    PUT #1

    LSET c$ = MKI$(myHeight%)'height
    PUT #1
   
    FOR j% = 0 TO myHeight% - 1
      GET (0, j%)-(myWidth% - 1, j%), ImageBuf%
      FOR i% = 0 TO size% - 1
          LSET c$ = MKI$(ImageBuf%(pad% + i% + 2))
          PUT #1
      NEXT i%
    NEXT j%
    CLOSE #1
END SUB

