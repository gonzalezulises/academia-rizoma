# Caso práctico: Predicción de demanda de bicicletas

Aplicaremos regresión lineal para predecir la demanda de bicicletas compartidas.

## El dataset bikeshare

Contiene registros horarios de uso de bicicletas con:
- Condiciones climáticas (temperatura, humedad)
- Temporal (hora, día, temporada)
- Target: cantidad de alquileres

## Pipeline completo

```python
import pandas as pd
from sklearn.model_selection import train_test_split
from sklearn.linear_model import LinearRegression
from sklearn.metrics import r2_score, mean_absolute_error

# 1. Cargar y explorar
df = pd.read_csv("bikeshare.csv")
print(df.info())

# 2. Seleccionar features
features = ["temp", "humidity", "windspeed", "hour"]
X = df[features]
y = df["count"]

# 3. Split
X_train, X_test, y_train, y_test = train_test_split(
    X, y, test_size=0.2, random_state=42
)

# 4. Entrenar
model = LinearRegression()
model.fit(X_train, y_train)

# 5. Evaluar
y_pred = model.predict(X_test)
print(f"R²: {r2_score(y_test, y_pred):.3f}")
print(f"MAE: {mean_absolute_error(y_test, y_pred):.1f}")
```

<!-- exercise:ex-05-04-bikeshare -->

## Análisis de coeficientes

```python
coef_df = pd.DataFrame({
    "Feature": features,
    "Coeficiente": model.coef_
})
print(coef_df.sort_values("Coeficiente", ascending=False))
```

## Resumen del módulo

- train_test_split para dividir datos
- LinearRegression para entrenar
- predict para generar predicciones
- MSE, RMSE, MAE, R² para evaluar
