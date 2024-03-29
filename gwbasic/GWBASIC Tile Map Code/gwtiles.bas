10 DIM RCODE%(22), IMAGE0%(66),IMAGE1%(66),IMAGE2%(66),IMAGE3%(66), MAP%(16,16)
20 RCODE%(0)=&H8B55:RCODE%(1)=&H8BEC:RCODE%(2)=&H0C76:RCODE%(3)=&H1C8A:RCODE%(4)=&H3C8A
30 RCODE%(5)=&H10B4:RCODE%(6)=&H00B0:RCODE%(7)=&H10CD:RCODE%(8)=&H10B4:RCODE%(9)=&H10B0
40 RCODE%(10)=&H1C8B:RCODE%(11)=&H768B:RCODE%(12)=&H8A0A:RCODE%(13)=&H8B34:RCODE%(14)=&H0876
50 RCODE%(15)=&H2C8A:RCODE%(16)=&H768B:RCODE%(17)=&H8A06:RCODE%(18)=&HCD0C:RCODE%(19)=&H5D10
60 RCODE%(20)=&H08CA:RCODE%(21)=&H0000
65 SCREEN 9:CLS:LOCATE 22,1
70 FOR C%=0 to 15
80   READ R%,G%,B%
90   SETRGB=VARPTR(RCODE%(0)):CALL SETRGB(C%,R%,G%,B%)
100 NEXT C%
115 RESTORE 1600
116 READ W%,H%,WT%,HT%
120 FOR J%=0 TO 15
121   FOR I%=0 TO 15
122     READ MAP%(I%,J%)
140   NEXT I%
150 NEXT J%
160 RESTORE 1200
170 FOR I%=0 TO 65
180   READ IMAGE0%(I%)
200 NEXT
210 FOR I%=0 TO 65
220   READ IMAGE1%(I%)
230 NEXT
240 FOR I%=0 TO 65
250   READ IMAGE2%(I%)
260 NEXT
270 FOR I%=0 TO 65
280   READ IMAGE3%(I%)
290 NEXT
300 FOR J%=0 TO 15
310   FOR I%=0 TO 15
320     IF MAP%(I%,J%)=1 THEN PUT(I%*16,J%*16),IMAGE0%
321     IF MAP%(I%,J%)=2 THEN PUT(I%*16,J%*16),IMAGE1%
322     IF MAP%(I%,J%)=3 THEN PUT(I%*16,J%*16),IMAGE2%
323     IF MAP%(I%,J%)=4 THEN PUT(I%*16,J%*16),IMAGE3%
330   NEXT
340 NEXT

1000 ' GWBASIC/PC-BASIC Palette,  Size= 48 Colors= 16 Format=6 Bit
1010 DATA 29, 15, 13
1020 DATA 58, 41, 27
1030 DATA 16, 9, 12
1040 DATA 20, 24, 31
1050 DATA 9, 11, 17
1060 DATA 34, 38, 44
1070 DATA 47, 50, 54
1080 DATA 47, 27, 18
1090 DATA 9, 37, 26
1100 DATA 17, 56, 44
1110 DATA 26, 63, 52
1120 DATA 63, 28, 27
1130 DATA 51, 32, 21
1140 DATA 57, 17, 14
1150 DATA 63, 43, 13
1160 DATA 63, 57, 24
1170 ' GWBASIC\PCBASIC, Size= 66 Width= 16 Height= 16 Colors= 16
1180 ' Put Bitmap 
1190 ' Image16
1200 DATA &H0010,&H0010,&HFFFF,&HFFFF,&H0000,&H0000,&H0FFF,&HF402,&HFBFD,&H0000
1210 DATA &HFFFF,&H0402,&HFBFD,&H0000,&HFFFF,&H0402,&HFBFD,&H0000,&HFFFF,&HFFFF
1220 DATA &H0000,&H0000,&HF03F,&H2FD0,&HDFEF,&H0000,&HFFFF,&H2010,&HDFEF,&H0000
1230 DATA &HFFFF,&H2010,&HDFEF,&H0000,&HFFFF,&HFFFF,&H0000,&H0000,&H0FFF,&HF402
1240 DATA &HFBFD,&H0000,&HFFFF,&H0402,&HFBFD,&H0000,&HFFFF,&H0402,&HFBFD,&H0000
1250 DATA &HFFFF,&HFFFF,&H0000,&H0000,&HF03F,&H2FD0,&HDFEF,&H0000,&HFFFF,&H2010
1260 DATA &HDFEF,&H0000,&HFFFF,&H2010,&HDFEF,&H0000

