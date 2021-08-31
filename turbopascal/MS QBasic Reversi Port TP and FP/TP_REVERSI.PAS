(* Microsoft's QBasic Reversi for DOS                      *)
(* Ported to Turbo Pascal By RetroNick on August 29 - 2021 *)
(* See youtube video https://youtu.be/BVuZLp7hr-Q          *)

Program Reversi;
  uses graph,crt;

CONST
  qbTRUE = -1;
  qbFALSE = 0;
  QUIT = 113;
  UP = 72;
  DOWN = 80;
  LEFT = 75;
  RIGHT = 77;
  BBLOCK = 1;
  EBLOCK = 8;
  ENTER = 13;
  ULEFT = 71;
  URIGHT = 73;
  DLEFT = 79;
  DRIGHT = 81;
  PASS = 112;
  DIFF = 100;
  START = 115;
  HELP = 104;
  FMOVE = 99;
  SPACE = 32;

TYPE
  GameGrid = Record
    player : INTEGER;
    nTake  : INTEGER;
    cx     : INTEGER;
    cy     : INTEGER;
   end;

  GameStatus = Record
    curRow   : INTEGER;
    curCol   : INTEGER;
    stat     : INTEGER;
    rScore   : INTEGER;
    bScore   : INTEGER;
    mDisplay : INTEGER;
    dLevel   : STRING[6];
    GColor   : INTEGER;
  end;

Var
 GS : GameStatus;
 smode : INTEGER;
 GG : array[1..8, 1..8] of GameGrid;
 GBoard : INTEGER;

 COMPUTER  : INTEGER;
 HUMAN     : INTEGER;
 BG    : INTEGER;
 GP    : array[1..8, 1..8, 1..8] of INTEGER;
 GW    : array[1..8,1..8] of INTEGER;

 locate_row,locate_col : integer;


function GetKey : integer;
var
 ch : char;
begin
 Repeat Until Keypressed;
 ch:=readkey;
 if ch = #0 then
 begin
   ch:=readkey;
 end;
 GetKey:=ORD(ch);
end;

procedure LocateInit;
begin
 Locate_row:=0;
 Locate_col:=0;
end;

function intToStr( i : integer) : string;
var
 tempstr : string;
begin
 Str(i,tempstr);
 intToStr:=tempstr;
end;
procedure Locate(r,c : integer);
begin
 Locate_row:=r;
 Locate_col:=c;
end;

procedure Print(t : string; fgcolor,bgcolor : integer);
var
x,y,x2,y2 : integer;
begin
 x:=locate_col*8-8;
 y:=locate_row*19-19+5;
 x2:=x+length(t)*8;
 y2:=y+8;

 SetFillStyle(SolidFill,bgcolor);
 Bar(x,y,x2,y2);
 SetColor(fgcolor);
 OutTextXY(x,y,t);
end;

procedure EraseGP;
begin
  FillChar(GP,sizeof(GP),0);
end;


Procedure DrawGamePiece(row, col, GpColor : integer);
begin
  IF GBoard = 85 THEN
  begin
    SetFillStyle(SolidFill,7);
    Bar(232 + col * 40, 33 + row * 40,267 + col * 40, 67 + row * 40);
    IF GpColor <> GBoard THEN
    begin
      SetColor(0);
      CIRCLE (GG[row, col].cx, GG[row, col].cy, 15);
      SetFillStyle(SolidFill,GpColor);
      FloodFill(GG[row, col].cx, GG[row, col].cy, 0);
    END;
    SetFillStyle(xHatchFill,Green);
    FloodFill(235 + col * 40, 35 + row * 40, 0);
  end
  ELSE
  begin
    SetColor(GpColor);
    CIRCLE (GG[row, col].cx, GG[row, col].cy, 15);
    CIRCLE (GG[row, col].cx, GG[row, col].cy, 14);
    SetFillStyle(SolidFill,GpColor);
    FloodFill(GG[row, col].cx, GG[row, col].cy, GpColor);
  END;
END;




FUNCTION CheckPath (i, IBound, IStep, j, JBound, JStep, Opponent : integer) : integer;
var
 done : integer;
 count : integer;
begin
  done := qbFALSE;
  WHILE ((i <> IBound) OR (j <> JBound)) AND (done=qbFalse) do
  begin
    IF GG[i, j].player = GBoard THEN
    begin
      count := 0;
      done := qbTRUE;
    end
    ELSE IF GG[i, j].player = Opponent THEN
    begin
      count := count + 1;
      i := i + IStep;
      j := j + JStep;
      IF ((i < 1) OR (i > 8)) OR ((j < 1) OR (j > 8)) THEN
      begin
        count := 0;
        done := qbTRUE;
      END;
    END
    ELSE
    begin
      done := qbTRUE;
    END;
  end; (* // while *)
  CheckPath := count;
END;




Procedure TakeBlocks (row, col, player : integer);
var
  i : integer;
begin
  GG[row, col].player := player;
  DrawGamePiece(row, col, player);

  FOR i := 1 TO GP[row, col, 1] do
  begin
    GG[row, col - i].player := player;
    DrawGamePiece(row, col - i, player);
  end;

  FOR i := 1 TO GP[row, col, 2] do
  begin
    GG[row, col + i].player := player;
    DrawGamePiece(row, col + i, player);
  end;

  FOR i := 1 TO GP[row, col, 3] do
  begin
    GG[row - i, col].player := player;
    DrawGamePiece(row - i, col, player);
  end;

  FOR i := 1 TO GP[row, col, 4] do
  begin
    GG[row + i, col].player := player;
    DrawGamePiece(row + i, col, player);
  end;

  FOR i := 1 TO GP[row, col, 5] do
  begin
    GG[row - i, col - i].player := player;
    DrawGamePiece(row - i, col - i, player);
  end;

  FOR i := 1 TO GP[row, col, 6] do
  begin
    GG[row + i, col + i].player := player;
    DrawGamePiece(row + i, col + i, player);
  end;

  FOR i := 1 TO GP[row, col, 7] do
  begin
    GG[row - i, col + i].player := player;
    DrawGamePiece(row - i, col + i, player);
  end;

  FOR i := 1 TO GP[row, col, 8] do
  begin
    GG[row + i, col - i].player := player;
    DrawGamePiece(row + i, col - i, player);
  end;

  IF player = HUMAN THEN
  begin
    GS.rScore := GS.rScore + GG[row, col].nTake + 1;
    GS.bScore := GS.bScore - GG[row, col].nTake;
  end
  ELSE
  begin
    GS.bScore := GS.bScore + GG[row, col].nTake + 1;
    GS.rScore := GS.rScore - GG[row, col].nTake;
  END;

  LOCATE (17, 7);
  PRINT('Your Score:      '+intToStr(GS.rScore),0,8);
  LOCATE(18, 7);
  PRINT('Computer Score:  '+IntToStr(GS.bScore),0,8);
END;



Procedure ComputerMove;
var
 bestmove : integer;
 bestrow : integer;
 bestcol : integer;
 row,col : integer;
 value : integer;
begin
  BestMove := -99;
  FOR row := 1 TO 8 do
  begin
    FOR col := 1 TO 8 do
    begin
      IF GG[row, col].nTake > 0 THEN
      begin
        IF GS.dLevel = 'Novice' THEN
        begin
          value := GG[row, col].nTake + GW[row, col];
        end
        ELSE
        begin
         value := GG[row, col].nTake + GW[row, col];

         if row = 1 then
          begin
              IF col < 5 THEN value := value + ABS(10 * INTEGER(GG[1, 1].player = COMPUTER));
              IF col > 4 THEN value := value + ABS(10 * INTEGER(GG[1, 8].player = COMPUTER));
          end
          else if row = 2 then
          begin
              IF GG[1, col].player <> COMPUTER THEN value := value + 5 * (INTEGER(GG[1, col].player = HUMAN));
              IF (col > 1) AND (GG[1, col - 1].player <> COMPUTER) THEN
                 value := value + 5 *(INTEGER(GG[1, col - 1].player = HUMAN));
              IF (col < 8) AND (GG[1, col + 1].player <> COMPUTER) THEN
                 value := value + 5 * (INTEGER(GG[1, col + 1].player = HUMAN));
          end
          else if row = 7 then
          begin
              IF GG[8, col].player <> COMPUTER THEN value := value + 5 * (INTEGER(GG[8, col].player = HUMAN));
              IF (col > 1) AND (GG[8, col - 1].player <> COMPUTER) THEN
                 value := value + 5 * (INTEGER(GG[8, col - 1].player = HUMAN));
              IF (col < 8) AND (GG[8, col + 1].player <> COMPUTER) THEN
                 value := value + 5 * (INTEGER(GG[8, col + 1].player = HUMAN));
          end
          else if row = 8 then
          begin
              IF (col < 5) THEN value := value + ABS(10 * INTEGER(GG[8, 1].player = COMPUTER));
              IF col > 4 THEN value := value + ABS(10 * INTEGER(GG[8, 8].player = COMPUTER));
          END;

          if col = 1 then
          begin
            IF row < 5 THEN value := value + ABS(10 * INTEGER(GG[1, 1].player = COMPUTER));
            IF row > 4 THEN value := value + ABS(10 * INTEGER(GG[8, 1].player = COMPUTER));
          end
          else if col = 2 then
          begin
            IF GG[row, 1].player <> COMPUTER THEN value := value + 5 * (INTEGER(GG[row, 1].player = HUMAN));
            IF (row > 1) AND (GG[row - 1, 1].player <> COMPUTER) THEN
               value := value + 5 * (INTEGER(GG[row - 1, 1].player = HUMAN));
            IF (row < 8) AND (GG[row + 1, 1].player <> COMPUTER) THEN
               value := value + 5 * (INTEGER(GG[row + 1, 1].player = HUMAN));
          end
          else if col  = 7 then
          begin
             IF GG[row, 8].player <> COMPUTER THEN value := value + 5 * (INTEGER(GG[row, 8].player = HUMAN));
             IF (row > 1) AND (GG[row - 1, 8].player <> COMPUTER) THEN
                value := value + 5 * (INTEGER(GG[row - 1, 8].player = HUMAN));
             IF (row < 8) AND (GG[row + 1, 8].player <> COMPUTER) THEN
                value := value + 5 * (INTEGER(GG[row + 1, 8].player = HUMAN));
          end
          else if col = 8 then
          begin
            IF (row < 5) THEN value := value + ABS(10 * INTEGER(GG[1, 8].player = COMPUTER));
            IF (row > 4) THEN value := value + ABS(10 * INTEGER(GG[8, 8].player = COMPUTER));
          end;
        END;  (*//if *)

        IF value > BestMove THEN
        begin
          BestMove := value;
          bestrow := row;
          bestcol := col;
        END;

      END;
    end; (*//NEXT col*)
  end; (*//NEXT row*)

  TakeBlocks(bestrow, bestcol, COMPUTER);
  GS.stat := HUMAN;
END;

Procedure DrawGameBoard;
var
i : integer;
row,col : integer;
begin
  SetFillStyle(SolidFill,BG);
  Bar(0, 0,640, 480);
  SetColor(0);
  Rectangle(239, 15,400, 40);
  Rectangle(39, 260,231, 390);
  Rectangle(39, 70,231, 220);
  Rectangle(269, 70,591, 390);

  IF GBoard = 85 THEN                  (*//'If b&w*)
  begin
    SetFillStyle(xHatchFill,Green);
    FloodFill(300, 25, 0);
    FloodFill(150, 350, 0);
    FloodFill(150, 124, 0);
    FloodFill(450, 225, 0);
  end
  ELSE
  begin
    SetFillStyle(SolidFill,GBoard);
    FloodFill(300, 25, 0);
    FloodFill(150, 350,0);
    FloodFill(150, 124,0);
    FloodFill(450, 225,0);
  END;
  SetFillStyle(SolidFill,0);
  Bar(400, 25,410, 50);
  Bar(250, 40,410, 50);
  Bar(231, 80,240, 230);
  Bar(50, 220,240, 230);
  Bar(590, 80,600, 400);
  Bar(280, 390,600, 400);
  Bar(231, 270,240, 400);
  Bar(50, 390,240, 400);

 SetColor(0);
  FOR i:= 0 TO 8 do
  begin
    LINE(270, 70 + i * 40,590, 70 + i * 40);
    LINE(270 + i * 40, 70,270 + i * 40, 390);
    LINE(269 + i * 40, 70,269 + i * 40, 390);
  end;

  LOCATE(2, 35);
  PRINT('R E V E R S I',0,8);

  LOCATE(5, 11);
  PRINT('Game Controls',0,8);
  LOCATE(7, 7);
  PRINT('S = Start New Game',0,8);
  LOCATE(8, 7);
  PRINT('P = Pass Turn',0,8);
  LOCATE(9, 7);
  PRINT('D = Set Difficulty',0,8);
  LOCATE(10, 7);
  PRINT('H = Display Help',0,8);
  LOCATE(11, 7);
  PRINT('Q = Quit',0,8);
  LOCATE(15, 12);
  PRINT('Game Status',0,8);
  LOCATE(17, 7);
  PRINT('Your Score:      '+IntToStr(GS.rScore)+'',0,8);
  LOCATE(18, 7);
  PRINT('Computer Score:  '+IntToStr(GS.bScore),0,8);
  LOCATE(20, 7);
  PRINT('Difficulty:   '+GS.dLevel,0,8);

  FOR row := 1 TO 8 do
  begin
    FOR col := 1 TO 8 do
    begin
      IF GG[row, col].player <> GBoard THEN
      begin
        DrawGamePiece(row, col, GG[row, col].player);
      END;
    end;
  end;

END;


Procedure DrawCursor (row, col : integer);
var
  lc : integer;
begin
  IF GG[row, col].nTake > 0 THEN
  begin
    SetColor(HUMAN);
    CIRCLE (GG[row, col].cx, GG[row, col].cy, 15);
    CIRCLE (GG[row, col].cx, GG[row, col].cy, 14);
  end
  ELSE
  begin
    lc := 0;
    IF GG[row, col].player = 0 THEN lc := 7;
    SetColor(lc);
    Rectangle(GG[row, col].cx, GG[row, col].cy - 15,GG[row, col].cx, GG[row, col].cy + 15);
    Rectangle(GG[row, col].cx - 1, GG[row, col].cy - 15,GG[row, col].cx - 1, GG[row, col].cy + 15);
    Rectangle(GG[row, col].cx + 15, GG[row, col].cy,GG[row, col].cx - 15, GG[row, col].cy);
  END;
END;




Procedure DisplayHelp;
var
  a : array[1..18] of string;
  i : integer;
begin
  a[1] := 'The object of Reversi is to finish the game with more of your red';
  a[2] := 'circles on the board than the computer has of blue (Monochrome';
  a[3] := 'monitors will show red as white and blue as black).';
  a[4] := '';
  a[5] := '1) You and the computer play by the same rules.';
  a[6] := '2) To make a legal move, at least one of the computers circles';
  a[7] := '   must lie in a horizontal, vertical, or diagonal line between';
  a[8] := '   one of your existing circles and the square where you want to';
  a[9] := '   move.  Use the arrow keys to position the cursor on the square';
  a[10] := '   and hit Enter or the Space Bar.';
  a[11] := '3) You can choose Pass from the game controls menu on your first';
  a[12] := '   move to force the computer to play first.';
  a[13] := '4) After your first move, you cannot pass if you can make a legal';
  a[14] := '   move.';
  a[15] := '5) If you cannot make a legal move, you must choose Pass';
  a[16] := '6) When neither you nor the computer can make a legal move, the';
  a[17] := '   game is over.';
  a[18] := '7) The one with the most circles wins.';

  SetFillStyle(SolidFill,BG);
  bar (0, 0,640, 480);
  SetColor(0);
  Rectangle(39, 15,590, 450);
  IF GBoard = 85 THEN
  begin
    (*//PAINT (200, 200), CHR$(85), 0*)
    SetFillStyle(xHatchFill,GBoard);
    FloodFill(200, 200, 0);
  end
  ELSE
  begin
    (*//PAINT (200, 200), GBoard, 0*)
    SetFillStyle(SolidFill,GBoard);
    FloodFill(200, 200, 0);
  END;
  SetFillStyle(SolidFill,0);
  Bar(590, 25,600, 460);
  Bar(50, 450,600, 460);

  LOCATE( 2, 35);
  PRINT('REVERSI HELP',0,8);
  FOR i := 1 TO 18 do
  begin
    LOCATE(3 + i, 7);
    PRINT(a[i],0,8);
  end;
  LOCATE(23, 25);
  PRINT('- Press any key to continue -',0,8);
  (*//SLEEP: a$ = INKEY$*)
  Repeat Until Keypressed;
  DrawGameBoard;
  DrawCursor(GS.curRow, GS.curCol);
END;


Procedure DisplayMsg (a : string);
var
 slen,LX : integer;
begin
  slen := Length(a);
  LX := (640 - 8 * (slen + 8)) div 2;
  SetColor(0);
  Rectangle(LX - 1, 420,640 - LX, 447);
  IF GBoard = 85 THEN
  begin
    (*//PAINT (LX + 10, 430), CHR$(85), 0*)
    SetFillStyle(xHatchFill,Green);
    FloodFill(LX + 10, 430,0);
  end
  ELSE
  begin
    (*//PAINT (LX + 10, 430), GBoard, 0*)
    SetFillStyle(SolidFill,GBoard);
    FloodFill(LX + 10, 430, 0);
  END;
  LOCATE(23, (80 - slen) div 2);
  PRINT(a,0,8);
  GS.mDisplay := qbTRUE;
END;



Procedure GameOver;
var
 scorediff:integer;
begin
  Scorediff := GS.rScore - GS.bScore;
  IF Scorediff = 0 THEN
  begin
    DisplayMsg('Tie Game');
  end
  ELSE IF Scorediff < 0 THEN
  begin
    DisplayMsg('You lost by');
    PRINT(IntToStr( ABS(Scorediff)),0,8);
  end
  ELSE
  begin
    DisplayMsg('You won by');
    PRINT(IntToStr(Scorediff),0,8);
  END;

  Repeat
    GS.stat := GetKey;
  UNTIL (GS.stat = QUIT) OR (GS.stat = START);
  SetFillStyle(SolidFill,BG);
  Bar(0, 420,640, 447);
END;

Procedure InitGame;

function calc_rc(v : integer) : integer;
var
 vr : real;
begin
 vr:=v;
 vr:=(vr-0.5)*40;
 calc_rc:=trunc(vr);
end;

var
 jstep,row,col,i,j : integer;
begin
  if smode = 9 then
  begin
    HUMAN := 4;
    COMPUTER := 1;
    BG := 3;
    GBoard := 8;
  end
  else
  begin
   HUMAN := 7;
   COMPUTER := 0;
   BG := 7;
   IF smode = 10 THEN
   begin
     GBoard := 1;
   end
   ELSE
   begin
     GBoard := 85;
   END;
  END;

  (*//WINDOW SCREEN (640, 480)-(0, 0)*)
  GS.curCol := 5;
  GS.curRow := 3;
  GS.stat := FMOVE;
  GS.bScore := 2;
  GS.rScore := 2;
  GS.mDisplay := qbFALSE;

  FOR row := 1 TO 8 do
  begin
    FOR col := 1 TO 8 do
    begin
      GG[row, col].player := GBoard;
      GG[row, col].nTake := 0;
      GG[row, col].cx := 270 + calc_rc(col);
      GG[row, col].cy := 70 + calc_rc(row);
      GW[row, col] := 2;
    end;
  end;
  GW[1, 1] := 99;
  GW[1, 8] := 99;
  GW[8, 1] := 99;
  GW[8, 8] := 99;
  FOR i := 3 TO 6 do
  begin
    (*//FOR j := 1 TO 8 STEP 7*)
    j:=1;
    FOR jstep:=1 to 2 do
    begin
      GW[i, j] := 5;
      GW[j, i] := 5;
      inc(j,7);
    end;
  end;
  GG[4, 4].player := HUMAN;
  GG[5, 4].player := COMPUTER;
  GG[4, 5].player := COMPUTER;
  GG[5, 5].player := HUMAN;
END;



Procedure UserMove;
var
  a : char;
move : integer;
begin

  DrawCursor(GS.curRow, GS.curCol);
  Repeat
    move := GetKey;
    IF GS.mDisplay = qbTRUE THEN
    begin
      SetFillStyle(SolidFill,BG);
      Bar(0, 420,640, 447);
      GS.mDisplay := qbFALSE;
    END;

    (*//SELECT CASE move*)
    if (move >=  71) and (move <=81) then
    begin
        DrawGamePiece(GS.curRow, GS.curCol, GG[GS.curRow, GS.curCol].player);
        IF move < 74 THEN
        begin
          IF GS.curRow = BBLOCK THEN
          begin
            GS.curRow := EBLOCK;
          end
          ELSE
          begin
            GS.curRow := GS.curRow - 1;
          END;
        end
        ELSE IF move > 78 THEN
        begin
          IF GS.curRow = EBLOCK THEN
          begin
            GS.curRow := BBLOCK;
          end
          ELSE
          begin
            GS.curRow := GS.curRow + 1;
          END;
        END;
        IF (move = 71) OR (move = 75) OR (move = 79) THEN
        begin
          IF GS.curCol = BBLOCK THEN
          begin
            GS.curCol := EBLOCK;
          end
          ELSE
          begin
            GS.curCol := GS.curCol - 1;
          END;
        end
        ELSE IF (move = 73) OR (move = 77) OR (move = 81) THEN
        begin
          IF GS.curCol = EBLOCK THEN
          begin
            GS.curCol := BBLOCK;
          end
          ELSE
          begin
            GS.curCol := GS.curCol + 1;
          END;
        END;
        DrawCursor(GS.curRow, GS.curCol);
    end
    else if move = START then
    begin
        GS.stat := START;
    end
    else if move = PASS then
    begin
        IF GS.stat = FMOVE THEN
        begin
          DisplayMsg('You passed.  Computer will make first move.');
          GS.stat := COMPUTER;
        end
        ELSE
        begin
          DisplayMsg('You can only pass on your first turn');
        END;
    end
    else if move= HELP then
    begin
        DisplayHelp;
    end
    else if move = DIFF then
    begin
        IF GS.dLevel = 'Novice' THEN
        begin
          GS.dLevel := 'Expert';
        end
        ELSE
        begin
          GS.dLevel := 'Novice';
        END;
        LOCATE(20, 7);
        PRINT('Difficulty:   '+ GS.dLevel,0,8);
    end
    else if (move= ENTER) or (move =SPACE)  then
    begin
        IF GG[GS.curRow, GS.curCol].nTake > 0 THEN
        begin
          TakeBlocks(GS.curRow, GS.curCol, HUMAN);
          GS.stat := COMPUTER;
        end
        ELSE
        begin
          DisplayMsg('Invalid move.  Move to a space where the cursor is a circle.');
        END;
    end
    else if move = QUIT then
    begin
        GS.stat := QUIT;
    END; (*//select*)
  UNTIL (GS.stat <> HUMAN) AND (GS.stat <> FMOVE);
END;

FUNCTION ValidMove (Opponent : integer) : integer;
var
 row,col : integer;
begin
  ValidMove := qbFALSE;
  eraseGP;
  FOR row := 1 TO 8 do
  begin
    FOR col := 1 TO 8 do
    begin
      GG[row, col].nTake := 0;

      IF GG[row, col].player = GBoard THEN
      begin
        IF col > 2 THEN
        begin
          GP[row, col, 1] := CheckPath(row, row, 0, col - 1, 0, -1, Opponent);
          GG[row, col].nTake := GG[row, col].nTake + GP[row, col, 1];

        END;
        IF col < 7 THEN
        begin
          GP[row, col, 2] := CheckPath(row, row, 0, col + 1, 9, 1, Opponent);
          GG[row, col].nTake := GG[row, col].nTake + GP[row, col, 2];
        END;

        IF row > 2 THEN
        begin
          GP[row, col, 3] := CheckPath(row - 1, 0, -1, col, col, 0, Opponent);
          GG[row, col].nTake := GG[row, col].nTake + GP[row, col, 3];
        END;

        IF row < 7 THEN
        begin
          GP[row, col, 4] := CheckPath(row + 1, 9, 1, col, col, 0, Opponent);
          GG[row, col].nTake := GG[row, col].nTake + GP[row, col, 4];
        END;

        IF (col > 2) AND (row > 2) THEN
        begin
          GP[row, col, 5] := CheckPath(row - 1, 0, -1, col - 1, 0, -1, Opponent);
          GG[row, col].nTake := GG[row, col].nTake + GP[row, col, 5];
        END;

        IF (col < 7) AND (row < 7) THEN
        begin
          GP[row, col, 6] := CheckPath(row + 1, 9, 1, col + 1, 9, 1, Opponent);
          GG[row, col].nTake := GG[row, col].nTake + GP[row, col, 6];
        END;

        IF (col < 7) AND (row > 2) THEN
        begin
          GP[row, col, 7] := CheckPath(row - 1, 0, -1, col + 1, 9, 1, Opponent);
          GG[row, col].nTake := GG[row, col].nTake + GP[row, col, 7];
        END;

        IF (col > 2) AND (row < 7) THEN
        begin
          GP[row, col, 8] := CheckPath(row + 1, 9, 1, col - 1, 0, -1, Opponent);
          GG[row, col].nTake := GG[row, col].nTake + GP[row, col, 8];
        END;

        IF GG[row, col].nTake > 0 THEN ValidMove := qbTRUE;
      END;
    end; (*// col*)
  end; (*// row*)
END;

var
 key   : integer;
 gd,gm : integer;
begin
  gd:=VGA;
  gm:=VGAHi;
  smode:=9;
  initgraph(gd,gm,'C:\TP7\BGI');

  GS.stat := START;
  GS.dLevel := 'Novice';
  WHILE GS.stat <> QUIT DO
  begin
    IF GS.stat = START THEN
    begin
      InitGame;
      DrawGameBoard;
    END;
    IF GS.stat <> COMPUTER THEN
    begin
      IF ValidMove(COMPUTER)=qbTrue THEN
      begin
        UserMove;
      end
      ELSE IF ValidMove(HUMAN)=qbTrue THEN
      begin
        Repeat
          DisplayMsg('You have no valid moves.  Select pass.');
          key:=getKey;
        UNTIL key = PASS;
        setfillstyle(solidfill,3);
        Bar(0, 420,640, 447);
        GS.mDisplay := qbFALSE;
        GS.stat := COMPUTER;
        ComputerMove;
      end
      ELSE
      begin
        GameOver;
      END;
    end
    ELSE
    begin
      IF ValidMove(HUMAN)=qbTRUE THEN
      begin
        ComputerMove;
      end
      ELSE IF ValidMove(COMPUTER)=qbTRUE THEN
      begin
        DisplayMsg('Computer has no valid moves.  Your Turn.');
        GS.stat := HUMAN;
        UserMove;
      end
      ELSE
      begin
        GameOver;
      END;
    END;
  end; (*//while*)
  DisplayMsg('Game Over');
END.


