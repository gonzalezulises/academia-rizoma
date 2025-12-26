# Combinar DataFrames

En análisis real, los datos vienen de múltiples fuentes. Pandas ofrece dos formas principales de combinarlos.

## concat(): apilar DataFrames

Une DataFrames verticalmente (agregar filas) u horizontalmente (agregar columnas):

```python
# Verticalmente (apilar filas)
df_combinado = pd.concat([df1, df2])

# Resetear índice después de concatenar
df_combinado = pd.concat([df1, df2], ignore_index=True)

# Horizontalmente (agregar columnas)
df_combinado = pd.concat([df1, df2], axis=1)
```

<!-- exercise:ex-03-08-concat -->

## merge(): unir por columnas clave

Similar a JOIN en SQL:

```python
# Inner join (solo coincidencias)
df_merged = pd.merge(df1, df2, on="id")

# Left join (todas las filas de df1)
df_merged = pd.merge(df1, df2, on="id", how="left")

# Right join (todas las filas de df2)
df_merged = pd.merge(df1, df2, on="id", how="right")

# Outer join (todas las filas)
df_merged = pd.merge(df1, df2, on="id", how="outer")
```

<!-- exercise:ex-03-09-merge -->

## Cuando las columnas tienen nombres diferentes

```python
df_merged = pd.merge(
    df1, df2,
    left_on="codigo_cliente",
    right_on="id_cliente"
)
```

## join(): alternativa usando índices

```python
df1.set_index("id").join(df2.set_index("id"))
```

## Resumen del módulo

- `describe()`, `mean()`, `sum()` para estadísticas
- `value_counts()` para frecuencias
- `groupby()` + `agg()` para agregaciones
- `isnull()`, `dropna()`, `fillna()` para valores faltantes
- `concat()` y `merge()` para combinar datos
