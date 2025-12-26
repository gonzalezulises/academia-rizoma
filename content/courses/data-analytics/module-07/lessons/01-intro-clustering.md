# Introducción a Clustering

Clustering es aprendizaje no supervisado: encontrar grupos naturales en datos sin etiquetas.

## Aplicaciones

- Segmentación de clientes
- Detección de anomalías
- Agrupación de documentos
- Compresión de imágenes

## Algoritmos principales

1. **K-Means**: Rápido, requiere especificar k
2. **DBSCAN**: Detecta formas arbitrarias y outliers
3. **Hierarchical**: Crea dendrogramas

<!-- exercise:ex-07-01-clustering-intro -->

## K-Means básico

```python
from sklearn.cluster import KMeans

model = KMeans(n_clusters=3, random_state=42)
clusters = model.fit_predict(X)
```

## Siguiente paso

Implementarás K-Means paso a paso.
