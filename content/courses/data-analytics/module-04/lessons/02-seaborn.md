# Visualización con Seaborn

Seaborn está construido sobre Matplotlib pero ofrece una API más intuitiva y gráficos más atractivos por defecto.

## Importar

```python
import seaborn as sns
import matplotlib.pyplot as plt
import pandas as pd
```

## Gráficos de distribución

```python
df = pd.read_csv("datos.csv")

# Histograma con KDE
sns.histplot(df["columna"], kde=True)

# Solo KDE
sns.kdeplot(df["columna"])

# Boxplot
sns.boxplot(x="categoria", y="valor", data=df)
```

<!-- exercise:ex-04-03-histplot -->

## Gráficos de relación

```python
# Scatter con regresión
sns.regplot(x="var1", y="var2", data=df)

# Scatter coloreado por categoría
sns.scatterplot(x="var1", y="var2", hue="categoria", data=df)

# Matriz de correlación
sns.heatmap(df.corr(), annot=True, cmap="coolwarm")
```

<!-- exercise:ex-04-04-scatter -->

## Gráficos categóricos

```python
# Barras con error
sns.barplot(x="categoria", y="valor", data=df)

# Violin plot
sns.violinplot(x="categoria", y="valor", data=df)

# Count plot
sns.countplot(x="categoria", data=df)
```

<!-- exercise:ex-04-05-barplot -->

## Personalización

```python
# Estilo
sns.set_style("whitegrid")

# Paleta de colores
sns.set_palette("husl")

# Tamaño de figura
plt.figure(figsize=(10, 6))
```

## Siguiente paso

Aprenderás a crear visualizaciones interactivas con Plotly.
