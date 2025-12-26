# Listas y diccionarios

Hasta ahora, cada variable guarda un solo valor. Pero en análisis de datos trabajas con colecciones: listas de ventas, tablas de clientes, series temporales. Python tiene dos estructuras fundamentales para esto: **listas** y **diccionarios**.

## Listas

Una lista es una secuencia ordenada de elementos. Se crea con corchetes `[]`:

```python
numeros = [1, 2, 3, 4, 5]
nombres = ["Ana", "Juan", "María"]
mezclado = [1, "texto", 3.14, True]  # Puede mezclar tipos
vacia = []  # Lista vacía
```

Las listas son ordenadas: el orden en que pones los elementos se preserva.

<!-- exercise:ex-01-06-listas-crear -->

## Acceder a elementos

Cada elemento tiene un **índice** que indica su posición. Los índices empiezan en 0:

```python
frutas = ["manzana", "banana", "cereza", "durazno"]
#            0          1         2          3

print(frutas[0])   # manzana (primer elemento)
print(frutas[2])   # cereza (tercer elemento)
print(frutas[-1])  # durazno (último elemento)
print(frutas[-2])  # cereza (penúltimo)
```

Los índices negativos cuentan desde el final: `-1` es el último, `-2` el penúltimo, etc.

### Slicing: obtener sublistas

Puedes extraer una porción de la lista con `[inicio:fin]`:

```python
numeros = [0, 1, 2, 3, 4, 5, 6, 7, 8, 9]

print(numeros[2:5])   # [2, 3, 4] - desde índice 2 hasta antes de 5
print(numeros[:3])    # [0, 1, 2] - desde el inicio hasta antes de 3
print(numeros[7:])    # [7, 8, 9] - desde índice 7 hasta el final
print(numeros[::2])   # [0, 2, 4, 6, 8] - cada 2 elementos
```

El índice final no se incluye—es el patrón de Python.

<!-- exercise:ex-01-07-listas-acceso -->

## Modificar listas

Las listas son **mutables**: puedes cambiar sus elementos:

```python
frutas = ["manzana", "banana", "cereza"]

# Cambiar un elemento
frutas[1] = "pera"
print(frutas)  # ["manzana", "pera", "cereza"]

# Agregar al final
frutas.append("uva")
print(frutas)  # ["manzana", "pera", "cereza", "uva"]

# Insertar en posición específica
frutas.insert(1, "kiwi")
print(frutas)  # ["manzana", "kiwi", "pera", "cereza", "uva"]

# Eliminar por valor
frutas.remove("pera")
print(frutas)  # ["manzana", "kiwi", "cereza", "uva"]

# Eliminar por índice
del frutas[0]
print(frutas)  # ["kiwi", "cereza", "uva"]
```

### Longitud y pertenencia

```python
numeros = [10, 20, 30, 40]

print(len(numeros))     # 4 (cantidad de elementos)
print(20 in numeros)    # True (¿está 20 en la lista?)
print(50 in numeros)    # False
```

## Diccionarios

Un diccionario almacena pares **clave-valor**. Piensa en él como una tabla de dos columnas:

```python
persona = {
    "nombre": "Ana García",
    "edad": 28,
    "ciudad": "Madrid",
    "es_cliente": True
}
```

Cada clave es única y apunta a un valor. Las claves suelen ser strings, pero pueden ser cualquier tipo inmutable.

### Acceder a valores

```python
print(persona["nombre"])     # Ana García
print(persona["edad"])       # 28

# Con .get() evitas errores si la clave no existe
print(persona.get("telefono"))           # None
print(persona.get("telefono", "N/A"))    # N/A (valor por defecto)
```

<!-- exercise:ex-01-08-diccionarios -->

### Modificar diccionarios

```python
persona = {"nombre": "Ana", "edad": 28}

# Agregar o modificar
persona["ciudad"] = "Madrid"      # Agrega nueva clave
persona["edad"] = 29              # Modifica valor existente

# Eliminar
del persona["ciudad"]

# Verificar si existe una clave
print("nombre" in persona)  # True
print("ciudad" in persona)  # False (ya la eliminamos)
```

### Recorrer diccionarios

```python
persona = {"nombre": "Ana", "edad": 28, "ciudad": "Madrid"}

# Solo claves
for clave in persona:
    print(clave)

# Claves y valores
for clave, valor in persona.items():
    print(f"{clave}: {valor}")
```

## Listas de diccionarios: la estructura de datos

En análisis de datos, la estructura más común es una **lista de diccionarios**, donde cada diccionario representa un registro:

```python
clientes = [
    {"id": 1, "nombre": "Ana", "compras": 5},
    {"id": 2, "nombre": "Juan", "compras": 12},
    {"id": 3, "nombre": "María", "compras": 3}
]

# Acceder al nombre del segundo cliente
print(clientes[1]["nombre"])  # Juan

# Recorrer todos
for cliente in clientes:
    print(f"{cliente['nombre']} ha hecho {cliente['compras']} compras")
```

Esta estructura es exactamente lo que representa un DataFrame de Pandas—que verás en módulos posteriores.

## Siguiente paso

Ya puedes almacenar y organizar datos. Ahora aprenderás a tomar decisiones en tu código con **estructuras de control**: if, for, while.
