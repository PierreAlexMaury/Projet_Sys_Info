TARGETS=compilateur interpreter
YACC=y.tab.c inst.tab.c
FLEX=lex.yy.c interlex.yy.c
OBJECTS=y.tab.o lex.yy.o table_symb.o table_cond.o
INTER=inst.tab.o interlex.yy.o table_interpreter.o
LDFLAGS=-ll
DEPENDS=$(patsubst %.o, %.dep, $(OBJECTS))

all: $(TARGETS)

compilateur: $(OBJECTS)
	gcc -o $@ $^ $(LDFLAGS)

interpreter: $(INTER)
	gcc -o $@ $^ $(LDFLAGS)

%.o: %.c %.dep
	gcc -c $<

depend: $(DEPENDS)

%.dep: %.c
	gcc -MM $^ -o $@

include $(wildcard *.dep)

y.tab.c: compilateur.y
	yacc -v -d compilateur.y

lex.yy.c: compilateur.lex
	flex compilateur.lex

inst.tab.c: interpreter.y
	yacc -v -d interpreter.y -o inst.tab.c

interlex.yy.c: interpreter.lex
	flex -o interlex.yy.c interpreter.lex 

clean:
	rm -rf $(OBJECTS) $(DEPENDS) $(YACC) $(FLEX) $(INTER)
			
run: ./$(TARGETS) 
