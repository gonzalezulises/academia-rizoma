# Otras fuentes de datos

CSV es el formato más común, pero Pandas puede leer prácticamente cualquier formato tabular.

## Leer Excel

```python
import pandas as pd

# Archivo Excel básico
df = pd.read_excel("datos.xlsx")

# Hoja específica
df = pd.read_excel("datos.xlsx", sheet_name="Ventas")

# Múltiples hojas (devuelve diccionario)
hojas = pd.read_excel("datos.xlsx", sheet_name=["Ventas", "Clientes"])
ventas = hojas["Ventas"]
clientes = hojas["Clientes"]

# Todas las hojas
todas = pd.read_excel("datos.xlsx", sheet_name=None)
```

<!-- exercise:ex-02-09-read-excel -->

## Crear DataFrames desde diccionarios

Ya vimos esto brevemente, pero es fundamental para crear datos de prueba o transformar estructuras:

```python
# Diccionario donde cada clave es una columna
datos = {
    "producto": ["Laptop", "Mouse", "Teclado"],
    "precio": [999, 25, 75],
    "stock": [10, 150, 80]
}
df = pd.DataFrame(datos)
```

```
  producto  precio  stock
0   Laptop     999     10
1    Mouse      25    150
2  Teclado      75     80
```

### Desde lista de diccionarios

Cada diccionario es una fila:

```python
registros = [
    {"producto": "Laptop", "precio": 999, "stock": 10},
    {"producto": "Mouse", "precio": 25, "stock": 150},
    {"producto": "Teclado", "precio": 75, "stock": 80}
]
df = pd.DataFrame(registros)
```

<!-- exercise:ex-02-10-crear-dataframe -->

## Leer JSON

```python
# JSON como lista de objetos
df = pd.read_json("datos.json")

# JSON anidado (requiere normalización)
import json
with open("datos_anidados.json") as f:
    data = json.load(f)
df = pd.json_normalize(data)
```

## Leer desde URL

Pandas puede leer directamente desde URLs:

```python
url = "https://ejemplo.com/datos.csv"
df = pd.read_csv(url)
```

## Guardar datos

```python
# A CSV
df.to_csv("salida.csv", index=False)  # index=False evita guardar el índice

# A Excel
df.to_excel("salida.xlsx", index=False)

# A JSON
df.to_json("salida.json", orient="records")
```

## Leer desde base de datos SQL

```python
import sqlite3

# Conectar a base de datos
conn = sqlite3.connect("database.db")

# Leer tabla completa
df = pd.read_sql("SELECT * FROM ventas", conn)

# Query específica
df = pd.read_sql("""
    SELECT fecha, producto, cantidad
    FROM ventas
    WHERE fecha > '2024-01-01'
""", conn)

conn.close()
```

## Datos de ejemplo integrados

Para practicar, puedes usar datasets de otras bibliotecas:

```python
# Desde seaborn
import seaborn as sns
tips = sns.load_dataset("tips")
iris = sns.load_dataset("iris")
titanic = sns.load_dataset("titanic")

# Desde sklearn
from sklearn.datasets import load_iris
iris_data = load_iris()
df = pd.DataFrame(iris_data.data, columns=iris_data.feature_names)
```

## Resumen del módulo

Has aprendido a:
1. Importar Pandas con `import pandas as pd`
2. Leer CSV con `pd.read_csv()`
3. Explorar datos con `head()`, `info()`, `describe()`, `shape`, `dtypes`
4. Seleccionar columnas con `df["columna"]` y `df[["col1", "col2"]]`
5. Seleccionar filas con `iloc` (posición) y `loc` (etiqueta)
6. Filtrar con condiciones booleanas
7. Leer Excel, JSON, y crear DataFrames desde diccionarios

En el siguiente módulo aprenderás a transformar y analizar estos datos con operaciones de agregación, limpieza y combinación.
