test: mini_js entrada.txt
	./mini_js < entrada.txt

build:
	yacc mini_js.y
	lex mini_js.l
	g++ y.tab.c -o mini_js -ll	

clear: 
	rm -f lex.yy.c y.tab.c mini_js