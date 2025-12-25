-- Migration: Update Python course lessons with full content
-- Description: Adds complete markdown content with interactive exercises to each lesson

-- Lesson 1: Variables y Tipos de Datos
UPDATE lessons
SET content = $CONTENT$# Variables y Tipos de Datos

Bienvenido a tu primera leccion de Python! Aqui aprenderas los conceptos fundamentales que necesitas para empezar a programar.

## Que es Python?

Python es un lenguaje de programacion creado en 1991 por Guido van Rossum. Es conocido por su sintaxis clara y legible, lo que lo hace perfecto para principiantes.

## Tu primer programa

Todo programador comienza con el clasico "Hola Mundo". En Python, mostrar texto en pantalla es muy sencillo usando la funcion `print()`:

```python
print("Hola, Mundo!")
```

### Ejercicio 1: Tu primer print

Vamos a practicar! Escribe tu primer programa:

<!-- exercise:ex-01-hola-mundo -->

## Variables

Una **variable** es como una caja donde guardamos informacion. Le damos un nombre y le asignamos un valor:

```python
nombre = "Maria"
edad = 25
```

### Reglas para nombrar variables

- Deben empezar con una letra o guion bajo (`_`)
- Solo pueden contener letras, numeros y guiones bajos
- No pueden ser palabras reservadas de Python (`if`, `for`, `while`, etc.)
- Son sensibles a mayusculas (`nombre` y `Nombre` son diferentes)

**Buenos nombres:**
```python
mi_variable = 10
usuario1 = "Ana"
_privado = "secreto"
```

**Nombres invalidos:**
```python
1variable = 10    # No puede empezar con numero
mi-variable = 10  # No puede tener guion medio
for = 10          # 'for' es palabra reservada
```

### Ejercicio 2: Crea tus variables

Practica creando variables con diferentes valores:

<!-- exercise:ex-02-variables-basicas -->

## Tipos de datos

Python tiene varios tipos de datos basicos:

| Tipo | Nombre | Ejemplo | Descripcion |
|------|--------|---------|-------------|
| `str` | String | `"Hola"` | Texto entre comillas |
| `int` | Integer | `42` | Numero entero |
| `float` | Float | `3.14` | Numero decimal |
| `bool` | Boolean | `True` | Verdadero o Falso |

### Strings (texto)

Los strings son secuencias de caracteres entre comillas simples o dobles:

```python
mensaje = "Hola, Python!"
otro = 'Tambien funciona con comillas simples'
```

### Numeros

Python distingue entre enteros y decimales:

```python
entero = 42        # int
decimal = 3.14159  # float
negativo = -10     # int negativo
```

### Booleanos

Solo pueden ser `True` o `False` (con mayuscula inicial):

```python
es_mayor = True
tiene_cuenta = False
```

### Funcion type()

Puedes verificar el tipo de una variable con `type()`:

```python
x = 10
print(type(x))  # <class 'int'>

y = "hola"
print(type(y))  # <class 'str'>
```

### Ejercicio 3: Tipos de datos

Ahora practica identificando y creando diferentes tipos:

<!-- exercise:ex-03-tipos-datos -->

## Resumen

En esta leccion aprendiste:

- Como usar `print()` para mostrar mensajes
- Que son las variables y como nombrarlas
- Los tipos de datos basicos: `str`, `int`, `float`, `bool`
- Como verificar el tipo con `type()`

En la siguiente leccion aprenderemos a hacer operaciones con estos datos!
$CONTENT$
WHERE id = '11111111-1111-1111-1111-111111111111';

-- Lesson 2: Operadores y Expresiones
UPDATE lessons
SET content = $CONTENT$# Operadores y Expresiones

Ahora que conoces las variables, aprenderemos a hacer operaciones con ellas.

## Operadores Aritmeticos

Python puede funcionar como una calculadora poderosa:

