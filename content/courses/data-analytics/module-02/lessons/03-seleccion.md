# Selección de datos

Seleccionar subconjuntos de datos es la operación más frecuente en análisis. Pandas ofrece múltiples formas de hacerlo.

## Seleccionar columnas

### Una columna (devuelve Series)

```python
# Notación de corchetes
edades = df["edad"]

# Notación de punto (solo si el nombre no tiene espacios ni caracteres especiales)
edades = df.edad
```

La notación de corchetes es más segura y funciona siempre. Usa esa.

### Múltiples columnas (devuelve DataFrame)

```python
# Lista de nombres de columnas
subset = df[["nombre", "salario"]]
```

Nota los dobles corchetes: el externo es la selección, el interno es la lista.

<!-- exercise:ex-02-06-seleccion-columnas -->

## Seleccionar filas con iloc y loc

Pandas tiene dos métodos principales para seleccionar filas:

- **iloc**: selección por **posición** (índice numérico, como listas)
- **loc**: selección por **etiqueta** (el índice del DataFrame)

### iloc: por posición

```python
# Primera fila
df.iloc[0]

# Filas 0, 1, 2
df.iloc[0:3]

# Última fila
df.iloc[-1]

# Filas específicas
df.iloc[[0, 2, 4]]

# Filas y columnas por posición
df.iloc[0:3, 0:2]  # Primeras 3 filas, primeras 2 columnas
```

### loc: por etiqueta

```python
# Si el índice es numérico (por defecto), funciona similar
df.loc[0]

# Pero loc usa las etiquetas del índice
df.loc[0:2]  # ¡Incluye el 2! (diferente a iloc)

# Con índice personalizado
df_indexed = df.set_index("nombre")
df_indexed.loc["Ana"]  # Fila donde el índice es "Ana"

# Filas y columnas por nombre
df.loc[0:2, ["nombre", "salario"]]
```

**Diferencia clave**: `iloc[0:3]` excluye el 3 (como Python normal), pero `loc[0:2]` incluye el 2.

<!-- exercise:ex-02-07-iloc-loc -->

## Filtrar filas con condiciones

La forma más común de seleccionar filas es con condiciones booleanas:

```python
# Empleados mayores de 30
mayores_30 = df[df["edad"] > 30]

# Empleados de Madrid
de_madrid = df[df["ciudad"] == "Madrid"]

# Múltiples condiciones con & (and) y | (or)
filtro = df[(df["edad"] > 30) & (df["salario"] > 50000)]

# Negación con ~
no_madrid = df[~(df["ciudad"] == "Madrid")]
```

**Importante**: Usa `&` y `|` (no `and`/`or`), y pon paréntesis alrededor de cada condición.

### Método query() - alternativa más legible

```python
# Equivalente a df[(df["edad"] > 30) & (df["salario"] > 50000)]
filtro = df.query("edad > 30 and salario > 50000")

# Puedes usar variables externas con @
edad_minima = 30
filtro = df.query("edad > @edad_minima")
```

<!-- exercise:ex-02-08-filtrado-basico -->

## isin(): filtrar por lista de valores

```python
# Empleados de ciudades específicas
ciudades_interes = ["Madrid", "Barcelona", "Valencia"]
filtro = df[df["ciudad"].isin(ciudades_interes)]
```

## Siguiente paso

Ya sabes seleccionar datos. Ahora veremos cómo cargar datos desde otras fuentes: Excel, JSON, y cómo crear DataFrames desde cero.
