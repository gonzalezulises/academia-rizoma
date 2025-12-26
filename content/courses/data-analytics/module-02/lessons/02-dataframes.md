# DataFrames y Series

Un DataFrame está compuesto por Series. Entender esta relación es clave para manipular datos eficientemente.

## Series: una columna

Una Series es una secuencia unidimensional con índice. Cuando extraes una columna de un DataFrame, obtienes una Series:

```python
import pandas as pd

df = pd.read_csv("empleados.csv")

# Extraer una columna → Series
edades = df["edad"]
print(type(edades))  # <class 'pandas.core.series.Series'>
```

Una Series tiene:
- **Valores**: los datos en sí
- **Índice**: etiquetas para cada valor (por defecto 0, 1, 2...)
- **Nombre**: el nombre de la columna original

```python
print(edades.values)  # array([28, 35, 42])
print(edades.index)   # RangeIndex(start=0, stop=3, step=1)
print(edades.name)    # 'edad'
```

## DataFrame: múltiples Series

Un DataFrame es esencialmente un diccionario de Series que comparten el mismo índice:

```python
# Crear DataFrame desde diccionario
datos = {
    "nombre": ["Ana", "Juan", "María"],
    "edad": [28, 35, 42],
    "salario": [45000, 52000, 61000]
}

df = pd.DataFrame(datos)
print(df)
```

Salida:
```
  nombre  edad  salario
0    Ana    28    45000
1   Juan    35    52000
2  María    42    61000
```

<!-- exercise:ex-02-03-explorar-df -->

## Explorar dimensiones

```python
# Número de filas y columnas
print(df.shape)  # (3, 3)

# Solo filas
print(len(df))  # 3

# Solo columnas
print(len(df.columns))  # 3
```

<!-- exercise:ex-02-04-head-tail -->

## Tipos de datos

Pandas infiere tipos automáticamente, pero debes verificarlos:

```python
print(df.dtypes)
```

```
nombre     object    # 'object' significa texto (string)
edad        int64    # entero de 64 bits
salario     int64
dtype: object
```

Tipos comunes en Pandas:
- `int64`: enteros
- `float64`: decimales
- `object`: texto (strings)
- `bool`: booleanos
- `datetime64`: fechas
- `category`: categorías (eficiente para valores repetidos)

<!-- exercise:ex-02-05-shape-dtypes -->

## info() y describe()

Dos métodos esenciales para exploración inicial:

```python
# Información estructural
df.info()
```

```
<class 'pandas.DataFrame'>
RangeIndex: 3 entries, 0 to 2
Data columns (total 3 columns):
 #   Column   Non-Null Count  Dtype 
---  ------   --------------  ----- 
 0   nombre   3 non-null      object
 1   edad     3 non-null      int64 
 2   salario  3 non-null      int64 
dtypes: int64(2), object(1)
memory usage: 200.0+ bytes
```

```python
# Estadísticas descriptivas (solo columnas numéricas)
df.describe()
```

```
            edad       salario
count   3.000000      3.000000
mean   35.000000  52666.666667
std     7.000000   8020.806279
min    28.000000  45000.000000
25%    31.500000  48500.000000
50%    35.000000  52000.000000
75%    38.500000  56500.000000
max    42.000000  61000.000000
```

## Siguiente paso

Ya conoces la estructura. Ahora aprenderás a seleccionar subconjuntos de datos—filas específicas, columnas específicas, o combinaciones.
