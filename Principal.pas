unit Principal;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, uLkJSON, ACBrDFeSSL, ACBrEAD, ACBrOpenSSLUtils, IdHTTP,
  IdSSLOpenSSL, IniFiles;

type
  TFPrincipal = class(TForm)
    btnGerarToken: TButton;
    MemoRespToken: TMemo;
    Label1: TLabel;
    editToken: TEdit;
    Label2: TLabel;
    lblTokenExpira: TLabel;
    btnCriarBoleto: TButton;
    MemoResp: TMemo;
    procedure btnGerarTokenClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure btnCriarBoletoClick(Sender: TObject);
  private
    { Private declarations }
    DFeSSL: TDFeSSL;
    //ObjACBrEAD: TACBrEAD;
    FIdSSLIOHandlerSocketOpenSSL: TIdSSLIOHandlerSocketOpenSSL;
    ACBrOpenSSLUtils1: TACBrOpenSSLUtils;
    FHTTP: TIdHTTP;
  public
    { Public declarations }
    procedure ACBrEADGetChavePrivada(var Chave: string);
  end;

var
  FPrincipal: TFPrincipal;
  UrlToken, UrlRegBoleto, UrlCriaBoleto: string;
  ClienteID, ClientSecret: string;
  ArquivoPFX, SenhaPFX: string;
  PagadorDocumento, PagadorNome, PagadorEnderecoRua, PagadorEnderecoNumero, PagadorEnderecoCep, PagadorEnderecoBairro, PagadorEnderecoMunicipio, PagadorEnderecoUF: string;
  BeneficiarioDocumento:string;
implementation

uses
  Funcoes, LibBradescoApiCriaBoleto;

{$R *.dfm}

procedure TFPrincipal.FormCreate(Sender: TObject);
var
  IniFile: TIniFile;
begin
  UrlToken := 'https://proxy.api.prebanco.com.br/auth/server/v1.1/token';
  UrlRegBoleto := '/v1/boleto/registrarBoleto';
  UrlCriaBoleto := 'https://proxy.api.prebanco.com.br/v1/boleto/registrarBoleto';

  //URL_BASE        = 'https://proxy.api.prebanco.com.br';
  //URL_TOKEN       = 'https://proxy.api.prebanco.com.br/auth/server/v1.1/token';
  //URL_TOKEN_REQ   = 'https://proxy.api.prebanco.com.br/auth/server/v1.2/token';
  //URL_CRIABOLETO  = 'https://proxy.api.prebanco.com.br/v1/boleto/registrarBoleto';
  //URI_REG_BOLETO  = '/v1/boleto/registrarBoleto';
  //URI_TESTE       = '/v1.1/jwt-service';
  //PARAM_TESTE     = 'agencia=552&conta=331';
  //CLIENT_ID       = 'SEUCLIENTID';

  ArquivoPFX := 'certificado.pfx';
  SenhaPFX := '123456';
  ClienteID := '12345678-1234-1234-1234-123456789012';
  ClientSecret := '12345678-1234-1234-1234-123456789012';

  PagadorDocumento := '12345678901234';
  PagadorNome := 'EMPRESA MODELO';
  PagadorEnderecoRua := 'EMPRESA MODELO';
  PagadorEnderecoNumero := '123';
  PagadorEnderecoCep := '13416901';
  PagadorEnderecoBairro := 'CENTRO';
  PagadorEnderecoMunicipio := 'MUNICIPIO';
  PagadorEnderecoUF := 'SP';

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

    BeneficiarioDocumento := IniFile.ReadString('Configuracoes', 'BeneficiarioDocumento', '');

    PagadorDocumento := IniFile.ReadString('Configuracoes', 'PagadorDocumento', '');
    PagadorNome := IniFile.ReadString('Configuracoes', 'PagadorNome', '');
    PagadorEnderecoRua := IniFile.ReadString('Configuracoes', 'PagadorEnderecoRua', '');
    PagadorEnderecoNumero := IniFile.ReadString('Configuracoes', 'PagadorEnderecoNumero', '');
    PagadorEnderecoCep := IniFile.ReadString('Configuracoes', 'PagadorEnderecoCep', '');
    PagadorEnderecoBairro := IniFile.ReadString('Configuracoes', 'PagadorEnderecoBairro', '');
    PagadorEnderecoMunicipio := IniFile.ReadString('Configuracoes', 'PagadorEnderecoMunicipio', '');
    PagadorEnderecoUF := IniFile.ReadString('Configuracoes', 'PagadorEnderecoUF', '');

    IniFile.Free;
  end;

  FHTTP := TIdHTTP.Create;
  FIdSSLIOHandlerSocketOpenSSL := TIdSSLIOHandlerSocketOpenSSL.Create(FHTTP);
  FIdSSLIOHandlerSocketOpenSSL.SSLOptions.SSLVersions := [sslvTLSv1_2];
  FHTTP.IOHandler := FIdSSLIOHandlerSocketOpenSSL;
