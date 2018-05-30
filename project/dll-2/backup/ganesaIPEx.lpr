library ganesaIPEx;

{$mode objfpc}{$H+}

uses
  Classes, SysUtils, fphttpclient, RegexPr;

function GetExternalIPAddress: string;
var
  HTTPClient: TFPHTTPClient;
  IPRegex: TRegExpr;
  RawData: string;
begin
  try
    HTTPClient := TFPHTTPClient.Create(nil);
    IPRegex := TRegExpr.Create;
    try
      //returns something like:
      {
<html><head><title>Current IP Check</title></head><body>Current IP Address: 44.151.191.44</body></html>
      }
      RawData:=HTTPClient.Get('http://checkip.dyndns.org');
      // adjust for expected output; we just capture the first IP address now:
      IPRegex.Expression := RegExprString('\b\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3}\b');
      //or
      //\b(?:\d{1,3}\.){3}\d{1,3}\b
      if IPRegex.Exec(RawData) then
      begin
        result := IPRegex.Match[0];
      end
      else
      begin
        result := 'Got invalid results getting external IP address. Details:'+LineEnding+
          RawData;
      end;
    except
      on E: Exception do
      begin
        result := 'Error retrieving external IP address: '+E.Message;
      end;
    end;
  finally
    HTTPClient.Free;
    IPRegex.Free;
  end;
end;

exports GetExternalIPAddress;

begin
end.

