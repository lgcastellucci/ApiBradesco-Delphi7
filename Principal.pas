unit Principal;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, uLkJSON, ACBrDFeSSL, ACBrEAD, ACBrOpenSSLUtils, IdHTTP,
  IdSSLOpenSSL, IniFiles, synacode;

type
  TFPrincipal = class(TForm)
    btnGerarToken: TButton;
    MemoRespToken: TMemo;
    Label1: TLabel;
    editToken: TEdit;
    Label2: TLabel;
    lblTokenExpira: TLabel;
    btnRegistraBoleto: TButton;
    MemoResp: TMemo;
    btnValidaAcesso: TButton;
    procedure btnGerarTokenClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure btnRegistraBoletoClick(Sender: TObject);
    procedure btnValidaAcessoClick(Sender: TObject);
  private
    { Private declarations }
    DFeSSL: TDFeSSL;
    //FSSLDigest: TSSLDgst;
    //FSSLHashOutput: TSSLHashOutput;
    //ObjACBrEAD: TACBrEAD;
    FIdSSLIOHandlerSocketOpenSSL: TIdSSLIOHandlerSocketOpenSSL;
    ACBrOpenSSLUtils1: TACBrOpenSSLUtils;
    FHTTP: TIdHTTP;
    procedure InsereLog(Dado: string);
  public
    { Public declarations }
    procedure ACBrEADGetChavePrivada(var Chave: string);
  end;

var
  FPrincipal: TFPrincipal;
  UrlToken, UrlTokenNoRequest, UrlRegBoleto, UrlRegBoletoNoRequest: string;
  ClienteID, ClientSecret: string;
  ArquivoPFX, SenhaPFX: string;
  PagadorDocumento, PagadorNome, PagadorEnderecoRua, PagadorEnderecoNumero, PagadorEnderecoCep, PagadorEnderecoBairro, PagadorEnderecoMunicipio, PagadorEnderecoUF: string;
  BeneficiarioDocumento, BeneficiarioCarteira, BeneficiarioAgencia, BeneficiarioConta: string;
  Agora: TDateTime;

implementation

uses
  Funcoes, LibBradescoApiCriaBoleto;

{$R *.dfm}

procedure TFPrincipal.InsereLog(Dado: string);
var
  LogFile: TextFile;
  LogNomeArquiovo: string;
begin
  try
    LogNomeArquiovo := ExtractFilePath(Application.ExeName) + 'Log_' + FormatDateTime('YYYY_MM_DD', Now) + '.txt';

    AssignFile(LogFile, LogNomeArquiovo);
    if FileExists(LogNomeArquiovo) then
      Append(LogFile)
    else
      Rewrite(LogFile);

    try
      Writeln(LogFile, FormatDateTime('DD/MM/YYYY HH:NN:SS', Now) + ' => ' + Dado);
      Flush(LogFile);
    except
    end;

    CloseFile(LogFile);
  except
    // Nao foi possivel gravar
  end;
end;

procedure TFPrincipal.FormCreate(Sender: TObject);
var
  IniFile: TIniFile;
