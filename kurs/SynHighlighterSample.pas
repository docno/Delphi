{-------------------------------------------------------------------------------
The contents of this file are subject to the Mozilla Public License
Version 1.1 (the "License"); you may not use this file except in compliance
with the License. You may obtain a copy of the License at
http://www.mozilla.org/MPL/

Software distributed under the License is distributed on an "AS IS" basis,
WITHOUT WARRANTY OF ANY KIND, either express or implied. See the License for
the specific language governing rights and limitations under the License.

Code template generated with SynGen.
The original code is: SynHighlighterSample.pas, released 2012-12-01.
Description: Syntax Parser/Highlighter
The initial author of this file is ������.
Copyright (c) 2012, all rights reserved.

Contributors to the SynEdit and mwEdit projects are listed in the
Contributors.txt file.

Alternatively, the contents of this file may be used under the terms of the
GNU General Public License Version 2 or later (the "GPL"), in which case
the provisions of the GPL are applicable instead of those above.
If you wish to allow use of your version of this file only under the terms
of the GPL and not to allow others to use your version of this file
under the MPL, indicate your decision by deleting the provisions above and
replace them with the notice and other provisions required by the GPL.
If you do not delete the provisions above, a recipient may use your version
of this file under either the MPL or the GPL.

$Id: $

You may retrieve the latest version of this file at the SynEdit home page,
located at http://SynEdit.SourceForge.net

-------------------------------------------------------------------------------}

unit SynHighlighterSample;

{$I SynEdit.inc}

interface

uses
{$IFDEF SYN_CLX}
  QGraphics,
  QSynEditTypes,
  QSynEditHighlighter,
{$ELSE}
  Graphics,
  SynEditTypes,
  SynEditHighlighter,
{$ENDIF}
  SysUtils,
  Classes;

type
  TtkTokenKind = (
    tkComment,
    tkIdentifier,
    tkKey,
    tkNull,
    tkNumber,
    tkSpace,
    tkString,
    tkSymbolRaz,
    tkSymbolSk,
    tkSymbolZn,
    tkUnknown);

  TRangeState = (rsUnKnown, rsBraceComment, rsString);

  TProcTableProc = procedure of object;

  PIdentFuncTableFunc = ^TIdentFuncTableFunc;
  TIdentFuncTableFunc = function: TtkTokenKind of object;

const
  MaxKey = 88;

