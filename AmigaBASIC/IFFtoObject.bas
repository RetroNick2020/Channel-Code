' ######################################
' # Use DPaint as Object-Editor with   #
' #                                    #
' # B R U S H - T R A N S F O R M E R  #
' #                                    #
' # (C) 1987 by Stefan Maelger         #
' ######################################

CLEAR,30000&
DIM r(31),g(31),b(31)

nameinput:
  PRINT "Brush-File Name (and Path): ";
  LINE INPUT brush$
  PRINT
  PRINT "Object-Data File (and Path): ";
  LINE INPUT objectfile$
  PRINT 
  PRINT "Create Color-Data File? (Y/N) ";

pause:
   a$=LEFT$(UCASE$(INKEY$+CHR$(0)),1)
   IF a$="N" THEN 
      PRINT "NO!"
   ELSEIF a$="Y" THEN
      PRINT "OK."
      colorflag%=1
      PRINT 
      PRINT "Color-Data File Name (and Path): ";
      LINE INPUT colorfile$
   ELSE
      GOTO pause
   END IF
   PRINT 

   OPEN brush$ FOR INPUT AS 1
   a$=INPUT$(4,1)
   IF a$<>"FORM" THEN CLOSE 1:RUN
   a$=INPUT$(4,1)
   a$=INPUT$(4,1)
   IF a$<>"ILBM" THEN CLOSE 1:RUN

getchunk:
   a$=INPUT$(4,1)

   IF a$="BMHD" THEN
      PRINT "BMHD-Chunk found."
      PRINT 
      a$=INPUT$(4,1)
      bwidth%=ASC(INPUT$(1,1)+CHR$(0))*256
      bwidth%=bwidth%+ASC(INPUT$(1,1)+CHR$(0)) 
      PRINT "Image width :";bwidth%;" Pixels"
      IF bwidth%>320 THEN
         PRINT "It is too wide."
         BEEP 
         CLOSE 1
         RUN
      END IF
      bheight%=ASC(INPUT$(1,1)+CHR$(0))*256
      bheight%=bheight%+ASC(INPUT$(1,1)+CHR$(0))
      PRINT "Image height:";bheight%;" Pixels"
      IF bheight%>200 THEN
         PRINT "It is too high."
         BEEP
         CLOSE 1
         RUN
      END IF
      a$=INPUT$(4,1)
      planes%=ASC(INPUT$(1,1))
      PRINT "Image Depth :";planes%;" Planes"
      IF planes%>5 THEN
         PRINT "Too many Planes!"
         BEEP
         CLOSE 1
         RUN
      ELSEIF planes%*((bwidth%-1)\16+1)*2*bheight%>32000 THEN
         PRINT "Too many Bytes for the Object-String!"
         BEEP
         CLOSE 1
         RUN
      END IF 
      a$=INPUT$(1,1)
      packed%=ASC(INPUT$(1,1) +CHR$(0) ) 
      IF packed%=0 THEN
         PRINT "Pack status: NOT packed."
      ELSEIF packed%=1 THEN
         PRINT "Pack status: ByteRunl-Algorithm."
      ELSE
         PRINT "Pack status: Unknown method"
         BEEP 
         CLOSE 1
         RUN
      END IF
      a$=INPUT$(9,1)
      Status%=Status%+1
      PRINT
      PRINT 
   ELSEIF a$="CMAP" THEN
      PRINT "CMAP-Chunk found."
      a$=INPUT$ (3,1)
      l%=ASC(INPUT$(1,1))
      colors%=l%\3
      PRINT colors%; "Colors found"
      FOR i%=0 TO colors%-1
         r(i%)=ASC(INPUT$(1,1)+CHR$(0))/255
         g(i%)=ASC(INPUT$(1,1)+CHR$(0))/255
         b(i%)=ASC(INPUT$(1,1)+CHR$(0))/255
      NEXT
      Status%=Status%+2
      PRINT 
      PRINT 
   ELSEIF a$="BODY" THEN
      PRINT "BODY-Chunk found."
      PRINT 
      a$=INPUT$(4,1)
      bytes%=(bwidth%-1)\8+1
      'RetroNick added this line to fix issues with loading images 8 pixels wide or less
      if bwidth% < 9 then  bytes%=(bwidth%+15)\8   
      bmap%=bytes%*bheight%
      obj$=STRING$(bytes%*bheight%*planes%,0)
      FOR i%=0 TO bheight%-1
         PRINT "Getting lines";i%+1
         FOR j%=0 TO planes%-1
            IF packed%=0 THEN
               FOR k%=1 TO bytes%
                  a$=LEFT$(INPUT$(1,1) +CHR$ (0) ,1) 
                  MID$(obj$,j%*bmap%+i%*bytes%+k%,1)=a$
               NEXT
            ELSE
               pointer%=1
               WHILE pointer%<bytes%+1
                  a%=ASC(INPUT$(1,1)+CHR$(0))
                  IF a%<128 THEN
                     FOR k%=pointer% TO pointer%+a%
                        a$=LEFT$(INPUT$(1,1)+CHR$(0),1)
                        MID$(obj$,j%*bmap%+i%*bytes%+k%,1)=a$
                     NEXT
                     pointer%=pointer%+a%+1
                  ELSEIF a%>128 THEN
                     a$=LEFT$(INPUT$(1,1)+CHR$(0),1)
                     FOR k%=pointer% TO pointer%+257-a%
                        MID$(obj$,j%*bmap%+i%*bytes%+k%, 1)=a$
                     NEXT
                     pointer%=pointer%+256-a%
                  END IF
               WEND
            END IF
         NEXT
      NEXT i%
      Status%=Status%+4
   ELSE
      PRINT a$;" found."
      a=CVL(INPUT$(4,1))/4
      FOR i%=1 TO a
         a$=INPUT$(4,1)
      NEXT
      GOTO getchunk
   END IF

