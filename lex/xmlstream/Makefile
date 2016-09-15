
all: xmlstream

xmlstream: lex.yy.c
	gcc -o xmlstream lex.yy.c -lfl

lex.yy.c: xmlstream.l
	flex xmlstream.l