//  FHTTP.CookieManager           := TIdCookieManager.Create(FHTTP);
  FHTTP.ConnectTimeout := 30000;
  FHTTP.HandleRedirects := True;
  FHTTP.AllowCookies := True;
  FHTTP.RedirectMaximum := 10;
  FHTTP.HTTPOptions := [hoForceEncodeParams];

  DFeSSL := TDFeSSL.Create();
  //ObjACBrEAD := TACBrEAD.Create(nil);
  //ObjACBrEAD.OnGetChavePrivada := ACBrEADGetChavePrivada;

  ACBrOpenSSLUtils1 := TACBrOpenSSLUtils.Create(Self);
  ACBrOpenSSLUtils1.LoadPFXFromFile(ArquivoPFX, SenhaPFX);
end;

procedure TFPrincipal.FormDestroy(Sender: TObject);
begin
  DFeSSL.Free;
end;

procedure TFPrincipal.ACBrEADGetChavePrivada(var Chave: string);
var
  objStringStream: TStringStream;
begin
  objStringStream := TStringStream.Create('');
  //objStringStream.LoadFromFile('CERT-TESTE.pem');
  Chave := objStringStream.DataString;
end;

procedure TFPrincipal.btnGerarTokenClick(Sender: TObject);
var
  jsonHeader, jsonPayload, objJson: TlkJSONobject;
  intSegundos, intSegundos1h, intMilisegundos: Int64;
  dataAtual: TDateTime;
  strHeaderBase64, strPayloadBase64, strResult: string;
  strAssinado, strJWS: WideString;
  streamHeaderPayload: TStringStream;
  xRequestBody: TStringList;
  i: Integer;
  strJsonHeader, strPayloadBase: string;
begin
  {*** BLOCO FORMATACAO DA DATA DO PAYLOAD***}
  dataAtual := AddHoursToDateTime(Now, 3); //Data Atual UTC
  intSegundos := DateTimeToUnix(dataAtual); //Data Atual UTC em Segundos.
  intSegundos1h := DateTimeToUnix(AddHoursToDateTime(dataAtual, 1)); //Data Atual UTC em Segundos + Horario 1h
  intMilisegundos := DateTimeToUnix(dataAtual) * 1000 + MilliSecondsBetween(dataAtual, Trunc(dataAtual)); //Data Atual UTC em Milisegundos.
  {*** FIM BLOCO FORMATACAO DA DATA DO PAYLOAD***}

  {*** BLOCO MONTAGEM DO HEADER JSON ***}
  jsonHeader := TlkJSONobject.Create;
  jsonHeader.Add('alg', 'RS256');
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

  DFeSSL.SSLCryptLib := cryOpenSSL;
  DFeSSL.ArquivoPFX := ArquivoPFX;
  DFeSSL.Senha := SenhaPFX;
  DFeSSL.CarregarCertificado;

  strAssinado := CalcularHash(DFeSSL, streamHeaderPayload);

  strJWS := strHeaderBase64 + '.' + strPayloadBase64 + '.' + strAssinado;
  {*** FIM BLOCO DE ASSINATURA ***}

  FHTTP.Request.Clear;
  FHTTP.Request.CustomHeaders.Clear;
  FHTTP.Request.UserAgent := 'Mozilla/4.0 (compatible; MSIE 7.0; Windows NT 6.0; Acoo Browser; GTB5; Mozilla/4.0 (compatible; MSIE 6.0; Windows NT 5.1; SV1) ; Maxthon; InfoPath.1; .NET CLR 3.5.30729; .NET CLR 3.0.30618)';
  FHTTP.Request.AcceptCharSet := 'UTF-8, *;q=0.8';
  FHTTP.Request.AcceptEncoding := 'gzip, deflate, br';
  FHTTP.Request.ContentType := 'application/x-www-form-urlencoded';
  FHTTP.Request.BasicAuthentication := False;

  xRequestBody := TStringList.Create;
  xRequestBody.Add('grant_type=urn:ietf:params:oauth:grant-type:jwt-bearer');
  xRequestBody.Add('assertion=' + strJWS);

  try
    strResult := FHTTP.Post(UrlToken, xRequestBody);
    MemoRespToken.lines.add(strResult);

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
      MemoRespToken.Lines.add(E.ErrorMessage);
    end;
  end;

  FreeAndNil(xRequestBody);

