# Preprocesamiento de datos

## Objetivos de aprendizaje

- Escalar features numéricas con StandardScaler y MinMaxScaler
- Codificar variables categóricas con OneHotEncoder y LabelEncoder
- Identificar cuándo usar cada tipo de preprocesamiento según el algoritmo
- Manejar valores faltantes con SimpleImputer

---

## Introducción

Dataset real de clientes:
- `edad`: 18-85
- `ingreso_anual`: $15,000-$500,000
- `ciudad`: "Lima", "Bogotá", "CDMX", NaN
- `tiempo_cliente_meses`: 0-120, con algunos NaN

**¿Puedes entrenar un modelo directamente con esto?**

Técnicamente sí. Pero probablemente funcione mal.

Los modelos esperan datos numéricos, sin missing, y a escalas comparables.

---

## ¿Por qué escalar?

Muchos algoritmos son sensibles a la escala:

| Algoritmo | Por qué le afecta la escala |
|-----------|----------------------------|
| **KNN** | Usa distancia euclidiana. Feature con rango 0-500,000 domina sobre 0-100 |
| **SVM** | Kernel RBF asume features en escala similar |
| **Regresión con regularización** | L1/L2 penaliza coeficientes grandes |
| **Redes neuronales** | Gradientes explotan o desvanecen con escalas extremas |

**NO sensibles a escala**: Árboles (Decision Tree, Random Forest, XGBoost)

### Tipos de scalers

| Scaler | Fórmula | Cuándo usar |
|--------|---------|-------------|
| **StandardScaler** | (x - mean) / std | Default. Asume distribución ~normal |
| **MinMaxScaler** | (x - min) / (max - min) | Rango [0,1]. Sensible a outliers |
| **RobustScaler** | (x - median) / IQR | Con outliers |

---

## Ejercicio: Escalar features

<!-- exercise:ex-scaling -->

---

## Codificación de variables categóricas

```python
from sklearn.preprocessing import OneHotEncoder, LabelEncoder
import pandas as pd

# Datos
df = pd.DataFrame({'ciudad': ['Lima', 'Bogota', 'Lima', 'CDMX']})

# OneHotEncoder: Para features (crea columnas binarias)
ohe = OneHotEncoder(sparse_output=False, handle_unknown='ignore')
ciudades_encoded = ohe.fit_transform(df[['ciudad']])
# Resultado: [[1,0,0], [0,1,0], [1,0,0], [0,0,1]]

# LabelEncoder: Para target (convierte a números)
le = LabelEncoder()
ciudades_label = le.fit_transform(df['ciudad'])
# Resultado: [1, 0, 1, 2]  # Bogota=0, CDMX=1, Lima=2
```

### Regla importante

> **NUNCA uses LabelEncoder para features**
>
> Los modelos interpretarían CDMX > Bogota como orden, cuando no existe tal relación.

---

## Ejercicio: Codificar variables

<!-- exercise:ex-encoding -->

---

## Manejo de valores faltantes

```python
from sklearn.impute import SimpleImputer

# Numéricos: media, mediana, o constante
imputer_num = SimpleImputer(strategy='median')
X_num_clean = imputer_num.fit_transform(X_num)

# Categóricos: moda o constante
imputer_cat = SimpleImputer(strategy='most_frequent')
X_cat_clean = imputer_cat.fit_transform(X_cat)
```

### Estrategias disponibles

| Estrategia | Descripción | Uso recomendado |
|------------|-------------|-----------------|
| `mean` | Promedio | Numéricos sin outliers |
| `median` | Mediana | Numéricos con outliers |
| `most_frequent` | Moda | Categóricos |
| `constant` | Valor fijo | Cuando NaN tiene significado |

**Advertencia**: SimpleImputer no detecta patrones en missing. Si los NaN no son aleatorios (ej: ingresos faltantes = no reportan), considera crear un feature binario `ingreso_missing`.

---

## Ejercicio: Imputar valores faltantes

<!-- exercise:ex-imputation -->

---

## Orden correcto de preprocesamiento

```
+-------------------------------------------------------------+
| 1. TRAIN/TEST SPLIT (¡antes de todo!)                       |
+-------------------------------------------------------------+
                             |
               +-------------+-------------+
               v                           v
         +----------+               +----------+
         |  TRAIN   |               |   TEST   |
         +----+-----+               +----+-----+
              |                          |
+-------------v-------------+            |
| 2. fit() preprocesadores  |            |
|    en TRAIN únicamente    |            |
+-------------+-------------+            |
              |                          |
+-------------v-------------+  +---------v--------+
| 3. transform() TRAIN      |  | transform() TEST |
+-------------+-------------+  +---------+--------+
              |                          |
+-------------v-------------+            |
| 4. fit() modelo en TRAIN  |            |
+-------------+-------------+            |
              |                          |
              +------------+-------------+
                           v
+-------------------------------------------------------------+
| 5. predict() en TEST -> evaluar                             |
+-------------------------------------------------------------+
```

**Regla**: Solo fit() en train. Transform ambos con los mismos parámetros.

---

## ¿Por qué fit() solo en train?

Porque fit() aprende estadísticas de los datos (media, std, categorías).

Si incluyes test, esas estadísticas reflejan datos que el modelo no debería conocer, causando **data leakage**.

### Ejemplo de data leakage

```python
# INCORRECTO - data leakage
scaler.fit(X)  # Aprende de TODO incluyendo test
X_train, X_test = train_test_split(X)

# CORRECTO - sin leakage
X_train, X_test = train_test_split(X)
scaler.fit(X_train)  # Aprende solo de train
X_train_scaled = scaler.transform(X_train)
X_test_scaled = scaler.transform(X_test)
```

---

## Resumen

> **¿Por qué fit() de los preprocesadores solo debe ejecutarse en train, nunca en test?**
>
> Porque fit() aprende estadísticas de los datos (media, std, categorías). Si incluyes test, esas estadísticas reflejan datos que el modelo no debería conocer, causando data leakage.

### Próxima lección

Datos limpios, modelo entrenado. Pero accuracy no es suficiente. Siguiente: **evaluación de modelos con métricas relevantes al negocio**.
