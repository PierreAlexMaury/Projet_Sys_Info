TARGETS=compilateur
YACC=y.tab.c
FLEX=lex.yy.c
OBJECTS=y.tab.o lex.yy.o table_symb.o
LDFLAGS=-ll
DEPENDS=$(patsubst %.o, %.dep, $(OBJECTS))

all: $(TARGETS)

compilateur: $(OBJECTS)
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

clean:
	rm -rf $(OBJECTS) $(DEPENDS) $(YACC) $(FLEX)
			
run: ./$(TARGETS) 
