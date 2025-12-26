# Visualizaciones interactivas con Plotly

Plotly crea gráficos interactivos que funcionan en navegadores. Puedes hacer zoom, hover para ver valores, y exportar.

## Plotly Express: API simple

```python
import plotly.express as px
import pandas as pd

df = pd.read_csv("datos.csv")
```

## Gráficos básicos

```python
# Líneas
fig = px.line(df, x="fecha", y="valor", title="Tendencia")
fig.show()

# Barras
fig = px.bar(df, x="categoria", y="ventas", title="Ventas")
fig.show()

# Scatter
fig = px.scatter(df, x="var1", y="var2", color="grupo")
fig.show()
```

<!-- exercise:ex-04-06-plotly-basico -->

## Gráficos avanzados

```python
# Histograma
fig = px.histogram(df, x="valor", nbins=30)

# Box plot
fig = px.box(df, x="categoria", y="valor")

# Heatmap
fig = px.imshow(df.corr(), text_auto=True)
```

<!-- exercise:ex-04-07-plotly-avanzado -->

## Personalización

```python
fig = px.scatter(df, x="x", y="y")
fig.update_layout(
    title="Mi gráfico",
    xaxis_title="Eje X",
    yaxis_title="Eje Y",
    template="plotly_white"
)
fig.show()
```

## Siguiente paso

Aprenderás cuándo usar cada biblioteca y mejores prácticas de visualización.
