# Manejo de valores faltantes

Los datos reales siempre tienen huecos. Pandas representa valores faltantes como `NaN` (Not a Number) o `None`.

## Detectar valores faltantes

```python
# ¿Hay valores nulos?
df.isnull().sum()

# Porcentaje de nulos por columna
df.isnull().mean() * 100

# Filas con algún nulo
df[df.isnull().any(axis=1)]
```

<!-- exercise:ex-03-06-detectar-nulos -->

## Eliminar valores faltantes

```python
# Eliminar filas con cualquier nulo
df.dropna()

# Eliminar filas donde columnas específicas son nulas
df.dropna(subset=["columna1", "columna2"])

# Eliminar columnas con nulos
df.dropna(axis=1)

# Eliminar solo si TODOS son nulos
df.dropna(how="all")
```

## Rellenar valores faltantes

```python
# Con un valor fijo
df["columna"].fillna(0)

# Con la media
df["columna"].fillna(df["columna"].mean())

# Con el valor anterior (forward fill)
df["columna"].fillna(method="ffill")

# Con el valor siguiente (backward fill)
df["columna"].fillna(method="bfill")
```

<!-- exercise:ex-03-07-rellenar-nulos -->

## Reemplazar valores

```python
# Reemplazar valores específicos
df["columna"].replace("viejo", "nuevo")

# Múltiples reemplazos
df["columna"].replace({"A": 1, "B": 2, "C": 3})
```

## Siguiente paso

Aprenderás a combinar múltiples DataFrames con `merge()` y `concat()`.
