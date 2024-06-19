unit LibBradescoApiCriaBoleto;

interface

uses
  uLkJSON, SysUtils;

type
  TLibBradescoApiCriaBoleto = class
  private
    FregistrarTitulo: Integer;
    FcodUsuario: string;
    FnroCpfCnpjBenef: string;
    FfilCpfCnpjBenef: string;
    FdigCpfCnpjBenef: string;
    FtipoAcesso: Integer;
    FcpssoaJuridContr: Integer;
    FctpoContrNegoc: Integer;
    FnseqContrNegoc: Integer;
    FcidtfdProdCobr: Integer;
    FcnegocCobr: Integer;
    FcodigoBanco: Integer;
    Ffiller: string;
    FeNseqContrNegoc: Integer;
    FtipoRegistro: Integer;
    FcprodtServcOper: Integer;
    FctitloCobrCdent: Integer;
    FctitloCliCdent: string;
    FdemisTitloCobr: string;
    FdvctoTitloCobr: string;
    FcidtfdTpoVcto: Integer;
    FcindcdEconmMoeda: Integer;
    FvnmnalTitloCobr: Integer;
    FqmoedaNegocTitlo: Integer;
    FcespceTitloCobr: Integer;
    FcindcdAceitSacdo: string;
    FctpoProteTitlo: Integer;
    FctpoPrzProte: Integer;
    FctpoProteDecurs: Integer;
    FctpoPrzDecurs: Integer;
    FcctrlPartcTitlo: Integer;
    FcformaEmisPplta: Integer;
    FcindcdPgtoParcial: string;
    FqtdePgtoParcial: Integer;
    Ffiller1: string;
    FptxJuroVcto: Integer;
    FvdiaJuroMora: Integer;
    FqdiaInicJuro: Integer;
    FpmultaAplicVcto: Integer;
    FvmultaAtrsoPgto: Integer;
    FqdiaInicMulta: Integer;
    FpdescBonifPgto01: Integer;
    FvdescBonifPgto01: Integer;
    FdlimDescBonif1: string;
    FpdescBonifPgto02: Integer;
    FvdescBonifPgto02: Integer;
    FdlimDescBonif2: string;
    FpdescBonifPgto03: Integer;
    FvdescBonifPgto03: Integer;
    FdlimDescBonif3: string;
    FctpoPrzCobr: Integer;
    FpdescBonifPgto: Integer;
    FvdescBonifPgto: Integer;
    FdlimBonifPgto: string;
    FvabtmtTitloCobr: Integer;
    FviofPgtoTitlo: Integer;
    Ffiller2: string;
    FisacdoTitloCobr: string;
    FelogdrSacdoTitlo: string;
    FenroLogdrSacdo: Integer;
    FecomplLogdrSacdo: string;
    FccepSacdoTitlo: Integer;
    FccomplCepSacdo: Integer;
    FebairoLogdrSacdo: string;
    FimunSacdoTitlo: string;
    FcsglUfSacdo: string;
    FindCpfCnpjSacdo: Integer;
    FnroCpfCnpjSacdo: string;
    FrenderEletrSacdo: string;
    FcdddFoneSacdo: Integer;
    FcfoneSacdoTitlo: Integer;
    FbancoDeb: Integer;
    FagenciaDeb: Integer;
    FagenciaDebDv: Integer;
    FcontaDeb: Integer;
    FbancoCentProt: Integer;
    FagenciaDvCentPr: Integer;
    FisacdrAvalsTitlo: string;
    FelogdrSacdrAvals: string;
    FenroLogdrSacdr: Integer;
    FecomplLogdrSacdr: string;
    FccepSacdrTitlo: Integer;
    FccomplCepSacdr: Integer;
    FebairoLogdrSacdr: string;
    FimunSacdrAvals: string;
    FcsglUfSacdr: string;
    FindCpfCnpjSacdr: Integer;
    FnroCpfCnpjSacdr: Integer;
    FrenderEletrSacdr: string;
    FcdddFoneSacdr: Integer;
    FcfoneSacdrTitlo: Integer;
    Ffiller3: string;
    Ffase: Integer;
    FcindcdCobrMisto: string;
    FialiasAdsaoCta: string;
    FiconcPgtoSpi: string;
    FcaliasAdsaoCta: string;
    FilinkGeracQrcd: string;
    FwqrcdPdraoMercd: string;
    FvalidadeAposVencimento: string;
    Ffiller4: string;
  public
    constructor Create;
    destructor Destroy; override;
    procedure Clear;
    function ToString(): string;
    property registrarTitulo: Integer read FregistrarTitulo write FregistrarTitulo; //Registrar t�tulo 1 = Registrar o t�tulo 2 = Somente consistir dados do t�tulo
    property codUsuario: string read FcodUsuario write FcodUsuario; //C�digo do Usu�rio respons�vel - Fixo = APISERVIC
    property nroCpfCnpjBenef: string read FnroCpfCnpjBenef write FnroCpfCnpjBenef; //N�mero de Inscri��o do CNPJ ou CPF do Benefici�rio (Cedente)
    property filCpfCnpjBenef: string read FfilCpfCnpjBenef write FfilCpfCnpjBenef; //N�mero da Filial do CNPJ do Benefici�rio (Cedente) Obs.: incluir zeros quando se tratar de CPF
    property digCpfCnpjBenef: string read FdigCpfCnpjBenef write FdigCpfCnpjBenef; //D�gitos verificadores do CNPJ ou CPF do Benefici�rio (Cedente)
    property tipoAcesso: Integer read FtipoAcesso write FtipoAcesso; //Tipo de acesso desejado - Fixo = 2
    property cpssoaJuridContr: Integer read FcpssoaJuridContr write FcpssoaJuridContr; //C�digo da pessoa jur�dica do contrato - Fixo = 0
    property ctpoContrNegoc: Integer read FctpoContrNegoc write FctpoContrNegoc; //Tipo do Contrato - Fixo = 0
    property nseqContrNegoc: Integer read FnseqContrNegoc write FnseqContrNegoc; //N�mero do Contrato - Fixo = 0
    property cidtfdProdCobr: Integer read FcidtfdProdCobr write FcidtfdProdCobr; //Identificador do Produto Cobran�a (Carteira)
    property cnegocCobr: Integer read FcnegocCobr write FcnegocCobr; //N�mero do Contrato (Negocia��o Ag�ncia + Conta)
    property codigoBanco: Integer read FcodigoBanco write FcodigoBanco; //C�digo do Banco
    property filler: string read Ffiller write Ffiller; //Implementa��es futuras - Manter em branco
    property eNseqContrNegoc: Integer read FeNseqContrNegoc write FeNseqContrNegoc; //N�mero do Contrato - Fixo = 0
    property tipoRegistro: Integer read FtipoRegistro write FtipoRegistro; //Tipo de registro do t�tulo: 1 = T�tulo 2 = T�tulo com Instru��o de Protesto 3 = T�tulo com Instru��o de Protesto Falimentar
    property cprodtServcOper: Integer read FcprodtServcOper write FcprodtServcOper; //C�digo do Produto Cobran�a
    property ctitloCobrCdent: Integer read FctitloCobrCdent write FctitloCobrCdent; //Nosso N�mero
    property ctitloCliCdent: string read FctitloCliCdent write FctitloCliCdent; //Identificador do t�tulo pelo benefici�rio (Seu N�mero)
    property demisTitloCobr: string read FdemisTitloCobr write FdemisTitloCobr; //Data de emiss�o do t�tulo. Deve ser informada como o exemplo 01.01.2001
    property dvctoTitloCobr: string read FdvctoTitloCobr write FdvctoTitloCobr; //Data de vencimento do t�tulo Deve ser informada como o exemplo 01.01.2001
    property cidtfdTpoVcto: Integer read FcidtfdTpoVcto write FcidtfdTpoVcto; //Identificador do tipo de vencimento 0 = Data fixa 1 = Contra-apresenta��o 2 = � vista - Fixo = 0
    property cindcdEconmMoeda: Integer read FcindcdEconmMoeda write FcindcdEconmMoeda; //Identificador da moeda do t�tulo (BACEN)
    property vnmnalTitloCobr: Integer read FvnmnalTitloCobr write FvnmnalTitloCobr; //Valor nominal do t�tulo
    property qmoedaNegocTitlo: Integer read FqmoedaNegocTitlo write FqmoedaNegocTitlo; //Quantidade de moeda do t�tulo - Fixo = 0
    property cespceTitloCobr: Integer read FcespceTitloCobr write FcespceTitloCobr; //C�digo da esp�cie do t�tulo Ex. 02 = DM
    property cindcdAceitSacdo: string read FcindcdAceitSacdo write FcindcdAceitSacdo; //Identificador de aceite do devedor (Sacado)
    property ctpoProteTitlo: Integer read FctpoProteTitlo write FctpoProteTitlo; //Tipo de protesto autom�tico do t�tulo 1 = Dias corridos 2 = Dias �teis
    property ctpoPrzProte: Integer read FctpoPrzProte write FctpoPrzProte; //Quantidade de dias ap�s o vencimento, para protesto autom�tico - Sim, caso informado ctpoProteTitlo
    property ctpoProteDecurs: Integer read FctpoProteDecurs write FctpoProteDecurs; //Tipo decurso de protesto 1 = Dias corridos 2 = Dias �teis - Sim, caso informado ctpoProteTitlo
    property ctpoPrzDecurs: Integer read FctpoPrzDecurs write FctpoPrzDecurs; //Quantidade de dias para decurso de protesto - Fixo = 0
    property cctrlPartcTitlo: Integer read FcctrlPartcTitlo write FcctrlPartcTitlo; //Controle do participante
    property cformaEmisPplta: Integer read FcformaEmisPplta write FcformaEmisPplta; //Forma de emiss�o do boleto (Papeleta) 01 = Banco emite 02 = Cliente emite 03 = Banco envia e-mail 04 = Banco envia sms - Fixo = 2
    property cindcdPgtoParcial: string read FcindcdPgtoParcial write FcindcdPgtoParcial; //Indicador de pagamento parcial S = Sim N = N�o - Fixo = N�o
    property qtdePgtoParcial: Integer read FqtdePgtoParcial write FqtdePgtoParcial; //Quantidade de pagamento parcial de 001 a 099 - Fixo = 000
    property filler1: string read Ffiller1 write Ffiller1; //Implementa��es futuras - Manter em branco
    property ptxJuroVcto: Integer read FptxJuroVcto write FptxJuroVcto; //Percentual de juros ap�s vencimento Deve ser informado com 5 decimais (Exemplo: 2% = 2.00000 | 0,05% = 0.05000)
    property vdiaJuroMora: Integer read FvdiaJuroMora write FvdiaJuroMora; //Valor di�rio de juros ap�s vencimento Deve ser informado com 2 decimais (Exemplo: R$ 2,00 = 200 | R$ 0,05 = 005)
    property qdiaInicJuro: Integer read FqdiaInicJuro write FqdiaInicJuro; //Quantidade de dias ap�s o vencimento, para incid�ncia de juros - Sim, caso informado valor ou percentual de Juros
    property pmultaAplicVcto: Integer read FpmultaAplicVcto write FpmultaAplicVcto; //Percentual de multa ap�s vencimento Deve ser informado com 5 decimais (Exemplo: 2% = 2.00000 | 0,05% = 0.05000)
    property vmultaAtrsoPgto: Integer read FvmultaAtrsoPgto write FvmultaAtrsoPgto; //Valor da multa ap�s vencimento Deve ser informado com 2 decimais (Exemplo: R$ 2,00 = 200 | R$ 0,05 = 005)
    property qdiaInicMulta: Integer read FqdiaInicMulta write FqdiaInicMulta; //Quantidade de dias ap�s o vencimento, para incid�ncia de multa - Sim, caso informado valor ou percentual de Multa
    property pdescBonifPgto01: Integer read FpdescBonifPgto01 write FpdescBonifPgto01; //1� - Percentual de desconto Deve ser informado com 5 decimais (Exemplo: 2% = 2.00000 | 0,05% = 0.05000)
    property vdescBonifPgto01: Integer read FvdescBonifPgto01 write FvdescBonifPgto01; //1� - Valor de desconto Deve ser informado com 2 decimais (Exemplo: R$ 2,00 = 200 | R$ 0,05 = 005)
    property dlimDescBonif1: string read FdlimDescBonif1 write FdlimDescBonif1; //1� - Data-limite de desconto Deve ser informada como o exemplo 01.01.2001 - Sim, caso informado valor ou percentual do 1� desconto/ bonifica��o
    property pdescBonifPgto02: Integer read FpdescBonifPgto02 write FpdescBonifPgto02; //2� - Percentual de desconto Deve ser informado com 5 decimais (Exemplo: 2% = 2.00000 | 0,05% = 0.05000)
    property vdescBonifPgto02: Integer read FvdescBonifPgto02 write FvdescBonifPgto02; //2� - Valor de desconto Deve ser informado com 2 decimais (Exemplo: R$ 2,00 = 200 | R$ 0,05 = 005)
    property dlimDescBonif2: string read FdlimDescBonif2 write FdlimDescBonif2; //2� - Data-limite de desconto Deve ser informada como o exemplo 01.01.2001 - Sim, caso informado valor ou percentual do 2� desconto
    property pdescBonifPgto03: Integer read FpdescBonifPgto03 write FpdescBonifPgto03; //3� - Percentual de desconto Deve ser informado com 5 decimais (Exemplo: 2% = 2.00000 | 0,05% = 0.05000)
    property vdescBonifPgto03: Integer read FvdescBonifPgto03 write FvdescBonifPgto03; //3� - Valor de desconto Deve ser informado com 2 decimais (Exemplo: R$ 2,00 = 200 | R$ 0,05 = 005)
    property dlimDescBonif3: string read FdlimDescBonif3 write FdlimDescBonif3; //3� - Data-limite de desconto Deve ser informada como o exemplo 01.01.2001 - Sim, caso informado valor ou percentual do 3� desconto
    property ctpoPrzCobr: Integer read FctpoPrzCobr write FctpoPrzCobr; //Tipo de prazo desconto/bonifica��o 1 = Dias corridos 2 = Dias �teis - Sim, caso informado valor ou percentual de desconto/ bonifica��o
    property pdescBonifPgto: Integer read FpdescBonifPgto write FpdescBonifPgto; //Percentual de desconto Deve ser informado com 5 decimais (Exemplo: 2% = 2.00000 | 0,05% = 0.05000)
    property vdescBonifPgto: Integer read FvdescBonifPgto write FvdescBonifPgto; //Valor de bonifica��o Deve ser informado com 2 decimais (Exemplo: R$ 2,00 = 200 | R$ 0,05 = 005)
    property dlimBonifPgto: string read FdlimBonifPgto write FdlimBonifPgto; //Data-limite de bonifica��o Deve ser informada como o exemplo 01.01.2001 - Sim, caso informado valor ou percentual de bonifica��o
    property vabtmtTitloCobr: Integer read FvabtmtTitloCobr write FvabtmtTitloCobr; //Valor de abatimento do t�tulo
    property viofPgtoTitlo: Integer read FviofPgtoTitlo write FviofPgtoTitlo; //Valor de IOF do t�tulo - N�o, usar apenas para seguradoras
    property filler2: string read Ffiller2 write Ffiller2; //Implementa��es futuras - Manter em branco
    property isacdoTitloCobr: string read FisacdoTitloCobr write FisacdoTitloCobr; //Nome do devedor (Sacado)
    property elogdrSacdoTitlo: string read FelogdrSacdoTitlo write FelogdrSacdoTitlo; //Logradouro do devedor (Sacado)
    property enroLogdrSacdo: Integer read FenroLogdrSacdo write FenroLogdrSacdo; //N�mero do logradouro do devedor (Sacado)
    property ecomplLogdrSacdo: string read FecomplLogdrSacdo write FecomplLogdrSacdo; //Complemento do logradouro do devedor (Sacado)
    property ccepSacdoTitlo: Integer read FccepSacdoTitlo write FccepSacdoTitlo; //CEP do devedor (Sacado)
    property ccomplCepSacdo: Integer read FccomplCepSacdo write FccomplCepSacdo; //Complemento do CEP do devedor (Sacado)
    property ebairoLogdrSacdo: string read FebairoLogdrSacdo write FebairoLogdrSacdo; //Bairro do logradouro do devedor (Sacado)
    property imunSacdoTitlo: string read FimunSacdoTitlo write FimunSacdoTitlo; //Munic�pio do devedor (Sacado)
    property csglUfSacdo: string read FcsglUfSacdo write FcsglUfSacdo; //Sigla da Unidade Federativa do devedor (Sacado)
    property indCpfCnpjSacdo: Integer read FindCpfCnpjSacdo write FindCpfCnpjSacdo; //Indicador de CPF ou CNPJ do devedor (Sacado) 1 = CPF 2 = CNPJ
    property nroCpfCnpjSacdo: string read FnroCpfCnpjSacdo write FnroCpfCnpjSacdo; //N�mero do CPF ou CNPJ do devedor (Sacado)
    property renderEletrSacdo: string read FrenderEletrSacdo write FrenderEletrSacdo; //Endere�o eletr�nico do devedor - e-mail (Sacado)
    property cdddFoneSacdo: Integer read FcdddFoneSacdo write FcdddFoneSacdo; //DDD do telefone do devedor (Sacado)
    property cfoneSacdoTitlo: Integer read FcfoneSacdoTitlo write FcfoneSacdoTitlo; //N�mero do telefone do devedor (Sacado)
    property bancoDeb: Integer read FbancoDeb write FbancoDeb; //C�digo do Banco para d�bito autom�tico
    property agenciaDeb: Integer read FagenciaDeb write FagenciaDeb; //N�mero do Ag�ncia para d�bito autom�tico
    property agenciaDebDv: Integer read FagenciaDebDv write FagenciaDebDv; //D�gito verificador da Ag�ncia para d�bito autom�tico - Sim, caso informado agenciaDeb
    property contaDeb: Integer read FcontaDeb write FcontaDeb; //N�mero da conta para d�bito autom�tico - Sim, caso informado agenciaDeb
    property bancoCentProt: Integer read FbancoCentProt write FbancoCentProt; //C�digo do Banco de protesto - Fixo = 0
    property agenciaDvCentPr: Integer read FagenciaDvCentPr write FagenciaDvCentPr; //N�mero da Ag�ncia de protesto - Fixo = 0
    property isacdrAvalsTitlo: string read FisacdrAvalsTitlo write FisacdrAvalsTitlo; //Nome do sacador avalista (Benefici�rio final)
    property elogdrSacdrAvals: string read FelogdrSacdrAvals write FelogdrSacdrAvals; //Logradouro do sacador avalista (Benefici�rio final) - Sim, caso informado dados do sacador avalista (Benefici�rio final)
    property enroLogdrSacdr: Integer read FenroLogdrSacdr write FenroLogdrSacdr; //N�mero do logradouro do sacador avalista (Benefici�rio final) - Sim, caso informado dados do sacador avalista (Benefici�rio final)
    property ecomplLogdrSacdr: string read FecomplLogdrSacdr write FecomplLogdrSacdr; //Complemento do logradouro do sacador avalista (Benefici�rio final) - Sim, caso informado dados do sacador avalista (Benefici�rio final)
    property ccepSacdrTitlo: Integer read FccepSacdrTitlo write FccepSacdrTitlo; //CEP do sacador avalista - Sim, caso informado dados do sacador avalista (Benefici�rio final)
    property ccomplCepSacdr: Integer read FccomplCepSacdr write FccomplCepSacdr; //Complemento do CEP do sacador avalista - Sim, caso informado dados do sacador avalista (Benefici�rio final)
    property ebairoLogdrSacdr: string read FebairoLogdrSacdr write FebairoLogdrSacdr; //Bairro do logradouro do sacador avalista - Sim, caso informado dados do sacador avalista (Benefici�rio final)
    property imunSacdrAvals: string read FimunSacdrAvals write FimunSacdrAvals; //Munic�pio do sacador avalista - Sim, caso informado dados do sacador avalista (Benefici�rio final)
    property csglUfSacdr: string read FcsglUfSacdr write FcsglUfSacdr; //Sigla da Unidade Federativa do sacador avalista - Sim, caso informado dados do sacador avalista (Benefici�rio final)
    property indCpfCnpjSacdr: Integer read FindCpfCnpjSacdr write FindCpfCnpjSacdr; //Indicador de CPF ou CNPJ do sacador avalista 1 = CPF 2 = CNPJ - Sim, caso informado dados do sacador avalista (Benefici�rio final)
    property nroCpfCnpjSacdr: Integer read FnroCpfCnpjSacdr write FnroCpfCnpjSacdr; //N�mero do CPF ou CNPJ do sacador avalista - Sim, caso informado dados do sacador avalista (Benefici�rio final)
    property renderEletrSacdr: string read FrenderEletrSacdr write FrenderEletrSacdr; //Endere�o eletr�nico do sacador avalista - e-mail
    property cdddFoneSacdr: Integer read FcdddFoneSacdr write FcdddFoneSacdr; //DDD do telefone do sacador avalista
    property cfoneSacdrTitlo: Integer read FcfoneSacdrTitlo write FcfoneSacdrTitlo; //N�mero do telefone do sacador avalista
    property filler3: string read Ffiller3 write Ffiller3; //Implementa��es futuras - Fixo = 0
    property fase: Integer read Ffase write Ffase; //Fase de atualiza��o do QR Code: 1 = Registro do t�tulo e envio ao BSPI 2 = Vincula��o do t�tulo com QR Code - Fixo = 1
    property cindcdCobrMisto: string read FcindcdCobrMisto write FcindcdCobrMisto; //Indicador do registro de t�tulo com QR Code S = Sim N = N�o - Fixo = S
    property ialiasAdsaoCta: string read FialiasAdsaoCta write FialiasAdsaoCta; //Chave Pix do benefici�rio - Manter em branco
    property iconcPgtoSpi: string read FiconcPgtoSpi write FiconcPgtoSpi; //TXID do t�tulo - Manter em branco
    property caliasAdsaoCta: string read FcaliasAdsaoCta write FcaliasAdsaoCta; // C�digos de erro na gera��o do QR Code pelo BSPI - Manter em branco
    property ilinkGeracQrcd: string read FilinkGeracQrcd write FilinkGeracQrcd; //Identifica��o do location do QR Code gerado pelo BSPI - Manter em branco
    property wqrcdPdraoMercd: string read FwqrcdPdraoMercd write FwqrcdPdraoMercd; //C�digo EMV do QR Code gerado pelo BSPI - Manter em branco
    property validadeAposVencimento: string read FvalidadeAposVencimento write FvalidadeAposVencimento; //Quantidade de dias ap�s vencimento, que o t�tulo � v�lido para pagamento via Pix - Manter em branco
    property filler4: string read Ffiller4 write Ffiller4; //Implementa��es futuras - Manter em branco
  end;

