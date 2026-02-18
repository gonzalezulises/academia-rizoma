# El ciclo de decisión basada en datos

### De la pregunta a la acción

Ya sabes que los sesgos cognitivos distorsionan tus decisiones y que no todos los datos son iguales. Ahora necesitas un proceso — un framework que te guíe desde "tengo un problema" hasta "tomé una decisión informada y sé cómo evaluarla".

El ciclo de decisión basada en datos no es un invento reciente. Tiene raíces en el método científico (siglo XVII), el ciclo PDCA de Deming (1950) y la medicina basada en evidencia de Sackett (1996). Lo que hacemos aquí es adaptarlo para decisiones de negocio cotidianas.

---

## Las 5 etapas del ciclo

```
    ┌──────────────┐
    │  1. DEFINIR   │
    │  el problema  │
    └──────┬───────┘
           │
    ┌──────▼───────┐
    │ 2. RECOPILAR │
    │    datos     │
    └──────┬───────┘
           │
    ┌──────▼───────┐
    │ 3. ANALIZAR  │
    │  evidencia   │
    └──────┬───────┘
           │
    ┌──────▼───────┐
    │  4. DECIDIR  │
    │   y actuar   │
    └──────┬───────┘
           │
    ┌──────▼───────┐
    │ 5. EVALUAR   │──── (vuelve a etapa 1)
    │  resultado   │
    └──────────────┘
```

---

### Etapa 1: Definir el problema

La etapa más importante y la más frecuentemente omitida. Einstein supuestamente dijo: "Si tuviera una hora para resolver un problema, dedicaría 55 minutos a definirlo y 5 a resolverlo."

**Qué hacer:**
- Escribir el problema como una **pregunta específica y medible**
- Definir los **criterios de éxito** antes de buscar datos
- Identificar quién es el **tomador de decisión** y cuál es el **deadline**

**Ejemplo malo:** "Nuestras ventas están bajas."
**Ejemplo bueno:** "¿Por qué las ventas del producto X cayeron 15% en el último trimestre vs. el mismo período del año anterior en la región Pacífico?"

La diferencia: la segunda pregunta es específica (producto X), medible (15%), acotada en tiempo (último trimestre vs. año anterior) y en alcance (región Pacífico).

---

### Etapa 2: Recopilar datos

Con la pregunta definida, ahora buscas los datos necesarios — no todos los datos posibles.

**Principio clave:** Recopila los datos que necesitas para responder tu pregunta, no los que tienes disponibles.

| Acción | Descripción |
|---|---|
| Identificar fuentes | ¿Qué datos existen? ¿Son primarios o secundarios? |
| Evaluar calidad | ¿Son actualizados? ¿La muestra es representativa? |
| Llenar vacíos | ¿Qué datos faltan? ¿Vale la pena conseguirlos? |
| Documentar limitaciones | ¿Qué no puedes medir? ¿Qué supuestos estás haciendo? |

**Trampa común:** Recopilar datos indefinidamente para evitar decidir. Recuerda la regla del 70% de Bezos: no necesitas información perfecta.

---

### Etapa 3: Analizar la evidencia

Aquí es donde los datos se convierten en insight. No necesitas ser data scientist — necesitas hacer las preguntas correctas.

**Preguntas de análisis:**
1. ¿Qué dicen los datos sobre mi pregunta original?
2. ¿Los datos confirman o contradicen mi hipótesis inicial?
3. ¿Hay explicaciones alternativas que no he considerado?
4. ¿Los datos son consistentes entre diferentes fuentes?

**Herramientas simples de análisis (sin código):**
- **Comparación temporal:** ¿Cómo era antes vs. ahora?
- **Comparación entre grupos:** ¿Cómo se compara A vs. B?
- **Análisis de tendencias:** ¿La dirección es positiva, negativa o estable?
- **Identificación de outliers:** ¿Hay valores atípicos que distorsionan el promedio?

---

### Etapa 4: Decidir y actuar

La decisión debe ser **explícita, documentada y comunicada**.

**Checklist de decisión:**
- [ ] ¿La decisión responde directamente a la pregunta de la etapa 1?
- [ ] ¿Consideré al menos 2 opciones alternativas?
- [ ] ¿Identifiqué los riesgos principales de cada opción?
- [ ] ¿Definí qué indicadores mediré para saber si la decisión fue correcta?
- [ ] ¿Establecí un plazo para evaluar los resultados?

**Anti-patrón:** "Decidimos seguir monitoreando." Eso no es una decisión — es la ausencia de una. Si después del análisis no hay suficiente evidencia, la decisión debería ser: "No actuamos ahora porque X, revisaremos en Y semanas con datos Z."

---

### Etapa 5: Evaluar el resultado

La etapa que cierra el ciclo y que casi nadie hace.

Philip Tetlock, en *Superforecasting* (2015), demostró que los mejores tomadores de decisiones comparten una característica: **registran sus predicciones y las comparan con la realidad**. Sin este paso, nunca aprendes si tus decisiones son buenas o simplemente tuviste suerte.

**Qué evaluar:**
- ¿Los resultados coincidieron con lo esperado?
- Si no, ¿fue por mala ejecución o por mala decisión?
- ¿Los supuestos que hicimos resultaron correctos?
- ¿Qué haríamos diferente la próxima vez?

**Trampas de la evaluación:**
- **Sesgo de resultado:** Juzgar una decisión por su resultado, no por su proceso. Una buena decisión puede tener mal resultado (y viceversa).
- **Sesgo retrospectivo:** "Yo sabía que iba a pasar" — después del hecho, todo parece obvio.

---

## El ciclo en práctica: ejemplo completo

**Contexto:** Cadena de farmacias en Centroamérica considera abrir domingos.

1. **Definir:** "¿Abrir domingos en nuestras 5 sucursales urbanas generará ingresos netos positivos considerando costos operativos adicionales?"
2. **Recopilar:** Ventas por día de semana (últimos 12 meses), costos de nómina dominical, datos de competidores que abren domingos, encuesta a 200 clientes sobre intención de compra dominical.
3. **Analizar:** Los competidores que abren domingos reportan 12-18% de ventas semanales ese día. Costo dominical: +40% en nómina. Encuesta: 65% dice que compraría en domingo. Margen típico: 28%.
4. **Decidir:** Piloto en 2 sucursales durante 3 meses. Si las ventas dominicales superan el punto de equilibrio ($X por sucursal), expandir.
5. **Evaluar:** A los 3 meses, sucursal A: 22% sobre punto de equilibrio. Sucursal B: 8% bajo punto de equilibrio (zona residencial con menos tráfico). Decisión: expandir a sucursales urbanas-comerciales, no a residenciales.

---

### Tu turno

¿Puedes ordenar correctamente las etapas del ciclo y detectar cuándo se están saltando pasos críticos?

<!-- exercise:db-ex-04 -->

---

**Referencias:**

- Deming, W.E. (1986). *Out of the Crisis*. MIT Press.
- Tetlock, P. & Gardner, D. (2015). *Superforecasting*. Crown.
- Sackett, D.L. et al. (1996). "Evidence-based medicine." *BMJ*, 312(7023).
- Mandinach, E.B. (2012). "A Perfect Time for Data Use." *Educational Psychologist*, 47(2).
