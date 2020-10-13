build: tradutor.l
	flex tradutor.l
	g++ -Wall -std=c++17 lex.yy.c -o tradutor -ll
	
clean:
	rm lex.yy.c tradutor