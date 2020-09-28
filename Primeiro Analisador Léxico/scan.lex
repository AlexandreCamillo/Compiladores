%{
#include <string>

using namespace std;


%}


WS	[ \t\n]*

DIGITO [0-9]
LETRA [a-zA-Z_$]
SINAL ("+"|"-")

INT {DIGITO}*
FLOAT {INT}("."{INT})?([Ee]("+"|"-")?{INT})?

FOR [Ff][Oo][Rr]
IF [Ii][Ff]

 
/* O operador . significa a mesma coisa que LINHA */
LINHA [^\n]* 

ID {LETRA}+({LETRA}|{DIGITO})*

%%
    /* Padrões e ações. Nesta seção, comentários devem ter um tab antes */
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

.       { return *yytext; 
          /* Essa deve ser a última regra. Dessa forma qualquer caractere isolado será retornado pelo seu código ascii. */ }

%%


/* Não coloque nada aqui - a função main é automaticamente incluída na hora de avaliar e dar a nota. */