| Operador | Nombre | Ejemplo | Resultado |
|----------|--------|---------|-----------|
| `+` | Suma | `5 + 3` | `8` |
| `-` | Resta | `10 - 4` | `6` |
| `*` | Multiplicacion | `6 * 7` | `42` |
| `/` | Division | `15 / 4` | `3.75` |
| `//` | Division entera | `15 // 4` | `3` |
| `%` | Modulo (resto) | `15 % 4` | `3` |
| `**` | Potencia | `2 ** 3` | `8` |

### Ejemplos practicos

```python
# Operaciones basicas
suma = 10 + 5      # 15
resta = 20 - 8     # 12
producto = 4 * 7   # 28
cociente = 15 / 4  # 3.75

# Division entera (descarta decimales)
division_entera = 15 // 4  # 3

# Modulo (el resto de la division)
resto = 15 % 4  # 3 (porque 15 = 4*3 + 3)

# Potencia
cuadrado = 5 ** 2  # 25
cubo = 2 ** 3      # 8
```

### Ejercicio 4: Calculadora basica

Practica realizando operaciones aritmeticas:

<!-- exercise:ex-04-aritmetica -->

## Operadores de Comparacion

Estos operadores comparan valores y devuelven `True` o `False`:

| Operador | Significado | Ejemplo | Resultado |
|----------|-------------|---------|-----------|
| `==` | Igual a | `5 == 5` | `True` |
| `!=` | Diferente de | `5 != 3` | `True` |
| `>` | Mayor que | `7 > 3` | `True` |
| `<` | Menor que | `2 < 5` | `True` |
| `>=` | Mayor o igual | `5 >= 5` | `True` |
| `<=` | Menor o igual | `3 <= 4` | `True` |

### Ejemplos

```python
x = 10
y = 5

print(x == y)   # False (10 no es igual a 5)
print(x != y)   # True (10 es diferente de 5)
print(x > y)    # True (10 es mayor que 5)
print(x < y)    # False (10 no es menor que 5)
print(x >= 10)  # True (10 es mayor o igual a 10)
print(y <= 5)   # True (5 es menor o igual a 5)
```

> **Importante:** No confundas `=` (asignacion) con `==` (comparacion).
> - `x = 5` asigna el valor 5 a x
> - `x == 5` pregunta si x es igual a 5

### Ejercicio 5: Comparaciones

Practica usando operadores de comparacion:

<!-- exercise:ex-05-comparaciones -->

## Operadores Logicos

Combinan expresiones booleanas:

| Operador | Descripcion | Ejemplo |
|----------|-------------|---------|
| `and` | Verdadero si ambos son True | `True and False` -> `False` |
| `or` | Verdadero si al menos uno es True | `True or False` -> `True` |
| `not` | Invierte el valor | `not True` -> `False` |

### Ejemplos

```python
edad = 25
tiene_licencia = True

# and: ambas condiciones deben ser verdaderas
puede_conducir = edad >= 18 and tiene_licencia  # True

# or: al menos una condicion debe ser verdadera
es_fin_de_semana = False
es_feriado = True
dia_libre = es_fin_de_semana or es_feriado  # True

# not: invierte el valor
esta_lloviendo = False
buen_clima = not esta_lloviendo  # True
```

## Operadores de Asignacion

Atajos para modificar variables:

| Operador | Equivale a | Ejemplo |
|----------|------------|---------|
| `+=` | `x = x + n` | `x += 5` |
| `-=` | `x = x - n` | `x -= 3` |
| `*=` | `x = x * n` | `x *= 2` |
| `/=` | `x = x / n` | `x /= 4` |

```python
contador = 10

contador += 5   # contador = 15
contador -= 3   # contador = 12
contador *= 2   # contador = 24
contador /= 4   # contador = 6.0
```

## Concatenacion de Strings

El operador `+` tambien une strings:

```python
nombre = "Maria"
apellido = "Garcia"
nombre_completo = nombre + " " + apellido
print(nombre_completo)  # "Maria Garcia"
```

Y `*` repite strings:

```python
risa = "ja" * 3
print(risa)  # "jajaja"
```

## Resumen

Aprendiste:

