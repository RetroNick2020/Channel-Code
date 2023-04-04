
unit findrows;

Interface
  uses c4core;

const
  HSize = 7;   (*if you cange hsize or vsize make sure to change in*)
  VSize = 6;   (*pathfind unit also*)
  GBItemEmpty = 0;

type
GameBoardRec = record
                  Item : integer;
               end;

GameBoard = array[0..HSize-1,0..VSize-1] of GameBoardRec;

(*used for storing path when performing a MoveTo command*)
(*move piece another valid position*)
pathpoints = record
              x,y : integer;
             end;

(*used for storing all the item/color lines that are 5 items (or more) wide*)
itempoints = record
              x,y,stepx,stepy,item,count : integer;
             end;

 apathpoints = array of pathpoints;

 aitempoints = array[0..1000] of itempoints;


 GBPosRec = Record
              xoff,yoff : integer;
 end;

function FindRowOfColors(var apoints : aitempoints;LCount : integer) : integer;


 
implementation
var
 aiCounter     : integer;



//copy zero index game board to 1 index array game board
Procedure CopyBoardToGB(var GB : GameBoard);
var
 i, j : integer;
begin
 for j:=0 to vsize-1 do
 begin
   for i:=0 to hsize-1 do
   begin
     GB[i,j].Item:=get_game_piece(i+1,j+1);
   end;
 end;
end;



(*
Procedure InitGameBoard(var GB : GameBoard);
var
 i, j : integer;
begin
 for j:=0 to vsize-1 do
 begin
   for i:=0 to hsize-1 do
   begin
     GB[i,j].Item:=GBItemEmpty;
   end;
 end;
end;
*)
Procedure InitAiQueue;
begin
 aiCounter:=0;
end;


(*as long it is not empty it should be moveable*)
//Function canSelectItem(x,y : integer) : Boolean;
//begin
//  canSelectItem:=(GB[x,y].Item <> GBItemEmpty);
//end;

(*from selected position*)
//function canMoveTo(x,y : integer) : Boolean;
//begin
//  canMoveTo:=(GB[x,y].Item = GBItemEmpty);
//end;


function isPosInRange(x,y : integer) : boolean;
var
 maxx,maxy : integer;
begin
 maxx:=HSIZE-1;
 maxy:=VSIZE-1;
 isPosInRange:=(x>=0) and (x<=maxx) and (y>=0) and (y<=maxy);
end;

function isColorSame(Var TGB : GameBoard;x1,y1,x2,y2 : integer) : boolean;
var
 c1,c2 : integer;
begin
 c1:=TGB[x1,y1].Item;
 c2:=TGB[x2,y2].Item;
 IsColorSame:=(c1>0) and (c1=c2); 
end;

(*looks for continous color in any direction*)
(*stepx and stepy can be 0 or 1 or -1*)

function FindColorCount(Var TGB : GameBoard;startx,starty,stepx,stepy,count : integer) : integer;
var
 i,c : integer;
 xpos,ypos : integer;
begin
 xpos:=startx;
 ypos:=starty;
 c:=1;
 for i:=1 to count-1 do
 begin
    if isPosInRange(xpos,ypos) and isPosInRange(xpos+stepx,ypos+stepy) then
    begin
      if isColorSame(TGB,xpos,ypos,xpos+stepx,ypos+stepy) then
      begin
        inc(c);
      end
      else
      begin
        FindColorCount:=c;
        exit;
      end;
    end;
    inc(xpos,stepx);
    inc(ypos,stepy);
  end;
  FindColorCount:=c;
end;

procedure AddRowsToQueue(var GB : GameBoard; x,y,stepx,stepy,count : integer;
                                   var apoints : aitempoints);
begin
 apoints[aiCounter].item:=GB[x,y].Item;
 apoints[aiCounter].x:=x+1;  //mod for c4
 apoints[aiCounter].y:=y+1;  //mod for c4
 apoints[aiCounter].stepx:=stepx;
 apoints[aiCounter].stepy:=stepy;
 apoints[aiCounter].count:=count;
 inc(aiCounter);
end;

(*
procedure DrawRowOfColors(var apoints : aitempoints;item : integer);
var
 i : integer;
begin
 for i:=0 to aiCounter-1 do
 begin
   //DrawRowBoarder(apoints[i].x,apoints[i].y,
   //               apoints[i].stepx,apoints[i].stepy,
   //               apoints[i].count,item);
 end;
end;
*)
procedure DeleteRowFromBoard(var TGB : GameBoard; x,y,stepx,stepy,count : integer);
var
 i : integer;
