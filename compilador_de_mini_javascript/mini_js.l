DIGITO  [0-9]
LETRA   [A-Za-z_]
DOUBLE  {DIGITO}+("."{DIGITO}+)?
ID      {LETRA}({LETRA}|{DIGITO})*
STR 	(\"([^\"\n]|(\\\")|\"\")+\")|(\'([^\'\n]|(\\\')|\'\')+\')

%%

" "  		     {  coluna_anterior = coluna_atual++; 
}
"\t"		     {  coluna_anterior = coluna_atual; 
                coluna_atual += 2; 
}
"\n"         {  linha++; 
                coluna_anterior = coluna_atual;
                coluna_atual = 1;
}

{DOUBLE}     { return retorna( NUM ); }
{STR}	       { return retorna( STR ); }

"let"	       { return retorna( LET ); }
"function"	 { return retorna( FUNC ); }
"return"	   { return retorna( RETURN ); }
"asm{".*"}"  { 
  string aux = convertToString(yytext, strlen(yytext));
  yylval.v = novo + aux.substr(4, strlen(yytext) - 5); 
  
  coluna_atual += strlen( yytext ); 
  return ASM; 
}

"if"	       { return retorna( IF ); }
"else"	     { return retorna( ELSE ); }
"while"	     { return retorna( WHILE ); }
"for"	       { return retorna( FOR ); }
"=="	       { return retorna( EQ ); }
"- "	       { return retorna( MN ); }
"!="	       { return retorna( NE ); }
"<="	       { return retorna( GTE ); }
">="	       { return retorna( LTE ); }
"<"	         { return retorna( GT ); }
">"	         { return retorna( LT ); }

 /* "print"    { return retorna( PRINT ); } */

{ID}         { return retorna( ID ); }

.            { return retorna( *yytext ); }

%% 