# Introducción a Pandas

Pandas es la biblioteca central para análisis de datos en Python. Transforma Python de un lenguaje de programación general a una herramienta especializada en manipulación de datos tabulares—piensa en Excel, pero con la potencia de la programación.

## Importar Pandas

La convención universal es importar Pandas con el alias `pd`:

```python
import pandas as pd
```

Este alias es tan estándar que verás `pd.` en prácticamente todo código de análisis de datos. No uses otro alias—confundirás a cualquiera que lea tu código.

<!-- exercise:ex-02-01-import-pandas -->

## Leer datos desde CSV

El formato más común para datos es CSV (Comma-Separated Values). Pandas lo lee con una sola línea:

```python
import pandas as pd

df = pd.read_csv("datos.csv")
```

La variable `df` (por DataFrame) ahora contiene todos los datos del archivo. Por convención, usamos `df` para DataFrames genéricos—es el estándar en la comunidad.

### Parámetros útiles de read_csv

```python
# Especificar separador (para archivos con ; o tabs)
df = pd.read_csv("datos.csv", sep=";")

# Indicar que la primera fila NO son encabezados
df = pd.read_csv("datos.csv", header=None)

# Usar una columna como índice
df = pd.read_csv("datos.csv", index_col="id")

# Leer solo ciertas columnas
df = pd.read_csv("datos.csv", usecols=["nombre", "edad", "ciudad"])

# Especificar tipos de datos
df = pd.read_csv("datos.csv", dtype={"codigo": str, "cantidad": int})
```

<!-- exercise:ex-02-02-read-csv -->

## El DataFrame: la estructura central

Un DataFrame es una tabla bidimensional con filas y columnas. Cada columna tiene un nombre y un tipo de datos:

```
        nombre    edad    ciudad      salario
0       Ana       28      Madrid      45000
1       Juan      35      Barcelona   52000
2       María     42      Valencia    61000
```

- Las **filas** tienen un índice (0, 1, 2... por defecto)
- Las **columnas** tienen nombres
- Cada columna es una **Series** (veremos esto después)

## Primeras exploraciones

Después de cargar datos, siempre exploras antes de analizar:

```python
# Ver las primeras 5 filas
df.head()

# Ver las últimas 5 filas
df.tail()

# Ver las primeras N filas
df.head(10)

# Dimensiones: (filas, columnas)
df.shape

# Nombres de columnas
df.columns

# Tipos de datos de cada columna
df.dtypes

# Resumen completo
df.info()
```

El método `info()` es especialmente útil: muestra columnas, tipos, y cuántos valores no nulos hay—esencial para detectar datos faltantes.

## Siguiente paso

Ahora que sabes cargar datos, profundizaremos en la estructura del DataFrame y cómo trabajar con Series.
