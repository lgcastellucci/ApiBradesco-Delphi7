program ApiBradesco;

uses
  Forms,
  Principal in 'Principal.pas' {FPrincipal},
  LibBradescoApiCriaBoleto in 'LibBradescoApiCriaBoleto.pas',
  Funcoes in 'Funcoes.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TFPrincipal, FPrincipal);
  Application.Run;
end.
