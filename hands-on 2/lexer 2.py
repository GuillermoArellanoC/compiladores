import ply.lex as lex
# tokens que se van a reconocer
tokens = ['INT', 'RETURN', 'ID', 'NUMBER', 'STRING']
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
# ignorar los espacios
t_ignore = ' \t=;'
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
int x = 5;       // Se declara una variable 'x'
return x;        // Se devuelve su valor
/* Esto es un comentario 
   de varias líneas */
"Hola mundo"    // Se define una cadena de texto
'''
lexer.input(codigo)
# resultados
for token in lexer:
    print(token)
