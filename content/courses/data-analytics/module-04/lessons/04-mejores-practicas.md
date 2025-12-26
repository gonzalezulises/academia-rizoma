# Mejores prácticas de visualización

La visualización efectiva comunica información claramente. No se trata de hacer gráficos bonitos sino útiles.

## Elegir el gráfico correcto

| Objetivo | Tipo de gráfico |
|----------|-----------------|
| Comparar categorías | Barras |
| Mostrar tendencia temporal | Líneas |
| Mostrar distribución | Histograma, boxplot |
| Mostrar relación entre variables | Scatter |
| Mostrar proporciones | Pie (con moderación) |
| Mostrar correlaciones | Heatmap |

## Principios clave

1. **Menos es más**: Elimina elementos innecesarios
2. **Etiquetas claras**: Siempre incluye títulos y etiquetas de ejes
3. **Colores con propósito**: Usa color para destacar, no decorar
4. **Escala apropiada**: No distorsiones el eje Y

<!-- exercise:ex-04-08-grafico-completo -->

## Errores comunes

```python
# ❌ Malo: pie chart con muchas categorías
# ✅ Mejor: barras ordenadas

# ❌ Malo: 3D innecesario
# ✅ Mejor: 2D simple

# ❌ Malo: colores aleatorios
# ✅ Mejor: paleta coherente
```

## Cuándo usar cada biblioteca

- **Matplotlib**: Control total, publicaciones
- **Seaborn**: Análisis estadístico, exploración
- **Plotly**: Dashboards, presentaciones interactivas

## Resumen del módulo

- Matplotlib para control total
- Seaborn para estadísticas elegantes
- Plotly para interactividad
- Elige el gráfico según el mensaje
- Mantén simplicidad
