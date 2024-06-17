unit Funcoes;

interface

uses
  Classes, SysUtils, ACBrDFeSSL;

function EncodeBase64(const inStr: string): string;
function DateTimeToUnix(const AValue: TDateTime): Cardinal;
function AddHoursToDateTime(ADateTime: TDateTime; Hours: Double): TDateTime;
function MilliSecondsBetween(const ANow, AThen: TDateTime): Int64;
function CalcularHash(var DFeSSL_Local: TDFeSSL; AAut: TStream): string;
function ConverteDateISO(AData: TDateTime; AInputIsUTC : Boolean = True): String;
function URLEncode(const S: string): string;

implementation

//essa funcao esta nao Comunix.FuncoesGeral
function EncodeBase64(const inStr: string): string;

  function Encode_Byte(b: Byte): char; 
  const 
    Base64Code: string[64] = 
      'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/'; 
  begin 
    Result := Char(Base64Code[(b and $3F)+1]); 
  end; 
var 
  i: Integer; 
begin 
  i := 1; 
  Result := ''; 
  while i <= Length(InStr) do 
  begin 
    Result := Result + Encode_Byte(Byte(inStr[i]) shr 2); 
    Result := Result + Encode_Byte((Byte(inStr[i]) shl 4) or (Byte(inStr[i+1]) shr 4)); 
    if i+1 <= Length(inStr) then 
      Result := Result + Encode_Byte((Byte(inStr[i+1]) shl 2) or (Byte(inStr[i+2]) shr 6)) 
    else 
      Result := Result + '='; 
    if i+2 <= Length(inStr) then 
      Result := Result + Encode_Byte(Byte(inStr[i+2])) 
    else 
      Result := Result + '='; 
    Inc(i, 3); 
  end; 
end;

function DateTimeToUnix(const AValue: TDateTime): Cardinal;
begin
  Result := Round((AValue - UnixDateDelta) * SecsPerDay);
end;

function AddHoursToDateTime(ADateTime: TDateTime; Hours: Double): TDateTime;
begin
  Result := ADateTime + (Hours / 24);
end;

function MilliSecondsBetween(const ANow, AThen: TDateTime): Int64;
begin
  Result := Round((ANow - AThen) * 86400000); // 86400000 = 24 horas * 60 minutos * 60 segundos * 1000 milissegundos
end;

function CalcularHash(var DFeSSL_Local: TDFeSSL; AAut: TStream): string;
begin
  Result := DFeSSL_Local.CalcHash(AAut, dgstSHA256, outBase64, True);
end;

function ConverteDateISO(AData: TDateTime; AInputIsUTC : Boolean = True): String;
const
  SDateFormat: string = 'yyyy''-''mm''-''dd''T''hh'':''nn'':''ss'; { Do not localize }
begin
  Result := FormatDateTime(SDateFormat, AData)+'-00:00';
end;

function URLEncode(const S: string): string;
var
  I, J: integer;
begin
  Result := '';
  for I := 1 to Length(S) do begin
    if S[I] in [' ', '/', '\', ':', '@', '+', ',', '=', '$'] then
    begin
      Result := Result + Format('%02X', [IntToHex(Ord(S[I]), 2)]);
    end
    else
    begin
      Result := Result + S[I];
    end;
  end;
end;

end.
