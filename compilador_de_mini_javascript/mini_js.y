%{
#include <string>
#include <iostream>
#include <map>
#include <vector>

using namespace std;

struct Atributos {
  vector<string> v;
};

#define YYSTYPE Atributos

vector<string> comandos;
map<string,int> vars;

void define_var( string var );
void checa_declarado( string var );

vector<string> concatena( vector<string> a, vector<string> b );
vector<string> operator+( vector<string> a, vector<string> b );
vector<string> operator+( vector<string> a, string b );

string gera_label( string prefixo );
vector<string> resolve_enderecos( vector<string> entrada );


int yylex();
void yyerror( const char* );
void erro( string msg );
int retorna( int tk );

void imprime (vector<string> codigo);

int linha = 1, coluna_atual = 1, coluna_anterior = 0;

vector<string> novo;

%}

%token NUM STR ID LET IF ELSE EQ GT LT NE

%left '+' '-'
%left '*' '/'

%start S

%%
S : STMs {  imprime(resolve_enderecos($1.v)); }
  ;

STMs : STM ';' STMs { $$.v = $1.v + $3.v; }
     | STM STMs     { $$.v = $1.v + $2.v; }
     |              { $$.v = novo; }
     ;

STM : A ';'{ $$.v = $1.v + "^"; }
    | LET DECLVARs ';'{ $$ = $2; }
    | SEC_STM
    | COMP_STM
    | EXP_STM
    ;

COMP_STM  : '{' '}'
          | '{' STMs '}' { $$.v = $2.v; }
          ;

SEC_STM : IF '(' R ')' STM { 
            string end_if =  gera_label("end_if");
            $$.v = $3.v + "!" + end_if + "?" + $5.v + (":" + end_if);
          }
        | IF '(' R ')' STM ELSE STM { 
            string then =  gera_label("then");
            string end_if =  gera_label("end_if");
            $$.v = $3.v + then + "?" + $7.v + end_if + "#" + (":" + then) + $5.v + (":" + end_if);
          }
        ;

EXP_STM : ';'
        | R ';'
        ;

DECLVARs : DECLVAR ',' DECLVARs { $$.v = $1.v + $3.v; }
         | DECLVAR
         ;

DECLVAR : ID '=' R { $$.v = $1.v + "&" + $1.v + $3.v + "=" + "^"; }
        | ID       { $$.v = $1.v + "&";}
        ;

A : ID '=' A { $$.v = $1.v + $3.v + "="; }
  | R
  ;

R : E '<' E { $$.v = $1.v + $3.v + "<"; }
  | E '>' E { $$.v = $1.v + $3.v + ">"; }
  | E EQ E { $$.v = $1.v + $3.v + "=="; }
  | E NE E { $$.v = $1.v + $3.v + "!="; }
  | E GT E { $$.v = $1.v + $3.v + ">="; }
  | E LT E { $$.v = $1.v + $3.v + "<="; }
  | E
  ;
  
E : E '+' T { $$.v = $1.v + $3.v + "+"; }
  | E '-' T { $$.v = $1.v + $3.v + "-"; }
  | T

T : T '*' F { $$.v = $1.v + $3.v + "*"; }
  | T '/' F { $$.v = $1.v + $3.v + "/"; }
  | F
  ;
  
F : ID  { $$.v = $1.v + "@"; }
  | NUM { $$.v = $1.v; }
  | STR { $$.v = $1.v; }
  | '(' E ')' { $$ = $2; }
  | '{' '}' { $$.v = novo + "{}"; }
  | '[' ']' { $$.v = novo + "[]"; }
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

vector<string> concatena( vector<string> a, vector<string> b ) {
  a.insert( a.end(), b.begin(), b.end() );
  return a;
}

vector<string> operator+( vector<string> a, vector<string> b ) {
  return concatena( a, b );
}

vector<string> operator+( vector<string> a, string b ) {
  a.push_back( b );
  return a;
}

void imprime (vector<string> codigo){
  for(auto i = 0; i < codigo.size(); i++) 
    cout << codigo[i] << endl; 
  cout << endl << ".";
}

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
  yylval.v = novo + yytext; 
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