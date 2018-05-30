library ganesaDB;

{$mode objfpc}{$H+}

uses
   Classes, SysUtils, BlowFish;

function EncryptString(aString:string):string;
var Key:string;
    EncrytpStream:TBlowFishEncryptStream;
    StringStream:TStringStream;
    EncryptedString:string;
begin
  Key := 'your_secret_encryption_key';
  StringStream := TStringStream.Create('');
  EncrytpStream := TBlowFishEncryptStream.Create(Key,StringStream);
  EncrytpStream.WriteAnsiString(aString);
  EncrytpStream.Free;
  EncryptedString := StringStream.DataString;
  StringStream.Free;
  EncryptString := EncryptedString;
end;


function getUser: string; stdcall;
begin
   Result := EncryptString('user do banco de dados');
end;
function getPwd: string; stdcall;
begin
   Result := EncryptString('senha do banco de dados');
end;
function getServer: string; stdcall;
begin
   Result := EncryptString('servidor mysql');
end;
function getShema: string; stdcall;
begin
   Result := EncryptString('nomde do banco de dados');
end;


exports getUser;
exports getPwd;
exports getServer;
exports getShema;
begin
end.

