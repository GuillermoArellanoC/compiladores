import ply.lex as lex

# tokens que se van a reconocer
tokens = ['INT', 'RETURN', 'ID', 'NUMBER']

# palabras clabes
palabras_reservadas = {'int': 'INT', 'return': 'RETURN'}

# expresiones para los tokens
def t_ID(t):
    r'[a-zA-Z_][a-zA-Z0-9_]*'
    if t.value in palabras_reservadas:
        t.type = palabras_reservadas[t.value]  
    return t

def t_NUMBER(t):
    r'\d+'
    return t

# ignorar los espacios
t_ignore = ' \t=;'

# lineas nuevas
def t_newline(t):
    r'\n+'
    t.lexer.lineno += len(t.value)

# manejo de errores
def t_error(t):
    print(f"Error: Caracter inesperado '{t.value[0]}' en la línea {t.lexer.lineno}")
    t.lexer.skip(1)

# analizador lexico
lexer = lex.lex()

# pruebas
codigo = "int x = 5; return x;"
lexer.input(codigo)

# resultados
for token in lexer:
    print(token)

