# Diseñando tu framework de decisión

### De aprender a aplicar

A lo largo de este curso has aprendido a identificar sesgos, clasificar datos, usar el ciclo de decisión, evaluar métricas y realizar análisis costo-beneficio. Ahora el objetivo es integrar todo en un **framework personal** que puedas aplicar a cualquier decisión profesional.

No existe un framework universal perfecto. Pero sí existen componentes que los mejores tomadores de decisiones utilizan consistentemente.

---

## Los 7 componentes de un framework de decisión robusto

### 1. Clasificación de la decisión

Antes de analizar, clasifica. No todas las decisiones requieren el mismo rigor.

| Dimensión | Pregunta | Si es alto → |
|---|---|---|
| **Impacto** | ¿Cuánto dinero/personas/tiempo afecta? | Más análisis |
| **Reversibilidad** | ¿Se puede deshacer fácilmente? | Menos análisis si es reversible |
| **Urgencia** | ¿Cuánto tiempo tengo para decidir? | Adaptar profundidad al tiempo |
| **Incertidumbre** | ¿Cuánto sé sobre las consecuencias? | Buscar más datos o pilotar |

**Regla práctica:**
- **Impacto bajo + reversible:** Decide rápido, itera (minutos)
- **Impacto alto + reversible:** Análisis ligero, piloto (días)
- **Impacto bajo + irreversible:** Análisis moderado (días)
- **Impacto alto + irreversible:** Análisis riguroso, múltiples perspectivas (semanas)

---

### 2. Definición estructurada del problema

Usa este template para definir cualquier decisión:

```
DECISIÓN: [Pregunta específica y medible]
CONTEXTO: [Por qué surge esta decisión ahora]
CRITERIOS: [Qué define "éxito" — máximo 3-5 criterios]
DEADLINE: [Cuándo se debe decidir]
DUEÑO: [Quién decide, quién ejecuta]
OPCIONES: [Mínimo 3, incluyendo status quo]
```

**Ejemplo:**
```
DECISIÓN: ¿Migramos el CRM de Salesforce a HubSpot antes de Q3?
CONTEXTO: El contrato de Salesforce se renueva en agosto. HubSpot cuesta 40% menos.
CRITERIOS: (1) Costo total a 3 años, (2) Impacto en productividad de ventas, (3) Riesgo de migración
DEADLINE: 15 de mayo (necesitamos 90 días para migrar antes de agosto)
DUEÑO: VP de Tecnología decide, Director de Ventas valida
OPCIONES: A) Migrar a HubSpot, B) Renegociar Salesforce, C) Status quo
```

---

### 3. Recopilación de evidencia con límite de tiempo

El error más común: recopilar datos indefinidamente. Establece un **time-box** antes de empezar:

| Tipo de decisión | Time-box recomendado |
|---|---|
| Operativa | 1-2 días |
| Táctica | 1-2 semanas |
| Estratégica | 2-4 semanas |

Al final del time-box, decide con lo que tienes. Si no tienes suficiente información, la decisión es: "necesitamos X dato específico, lo obtendremos en Y días."

---

### 4. Checklist anti-sesgos

Antes de decidir, revisa esta lista:

- [ ] **¿Busqué información que contradiga mi hipótesis?** (Anti sesgo de confirmación)
- [ ] **¿El primer dato que recibí está influyendo desproporcionadamente?** (Anti sesgo de anclaje)
- [ ] **¿Estoy dando demasiado peso a un evento reciente o dramático?** (Anti sesgo de disponibilidad)
- [ ] **¿Estoy considerando los casos que NO veo?** (Anti sesgo de supervivencia)
- [ ] **¿Estoy incluyendo costos hundidos en mi razonamiento?** (Anti falacia de costos hundidos)
- [ ] **¿La persona más confiada en la sala es realmente la más informada?** (Anti Dunning-Kruger)

Annie Duke, en *Thinking in Bets* (2018), recomienda preguntarse: "Si un colega inteligente tomara la decisión opuesta, ¿qué razones tendría?" Si no puedes articular razones legítimas para la posición contraria, probablemente no has analizado suficiente.

---

### 5. Matriz de decisión ponderada

Para decisiones con múltiples criterios, usa una matriz simple:

