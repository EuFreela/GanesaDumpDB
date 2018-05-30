library ganesaDir;

{$mode objfpc}{$H+}

uses
  Classes, SysUtils;

function createDirectory():String;stdcall;
var Msg : string;
begin
  //CRIAR DIRETÓRIO
  If Not DirectoryExists('c:\Ganesa_Backup_DB') then
    If Not CreateDir('c:\Ganesa_Backup_DB') Then
      Msg:='Ocorreu um erro ao criar o diretório!'
    else
      Msg:='Diretório criado com sucesso'
  Else
      Msg:='O diretório já foi criado!';

  Result := Msg;
end;

exports createDirectory;

begin
end.

