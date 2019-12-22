REM simple tic tac toe game in qb
REM make it better

BP1$ = "1"
BP2$ = "2"
BP3$ = "3"
BP4$ = "4"
BP5$ = "5"
BP6$ = "6"
BP7$ = "7"
BP8$ = "8"
BP9$ = "9"

startgame:
GOSUB printboard

boardpiece$ = "X"
PRINT "Enter move player X ?"
INPUT playerpos
GOSUB placeboardpiece
GOSUB printboard
boardpiece$ = "O"
PRINT "Enter move player O ?"
INPUT playerpos
GOSUB placeboardpiece
GOSUB printboard
GOTO startgame

placeboardpiece:
IF playerpos = 1 THEN BP1$ = boardpiece$
IF playerpos = 2 THEN BP2$ = boardpiece$
IF playerpos = 3 THEN BP3$ = boardpiece$
IF playerpos = 4 THEN BP4$ = boardpiece$
IF playerpos = 5 THEN BP5$ = boardpiece$
IF playerpos = 6 THEN BP6$ = boardpiece$
IF playerpos = 7 THEN BP7$ = boardpiece$
IF playerpos = 8 THEN BP8$ = boardpiece$
IF playerpos = 9 THEN BP9$ = boardpiece$
RETURN

printboard:
PRINT " "; BP1$; " | "; BP2$; " | "; BP3$; "  "
PRINT "---+---+---"
PRINT " "; BP4$; " | "; BP5$; " | "; BP6$; "  "
PRINT "---+---+---"
PRINT " "; BP7$; " | "; BP8$; " | "; BP9$; "  "
PRINT
RETURN

