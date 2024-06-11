unit Principal;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, uLkJSON, ACBrDFeSSL, IdHTTP, IdSSLOpenSSL, IniFiles;

type
  TFPrincipal = class(TForm)
    btnGerarToken: TButton;
    Memo1: TMemo;
    Label1: TLabel;
    editToken: TEdit;
    Label2: TLabel;
    lblTokenExpira: TLabel;
    procedure btnGerarTokenClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
  private
    { Private declarations }
    DFeSSL: TDFeSSL;
    FHTTP: TIdHTTP;
    FIdSSLIOHandlerSocketOpenSSL : TIdSSLIOHandlerSocketOpenSSL;
    function calcularHash(AAut: TStream): string;    
  public
    { Public declarations }
  end;


var
  FPrincipal: TFPrincipal;
  UrlToken: string;
  ClienteID, ClientSecret : string;
  ArquivoPFX, SenhaPFX : string;

implementation

{$R *.dfm}

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

function TFPrincipal.calcularHash(AAut: TStream): string;
begin
  Result := DFeSSL.CalcHash(AAut, dgstSHA256, outBase64, True);
end;

procedure TFPrincipal.btnGerarTokenClick(Sender: TObject);
var
  jsonHeader, jsonPayload, objJson: TlkJSONobject;
  intSegundos, intSegundos1h, intMilisegundos: Int64;
  dataAtual: TDateTime;
  strHeaderBase64, strPayloadBase64, strResult: string;
  strAssinado, strJWS: WideString;
  streamHeaderPayload : TStringStream;
  xRequestBody : TStringList;
  i : Integer;
  strJsonHeader, strPayloadBase : string;
begin
  {*** BLOCO FORMATACAO DA DATA DO PAYLOAD***}
  dataAtual :=  AddHoursToDateTime(Now, 3); //Data Atual UTC
  intSegundos := DateTimeToUnix(dataAtual); //Data Atual UTC em Segundos.
  intSegundos1h := DateTimeToUnix(AddHoursToDateTime(dataAtual, 1)); //Data Atual UTC em Segundos + Horario 1h
  intMilisegundos := DateTimeToUnix(dataAtual) * 1000 + MilliSecondsBetween(dataAtual, Trunc(dataAtual)); //Data Atual UTC em Milisegundos.
  {*** FIM BLOCO FORMATACAO DA DATA DO PAYLOAD***}

  {*** BLOCO MONTAGEM DO HEADER JSON ***}
  jsonHeader := TlkJSONobject.Create;
  jsonHeader.Add('alg','RS256');
  jsonHeader.Add('typ', 'JWT');
  i := 0;
  strJsonHeader := GenerateReadableText(jsonHeader, i);
  strHeaderBase64 := EncodeBase64(strJsonHeader);
  {*** FIM BLOCO MONTAGEM DO HEADER JSON ***}
  

  {*** BLOCO MONTAGEM DO PAYLOAD JSON ***}
  jsonPayload := TlkJSONobject.Create;
  jsonPayload.Add('aud', UrlToken);
  jsonPayload.Add('sub', ClienteID);
  jsonPayload.Add('iat', IntToStr(intSegundos));
  jsonPayload.Add('exp', IntToStr(intSegundos1h));
  jsonPayload.Add('jti', IntToStr(intMilisegundos));
  jsonPayload.Add('ver', '1.1');
  i := 0;
  strPayloadBase := GenerateReadableText(jsonPayload, i);
  strPayloadBase64 := EncodeBase64(strPayloadBase);
  {*** FIM BLOCO MONTAGEM DO PAYLOAD JSON ***}

  
  {*** BLOCO DE ASSINATURA ***}
  streamHeaderPayload := TStringStream.Create(strHeaderBase64 + '.' + strPayloadBase64);

  DFeSSL.SSLCryptLib      := cryOpenSSL;
  DFeSSL.ArquivoPFX       := ArquivoPFX;
  DFeSSL.Senha            := SenhaPFX;
  DFeSSL.CarregarCertificado;

  strAssinado := calcularHash(streamHeaderPayload);

  strJWS := strHeaderBase64 + '.' + strPayloadBase64 + '.' + strAssinado;
  {*** FIM BLOCO DE ASSINATURA ***}


  FHTTP.Request.Clear;
  FHTTP.Request.CustomHeaders.Clear;
  FHTTP.Request.UserAgent           := 'Mozilla/4.0 (compatible; MSIE 7.0; Windows NT 6.0; Acoo Browser; GTB5; Mozilla/4.0 (compatible; MSIE 6.0; Windows NT 5.1; SV1) ; Maxthon; InfoPath.1; .NET CLR 3.5.30729; .NET CLR 3.0.30618)';
  FHTTP.Request.AcceptCharSet       := 'UTF-8, *;q=0.8';
  FHTTP.Request.AcceptEncoding      := 'gzip, deflate, br';
  FHTTP.Request.ContentType         := 'application/x-www-form-urlencoded';
  FHTTP.Request.BasicAuthentication := False;

  xRequestBody := TStringList.Create;
  xRequestBody.Add('grant_type=urn:ietf:params:oauth:grant-type:jwt-bearer');
  xRequestBody.Add('assertion=' + strJWS);

  try
    strResult := FHTTP.Post(UrlToken, xRequestBody);
    Memo1.lines.add(strResult);

    objJson := TlkJSON.ParseText(strResult) as TlkJSONobject;
    //objJson := TJSONObject.ParseJSONValue(TEncoding.UTF8.GetBytes(strResult), 0) as TJSONObject;

    if objJson.Field['access_token'] <> nil then
      if VarToStr(objJson.Field['access_token'].Value) <> '' then
        editToken.Text := VarToStr(objJson.Field['access_token'].Value);
    //if Assigned(objJson.Values['access_token']) then
    //  if (objJson.Values['access_token'].ToString <> EmptyStr) then
    //    editToken.Text := TJSONString(objJson.Values['access_token']).Value;

    if objJson.Field['expires_in'] <> nil then
      if VarToStr(objJson.Field['expires_in'].Value) <> '' then
        lblTokenExpira.Caption := VarToStr(objJson.Field['expires_in'].Value);
    //if Assigned(objJson.Values['expires_in']) then
    //  if (objJson.Values['expires_in'].ToString <> EmptyStr) then
    //    lblTokenExpira.Caption := DateTimeToStr(IncSecond(Now, StrToInt(objJson.Values['expires_in'].ToString)));
  except
    on E: EIdHTTPProtocolException do
    begin
      Memo1.Lines.add(E.ErrorMessage);
    end;
  end;

  FreeAndNil(xRequestBody);

