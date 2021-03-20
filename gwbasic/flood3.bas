5 defint a-z
10 DIM plist.x(2000) 
20 DIM plist.y(2000)
25 key off
30 SCREEN 9
40 LINE (0, 0)-(639, 349), 15, B
50 LINE (100, 100)-(150, 150), 15, B
60 LINE (11, 11)-(120, 120), 15, B
70 LINE (200, 60)-(600, 120), 15, B
80 LINE (250, 20)-(620, 48), 15, B
90 LINE (170, 125)-(300, 330), 15, B
100 CIRCLE (180, 50), 30
110 CIRCLE (80, 250), 50
120 CIRCLE (400, 250), 70
130 CIRCLE (500, 300), 70
140 :rem floodfill(10, 10, 2)
150 inv1=10
160 inv2=10
170 inv3=4
180 gosub 1000:rem call floodfill
190 end: rem finish progrma
1000 rem start of floodfill routine
1010 rem pass inv1, inv2, inv3 - global variables to pass paremeter
1020 px = inv1
1030 py = inv2
1040 replacementColor = inv3
1050 temp.x=0
1055 temp.y=0
1060 txy.x=0
1070 txy.y=0
1080 y1=0
1090 true = -1
1100 fasle = 0
1110 spanLeft=false
1120 spanRight=false
1130 targetColor=0
1140 GetMaxX = 639
1150 GetMaxY = 349
1160 rem call stackpoint.init
1170 gosub 5000
1180 txy.x = px
1190 txy.y = py
1200 targetColor = POINT(txy.x, txy.y)
1210 IF targetColor = replacementColor THEN  return
1260 rem call stackpoint.init
1270 gosub 5000
1280 inv1 = txy.x
1281 inv2 = txy.y
1282 gosub 7000:rem stackpoint.push(txy)
1290 WHILE (stackpoint.count <> 0)
1300    gosub 2000:rem 'loop2
1310 WEND
1320 return:rem finish floodfill - return to main
2000 rem loop2:
2010 gosub  6000:rem stackpoint.pop(temp)
2020 temp.x = ov1
2030 temp.y = ov2
2040 y1 = temp.y
2050 WHILE (y1 >= 0) AND (POINT(temp.x, y1) = targetColor)
2060   y1 = y1 - 1
2070 WEND
2080 y1 = y1 + 1
2090 spanLeft = false
2100 spanRight = false
2110 WHILE (y1 < GetMaxY) AND (POINT(temp.x, y1) = targetColor)
2120   gosub 3000:rem loop1
2130 WEND
2140 return
3000 rem loop1:
3010 PSET (temp.x, y1), replacementColor
3020 C1=(NOT spanLeft) AND (temp.x > 0) AND (POINT((temp.x - 1), y1) = targetColor) 
3030 C2=(spanLeft = true) AND ((temp.x - 1) = 0) AND (POINT((temp.x - 1), y1) <> targetColor)
3040 IF C1 THEN  txy.x = temp.x - 1:txy.y = y1: inv1=txy.x:inv2=txy.y: gosub 7000:spanLeft = true:ELSE IF C2 THEN spanLeft = false
3050 C3 = (NOT spanRight) AND (temp.x < (GetMaxX - 1)) AND (POINT(temp.x + 1, y1) = targetColor)
3060 C4 = (spanRight = true) AND (temp.x < (GetMaxX - 1)) AND (POINT(temp.x + 1, y1) <> targetColor)
4070 IF C3 THEN  txy.x = temp.x + 1: txy.y = y1:inv1=txy.x:inv2=txy.y:gosub 7000:spanRight = true:ELSE IF C4 THEN spanRight = false
4080 y1 = y1 + 1
4090 return 
5000 rem stackpoint.init
5010 stackpoint.count = 0
5020 return
6000 rem stackpoint.pop (mypt AS pt)
6010 IF stackpoint.count > 0 THEN mypt.x = plist.x(stackpoint.count):mypt.y = plist.y(stackpoint.count):ov1=mypt.x:ov2=mypt.y:stackpoint.count=stackpoint.count-1
6020 return
7000 rem stackpoint.push (mypt AS pt)
7010 stackpoint.count = stackpoint.count + 1
7020 IF stackpoint.count > 999 THEN END
7030 mypt.x=inv1
7040 mypt.y=inv2
7050 plist.x(stackpoint.count) = mypt.x
7060 plist.y(stackpoint.count) = mypt.y
7161 rem print stackpoint.coun%
7065 rem print plist.x(stackpoint.count)
7065 rem print plist.y(stackpoint.count)
7070 return
