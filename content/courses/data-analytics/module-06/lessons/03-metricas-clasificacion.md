# Métricas de clasificación

Las métricas de regresión no aplican aquí. Clasificación tiene su propio conjunto.

## Matriz de confusión

```python
from sklearn.metrics import confusion_matrix

cm = confusion_matrix(y_test, y_pred)
#           Predicho
#           0    1
# Real 0 [[ TN   FP ]
# Real 1  [ FN   TP ]]
```

- **TP**: True Positive
- **TN**: True Negative
- **FP**: False Positive (error tipo I)
- **FN**: False Negative (error tipo II)

<!-- exercise:ex-06-03-confusion-matrix -->

## Métricas principales

```python
from sklearn.metrics import accuracy_score, precision_score, recall_score, f1_score

accuracy = accuracy_score(y_test, y_pred)   # (TP+TN) / total
precision = precision_score(y_test, y_pred)  # TP / (TP+FP)
recall = recall_score(y_test, y_pred)        # TP / (TP+FN)
f1 = f1_score(y_test, y_pred)                # 2*P*R / (P+R)
```

<!-- exercise:ex-06-04-metricas-clasificacion -->

## ¿Cuál métrica usar?

| Situación | Métrica |
|-----------|---------|
| Clases balanceadas | Accuracy |
| Costo alto de FP | Precision |
| Costo alto de FN | Recall |
| Balance P/R | F1 |

## classification_report

```python
from sklearn.metrics import classification_report
print(classification_report(y_test, y_pred))
```

## Siguiente paso

Aplicarás clasificación al dataset Titanic.
