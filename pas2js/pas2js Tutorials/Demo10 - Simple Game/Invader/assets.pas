unit assets;

{$R assets/ship2.png}
{$R assets/enemy2.png}
{$R assets/b1.png}
{$R assets/fire.wav}
{$R assets/explode.wav}

Interface
  uses Web,JS,p2jsres;

var  
 ShipImage : TJSHTMLImageElement;
 BulletImage : TJSHTMLImageElement;
 EnemyImage : TJSHTMLImageElement;
 FireSound : TJSHTMLAudioElement;
 ExplodeSound : TJSHTMLAudioElement;

Procedure LoadResources(resfilename : string);

Implementation

Procedure CreateAssetElements;
begin
  ShipImage:=TJSHTMLImageElement.New;
  BulletImage:=TJSHTMLImageElement.New;
  EnemyImage:=TJSHTMLImageElement.New;

  FireSound:= TJSHTMLAudioElement(Document.CreateElement('audio'));
  ExplodeSound:= TJSHTMLAudioElement(Document.CreateElement('audio'));
end;

Procedure  LoadImage(ImageName : string; var Img : TJSHTMLImageElement);
var
  aInfo : TResourceInfo;
begin
  if not GetResourceInfo(ImageName,aInfo) then
    Writeln('No info for image ',ImageName)
  else
    Img.Src:='data:'+aInfo.format+';base64,'+aInfo.Data;
end;

Procedure  LoadSound(SoundName : string; var Snd : TJSHTMLAudioElement);
var
  aInfo : TResourceInfo;
begin
  if not GetResourceInfo(SoundName,aInfo) then
    Writeln('No info for sound file ',SoundName)
  else
    Snd.Src:='data:'+'audio/wav'+';base64,'+aInfo.Data;
end;

procedure OnLoadFailed(const aError: string);
begin
  window.alert('Failed to load resources : '+AError)
end;

procedure OnLoaded(const LoadedResources: array of String);
Var
  S : String;
begin
  //for S in LoadedResources do
  //  Writeln('Found resource: ',S);
 
  LoadImage('ship2',ShipImage);
  LoadImage('enemy2',EnemyImage);
  LoadImage('b1',BulletImage);
  
  LoadSound('fire',FireSound);
  LoadSound('explode',ExplodeSound);
end;

Procedure LoadResources(resfilename : string);
begin
  CreateAssetElements;
  SetResourceSource(rsHTML);
  LoadHTMLLinkResources(resfilename,@OnLoaded,@OnLoadFailed);
 // writeln('LoadResources'); 
end;

begin
end.
