unit Unit1;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs;

type
  TForm1 = class(TForm)
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}

type
  { C++ String 类内存结构 大小：24字节 }
  VCString = record
    strMem: PDWORD;    // 字符串指针
    R1, R2, R3: DWORD; // 未知
    len: DWORD;        // 字符串长度
    R4: DWORD;         // 定值 = $0000002F
  end;

procedure TestVCString(strValue: VCString); stdcall; external 'VC02.dll';

{ Delphi String 转换为 C++ String }
function DelphiString2VCString(strFileName: string): VCString;
var
  vcs: AnsiString;
begin
  FillChar(Result, SizeOf(VCString), #0);   // 置空
  vcs           := AnsiString(strFileName); // 宽字节转换为短字节
  Result.strMem := @vcs[1];                 // 字符串指针
  Result.len    := Length(vcs);             // 字符串长度
  Result.R4     := $0000002F;               // 定值
end;

procedure TForm1.FormCreate(Sender: TObject);
var
  AAA: VCString;
begin
  AAA := DelphiString2VCString('F:\Github\dbImage\bin\Win32\test.jpg');
  TestVCString(AAA);
end;

end.
