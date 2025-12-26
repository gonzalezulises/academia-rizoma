# Tipos de datos y operaciones

Python distingue entre diferentes tipos de datos. Esta distinción importa porque determina qué operaciones puedes hacer: sumar números tiene sentido, pero ¿sumar textos? También, pero significa algo diferente.

## Los cuatro tipos básicos

### Enteros (`int`)

Números sin decimales. Pueden ser positivos, negativos o cero:

```python
edad = 28
temperatura = -5
cantidad = 0
poblacion = 8_000_000  # Los guiones bajos mejoran legibilidad
```

### Decimales (`float`)

Números con punto decimal:

```python
precio = 19.99
pi = 3.14159
tasa = 0.05
```

Python usa el punto `.` como separador decimal, no la coma.

### Texto (`str`)

Secuencias de caracteres entre comillas:

```python
nombre = "Ana García"
mensaje = 'También funcionan comillas simples'
multilinea = """Este texto
ocupa varias
líneas"""
```

### Booleanos (`bool`)

Solo dos valores posibles: `True` o `False`. Representan condiciones lógicas:

```python
es_mayor_de_edad = True
tiene_descuento = False
```

Nota: La mayúscula inicial es obligatoria. `true` o `TRUE` producen error.

<!-- exercise:ex-01-03-tipos-datos -->

## Operaciones aritméticas

Python soporta las operaciones matemáticas estándar:

| Operador | Operación | Ejemplo |
|----------|-----------|---------|
| `+` | Suma | `5 + 3` → `8` |
| `-` | Resta | `5 - 3` → `2` |
| `*` | Multiplicación | `5 * 3` → `15` |
| `/` | División | `5 / 3` → `1.666...` |
| `//` | División entera | `5 // 3` → `1` |
| `%` | Módulo (resto) | `5 % 3` → `2` |
| `**` | Potencia | `5 ** 3` → `125` |

La división `/` siempre devuelve un `float`, incluso si el resultado es exacto:

```python
print(10 / 2)   # 5.0 (float)
print(10 // 2)  # 5 (int)
```

El orden de operaciones sigue las reglas matemáticas estándar (PEMDAS). Usa paréntesis para controlar el orden:

```python
resultado = (5 + 3) * 2  # 16, no 11
```

<!-- exercise:ex-01-04-operaciones -->

## Operaciones con texto

El operador `+` concatena (une) textos:

```python
nombre = "Ana"
apellido = "García"
completo = nombre + " " + apellido
print(completo)  # Ana García
```

El operador `*` repite texto:

```python
linea = "-" * 20
print(linea)  # --------------------
```

### f-strings: la forma moderna de formatear

Los f-strings permiten insertar variables directamente en el texto:

```python
nombre = "Ana"
edad = 28
mensaje = f"Me llamo {nombre} y tengo {edad} años"
print(mensaje)  # Me llamo Ana y tengo 28 años
```

También puedes hacer operaciones dentro de las llaves:

```python
precio = 100
descuento = 0.15
print(f"Precio final: ${precio * (1 - descuento)}")  # Precio final: $85.0
```

<!-- exercise:ex-01-05-strings -->

## Verificar tipos

La función `type()` te dice el tipo de cualquier valor:

```python
print(type(42))        # <class 'int'>
print(type(3.14))      # <class 'float'>
print(type("hola"))    # <class 'str'>
print(type(True))      # <class 'bool'>
```

## Conversión entre tipos

A veces necesitas convertir un tipo a otro:

```python
# Texto a número
edad_texto = "28"
edad_numero = int(edad_texto)

# Número a texto
precio = 19.99
precio_texto = str(precio)

# Entero a decimal
cantidad = 5
cantidad_decimal = float(cantidad)
```

Cuidado: no todas las conversiones funcionan:

```python
int("hola")  # Error: no se puede convertir "hola" a número
```

## Siguiente paso

Ya conoces los tipos básicos y cómo operar con ellos. Ahora veremos cómo agrupar múltiples valores en **listas** y **diccionarios**—las estructuras de datos fundamentales para análisis.
