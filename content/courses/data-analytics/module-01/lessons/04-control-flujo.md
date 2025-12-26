# Control de flujo

Hasta ahora, Python ejecuta cada línea en orden, de arriba a abajo. Pero los programas reales necesitan tomar decisiones y repetir acciones. Aquí entran las estructuras de control.

## Condicionales: if, elif, else

El bloque `if` ejecuta código solo si una condición es verdadera:

```python
edad = 25

if edad >= 18:
    print("Es mayor de edad")
```

La **indentación** (4 espacios) es obligatoria en Python. Todo el código indentado bajo el `if` pertenece a ese bloque.

### else: cuando la condición es falsa

```python
edad = 15

if edad >= 18:
    print("Mayor de edad")
else:
    print("Menor de edad")
```

### elif: múltiples condiciones

```python
nota = 85

if nota >= 90:
    print("A - Excelente")
elif nota >= 80:
    print("B - Muy bien")
elif nota >= 70:
    print("C - Bien")
elif nota >= 60:
    print("D - Suficiente")
else:
    print("F - Reprobado")
```

Python evalúa las condiciones en orden y ejecuta solo el primer bloque que sea verdadero.

### Operadores de comparación

| Operador | Significado |
|----------|-------------|
| `==` | Igual a |
| `!=` | Diferente de |
| `<` | Menor que |
| `>` | Mayor que |
| `<=` | Menor o igual |
| `>=` | Mayor o igual |

### Operadores lógicos

```python
edad = 25
tiene_licencia = True

# and: ambas condiciones deben ser verdaderas
if edad >= 18 and tiene_licencia:
    print("Puede conducir")

# or: al menos una condición verdadera
if edad < 18 or edad > 65:
    print("Tarifa especial")

# not: invierte la condición
if not tiene_licencia:
    print("Necesita obtener licencia")
```

<!-- exercise:ex-01-09-if-else -->

## Bucles for: repetir sobre una secuencia

El bucle `for` itera sobre cada elemento de una secuencia (lista, string, etc.):

```python
frutas = ["manzana", "banana", "cereza"]

for fruta in frutas:
    print(f"Me gusta la {fruta}")
```

Salida:
```
Me gusta la manzana
Me gusta la banana
Me gusta la cereza
```

### range(): generar secuencias de números

```python
# range(n) genera 0, 1, 2, ..., n-1
for i in range(5):
    print(i)  # 0, 1, 2, 3, 4

# range(inicio, fin)
for i in range(2, 6):
    print(i)  # 2, 3, 4, 5

# range(inicio, fin, paso)
for i in range(0, 10, 2):
    print(i)  # 0, 2, 4, 6, 8
```

### Acumuladores: patrón común

```python
numeros = [10, 20, 30, 40, 50]
suma = 0

for numero in numeros:
    suma = suma + numero  # o suma += numero

print(f"Total: {suma}")  # Total: 150
```

Este patrón—inicializar una variable y actualizarla en cada iteración—es fundamental en análisis de datos.

<!-- exercise:ex-01-10-for-loop -->

## Bucles while: repetir mientras una condición sea verdadera

El bucle `while` repite mientras la condición sea `True`:

```python
contador = 0

while contador < 5:
    print(contador)
    contador += 1  # ¡Importante! Sin esto, el bucle nunca termina
```

### Cuándo usar while vs for

- **for**: cuando sabes cuántas iteraciones necesitas o iteras sobre una colección
- **while**: cuando repites hasta que algo cambie (entrada de usuario, condición de parada)

```python
# Ejemplo: encontrar el primer número divisible por 7 mayor a 100
numero = 100

while numero % 7 != 0:
    numero += 1

print(f"Encontrado: {numero}")  # 105
```

<!-- exercise:ex-01-11-while-loop -->

## break y continue

- `break`: sale del bucle inmediatamente
- `continue`: salta a la siguiente iteración

```python
# break: encontrar el primer número mayor a 50
numeros = [10, 25, 60, 35, 80]

for n in numeros:
    if n > 50:
        print(f"Encontrado: {n}")
        break  # Sale del bucle

# continue: procesar solo números positivos
valores = [5, -3, 8, -1, 12]

for v in valores:
    if v < 0:
        continue  # Salta los negativos
    print(f"Procesando: {v}")
```

## Enumerate: índice y valor

Cuando necesitas tanto el índice como el valor:

```python
frutas = ["manzana", "banana", "cereza"]

for indice, fruta in enumerate(frutas):
    print(f"{indice}: {fruta}")
```

Salida:
```
0: manzana
1: banana
2: cereza
```

## Siguiente paso

Ya puedes tomar decisiones y repetir acciones. El último paso de este módulo es organizar código reutilizable en **funciones**.
