(* RetroNick's version of popular fiveline puzzle/logic game          *)
(* This Program is free and open source. Do what ever you like with   *)
(* the code. Tested on freepascal for Dos GO32 target but should work *)
(* on anything that uses the graph unit.                              *)
(*                                                                    *)
(* If you can't sleep at night please visit my github and youtube     *)
(* channel. A sub and follow would be nice :)                         *)
(*                                                                    *)
(* https://github.com/RetroNick2020                                   *)
(* https://www.youtube.com/channel/UCLak9dN2fgKU9keY2XEBRFQ           *)
(* https://twitter.com/Nickshardware                                  *)
(* nickshardware2020@gmail.com                                        *)
(*                                                                    *)

unit squeue;

Interface

Const
 MaxQueue = 1000;

Type
  LocationRec = record
                x,y       : integer;
                direction : integer;
  end;

  SimpleQueueRec = Record
             c : integer;
             qlist : array[1..MaxQueue] of LocationRec;
  end;

procedure InitSQueue(var SQ : SimpleQueueRec);
procedure SQueuePush(var SQ : SimpleQueueRec; qr : LocationRec);
procedure SQueuePop(var SQ : SimpleQueueRec;var qr : LocationRec);
procedure SQueueGet(var SQ : SimpleQueueRec;n : integer;var qr : LocationRec);
procedure SQueuePopFirst(var SQ : SimpleQueueRec;var qr : LocationRec);
function  SQueueCount(var SQ : SimpleQueueRec) : integer;

Implementation

procedure InitSQueue(var SQ : SimpleQueueRec);
begin
 SQ.c:=0;
end;

procedure SQueuePush(var SQ : SimpleQueueRec; qr : LocationRec);
begin
 if SQ.c < MaxQueue then
 begin
   inc(SQ.c);
   SQ.qlist[SQ.c]:=qr;
 end;
end;

procedure SQueuePop(var SQ : SimpleQueueRec;var qr : LocationRec);
begin
 if SQ.c > 0 then
 begin
   qr:=SQ.qlist[SQ.c];
   dec(SQ.c);
 end;
end;

procedure SQueueGet(var SQ : SimpleQueueRec;n : integer;var qr : LocationRec);
begin
   qr:=SQ.qlist[n];
end;

procedure SQueuePopFirst(var SQ : SimpleQueueRec;var qr : LocationRec);
var
i : integer;
begin
 if SQ.c > 0 then
 begin
   qr:=SQ.qlist[1];
   dec(SQ.c);
   for i:=1 to SQ.c do
   begin
     SQ.qlist[i]:=SQ.qlist[i+1];
   end;
 end;
end;


function  SQueueCount(var SQ : SimpleQueueRec) : integer;
begin
  SQueueCount:=SQ.c;
end;

begin
end.