testAll: mini_js
	./mini_js < testes/teste1/input.txt | ./interpretador | testes/checktest.sh teste1
	./mini_js < testes/teste2/input.txt | ./interpretador | testes/checktest.sh teste2
	./mini_js < testes/teste3/input.txt | ./interpretador | testes/checktest.sh teste3
	./mini_js < testes/teste4/input.txt | ./interpretador | testes/checktest.sh teste4
	./mini_js < testes/teste5/input.txt | ./interpretador | testes/checktest.sh teste5
	./mini_js < testes/teste6/input.txt | ./interpretador | testes/checktest.sh teste6
	./mini_js < testes/teste7/input.txt | ./interpretador | testes/checktest.sh teste7
	./mini_js < testes/teste8/input.txt | ./interpretador | testes/checktest.sh teste8
	./mini_js < testes/teste9/input.txt | ./interpretador | testes/checktest.sh teste9
	./mini_js < testes/teste10/input.txt | ./interpretador | testes/checktest.sh teste10

test2All: mini_js test1 test2 test3 test4 test5 test6 test7 test8 test9 test10

test1: mini_js
	./mini_js < testes2/teste1/input.txt | ./interpretador | testes2/checktest.sh teste1
test2: mini_js
	./mini_js < testes2/teste2/input.txt | ./interpretador | testes2/checktest.sh teste2
test3: mini_js
	./mini_js < testes2/teste3/input.txt | ./interpretador | testes2/checktest.sh teste3
test4: mini_js
	./mini_js < testes2/teste4/input.txt | ./interpretador | testes2/checktest.sh teste4
test5: mini_js
	./mini_js < testes2/teste5/input.txt | ./interpretador | testes2/checktest.sh teste5
test6: mini_js
	./mini_js < testes2/teste6/input.txt | ./interpretador | testes2/checktest.sh teste6
test7: mini_js
	./mini_js < testes2/teste7/input.txt | ./interpretador | testes2/checktest.sh teste7
test8: mini_js
	./mini_js < testes2/teste8/input.txt | ./interpretador | testes2/checktest.sh teste8
test9: mini_js
	./mini_js < testes2/teste9/input.txt | ./interpretador | testes2/checktest.sh teste9
test10: mini_js
	./mini_js < testes2/teste10/input.txt | ./interpretador | testes2/checktest.sh teste10

build:
	yacc mini_js.y
	lex mini_js.l
	g++ y.tab.c -o mini_js -ll	

clear: 
	rm -f lex.yy.c y.tab.c mini_js