end;

procedure TFPrincipal.FormCreate(Sender: TObject);
var
  IniFile: TIniFile;
begin
  UrlToken := 'https://proxy.api.prebanco.com.br/auth/server/v1.1/token';

  ArquivoPFX   := 'certificado.pfx';
  SenhaPFX     := '123456';
  ClienteID    := '12345678-1234-1234-1234-123456789012';
  ClientSecret := '12345678-1234-1234-1234-123456789012';

  if FileExists(ExtractFilePath(Application.ExeName) + 'Configuracoes.ini') then
  begin
    IniFile := TIniFile.Create(ExtractFilePath(Application.ExeName) + 'Configuracoes.ini');
    if IniFile.ReadString('Configuracoes', 'ArquivoPFX', '') <> '' then
      ArquivoPFX := IniFile.ReadString('Configuracoes', 'ArquivoPFX', '');

    if IniFile.ReadString('Configuracoes', 'SenhaPFX', '') <> '' then
      SenhaPFX := IniFile.ReadString('Configuracoes', 'SenhaPFX', '');

    if IniFile.ReadString('Configuracoes', 'ClienteID', '') <> '' then
      ClienteID := IniFile.ReadString('Configuracoes', 'ClienteID', '');

    if IniFile.ReadString('Configuracoes', 'ClientSecret', '') <> '' then
      ClientSecret := IniFile.ReadString('Configuracoes', 'ClientSecret', '');

    IniFile.Free;
  end;

  FHTTP                         := TIdHTTP.Create;
  FIdSSLIOHandlerSocketOpenSSL  := TIdSSLIOHandlerSocketOpenSSL.Create(FHTTP);
  FIdSSLIOHandlerSocketOpenSSL.SSLOptions.SSLVersions := [sslvTLSv1_2];
  FHTTP.IOHandler               := FIdSSLIOHandlerSocketOpenSSL;
//  FHTTP.CookieManager           := TIdCookieManager.Create(FHTTP);
  FHTTP.ConnectTimeout          := 30000;
  FHTTP.HandleRedirects         := True;
  FHTTP.AllowCookies            := True;
  FHTTP.RedirectMaximum         := 10;
  FHTTP.HTTPOptions             := [hoForceEncodeParams];

  DFeSSL := TDFeSSL.Create();
end;

procedure TFPrincipal.FormDestroy(Sender: TObject);
begin
  DFeSSL.Free;
end;

end.
