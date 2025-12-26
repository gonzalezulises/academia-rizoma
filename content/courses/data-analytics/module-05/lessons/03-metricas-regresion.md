# Métricas de regresión

Las métricas cuantifican qué tan bien predice tu modelo.

## Métricas principales

```python
from sklearn.metrics import mean_squared_error, mean_absolute_error, r2_score

# Error cuadrático medio
mse = mean_squared_error(y_test, y_pred)

# Raíz del error cuadrático medio
rmse = mean_squared_error(y_test, y_pred, squared=False)

# Error absoluto medio
mae = mean_absolute_error(y_test, y_pred)

# Coeficiente de determinación (R²)
r2 = r2_score(y_test, y_pred)
```

<!-- exercise:ex-05-03-metricas -->

## Interpretación

| Métrica | Rango | Interpretación |
|---------|-------|----------------|
| MSE | 0 → ∞ | Menor es mejor |
| RMSE | 0 → ∞ | En unidades de y |
| MAE | 0 → ∞ | Error promedio |
| R² | 0 → 1 | % varianza explicada |

## R²: la métrica más usada

- R² = 1: predicción perfecta
- R² = 0: igual que predecir la media
- R² < 0: peor que la media (modelo malo)

## Siguiente paso

Aplicarás regresión a un caso práctico con el dataset bikeshare.
