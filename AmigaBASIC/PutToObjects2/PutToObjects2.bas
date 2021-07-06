    'This Demo shows you how to:
    ' 1. Read VSprite Files and Change their palette colors
    ' 2. Create Pattern data for the Pattern command
    
    screen 1,300,190,5,1
    window 2,"RM Demo VSprites and Patterns",(1,1)-(275,170),15,1

    defint a-z
    option base 0
    
    dim image(1000)
    dim pat%(15)


    'change background color to light gray
    call Palette4(0,4,4,4)
    
    'change palette color 5 to lighter gray
    call Palette4(5,6,6,6)


    ' read pattern data and draw box using pattern
    for i=0 to 15
     read pat%(i)
    next i
    pattern ,pat%
    line(0,0)-(275,170),5,bf
   
    Call ReadBobFile("ghost.vsp",ghost$)

   ' call VSPalette(ghost$,3,3,11,15)
   ' call VSPalette(ghost$,2,0,14,2)
    call VSPalette(ghost$,1,15,6,2)

    object.shape 1, ghost$
    object.x 1,120
    object.y 1,100
    object.on 1

    call VSPalette(ghost$,1,0,4,2)
    object.shape 2, ghost$
    object.x 2,150
    object.y 2,100
    object.on 2


    a$=""
    x=150
    While a$<>"q"
      a$=inkey$
      if a$="a" then x=x-4
      elseif a$="s" then x=x+4
      
      object.x 2,x

    Wend

    End
  

SUB MakeSpriteImage(ImageBuf(),ObjectImage$,size) static
    pad%=LBOUND(ImageBuf)
    'make 4 color sprite from 4,8,16,32 color Image - use frst 2 bitplanes - width must 16 pixels 
    if (ImageBuf(pad%)<>16) or (ImageBuf(pad%+2)< 2) or (ImageBuf(pad%+2)>5) then exit sub
    if ImageBuf(pad%+2) <> 2 then
        size=(6+ImageBuf(pad%+1)*2*INT((ImageBuf(pad%)+15)/16)*2) /2
    end if
    fVSprite=1                'This will be a sprite
    SAVEBACK=8                '8 = Save background, 0 = Leave copy of image when drawing
    OVERLAY=16                '0 = solid, 16 = Transparent flag
    Flags=SAVEBACK+OVERLAY+fVSprite
    ObjectImage$=MKL$(0) 'ColorSet
    ObjectImage$=ObjectImage$+MKL$(0) 'DataSet
    ObjectImage$=ObjectImage$+MKI$(0)+MKI$(2)  '2 Bitplanes
    ObjectImage$=ObjectImage$+MKI$(0)+MKI$(ImageBuf(pad%))  'Width is 16 pixels
    ObjectImage$=ObjectImage$+MKI$(0)+MKI$(ImageBuf(pad%+1))  'Height
    ObjectImage$=ObjectImage$+MKI$(Flags)
    ObjectImage$=ObjectImage$+MKI$(3)                    '(PlanePick)  planePick def 15
    ObjectImage$=ObjectImage$+MKI$(0)  'planeOnOff
    FOR i=(3+pad%) TO (size+pad%-1)       'Read only first 2 bitplanes from 4 bitplane  image
        ObjectImage$=ObjectImage$+MKI$(ImageBuf(i))
    NEXT i

    'Output Sprite Colors - Change Color Values
    ObjectImage$=ObjectImage$+MKI$(&HFFF)  '&HFFF is White - Color 1
    ObjectImage$=ObjectImage$+MKI$(0)      '0 is Black - Color 2
    ObjectImage$=ObjectImage$+MKI$(&H080)  '&HF80 is Orange &HF0F is pink - Color 3
END SUB

SUB MakeBobImage(ImageBuf(),ObjectImage$,size) static
    pad%=LBOUND(ImageBuf)
    fVSprite=0 'must be 0 for bob
    SAVEBACK=8 '0 or 8 - Save Background - when 8 it saves and restore background. when set to 0 it stamps image to screeen
    OVERLAY=16 '0 or 16 -Transparent Flag - when 16 - color 0 is transparent, when flag set to 0 - color 0 is solid       
    Flags=SAVEBACK+OVERLAY+fVSprite
    ObjectImage$=MKL$(0) 'ColorSet
    ObjectImage$=ObjectImage$+MKL$(0) 'DataSet
    ObjectImage$=ObjectImage$+MKI$(0)+MKI$(ImageBuf(pad%+2))  'Bitplanes
    ObjectImage$=ObjectImage$+MKI$(0)+MKI$(ImageBuf(pad%))  'width
    ObjectImage$=ObjectImage$+MKI$(0)+MKI$(ImageBuf(pad%+1))  'height
    ObjectImage$=ObjectImage$+MKI$(Flags)
    ObjectImage$=ObjectImage$+MKI$(2^ImageBuf(pad%+2)-1) '(PlanePick)  planePick def 15 is for up to 4 bitplanes and 31 is for 5 bitplanes,  1 for 1 bitplane, 3 is for 2 bitplanes, 7 is for 3 bitplanes
    ObjectImage$=ObjectImage$+MKI$(0)  'planeOnOff  def 0 - hint - eable unused bitplanes that planepick uses
    FOR i=(3+pad%) TO (size+pad%-1)                    'to get different color combinations
        ObjectImage$=ObjectImage$+MKI$(ImageBuf(i))
    NEXT i
END SUB

