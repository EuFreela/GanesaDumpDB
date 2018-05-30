unit unitGanesaDB;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, ExtCtrls,
  StdCtrls, MaskEdit, Menus, process, BlowFish, UnitAbout;

type

  { TForm1 }

  TForm1 = class(TForm)
    btnDump: TButton;
    btnOpenDialog: TButton;
    btnAbout: TButton;
    edIP: TEdit;
    edSaveLocate: TEdit;
    edMySqlDumpLocalhost: TEdit;
    edShema: TEdit;
    edServer: TEdit;
    edPwd: TEdit;
    edUser: TEdit;
    GroupBox1: TGroupBox;
    GroupBox2: TGroupBox;
    GroupBox3: TGroupBox;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    Memo1: TMemo;
    opDialog: TOpenDialog;
    procedure btnAboutClick(Sender: TObject);
    procedure btnDumpClick(Sender: TObject);
    procedure btnOpenDialogClick(Sender: TObject);
    procedure edPwdClick(Sender: TObject);
    procedure edServerClick(Sender: TObject);
    procedure edShemaClick(Sender: TObject);
    procedure edUserClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
      procedure backupMySQL;
  public

  end;

var
  Form1: TForm1;
  Texto,
  TextoEncriptado:String;
  Chave:Integer;

implementation
function createDirectory:String; stdcall; external 'ganesaDir.dll';
function GetExternalIPAddress: string; stdcall; external 'ganesaIPEx.dll';

//DB
function getUser: string; stdcall; external 'ganesaDB.dll';
function getPwd: string; stdcall; external 'ganesaDB.dll';
function getServer: string; stdcall; external 'ganesaDB.dll';
function getShema: string; stdcall; external 'ganesaDB.dll';

{$R *.lfm}

{ TForm1 }

function DecryptString(aString:string):string;
var Key:string;
    DecrytpStream:TBlowFishDeCryptStream;
    StringStream:TStringStream;
    DecryptedString:string;
begin
  Key := 'your_secret_encryption_key';

  StringStream := TStringStream.Create(aString);
  DecrytpStream := TBlowFishDeCryptStream.Create(Key,StringStream);
  DecryptedString := DecrytpStream.ReadAnsiString;
  DecrytpStream.Free;
  StringStream.Free;

  DecryptString := DecryptedString;
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
   edIp.Text := GetExternalIPAddress;
   edUser.Text := DecryptString(getUser);
   edPwd.Text := DecryptString(getPwd);
   edServer.Text := DecryptString(getServer);
   edShema.Text := DecryptString(getShema);
end;

procedure TForm1.backupMySQL;
const
     READ_BYTES = 1024;
var
   command : TProcess;
   nameArchiveDestine : string;
   output : TStringList;
   BytesRead, n : LongInt;
   memoryStream : TMemoryStream;
   nameArchive : string;
   dataAtual : TDateTime;
begin
  //DESTINO DO ARQUIVO
  dataAtual := Now;
  nameArchive := edSaveLocate.Text+'\backup_ganesa_'+FormatDateTime('dd-mm-yy',NOW)+'_'+IntToStr(random(1000000000))+'_'+FormatDateTime('hh',dataAtual)+FormatDateTime('mm',dataAtual)+FormatDateTime('ss',dataAtual)+'.sql';

  nameArchiveDestine := nameArchive;
  command := TProcess.Create(nil);
  output := TStringList.Create;
  memoryStream := TMemoryStream.Create;;
  BytesRead := 0;
  command.CommandLine := edMySqlDumpLocalhost.Text +' -u'+edUser.Text+' -p'+edPwd.Text+' -h'+edServer.Text+' '+edShema.Text;
  command.Options := command.Options+[poUsePipes];
  memo1.clear;
  memo1.lines.add('Backup iniciado..');
  command.ShowWindow := swoHIDE;
  command.Execute;
  while command.Running do
  begin
     memoryStream.SetSize(BytesRead+READ_BYTES);
     n := command.Output.Read((memoryStream.Memory+BytesRead)^,READ_BYTES);
     if n>0 then
         inc(BytesRead,n)
     else
       Sleep(100);
  end;
  repeat
     memoryStream.SetSize(BytesRead+READ_BYTES);
     n := command.Output.Read((memoryStream.Memory+BytesRead)^,READ_BYTES);
     if n>0 then
         inc(BytesRead,n)
     else
       Sleep(100);
  until n <= 0 ;

  memoryStream.SetSize(BytesRead+READ_BYTES);
  output.LoadFromStream(memoryStream);
  memo1.lines.addStrings(output);
  output.SaveToFile(nameArchiveDestine);
  output.Free;
  command.Free;
  memoryStream.Free;
  memo1.Lines.add('Backup concluído! Nome do arquivo '+nameArchive);

end;


procedure TForm1.btnDumpClick(Sender: TObject);
begin
  memo1.Clear;
  if(memo1.Lines.Count <= 0) then
                       createDirectory;
                       backupMySQL;
end;

procedure TForm1.btnAboutClick(Sender: TObject);
begin
  Form2.ShowModal;
end;

procedure TForm1.btnOpenDialogClick(Sender: TObject);
begin
  if opDialog.Execute then
  begin

  end;
end;

procedure TForm1.edPwdClick(Sender: TObject);
begin
  edPwd.Clear;
end;

procedure TForm1.edServerClick(Sender: TObject);
begin
  edServer.Clear;
end;

procedure TForm1.edShemaClick(Sender: TObject);
begin
  edShema.Clear;
end;

procedure TForm1.edUserClick(Sender: TObject);
begin
  edUser.Clear;
end;


end.

