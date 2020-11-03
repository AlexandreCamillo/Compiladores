DIGITO  [0-9]
LETRA   [A-Za-z_]
DOUBLE  {DIGITO}+("."{DIGITO}+)?
ID      {LETRA}({LETRA}|{DIGITO})*
STR 	(\"([^\"\n]|(\\\")|\"\")+\")|(\'([^\'\n]|(\\\')|\'\')+\')

%%

" "  		{ coluna_anterior = coluna_atual++; }
"\t"		{ coluna_anterior = coluna_atual; 
                  coluna_atual += 2; }
"\n"            { linha++; 
                  coluna_anterior = coluna_atual;
                  coluna_atual = 1;}

{DOUBLE}   { return retorna( NUM ); }
{STR}	   { return retorna( STR ); }

"let"	   { return retorna( LET ); }
"if"	   { return retorna( IF ); }
"else"	   { return retorna( ELSE ); }
"=="	   { return retorna( EQ ); }
"!="	   { return retorna( NE ); }
"<="	   { return retorna( GT ); }
">="	   { return retorna( LT ); }

 /* "print"    { return retorna( PRINT ); } */

{ID}       { return retorna( ID ); }

.          { return retorna( *yytext ); }

%% 