begin
  //ProdUrlToken := 'https://openapi.bradesco.com.br/auth/server/v1.1/token';
  //ProdUrlTokenNoRequest := 'https://openapi.bradesco.com.br/auth/server/v1.1/token';

  UrlToken := 'https://proxy.api.prebanco.com.br/auth/server/v1.2/token';
  UrlTokenNoRequest := 'https://proxy.api.prebanco.com.br/auth/server/v1.1/token';

  UrlRegBoleto := 'https://proxy.api.prebanco.com.br/v1/boleto-hibrido/registrar-boleto';
  UrlRegBoletoNoRequest := '/v1/boleto-hibrido/registrar-boleto';

  //C_URL             = 'https://openapi.bradesco.com.br/cobranca-bancaria/v2';
  //C_URL_HOM         = 'https://proxy.api.prebanco.com.br/cobranca-bancaria/v2';

  //C_URL_OAUTH_PROD  = 'https://openapi.bradesco.com.br/auth/server/v1.2/token';
  //C_URL_OAUTH_HOM   = 'https://proxy.api.prebanco.com.br/auth/server/v1.2/token';

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
    BeneficiarioCarteira := IniFile.ReadString('Configuracoes', 'BeneficiarioCarteira', '');
    BeneficiarioAgencia := IniFile.ReadString('Configuracoes', 'BeneficiarioAgencia', '');
    BeneficiarioConta := IniFile.ReadString('Configuracoes', 'BeneficiarioConta', '');

    PagadorDocumento := IniFile.ReadString('Configuracoes', 'PagadorDocumento', '');
    PagadorNome := IniFile.ReadString('Configuracoes', 'PagadorNome', '');
    PagadorEnderecoRua := IniFile.ReadString('Configuracoes', 'PagadorEnderecoRua', '');
    PagadorEnderecoNumero := IniFile.ReadString('Configuracoes', 'PagadorEnderecoNumero', '');
    PagadorEnderecoCep := IniFile.ReadString('Configuracoes', 'PagadorEnderecoCep', '');
    PagadorEnderecoBairro := IniFile.ReadString('Configuracoes', 'PagadorEnderecoBairro', '');
    PagadorEnderecoMunicipio := IniFile.ReadString('Configuracoes', 'PagadorEnderecoMunicipio', '');
    PagadorEnderecoUF := IniFile.ReadString('Configuracoes', 'PagadorEnderecoUF', '');

    //if IniFile.ReadString('Configuracoes', 'UrlToken', '') <> '' then
    //  UrlToken := IniFile.ReadString('Configuracoes', 'UrlToken', '');

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
  InsereLog('Inicio GerarToken');

  Agora := Now;

  {*** BLOCO FORMATACAO DA DATA DO PAYLOAD***}
  dataAtual := AddHoursToDateTime(Agora, 3); //Data Atual UTC
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
  strJsonHeader := RemoveCaracterNaoUtilizadoNoJson(strJsonHeader);
  strHeaderBase64 := EncodeBase64(strJsonHeader);
  strHeaderBase64 := RemoveCaracterIgual(strHeaderBase64);

  InsereLog('strJsonHeader ==> ' + strJsonHeader);
  {*** FIM BLOCO MONTAGEM DO HEADER JSON ***}


  {*** BLOCO MONTAGEM DO PAYLOAD JSON ***}
  jsonPayload := TlkJSONobject.Create;
  jsonPayload.Add('aud', UrlTokenNoRequest);
  jsonPayload.Add('sub', ClienteID);
  jsonPayload.Add('iat', Padr(IntToStr(intSegundos), '0', 10));
  jsonPayload.Add('exp', Padr(IntToStr(intSegundos1h), '0', 10));
  jsonPayload.Add('jti', Padr(IntToStr(intSegundos), '0', 10) + '000');

  //jsonPayload.Add('iat', IntToStr(intSegundos));
  //jsonPayload.Add('exp', IntToStr(intSegundos1h));
  //jsonPayload.Add('jti', IntToStr(intMilisegundos));

  jsonPayload.Add('ver', '1.1');
  i := 0;
  strPayloadBase := GenerateReadableText(jsonPayload, i);
  strPayloadBase := RemoveCaracterNaoUtilizadoNoJson(strPayloadBase);

  strPayloadBase64 := EncodeBase64(strPayloadBase);
  strPayloadBase64 := RemoveCaracterIgual(strPayloadBase64);

  InsereLog('strPayloadBase ==> ' + strPayloadBase);
  {*** FIM BLOCO MONTAGEM DO PAYLOAD JSON ***}

  {*** BLOCO DE ASSINATURA ***}
  DFeSSL.SSLCryptLib := cryOpenSSL;
  DFeSSL.ArquivoPFX := ArquivoPFX;
  DFeSSL.Senha := SenhaPFX;
  DFeSSL.CarregarCertificado;

  streamHeaderPayload := TStringStream.Create(strHeaderBase64 + '.' + strPayloadBase64); //concatena conforme o manual.
  strAssinado := CalcularHash(DFeSSL, streamHeaderPayload); //aqui realiza a assinatura.

  strJWS := strHeaderBase64 + '.' + strPayloadBase64 + '.' + strAssinado; //HeaderBase64 + PayloadBase64 + JWT assinado = JWS.
  InsereLog('strJWS ==> ' + strJWS);
  {*** FIM BLOCO DE ASSINATURA ***}

  {*** BLOCO DE MONTAGEM DO BODY ***}
  xRequestBody := TStringList.Create;
  xRequestBody.Add('grant_type=urn:ietf:params:oauth:grant-type:jwt-bearer');
  xRequestBody.Add('assertion=' + strJWS);
  {*** FIM BLOCO DE MONTAGEM DO BODY ***}

  FHTTP.Request.Clear;
  FHTTP.Request.CustomHeaders.Clear;
  FHTTP.Request.UserAgent := 'Mozilla/4.0 (compatible; MSIE 7.0; Windows NT 6.0; Acoo Browser; GTB5; Mozilla/4.0 (compatible; MSIE 6.0; Windows NT 5.1; SV1) ; Maxthon; InfoPath.1; .NET CLR 3.5.30729; .NET CLR 3.0.30618)';
  FHTTP.Request.AcceptCharSet := 'UTF-8, *;q=0.8';
  FHTTP.Request.AcceptEncoding := 'gzip, deflate, br';
  FHTTP.Request.ContentType := 'application/x-www-form-urlencoded';
  FHTTP.Request.BasicAuthentication := False;

  try
    strResult := FHTTP.Post(UrlToken, xRequestBody);
    MemoRespToken.lines.add(strResult);

    InsereLog('UrlToken ==> ' + UrlToken);
    for i := 0 to xRequestBody.Count - 1 do
      InsereLog('xRequestBody ==> ' + xRequestBody[i]);
    InsereLog('httpResult ==> ' + strResult);

    objJson := TlkJSON.ParseText(strResult) as TlkJSONobject;
    //objJson := TJSONObject.ParseJSONValue(TEncoding.UTF8.GetBytes(strResult), 0) as TJSONObject;

    if objJson.Field['access_token'] <> nil then
      if VarToStr(objJson.Field['access_token'].Value) <> '' then
        editToken.Text := VarToStr(objJson.Field['access_token'].Value);

    if objJson.Field['expires_in'] <> nil then
      if VarToStr(objJson.Field['expires_in'].Value) <> '' then
        lblTokenExpira.Caption := VarToStr(objJson.Field['expires_in'].Value);

    //if Assigned(objJson.Values['expires_in']) then
    //  if (objJson.Values['expires_in'].ToString <> EmptyStr) then
    //    lblTokenExpira.Caption := DateTimeToStr(IncSecond(Now, StrToInt(objJson.Values['expires_in'].ToString)));
  except
    on E: EIdHTTPProtocolException do
    begin
      InsereLog('httpResult ==> ' + strResult);
      InsereLog('ErrorMessage ==> ' + E.ErrorMessage);
      MemoRespToken.Lines.add(E.ErrorMessage);
    end;
  end;

  FreeAndNil(xRequestBody);

  InsereLog('Fim GerarToken');
  InsereLog('');

