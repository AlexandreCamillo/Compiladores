%{
#include <string>

using namespace std;


%}


WS	[ \t\n]*

DIGITO	[0-9]
LETRA	[a-zA-Z_$]
SINAL	("+"|"-")

INT	{DIGITO}*
FLOAT	{INT}("."{INT})?([Ee]("+"|"-")?{INT})?

FOR	[Ff][Oo][Rr]
IF	[Ii][Ff]


C_START	"/"+"*"
C_SIMPLE	[^*]
C_COMPLEX   	"*"+[^/]
C_END		"*"+"/"
ML_COMMENT {START}[{SIMPLE}{COMPLEX}]*{END}
SL_COMMENT \/\/(.*)

S_START	(\")
S_SIMPLE	(\\.)
S_COMPLEX   	([^"\\]|(\"\"))
S_END		(\")

ID	{LETRA}+({LETRA}|{DIGITO})*

%x C
%x S
%%

{WS}	{ /* ignora espaços, tabs e '\n' */ } 
    
{INT} { return _INT; }
{FLOAT} { return _FLOAT; }

{FOR} { return _FOR; }
{IF} { return _IF; }


"+" { return '+'; }
"-" { return '-'; }
"*" { return '*'; }
"/" { return '/'; }
"<" { return '<'; }
">" { return '>'; }
"<=" { return _MEIG; }
">=" { return _MAIG; }
"==" { return _IG; }
"!=" { return _DIF; }



{ID} { return _ID; }

{S_START}	{ BEGIN(S); yymore(); }
<S>{S_SIMPLE}	{ yymore(); }
<S>{S_COMPLEX}	{ yymore(); }
<S>{S_END}  	{ BEGIN(0); return _STRING; }

{C_START}	{ BEGIN(C); yymore(); }
<C>{C_SIMPLE}	{ yymore(); }
<C>{C_COMPLEX}	{ yymore(); }
<C>{C_END}  	{ BEGIN(0); return _COMENTARIO; }

{SL_COMMENT}	{return _COMENTARIO;}

.       { return *yytext; 
          /* Essa deve ser a última regra. Dessa forma qualquer caractere isolado será retornado pelo seu código ascii. */ }

%%


/* Não coloque nada aqui - a função main é automaticamente incluída na hora de avaliar e dar a nota. */
