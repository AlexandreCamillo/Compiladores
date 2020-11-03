%{
#include <string>
#include <iostream>
#include <map>
#include <vector>

using namespace std;

struct Atributos {
  string v;
};

vector<string> comandos;
map<string,int> vars;

void define_var( string var );
void checa_declarado( string var );

string gera_label( string prefixo );
vector<string> resolve_enderecos( vector<string> entrada );

#define YYSTYPE Atributos

void erro( string msg );
// void Print( string st );

// protótipo para o analisador léxico (gerado pelo lex)
int yylex();
void yyerror( const char* );
int retorna( int tk );

int linha = 1, coluna_atual = 1, coluna_anterior = 0;

%}

%token NUM STR ID LET IF ELSE
    
%left '+' '-'
%left '*' '/'

%start S

%%
S : STMs { for(auto i = 0; i < comandos.size(); i++) cout << comandos[i] << endl; cout << endl << "."; }
  ;

STMs : STM ';' STMs { $$.v = $1.v + "\n" + $3.v; }
     |              { $$.v = ""; }
     ;

STM : A { comandos.push_back($$.v + " ^"); }
    | LET DECLVARs { $$ = $2; comandos.push_back($$.v);}
    ;

DECLVARs : DECLVAR ',' DECLVARs { $$.v = $1.v + " " + $3.v; }
         | DECLVAR
         ;

DECLVAR : ID '=' E { define_var( $1.v ); $$.v = $1.v + " & " + $1.v + " " + $3.v + " = ^"; }
        | ID       { define_var( $1.v ); $$.v = $1.v + " &";}
        ;

A : ID '=' A { checa_declarado($1.v); $$.v = $1.v + " " + $3.v + " ="; }
  | E
  ;

// IF_ELSE : IF '(' COND ')' STM {}
//      | IF '(' COND ')' '{' STMs '}' {}

// COND : 
  
E : E '+' T { $$.v = $1.v + " " + $3.v + " +"; }
  | E '-' T { $$.v = $1.v + " " + $3.v + " -"; }
  | T

T : T '*' F { $$.v = $1.v + " " + $3.v + " *"; }
  | T '/' F { $$.v = $1.v + " " + $3.v + " /"; }
  | F
  ;
  
F : ID  { $$.v = $1.v + " @"; }
  | NUM { $$.v = $1.v; }
  | STR { $$.v = $1.v; }
  | '(' E ')' { $$ = $2; }
  | '{' '}' { $$.v = "{}"; }
  | '[' ']' { $$.v = "[]"; }
  // | ID '(' PARAM ')' { $$.v = $1.v + " #"; }
  ;
  
// PARAM : ARGs
//       |
//       ;
  
// ARGs : E ',' ARGs
//      | E
//      ;
  
%%

#include "lex.yy.c"

// map<int,string> nome_tokens = {
//   { STR, "string" },
//   { ID, "nome de identificador" },
//   { NUM, "número" }
// };
// string nome_token( int token ) {
//   if( nome_tokens.find( token ) != nome_tokens.end() )
//     return nome_tokens[token];
//   else {
//     string r;
    
//     r = token;
//     return r;
//   }
// }

void define_var( string var ) {
  if (vars.find( var ) != vars.end()){
    int var_ln = vars.find( var )->second;
    string msg = "a variável '" + var + "' já foi declarada na linha " + to_string(var_ln);
    erro(msg);
  }
  vars[var] = linha;
}
void checa_declarado( string var ) {
  if (vars.find( var ) == vars.end()){
    string msg = "a variável '" + var + "' não foi declarada ";
    erro(msg);
  }
  vars[var] = linha;
}

string gera_label( string prefixo ) {
  static int n = 0;
  return prefixo + "_" + to_string( ++n ) + ":";
}

vector<string> resolve_enderecos( vector<string> entrada ) {
  map<string,int> label;
  vector<string> saida;
  for( int i = 0; i < entrada.size(); i++ ) 
    if( entrada[i][0] == ':' ) 
        label[entrada[i].substr(1)] = saida.size();
    else
      saida.push_back( entrada[i] );
  
  for( int i = 0; i < saida.size(); i++ ) 
    if( label.count( saida[i] ) > 0 )
        saida[i] = to_string(label[saida[i]]);
    
  return saida;
}

int retorna( int tk ) {  
  yylval.v = yytext; 
  coluna_atual += strlen( yytext ); 

  return tk;
}

void yyerror( const char* msg )  {
  erro(msg);
}

void erro( string msg ) {
  cout << "Erro: " << msg << " Próximo a: " << yytext << endl << 
      "Linha: " << linha << ", coluna: " << coluna_anterior << endl;
  exit( 1 );
}


int main() {
  yyparse();
   
  return 0;
}