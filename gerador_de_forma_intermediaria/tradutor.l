%{
#include <stdlib.h>
#include <stdio.h>
#include <iostream>
#include <map>

using namespace std;  
  
int token;
string lexema;
int linha = 1, coluna_atual = 1, coluna_anterior = 0;

void VS();
void A();
void E();
void E_linha();
void T();
void T_linha();
void F();
void FUNC();
void V();
void casa( int );

enum { tk_num = 256, tk_id, 
       tk_cte_int, tk_string, tk_func };

map<int,string> nome_tokens = {
  { tk_num, "número" },
  { tk_id, "nome de identificador" },
  { tk_cte_int, "constante inteira" },
  { tk_string, "string" },
  { tk_func, "função"}
};

int tk( int token );

%}

DIGITO	[0-9]
LETRA	[A-Za-z_]

INT	{DIGITO}+
NUM {INT}("."{INT})?([Ee]("+"|"-")?{INT})?
ID	{LETRA}({LETRA}|{DIGITO})*

FUNC (max|print|mdc|dtos)

S_START	(\")
S_SIMPLE	(\\.)
S_COMPLEX   	([^"\\]|(\"\"))
S_END		(\")

%x S

%%

" "  		{ coluna_anterior = coluna_atual++; }
"\t"		{ coluna_anterior = coluna_atual; 
                  coluna_atual += 2; }
"\n"            { linha++; 
                  coluna_anterior = coluna_atual;
                  coluna_atual = 1;}

{NUM} 		{ return tk( tk_num ); }

{S_START}	{ BEGIN(S); yymore(); }
<S>{S_SIMPLE}	{ yymore(); }
<S>{S_COMPLEX}	{ yymore(); }
<S>{S_END}  	{ BEGIN(0); return tk( tk_string ); }

{FUNC} { return tk( tk_func ); }

{ID}		{ return tk( tk_id ); }

.		{ return tk( yytext[0] ); }

%%

int tk( int token ) {
  coluna_anterior = coluna_atual;
  coluna_atual += strlen( yytext );
  lexema = yytext;
  return token;
}

int next_token() {
  return yylex();
}

void erro( string msg ) {
  cout << "*** Erro: ***" << endl
       << "Linha: " << linha << ", coluna: " << coluna_anterior << endl
       << msg << endl;
  exit( 1 );
}

string nome_token( int token ) {
  if( nome_tokens.find( token ) != nome_tokens.end() )
    return nome_tokens[token];
  else {
    string r;
    r = (char) token;
    
    return "'" + r + "'";
  }
}

void A() {
// Guardamos o lexema pois a função 'casa' altera o seu valor.
  string temp = lexema; 
  switch( token ) {
    case tk_id : {
      casa( tk_id ); cout << temp; casa( '=' ); E(); cout <<  " =" ; } 
      break;
    case tk_func : {
      FUNC(); }
      break;
  }
}

void E() {
  T();
  E_linha();
}

void E_linha() {
  switch( token ) {
    case '+' : casa( '+' ); T(); cout <<  " +"; E_linha(); break;
    case '-' : casa( '-' ); T(); cout <<  " -"; E_linha(); break;
  }
}

void T() {
  F();
  T_linha();
}

void T_linha() {
  switch( token ) {
    case '*' : casa( '*' ); F(); cout <<  " *"; T_linha(); break;
    case '/' : casa( '/' ); F(); cout <<  " /"; T_linha(); break;
  }
}

void P() {
  E();
  switch( token ) {
    case ',' : casa( ',' ); P(); break;
  }
}

void F() {
  switch( token ) {
    case tk_id : {
      string temp = lexema;
      casa( tk_id ); cout << " " << temp << " @" ; } 
      break;
    case tk_num : {
      string temp = lexema;
      casa( tk_num ); cout << " " << temp ; }
      break;
    case tk_string :{
      string temp = lexema;
      casa( tk_string ); cout << " " << temp ; }
      break;
    case tk_func :{
      FUNC();}
      break;
    case '(': 
      casa( '(' ); E(); casa ( ')' ); break;

  }
}

void FUNC() {
  string temp = lexema;
  casa( tk_func );
  int aux = 0;
  if(token == '('){
    aux = 1;
    casa('(');
  }
  P();
  if (aux == 1) casa( ')' );

  cout << " " << temp << " #";
}

void V() {
  A();  
  T(); 
  casa( ';' );
  cout << " ";
}

void VS() {
  if (token == tk_id || token == tk_func) {
    V();
    VS();
  }
}

void casa( int esperado ) {
  if( token == esperado )
    token = next_token();
  else
    erro( "Esperado " + nome_token( esperado ) +
	  ", encontrado: " + nome_token( token ) );
}

auto f = &yyunput;

int main() {
  token = next_token();
  lexema = yytext;
  VS();

  return 0;
}
