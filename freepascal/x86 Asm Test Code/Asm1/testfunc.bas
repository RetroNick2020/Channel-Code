'compile nasm -f obj myfunc.asm myfunc.obj
'to create MYFUNC.OBJ
'
'To create MYFUNC.LIB
'C:\QB45\LIB
'will tell you it does not exist and prompt to create - answer y
'At Operations: line enter MYFUNC.OBJ
'At List File: line enter null
'and this will create MYFUNC.LIB
'
'create MYFUNC.QLB
'C:\QB45\LINK /QU MYFUNC.LIB, MYFUNC.QLB, NULL, C:\QB45\BQLB45.LIB
'and this will create MYFUNC.QLB
'
'to start QB45 with library loaded enter c:\qb45\qb /L MYFUNC.QLB
'

DECLARE SUB PassN (BYVAL n1%, SEG n2%)
DECLARE SUB ChangeN (SEG n1%, SEG n2%)
DECLARE FUNCTION ReturnN% (BYVAL n1%)
DECLARE FUNCTION ReturnN2& (BYVAL n1%)

n1% = 0
n2% = 0
r% = 0
r2& = 0

CALL PassN(n1%, n2%)
'CALL ChangeN(n1%, n2%)
' r% = ReturnN(10)
' r2& = ReturnN2(20)

PRINT "n1= "; n1%; " n2%="; n2%; " r%="; r%; " r2&="; r2&

    