| Criterio | Peso | Opción A | Opción B | Status quo |
|---|---|---|---|---|
| Costo total (3 años) | 40% | 8/10 | 6/10 | 5/10 |
| Impacto en productividad | 35% | 5/10 | 7/10 | 7/10 |
| Riesgo de implementación | 25% | 4/10 | 7/10 | 9/10 |
| **Score ponderado** | | **5.95** | **6.55** | **6.60** |

**Importante:** Los pesos deben definirse **antes** de evaluar las opciones. Si defines los pesos después, inconscientemente los ajustarás para justificar tu preferencia.

---

### 6. Documentación de la decisión

Philip Tetlock encontró que documentar predicciones mejora drásticamente la calidad de las decisiones futuras. Usa este formato:

```
DECISIÓN TOMADA: [Qué se decidió]
FECHA: [Cuándo]
DATOS CLAVE: [Top 3 datos que influyeron]
SUPUESTOS: [Qué asumimos que puede no ser cierto]
RIESGOS IDENTIFICADOS: [Top 3 riesgos y mitigación]
INDICADOR DE ÉXITO: [Cómo sabremos si funcionó]
FECHA DE REVISIÓN: [Cuándo evaluaremos]
```

**¿Por qué documentar?** Porque sin registro, sufrirás de sesgo retrospectivo — recordarás las decisiones buenas como "obvias" y las malas como "impredecibles", y no aprenderás de ninguna.

---

### 7. Revisión y aprendizaje

Programa una revisión en la fecha establecida. Compara:

1. ¿Los resultados coincidieron con las expectativas?
2. ¿Los supuestos resultaron correctos?
3. ¿Hubo consecuencias no anticipadas?
4. ¿Qué haríamos diferente?

Gary Klein, en su técnica de **Pre-mortem** (2007), sugiere además un ejercicio antes de ejecutar: "Imagina que estamos en el futuro y esta decisión fracasó. ¿Qué salió mal?" Este ejercicio obliga a considerar riesgos que el optimismo grupal tiende a ignorar.

---

## Integrando todo: tu framework personal

```
┌─────────────────────────────────────────┐
│  1. CLASIFICAR: ¿Qué tipo de decisión?  │
│     Impacto × Reversibilidad            │
└────────────────┬────────────────────────┘
                 │
┌────────────────▼────────────────────────┐
│  2. DEFINIR: Pregunta + criterios       │
│     + deadline + opciones (≥3)          │
└────────────────┬────────────────────────┘
                 │
┌────────────────▼────────────────────────┐
│  3. RECOPILAR: Datos con time-box       │
│     Cuantitativos + cualitativos        │
└────────────────┬────────────────────────┘
                 │
┌────────────────▼────────────────────────┐
│  4. VERIFICAR: Checklist anti-sesgos    │
│     ¿Confirmación? ¿Anclaje? ¿Hundidos?│
└────────────────┬────────────────────────┘
                 │
┌────────────────▼────────────────────────┐
│  5. EVALUAR: Matriz ponderada + ACB     │
│     Score cuantitativo + factores soft  │
└────────────────┬────────────────────────┘
                 │
┌────────────────▼────────────────────────┐
│  6. DOCUMENTAR: Decisión + supuestos    │
│     + riesgos + fecha de revisión       │
└────────────────┬────────────────────────┘
                 │
┌────────────────▼────────────────────────┐
│  7. REVISAR: ¿Funcionó? ¿Qué aprendí?  │
│     Cerrar el ciclo                     │
└─────────────────────────────────────────┘
```

Este framework no es rígido — es una guía. Para decisiones menores, puedes saltar pasos. Para decisiones críticas, deberías completar cada componente con rigor.

Lo importante es que **tengas un proceso**. Un proceso imperfecto pero consistente produce mejores decisiones a lo largo del tiempo que la intuición brillante pero inconsistente.

---

### Tu turno

Es hora de demostrar todo lo aprendido. El quiz final integra conceptos de los tres módulos.

<!-- exercise:db-ex-09 -->

---

**Referencias:**

- Duke, A. (2018). *Thinking in Bets*. Portfolio/Penguin.
- Tetlock, P. & Gardner, D. (2015). *Superforecasting*. Crown.
- Klein, G. (2007). "Performing a Project Premortem." *Harvard Business Review*.
- Kahneman, D., Sibony, O. & Sunstein, C.R. (2021). *Noise: A Flaw in Human Judgment*. Little, Brown Spark.
- Hammond, J.S., Keeney, R.L. & Raiffa, H. (1999). *Smart Choices*. Harvard Business School Press.