- Operadores aritmeticos: `+`, `-`, `*`, `/`, `//`, `%`, `**`
- Operadores de comparacion: `==`, `!=`, `>`, `<`, `>=`, `<=`
- Operadores logicos: `and`, `or`, `not`
- Operadores de asignacion: `+=`, `-=`, `*=`, `/=`
- Concatenacion de strings con `+` y `*`

En la siguiente leccion aprenderemos a tomar decisiones con `if` y `else`!
$CONTENT$
WHERE id = '22222222-2222-2222-2222-222222222222';

-- Lesson 3: Estructuras de Control
UPDATE lessons
SET content = $CONTENT$# Estructuras de Control

Hasta ahora, nuestros programas ejecutan instrucciones de arriba hacia abajo. Pero a veces necesitamos que el programa tome decisiones. Para eso usamos las estructuras de control.

## La sentencia if

`if` ejecuta un bloque de codigo solo si una condicion es verdadera:

```python
edad = 18

if edad >= 18:
    print("Eres mayor de edad")
```

### La indentacion es importante!

En Python, la indentacion (espacios al inicio) define que codigo pertenece al `if`:

```python
if condicion:
    # Este codigo se ejecuta si la condicion es True
    print("Dentro del if")
    print("Tambien dentro del if")

print("Esto esta fuera del if, siempre se ejecuta")
```

> **Regla:** Usa 4 espacios para indentar. La mayoria de editores lo hacen automaticamente con Tab.

## if-else

`else` define que hacer cuando la condicion es falsa:

```python
edad = 15

if edad >= 18:
    print("Puedes votar")
else:
    print("Aun no puedes votar")
```

### Ejercicio 6: Tu primer if-else

Practica tomando decisiones en tu codigo:

<!-- exercise:ex-06-if-else -->

## elif (else if)

Cuando tienes multiples condiciones, usa `elif`:

```python
nota = 85

if nota >= 90:
    print("Excelente - A")
elif nota >= 80:
    print("Muy bien - B")
elif nota >= 70:
    print("Bien - C")
elif nota >= 60:
    print("Suficiente - D")
else:
    print("Reprobado - F")
```

### Como funciona

Python evalua las condiciones de arriba hacia abajo:
1. Si la primera es `True`, ejecuta ese bloque y salta el resto
2. Si es `False`, pasa a la siguiente condicion
3. `else` captura todos los casos que no cumplieron ninguna condicion

### Ejercicio 7: Multiples condiciones

Practica usando elif para clasificar valores:

<!-- exercise:ex-07-elif -->

## Condiciones anidadas

Puedes poner un `if` dentro de otro:

```python
tiene_boleto = True
edad = 12

if tiene_boleto:
    if edad < 12:
        print("Entrada infantil")
    else:
        print("Entrada adulto")
else:
    print("Necesitas comprar un boleto")
```

Aunque muchas veces es mejor usar `and`:

```python
if tiene_boleto and edad < 12:
    print("Entrada infantil")
elif tiene_boleto:
    print("Entrada adulto")
else:
    print("Necesitas comprar un boleto")
```

## Operador ternario

Para condiciones simples, puedes usar una sola linea:

```python
edad = 20
mensaje = "Mayor" if edad >= 18 else "Menor"
print(mensaje)  # "Mayor"
```

Es equivalente a:

```python
if edad >= 18:
    mensaje = "Mayor"
else:
    mensaje = "Menor"
```

## Valores Truthy y Falsy

En Python, algunos valores se consideran "falsos" en condiciones:

**Valores Falsy (se evaluan como False):**
- `False`
- `0` y `0.0`
- `""` (string vacio)
- `[]` (lista vacia)
- `None`

**Todo lo demas es Truthy:**

```python
nombre = ""

if nombre:
    print(f"Hola, {nombre}")
else:
    print("No ingresaste un nombre")
```

## Comparando strings

Los strings se comparan alfabeticamente:

```python
"apple" < "banana"  # True (a viene antes que b)
"Ana" < "ana"       # True (mayusculas van antes)
```

Para comparar sin importar mayusculas:

```python
nombre = "Maria"
if nombre.lower() == "maria":
    print("Encontrado!")
```

## Resumen

Aprendiste:

