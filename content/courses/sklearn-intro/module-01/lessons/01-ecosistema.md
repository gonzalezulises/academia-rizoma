# El ecosistema de Scikit-Learn

## Objetivos de aprendizaje

- Identificar los tipos de problemas que sklearn puede resolver (clasificación, regresión, clustering, reducción dimensional)
- Explicar la API consistente de sklearn (estimator, fit, predict, transform)
- Distinguir cuándo usar sklearn vs alternativas (statsmodels, deep learning, AutoML)

---

## Introducción

Tienes un dataset de 10,000 clientes con 20 variables. Tu jefe quiere saber quiénes van a cancelar el próximo mes.

Podrías escribir reglas manuales ("si edad < 25 y tenure < 6 meses, alto riesgo")... O podrías dejar que un algoritmo descubra los patrones por ti.

**Scikit-learn es la herramienta estándar para esto en Python.**

---

## ¿Qué es Scikit-Learn?

Una librería de ML **clásico** para Python. No hace deep learning (eso es PyTorch/TensorFlow).

Resuelve 4 tipos de problemas:

| Tipo | Input | Output | Ejemplo |
|------|-------|--------|---------|
| **Clasificación** | Features | Categoría | ¿Spam o no spam? |
| **Regresión** | Features | Número continuo | ¿Precio de casa? |
| **Clustering** | Features | Grupo (sin labels) | Segmentos de clientes |
| **Reducción dimensional** | Features | Menos features | Visualización, compresión |

### ¿Cuándo NO usar sklearn?

- **Imágenes, texto, audio** -> Deep learning (PyTorch, TensorFlow)
- **Inferencia estadística** (p-values, intervalos) -> statsmodels
- **Series temporales** -> prophet, statsmodels, sktime
- **Datos tabulares masivos con AutoML** -> auto-sklearn, H2O

---

## La API consistente de sklearn

```python
from sklearn.linear_model import LogisticRegression
from sklearn.preprocessing import StandardScaler

# 1. Crear el objeto (estimator)
modelo = LogisticRegression()
scaler = StandardScaler()

# 2. Ajustar a los datos (fit)
scaler.fit(X_train)
modelo.fit(X_train_scaled, y_train)

# 3. Usar el objeto ajustado
X_test_scaled = scaler.transform(X_test)  # transform para preprocesadores
predicciones = modelo.predict(X_test_scaled)  # predict para modelos

# Patrón común: fit_transform (fit + transform en un paso)
X_train_scaled = scaler.fit_transform(X_train)
```

### Puntos clave:

- **Todo en sklearn es un 'estimator'** con la misma interfaz
- **fit()** aprende de los datos (parámetros, estadísticas)
- **transform()** para preprocesadores, **predict()** para modelos
- **fit_transform()** es un atajo común

---

## Diagrama de la API

```
+-------------------------------------------------------------+
|                      BaseEstimator                          |
|                                                             |
|  fit(X, y=None)    Aprende de los datos                    |
|  get_params()      Retorna hiperparámetros                 |
|  set_params()      Modifica hiperparámetros                |
+-------------------------------------------------------------+
              |                              |
              v                              v
+---------------------+      +---------------------+
|   TransformerMixin  |      |   ClassifierMixin   |
|                     |      |   RegressorMixin    |
|  transform(X)       |      |                     |
|  fit_transform(X)   |      |  predict(X)         |
|                     |      |  predict_proba(X)   |
|  Ej: StandardScaler |      |  score(X, y)        |
|      PCA            |      |                     |
|      OneHotEncoder  |      |  Ej: LogisticReg    |
+---------------------+      |      RandomForest   |
                             |      SVC            |
                             +---------------------+
```

**Esta consistencia significa que puedes cambiar un modelo por otro con una sola línea de código.** El resto del pipeline no cambia.

---

## Comparación: Sklearn vs Alternativas

| Criterio | Scikit-Learn | Statsmodels | PyTorch/TF |
|----------|--------------|-------------|------------|
| **Foco** | Predicción | Inferencia estadística | Deep learning |
| **Output típico** | predict() | summary() con p-values | forward() |
| **Datos** | Tabulares pequeños/medianos | Tabulares | Cualquiera, GPUs |
| **Curva de aprendizaje** | Baja | Media | Alta |
| **Producción** | Fácil (joblib) | Limitado | Complejo (serving) |

---

## Ejercicio: Identificar el método correcto

<!-- exercise:ex-match-problems -->

---

## Resumen

> **En una oración**: La API consistente de sklearn permite cambiar algoritmos con una línea de código porque todos comparten fit/predict/transform, reduciendo el costo de experimentación.

### Próxima lección

Ya conoces la API. En la siguiente lección escribirás tu primer modelo completo con el patrón fit/predict.
