main:
	bison -d parser.y  
	flex lexer.l
	gcc lex.yy.c parser.tab.c 		  
	rm lex.yy.c parser.tab.c
	./a.out <full_example.c> output.txt
	
main2:
	gcc main.c
	./a.out