- `if` para ejecutar codigo condicionalmente
- `else` para el caso alternativo
- `elif` para multiples condiciones
- La importancia de la indentacion
- El operador ternario para condiciones simples
- Valores truthy y falsy

En la siguiente leccion aprenderemos sobre listas y bucles!
$CONTENT$
WHERE id = '33333333-3333-3333-3333-333333333333';

-- Lesson 4: Listas y Bucles
UPDATE lessons
SET content = $CONTENT$# Listas y Bucles

Las listas son una de las estructuras de datos mas importantes en Python. Te permiten almacenar multiples valores en una sola variable.

## Creando listas

Una lista se crea con corchetes `[]`:

```python
# Lista de numeros
numeros = [1, 2, 3, 4, 5]

# Lista de strings
frutas = ["manzana", "banana", "naranja"]

# Lista mixta (no recomendado, pero posible)
mixta = [1, "hola", 3.14, True]

# Lista vacia
vacia = []
```

### Ejercicio 8: Crea tu lista

Practica creando listas:

<!-- exercise:ex-08-crear-lista -->

## Accediendo a elementos

Cada elemento tiene un indice, empezando desde 0:

```python
frutas = ["manzana", "banana", "naranja", "pera"]
#            0          1         2         3

print(frutas[0])   # "manzana"
print(frutas[2])   # "naranja"
print(frutas[-1])  # "pera" (ultimo elemento)
print(frutas[-2])  # "naranja" (penultimo)
```

## Modificando listas

Las listas son mutables (se pueden cambiar):

```python
frutas = ["manzana", "banana", "naranja"]

# Cambiar un elemento
frutas[1] = "fresa"
print(frutas)  # ["manzana", "fresa", "naranja"]

# Agregar al final
frutas.append("pera")
print(frutas)  # ["manzana", "fresa", "naranja", "pera"]

# Insertar en posicion especifica
frutas.insert(1, "kiwi")
print(frutas)  # ["manzana", "kiwi", "fresa", "naranja", "pera"]

# Eliminar por valor
frutas.remove("fresa")

# Eliminar por indice
del frutas[0]

# Eliminar y obtener el ultimo
ultimo = frutas.pop()
```

## Longitud de una lista

Usa `len()` para saber cuantos elementos tiene:

```python
numeros = [10, 20, 30, 40, 50]
print(len(numeros))  # 5
```

## El bucle for

`for` recorre cada elemento de una lista:

```python
frutas = ["manzana", "banana", "naranja"]

for fruta in frutas:
    print(f"Me gusta la {fruta}")
```

Salida:
```
Me gusta la manzana
Me gusta la banana
Me gusta la naranja
```

### Ejercicio 9: Bucle for

Practica recorriendo listas con for:

<!-- exercise:ex-09-for-loop -->

## range()

`range()` genera secuencias de numeros:

```python
# range(fin) - desde 0 hasta fin-1
for i in range(5):
    print(i)  # 0, 1, 2, 3, 4

# range(inicio, fin)
for i in range(2, 6):
    print(i)  # 2, 3, 4, 5

# range(inicio, fin, paso)
for i in range(0, 10, 2):
    print(i)  # 0, 2, 4, 6, 8
```

## enumerate()

Si necesitas el indice y el valor:

```python
frutas = ["manzana", "banana", "naranja"]

for indice, fruta in enumerate(frutas):
    print(f"{indice}: {fruta}")
```

Salida:
```
0: manzana
1: banana
2: naranja
```

## El bucle while

`while` repite mientras una condicion sea verdadera:

```python
contador = 0

while contador < 5:
    print(contador)
    contador += 1  # Importante: actualizar la condicion!
```

> **Cuidado:** Si no actualizas la condicion, crearas un bucle infinito!

### Ejercicio 10: Bucle while

Practica usando while:

<!-- exercise:ex-10-while-loop -->

## break y continue

Controla el flujo dentro de bucles:

```python
# break: sale del bucle completamente
for i in range(10):
    if i == 5:
        break
    print(i)  # 0, 1, 2, 3, 4

# continue: salta a la siguiente iteracion
for i in range(5):
    if i == 2:
        continue
    print(i)  # 0, 1, 3, 4
```