end;

procedure TFPrincipal.btnRegistraBoletoClick(Sender: TObject);
var
  strResult: string;
  strMiliSegundos: string;
  strTimeStamp, strObj, strLinha1, strLinha2, strLinha3, strLinha4, strLinha5, strLinha6, strLinha7, strLinha8: string;
  dataAtual: TDateTime;
  stremRequest: TStringStream;
  strRequestAssinado: string;
  xRequestBody: TStringStream;
  objCriaBoleto: TLibBradescoApiCriaBoleto;
  strList: TStringList;
  i: Integer;
begin
  if editToken.Text = '' then
    Exit;

  InsereLog('Inicio RegistraBoleto');

  {*** BLOCO FORMATACAO DA DATA DO PAYLOAD***}
  dataAtual := AddHoursToDateTime(Agora, 3); //Data Atual UTC
  strMiliSegundos := Padr(IntToStr(DateTimeToUnix(dataAtual)), '0', 10) + '000'; //Data Atual UTC em Milisegundos.
  //intMiliSegundos := DateTimeToUnix(dataAtual) * 1000 + MilliSecondsBetween(dataAtual, Trunc(dataAtual)); //Data Atual UTC em Milisegundos.
  strTimeStamp := ConverteDateISO(dataAtual, True);
  {*** FIM BLOCO FORMATACAO DA DATA DO PAYLOAD***}

  {*** CRIAÇAO DO PAYLOAD DO BOLETO ***}
  objCriaBoleto := TLibBradescoApiCriaBoleto.Create; //Classe contento todos os campos do boleto.
  objCriaBoleto.Clear;
  objCriaBoleto.nroCpfCnpjSacdo := PagadorDocumento; //DOCUMENTO DO CLIENTE.
  objCriaBoleto.ialiasAdsaoCta := PagadorDocumento; //DOCUMENTO DO CLIENTE.

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
  objCriaBoleto.demisTitloCobr := FormatDateTime('dd.mm.yyyy', Agora); //'30.08.2023'; //Data Emissão.
  objCriaBoleto.dvctoTitloCobr := FormatDateTime('dd.mm.yyyy', AddHoursToDateTime(Agora, 24)); //'31.08.2023'; //Data Vencimento.

  strObj := objCriaBoleto.ToString();

  //boleto padrão enviado em um modelo de API fornecido pelo banco
  strObj := objCriaBoleto.stringApiModeloDoBanco();

  InsereLog('strObj');
  InsereLog(strObj);
  {*** FIM CRIAÇAO DO PAYLOAD DO BOLETO ***}

  {*** BLOCO DE ASSINATURA ***}
  DFeSSL.SSLCryptLib := cryOpenSSL;
  DFeSSL.ArquivoPFX := ArquivoPFX;
  DFeSSL.Senha := SenhaPFX;
  DFeSSL.CarregarCertificado;

  strLinha1 := 'POST' + #10; //Methodo HTTP
  strLinha2 := UrlRegBoletoNoRequest + #10; //URI de Requisição
  strLinha3 := '' + #10; //Parâmetros. quando houver, se não tem deixa linha em branco.
  strLinha4 := strObj + #10; //Json de criação do Boleto que vai no Body.
  strLinha5 := editToken.Text + #10; //Access-token retornado da API.
  strLinha6 := strMiliSegundos + #10; //Hora Atual em Milisegundos.
  strLinha7 := strTimeStamp + #10; //TimeStamp;
  strLinha8 := 'SHA256'; //Algoritimo Usado.

  //Assinatura conforme o manual
  {
  if FileExists('request.txt') then
    DeleteFile('request.txt');

  stremRequest := TStringStream.Create(strLinha1 + strLinha2 + strLinha3 + strLinha4 + strLinha5 + strLinha6 + strLinha7 + strLinha8); //Aqui vai o arquivo para Assinar.
  FileStream := TFileStream.Create('request.txt', fmCreate);
  try
    // Define a posição inicial no TStringStream
    stremRequest.Position := 0;
    // Copia o conteúdo do TStringStream para o TFileStream
    FileStream.CopyFrom(stremRequest, stremRequest.Size);
  finally
    // Libera a memória usada pelo TFileStream
    FileStream.Free;
  end;

  InsereLog('request.txt');
  InsereLog(strLinha1 + strLinha2 + strLinha3 + strLinha4 + strLinha5 + strLinha6 + strLinha7 + strLinha8);

  strRequestAssinado := URLEncode(CalcularHashArquivo(DFeSSL, 'request.txt')); //aqui realiza a assinatura.
  }


  stremRequest := TStringStream.Create(strLinha1 + strLinha2 + strLinha3 + strLinha4 + strLinha5 + strLinha6 + strLinha7 + strLinha8); //Aqui vai o arquivo para Assinar.
  strRequestAssinado := CalcularHash(DFeSSL, stremRequest);//aqui realiza a assinatura.

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
  FHTTP.Request.CustomHeaders.Add('X-Brad-Nonce: ' + strMiliSegundos);
  FHTTP.Request.CustomHeaders.Add('X-Brad-Signature: ' + strRequestAssinado);
  FHTTP.Request.CustomHeaders.Add('X-Brad-Timestamp: ' + strTimeStamp);
  FHTTP.Request.CustomHeaders.Add('X-Brad-Algorithm: SHA256');
  FHTTP.Request.CustomHeaders.Add('access-token: ' + ClienteID);
  FHTTP.Request.CustomHeaders.Add('Content-Type: ' + 'application/json');
  //FHTTP.Request.CustomHeaders.Add('cpf-cnpj: ' + BeneficiarioDocumento); //CNPJ DA EMPRESA
  {*** FIM MONTAGEM DO HEADER ***}

  xRequestBody := TStringStream.Create(strObj); //Preenche o Body para enviar no Post.

  try
    InsereLog('UrlRegBoleto ==> ' + UrlRegBoleto);
    for i := 0 to FHTTP.Request.CustomHeaders.Count - 1 do
      InsereLog('Headers ==> ' + FHTTP.Request.CustomHeaders[i]);

    strResult := FHTTP.Post(UrlRegBoleto, xRequestBody); //Envia.

    InsereLog('httpResult ==> ' + strResult);
    MemoResp.lines.add(strResult);
  except
    on E: EIdHTTPProtocolException do
    begin
      InsereLog('httpResult ==> ' + strResult);
      InsereLog('httpError ==> ' + E.ErrorMessage);
      MemoResp.Lines.add(E.ErrorMessage);
    end;
  end;

  FreeAndNil(xRequestBody);
  FreeAndNil(strList);
  //FreeAndNil(streamstr);
  InsereLog('Fim RegistraBoleto');
