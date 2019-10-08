translator : translator.l translator.y
	flex translator.l
	bison -d translator.y
	gcc -o $@ translator.tab.c lex.yy.c -ll