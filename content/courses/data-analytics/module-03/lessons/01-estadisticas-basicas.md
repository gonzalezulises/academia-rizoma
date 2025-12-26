# Estadísticas básicas con Pandas

El análisis exploratorio comienza con estadísticas descriptivas. Pandas facilita calcular métricas que resumen tus datos.

## describe(): resumen estadístico

```python
import pandas as pd
df = pd.read_csv("datos.csv")

# Estadísticas de columnas numéricas
df.describe()
```

Devuelve: count, mean, std, min, 25%, 50%, 75%, max.

Para incluir columnas no numéricas:

```python
df.describe(include='all')
```

<!-- exercise:ex-03-01-describe -->

## Estadísticas individuales

```python
# Media
df["columna"].mean()

# Mediana
df["columna"].median()

# Desviación estándar
df["columna"].std()

# Mínimo y máximo
df["columna"].min()
df["columna"].max()

# Suma
df["columna"].sum()

# Conteo de valores no nulos
df["columna"].count()
```

<!-- exercise:ex-03-02-estadisticas -->

## value_counts(): frecuencia de valores

Esencial para columnas categóricas:

```python
# Conteo de cada valor único
df["categoria"].value_counts()

# Proporciones (normalizado)
df["categoria"].value_counts(normalize=True)

# Incluir valores nulos
df["categoria"].value_counts(dropna=False)
```

<!-- exercise:ex-03-03-value-counts -->

## unique() y nunique()

```python
# Valores únicos
df["columna"].unique()

# Número de valores únicos
df["columna"].nunique()
```

## Siguiente paso

Aprenderás a agregar datos por grupos con `groupby()`—una de las operaciones más poderosas en análisis de datos.
