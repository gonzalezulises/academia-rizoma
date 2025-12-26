# Caso práctico: Segmentación de clientes

Aplicaremos clustering para segmentar clientes basados en comportamiento de compra.

## Pipeline completo

```python
import pandas as pd
from sklearn.cluster import KMeans
from sklearn.preprocessing import StandardScaler

# 1. Cargar datos
df = pd.read_csv("customers.csv")

# 2. Seleccionar features
features = ["annual_income", "spending_score"]
X = df[features]

# 3. Escalar
scaler = StandardScaler()
X_scaled = scaler.fit_transform(X)

# 4. Encontrar k óptimo (método del codo)
inertias = []
for k in range(1, 11):
    kmeans = KMeans(n_clusters=k, random_state=42)
    kmeans.fit(X_scaled)
    inertias.append(kmeans.inertia_)

# 5. Entrenar con k seleccionado
kmeans = KMeans(n_clusters=5, random_state=42)
df["cluster"] = kmeans.fit_predict(X_scaled)

# 6. Analizar clusters
print(df.groupby("cluster")[features].mean())
```

<!-- exercise:ex-07-05-segmentacion -->

## Interpretación de clusters

Después de clustering, asigna nombres descriptivos:

```python
cluster_names = {
    0: "Alto ingreso, bajo gasto",
    1: "Bajo ingreso, bajo gasto",
    2: "Ingreso medio, gasto medio",
    3: "Alto ingreso, alto gasto",
    4: "Bajo ingreso, alto gasto"
}
df["segment"] = df["cluster"].map(cluster_names)
```

## Resumen del módulo

- K-Means para clusters esféricos
- DBSCAN para formas arbitrarias
- Siempre escalar antes de clustering
- Método del codo para elegir k
- Interpretar clusters con estadísticas de grupo
