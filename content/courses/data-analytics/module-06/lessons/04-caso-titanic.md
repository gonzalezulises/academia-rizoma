# Caso práctico: Titanic

El clásico problema de ML: predecir supervivencia en el Titanic.

## Pipeline completo

```python
import pandas as pd
from sklearn.model_selection import train_test_split
from sklearn.linear_model import LogisticRegression
from sklearn.metrics import accuracy_score, classification_report

# 1. Cargar
df = pd.read_csv("titanic.csv")

# 2. Preparar features
df["Sex"] = df["Sex"].map({"male": 0, "female": 1})
features = ["Pclass", "Sex", "Age", "Fare"]
df = df.dropna(subset=features + ["Survived"])

X = df[features]
y = df["Survived"]

# 3. Split
X_train, X_test, y_train, y_test = train_test_split(X, y, test_size=0.2, random_state=42)

# 4. Entrenar
model = LogisticRegression()
model.fit(X_train, y_train)

# 5. Evaluar
y_pred = model.predict(X_test)
print(f"Accuracy: {accuracy_score(y_test, y_pred):.3f}")
print(classification_report(y_test, y_pred))
```

<!-- exercise:ex-06-05-titanic -->

## Análisis de coeficientes

```python
coef_df = pd.DataFrame({
    "Feature": features,
    "Coeficiente": model.coef_[0]
})
print(coef_df.sort_values("Coeficiente", ascending=False))
```

## Resumen del módulo

- LogisticRegression para clasificación binaria
- predict() para clases, predict_proba() para probabilidades
- Matriz de confusión para entender errores
- Accuracy, precision, recall, F1 según el caso
