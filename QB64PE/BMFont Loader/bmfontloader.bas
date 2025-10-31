'Quick and dirty QB64PE BMFont Loader
'Use Raster Master  to create BMFont font sheets
'
'replace test.fnt and test.png with other generated files

fntFile$ = "test.fnt" 'text-format .fnt
pngFile$ = "test.png" 'texture page 0


Screen _NewImage(800, 600, 32)
LoadBMFont fntFile$, pngFile$
Line (0, 0)-(100, 100), _RGB32(255, 0, 0), BF

PrintBMF 20, 20, "Hello from QB64-PE BMFont!", _RGB32(255, 255, 0)

Print "Press any key to quit"
Sleep



'============  1.  TYPE  ===========================
Type BMFchar
    x As Integer
    y As Integer
    w As Integer
    h As Integer
    xo As Integer
    yo As Integer
    xadv As Integer
End Type

'============  2.  GLOBALS  =======================
Dim Shared fontChar(0 To 255) As BMFchar
Dim Shared fontTex&
Dim Shared fontLineH%, fontBase%

'============  3.  LOADER  ========================
Sub LoadBMFont (fnt$, png$)
    Open fnt$ For Input As #1
    Do Until EOF(1)
        Line Input #1, l$
        l$ = _Trim$(l$)

        If Left$(l$, 5) = "info " Then
            fontLineH% = Val(ReadKey$(l$, "lineHeight="))
            fontBase% = Val(ReadKey$(l$, "base="))

        ElseIf Left$(l$, 5) = "page " Then
            fontTex& = _LoadImage(png$)
            If fontTex& = 0 Then Print "ERROR: load "; png$: Close: End

        ElseIf Left$(l$, 5) = "char " Then
            id% = Val(ReadKey$(l$, "id="))
            If id% >= 0 And id% <= 255 Then
                fontChar(id%).x = Val(ReadKey$(l$, "x="))
                fontChar(id%).y = Val(ReadKey$(l$, "y="))
                fontChar(id%).w = Val(ReadKey$(l$, "width="))
                fontChar(id%).h = Val(ReadKey$(l$, "height="))
                fontChar(id%).xo = Val(ReadKey$(l$, "xoffset="))
                fontChar(id%).yo = Val(ReadKey$(l$, "yoffset="))
                fontChar(id%).xadv = Val(ReadKey$(l$, "xadvance="))
            End If
        End If
    Loop
    Close #1
End Sub

'----------  helper  ----------
Function ReadKey$ (s$, k$)
    p = InStr(s$, k$): If p = 0 Then ReadKey$ = "0": Exit Function
    p2 = InStr(p + Len(k$), s$, " "): If p2 = 0 Then p2 = Len(s$) + 1
    ReadKey$ = Mid$(s$, p + Len(k$), p2 - p - Len(k$))
End Function

Sub CopyImageRect (srcHandle&, srcx%, srcy%, dstx%, dsty%, w%, h%, col&)
    Dim sx, sy, dx, dy As Integer

    _Source srcHandle&
    For sy = 0 To h% - 1
        For sx = 0 To w% - 1
            c& = Point(srcx% + sx, srcy% + sy)
            If _Red32(c&) > 0 Or _Green32(c&) Or _Blue32(c&) > 0 Then PSet (dstx% + sx, dsty% + sy), col&
        Next sx
    Next sy
    _Source _Dest
End Sub

'============  4.  DRAW  ==========================
Sub PrintBMF (x%, y%, txt$, col&)
    dstx% = x%
    For i% = 1 To Len(txt$)
        c% = Asc(Mid$(txt$, i%, 1))

        'cache metrics locally (optional, but cleaner)
        chX = fontChar(c%).x
        chY = fontChar(c%).y
        chW = fontChar(c%).w
        chH = fontChar(c%).h
        chXo = fontChar(c%).xo
        chYo = fontChar(c%).yo
        chAdv = fontChar(c%).xadv

        dstx% = dstx% + chXo
        dstY% = y% + chYo

        '----  tint-and-blit routine  ------------
        CopyImageRect fontTex&, chX, chY, dstx%, dstY%, chW, chH, col&

        'advance cursor (xadv already includes xo)
        dstx% = dstx% + chAdv - chXo
    Next
End Sub