## Operaciones comunes con listas

```python
numeros = [3, 1, 4, 1, 5, 9, 2, 6]

# Ordenar
numeros.sort()           # Modifica la lista original
ordenados = sorted(numeros)  # Crea una nueva lista

# Invertir
numeros.reverse()

# Buscar
if 5 in numeros:
    print("5 esta en la lista")

indice = numeros.index(5)  # Posicion del 5

# Contar ocurrencias
cantidad = numeros.count(1)  # Cuantos 1 hay

# Suma, minimo, maximo
total = sum(numeros)
minimo = min(numeros)
maximo = max(numeros)
```

## Slicing (rebanado)

Extrae porciones de una lista:

```python
letras = ['a', 'b', 'c', 'd', 'e']

print(letras[1:4])   # ['b', 'c', 'd']
print(letras[:3])    # ['a', 'b', 'c']
print(letras[2:])    # ['c', 'd', 'e']
print(letras[::2])   # ['a', 'c', 'e'] (cada 2)
print(letras[::-1])  # ['e', 'd', 'c', 'b', 'a'] (invertida)
```

## Resumen

Aprendiste:

- Crear y acceder a listas con `[]`
- Modificar listas: `append()`, `insert()`, `remove()`, `pop()`
- Bucle `for` para recorrer elementos
- `range()` para generar secuencias
- Bucle `while` para repetir mientras una condicion sea True
- `break` y `continue` para controlar bucles
- Operaciones: `sort()`, `sum()`, `min()`, `max()`, `in`
- Slicing para extraer porciones

En la siguiente leccion aprenderemos a crear funciones!
$CONTENT$
WHERE id = '44444444-4444-4444-4444-444444444444';

-- Lesson 5: Funciones
UPDATE lessons
SET content = $CONTENT$# Funciones

Las funciones son bloques de codigo reutilizable. En lugar de repetir el mismo codigo, lo encapsulamos en una funcion y la llamamos cuando la necesitamos.

## Por que usar funciones?

- **Reutilizacion:** Escribe el codigo una vez, usalo muchas veces
- **Organizacion:** Divide programas complejos en partes manejables
- **Legibilidad:** Codigo mas facil de leer y entender
- **Mantenimiento:** Cambias en un solo lugar y se aplica en todos lados

## Definiendo una funcion

Usa `def` para crear una funcion:

```python
def saludar():
    print("Hola!")
    print("Bienvenido al curso")

# Llamar a la funcion
saludar()
```

### Ejercicio 11: Tu primera funcion

Crea una funcion simple:

<!-- exercise:ex-11-funcion-simple -->

## Funciones con parametros

Los parametros permiten pasar informacion a la funcion:

```python
def saludar(nombre):
    print(f"Hola, {nombre}!")

saludar("Maria")  # Hola, Maria!
saludar("Carlos") # Hola, Carlos!
```

### Multiples parametros

```python
def presentar(nombre, edad, ciudad):
    print(f"Soy {nombre}, tengo {edad} anos y vivo en {ciudad}")

presentar("Ana", 25, "Madrid")
```

### Ejercicio 12: Funcion con parametros

Practica creando funciones que reciben datos:

<!-- exercise:ex-12-funcion-parametros -->

## Parametros por defecto

Puedes dar valores por defecto a los parametros:

```python
def saludar(nombre, saludo="Hola"):
    print(f"{saludo}, {nombre}!")

saludar("Maria")              # Hola, Maria!
saludar("Carlos", "Buenos dias")  # Buenos dias, Carlos!
```

## Return: Devolver valores

`return` hace que la funcion devuelva un resultado:

```python
def sumar(a, b):
    resultado = a + b
    return resultado

# Usar el valor devuelto
total = sumar(5, 3)
print(total)  # 8

# Tambien puedes usarlo directamente
print(sumar(10, 20))  # 30
```

### Return termina la funcion

Cuando Python encuentra `return`, sale de la funcion:

