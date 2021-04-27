(* RetroNick Ported this code from grafx2 app to freepascal               *)
(* grafx2 c code looks like it was also refactored EA Deluxe Paint c code *)
(* file handles removed from T_PackBits_data - we now write to dbuffer  *)
(* instead of writing to file. we also keep track buffer count in the   *)
(* record with ncount                                                   *)

unit gpacker;

interface

type
  T_List = array[0..129] of byte;
  T_PackBits_data = packed Record
              //      output_count : integer;
                       list_size : byte;
                 repetition_mode : byte;
                            list : T_List;
                        ncounter : integer;
                    end;

 LineBufType = Array[0..16023] of Byte;


procedure PackBits_pack_init(var data : T_PackBits_data;var dbuffer : lineBufType);
function PackBits_pack_add(var data : T_PackBits_data; b : byte;var dbuffer : lineBufType) : integer;
function PackBits_pack_flush(var data : T_PackBits_data;var dbuffer : lineBufType) : integer;
function gPackRow(var buffer : LineBufType; BufferOffset : word;var dbuffer : LineBufType; size : integer) : integer;

implementation

procedure Write_byte(var data : T_PackBits_data; b : byte;var dbuffer : lineBufType);
begin
  dbuffer[data.ncounter]:=b;
  inc(data.ncounter);
end;

procedure Write_bytes(var data : T_PackBits_data;var buffData : T_List; size : word;var dbuffer : lineBufType);
var
i : integer;
begin
  for i:=0 to size-1 do
  begin
    dbuffer[data.ncounter]:=buffData[i];
    inc(data.ncounter);
  end;
end;

procedure PackBits_pack_init(var data : T_PackBits_data;var dbuffer : lineBufType);

begin
  Fillchar(data,sizeof(T_PackBits_data),0);
  data.list_size:=0;
  data.ncounter:=0;
  data.repetition_mode:=0;
end;

function PackBits_pack_add(var data : T_PackBits_data; b : byte;var dbuffer : lineBufType) : integer;
begin
  PackBits_pack_add:=0; // OK
  if data.list_size = 0 then
  begin // First color
    data.list[0] := b;
    data.list_size := 1;
  end
  else if data.list_size = 1  then
  begin  // second color
    data.repetition_mode:=0;
    if (data.list[0] = b) then  data.repetition_mode:=1;
    data.list[1] := b;
    data.list_size := 2;
  end
  else
  begin // next colors
     if (data.list[data.list_size -1] = b) then // repeat detected
     begin
           if (data.repetition_mode=0) AND (data.list_size >= 127) then
           begin
               // diff mode with 126 bytes then 2 identical bytes
               dec(data.list_size);
               if (PackBits_pack_flush(data,dbuffer) < 0) then
               begin
                  PackBits_pack_add:=-1;
                  exit;
               end;
               data.list[0] := b;
               data.list[1] := b;
               data.list_size := 2;
               data.repetition_mode := 1;
           end
           else if (data.repetition_mode=1) OR (data.list[data.list_size - 2] <> b) then
           begin
               // same mode is kept
               if (data.list_size = 128) then
               begin
                   if (PackBits_pack_flush(data,dbuffer) < 0) then
                   begin
                       PackBits_pack_add:=-1;
                       exit;
                   end;
               end;
               inc(data.list_size);
               data.list[data.list_size-1] := b;
               exit;
           end
           else
           begin
             // diff mode and 3 identical bytes
             dec(data.list_size,2);
             if (PackBits_pack_flush(data,dbuffer) < 0) then
             begin
                PackBits_pack_add:=-1;
                exit;
             end;//
             data.list[0] := b;
             data.list[1] := b;
             data.list[2] := b;
             data.list_size := 3;
             data.repetition_mode := 1;
          end
    end
    else // the color is different from the previous one
    begin
          if (data.repetition_mode=0) then                 // keep mode
          begin
             if (data.list_size = 128) then
             begin
                if (PackBits_pack_flush(data,dbuffer) < 0) then
                begin
                   PackBits_pack_add:=-1;
                exit;
                end;
            end;
            inc(data.list_size);
            data.list[data.list_size-1] := b;
         end
         else                                        // change mode
         begin
            if (PackBits_pack_flush(data,dbuffer) < 0) then
            begin
              PackBits_pack_add:=-1;
              exit;
            end;
            inc(data.list_size);
            data.list[data.list_size-1] := b;
        end;
    end;
  end;
  PackBits_pack_add:=0; // OK
end;


function PackBits_pack_flush(var data : T_PackBits_data;var dbuffer : lineBufType) : integer;
begin
  if (data.list_size > 0) then
  begin
    if (data.list_size > 128) then
    begin
      //GFX2_Log(GFX2_ERROR, "PackBits_pack_flush() list_size=%d !\n", data->list_size);
      write('error data.list_size > 128');
    end;

    if (data.repetition_mode=1) then
    begin
        Write_byte(data, 257 - data.list_size,dbuffer);
        Write_byte(data, data.list[0],dbuffer);
    end
    else
    begin
        Write_byte(data, data.list_size-1 ,dbuffer);
        Write_bytes(data, data.list, data.list_size,dbuffer);
    end;
    data.list_size := 0;
    data.repetition_mode := 0;
  end;
  PackBits_pack_flush:= data.ncounter;
end;


function gPackRow(var buffer : LineBufType; BufferOffset : word;var dbuffer : LineBufType; size : integer) : integer;
var
  pb_data : T_PackBits_data;
  i : integer;
begin
  PackBits_pack_init(pb_data,dbuffer);
  for i:=0 to size-1 do
  begin
    if (PackBits_pack_add(pb_data, buffer[i+Bufferoffset],dbuffer) =-1 ) then
    begin
      gPackRow:=-1;
      writeln('failed');
      exit;
    end;
  end;
  PackBits_pack_flush(pb_data,dbuffer);
  gPackrow:=pb_data.ncounter
end;

begin

end.
