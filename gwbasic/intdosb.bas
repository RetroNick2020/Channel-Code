100 '*************************************************************
110 '*                        I N T D O S B                      *
120 '*************************************************************
130 '* Assignment outputs as an example of an Interrupt          *
140 '*            a String through a DOS function on'            *
150 '*            the display screen'                            *
160 '*  Author      :MICHAEL TISCHER'                            *
170 '*  developed   :07/30/87                                    *
180 '*  last Update :04/08/89'                                   *
190 '*************************************************************
200 'eg. CALL IA(INTNR%,AH%,AL%,BH%,BL%,CH%,CL%,DH%,DL%,DI%,SI%,ES%,FLAGS%)
210 CLS : KEY OFF
220 PRINT"NOTE: This program can only be started if the GWBASIC was "
230 PRINT"started from the DOS level with the command"
235 PRINT"<GWBASIC /m:60000>."
240 PRINT: PRINT"If this is not the case, please input <s> for Stop."
250 PRINT"otherwise press any key ... ";
260 A$ = INKEY$ : IF A$ = "s" THEN END
270 IF A$ = "" THEN 260
280 PRINT
290 GOSUB 60000 'install function for interrupt call
300 T$ = CHR$(13) + CHR$(10) + "this text was output through"
305 T$ = T$ + "Function 9 of Interrupt 21H ... $"
310 INR% = &H21 'Number of interrupt to be called
320 FKT% = 9 'Number of functions to be called
330 OFSLO% = PEEK(VARPTR(T$)+1) 'LO-Byte Offset address to the String
340 OFSHI% = PEEK(VARPTR(T$)+2) 'HI-Byte Offset address to the String
350 CALL IA(INR%,FKT%,Z%,Z%,Z%,Z%,Z%,OFSHI%,OFSLO%,Z%,Z%,Z%,Z%)
360 PRINT : PRINT : PRINT 'output three blank lines
370 END
380 '
60000 '*************************************************************
60010 '* initialize the routine for the interrupt call             *
60020 '*************************************************************
60030 '* Input: none                                               *
60040 '* Output: IA is the Start address of the Interrupt routine  *
60050 '*************************************************************
60060 'eg. CALL IA(INTNR%,AH%,AL%,BH%,BL%,CH%,CL%,DH%,DL%,DI%,SI%,ES%,FLAGS%)
60070 IA=60000! 'Start address of the routine in the BASIC segment
60080 DEF SEG 'set BASIC segment
60090 RESTORE 60130
60100 FOR I% = 0 TO 160 : READ X% : POKE IA+I%,X% : NEXT 'poke Routine
60110 RETURN 'back to caller
60120 '
60130 DATA 85,139,236, 30, 6,139,118, 30,139, 4,232,140, 0,139,118
60140 DATA 12,139, 60,139,118, 8,139, 4, 61,255,255,117, 2,140,216
60150 DATA 142,192,139,118, 28,138, 36,139,118, 26,138, 4,139,118, 24
60160 DATA 138, 60,139,118, 22,138, 28,139,118, 20,138, 44,139,118, 18
60170 DATA 138, 12,139,118, 16,138, 52,139,118, 14,138, 20,139,118, 10
60180 DATA 139, 52, 85,205, 33, 93, 86,156,139,118, 12,137, 60,139,118
60190 DATA 28,136, 36,139,118, 26,136, 4,139,118, 24,136, 60,139,118
60200 DATA 22,136, 28,139,118, 20,136, 44,139,118, 18,136, 12,139,118
60210 DATA 16,136,52,139,118,14,136,20,139,118, 8,140,192,137, 4
60220 DATA 88,139,118, 6,137, 4, 88,139,118, 10,137, 4, 7, 31, 93
60230 DATA 202, 26, 0, 91, 46,136, 71, 66,233,108,255