SUB MakeImageBufFromObject(ObjectImage$,ImageBuf()) static
    pad%=LBOUND(ImageBuf)
    ImageBuf%(pad%)=CVI(MID$(ObjectImage$,15,2))
    ImageBuf%(pad%+1)=CVI(MID$(ObjectImage$,19,2))
    ImageBuf%(pad%+2)=CVI(MID$(ObjectImage$,11,2))
    c%=pad%+2   
    for i=27 to Len(ObjectImage$) step 2
        c%=c%+1
        ImageBuf%(c%)=CVI(MID$(ObjectImage$,i,2))
    next i
END SUB 

SUB ChangeBobTransFlags(ObjectImage$,Trans) static
    SAVEBACK=8
    OVERLAY=0 
    if Trans=1 then  OVERLAY=16 '0 or 16 -Transparent Flag - when 16 - color 0 is transparent, when flag set to 0 - color 0 is solid       
    Flags=SAVEBACK+OVERLAY
    MID$(ObjectImage$,21,2)=MKI$(Flags)    
END SUB

SUB GetImageBufSize(ObjectImage$,size) static
    size=(LEN(ObjectImage$)-20) / 2  'object has 26 byte header - put image has 6 byte header
END SUB

SUB ReadPutImage(ImageBuf(),size) static
    pad%=LBOUND(ImageBuf)
    for i=pad% to (size+pad%-1)
        read ImageBuf(i)
    next i
END SUB

'reads bob or sprite data statements to string
SUB ReadBobImage(ObjectImage$,size) static
    ObjectImage$=""
    FOR i=1 to size
        read a
        ObjectImage$=ObjectImage$+chr$(a)
    NEXT i
END SUB

'Reads Put Image file into array - this is the XGF Export from Raster Master
SUB ReadPutImageFile(filename$,ImageBuf(),size) static
    pad%=LBOUND(ImageBuf)
    open "R",#1,filename$,2
    field #1, 2 as c$
    for i=pad% to (size+pad%-1)
        get #1
        ImageBuf(i)=CVI(c$)
    next i
    close #1
END SUB

'Saves a Put Image that is in an array to file
'It does't matter where the Image came from - data statements, captured from screen with GET, or converted fron Bob
SUB SavePutImageFile(filename$,ImageBuf(),size) static
    pad%=LBOUND(ImageBuf)
    open "R",#1,filename$,2
    field #1, 2 as c$
    for i=pad% to (size+pad%-1)
        LSET c$ = MKI$(ImageBuf(i))
        put #1
    next i
    close #1
END SUB

'Save Object/vsprite in string to filew
SUB SaveBobFile(filename$,ob$) static
    OPEN  filename$ FOR OUTPUT AS 1
    PRINT#1,ob$;
    CLOSE 1
END SUB

'reads Object/vsprite into string
SUB ReadBobFile(filename$,ob$) static
    OPEN filename$ FOR INPUT AS 1 
    ob$=INPUT$(LOF(1),1)
    CLOSE 1     
END SUB

'takes r g b values from 0 to 15
'the palette is located at the end of the vsprite$
' last 6 bytes
SUB GetVSPalette(vsprite$,colornum,r,g,b) static
    cpos=len(vsprite$)-(7-colornum*2)
    rgbpack$=MID$(vsprite$,cpos,2)
    r=ASC(LEFT$(rgbpack$,1))
    g=(ASC(RIGHT$(rgbpack$,1)) AND &HF0) / 16
    b=(ASC(RIGHT$(rgbpack$,1)) AND &H0F)
END SUB

SUB GetVSPalettePercent(vsprite$,colornum,r!,g!,b!) static
    cpos=len(vsprite$)-(7-colornum*2)
    rgbpack$=MID$(vsprite$,cpos,2)
    r2=ASC(LEFT$(rgbpack$,1))
    g2=(ASC(RIGHT$(rgbpack$,1)) AND &HF0) / 16
    b2=(ASC(RIGHT$(rgbpack$,1)) AND &H0F)
    r!=r2*0.067
    g!=g2*0.067
    b!=b2*0.067
END SUB

SUB VSPalette(vsprite$,colornum,r,g,b) static
    r2=r*2^8
    g2=g*2^4
    newpal=r2+g2+b
    cpos=len(vsprite$)-(7-colornum*2)
    MID$(vsprite$,cpos,2)=MKI$(newpal)  
END SUB

'takes percent number just like the palette command values
SUB VSPalettePercent(vsprite$,colornum%,r!,g!,b!) static
    r2=int(r!*15)       
    g2=int(g!*15)
    b2=int(b!*15)
    r2=r2*2^8
    g2=g2*2^4
    newpal=r2+g2+b2
    cpos=len(vsprite$)-(7-colornum%*2)
    MID$(vsprite$,cpos,2)=MKI$(newpal)  
END SUB

' takes RGB values from 0 to 15 and converts them to percentage format used by the palette command
SUB Palette4(colornum%,r%,g%,b%) static
    r2!=r%*0.067
    g2!=g%*0.067
    b2!=b%*0.067 
    Palette colornum%,r2!,g2!,b2!
END SUB

SUB GetImageSize(x,y,x2,y2,D,size) static
    size=(6+(y2-y+1)*2*INT((x2-x+16)/16)*D) /2
END SUB

' AmigaBASIC PUT Image, Size= 16 Width= 16 Height= 16 Colors= 2
' p2
DATA &H0000,&H0010,&H0430,&H0C48,&H1228,&H2218,&H7208
DATA &H0D0C,&H0304,&H07C0,&H0820,&H1010,&H0820,&H07C0,&H0000,&H0000
