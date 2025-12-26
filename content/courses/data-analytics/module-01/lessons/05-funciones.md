# Funciones básicas

Las funciones son bloques de código reutilizables. En lugar de copiar y pegar el mismo código, lo encapsulas en una función y la llamas cuando la necesitas. Esto hace tu código más limpio, más fácil de mantener y menos propenso a errores.

## Definir una función

Usa la palabra clave `def` seguida del nombre de la función y paréntesis:

```python
def saludar():
    print("¡Hola!")
    print("Bienvenido al curso")

# Llamar la función
saludar()
```

El código dentro de la función solo se ejecuta cuando la **llamas** (escribes su nombre con paréntesis).

## Parámetros: funciones que reciben datos

Los parámetros permiten que la función trabaje con diferentes valores:

```python
def saludar(nombre):
    print(f"¡Hola, {nombre}!")

saludar("Ana")     # ¡Hola, Ana!
saludar("Carlos")  # ¡Hola, Carlos!
```

Puedes tener múltiples parámetros:

```python
def calcular_total(precio, cantidad):
    total = precio * cantidad
    print(f"Total: ${total}")

calcular_total(10, 5)   # Total: $50
calcular_total(25, 2)   # Total: $50
```

### Parámetros con valores por defecto

```python
def calcular_total(precio, cantidad, descuento=0):
    total = precio * cantidad * (1 - descuento)
    print(f"Total: ${total}")

calcular_total(100, 2)          # Total: $200 (descuento=0 por defecto)
calcular_total(100, 2, 0.1)     # Total: $180 (10% descuento)
```

Los parámetros con valores por defecto deben ir al final.

## Return: devolver valores

Hasta ahora las funciones solo imprimen. Pero las funciones más útiles **devuelven** un valor que puedes usar:

```python
def calcular_area(base, altura):
    area = base * altura
    return area

# El resultado se puede guardar en una variable
resultado = calcular_area(5, 3)
print(f"El área es: {resultado}")  # El área es: 15

# O usar directamente
print(calcular_area(10, 4))  # 40
```

La instrucción `return` termina la función inmediatamente y devuelve el valor especificado.

### Funciones sin return

Si una función no tiene `return`, devuelve `None` implícitamente:

```python
def saludar(nombre):
    print(f"Hola, {nombre}")

resultado = saludar("Ana")
print(resultado)  # None
```

## Funciones que procesan listas

Las funciones son especialmente útiles para procesar colecciones:

```python
def calcular_promedio(numeros):
    suma = 0
    for n in numeros:
        suma += n
    promedio = suma / len(numeros)
    return promedio

ventas = [100, 150, 200, 175, 225]
promedio_ventas = calcular_promedio(ventas)
print(f"Promedio: ${promedio_ventas}")  # Promedio: $170.0
```

## Funciones que devuelven múltiples valores

Python permite devolver varios valores como una tupla:

```python
def estadisticas(numeros):
    minimo = min(numeros)
    maximo = max(numeros)
    promedio = sum(numeros) / len(numeros)
    return minimo, maximo, promedio

datos = [10, 25, 5, 30, 15]
min_val, max_val, prom = estadisticas(datos)
print(f"Mín: {min_val}, Máx: {max_val}, Prom: {prom}")
```

<!-- exercise:ex-01-12-funciones -->

## Scope: dónde viven las variables

Las variables creadas dentro de una función son **locales**—solo existen dentro de esa función:

```python
def mi_funcion():
    x = 10  # Variable local
    print(x)

mi_funcion()
print(x)  # Error! x no existe fuera de la función
```

Las variables fuera de funciones son **globales** y pueden leerse desde dentro:

```python
tasa = 0.16  # Variable global

def calcular_iva(precio):
    return precio * tasa  # Puede leer 'tasa'

print(calcular_iva(100))  # 16.0
```

## Por qué importan las funciones

En análisis de datos, constantemente repites operaciones:

- Limpiar datos de la misma forma
- Calcular métricas específicas
- Formatear resultados para reportes

Las funciones te permiten:

1. **Escribir una vez, usar muchas veces**
2. **Dar nombres descriptivos** a operaciones complejas
3. **Probar** partes del código de forma aislada
4. **Modificar** la lógica en un solo lugar

```python
def limpiar_precio(texto):
    """Convierte '$1,234.56' a número"""
    sin_simbolo = texto.replace("$", "")
    sin_comas = sin_simbolo.replace(",", "")
    return float(sin_comas)

# Ahora puedes limpiar cualquier precio fácilmente
precio1 = limpiar_precio("$1,234.56")
precio2 = limpiar_precio("$999.00")
```

## Siguiente paso

¡Felicidades! Has completado los fundamentos de Python. En el siguiente módulo aprenderás **Pandas**, la biblioteca que transforma a Python en una herramienta de análisis de datos profesional.
