// Nick's Experimental packer - use at own rick!
unit nPacker;

Interface
Type
 LineBufType = Array[0..16023] of Byte;

function nPackRow(var unpackedBuf  : LineBufType; BufferOffset : Word;
                  var packedBuf    : LineBufType;
                      unpackedSize : integer) : integer;

Implementation

const
  MaxRepeatCount = 128; //def max repeat code -128
  MaxNRCount = 128; // def 128 - max non repeat code

procedure PackOpRepeat(var packedBuf : LineBufType;var packedSize : integer; rc,n : integer);
begin
   packedbuf[packedsize]:=257-rc;
   packedbuf[packedsize+1]:=n;
   inc(packedsize,2);
end;

procedure PackOpValues(var packedBuf : LineBufType;var packedSize : integer;var tempbuf ;n : integer);
begin
 packedbuf[packedsize]:=n-1;
 move(tempbuf,packedbuf[packedsize+1],n);
 inc(packedsize,n+1);
end;

function nPackRow(var unpackedBuf  : LineBufType; BufferOffset : Word;
                  var packedBuf    : LineBufType;
                      unpackedSize : integer) : integer;
//if n is 0 to 127 - read n+1 chracters fron stream
//if n is -1 to -127 repeat next byte in stream abs(n)+1 , if we add 255 can can get rid of negative values and just use Byte
var
 count,i,tc,rc : integer;
 TempBuf : array[0..130] of byte;
 lastvalue : integer;
 packedSize : integer;
begin
 packedSize:=0;
 tc:=0;
 rc:=0;
 FillChar(TempBuf,sizeof(TempBuf),0);
 lastvalue:=-1;

 for i:=0 to unpackedSize-1 do
 begin
    if UnpackedBuf[BufferOffset+i] = lastvalue then
    begin
      if (tc = 1) AND (rc<(MaxRepeatCount-1)) then
      begin
        inc(rc);  // we remove the chractrer from the tempbuf and count it as repeating char
        tc:=0;
      end
      else if (tc > 1) AND (rc <(MaxRepeatCount-1)) then
      begin
        dec(tc); //remove last char  from tempbuf
        inc(rc);
        //write block write opcode and dump tempbuf
        PackOpValues(packedBuf,packedSize,tempbuf,tc);
        tc:=0;
      end;
      inc(rc);
      if rc > (MaxRepeatCount-1) then
      begin
        //write max repeat opcode and value   - keep repeat count going if over 128
        PackOpRepeat(packedBuf,packedSize,MaxRepeatCount,lastvalue);
        rc:=rc-MaxRepeatCount;
        lastvalue:=-1;
      end;
    end
    else
    begin
      if rc > 0 then
      begin
        //write repeat opcode and value
        PackOpRepeat(packedBuf,packedSize,rc,lastvalue);
        rc:=0;
      end;
      if tc > (MaxNRCount-1) then
      begin
        //write block write opcode and dump tempbuf to file
        PackOpValues(packedBuf,packedSize,tempbuf,MaxNRCount);
        tc:=0;
      end;
      inc(tc);
      TempBuf[tc-1]:=UnpackedBuf[BufferOffset+i];
      lastvalue:=UnpackedBuf[BufferOffset+i];
    end;
  end; //for

  if rc > 0 then
  begin
   //we still have rc data - dump it
   PackOpRepeat(packedBuf,packedSize,rc,lastvalue);
  end;

  if tc > 0 then
  begin
   //we still have some non repeat codes in buffer - dump them
   PackOpValues(packedBuf,packedSize,tempbuf,tc);
  end;
  nPackRow:=packedSize;
end;

begin
end.