end;

procedure TFPrincipal.btnCriarBoletoClick(Sender: TObject);
var
  strResult: string;
  objJson: TlkJSONobject;
  strTimeStamp, strObj, strLinha1, strLinha2, strLinha3, strLinha4, strLinha5, strLinha6, strLinha7, strLinha8: string;
  intMiliSegundos: int64;
  dataAtual: TDateTime;
  stremRequest: TStringStream;
  strRequestAssinado, strRequestAssinadoList, strRequestAssinadoStream, strRequestAssinadoAnsiString: WideString;
  xRequestBody: TStringStream;
  objCriaBoleto: TLibBradescoApiCriaBoleto;
  strList: TStringList;
  streamstr: TStringStream;
  arq: TextFile;
begin
  {*** BLOCO FORMATACAO DA DATA DO PAYLOAD***}
  dataAtual := AddHoursToDateTime(Now, 3); //Data Atual UTC
  intMiliSegundos := DateTimeToUnix(dataAtual) * 1000 + MilliSecondsBetween(dataAtual, Trunc(dataAtual)); //Data Atual UTC em Milisegundos.
  strTimeStamp := ConverteDateISO(dataAtual, False);
  {*** FIM BLOCO FORMATACAO DA DATA DO PAYLOAD***}

  {*** CRIA�AO DO PAYLOAD DO BOLETO ***}
  objCriaBoleto := TLibBradescoApiCriaBoleto.Create; //Classe contento todos os campos do boleto.
  objCriaBoleto.Clear;
  objCriaBoleto.nroCpfCnpjSacdo := PagadorDocumento; //DOCUMENTO DO CLIENTE.

  if (Length(PagadorDocumento) = 11) then
    objCriaBoleto.indCpfCnpjSacdo := 1 //TIPO 1 CPF
  else
    objCriaBoleto.indCpfCnpjSacdo := 2; //TIPO 1 CPF

  objCriaBoleto.nroCpfCnpjBenef := BeneficiarioDocumento;
  objCriaBoleto.filCpfCnpjBenef := Copy(BeneficiarioDocumento, 9, 4);
  objCriaBoleto.filCpfCnpjBenef := Copy(BeneficiarioDocumento, 12, 2);

  objCriaBoleto.isacdoTitloCobr := PagadorNome; //NOME DO CLIENTE
  objCriaBoleto.elogdrSacdoTitlo := PagadorEnderecoRua; //RUA.
  objCriaBoleto.enroLogdrSacdo := StrToIntDef(PagadorEnderecoNumero, 0); //NUMERO
  objCriaBoleto.ccepSacdoTitlo := StrToInt64Def(PagadorEnderecoCep, 0); //CEP
  objCriaBoleto.ebairoLogdrSacdo := PagadorEnderecoBairro; //BAIRRO
  objCriaBoleto.imunSacdoTitlo := PagadorEnderecoMunicipio; //CIDADE CLIENTE
  objCriaBoleto.csglUfSacdo := PagadorEnderecoUF; //UF CLIENTE
  objCriaBoleto.demisTitloCobr := FormatDateTime('dd.mm.yyyy', Now); //'30.08.2023'; //Data Emiss�o.
  objCriaBoleto.dvctoTitloCobr := FormatDateTime('dd.mm.yyyy', AddHoursToDateTime(Now, 24)); //'31.08.2023'; //Data Vencimento.

  strObj := objCriaBoleto.ToString();
  {*** FIM CRIA�AO DO PAYLOAD DO BOLETO ***}

  {*** BLOCO DE ASSINATURA ***}
  {
  DFeSSL.SSLCryptLib      := cryOpenSSL;
  DFeSSL.ArquivoPFX       := 'certificado.pfx';
  DFeSSL.Senha            := '123456';
  DFeSSL.CarregarCertificado;
  }

  strList := TStringList.Create;
  strList.Add('POST'); //Methodo HTTP
  strList.Add(UrlRegBoleto); //URI de Requisi��o
  strList.Add(''); //Par�metros. quando houver, se n�o tem deixa linha em branco.
  strList.Add(strObj); //Json de cria��o do Boleto que vai no Body.
  strList.Add(editToken.Text); //Access-token retornado da API.
  strList.Add(IntToStr(intMiliSegundos)); //Hora Atual em Milisegundos.
  strList.Add(strTimeStamp); //TimeStamp;
  strList.Add('SHA256'); //Algoritimo Usado.

  strLinha1 := 'POST'; //Methodo HTTP
  strLinha2 := UrlRegBoleto; //URI de Requisi��o
  strLinha3 := ''; //Par�metros. quando houver, se n�o tem deixa linha em branco.
  strLinha4 := strObj; //Json de cria��o do Boleto que vai no Body.
  strLinha5 := editToken.Text; //Access-token retornado da API.
  strLinha6 := IntToStr(intMiliSegundos); //Hora Atual em Milisegundos.
  strLinha7 := strTimeStamp; //TimeStamp;
  strLinha8 := 'SHA256'; //Algoritimo Usado.

  if FileExists('request.txt') then
    DeleteFile('request.txt');

  AssignFile(arq, 'request.txt');
  SetLineBreakStyle(arq, tlbsLF);
  {$I-}
  Reset(arq);
  {$I+}
  if (IOResult <> 0) then
    Rewrite(arq) { arquivo n�o existe e ser� criado }
  else
  begin
    CloseFile(arq);
    Append(arq); { o arquivo existe e ser� aberto para sa�das adicionais }
  end;
  Writeln(arq, strLinha1);
  Writeln(arq, strLinha2);
  Writeln(arq, strLinha3);
  Writeln(arq, strLinha4);
  Writeln(arq, strLinha5);
  Writeln(arq, strLinha6);
  Writeln(arq, strLinha7);
  Writeln(arq, strLinha8);
  CloseFile(arq); { fecha o arquivo texto aberto }

  //stremRequest := TStringStream.Create(strLinha1+strLinha2+strLinha3+strLinha4+strLinha5+strLinha6+strLinha7+strLinha8); //Aqui vai o arquivo para Assinar.
  //stremRequest.SaveToFile('request.txt');
  //strRequestAssinado := ObjACBrEAD.CalcularAssinaturaArquivo( 'request.txt', dgstSHA256, outBase64);
  //strRequestAssinado := ObjACBrEAD.CalcularAssinatura(strLinha1+#10+strLinha2+#10+strLinha3+#10+strLinha4+#10+
  //  strLinha5+#10+strLinha6+#10+strLinha7+#10+strLinha8, dgstSHA256, outBase64);