1270 ' GWBASIC\PCBASIC, Size= 66 Width= 16 Height= 16 Colors= 16
1280 ' Put Bitmap 
1290 ' Image3
1300 DATA &H0010,&H0010,&HFFFF,&HFFFF,&H0000,&H0000,&H0FFF,&HF402,&HFBFD,&H0000
1310 DATA &H0FF0,&H0400,&HFBFF,&H0000,&H0180,&H0000,&HFFFF,&H0000,&H4002,&HA005
1320 DATA &HFFFF,&H0000,&H742E,&H8001,&HFFFF,&H0000,&H9C39,&H0810,&HF7EF,&H0000
1330 DATA &HFC3F,&H0810,&HF7EF,&H0000,&H1008,&H4002,&HFFFF,&H0000,&H1998,&H0000
1340 DATA &HFFFF,&H0000,&H1188,&H0000,&HFFFF,&H0000,&H53CA,&HA005,&HFFFF,&H0000
1350 DATA &HE7C7,&H07C0,&HF83F,&H0000,&H0020,&H07C0,&HFFFF,&H0000,&H0FF0,&H0010
1360 DATA &HFFEF,&H0000,&HFFFF,&H2010,&HDFEF,&H0000

1370 ' GWBASIC\PCBASIC, Size= 66 Width= 16 Height= 16 Colors= 16
1380 ' Put Bitmap 
1390 ' Image4
1400 DATA &H0010,&H0010,&H3FFE,&HFFFF,&H0000,&H0000,&H1FFC,&HFFFF,&H0000,&H0000
1410 DATA &H1FF8,&HFFFF,&H8000,&H0000,&H1FF8,&HFFFF,&H8001,&H0000,&H1FF8,&HFFFF
1420 DATA &H8001,&H0000,&H1FF8,&HFFFF,&H8001,&H0000,&H1FF8,&HFFFF,&H8001,&H0000
1430 DATA &H1FF8,&HFFFF,&H8001,&H0000,&H1FF8,&HFFFF,&H8001,&H0000,&H1FF8,&HFFFF
1440 DATA &H8001,&H0000,&H8FF1,&H7FFE,&H8001,&H0000,&H0FF0,&HFFFF,&HC003,&H0000
1450 DATA &H8FF1,&HFFFF,&H8001,&H0000,&H9FF9,&HFFFF,&H8001,&H0000,&H1FF8,&HFFFF
1460 DATA &H0000,&H0000,&H3FFC,&HFFFF,&H0000,&H0000

1470 ' GWBASIC\PCBASIC, Size= 66 Width= 16 Height= 16 Colors= 16
1480 ' Put Bitmap 
1490 ' Image5
1500 DATA &H0010,&H0010,&HFFFF,&HFFFF,&H0000,&H0000,&HFFFF,&HFFFF,&H0000,&H0000
1510 DATA &HFFFF,&HFFFF,&H0000,&H0000,&HFFFF,&HFFFF,&H0000,&H0000,&HFFFF,&HFFFF
1520 DATA &H0000,&H0000,&HFFFF,&HFFFF,&H0000,&H0000,&HFFFF,&HFFFF,&H0000,&H0000
1530 DATA &HFFFF,&HFFFF,&H0000,&H0000,&HFFFF,&HFFFF,&H0000,&H0000,&HFFFF,&HFFFF
1540 DATA &H0000,&H0000,&HFFFF,&HFFFF,&H0000,&H0000,&HFFFF,&HFFFF,&H0000,&H0000
1550 DATA &HFFFF,&HFFFF,&H0000,&H0000,&HFFFF,&HFFFF,&H0000,&H0000,&HFFFF,&HFFFF
1560 DATA &H0000,&H0000,&HFFFF,&HFFFF,&H0000,&H0000

1570 ' Basic Map Code
1580 ' Size =260 Width=16 Height=16 Tile Width=16 Tile Height=16
1590 ' Map1
1600 DATA 16,16,16,16,1,1,1,1,1,1
1610 DATA 1,1,1,1,1,1,1,1,1,1
1620 DATA 1,4,1,4,4,4,4,4,4,4
1630 DATA 4,4,4,4,4,1,1,4,1,1
1640 DATA 1,1,4,4,4,4,4,1,1,4
1650 DATA 4,1,1,4,4,4,4,1,4,4
1660 DATA 4,4,4,4,1,1,4,1,1,1
1670 DATA 1,4,1,1,4,4,4,1,4,4
1680 DATA 4,1,4,1,4,4,1,4,1,1
1690 DATA 1,1,1,1,1,4,4,1,4,1
1700 DATA 4,4,1,4,4,4,4,4,4,4
1710 DATA 4,1,4,1,4,1,4,4,1,1
1720 DATA 1,2,1,1,1,1,4,1,4,1
1730 DATA 3,1,4,4,4,4,4,4,4,4
1740 DATA 4,1,4,1,4,1,4,1,4,4
1750 DATA 4,4,4,4,4,4,4,1,4,1
1760 DATA 4,1,4,1,4,4,4,4,4,4
1770 DATA 4,4,4,1,4,1,4,1,4,1
1780 DATA 4,4,4,1,1,1,1,1,1,1
1790 DATA 4,1,4,1,4,1,4,4,4,1
1800 DATA 4,4,4,4,4,4,4,4,4,1
1810 DATA 4,4,4,4,1,1,4,1,4,4
1820 DATA 4,4,4,4,4,1,1,4,4,4
1830 DATA 4,4,4,1,4,1,1,1,1,1
1840 DATA 4,4,4,4,1,1,1,1,1,1
1850 DATA 1,1,1,1,1,1,1,1,1,1
