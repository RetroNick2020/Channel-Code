REM very basic hangman game
REM make it better

phrase$ = "WHEEL OF FORTUNE"
notfoundcount = 0

GOSUB clearhangman
GOSUB buildguessedphrase
GOSUB printguessedphrase
GOSUB printhangman

DO
    GOSUB guessletter
    GOSUB buildguessedphrase
    GOSUB printguessedphrase
    GOSUB buildhangman
    GOSUB printhangman
    GOSUB checkforwin
LOOP

checkforwin:
IF guessedphrase$ = phrase$ THEN
    PRINT "WINNER!!!!"
    END
ELSEIF notfoundcount > 3 THEN
    PRINT "SORRY YOU LOST!!!"
    END
END IF
RETURN

guessletter:
INPUT "Enter Letter:", letter$
letter$ = UCASE$(MID$(letter$, 1, 1))
IF INSTR(1, phrase$, letter$) > 0 THEN
    foundletters$ = foundletters$ + letter$
ELSE
    notfoundcount = notfoundcount + 1
END IF
RETURN

clearhangman:
hman1$ = ""
hman2$ = ""
hman3$ = ""
hman4$ = ""
RETURN

buildhangman:
IF notfoundcount > 0 THEN hman1$ = "\O/"
IF notfoundcount > 1 THEN hman2$ = " |"
IF notfoundcount > 2 THEN hman3$ = " |"
IF notfoundcount > 3 THEN hman4$ = "/ \"
RETURN

buildguessedphrase:
guessedphrase$ = ""
FOR I = 1 TO LEN(phrase$)
    fletter$ = MID$(phrase$, I, 1)
    IF (INSTR(1, foundletters$, fletter$) > 0) OR (fletter$ = " ") THEN
        guessedphrase$ = guessedphrase$ + fletter$
    ELSE
        guessedphrase$ = guessedphrase$ + "_"
    END IF
NEXT I
RETURN

printguessedphrase:
PRINT guessedphrase$
RETURN

printhangman:
PRINT "+--------+"
PRINT "|       "; hman1$
PRINT "|       "; hman2$
PRINT "|       "; hman3$
PRINT "|       "; hman4$
PRINT "|"
PRINT "|"
RETURN