//  strRequestAssinado := TURI.URLEncode(ACBrOpenSSLUtils1.CalcHashFromFile('request.txt', algSHA256, sttHexa, True));
  strRequestAssinado := URLEncode(ACBrOpenSSLUtils1.CalcHashFromFile('request.txt', algSHA256, sttHexa, True));
  //strRequestAssinado := ACBrOpenSSLUtils1.CalcHashFromString(strLinha1+#10+strLinha2+#10+strLinha3+#10+strLinha4+#10+
  //  strLinha5+#10+strLinha6+#10+strLinha7+#10+strLinha8, algSHA256, sttBase64, True);

  //strRequestAssinadoStream := CalcularHash(stremRequest);//aqui realiza a assinatura.
  //strRequestAssinadoStream := ObjACBrEAD.CalcularAssinatura(stremRequest, dgstSHA256, outBase64);

  //strRequestAssinado := CalcHashArquivo('request.txt');
  {
  memoEnv.Lines.Add('--------------STREAM-------------');
  memoEnv.Lines.Add(strRequestAssinadoStream);
  memoEnv.Lines.Add('---------------------------');
  }
  //streamstr := TStringStream.Create();
  //strList.SaveToStream(streamstr);
  //strList.SaveToFile('request.txt');
  //strRequestAssinadoList := CalcularHash(strList);//aqui realiza a assinatura.
  //strRequestAssinadoList := ObjACBrEAD.CalcularAssinatura(strList, dgstSHA256, outBase64);
  //strRequestAssinado := ObjACBrEAD.CalcularAssinaturaArquivo('request.txt', dgstSHA256, outBase64);
  //strRequestAssinado := strRequestAssinadoList;
  {
  memoEnv.Lines.Add('--------------STRLIST-------------');
  memoEnv.Lines.Add(strRequestAssinadoList);
  memoEnv.Lines.Add('---------------------------');
  }
  //strRequestAssinadoAnsiString := CalcularHash(strLinha1+strLinha2+strLinha3+strLinha4+strLinha5+strLinha6+strLinha7+strLinha8);//aqui realiza a assinatura.
  //strRequestAssinadoAnsiString := CalcularHash(ChangeLineBreak(strLinha1+strLinha2+strLinha3+strLinha4+strLinha5+strLinha6+strLinha7+strLinha8, sLineBreak));//aqui realiza a assinatura.
  //strRequestAssinadoAnsiString := ObjACBrEAD.CalcularAssinatura(ChangeLineBreak(strLinha1+strLinha2+strLinha3+strLinha4+strLinha5+strLinha6+strLinha7+strLinha8, sLineBreak), dgstSHA256, outBase64);
  {
  memoEnv.Lines.Add('--------------ANSISTRING-------------');
  memoEnv.Lines.Add(strRequestAssinadoAnsiString);
  memoEnv.Lines.Add('---------------------------');
  }

  //strRequestAssinado := strRequestAssinadoAnsiString;
  {*** FIM BLOCO DE ASSINATURA ***}

  {*** MONTAGEM DO HEADER ***}
  FHTTP.Request.Clear;
  FHTTP.Request.CustomHeaders.Clear;
  FHTTP.Request.UserAgent := 'Mozilla/4.0 (compatible; MSIE 7.0; Windows NT 6.0; Acoo Browser; GTB5; Mozilla/4.0 (compatible; MSIE 6.0; Windows NT 5.1; SV1) ; Maxthon; InfoPath.1; .NET CLR 3.5.30729; .NET CLR 3.0.30618)';
  FHTTP.Request.Accept := '*/*';
  //FHTTP.Request.AcceptCharSet       := 'UTF-8, *;q=0.8';
  FHTTP.Request.AcceptEncoding := 'gzip, deflate, br';
  FHTTP.Request.BasicAuthentication := False;
  FHTTP.Request.Connection := 'keep-alive';

  {
  stremRequest := TStringStream.Create('');
  stremRequest.Clear;
  stremRequest.LoadFromFile('assinatura.txt');
  strRequestAssinado := stremRequest.DataString;
  }

  FHTTP.Request.CustomHeaders.FoldLines := False;
  FHTTP.Request.ContentType := 'application/json';
  FHTTP.Request.CustomHeaders.Add('Authorization: Bearer ' + editToken.Text); //TOKEN OBTIDO.
  FHTTP.Request.CustomHeaders.Add('X-Brad-Signature: ' + strRequestAssinado);
  //FHTTP.Request.CustomHeaders.Add('cpf-cnpj: 00000000000000'); //CNPJ DA EMPRESA
  FHTTP.Request.CustomHeaders.Add('X-Brad-Nonce: ' + IntToStr(intMiliSegundos));
  FHTTP.Request.CustomHeaders.Add('X-Brad-Timestamp: ' + strTimeStamp);
  FHTTP.Request.CustomHeaders.Add('X-Brad-Algorithm: SHA256');
  {*** FIM MONTAGEM DO HEADER ***}

  xRequestBody := TStringStream.Create(strObj); //Preenche o Body para enviar no Post.

  try
    strResult := FHTTP.Post(UrlCriaBoleto, xRequestBody); //Envia.
    MemoResp.lines.add(strResult);

    objJson := TlkJSON.ParseText(strResult) as TlkJSONobject;

  except
    on E: EIdHTTPProtocolException do
    begin
      MemoResp.Lines.add(E.ErrorMessage);
    end;
  end;

  FreeAndNil(xRequestBody);
  FreeAndNil(strList);
  //FreeAndNil(streamstr);
end;

end.
