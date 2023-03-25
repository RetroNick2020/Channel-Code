unit invader;

Interface
 uses Web,player,enemy,bullets,assets;
 //browserconsole

const
  EnemyCount = 30; 
type
 TInvader = class
            ex : integer;
            ey : integer;
            myEnemy   : array[0..EnemyCount-1] of TEnemy;
            myPlayer  : TPlayer;
            myBullet  : TBullet;
            timer : TJSDOMHighResTimeStamp;

            renderctx        : TJSCanvasRenderingContext2D;
            renderimg        : TJSHTMLImageElement;

            constructor create;
            procedure setRenderCTX(var ctx : TJSCanvasRenderingContext2D);
            //procedure setRenderImg(var Img : TJSHTMLImageElement);   
            
            procedure UpdateEnemyRenderCTX;
            //procedure UpdateEnemyRenderImg;
            function checkforhit : integer;
            procedure update(aTime: TJSDOMHighResTimeStamp);
            procedure draw;            
 end;

Implementation

constructor TInvader.create;
var
 i : integer;
begin
  ex:=10;
  ey:=10;
  //myEnemy = []
  timer := 0;
  
  for i:=0 to EnemyCount-1 do
  begin
    myEnemy[i] := TEnemy.Create;
    myEnemy[i].MoveTo(ex+i*25,ey);
  end;
  myPlayer := TPlayer.Create;
  myBullet := TBullet.Create;
end;

procedure TInvader.setRenderCTX(var ctx : TJSCanvasRenderingContext2D);
begin
  renderctx:=ctx;
end;
(*
procedure TInvader.setRenderImg(var Img : TJSHTMLImageElement);
begin
  renderImg:=Img;
end;
*)
procedure TInvader.UpdateEnemyRenderCTX;
var
 i : integer;
begin
  for i:=0 to EnemyCount-1 do
  begin
    myEnemy[i].setRenderCTX(renderCTX);
  end;
end;
(*
procedure TInvader.UpdateEnemyRenderImg;
var
 i : integer;
begin
  for i:=0 to 4 do
  begin
    myEnemy[i].setRenderImg(renderImg);
  end;
end;
*)

function TInvader.checkforhit : integer;
var
 i,btx,bty,enx,eny,disx,disy : integer;
begin
 if myBullet.getactive = true then
 begin
    btx:=myBullet.getx+1;
    bty:=myBullet.gety+1;
    for i:=0 to EnemyCount-1 do
    begin
      if myEnemy[i].getactive = true then
      begin
         enx:=myEnemy[i].getx+7;
         eny:=myEnemy[i].gety+7;
         disx:=abs(btx-enx);
         disy:=abs(bty-eny);
         if (disx < 8) and (disy < 8) then
         begin
           checkforhit:=i;
           exit;
         end;
      end;
    end;
 end;
 checkforhit:=-1;
end;

procedure TInvader.update(aTime: TJSDOMHighResTimeStamp);
var
 i : integer;
 ishit : integer;
begin
 // writeln(myPlayer.playerdir);
  myPlayer.Update;

//  timer := timer+1;
  if aTime > (timer+200)  then
  begin
    timer:=aTime;
    for i:=0 to EnemyCount-1 do
    begin
      myEnemy[i].movedelta(5);
    end;

    myBullet.move;
    ishit:=checkforhit;
    if ishit > -1 then
    begin
      ExplodeSound.Play;
      myBullet.setactive(false);
      myEnemy[ishit].setactive(false);
    //  return
    end;
  end;
end;

procedure TInvader.draw;
var
 i : integer;
begin
  //screen.clear()
  for i:=0 to EnemyCount-1 do
  begin
    myEnemy[i].draw;
  end;  
  myBullet.draw;
  myPlayer.draw;
end;

begin
end.