checkstatus:
IF Status%<7 GOTO getchunk
   CLOSE 1
   PRINT 
   PRINT "OK, Creating Object."
   ob$=""
   FOR i%=0 TO 10
       ob$=ob$+CHR$(0)
   NEXT
   ob$=ob$+CHR$(planes%)+CHR$(0)+CHR$(0)
   ob$=ob$+MKI$(bwidth%)+CHR$(0)+CHR$(0)
   ob$=ob$+MKI$(bheight%)+CHR$(0)+CHR$(24)
   ob$=ob$+CHR$(0)+CHR$(3)+CHR$(0)+CHR$(0) 
   ob$=ob$+obj$
   PRINT 

   PRINT "Create Object-Data File as ";CHR$ (34); 
   PRINT objectfile$;CHR$(34)
   PRINT 

   OPEN objectfile$ FOR OUTPUT AS 2
   PRINT#2,ob$;
   CLOSE 2
   PRINT "Object stored. "

   IF colorflag%=1 THEN
      PRINT
      PRINT "Creating Color-Data File: "
      OPEN colorfile$ FOR OUTPUT AS 3
      PRINT#3,CHR$(planes%);
      PRINT " Byte 1 = Number of Bitplanes"
      FOR i%=0 TO 2^planes%-1
         PRINT "Byte";i%*3+2;"= red ("; i%; ")*255"
         PRINT#3,CHR$(r(i%)*255);
         PRINT "Byte";i%*3+3;"= green("; i%; ")*255"
         PRINT#3,CHR$(g(i%)*255);
         PRINT "Byte";i%*3+4;"= blue ("; i%; ")*255"
         PRINT#3,CHR$(b(i%)*255);
      NEXT
      CLOSE 3
   END IF
   SCREEN 1,320,200,planes%, 1
   WINDOW 2,,,0,1
   FOR i%=0 TO 2^splanes%-1
      PALETTE i%,r(i%),g(i%),b(i%)
   NEXT
   OBJECT.SHAPE 1,ob$
   OBJECT.PLANES 1,2^planes%-1,0
   FOR i=0 TO 300 STEP .1
      OBJECT.X 1,i
      OBJECT.Y 1,(i\2)
      OBJECT.ON
   NEXT
WINDOW CLOSE 2
SCREEN CLOSE 1

RUN