implementation

uses
  Funcoes;

{ TLibBradescoApiCriaBoleto }

procedure TLibBradescoApiCriaBoleto.Clear;
begin
  FregistrarTitulo := 0;
  FcodUsuario := 'APISERVIC';
  FnroCpfCnpjBenef := ''; //9 digitos do CNPJ
  FfilCpfCnpjBenef := ''; //4 digitos depois da Barra "/".
  FdigCpfCnpjBenef := ''; //2 digito verificador.
  FtipoAcesso := 2;
  FcpssoaJuridContr := 0;
  FctpoContrNegoc := 0;
  FnseqContrNegoc := 0;
  FcidtfdProdCobr := 17; //Carteira
  FcnegocCobr := 0; //N�mero do Contrato (Negocia��o Ag�ncia + Conta).
  FcodigoBanco := 237;
  Ffiller := '';
  FeNseqContrNegoc := 0;
  FtipoRegistro := 1;
  FcprodtServcOper := 0;
  FctitloCobrCdent := 00000000001; //Nosso N�mero
  FctitloCliCdent := ''; //Numero da NF.
  FdemisTitloCobr := '01.01.2000'; //Data Emiss�o.
  FdvctoTitloCobr := '01.01.2000'; //Data Vencimento.
  FcidtfdTpoVcto := 1; //Identificador do tipo de vencimento 0 = Data fixa 1 = Contra-apresenta��o 2 = � vista
  FcindcdEconmMoeda := 0; //Moeda.
  FvnmnalTitloCobr := 1000; //Valor do T�tulo.
  FqmoedaNegocTitlo := 0; //Quantidade Moeda - Fixo = 0
  FcespceTitloCobr := 02; //Esp�cie do Documento - 02 = DM.
  FcindcdAceitSacdo := 'N'; //Aceite do Devedor(SACADO) - Fixo = N.
  FctpoProteTitlo := 0; //Tipo de protesto autom�tico do t�tulo 1 = Dias corridos 2 = Dias �teis
  FctpoPrzProte := 0; //Quantidade de dias ap�s o vencimento, para protesto autom�tico - Obrigat�rio se informou o Tipo de Protesto
  FctpoProteDecurs := 0; //Tipo decurso de protesto 1 = Dias corridos 2 = Dias �teis - Obrigat�rio se informou o Tipo de Protesto
  FctpoPrzDecurs := 0; //Quantidade de dias para decurso de protesto - Fixo = 0
  FcctrlPartcTitlo := 0; //Controle do participante
  FcformaEmisPplta := 2; //Forma de emiss�o do boleto (Papeleta) 01 = Banco emite 02 = Cliente emite 03 = Banco envia e-mail 04 = Banco envia sms - Fixo = 2
  FcindcdPgtoParcial := 'N'; //Indicador de pagamento parcial S = Sim N = N�o - Fixo = N�o
  FqtdePgtoParcial := 000; //Quantidade de pagamento parcial de 001 a 099 - Fixo = 000
  Ffiller1 := '';
  FptxJuroVcto := 0; //Percentual de juros ap�s vencimento Deve ser informado com 5 decimais (Exemplo: 2% = 2.00000 | 0,05% = 0.05000)
  FvdiaJuroMora := 0; //Valor di�rio de juros ap�s vencimento Deve ser informado com 2 decimais (Exemplo: R$ 2,00 = 200 | R$ 0,05 = 005)
  FqdiaInicJuro := 0; //Quantidade de dias ap�s o vencimento, para incid�ncia de juros - Sim, caso informado valor ou percentual de Juros.
  FvmultaAtrsoPgto := 0; //Valor da multa ap�s vencimento Deve ser informado com 2 decimais (Exemplo: R$ 2,00 = 200 | R$ 0,05 = 005)
  FqdiaInicMulta := 0; //Quantidade de dias ap�s o vencimento, para incid�ncia de multa - Obrigat�rio se informar o Valor ou Percentual de Multa.
  FpdescBonifPgto01 := 0; //1� - Percentual de desconto Deve ser informado com 5 decimais (Exemplo: 2% = 2.00000 | 0,05% = 0.05000)
  FvdescBonifPgto01 := 0; //1� - Valor de desconto Deve ser informado com 2 decimais (Exemplo: R$ 2,00 = 200 | R$ 0,05 = 005)
  FdlimDescBonif1 := ''; //1� - Data-limite de desconto Deve ser informada como o exemplo 01.01.2001 - Obrigat�rio, caso informado valor ou percentual do 1� desconto/ bonifica��o
  FpdescBonifPgto02 := 0; //2� - Percentual de desconto Deve ser informado com 5 decimais (Exemplo: 2% = 2.00000 | 0,05% = 0.05000)
  FvdescBonifPgto02 := 0; //2� - Valor de desconto Deve ser informado com 2 decimais (Exemplo: R$ 2,00 = 200 | R$ 0,05 = 005)
  FdlimDescBonif2 := ''; //2� - Data-limite de desconto Deve ser informada como o exemplo 01.01.2001
  FpdescBonifPgto03 := 0; //3� - Percentual de desconto Deve ser informado com 5 decimais (Exemplo: 2% = 2.00000 | 0,05% = 0.05000)
  FvdescBonifPgto03 := 0; //3� - Valor de desconto Deve ser informado com 2 decimais (Exemplo: R$ 2,00 = 200 | R$ 0,05 = 005)
  FdlimDescBonif3 := ''; //3� - Data-limite de desconto Deve ser informada como o exemplo 01.01.2001
  FctpoPrzCobr := 0; //Tipo de prazo desconto/bonifica��o 1 = Dias corridos 2 = Dias �teis
  FpdescBonifPgto := 0; //Percentual de desconto Deve ser informado com 5 decimais (Exemplo: 2% = 2.00000 | 0,05% = 0.05000)
  FvdescBonifPgto := 0; //Valor de bonifica��o Deve ser informado com 2 decimais (Exemplo: R$ 2,00 = 200 | R$ 0,05 = 005)
  FdlimBonifPgto := ''; //Data-limite de bonifica��o Deve ser informada como o exemplo 01.01.2001
  FvabtmtTitloCobr := 0; //Valor de abatimento do t�tulo
  FviofPgtoTitlo := 0; //Valor de IOF do t�tulo - N�o, usar apenas para seguradoras
  Ffiller2 := ''; //Manter em branco.
  FisacdoTitloCobr := ''; //Nome do devedor (Sacado) Tam: 70.
  FelogdrSacdoTitlo := ''; //Logradouro do devedor (Sacado) Tam: 40
  FenroLogdrSacdo := 0; //N�mero do logradouro do devedor (Sacado)
  FecomplLogdrSacdo := ''; //Complemento do logradouro do devedor (Sacado) Tam: 15
  FccepSacdoTitlo := 0; //CEP do devedor (Sacado)
  FccomplCepSacdo := 0; //Complemento do CEP do devedor (Sacado)
  FebairoLogdrSacdo := ''; //Bairro do logradouro do devedor (Sacado) Tam: 40
  FimunSacdoTitlo := ''; //Munic�pio do devedor (Sacado) Tam: 30
  FcsglUfSacdo := ''; //Sigla da Unidade Federativa do devedor (Sacado) Tam: 2
  FindCpfCnpjSacdo := 0; //Indicador de CPF ou CNPJ do devedor (Sacado) 1 = CPF 2 = CNPJ
  FnroCpfCnpjSacdo := '0'; //N�mero do CPF ou CNPJ do devedor (Sacado)
  FrenderEletrSacdo := ''; //Endere�o eletr�nico do devedor - e-mail (Sacado)
  FcdddFoneSacdo := 0; //DDD do telefone do devedor (Sacado)
  FcfoneSacdoTitlo := 0; //N�mero do telefone do devedor (Sacado);
  FbancoDeb := 0; //C�digo do Banco para d�bito autom�tico
  FagenciaDeb := 0; //N�mero do Ag�ncia para d�bito autom�tico
  FagenciaDebDv := 0; //D�gito verificador da Ag�ncia para d�bito autom�tico - Obrigat�rio, caso informado agenciaDeb
  FcontaDeb := 0; //N�mero da conta para d�bito autom�tico - Obrigat�rio, caso informado agenciaDeb
  FbancoCentProt := 0; //C�digo do Banco de protesto
  FagenciaDvCentPr := 0; //N�mero da Ag�ncia de protesto
  FisacdrAvalsTitlo := ''; //Nome do sacador avalista (Benefici�rio final) - Tam: 40
  FelogdrSacdrAvals := ''; //Logradouro do sacador avalista (Benefici�rio final) - Tam: 40
  FenroLogdrSacdr := 0; //N�mero do logradouro do sacador avalista (Benefici�rio final)
  FecomplLogdrSacdr := ''; //Complemento do logradouro do sacador avalista (Benefici�rio final)
  FccepSacdrTitlo := 0; //CEP do sacador avalista
  FccomplCepSacdr := 0; //Complemento do CEP do sacador avalista
  FebairoLogdrSacdr := ''; //Bairro do logradouro do sacador avalista
  FimunSacdrAvals := ''; //Munic�pio do sacador avalista
  FcsglUfSacdr := ''; //Sigla da Unidade Federativa do sacador avalista
  FindCpfCnpjSacdr := 0; //Indicador de CPF ou CNPJ do sacador avalista 1 = CPF 2 = CNPJ
  FnroCpfCnpjSacdr := 0; //N�mero do CPF ou CNPJ do sacador avalista
  FrenderEletrSacdr := ''; //Endere�o eletr�nico do sacador avalista - e-mail
  FcdddFoneSacdr := 0; //DDD do telefone do sacador avalista
  FcfoneSacdrTitlo := 0; //N�mero do telefone do sacador avalista
  Ffiller3 := ''; //Implementa��es futuras
  Ffase := 1; //Fase de atualiza��o do QR Code: 1 = Registro do t�tulo e envio ao BSPI 2 = Vincula��o do t�tulo com QR Code
  FcindcdCobrMisto := 'S'; //Indicador do registro de t�tulo com QR Code S = Sim N = N�o
  FialiasAdsaoCta := ''; //Chave Pix do benefici�rio
  FiconcPgtoSpi := ''; //TXID do t�tulo
  FcaliasAdsaoCta := ''; //C�digos de erro na gera��o do QR Code pelo BSPI
  FilinkGeracQrcd := ''; //Identifica��o do location do QR Code gerado pelo BSPI
  FwqrcdPdraoMercd := ''; //C�digo EMV do QR Code gerado pelo BSPI
  FvalidadeAposVencimento := ''; //Quantidade de dias ap�s vencimento, que o t�tulo � v�lido para pagamento via Pix
  Ffiller4 := ''; //Implementa��es futuras