```python
def verificar_edad(edad):
    if edad < 0:
        return "Edad invalida"
    if edad >= 18:
        return "Mayor de edad"
    return "Menor de edad"

print(verificar_edad(25))   # Mayor de edad
print(verificar_edad(-5))   # Edad invalida
print(verificar_edad(15))   # Menor de edad
```

### Ejercicio 13: Funcion con return

Crea funciones que devuelvan valores:

<!-- exercise:ex-13-funcion-return -->

## Retornar multiples valores

Python permite retornar varios valores como tupla:

```python
def calcular_estadisticas(numeros):
    minimo = min(numeros)
    maximo = max(numeros)
    promedio = sum(numeros) / len(numeros)
    return minimo, maximo, promedio

datos = [4, 8, 2, 9, 5]
min_val, max_val, prom = calcular_estadisticas(datos)
print(f"Min: {min_val}, Max: {max_val}, Promedio: {prom}")
```

## Argumentos con nombre

Puedes especificar argumentos por nombre:

```python
def crear_usuario(nombre, edad, ciudad):
    print(f"{nombre}, {edad} anos, {ciudad}")

# Por posicion
crear_usuario("Ana", 25, "Madrid")

# Por nombre (mas claro)
crear_usuario(nombre="Carlos", ciudad="Barcelona", edad=30)
```

## *args y **kwargs

Para funciones con numero variable de argumentos:

```python
# *args: multiples argumentos posicionales
def sumar_todos(*numeros):
    return sum(numeros)

print(sumar_todos(1, 2, 3))       # 6
print(sumar_todos(1, 2, 3, 4, 5)) # 15

# **kwargs: multiples argumentos con nombre
def mostrar_info(**datos):
    for clave, valor in datos.items():
        print(f"{clave}: {valor}")

mostrar_info(nombre="Ana", edad=25, ciudad="Madrid")
```

## Scope (alcance de variables)

Las variables dentro de una funcion son locales:

```python
x = 10  # Variable global

def cambiar():
    x = 20  # Variable local (diferente de la global)
    print(f"Dentro: {x}")

cambiar()          # Dentro: 20
print(f"Fuera: {x}")  # Fuera: 10
```

Para modificar una variable global, usa `global`:

```python
contador = 0

def incrementar():
    global contador
    contador += 1

incrementar()
print(contador)  # 1
```

## Funciones como objetos

En Python, las funciones son objetos de primera clase:

```python
def doble(x):
    return x * 2

# Asignar a otra variable
mi_funcion = doble
print(mi_funcion(5))  # 10

# Pasar como argumento
def aplicar(funcion, valor):
    return funcion(valor)

print(aplicar(doble, 10))  # 20
```

## Funciones lambda

Funciones anonimas de una linea:

```python
# Funcion normal
def cuadrado(x):
    return x ** 2

# Equivalente con lambda
cuadrado = lambda x: x ** 2

print(cuadrado(5))  # 25
```

Utiles con funciones como `map`, `filter`, `sorted`:

```python
numeros = [1, 2, 3, 4, 5]
cuadrados = list(map(lambda x: x**2, numeros))
print(cuadrados)  # [1, 4, 9, 16, 25]
```

## Documentacion (docstrings)

Documenta tus funciones con docstrings:

```python
def calcular_area(base, altura):
    """
    Calcula el area de un triangulo.

    Args:
        base: La base del triangulo
        altura: La altura del triangulo

    Returns:
        El area del triangulo
    """
    return (base * altura) / 2

# Ver la documentacion
help(calcular_area)
```

## Resumen

Aprendiste:

- Crear funciones con `def`
- Pasar parametros a funciones
- Usar valores por defecto
- Retornar valores con `return`
- Retornar multiples valores
- Argumentos por nombre
- `*args` y `**kwargs`
- Scope de variables
- Funciones lambda
- Documentar con docstrings

Felicidades! Has completado los fundamentos de Python. Ahora tienes las herramientas basicas para empezar a crear programas mas complejos.
$CONTENT$
WHERE id = '55555555-5555-5555-5555-555555555555';
