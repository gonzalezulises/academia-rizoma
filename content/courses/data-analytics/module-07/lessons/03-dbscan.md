# DBSCAN

DBSCAN detecta clusters basándose en densidad, no requiere especificar k, y detecta outliers.

## Parámetros clave

- **eps**: Radio de vecindario
- **min_samples**: Mínimo de puntos para formar cluster

```python
from sklearn.cluster import DBSCAN

dbscan = DBSCAN(eps=0.5, min_samples=5)
clusters = dbscan.fit_predict(X_scaled)
```

<!-- exercise:ex-07-04-dbscan -->

## Características

- Etiqueta -1 = outlier/ruido
- No requiere k previo
- Detecta formas arbitrarias

## ¿Cuándo usar qué?

| Algoritmo | Cuando usar |
|-----------|-------------|
| K-Means | Clusters esféricos, k conocido |
| DBSCAN | Formas arbitrarias, outliers |

## Siguiente paso

Aplicarás clustering a segmentación de clientes.
