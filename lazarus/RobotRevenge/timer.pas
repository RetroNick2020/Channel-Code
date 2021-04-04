Unit Timer;
{$mode objfpc}{$H+}

Interface
 uses ray_header;

Const
 MaxTimers = 50;

Type
 TimerProc = procedure(timerid : integer);

 TimerRec = Record
              timerid  : integer;
              Active : Boolean;
              Started : Boolean;
              RepeatTimer : Boolean;
              Ticks    : double;
              LastTime : double;
              Timer  : TimerProc;
             end;

Procedure StartTimer;
Function GetTimerTicks : double;
Procedure EndTimer;

Procedure InitTimers;
Procedure SetTimer(timerid : integer;active,started,repeattimer : Boolean;
                   Ticks : double; Timer : TimerProc);
Procedure ProcessTimers;

Implementation

var
 StartTick,StopTick: Word;
 TimerList : array[1..MaxTimers] of TimerRec;
// TimerCount : integer;

Procedure StartTimer;
begin
  // StartTick := MemW[Seg0040:$6C] { Tick };
end;

Procedure EndTimer;
begin
  // StopTick := MemW[Seg0040:$6C] { Tick };
end;

Function GetStartStopTimerTicks : Word;
begin
  GetStartStopTimerTicks:=StopTick-StartTick;
end;

Function GetTimerTicks : double;
begin
 // GetTimerTicks:=MemW[Seg0040:$6C];
  GetTimerTicks:=GetTime;
end;


Procedure InitTimers;
var
 i : integer;
begin
 For i:=1 to MaxTimers do
 begin
  TimerList[i].active:=false;
  TimerList[i].started:=false;
  TimerList[i].repeattimer:=false;
  TimerList[i].Ticks:=0;
  TimerList[i].LastTime:=0;
 end;
end;

Procedure ProcessTimers;
var
 i : integer;
 TickCount : double;
 CurrentTime : double;
begin
 For i:=1 to MaxTimers do
 begin
//  writeln(i);
  if TimerList[i].active then
  begin
    if TimerList[i].started=false then
    begin
       TimerList[i].started:=true;
       TimerList[i].LastTime:=GetTimerTicks;
    end
    else
       CurrentTime:=GetTimerTicks;
       TickCount:=abs(CurrentTime-TimerList[i].LastTime);
       if TickCount >= TimerList[i].Ticks then
       begin
         TimerList[i].Timer(i);
         TimerList[i].LastTime:=GetTimerTicks;

         If TimerList[i].repeattimer = false then
         begin
          TimerList[i].Active:=false;
         end;
       end;
    end;
 end;
end;

Procedure SetTimer(timerid : integer;active,started,repeattimer : Boolean;
                   Ticks : double; Timer : TimerProc);
begin
  TimerList[timerid].active:=active;
  TimerList[timerid].started:=started;
  TimerList[timerid].repeattimer:=repeattimer;
  TimerList[timerid].Ticks:=Ticks;
  TimerList[timerid].LastTime:=0;
  TimerList[timerid].Timer:=Timer;
end;

begin
  // StartTick := MemW[Seg0040:$6C] { Tick };
  // while StartTick = MemW[Seg0040:$6C] do
  //       { wait for end of TimerTick };
  //  StartTick := MemW[Seg0040:$6C] { Tick };
  //  { call function }
  //  StopTick := MemW[Seg0040:$6C] { Tick };
  //  writeln('Time: ',(StopTick-StartTick)
  //                  / 18.2:1:2,' seconds.')


end.