type
  TSynSampleSyn = class(TSynCustomHighlighter)
  private
    fLineRef: string;
    fLine: PChar;
    fLineNumber: Integer;
    fProcTable: array[#0..#255] of TProcTableProc;
    fRange: TRangeState;
    Run: LongInt;
    fStringLen: Integer;
    fToIdent: PChar;
    fTokenPos: Integer;
    fTokenID: TtkTokenKind;
    fIdentFuncTable: array[0 .. MaxKey] of TIdentFuncTableFunc;
    fCommentAttri: TSynHighlighterAttributes;
    fIdentifierAttri: TSynHighlighterAttributes;
    fKeyAttri: TSynHighlighterAttributes;
    fNumberAttri: TSynHighlighterAttributes;
    fSpaceAttri: TSynHighlighterAttributes;
    fStringAttri: TSynHighlighterAttributes;
    fSymbolRazAttri: TSynHighlighterAttributes;
    fSymbolSkAttri: TSynHighlighterAttributes;
    fSymbolZnAttri: TSynHighlighterAttributes;
    function KeyHash(ToHash: PChar): Integer;
    function KeyComp(const aKey: string): Boolean;
    function Func23: TtkTokenKind;
    function Func32: TtkTokenKind;
    function Func37: TtkTokenKind;
    function Func57: TtkTokenKind;
    function Func61: TtkTokenKind;
    function Func65: TtkTokenKind;
    function Func88: TtkTokenKind;
    procedure IdentProc;
    procedure NumberProc;
    procedure SymbolRazProc;
    procedure SymbolSkProc;
    procedure SymbolZnProc;
    procedure UnknownProc;
    function AltFunc: TtkTokenKind;
    procedure InitIdent;
    function IdentKind(MayBe: PChar): TtkTokenKind;
    procedure MakeMethodTables;
    procedure NullProc;
    procedure SpaceProc;
    procedure CRProc;
    procedure LFProc;
    procedure BraceCommentOpenProc;
    procedure BraceCommentProc;
    procedure StringOpenProc;
    procedure StringProc;
  protected
    function GetIdentChars: TSynIdentChars; override;
    function GetSampleSource: string; override;
    function IsFilterStored: Boolean; override;
  public
    constructor Create(AOwner: TComponent); override;
    {$IFNDEF SYN_CPPB_1} class {$ENDIF}
    function GetLanguageName: string; override;
    function GetRange: Pointer; override;
    procedure ResetRange; override;
    procedure SetRange(Value: Pointer); override;
    function GetDefaultAttribute(Index: integer): TSynHighlighterAttributes; override;
    function GetEol: Boolean; override;
    function GetKeyWords: string;
    function GetTokenID: TtkTokenKind;
    procedure SetLine(NewValue: String; LineNumber: Integer); override;
    function GetToken: String; override;
    function GetTokenAttribute: TSynHighlighterAttributes; override;
    function GetTokenKind: integer; override;
    function GetTokenPos: Integer; override;
    procedure Next; override;
  published
    property CommentAttri: TSynHighlighterAttributes read fCommentAttri write fCommentAttri;
    property IdentifierAttri: TSynHighlighterAttributes read fIdentifierAttri write fIdentifierAttri;
    property KeyAttri: TSynHighlighterAttributes read fKeyAttri write fKeyAttri;
    property NumberAttri: TSynHighlighterAttributes read fNumberAttri write fNumberAttri;
    property SpaceAttri: TSynHighlighterAttributes read fSpaceAttri write fSpaceAttri;
    property StringAttri: TSynHighlighterAttributes read fStringAttri write fStringAttri;
    property SymbolRazAttri: TSynHighlighterAttributes read fSymbolRazAttri write fSymbolRazAttri;
    property SymbolSkAttri: TSynHighlighterAttributes read fSymbolSkAttri write fSymbolSkAttri;
    property SymbolZnAttri: TSynHighlighterAttributes read fSymbolZnAttri write fSymbolZnAttri;
  end;

implementation

uses
{$IFDEF SYN_CLX}
  QSynEditStrConst;
{$ELSE}
  SynEditStrConst;
{$ENDIF}

{$IFDEF SYN_COMPILER_3_UP}
resourcestring
{$ELSE}
const
{$ENDIF}
  SYNS_FilterSample = 'All files';
  SYNS_LangSample = 'Sample';
  SYNS_AttrSymbolRaz = 'SymbolRaz';
  SYNS_AttrSymbolSk = 'SymbolSk';
  SYNS_AttrSymbolZn = 'SymbolZn';

var
  Identifiers: array[#0..#255] of ByteBool;
  mHashTable : array[#0..#255] of Integer;

procedure MakeIdentTable;
var
  I, J: Char;
begin
  for I := #0 to #255 do
  begin
    case I of
      '_', 'a'..'z', 'A'..'Z': Identifiers[I] := True;
    else
      Identifiers[I] := False;
    end;
    J := UpCase(I);
    case I in ['_', 'A'..'Z', 'a'..'z'] of
      True: mHashTable[I] := Ord(J) - 64
    else
      mHashTable[I] := 0;
    end;
  end;
end;

procedure TSynSampleSyn.InitIdent;
var
  I: Integer;
  pF: PIdentFuncTableFunc;
begin
  pF := PIdentFuncTableFunc(@fIdentFuncTable);
  for I := Low(fIdentFuncTable) to High(fIdentFuncTable) do
  begin
    pF^ := AltFunc;
    Inc(pF);
  end;
  fIdentFuncTable[23] := Func23;
  fIdentFuncTable[32] := Func32;
  fIdentFuncTable[37] := Func37;
  fIdentFuncTable[57] := Func57;
  fIdentFuncTable[61] := Func61;
  fIdentFuncTable[65] := Func65;
  fIdentFuncTable[88] := Func88;
end;

function TSynSampleSyn.KeyHash(ToHash: PChar): Integer;
begin
  Result := 0;
  while ToHash^ in ['_', 'a'..'z', 'A'..'Z'] do
  begin
    inc(Result, mHashTable[ToHash^]);
    inc(ToHash);
  end;
  fStringLen := ToHash - fToIdent;
end;

function TSynSampleSyn.KeyComp(const aKey: String): Boolean;
var
  I: Integer;
  Temp: PChar;
begin
  Temp := fToIdent;
  if Length(aKey) = fStringLen then
  begin
    Result := True;
    for i := 1 to fStringLen do
    begin
      if mHashTable[Temp^] <> mHashTable[aKey[i]] then
      begin
        Result := False;
        break;
      end;
      inc(Temp);
    end;
  end
  else
    Result := False;
end;

function TSynSampleSyn.Func23: TtkTokenKind;
begin
  if KeyComp('end') then Result := tkKey else Result := tkIdentifier;
end;

function TSynSampleSyn.Func32: TtkTokenKind;
begin
  if KeyComp('get') then Result := tkKey else Result := tkIdentifier;
end;

function TSynSampleSyn.Func37: TtkTokenKind;
begin
  if KeyComp('koef') then Result := tkKey else Result := tkIdentifier;
end;

function TSynSampleSyn.Func57: TtkTokenKind;
begin
  if KeyComp('given') then Result := tkKey else Result := tkIdentifier;
end;

function TSynSampleSyn.Func61: TtkTokenKind;
begin
  if KeyComp('cauchy') then Result := tkKey else Result := tkIdentifier;
end;

function TSynSampleSyn.Func65: TtkTokenKind;
begin
  if KeyComp('method') then Result := tkKey else Result := tkIdentifier;
end;

function TSynSampleSyn.Func88: TtkTokenKind;
begin
  if KeyComp('program') then Result := tkKey else Result := tkIdentifier;
end;

function TSynSampleSyn.AltFunc: TtkTokenKind;
begin
  Result := tkIdentifier;
end;

function TSynSampleSyn.IdentKind(MayBe: PChar): TtkTokenKind;
var
  HashKey: Integer;
begin
  fToIdent := MayBe;
  HashKey := KeyHash(MayBe);
  if HashKey <= MaxKey then
    Result := fIdentFuncTable[HashKey]
  else
    Result := tkIdentifier;
end;

procedure TSynSampleSyn.MakeMethodTables;
var
  I: Char;
begin
  for I := #0 to #255 do
    case I of
      #0: fProcTable[I] := NullProc;
      #10: fProcTable[I] := LFProc;
      #13: fProcTable[I] := CRProc;
      '{': fProcTable[I] := BraceCommentOpenProc;
      '''': fProcTable[I] := StringOpenProc;
      #1..#9,
      #11,
      #12,
      #14..#32 : fProcTable[I] := SpaceProc;
      'A'..'Z','a'..'z': fProcTable[I] := IdentProc;
      '0'..'9': fProcTable[I] := NumberProc;
      '>',';',',',':','.': fProcTable[I] := SymbolRazProc;
      '(',')','[',']': fProcTable[I] := SymbolSkProc;
      '-', '+', '*','^','/','=': fProcTable[I] := SymbolZnProc;
    else
      fProcTable[I] := UnknownProc;
    end;
end;

procedure TSynSampleSyn.SpaceProc;
begin
  fTokenID := tkSpace;
  repeat
    inc(Run);
  until not (fLine[Run] in [#1..#32]);
end;

procedure TSynSampleSyn.NullProc;
begin
  fTokenID := tkNull;
end;

procedure TSynSampleSyn.CRProc;
begin
  fTokenID := tkSpace;
  inc(Run);
  if fLine[Run] = #10 then
    inc(Run);
end;

procedure TSynSampleSyn.LFProc;
begin
  fTokenID := tkSpace;
  inc(Run);
end;

procedure TSynSampleSyn.BraceCommentOpenProc;
begin
  Inc(Run);
  fRange := rsBraceComment;
  BraceCommentProc;
  fTokenID := tkComment;
end;

procedure TSynSampleSyn.BraceCommentProc;
begin
  case fLine[Run] of
     #0: NullProc;
    #10: LFProc;
    #13: CRProc;
  else
    begin
      fTokenID := tkComment;
      repeat
        if (fLine[Run] = '}') then
        begin
          Inc(Run, 1);
          fRange := rsUnKnown;
          Break;
        end;
        if not (fLine[Run] in [#0, #10, #13]) then
          Inc(Run);
      until fLine[Run] in [#0, #10, #13];
    end;
  end;
end;

procedure TSynSampleSyn.StringOpenProc;
begin
  Inc(Run);
  fRange := rsString;
  StringProc;
  fTokenID := tkString;
end;

procedure TSynSampleSyn.StringProc;
begin
  fTokenID := tkString;
  repeat
    if (fLine[Run] = '''') then
    begin
      Inc(Run, 1);
      fRange := rsUnKnown;
      Break;
    end;
    if not (fLine[Run] in [#0, #10, #13]) then
      Inc(Run);
  until fLine[Run] in [#0, #10, #13];
end;

constructor TSynSampleSyn.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  fCommentAttri := TSynHighLighterAttributes.Create(SYNS_AttrComment);
  fCommentAttri.Style := [fsItalic];
  fCommentAttri.Foreground := clNavy;
  AddAttribute(fCommentAttri);

  fIdentifierAttri := TSynHighLighterAttributes.Create(SYNS_AttrSASM);
  fIdentifierAttri.Style := [fsItalic];
  fIdentifierAttri.Foreground := clHighlight;
  AddAttribute(fIdentifierAttri);

  fKeyAttri := TSynHighLighterAttributes.Create(SYNS_AttrSASMKey);
  fKeyAttri.Style := [fsBold];
  fKeyAttri.Foreground := clHotLight;
  AddAttribute(fKeyAttri);

  fNumberAttri := TSynHighLighterAttributes.Create(SYNS_AttrNumber);
  fNumberAttri.Foreground := clBlue;
  AddAttribute(fNumberAttri);

  fSpaceAttri := TSynHighLighterAttributes.Create(SYNS_AttrSpace);
  fSpaceAttri.Foreground := clCream;
  AddAttribute(fSpaceAttri);

  fStringAttri := TSynHighLighterAttributes.Create(SYNS_AttrString);
  fStringAttri.Foreground := clFuchsia;
  AddAttribute(fStringAttri);

  fSymbolRazAttri := TSynHighLighterAttributes.Create(SYNS_AttrSymbolRaz);
  fSymbolRazAttri.Style := [fsBold];
  fSymbolRazAttri.Foreground := clMaroon;
  AddAttribute(fSymbolRazAttri);

  fSymbolSkAttri := TSynHighLighterAttributes.Create(SYNS_AttrSymbolSk);
  fSymbolSkAttri.Style := [fsBold];
  fSymbolSkAttri.Foreground := clGreen;
  AddAttribute(fSymbolSkAttri);

  fSymbolZnAttri := TSynHighLighterAttributes.Create(SYNS_AttrSymbolZn);
  fSymbolZnAttri.Foreground := clRed;
  AddAttribute(fSymbolZnAttri);

  SetAttributesOnChange(DefHighlightChange);
  InitIdent;
  MakeMethodTables;
  fDefaultFilter := SYNS_FilterSample;
  fRange := rsUnknown;
end;

procedure TSynSampleSyn.SetLine(NewValue: String; LineNumber: Integer);
begin
  fLineRef := NewValue;
  fLine := PChar(fLineRef);
  Run := 0;
  fLineNumber := LineNumber;
  Next;
end;

procedure TSynSampleSyn.IdentProc;
begin
  fTokenID := IdentKind((fLine + Run));
  inc(Run, fStringLen);
  while Identifiers[fLine[Run]] do
    Inc(Run);
end;

procedure TSynSampleSyn.NumberProc;
begin
  inc(Run);
  fTokenID := tkNumber;
  while Identifiers[fLine[Run]] do

    inc(Run);

end;

procedure TSynSampleSyn.SymbolRazProc;
begin
  fTokenID  := tkSymbolRaz;
  Inc( Run );
end;

procedure TSynSampleSyn.SymbolSkProc;
begin
  fTokenID  := tkSymbolSk;
  Inc( Run );
end;

procedure TSynSampleSyn.SymbolZnProc;
begin
  fTokenID  := tkSymbolZn;
  Inc( Run );
end;

procedure TSynSampleSyn.UnknownProc;
begin
{$IFDEF SYN_MBCSSUPPORT}
  if FLine[Run] in LeadBytes then
    Inc(Run,2)
  else
{$ENDIF}
  inc(Run);
  fTokenID := tkUnknown;
end;

procedure TSynSampleSyn.Next;
begin
  fTokenPos := Run;
  case fRange of
    rsBraceComment: BraceCommentProc;
  else
    begin
      fRange := rsUnknown;
      fProcTable[fLine[Run]];
    end;
  end;
end;

function TSynSampleSyn.GetDefaultAttribute(Index: integer): TSynHighLighterAttributes;
begin
  case Index of
    SYN_ATTR_COMMENT    : Result := fCommentAttri;
    SYN_ATTR_IDENTIFIER : Result := fIdentifierAttri;
    SYN_ATTR_KEYWORD    : Result := fKeyAttri;
    SYN_ATTR_STRING     : Result := fStringAttri;
    SYN_ATTR_WHITESPACE : Result := fSpaceAttri;
  else
    Result := nil;
  end;
end;

function TSynSampleSyn.GetEol: Boolean;
begin
  Result := fTokenID = tkNull;
end;

function TSynSampleSyn.GetKeyWords: string;
begin
  Result := 
    'cauchy,end,get,given,koef,method,program';
end;

function TSynSampleSyn.GetToken: String;
var
  Len: LongInt;
begin
  Len := Run - fTokenPos;
  SetString(Result, (FLine + fTokenPos), Len);
end;

function TSynSampleSyn.GetTokenID: TtkTokenKind;
begin
  Result := fTokenId;
end;

function TSynSampleSyn.GetTokenAttribute: TSynHighLighterAttributes;
begin
  case GetTokenID of
    tkComment: Result := fCommentAttri;
    tkIdentifier: Result := fIdentifierAttri;
    tkKey: Result := fKeyAttri;
    tkNumber: Result := fNumberAttri;
    tkSpace: Result := fSpaceAttri;
    tkString: Result := fStringAttri;
    tkSymbolRaz: Result := fSymbolRazAttri;
    tkSymbolSk: Result := fSymbolSkAttri;
    tkSymbolZn: Result := fSymbolZnAttri;
    tkUnknown: Result := fIdentifierAttri;
  else
    Result := nil;
  end;
end;

function TSynSampleSyn.GetTokenKind: integer;
begin
  Result := Ord(fTokenId);
end;

function TSynSampleSyn.GetTokenPos: Integer;
begin
  Result := fTokenPos;
end;

function TSynSampleSyn.GetIdentChars: TSynIdentChars;
begin
  Result := ['_', 'a'..'z', 'A'..'Z'];
end;

function TSynSampleSyn.GetSampleSource: string;
begin
  Result := '{ Sample source for the demo highlighter }'#13#10 +
            #13#10 +
            'This highlighter will recognize the words Hello and'#13#10 +
            'World as keywords. It will also highlight "Strings".'#13#10 +
            #13#10 +
            'And a special keyword type: SynEdit'#13#10 +
            #13#10 +
            '/* This style of comments is also highlighted */';
end;

function TSynSampleSyn.IsFilterStored: Boolean;
begin
  Result := fDefaultFilter <> SYNS_FilterSample;
end;

{$IFNDEF SYN_CPPB_1} class {$ENDIF}
function TSynSampleSyn.GetLanguageName: string;
begin
  Result := SYNS_LangSample;
end;

procedure TSynSampleSyn.ResetRange;
begin
  fRange := rsUnknown;
end;

procedure TSynSampleSyn.SetRange(Value: Pointer);
begin
  fRange := TRangeState(Value);
end;

function TSynSampleSyn.GetRange: Pointer;
begin
  Result := Pointer(fRange);
end;

initialization
  MakeIdentTable;
{$IFNDEF SYN_CPPB_1}
  RegisterPlaceableHighlighter(TSynSampleSyn);
{$ENDIF}
end.
