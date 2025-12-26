# Primeros pasos con Python

Python es el lenguaje dominante en análisis de datos por una razón simple: te permite ir de la idea al resultado con el mínimo de fricción. No necesitas compilar, no necesitas declarar tipos, y la sintaxis es tan cercana al pseudocódigo que casi puedes leer el código como si fuera inglés.

En esta lección vas a escribir tu primer programa y entender cómo Python ejecuta instrucciones.

## Tu primer programa

Todo programador empieza con lo mismo: hacer que la computadora diga "Hola". En Python, esto requiere exactamente una línea:

```python
print("Hola, mundo")
```

`print()` es una **función** que muestra texto en pantalla. El texto va entre comillas (pueden ser dobles `"` o simples `'`). Python ejecuta las instrucciones de arriba hacia abajo, una por una.

Prueba modificar el mensaje:

```python
print("Hola, mundo")
print("Estoy aprendiendo Python")
print("Esto es análisis de datos")
```

Cada `print()` produce una línea de salida.

<!-- exercise:ex-01-01-hello-world -->

## Comentarios

Los comentarios son notas para humanos que Python ignora completamente. Usa `#` para crear un comentario:

```python
# Esto es un comentario - Python lo ignora
print("Esto sí se ejecuta")  # También puedes comentar al final de una línea
```

Los comentarios son esenciales para explicar *por qué* haces algo, no *qué* haces. El código debería ser autoexplicativo en el "qué"; los comentarios explican la intención.

## Variables: guardar valores para después

Una variable es un nombre que apunta a un valor. Piensa en ella como una etiqueta que pegas a un dato:

```python
nombre = "Ana"
edad = 28
print(nombre)
print(edad)
```

El operador `=` asigna el valor de la derecha al nombre de la izquierda. No es una ecuación matemática—es una instrucción: "guarda este valor con este nombre".

Puedes cambiar el valor de una variable en cualquier momento:

```python
contador = 0
print(contador)  # 0
contador = 1
print(contador)  # 1
contador = contador + 1
print(contador)  # 2
```

### Reglas para nombres de variables

- Pueden contener letras, números y guiones bajos
- No pueden empezar con número
- Son sensibles a mayúsculas (`edad` y `Edad` son diferentes)
- Por convención, usamos `snake_case`: palabras en minúsculas separadas por `_`

```python
# ✅ Buenos nombres
precio_total = 100
nombre_cliente = "Juan"
cantidad_items = 5

# ❌ Nombres problemáticos
1precio = 100      # Error: empieza con número
precio-total = 100 # Error: el guión no está permitido
```

<!-- exercise:ex-01-02-variables -->

## Siguiente paso

Ahora que sabes mostrar información y guardarla en variables, el siguiente paso es entender los diferentes **tipos de datos** que Python puede manejar: números, texto, valores verdadero/falso, y más.
