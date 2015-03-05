TARGETS=compilateur
YACC=y.tab.c
FLEX=lex.yy.c
YACC=compilateur.y
OBJECTS=y.tab.o lex.yy.o
LDFLAGS=-ll
DEPENDS=$(patsubst %.o, %.dep, $(OBJECTS))

all: $(TARGETS)

compilateur: $(OBJECTS)
	gcc $(LDFLAGS) -o $@ $^

%.o: %.c %.dep
	gcc -c $<

depend: $(DEPENDS)

%.dep: %.c
	gcc -MM $^ -o $@

include $(wildcard *.dep)

y.tab.c: compilateur.y
	yacc -d compilateur.y

lex.yy.c: compilateur.lex
	flex compilateur.lex

clean:
	rm -rf $(OBJECTS) $(DEPENDS)
			
run: ./compilateur
