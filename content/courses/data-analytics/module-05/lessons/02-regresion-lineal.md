# Regresión Lineal

La regresión lineal modela la relación entre variables como una línea recta: y = mx + b.

## Implementación con Scikit-learn

```python
import pandas as pd
from sklearn.linear_model import LinearRegression
from sklearn.model_selection import train_test_split

# Preparar datos
df = pd.read_csv("datos.csv")
X = df[["feature1", "feature2"]]  # Features (debe ser 2D)
y = df["target"]                   # Target

# Dividir
X_train, X_test, y_train, y_test = train_test_split(X, y, test_size=0.2, random_state=42)

# Entrenar
model = LinearRegression()
model.fit(X_train, y_train)

# Predecir
y_pred = model.predict(X_test)
```

<!-- exercise:ex-05-02-linear-regression -->

## Coeficientes e intercepto

```python
print(f"Coeficientes: {model.coef_}")
print(f"Intercepto: {model.intercept_}")
```

## Regresión con una sola variable

```python
# X debe ser 2D incluso con una variable
X = df[["feature"]].values  # Nota los dobles corchetes
```

## Siguiente paso

Aprenderás a evaluar qué tan bueno es tu modelo.
