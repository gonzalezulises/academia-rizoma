# Agrupación con groupby()

`groupby()` divide los datos en grupos, aplica una función a cada grupo, y combina los resultados. Es el equivalente a las tablas dinámicas de Excel.

## Sintaxis básica

```python
# Agrupar por una columna y calcular media
df.groupby("categoria")["ventas"].mean()

# Múltiples columnas de agregación
df.groupby("categoria")[["ventas", "cantidad"]].sum()

# Múltiples columnas de agrupación
df.groupby(["region", "categoria"])["ventas"].sum()
```

<!-- exercise:ex-03-04-groupby-basico -->

## Múltiples funciones con agg()

```python
# Varias estadísticas a la vez
df.groupby("categoria")["ventas"].agg(["mean", "sum", "count"])

# Funciones diferentes por columna
df.groupby("categoria").agg({
    "ventas": "sum",
    "cantidad": "mean",
    "precio": ["min", "max"]
})
```

<!-- exercise:ex-03-05-groupby-agg -->

## Resetear índice

`groupby()` crea un índice jerárquico. Para volver a columnas normales:

```python
resultado = df.groupby("categoria")["ventas"].sum().reset_index()
```

## transform(): mantener dimensiones originales

A diferencia de `agg()`, `transform()` devuelve un resultado del mismo tamaño que el input:

```python
# Agregar columna con media del grupo
df["media_grupo"] = df.groupby("categoria")["ventas"].transform("mean")

# Calcular diferencia vs media del grupo
df["diff_vs_grupo"] = df["ventas"] - df.groupby("categoria")["ventas"].transform("mean")
```

## Siguiente paso

Aprenderás a manejar valores faltantes y limpiar datos.
