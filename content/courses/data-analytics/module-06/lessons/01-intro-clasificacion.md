# Introducción a Clasificación

Clasificación predice categorías discretas en lugar de valores continuos.

## Diferencia con regresión

- **Regresión**: ¿Cuánto? (precio, temperatura)
- **Clasificación**: ¿Qué categoría? (spam/no spam, fraude/legítimo)

## Tipos de clasificación

- **Binaria**: 2 clases (sí/no, 0/1)
- **Multiclase**: 3+ clases (bajo/medio/alto)

## Algoritmos comunes

1. **Regresión Logística**: Simple y efectiva
2. **Árboles de decisión**: Interpretables
3. **Random Forest**: Robusto
4. **SVM**: Márgenes máximos
5. **K-Nearest Neighbors**: Basado en distancia

<!-- exercise:ex-06-01-clasificacion-intro -->

## El pipeline es el mismo

```python
from sklearn.linear_model import LogisticRegression
from sklearn.model_selection import train_test_split

X_train, X_test, y_train, y_test = train_test_split(X, y, test_size=0.2)

model = LogisticRegression()
model.fit(X_train, y_train)
y_pred = model.predict(X_test)
```

## Siguiente paso

Implementarás regresión logística paso a paso.
