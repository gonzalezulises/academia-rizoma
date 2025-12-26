# Regresión Logística

A pesar de su nombre, es un algoritmo de clasificación. Predice probabilidades de pertenecer a una clase.

## Implementación

```python
from sklearn.linear_model import LogisticRegression

model = LogisticRegression()
model.fit(X_train, y_train)

# Predicción de clase
y_pred = model.predict(X_test)

# Probabilidades
y_proba = model.predict_proba(X_test)
```

<!-- exercise:ex-06-02-logistic-regression -->

## Probabilidades vs clases

```python
# predict_proba devuelve probabilidad de cada clase
print(y_proba[:5])
# [[0.8, 0.2],   # 80% clase 0, 20% clase 1
#  [0.3, 0.7],   # 30% clase 0, 70% clase 1
#  ...]

# predict usa umbral de 0.5 por defecto
```

## Regularización

```python
# C controla la regularización (menor C = más regularización)
model = LogisticRegression(C=0.1)
```

## Siguiente paso

Aprenderás las métricas para evaluar clasificadores.
