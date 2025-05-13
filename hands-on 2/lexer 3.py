import ply.lex as lex
# tokens que se van a reconocer
tokens = ['INT', 'RETURN', 'ID', 'NUMBER', 'STRING', 'OP', 'DELIM']
# palabras clave
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
def t_STRING(t):
    r'"([^\\"]|\\.)*"'
    return t
# operadores
t_OP = r'[=+\-*/]'
# delimitadores
t_DELIM = r'[;,\(\)\{\}]'
# ignorar espacios y tabulaciones
t_ignore = ' \t'
# ignorar comentarios de una línea
def t_COMMENT_SINGLE(t):
    r'//.*'
    pass
# ignorar comentarios de varias líneas
def t_COMMENT_MULTI(t):
    r'/\*[\s\S]*?\*/'
    pass
# lineas nuevas
def t_newline(t):
    r'\n+'
    t.lexer.lineno += len(t.value)
# manejo de errores
def t_error(t):
    print(f"Error: Caracter inesperado '{t.value[0]}' en la línea {t.lexer.lineno}")
    t.lexer.skip(1)
# analizador léxico
lexer = lex.lex()
# pruebas
codigo = '''
int x = 10;  // Variable entera
return x + 5; // Operación de suma
"Cadena de prueba"
'''
lexer.input(codigo)
# contar tokens
conteo = {t: 0 for t in tokens}
for token in lexer:
    conteo[token.type] += 1
print(conteo)
