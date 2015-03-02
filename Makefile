TARGETS=compilateur
FLEX=lex.yy.c
YACC=y.tab.c
YACC=compilateur.y
OBJECTS=lex.yy.o y.tab.o
LDFLAGS=-ll
DEPENDS=$(patsubst %.o, %.dep, $(OBJECTS))

%.dep: %.c
gcc -MM $^ -o $@

lex.yy.c: compilateur.lex
	flex compilateur.lex
	
y.tab.c: compilateur.y
	yacc -v compilateur.y
	
compilateur: $(OBJECTS)
	gcc $(LDFLAGS) -o $@ $^
	
%.o: %.c %.dep
	gcc -c $<

include $(wildcard *.dep)

run:
./compilateur