end;

procedure TFPrincipal.btnValidaAcessoClick(Sender: TObject);
var
  strResult: string;
  strMiliSegundos: string;
  strTimeStamp, strLinha1, strLinha2, strLinha3, strLinha4, strLinha5, strLinha6, strLinha7, strLinha8: string;
  dataAtual: TDateTime;
  stremRequest: TStringStream;
  strRequestAssinado, strRequestAssinadoList, strRequestAssinadoStream, strRequestAssinadoAnsiString: string;
  xRequestBody: TStringStream;
  urlValidaAcesso: string;
  FileStream: TFileStream;
  i: Integer;
begin
  if editToken.Text = '' then
    btnGerarToken.Click;

  if editToken.Text = '' then
    Exit;

  InsereLog('Inicio ValidaAcesso');

  {*** BLOCO FORMATACAO DA DATA DO PAYLOAD***}
  dataAtual := AddHoursToDateTime(Agora, 3); //Data Atual UTC
  strMiliSegundos := Padr(IntToStr(DateTimeToUnix(dataAtual)), '0', 10) + '000'; //Data Atual UTC em Milisegundos.
  //intMiliSegundos := DateTimeToUnix(dataAtual) * 1000 + MilliSecondsBetween(dataAtual, Trunc(dataAtual)); //Data Atual UTC em Milisegundos.
  strTimeStamp := ConverteDateISO(dataAtual, True);
  {*** FIM BLOCO FORMATACAO DA DATA DO PAYLOAD***}

  {*** BLOCO DE ASSINATURA ***}
  DFeSSL.SSLCryptLib := cryOpenSSL;
  DFeSSL.ArquivoPFX := ArquivoPFX;
  DFeSSL.Senha := SenhaPFX;
  DFeSSL.CarregarCertificado;

  urlValidaAcesso := 'https://proxy.api.prebanco.com.br/v1.1/jwt-service?agencia=' + BeneficiarioAgencia + '&conta=' + BeneficiarioConta;
  strLinha1 := 'POST' + #10; //Methodo HTTP
  strLinha2 := '/v1.1/jwt-service' + #10; //URI de Requisição
  strLinha3 := 'agencia=' + BeneficiarioAgencia + '&conta=' + BeneficiarioConta + #10; //Parâmetros
  strLinha4 := '' + #10; //Body.
  strLinha5 := editToken.Text + #10; //Access-token retornado da API.
  strLinha6 := strMiliSegundos + #10; //Hora Atual em Milisegundos.
  strLinha7 := strTimeStamp + #10; //TimeStamp;
  strLinha8 := 'SHA256'; //Algoritimo Usado.


  if FileExists('request.txt') then
    DeleteFile('request.txt');

  stremRequest := TStringStream.Create(strLinha1 + strLinha2 + strLinha3 + strLinha4 + strLinha5 + strLinha6 + strLinha7 + strLinha8); //Aqui vai o arquivo para Assinar.
  FileStream := TFileStream.Create('request.txt', fmCreate);
  try
    // Define a posição inicial no TStringStream
    stremRequest.Position := 0;
    // Copia o conteúdo do TStringStream para o TFileStream
    FileStream.CopyFrom(stremRequest, stremRequest.Size);
  finally
    // Libera a memória usada pelo TFileStream
    FileStream.Free;
  end;
  strRequestAssinado := URLEncode(CalcularHashArquivo(DFeSSL, 'request.txt')); //aqui realiza a assinatura.

  {*** FIM BLOCO DE ASSINATURA ***}

  {*** MONTAGEM DO HEADER ***}
  FHTTP.Request.Clear;
  FHTTP.Request.CustomHeaders.Clear;
  FHTTP.Request.UserAgent := 'Mozilla/4.0 (compatible; MSIE 7.0; Windows NT 6.0; Acoo Browser; GTB5; Mozilla/4.0 (compatible; MSIE 6.0; Windows NT 5.1; SV1) ; Maxthon; InfoPath.1; .NET CLR 3.5.30729; .NET CLR 3.0.30618)';
  FHTTP.Request.Accept := '*/*';
  FHTTP.Request.AcceptEncoding := 'gzip, deflate, br';
  FHTTP.Request.BasicAuthentication := False;
  FHTTP.Request.Connection := 'keep-alive';

  FHTTP.Request.CustomHeaders.FoldLines := False;
  FHTTP.Request.ContentType := 'application/json';
  FHTTP.Request.CustomHeaders.Add('Authorization: Bearer ' + editToken.Text); //TOKEN OBTIDO.
  FHTTP.Request.CustomHeaders.Add('X-Brad-Nonce: ' + strMiliSegundos);
  FHTTP.Request.CustomHeaders.Add('X-Brad-Signature: ' + strRequestAssinado);
  FHTTP.Request.CustomHeaders.Add('X-Brad-Timestamp: ' + strTimeStamp);
  FHTTP.Request.CustomHeaders.Add('X-Brad-Algorithm: SHA256');
  FHTTP.Request.CustomHeaders.Add('access-token: ' + ClienteID);
  FHTTP.Request.CustomHeaders.Add('Content-Type: ' + 'application/json');
  {*** FIM MONTAGEM DO HEADER ***}

  InsereLog('HTTP Headers');
  InsereLog(FHTTP.Request.CustomHeaders.Text);

  xRequestBody := TStringStream.Create(''); //Preenche o Body para enviar no Post.

  try
    InsereLog('urlValidaAcesso ==> ' + urlValidaAcesso);
    for i := 0 to FHTTP.Request.CustomHeaders.Count - 1 do
      InsereLog('Headers ==> ' + FHTTP.Request.CustomHeaders[i]);

    strResult := FHTTP.Post(urlValidaAcesso, xRequestBody); //Envia.

    InsereLog('httpResult ==> ' + strResult);
    MemoResp.lines.add(strResult);
 

    //objJson := TlkJSON.ParseText(strResult) as TlkJSONobject;

  except
    on E: EIdHTTPProtocolException do
    begin
      InsereLog('httpResult ==> ' + strResult);
      InsereLog('httpError ==> ' + E.ErrorMessage);
      MemoResp.Lines.add(E.ErrorMessage);
    end;
  end;

  FreeAndNil(xRequestBody);

  InsereLog('Fim ValidaAcesso');
end;

end.

