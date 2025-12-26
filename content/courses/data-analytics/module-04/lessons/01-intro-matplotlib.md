# Introducción a Matplotlib

Matplotlib es la biblioteca base de visualización en Python. Aunque Seaborn y Plotly ofrecen APIs más modernas, entender Matplotlib te da control total.

## Importar y configuración básica

```python
import matplotlib.pyplot as plt
import pandas as pd

# Configuración para notebooks
%matplotlib inline
```

## Tu primer gráfico

```python
x = [1, 2, 3, 4, 5]
y = [2, 4, 6, 8, 10]

plt.plot(x, y)
plt.xlabel("Eje X")
plt.ylabel("Eje Y")
plt.title("Mi primer gráfico")
plt.show()
```

<!-- exercise:ex-04-01-linea-basica -->

## Gráfico de barras

```python
categorias = ["A", "B", "C", "D"]
valores = [25, 40, 30, 55]

plt.bar(categorias, valores)
plt.title("Ventas por categoría")
plt.show()
```

<!-- exercise:ex-04-02-barras -->

## Histograma

```python
import numpy as np
datos = np.random.randn(1000)

plt.hist(datos, bins=30)
plt.title("Distribución")
plt.show()
```

## Scatter plot

```python
x = np.random.randn(100)
y = x + np.random.randn(100) * 0.5

plt.scatter(x, y, alpha=0.5)
plt.xlabel("Variable X")
plt.ylabel("Variable Y")
plt.show()
```

## Siguiente paso

Aprenderás a usar Seaborn para gráficos estadísticos más elegantes.