begin
 for i:=1 to count do
 begin
   TGB[x,y].Item:=GBItemEmpty;
   inc(x,stepx);
   inc(y,stepy);
 end;
end;

//TODO:
// this is a work arround to performing TGB:=GB in FindRowOfColors
// the second/third/fourth assignment doesn't take affect
// maybe a compiler bug. need to test - yes confirmed this is a bug.
// using pas2js 2.0.6 - should be fixed in next version
procedure copygbtotgb(var SGB, TGB  : GameBoard);
var i,j : integer;
begin
for j:=0 to VSize-1 do   
 begin
   for i:=0 to HSize-1 do 
   begin
     TGB[i,j]:=SGB[i,j];
   end;
 end;    
end;

function FindRowOfColors(var apoints : aitempoints;LCount : integer) : integer;
var
 TGB,GB  : GameBoard;
 i,j : integer;
 count : integer;
 rowcount : integer;
begin
  InitAiQueue;
  rowcount:=0;
  //copy c4 board to GameBoard -different array format (zero base vs 1 base)
  CopyBoardToGB(GB);

  // Make Copy GM
  // TGB:=GB;
  Copygbtotgb(GB,TGB);

 //horizonatal check
 for j:=0 to VSize-1 do   
 begin
   for i:=0 to HSize-4 do 
   begin
     count:=FindColorCount(TGB,i,j,1,0,LCount);
     if count = LCount then
     begin
        inc(rowcount);
        AddRowsToQueue(GB,i,j,1,0,count,apoints);
     //   (*Remove Line from from TGB - solves 6 to 9 in a row duplicate problem*)
        DeleteRowFromBoard(TGB,i,j,1,0,count);
     end;
   end;
 end;

// Make Copy GM Again - not a mistake
// TGB:=GB;
copygbtotgb(GB,TGB);

//vertical check
 for i:=0 to HSize-1 do   
 begin
   for j:=0 to VSize-4 do 
   begin
     count:=FindColorCount(TGB,i,j,0,1,LCount);
     if count = LCount then
     begin
       inc(rowcount);
       AddRowsToQueue(GB,i,j,0,1,count,apoints);
     //  (*Remove Line from from TGB - solves 6 to 9 in a row duplicate problem*)
       DeleteRowFromBoard(TGB,i,j,0,1,count);
     end;
   end;
 end;

//Make Copy GM 3rd time
//TGB:=GB;
copygbtotgb(GB,TGB);

//horizonatal down/right
 for j:=0 to VSize-4 do     
 begin
   for i:=0 to HSize-4 do   
   begin
     count:=FindColorCount(TGB,i,j,1,1,LCount);
     if count = LCount then
     begin
        inc(rowcount);
        AddRowsToQueue(GB,i,j,1,1,count,apoints);
     //   (*Remove Line from from TGB - solves 6 to 9 in a row duplicate problem*)
        DeleteRowFromBoard(TGB,i,j,1,1,count);
     end;
   end;
 end;

//Make Copy GM 4th time
// TGB:=GB;
copygbtotgb(GB,TGB);

 // (*horizonatal down/left*)
 for j:=0 to VSize-4 do      
 begin
   for i:=3 to HSize-1 do    
   begin
     count:=FindColorCount(TGB,i,j,-1,1,LCount);
     if count = LCount then
     begin
        inc(rowcount);
        AddRowsToQueue(GB,i,j,-1,1,count,apoints);
     //   (*Remove Line from from TGB - solves 6 to 9 in a row duplicate problem*)
        DeleteRowFromBoard(TGB,i,j,-1,1,count);
     end;
   end;
 end;
 FindRowOfColors:=rowcount;
end;

(*
Procedure RemoveRows(var GB : GameBoard;var apoints : aitempoints; count : integer);
var
 i : integer;
begin
 For i:=0 to count-1 do
 begin
   DeleteRowFromBoard(GB,apoints[i].x,apoints[i].y,
                         apoints[i].stepx,apoints[i].stepy,
                         apoints[i].count);
 end;
 DrawRowOfColors(apoints,GBItemEmpty);
end;
*)


begin
end.