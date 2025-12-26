# Plotly Graph Objects

Para control total sobre tus visualizaciones, usa Graph Objects en lugar de Express.

## Estructura básica

```python
import plotly.graph_objects as go

fig = go.Figure()

fig.add_trace(go.Scatter(
    x=[1, 2, 3, 4],
    y=[10, 11, 12, 13],
    mode='lines+markers',
    name='Serie 1'
))

fig.update_layout(
    title='Mi gráfico',
    xaxis_title='Eje X',
    yaxis_title='Eje Y'
)

fig.show()
```

<!-- exercise:ex-08-01-graph-objects -->

## Múltiples trazas

```python
fig = go.Figure()

fig.add_trace(go.Scatter(x=x, y=y1, name='Ventas'))
fig.add_trace(go.Scatter(x=x, y=y2, name='Costos'))
fig.add_trace(go.Bar(x=x, y=y3, name='Margen'))

fig.show()
```

<!-- exercise:ex-08-02-multiples-trazas -->

## Subplots

```python
from plotly.subplots import make_subplots

fig = make_subplots(rows=2, cols=2)

fig.add_trace(go.Scatter(x=x, y=y), row=1, col=1)
fig.add_trace(go.Bar(x=x, y=y), row=1, col=2)
fig.add_trace(go.Pie(values=v, labels=l), row=2, col=1)

fig.update_layout(height=600)
fig.show()
```

## Siguiente paso

Construirás tu primera app con Streamlit.
