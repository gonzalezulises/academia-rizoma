# Tipos de datos y fuentes de información

### No todos los datos son iguales

"Los datos no mienten." Esa frase es peligrosamente incompleta. Los datos no mienten, pero **pueden engañar** — depende de qué datos, de dónde vienen y cómo se recopilaron.

Antes de usar datos para decidir, necesitas saber clasificarlos. No es lo mismo una encuesta interna de 15 personas que un estudio de mercado de 10,000 hogares. Ambos son "datos", pero su peso en una decisión debería ser radicalmente diferente.

---

## Datos cuantitativos vs. cualitativos

| Dimensión | Cuantitativos | Cualitativos |
|---|---|---|
| **Qué miden** | Cantidades, frecuencias, magnitudes | Percepciones, motivaciones, experiencias |
| **Formato** | Números, porcentajes, promedios | Texto, entrevistas, observaciones |
| **Pregunta que responden** | ¿Cuánto? ¿Con qué frecuencia? | ¿Por qué? ¿Cómo se siente? |
| **Ejemplo** | "El 32% de los clientes abandona en el checkout" | "Los clientes dicen que el formulario es confuso" |
| **Fortaleza** | Objetividad, escalabilidad, comparabilidad | Profundidad, contexto, descubrimiento |
| **Debilidad** | No explica el *por qué* | Difícil de generalizar, subjetivo |

**Principio clave:** Los datos cuantitativos te dicen *qué* está pasando. Los cualitativos te dicen *por qué*. Las mejores decisiones combinan ambos.

John W. Creswell, en *Research Design* (2014), llama a esta combinación **métodos mixtos** y argumenta que produce decisiones más robustas que cualquier tipo de dato por separado.

---

## Fuentes primarias vs. secundarias

### Fuentes primarias

Datos que tú o tu organización recopilaron directamente para responder tu pregunta específica.

| Fuente | Ejemplo | Ventaja | Limitación |
|---|---|---|---|
| Encuestas propias | Encuesta de clima laboral a 200 empleados | Diseñada para tu contexto | Costosa, sesgo de diseño |
| Entrevistas | 15 entrevistas a clientes que cancelaron | Profundidad, matices | No generalizable |
| Datos operativos | Registros de ventas de tu ERP | Precisos, actualizados | Solo tu empresa |
| Experimentos | A/B test de dos precios diferentes | Evidencia causal | Requiere volumen |
| Observación directa | Auditoría de procesos en planta | Datos reales, no reportados | Efecto Hawthorne |

### Fuentes secundarias

Datos recopilados por otros para otros propósitos que tú reutilizas.

| Fuente | Ejemplo | Ventaja | Limitación |
|---|---|---|---|
| Reportes de industria | Estudio de mercado de Euromonitor | Amplio, profesional | Costoso, genérico |
| Datos gubernamentales | Censo, estadísticas de comercio exterior | Gratuito, confiable | Desactualizado (2-3 años) |
| Estudios académicos | Paper sobre comportamiento de consumidor | Riguroso, peer-reviewed | Contexto puede no aplicar |
| Benchmarks | Salarios promedio de Glassdoor/Mercer | Comparativo | Metodología opaca |
| Noticias y medios | Artículos sobre tendencias del sector | Accesible, actual | Sesgo editorial |

---

## La pirámide de confiabilidad

No todas las fuentes merecen el mismo peso. Adaptando la jerarquía de evidencia de la medicina (Sackett et al., 1996):

```
         ▲
        / \
       / 1 \     Experimentos controlados (A/B tests, RCTs)
      /─────\
     /   2   \   Datos operativos propios (verificables)
    /─────────\
   /     3     \  Estudios con metodología transparente
  /─────────────\
 /       4       \ Reportes de terceros, benchmarks
/─────────────────\
/        5         \ Opiniones de expertos, anécdotas
───────────────────
```

**Nivel 1 — Evidencia experimental:** A/B tests, ensayos controlados. La forma más confiable de establecer causalidad. "Probamos dos precios y medimos el impacto en conversión."

**Nivel 2 — Datos operativos verificables:** Tus propios registros de ventas, CRM, ERP. Confiables si los procesos de captura son consistentes.

**Nivel 3 — Estudios con metodología transparente:** Investigaciones donde puedes evaluar cómo se recopilaron los datos, el tamaño de muestra y las limitaciones.

**Nivel 4 — Reportes de terceros:** Útiles como referencia, pero la metodología suele ser opaca. "Según Gartner, el 75% de las empresas..." — ¿cómo definieron "empresas"? ¿Cuántas encuestaron?

**Nivel 5 — Opiniones y anécdotas:** "El CEO de X dijo que..." o "En mi experiencia...". Pueden generar hipótesis, pero no deben ser la base de decisiones importantes.

---

## Errores comunes al evaluar datos

### 1. Confundir correlación con causalidad

"Los países que consumen más chocolate ganan más premios Nobel." Verdadero estadísticamente, pero el chocolate no causa genialidad — ambos correlacionan con PIB per cápita.

### 2. Sesgo de selección en la muestra

"El 95% de nuestros clientes están satisfechos." ¿Encuestaste a los que cancelaron? Si solo mides satisfacción entre clientes activos, estás midiendo a los sobrevivientes.

### 3. Tamaño de muestra insuficiente

"Entrevistamos a 5 clientes y todos prefieren el producto azul." Con 5 personas, la variabilidad natural hace que cualquier conclusión sea estadísticamente irrelevante.

### 4. Datos desactualizados

"Según el censo de 2010, la población de esa zona es..." En 15 años, esa zona puede haber cambiado radicalmente. Siempre verifica la fecha de los datos.

---

### Tu turno

¿Puedes clasificar correctamente diferentes fuentes de datos según su tipo y confiabilidad?

<!-- exercise:db-ex-03 -->

---

**Referencias:**

- Creswell, J.W. (2014). *Research Design: Qualitative, Quantitative, and Mixed Methods Approaches*. SAGE.
- Sackett, D.L. et al. (1996). "Evidence-based medicine: what it is and what it isn't." *BMJ*, 312(7023).
- Wheelan, C. (2013). *Naked Statistics*. W.W. Norton.
- Huff, D. (1954). *How to Lie with Statistics*. W.W. Norton.
