CC = gcc
FLEX = flex
BISON = bison

CFLAGS = -I. -Iparser

# Arquivos
LEXER_SRC = lexer/lexer.l
PARSER_SRC = parser/parser.y
MAIN_SRC = main.c

# Arquivos gerados
LEXER_C = build/lexer.c
PARSER_C = parser/parser.tab.c
PARSER_H = parser/parser.tab.h

# Objetos
LEXER_O = build/lexer.o
PARSER_O = build/parser.o
MAIN_O = build/main.o

# Executável
TARGET = build/main

all: $(TARGET)

# Gera parser.tab.c e parser.tab.h
$(PARSER_C) $(PARSER_H): $(PARSER_SRC)
	$(BISON) -d -o $(PARSER_C) $(PARSER_SRC)

# Gera lexer.c
$(LEXER_C): $(LEXER_SRC) $(PARSER_H)
	$(FLEX) -o $(LEXER_C) $(LEXER_SRC)

# Compila lexer
$(LEXER_O): $(LEXER_C)
	$(CC) $(CFLAGS) -c $(LEXER_C) -o $(LEXER_O)

# Compila parser
$(PARSER_O): $(PARSER_C)
	$(CC) $(CFLAGS) -c $(PARSER_C) -o $(PARSER_O)

# Compila main
$(MAIN_O): $(MAIN_SRC)
	$(CC) $(CFLAGS) -c $(MAIN_SRC) -o $(MAIN_O)

# Linka tudo
$(TARGET): $(LEXER_O) $(PARSER_O) $(MAIN_O)
	$(CC) $(LEXER_O) $(PARSER_O) $(MAIN_O) -o $(TARGET)

clean:
	rm -f build/* parser/parser.tab.*

run: all
	./$(TARGET)
