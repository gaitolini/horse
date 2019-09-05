unit Horse.CGI;

interface

uses IdHTTPWebBrokerBridge, Horse.Core, IdContext;

type
  THorse = class(THorseCore)
  private
    FPort: Integer;
    procedure OnAuthentication(AContext: TIdContext; const AAuthType, AAuthData: String; var VUsername, VPassword: String;
      var VHandled: Boolean);
  public
    constructor Create; overload;
    constructor Create(APort: Integer); overload;
    property Port: Integer read FPort write FPort;
    procedure Start; override;
  end;

implementation

{ THorse }

uses Horse.Constants, Horse.WebModule, System.SysUtils, Web.WebReq;

constructor THorse.Create(APort: Integer);
begin
  inherited Create;
  FPort := APort;
end;

constructor THorse.Create;
begin
  inherited Create;
  FPort := DEFAULT_PORT;
end;

procedure THorse.OnAuthentication(AContext: TIdContext; const AAuthType, AAuthData: String; var VUsername, VPassword: String;
  var VHandled: Boolean);
begin
  VHandled := True;
end;

procedure THorse.Start;
var
  LHTTPWebBroker: TIdHTTPWebBrokerBridge;
  LAttach: string;
begin
  inherited;
  WebRequestHandler.WebModuleClass := WebModuleClass;
  LHTTPWebBroker := TIdHTTPWebBrokerBridge.Create(nil);
  try
    try
      LHTTPWebBroker.OnParseAuthentication := OnAuthentication;

      LHTTPWebBroker.DefaultPort := FPort;
      Writeln(Format(START_RUNNING, [FPort]));
      LHTTPWebBroker.Active := True;
      LHTTPWebBroker.StartListening;
      Write('Press return to stop ...');
      Read(LAttach);

      LHTTPWebBroker.Active := False;
      LHTTPWebBroker.Bindings.Clear;
    except
      on E: Exception do
        Writeln(E.ClassName, ': ', E.Message);
    end;
  finally
    LHTTPWebBroker.free;
  end;
end;

end.