end;

constructor TLibBradescoApiCriaBoleto.Create;
begin
  Self.Clear;
end;

destructor TLibBradescoApiCriaBoleto.Destroy;
begin
  inherited;
end;

function TLibBradescoApiCriaBoleto.ToString(): string;
var
  i: Integer;
  strJson: string;
  json: TlkJSONobject;
begin
  json := TlkJSONobject.Create;

  json.Add('FregistrarTitulo', FregistrarTitulo);
  json.Add('FcodUsuario', FcodUsuario);
  json.Add('FnroCpfCnpjBenef', FnroCpfCnpjBenef);
  json.Add('FfilCpfCnpjBenef', FfilCpfCnpjBenef);
  json.Add('FdigCpfCnpjBenef', FdigCpfCnpjBenef);
  json.Add('FtipoAcesso', FtipoAcesso);
  json.Add('FcpssoaJuridContr', FcpssoaJuridContr);
  json.Add('FctpoContrNegoc', FctpoContrNegoc);
  json.Add('FnseqContrNegoc', FnseqContrNegoc);
  json.Add('FcidtfdProdCobr', FcidtfdProdCobr);
  json.Add('FcnegocCobr', FcnegocCobr);
  json.Add('FcodigoBanco', FcodigoBanco);
  json.Add('Ffiller', Ffiller);
  json.Add('FeNseqContrNegoc', FeNseqContrNegoc);
  json.Add('FtipoRegistro', FtipoRegistro);
  json.Add('FcprodtServcOper', FcprodtServcOper);
  json.Add('FctitloCobrCdent', FctitloCobrCdent);
  json.Add('FctitloCliCdent', FctitloCliCdent);
  json.Add('FdemisTitloCobr', FdemisTitloCobr);
  json.Add('FdvctoTitloCobr', FdvctoTitloCobr);
  json.Add('FcidtfdTpoVcto', FcidtfdTpoVcto);
  json.Add('FcindcdEconmMoeda', FcindcdEconmMoeda);
  json.Add('FvnmnalTitloCobr', FvnmnalTitloCobr);
  json.Add('FqmoedaNegocTitlo', FqmoedaNegocTitlo);
  json.Add('FcespceTitloCobr', FcespceTitloCobr);
  json.Add('FcindcdAceitSacdo', FcindcdAceitSacdo);
  json.Add('FctpoProteTitlo', FctpoProteTitlo);
  json.Add('FctpoPrzProte', FctpoPrzProte);
  json.Add('FctpoProteDecurs', FctpoProteDecurs);
  json.Add('FctpoPrzDecurs', FctpoPrzDecurs);
  json.Add('FcctrlPartcTitlo', FcctrlPartcTitlo);
  json.Add('FcformaEmisPplta', FcformaEmisPplta);
  json.Add('FcindcdPgtoParcial', FcindcdPgtoParcial);
  json.Add('FqtdePgtoParcial', FqtdePgtoParcial);
  json.Add('Ffiller1', Ffiller1);
  json.Add('FptxJuroVcto', FptxJuroVcto);
  json.Add('FvdiaJuroMora', FvdiaJuroMora);
  json.Add('FqdiaInicJuro', FqdiaInicJuro);
  json.Add('FvmultaAtrsoPgto', FvmultaAtrsoPgto);
  json.Add('FqdiaInicMulta', FqdiaInicMulta);
  json.Add('FpdescBonifPgto01', FpdescBonifPgto01);
  json.Add('FvdescBonifPgto01', FvdescBonifPgto01);
  json.Add('FdlimDescBonif1', FdlimDescBonif1);
  json.Add('FpdescBonifPgto02', FpdescBonifPgto02);
  json.Add('FvdescBonifPgto02', FvdescBonifPgto02);
  json.Add('FdlimDescBonif2', FdlimDescBonif2);
  json.Add('FpdescBonifPgto03', FpdescBonifPgto03);
  json.Add('FvdescBonifPgto03', FvdescBonifPgto03);
  json.Add('FdlimDescBonif3', FdlimDescBonif3);
  json.Add('FctpoPrzCobr', FctpoPrzCobr);
  json.Add('FpdescBonifPgto', FpdescBonifPgto);
  json.Add('FvdescBonifPgto', FvdescBonifPgto);
  json.Add('FdlimBonifPgto', FdlimBonifPgto);
  json.Add('FvabtmtTitloCobr', FvabtmtTitloCobr);
  json.Add('FviofPgtoTitlo', FviofPgtoTitlo);
  json.Add('Ffiller2', Ffiller2);
  json.Add('FisacdoTitloCobr', FisacdoTitloCobr);
  json.Add('FelogdrSacdoTitlo', FelogdrSacdoTitlo);
  json.Add('FenroLogdrSacdo', FenroLogdrSacdo);
  json.Add('FecomplLogdrSacdo', FecomplLogdrSacdo);
  json.Add('FccepSacdoTitlo', FccepSacdoTitlo);
  json.Add('FccomplCepSacdo', FccomplCepSacdo);
  json.Add('FebairoLogdrSacdo', FebairoLogdrSacdo);
  json.Add('FimunSacdoTitlo', FimunSacdoTitlo);
  json.Add('FcsglUfSacdo', FcsglUfSacdo);
  json.Add('FindCpfCnpjSacdo', FindCpfCnpjSacdo);
  json.Add('FnroCpfCnpjSacdo', FnroCpfCnpjSacdo);
  json.Add('FrenderEletrSacdo', FrenderEletrSacdo);
  json.Add('FcdddFoneSacdo', FcdddFoneSacdo);
  json.Add('FcfoneSacdoTitlo', FcfoneSacdoTitlo);
  json.Add('FbancoDeb', FbancoDeb);
  json.Add('FagenciaDeb', FagenciaDeb);
  json.Add('FagenciaDebDv', FagenciaDebDv);
  json.Add('FcontaDeb', FcontaDeb);
  json.Add('FbancoCentProt', FbancoCentProt);
  json.Add('FagenciaDvCentPr', FagenciaDvCentPr);
  json.Add('FisacdrAvalsTitlo', FisacdrAvalsTitlo);
  json.Add('FelogdrSacdrAvals', FelogdrSacdrAvals);
  json.Add('FenroLogdrSacdr', FenroLogdrSacdr);
  json.Add('FecomplLogdrSacdr', FecomplLogdrSacdr);
  json.Add('FccepSacdrTitlo', FccepSacdrTitlo);
  json.Add('FccomplCepSacdr', FccomplCepSacdr);
  json.Add('FebairoLogdrSacdr', FebairoLogdrSacdr);
  json.Add('FimunSacdrAvals', FimunSacdrAvals);
  json.Add('FcsglUfSacdr', FcsglUfSacdr);
  json.Add('FindCpfCnpjSacdr', FindCpfCnpjSacdr);
  json.Add('FnroCpfCnpjSacdr', FnroCpfCnpjSacdr);
  json.Add('FrenderEletrSacdr', FrenderEletrSacdr);
  json.Add('FcdddFoneSacdr', FcdddFoneSacdr);
  json.Add('FcfoneSacdrTitlo', FcfoneSacdrTitlo);
  json.Add('Ffiller3', Ffiller3);
  json.Add('Ffase', Ffase);
  json.Add('FcindcdCobrMisto', FcindcdCobrMisto);
  json.Add('FialiasAdsaoCta', FialiasAdsaoCta);
  json.Add('FiconcPgtoSpi', FiconcPgtoSpi);
  json.Add('FcaliasAdsaoCta', FcaliasAdsaoCta);
  json.Add('FilinkGeracQrcd', FilinkGeracQrcd);
  json.Add('FwqrcdPdraoMercd', FwqrcdPdraoMercd);
  json.Add('FvalidadeAposVencimento', FvalidadeAposVencimento);
  json.Add('Ffiller4', Ffiller4);

  i := 0;
  strJson := GenerateReadableText(json, i);
  strJson := Remove_13_10(strJson);
  Result := strJson;
end;

end.

