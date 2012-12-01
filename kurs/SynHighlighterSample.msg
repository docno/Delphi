TSynSampleSyn   {first Identifier is considered to be the Class Name }
tk              {second Identifier is considered to be the Identifier Prefix }
IdentStart '_', 'a'..'z', 'A'..'Z':: '_', '0'..'9', 'a'..'z', 'A'..'Z':: 



TOKENTYPES
Identifier Foreground=clHighlight|Style=[fsItalic]
Comment Style=[fsItalic]|Foreground=clNavy
Space Foreground=clCream
String Foreground=clFuchsia
Key Style=[fsBold]|Foreground=clHotLight
SymbolZn Foreground=clRed
SymbolSk Foreground=clGreen|Style=[fsBold]
SymbolRaz Foreground=clMaroon|Style=[fsBold]
Number Foreground=clBlue

|><|

KEYS
program
given
koef
cauchy
method
get
end
|><|
CHARS

'A'..'Z','a'..'z'::Ident
BeginProc
  fTokenID := IdentKind((fLine + Run));
  inc(Run, fStringLen);
  while Identifiers[fLine[Run]] do
    Inc(Run);
EndProc

'0'..'9':: Number
BeginProc
inc(Run);
  fTokenID := tkNumber;
  while Identifiers[fLine[Run]] do

    inc(Run);

EndProc



'(',')','[',']'::SymbolSk
BeginProc
fTokenID  := tkSymbolSk;
  Inc( Run );
EndProc

'-', '+', '*','^','/','='::SymbolZn
BeginProc
fTokenID  := tkSymbolZn;
  Inc( Run );
EndProc

'>',';',',',':','.'::SymbolRaz
BeginProc
fTokenID  := tkSymbolRaz;
  Inc( Run );
EndProc


|><|



ENCLOSEDBY

Comment,BraceComment,{,},MultiLine
String,String,','
|><|

SAMPLESOURCE
{ Sample source for the demo highlighter }

This highlighter will recognize the words Hello and
World as keywords. It will also highlight "Strings".

And a special keyword type: SynEdit

/* This style of comments is also highlighted */
|><|

