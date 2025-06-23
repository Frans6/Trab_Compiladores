# indent_preproc.py (VERSÃO FINAL E CORRETA)
import sys

def process_file(filepath):
    try:
        with open(filepath, 'r', encoding='utf-8-sig') as f:
            lines = f.readlines()
    except FileNotFoundError:
        print(f"Erro: Arquivo '{filepath}' nao encontrado.", file=sys.stderr)
        sys.exit(1)

    indent_stack = [0]
    
    for line in lines:
        stripped_line = line.lstrip()
        
        if not stripped_line.strip():
            print() # Imprime a linha em branco
            continue

        if stripped_line.startswith('#'):
            print(line.rstrip()) #imprime a linha de comentário sem quebra extra
            continue
            
        leading_spaces = len(line) - len(stripped_line)
        
        if leading_spaces > indent_stack[-1]:
            indent_stack.append(leading_spaces)
            print('@INDENT@') # Imprime em sua própria linha
        
        while leading_spaces < indent_stack[-1]:
            indent_stack.pop()
            print('@DEDENT@') # Imprime em sua própria linha

        if leading_spaces != indent_stack[-1]:
            print(f"Erro de indentacao na linha: {line.strip()}", file=sys.stderr)
            sys.exit(1)

        print(stripped_line.rstrip()) # Remove quebra de linha extra

    while len(indent_stack) > 1:
        indent_stack.pop()
        print('@DEDENT@')

    # Garante que o arquivo termina com uma linha em branco
    print()

if __name__ == "__main__":
    if len(sys.argv) < 2:
        print("Uso: python3 indent_preproc.py <arquivo>", file=sys.stderr)
        sys.exit(1)
    
    process_file(sys.argv[1])