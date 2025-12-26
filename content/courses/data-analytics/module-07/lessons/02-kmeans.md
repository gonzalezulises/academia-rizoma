# K-Means Clustering

K-Means agrupa datos en k clusters minimizando la distancia a los centroides.

## Implementación

```python
from sklearn.cluster import KMeans
from sklearn.preprocessing import StandardScaler

# 1. Escalar datos (importante para K-Means)
scaler = StandardScaler()
X_scaled = scaler.fit_transform(X)

# 2. Crear y ajustar modelo
kmeans = KMeans(n_clusters=3, random_state=42, n_init=10)
clusters = kmeans.fit_predict(X_scaled)

# 3. Agregar etiquetas al DataFrame
df["cluster"] = clusters
```

<!-- exercise:ex-07-02-kmeans -->

## Elegir número de clusters: Método del codo

```python
inertias = []
K = range(1, 11)

for k in K:
    kmeans = KMeans(n_clusters=k, random_state=42)
    kmeans.fit(X_scaled)
    inertias.append(kmeans.inertia_)

plt.plot(K, inertias, 'bo-')
plt.xlabel('k')
plt.ylabel('Inertia')
plt.title('Método del codo')
plt.show()
```

<!-- exercise:ex-07-03-elbow -->

## Siguiente paso

Aprenderás DBSCAN para detectar clusters de forma arbitraria.
