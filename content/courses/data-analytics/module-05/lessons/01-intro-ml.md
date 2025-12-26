# Introducción a Machine Learning

Machine Learning permite que las computadoras aprendan patrones de datos sin ser programadas explícitamente.

## Tipos de aprendizaje

- **Supervisado**: Tienes datos etiquetados (X → y)
  - Regresión: predecir valores continuos
  - Clasificación: predecir categorías
- **No supervisado**: Sin etiquetas
  - Clustering: encontrar grupos
  - Reducción de dimensionalidad

## El flujo de trabajo ML

```python
# 1. Preparar datos
from sklearn.model_selection import train_test_split
X_train, X_test, y_train, y_test = train_test_split(X, y, test_size=0.2)

# 2. Crear y entrenar modelo
from sklearn.linear_model import LinearRegression
model = LinearRegression()
model.fit(X_train, y_train)

# 3. Predecir
y_pred = model.predict(X_test)

# 4. Evaluar
from sklearn.metrics import mean_squared_error
mse = mean_squared_error(y_test, y_pred)
```

<!-- exercise:ex-05-01-train-test-split -->

## Scikit-learn: la biblioteca estándar

Scikit-learn provee:
- Preprocesamiento
- Modelos (regresión, clasificación, clustering)
- Métricas de evaluación
- Validación cruzada

## Siguiente paso

Implementarás tu primer modelo de regresión lineal.
