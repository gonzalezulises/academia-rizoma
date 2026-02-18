-- =====================================================
-- Seed: Curso "Toma de Decisiones Basadas en Datos"
-- 3 módulos, 9 lecciones, 9 ejercicios (quizzes)
-- content_source = 'database' (contenido directo en DB)
-- =====================================================

-- 1. Insertar el curso
INSERT INTO courses (id, title, description, slug, thumbnail_url, is_published, content_source, content_status)
VALUES (
  'db000000-0000-0000-0000-000000000001',
  'Toma de Decisiones Basadas en Datos',
  'Aprende a tomar decisiones más efectivas usando evidencia en lugar de intuición. Reconoce sesgos cognitivos, aplica frameworks estructurados y analiza casos reales donde la evidencia cambió el rumbo de una organización. No requiere programación.',
  'decisiones-basadas-datos',
  '/images/courses/decisiones-basadas-datos-hero.webp',
  true,
  'database',
  'published'
)
ON CONFLICT (id) DO UPDATE SET
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  slug = EXCLUDED.slug,
  thumbnail_url = EXCLUDED.thumbnail_url,
  is_published = EXCLUDED.is_published,
  content_source = EXCLUDED.content_source,
  content_status = EXCLUDED.content_status;

-- 2. Insertar los módulos
INSERT INTO modules (id, course_id, title, description, order_index, is_locked)
VALUES
  (
    'db010000-0000-0000-0000-000000000001',
    'db000000-0000-0000-0000-000000000001',
    'De la Intuición a la Evidencia',
    'Descubre por qué la intuición nos engaña más de lo que creemos. Aprende a reconocer sesgos cognitivos, entiende qué significa decidir con datos y clasifica fuentes de información.',
    1,
    false
  ),
  (
    'db020000-0000-0000-0000-000000000001',
    'db000000-0000-0000-0000-000000000001',
    'Frameworks para Decidir con Datos',
    'Pasa de la teoría a la práctica con frameworks estructurados. Domina el ciclo de decisión, distingue métricas accionables de ruido y aplica análisis costo-beneficio.',
    2,
    false
  ),
  (
    'db030000-0000-0000-0000-000000000001',
    'db000000-0000-0000-0000-000000000001',
    'Casos Prácticos',
    'Aplica todo lo aprendido a situaciones reales: expansión de negocio, optimización de recursos y diseño de tu framework personal de decisión.',
    3,
    false
  )
ON CONFLICT (id) DO UPDATE SET
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  order_index = EXCLUDED.order_index;

-- 3. Insertar las lecciones con contenido completo en markdown
-- IMPORTANTE: order_index es GLOBAL para toda la navegación del curso

INSERT INTO lessons (id, course_id, module_id, title, content, lesson_type, order_index, duration_minutes, is_required)
VALUES

-- ─────────────────────────────────────────────────────────────────────
-- MÓDULO 1, LECCIÓN 1: Por qué fallamos al decidir
-- ─────────────────────────────────────────────────────────────────────
(
  'db010100-0000-0000-0000-000000000001',
  'db000000-0000-0000-0000-000000000001',
  'db010000-0000-0000-0000-000000000001',
  'Por qué fallamos al decidir',
  '## Por qué fallamos al decidir

### La ilusión de la buena decisión

Piensa en la última decisión importante que tomaste en tu trabajo. ¿Cuánto de esa decisión fue análisis riguroso y cuánto fue "instinto"?

Daniel Kahneman, premio Nobel de Economía, dedicó 40 años a demostrar algo incómodo: **los seres humanos somos máquinas de generar conclusiones rápidas que confundimos con razonamiento**. En *Thinking, Fast and Slow* (2011), describe dos sistemas de pensamiento:

| Sistema | Características | Ejemplo |
|---|---|---|
| **Sistema 1** (rápido) | Automático, emocional, intuitivo | "Ese candidato me genera confianza" |
| **Sistema 2** (lento) | Deliberado, analítico, costoso | "Comparemos las métricas de los 5 candidatos" |

El problema no es que el Sistema 1 exista — es esencial para sobrevivir. El problema es que lo usamos para decisiones que requieren el Sistema 2, y ni siquiera nos damos cuenta.

---

### Los sesgos cognitivos más peligrosos en decisiones de negocio

Un sesgo cognitivo es un atajo mental que produce errores sistemáticos. No son errores aleatorios — son **predeciblemente irracionales**, como lo describe Dan Ariely en *Predictably Irrational* (2008).

#### 1. Sesgo de confirmación

Buscamos información que confirma lo que ya creemos e ignoramos la que lo contradice.

**Ejemplo LATAM:** Un gerente regional está convencido de que su equipo es el más productivo. Cuando revisa los datos, solo mira las métricas donde lidera (tickets cerrados) e ignora aquellas donde está rezagado (satisfacción del cliente, tiempo de resolución).

> *"El sesgo de confirmación es el padre de todos los sesgos — es la razón por la que los demás sesgos sobreviven."* — Kahneman, 2011

#### 2. Sesgo de anclaje

La primera información que recibimos tiene un peso desproporcionado en nuestras decisiones posteriores.

**Ejemplo:** En una negociación salarial, si el primer número mencionado es $80,000, toda la discusión girará alrededor de ese ancla — aunque el valor de mercado sea $60,000 o $100,000.

#### 3. Sesgo de disponibilidad

Sobrestimamos la probabilidad de eventos que recordamos fácilmente — generalmente los más recientes o dramáticos.

**Ejemplo LATAM:** Después de que un proyecto de expansión fracasa espectacularmente, la junta directiva rechaza toda inversión en nuevos mercados durante 3 años. Un solo caso dramático pesa más que 15 expansiones exitosas previas.

#### 4. Sesgo de supervivencia

Solo vemos los casos que sobrevivieron un proceso y sacamos conclusiones de una muestra incompleta.

**Ejemplo:** "Mira, Steve Jobs abandonó la universidad y fue exitoso, así que los títulos no importan." Esa conclusión ignora a los miles que abandonaron la universidad y no crearon Apple.

#### 5. Efecto Dunning-Kruger

Las personas con menor competencia en un área tienden a sobreestimar su habilidad, mientras que los expertos tienden a subestimarse.

**Implicación para decisiones:** Los equipos con menos experiencia en un mercado suelen ser los más confiados en sus proyecciones.

---

### ¿Por qué importa esto en las organizaciones?

McKinsey publicó en 2019 un estudio con 1,048 decisiones de negocio y encontró que **reducir sesgos cognitivos en el proceso de decisión mejoraba los resultados en un 20%** — más que la calidad del análisis mismo.

| Factor | Impacto en ROI |
|---|---|
| Más datos y mejor análisis | +8% |
| Proceso de decisión sin sesgos | +20% |
| Ambos combinados | +25% |

---

### Tu turno

<!-- exercise:db-ex-01 -->

---

**Referencias:**

- Kahneman, D. (2011). *Thinking, Fast and Slow*. Farrar, Straus and Giroux.
- Ariely, D. (2008). *Predictably Irrational*. Harper Perennial.
- Tversky, A. & Kahneman, D. (1974). "Judgment under Uncertainty: Heuristics and Biases." *Science*.
- Lovallo, D. & Sibony, O. (2010). "The case for behavioral strategy." *McKinsey Quarterly*.',
  'text',
  1,
  20,
  true
),

-- ─────────────────────────────────────────────────────────────────────
-- MÓDULO 1, LECCIÓN 2: ¿Qué significa decidir con datos?
-- ─────────────────────────────────────────────────────────────────────
(
  'db010200-0000-0000-0000-000000000001',
  'db000000-0000-0000-0000-000000000001',
  'db010000-0000-0000-0000-000000000001',
  '¿Qué significa decidir con datos?',
  '## ¿Qué significa decidir con datos?

### No es lo que crees

"Somos una empresa data-driven." Si tuvieras un dólar por cada organización que dice esto sin serlo, probablemente no necesitarías este curso.

Decidir con datos **no** es:
- Hacer un dashboard bonito y revisarlo en la reunión semanal
- Pedir un reporte para justificar una decisión ya tomada
- Agregar números a una presentación para que parezca más seria

Decidir con datos **sí** es:
- Formular una pregunta antes de buscar la respuesta
- Estar dispuesto a cambiar de opinión si la evidencia contradice tu hipótesis
- Tener un proceso estructurado que reduce sesgos cognitivos

---

### El espectro de la toma de decisiones

| Nivel | Descripción | Ejemplo |
|---|---|---|
| **0 — Intuición pura** | "Lo siento en el estómago" | "Creo que deberíamos expandirnos a Colombia" |
| **1 — Opinión informada** | Experiencia + algo de información | "He trabajado en 3 mercados similares" |
| **2 — Datos descriptivos** | Datos del pasado, sin análisis causal | "Las ventas en mercados similares crecieron 15%" |
| **3 — Análisis causal** | Entender por qué pasan las cosas | "El crecimiento correlaciona con ingreso per cápita > $8K" |
| **4 — Decisión basada en evidencia** | Datos + framework + mitigación de sesgos | "El modelo muestra 73% de probabilidad de éxito" |

---

### Anatomía de una decisión con datos vs. sin datos

**Escenario: ¿Renovamos el contrato con el proveedor de logística?**

**Sin datos (nivel 0-1):**
1. El gerente dice: "Siempre hemos trabajado con ellos"
2. El director financiero dice: "Son caros"
3. Se decide por quién argumenta con más convicción
4. No se documenta el razonamiento

**Con datos (nivel 3-4):**
1. Se define la pregunta: "¿El proveedor actual maximiza costo/calidad vs. alternativas?"
2. Se recopilan datos: costo por envío, entregas a tiempo, tasa de daños
3. Se compara con benchmarks y cotizaciones alternativas
4. Se analiza: 94% entregas a tiempo (mercado: 89%) pero 18% más caro
5. Se calcula si el sobrecosto se justifica
6. Se documenta y se programa revisión en 6 meses

La diferencia: la segunda es **auditable, repetible y mejorable**.

---

### Decisiones reversibles vs. irreversibles

Jeff Bezos distingue entre:

| Tipo | Característica | Enfoque |
|---|---|---|
| **Puerta de un sentido** | Difícil de revertir | Análisis riguroso |
| **Puerta de dos sentidos** | Fácil de revertir | Decide rápido, itera |

El error más común: tratar todas las decisiones como puertas de un sentido, creando burocracia innecesaria.

---

### Tu turno

<!-- exercise:db-ex-02 -->

---

**Referencias:**

- Martin, R. & Lafley, A.G. (2013). *Playing to Win*. Harvard Business Review Press.
- Bezos, J. (2016). Carta a accionistas de Amazon.
- Davenport, T.H. (2006). "Competing on Analytics." *Harvard Business Review*.',
  'text',
  2,
  15,
  true
),

-- ─────────────────────────────────────────────────────────────────────
-- MÓDULO 1, LECCIÓN 3: Tipos de datos y fuentes de información
-- ─────────────────────────────────────────────────────────────────────
(
  'db010300-0000-0000-0000-000000000001',
  'db000000-0000-0000-0000-000000000001',
  'db010000-0000-0000-0000-000000000001',
  'Tipos de datos y fuentes de información',
  '## Tipos de datos y fuentes de información

### No todos los datos son iguales

"Los datos no mienten." Esa frase es peligrosamente incompleta. Los datos no mienten, pero **pueden engañar** — depende de qué datos, de dónde vienen y cómo se recopilaron.

---

### Datos cuantitativos vs. cualitativos

| Dimensión | Cuantitativos | Cualitativos |
|---|---|---|
| **Qué miden** | Cantidades, frecuencias | Percepciones, motivaciones |
| **Formato** | Números, porcentajes | Texto, entrevistas |
| **Pregunta** | ¿Cuánto? ¿Con qué frecuencia? | ¿Por qué? ¿Cómo se siente? |
| **Ejemplo** | "32% abandona en el checkout" | "El formulario es confuso" |
| **Fortaleza** | Objetividad, escalabilidad | Profundidad, contexto |
| **Debilidad** | No explica el *por qué* | Difícil de generalizar |

**Principio clave:** Los cuantitativos dicen *qué* pasa. Los cualitativos dicen *por qué*. Las mejores decisiones combinan ambos.

---

### Fuentes primarias vs. secundarias

**Fuentes primarias:** Datos que tú recopilaste directamente para tu pregunta.
- Encuestas propias, entrevistas, datos de tu ERP, A/B tests, observación directa.

**Fuentes secundarias:** Datos recopilados por otros para otros propósitos.
- Reportes de industria, datos gubernamentales, estudios académicos, benchmarks.

---

### La pirámide de confiabilidad

```
         ▲
        / \
       / 1 \     Experimentos controlados (A/B tests)
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

---

### Errores comunes al evaluar datos

1. **Confundir correlación con causalidad** — "Países con más chocolate ganan más Nobel" (ambos correlacionan con PIB).

2. **Sesgo de selección** — "95% de nuestros clientes están satisfechos" (¿encuestaste a los que cancelaron?).

3. **Tamaño de muestra insuficiente** — "5 clientes prefieren el producto azul" (irrelevante estadísticamente).

4. **Datos desactualizados** — "Según el censo de 2010..." (15 años de cambios ignorados).

---

### Tu turno

<!-- exercise:db-ex-03 -->

---

**Referencias:**

- Creswell, J.W. (2014). *Research Design*. SAGE.
- Sackett, D.L. et al. (1996). "Evidence-based medicine." *BMJ*.
- Wheelan, C. (2013). *Naked Statistics*. W.W. Norton.',
  'text',
  3,
  15,
  true
),

-- ─────────────────────────────────────────────────────────────────────
-- MÓDULO 2, LECCIÓN 4: El ciclo de decisión basada en datos
-- ─────────────────────────────────────────────────────────────────────
(
  'db020100-0000-0000-0000-000000000001',
  'db000000-0000-0000-0000-000000000001',
  'db020000-0000-0000-0000-000000000001',
  'El ciclo de decisión basada en datos',
  '## El ciclo de decisión basada en datos

### De la pregunta a la acción

Ya sabes que los sesgos distorsionan tus decisiones y que no todos los datos son iguales. Ahora necesitas un proceso — un framework que te guíe desde "tengo un problema" hasta "tomé una decisión informada".

---

### Las 5 etapas del ciclo

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

#### Etapa 1: Definir el problema

La etapa más importante y la más frecuentemente omitida.

**Ejemplo malo:** "Nuestras ventas están bajas."
**Ejemplo bueno:** "¿Por qué las ventas del producto X cayeron 15% en el último trimestre vs. el mismo período del año anterior en la región Pacífico?"

La segunda es específica, medible, acotada en tiempo y alcance.

---

#### Etapa 2: Recopilar datos

Recopila los datos que necesitas para responder tu pregunta, no los que tienes disponibles.

**Trampa común:** Recopilar datos indefinidamente para evitar decidir. Recuerda la regla del 70%.

---

#### Etapa 3: Analizar la evidencia

Preguntas clave:
1. ¿Qué dicen los datos sobre mi pregunta original?
2. ¿Confirman o contradicen mi hipótesis?
3. ¿Hay explicaciones alternativas?
4. ¿Son consistentes entre fuentes?

---

#### Etapa 4: Decidir y actuar

**Anti-patrón:** "Decidimos seguir monitoreando." Eso no es una decisión — es la ausencia de una.

**Checklist:**
- ¿Responde a la pregunta de la etapa 1?
- ¿Consideré al menos 2 alternativas?
- ¿Definí indicadores para medir si fue correcta?
- ¿Establecí plazo de evaluación?

---

#### Etapa 5: Evaluar el resultado

Philip Tetlock demostró en *Superforecasting* (2015) que los mejores tomadores de decisiones **registran sus predicciones y las comparan con la realidad**.

**Trampas:**
- **Sesgo de resultado:** Juzgar por el resultado, no por el proceso.
- **Sesgo retrospectivo:** "Yo sabía que iba a pasar."

---

### El ciclo en práctica

**Cadena de farmacias evalúa abrir domingos:**

1. **Definir:** "¿Abrir domingos en 5 sucursales urbanas generará ingresos netos positivos?"
2. **Recopilar:** Ventas por día, costos de nómina dominical, datos de competidores, encuesta a 200 clientes.
3. **Analizar:** Competidores reportan 12-18% de ventas el domingo. Costo +40% nómina. 65% de clientes dice que compraría.
4. **Decidir:** Piloto en 2 sucursales durante 3 meses.
5. **Evaluar:** Sucursal A: +22% sobre equilibrio. Sucursal B: -8%. Expandir solo a sucursales comerciales.

---

### Tu turno

<!-- exercise:db-ex-04 -->

---

**Referencias:**

- Deming, W.E. (1986). *Out of the Crisis*. MIT Press.
- Tetlock, P. & Gardner, D. (2015). *Superforecasting*. Crown.',
  'text',
  4,
  20,
  true
),

-- ─────────────────────────────────────────────────────────────────────
-- MÓDULO 2, LECCIÓN 5: Métricas que importan vs. ruido
-- ─────────────────────────────────────────────────────────────────────
(
  'db020200-0000-0000-0000-000000000001',
  'db000000-0000-0000-0000-000000000001',
  'db020000-0000-0000-0000-000000000001',
  'Métricas que importan vs. ruido',
  '## Métricas que importan vs. ruido

### El problema de medir todo

"Lo que no se mide, no se gestiona." Esta frase se ha convertido en una excusa para medir absolutamente todo. El resultado: dashboards con 50+ indicadores que nadie lee y una falsa sensación de control.

La pregunta correcta no es "¿qué podemos medir?" sino **"¿qué necesitamos saber para decidir?"**

---

### Métricas accionables vs. decorativas

| Característica | Accionable | Decorativa |
|---|---|---|
| **Umbral** | "Si supera X, hacemos Y" | "La monitoreamos" |
| **Dueño** | Una persona responsable | Se presenta "al equipo" |
| **Frecuencia** | Se revisa cuando se puede actuar | Se revisa por ritual |
| **Conexión** | Responde una pregunta | "Es interesante" |

**Test rápido:** ¿Qué harías diferente si este número cambia 20%? Si la respuesta es "nada", es decorativa.

---

### Vanity metrics

Eric Ries (*The Lean Startup*, 2011) acuñó el término **vanity metrics** — números que se ven impresionantes pero no informan decisiones.

| Vanity metric | Alternativa accionable |
|---|---|
| 100,000 usuarios registrados | Usuarios activos mensuales |
| 500,000 visitas al sitio | Tasa de conversión por canal |
| 200 story points completados | Cycle time de features |

---

### Indicadores adelantados vs. rezagados

| Tipo | Definición | Ejemplo |
|---|---|---|
| **Rezagado** (lagging) | Mide el resultado final | Ingresos trimestrales |
| **Adelantado** (leading) | Predice el resultado futuro | Pipeline de ventas |

**Error común:** El 80% de los dashboards ejecutivos solo tienen indicadores rezagados. Cuando ves que los ingresos cayeron, ya es tarde.

---

### ¿Cuántas métricas necesitas?

| Nivel | Recomendado |
|---|---|
| Equipo operativo | 3-5 |
| Unidad de negocio | 5-8 |
| Nivel ejecutivo | 8-12 |

**Test de Bernard Marr:** Si una métrica desaparece de tu dashboard durante 3 semanas y nadie pregunta, elimínala.

---

### Tu turno

<!-- exercise:db-ex-05 -->

---

**Referencias:**

- Ries, E. (2011). *The Lean Startup*. Crown Business.
- Kaplan, R.S. & Norton, D.P. (1996). *The Balanced Scorecard*. Harvard Business Press.
- Marr, B. (2015). *Key Performance Indicators*. Pearson.',
  'text',
  5,
  20,
  true
),

-- ─────────────────────────────────────────────────────────────────────
-- MÓDULO 2, LECCIÓN 6: Análisis costo-beneficio simplificado
-- ─────────────────────────────────────────────────────────────────────
(
  'db020300-0000-0000-0000-000000000001',
  'db000000-0000-0000-0000-000000000001',
  'db020000-0000-0000-0000-000000000001',
  'Análisis costo-beneficio simplificado',
  '## Análisis costo-beneficio simplificado

### No necesitas un MBA para esto

La pregunta fundamental: **¿Lo que gano supera lo que pierdo?** Lo difícil no es la matemática — es identificar correctamente todos los costos y beneficios.

---

### Los 4 tipos de costos

**1. Costos directos** — Lo que pagas explícitamente (salario, software, equipo).

**2. Costos indirectos** — Consecuencias no facturadas (tiempo de manager en onboarding, productividad reducida).

**3. Costo de oportunidad** — Lo que dejas de ganar al elegir esta opción. *"El concepto más importante de la economía y el más ignorado en las decisiones de negocio."* — Mankiw

**4. Costos hundidos** — Lo que ya gastaste y NO puedes recuperar. **No deben influir en decisiones futuras**, pero casi siempre lo hacen.

---

### Framework ACB simplificado

**Paso 1:** Lista mínimo 3 opciones (incluyendo status quo)

**Paso 2:** Cuantifica costos y beneficios

| Concepto | Opción A | Opción B | Status quo |
|---|---|---|---|
| Costos directos | $X | $Y | $0 |
| Costos indirectos | $X | $Y | $Z |
| Costo de oportunidad | ... | ... | ... |
| Beneficios esperados | $X | $Y | $0 |
| **Beneficio neto** | B - C | B - C | B - C |

**Paso 3:** Ajusta por incertidumbre con 3 escenarios

| Escenario | Beneficio | Probabilidad | Ajustado |
|---|---|---|---|
| Optimista | $200K | 20% | $40K |
| Probable | $120K | 60% | $72K |
| Pesimista | $50K | 20% | $10K |
| **Valor esperado** | | | **$122K** |

**Paso 4:** Considera factores no cuantificables (riesgo reputacional, moral del equipo, alineación estratégica, reversibilidad).

---

### Errores frecuentes

| Error | Cómo evitarlo |
|---|---|
| Ignorar costos indirectos | "¿Qué más consume esto?" |
| Omitir status quo | Siempre incluir "no actuar" |
| Costos hundidos | "Si empezara de cero, ¿lo haría?" |
| Sobreestimar beneficios | Usar 3 escenarios |
| Horizonte inadecuado | Evaluar 3-5 años para inversiones |

---

### Tu turno

<!-- exercise:db-ex-06 -->

---

**Referencias:**

- Mankiw, N.G. (2020). *Principles of Economics*. Cengage.
- Arkes, H.R. & Blumer, C. (1985). "The psychology of sunk cost." *OBHDP*.
- Thaler, R.H. (2015). *Misbehaving*. W.W. Norton.',
  'text',
  6,
  15,
  true
),

-- ─────────────────────────────────────────────────────────────────────
-- MÓDULO 3, LECCIÓN 7: Caso — ¿Abrimos una nueva sucursal?
-- ─────────────────────────────────────────────────────────────────────
(
  'db030100-0000-0000-0000-000000000001',
  'db000000-0000-0000-0000-000000000001',
  'db030000-0000-0000-0000-000000000001',
  'Caso: ¿Abrimos una nueva sucursal?',
  '## Caso: ¿Abrimos una nueva sucursal?

### El contexto

Distribuidora del Istmo: 3 ciudades en Centroamérica, 120 empleados, $12M anuales. El CEO propone abrir en San Pedro Sula porque visitó la zona y la vio "desatendida".

---

### Datos internos

| Métrica | Ciudad A | Ciudad B | Ciudad C |
|---|---|---|---|
| Año de apertura | 2018 | 2020 | 2022 |
| Ingresos anuales | $5.2M | $4.1M | $2.7M |
| Margen bruto | 28% | 26% | 22% |
| Punto de equilibrio | Mes 14 | Mes 18 | Mes 24 (aún no) |
| Clientes activos | 340 | 280 | 165 |
| NPS | 62 | 58 | 45 |
| Rotación personal | 12% | 15% | 28% |

**Ciudad C lleva 3 años sin alcanzar punto de equilibrio.**

### Datos del mercado (San Pedro Sula)

- Población: 920,000 (zona metropolitana)
- PIB per cápita: $3,200 (vs. $4,100 promedio ciudades actuales)
- Competidores: 4 locales + 2 nacionales
- Penetración: 78% del mercado ya cubierto
- Inversión requerida: $350,000
- Costo operativo mensual: $45,000
- Ingreso mensual optimista: $60,000
- Ingreso mensual conservador: $35,000

---

### Análisis aplicando el ciclo

**Pregunta correcta:** "¿Invertir $350K + $45K/mes en San Pedro Sula genera más valor que las alternativas?"

**Opciones:**
- A: Abrir en San Pedro Sula
- B: Invertir $350K en fortalecer Ciudad C
- C: No expandir

**A favor de expandir:** Mercado de 920K habitantes, 30% de negocios abiertos a cambiar de distribuidor.

**En contra:** PIB per cápita 22% menor, mercado con 78% penetración (no es "desatendido"), Ciudad C sin punto de equilibrio, equipo al límite, escenario conservador genera pérdidas.

**Señales de alarma:** CEO formó opinión en visita de 2 días (sesgo de disponibilidad). "Competencia débil" no sustentado por datos.

### ACB comparativo

| Concepto | San Pedro Sula | Fortalecer Ciudad C | Status quo |
|---|---|---|---|
| Inversión | $350,000 | $200,000 | $0 |
| Punto equilibrio | 18-30 meses | 6-12 meses | N/A |
| Beneficio neto 3 años | -$80K a +$190K | +$340K | $0 |

**Recomendación:** Fortalecer Ciudad C tiene mejor perfil riesgo-retorno. Reconsiderar San Pedro Sula en 12-18 meses.

---

### Tu turno

<!-- exercise:db-ex-07 -->

---

**Referencias:**

- Porter, M.E. (2008). "The Five Competitive Forces." *HBR*.
- Christensen, C.M. (1997). *The Innovator''s Dilemma*. HBR Press.',
  'text',
  7,
  20,
  true
),

-- ─────────────────────────────────────────────────────────────────────
-- MÓDULO 3, LECCIÓN 8: Caso — ¿Reducimos o reasignamos personal?
-- ─────────────────────────────────────────────────────────────────────
(
  'db030200-0000-0000-0000-000000000001',
  'db000000-0000-0000-0000-000000000001',
  'db030000-0000-0000-0000-000000000001',
  'Caso: ¿Reducimos o reasignamos personal?',
  '## Caso: ¿Reducimos o reasignamos personal?

### El contexto

TechServ Panamá: 85 empleados, servicios de tecnología. Después de 2 años de crecimiento (contrataron 30 personas), ingresos estancados y costos de nómina +40%. El director financiero: "Si no reducimos personal en 20% ($180K), estaremos en rojo en 6 meses."

---

### Estructura por departamento

| Depto | Personas | Costo anual | Ingreso | Ratio |
|---|---|---|---|---|
| Desarrollo | 25 | $450K | $1.2M | 2.67 |
| Soporte | 20 | $280K | $400K | 1.43 |
| Ventas | 12 | $240K | $800K | 3.33 |
| Administración | 10 | $160K | $0 | 0 |
| Marketing | 8 | $140K | $200K | 1.43 |
| Capacitación | 5 | $90K | $50K | 0.56 |
| Innovación | 5 | $100K | $0 | 0 |

### Datos de productividad

| Depto | Utilización | Backlog |
|---|---|---|
| Desarrollo | 92% | 8 semanas |
| Soporte | 75% | 2 días |
| Capacitación | 45% | 0 |
| Innovación | 60% | N/A |

**Dato clave del líder de ventas:** "Con 3 vendedores más, podría cerrar $400K en pipeline."

---

### Opción A: Despedir 12 personas

Ahorro bruto: $180K/año. Liquidaciones (Panamá): ~$90K. Ahorro neto año 1: ~$90K.

**Costos ocultos:** Productividad cae 15-20% por 3-6 meses en sobrevivientes. Pérdida de conocimiento. Señal negativa al mercado laboral.

### Opción B: Reasignar personal

| De → A | Personas | Lógica |
|---|---|---|
| Capacitación → Ventas | 2 | Habilidades de presentación, pipeline de $400K |
| Capacitación → Soporte premium | 1 | Trainers de clientes |
| Soporte → Pre-venta técnica | 3 | Conocimiento técnico + contacto clientes |
| Innovación → Desarrollo | 3 | Habilidades técnicas compatibles |
| Admin → Soporte de ventas | 1 | CRM, propuestas |

Inversión: $40K (capacitación de transición). Ingreso adicional estimado: $300-500K/año.

### La trampa del análisis simplista

Si solo miras los números fríos, despedir parece directo. Pero ignoras:
1. Liquidaciones cuestan casi lo que ahorras en año 1
2. Productividad de sobrevivientes cae por meses
3. Si la demanda vuelve, no puedes escalar
4. **El problema real es de ingresos, no de costos**

La reasignación aborda la causa raíz: personas ociosas en áreas sin ingreso, mientras hay demanda insatisfecha donde sí lo generan.

---

### Tu turno

<!-- exercise:db-ex-08 -->

---

**Referencias:**

- Cascio, W.F. (2018). *Managing Human Resources*. McGraw-Hill.
- Cameron, K.S. (1994). "Strategies for successful organizational downsizing." *HRM*.',
  'text',
  8,
  20,
  true
),

-- ─────────────────────────────────────────────────────────────────────
-- MÓDULO 3, LECCIÓN 9: Diseñando tu framework de decisión
-- ─────────────────────────────────────────────────────────────────────
(
  'db030300-0000-0000-0000-000000000001',
  'db000000-0000-0000-0000-000000000001',
  'db030000-0000-0000-0000-000000000001',
  'Diseñando tu framework de decisión',
  '## Diseñando tu framework de decisión

### De aprender a aplicar

A lo largo de este curso aprendiste a identificar sesgos, clasificar datos, usar el ciclo de decisión, evaluar métricas y realizar ACB. Ahora integra todo en un **framework personal**.

---

### Los 7 componentes

#### 1. Clasificación de la decisión

| Dimensión | Si es alto → |
|---|---|
| **Impacto** | Más análisis |
| **Reversibilidad** | Menos análisis si es reversible |
| **Urgencia** | Adaptar profundidad al tiempo |
| **Incertidumbre** | Buscar más datos o pilotar |

#### 2. Definición estructurada

```
DECISIÓN: [Pregunta específica y medible]
CONTEXTO: [Por qué surge ahora]
CRITERIOS: [Qué define éxito — máximo 3-5]
DEADLINE: [Cuándo se debe decidir]
DUEÑO: [Quién decide, quién ejecuta]
OPCIONES: [Mínimo 3, incluyendo status quo]
```

#### 3. Recopilación con time-box

| Tipo de decisión | Time-box |
|---|---|
| Operativa | 1-2 días |
| Táctica | 1-2 semanas |
| Estratégica | 2-4 semanas |

#### 4. Checklist anti-sesgos

- ¿Busqué información que contradiga mi hipótesis?
- ¿El primer dato está influyendo desproporcionadamente?
- ¿Estoy dando peso excesivo a un evento reciente?
- ¿Estoy considerando los casos que NO veo?
- ¿Incluyo costos hundidos en mi razonamiento?

Annie Duke (*Thinking in Bets*, 2018): "Si un colega inteligente tomara la decisión opuesta, ¿qué razones tendría?"

#### 5. Matriz de decisión ponderada

| Criterio | Peso | Opción A | Opción B | Status quo |
|---|---|---|---|---|
| Costo (3 años) | 40% | 8/10 | 6/10 | 5/10 |
| Productividad | 35% | 5/10 | 7/10 | 7/10 |
| Riesgo | 25% | 4/10 | 7/10 | 9/10 |
| **Score** | | **5.95** | **6.55** | **6.60** |

**Los pesos se definen ANTES de evaluar opciones.**

#### 6. Documentación

```
DECISIÓN TOMADA: [Qué]
DATOS CLAVE: [Top 3]
SUPUESTOS: [Qué asumimos]
INDICADOR DE ÉXITO: [Cómo sabremos si funcionó]
FECHA DE REVISIÓN: [Cuándo evaluaremos]
```

#### 7. Revisión y aprendizaje

Gary Klein (Pre-mortem, 2007): "Imagina que estamos en el futuro y esta decisión fracasó. ¿Qué salió mal?"

---

### Framework integrado

```
1. CLASIFICAR → 2. DEFINIR → 3. RECOPILAR
→ 4. VERIFICAR SESGOS → 5. EVALUAR
→ 6. DOCUMENTAR → 7. REVISAR
```

Lo importante es que **tengas un proceso**. Un proceso imperfecto pero consistente produce mejores decisiones que la intuición brillante pero inconsistente.

---

### Tu turno

<!-- exercise:db-ex-09 -->

---

**Referencias:**

- Duke, A. (2018). *Thinking in Bets*. Portfolio/Penguin.
- Klein, G. (2007). "Performing a Project Premortem." *HBR*.
- Kahneman, D., Sibony, O. & Sunstein, C.R. (2021). *Noise*. Little, Brown Spark.',
  'text',
  9,
  20,
  true
)

ON CONFLICT (id) DO UPDATE SET
  title = EXCLUDED.title,
  content = EXCLUDED.content,
  lesson_type = EXCLUDED.lesson_type,
  order_index = EXCLUDED.order_index,
  duration_minutes = EXCLUDED.duration_minutes;

-- 4. Insertar ejercicios (quizzes) en course_exercises

-- Quiz 1: Identifica el sesgo cognitivo (Lección 1.1)
INSERT INTO course_exercises (id, course_id, module_id, lesson_id, exercise_id, exercise_type, exercise_data, order_index)
VALUES (
  gen_random_uuid(),
  'db000000-0000-0000-0000-000000000001',
  'db010000-0000-0000-0000-000000000001',
  'db010100-0000-0000-0000-000000000001',
  'db-ex-01',
  'quiz',
  '{
    "id": "db-ex-01",
    "title": "Identifica el sesgo cognitivo",
    "description": "Pon a prueba tu capacidad para reconocer los sesgos cognitivos más comunes en situaciones reales de negocio.",
    "questions": [
      {
        "question": "Un gerente lee un artículo sobre una startup que creció 300% con marketing en TikTok. Propone destinar el 50% del presupuesto a TikTok, ignorando que su público tiene 45-60 años. ¿Qué sesgo opera?",
        "options": ["Sesgo de confirmación", "Sesgo de disponibilidad", "Sesgo de anclaje", "Sesgo de supervivencia"],
        "correct": 1,
        "explanation": "El caso reciente y dramático (300% de crecimiento) está más disponible en su mente y lo lleva a sobreestimar la probabilidad de que funcione para su contexto."
      },
      {
        "question": "Una directora de RRHH convencida de que el teletrabajo reduce productividad revisa un estudio con resultados mixtos, pero solo cita las secciones que confirman su posición. ¿Qué sesgo opera?",
        "options": ["Sesgo de confirmación", "Efecto Dunning-Kruger", "Sesgo de supervivencia", "Sesgo de anclaje"],
        "correct": 0,
        "explanation": "Busca y selecciona información que confirma su creencia preexistente, ignorando evidencia contradictoria del mismo estudio."
      },
      {
        "question": "En una negociación, el proveedor dice que el precio ''normal'' es $50,000. Acuerdan $38,000 y celebran. Nadie investigó el precio de mercado real ($25,000). ¿Qué sesgo opera?",
        "options": ["Sesgo de disponibilidad", "Sesgo de confirmación", "Sesgo de anclaje", "Efecto Dunning-Kruger"],
        "correct": 2,
        "explanation": "El precio inicial de $50,000 funcionó como ancla. Toda la negociación giró alrededor de ese número, y $38,000 pareció razonable solo vs. el ancla, no vs. el mercado."
      },
      {
        "question": "Un inversionista analiza 10 startups exitosas, nota que todas tenían fundadores < 30 años, y solo invierte en jóvenes. No analizó las miles que fracasaron. ¿Qué sesgo opera?",
        "options": ["Sesgo de confirmación", "Sesgo de anclaje", "Sesgo de disponibilidad", "Sesgo de supervivencia"],
        "correct": 3,
        "explanation": "Solo analizó los casos que ''sobrevivieron'' (exitosas) e ignoró la base completa. Las conclusiones de una muestra de sobrevivientes son fundamentalmente engañosas."
      },
      {
        "question": "Un analista junior de 3 meses presenta proyecciones con total certeza: ''Creceremos 40%, sin duda.'' Los directores con 15 años son mucho más cautelosos. ¿Qué efecto se observa?",
        "options": ["Sesgo de disponibilidad", "Efecto Dunning-Kruger", "Sesgo de anclaje", "Sesgo de confirmación"],
        "correct": 1,
        "explanation": "Efecto Dunning-Kruger: la persona con menos experiencia sobreestima su capacidad de predicción, mientras los expertos son más cautelosos."
      },
      {
        "question": "Después de que un cliente cancela por ''problemas de calidad'', la empresa gasta $200K en control de calidad. Los datos muestran tasa de defectos de 0.5% (industria: 2%) y que la cancelación fue por cambio de proveedor del cliente. ¿Qué sesgo operó?",
        "options": ["Sesgo de supervivencia", "Efecto Dunning-Kruger", "Sesgo de disponibilidad", "Sesgo de anclaje"],
        "correct": 2,
        "explanation": "Un evento reciente y emocionalmente impactante llevó a sobreestimar un problema que los datos no respaldan."
      }
    ],
    "passing_score": 50,
    "exercise_type": "quiz",
    "difficulty": "beginner",
    "estimated_duration_minutes": 5
  }'::jsonb,
  1
)
ON CONFLICT (course_id, exercise_id) DO UPDATE SET
  exercise_data = EXCLUDED.exercise_data,
  lesson_id = EXCLUDED.lesson_id;

-- Quiz 2: Decisión con datos vs. sin datos (Lección 1.2)
INSERT INTO course_exercises (id, course_id, module_id, lesson_id, exercise_id, exercise_type, exercise_data, order_index)
VALUES (
  gen_random_uuid(),
  'db000000-0000-0000-0000-000000000001',
  'db010000-0000-0000-0000-000000000001',
  'db010200-0000-0000-0000-000000000001',
  'db-ex-02',
  'quiz',
  '{
    "id": "db-ex-02",
    "title": "¿Con datos o sin datos?",
    "description": "Identifica si las decisiones están genuinamente basadas en datos o son intuición disfrazada de análisis.",
    "questions": [
      {
        "question": "El CEO decide expandir porque ''3 competidores se expandieron y les fue bien''. No consultó datos de mercado ni costos de entrada.",
        "options": ["Decisión basada en datos", "Intuición disfrazada de análisis"],
        "correct": 1,
        "explanation": "Citar lo que hicieron 3 competidores no es análisis — es usar una anécdota para justificar una decisión ya tomada."
      },
      {
        "question": "Marketing realiza A/B test con 5,000 usuarios durante 2 semanas. Diseño B aumenta conversión 12% (p < 0.05). Implementan diseño B.",
        "options": ["Decisión basada en datos", "Intuición disfrazada de análisis"],
        "correct": 0,
        "explanation": "Experimento controlado, muestra adecuada, resultado significativo y acción directa basada en el resultado. Nivel 4 del espectro."
      },
      {
        "question": "La junta revisa 45 indicadores durante 2 horas. Al final, el CEO dice ''los números se ven bien'' y no se toma ninguna acción.",
        "options": ["Decisión basada en datos", "Intuición disfrazada de análisis"],
        "correct": 1,
        "explanation": "Teatro de datos: ritual de revisión sin decisiones, sin umbrales, sin acciones. Los datos decoran la reunión sin cambiar comportamiento."
      },
      {
        "question": "Para lanzar un producto, realizan 200 encuestas, analizan 3 años de ventas de productos similares, consultan benchmarks y modelan 3 escenarios. Lanzan con un piloto limitado.",
        "options": ["Decisión basada en datos", "Intuición disfrazada de análisis"],
        "correct": 0,
        "explanation": "Múltiples fuentes, análisis de escenarios y una decisión prudente (piloto) que permite validar antes de escalar."
      },
      {
        "question": "El director financiero prepara 30 páginas justificando cerrar una línea de negocio. Cuando preguntan por alternativas, dice ''esa opción no es viable'' sin datos.",
        "options": ["Decisión basada en datos", "Intuición disfrazada de análisis"],
        "correct": 1,
        "explanation": "30 páginas evaluando solo la opción preferida y descartando alternativas sin datos es sesgo de confirmación con formato profesional."
      }
    ],
    "passing_score": 60,
    "exercise_type": "quiz",
    "difficulty": "beginner",
    "estimated_duration_minutes": 4
  }'::jsonb,
  2
)
ON CONFLICT (course_id, exercise_id) DO UPDATE SET
  exercise_data = EXCLUDED.exercise_data,
  lesson_id = EXCLUDED.lesson_id;

-- Quiz 3: Clasifica la fuente de datos (Lección 1.3)
INSERT INTO course_exercises (id, course_id, module_id, lesson_id, exercise_id, exercise_type, exercise_data, order_index)
VALUES (
  gen_random_uuid(),
  'db000000-0000-0000-0000-000000000001',
  'db010000-0000-0000-0000-000000000001',
  'db010300-0000-0000-0000-000000000001',
  'db-ex-03',
  'quiz',
  '{
    "id": "db-ex-03",
    "title": "Clasifica la fuente de datos",
    "description": "Evalúa tu comprensión de los tipos de datos, fuentes de información y su nivel de confiabilidad.",
    "questions": [
      {
        "question": "Una empresa realiza 15 entrevistas en profundidad con clientes que cancelaron. ¿Qué tipo de datos obtiene principalmente?",
        "options": ["Cuantitativos primarios", "Cualitativos primarios", "Cuantitativos secundarios", "Cualitativos secundarios"],
        "correct": 1,
        "explanation": "Cualitativos (entrevistas, motivaciones) y primarios (recopilados directamente por la empresa para su pregunta específica)."
      },
      {
        "question": "''Los países que consumen más helado tienen más ahogamientos.'' Alguien concluye que el helado causa ahogamientos. ¿Qué error comete?",
        "options": ["Sesgo de selección", "Muestra insuficiente", "Confundir correlación con causalidad", "Datos desactualizados"],
        "correct": 2,
        "explanation": "Ambas variables correlacionan con temperatura/verano. El helado no causa ahogamientos — comparten una tercera variable."
      },
      {
        "question": "Para evaluar expansión, una empresa usa: censo (2 años), reporte de Euromonitor, y datos de su CRM. ¿Cuál tiene mayor confiabilidad según la pirámide?",
        "options": ["El censo nacional", "El reporte de Euromonitor", "Los datos del CRM propio", "Todas igual"],
        "correct": 2,
        "explanation": "Los datos operativos propios (CRM) son nivel 2: verificables y específicos a tu contexto. Censo y Euromonitor son fuentes secundarias (niveles 3-4)."
      },
      {
        "question": "Una encuesta de satisfacción por email tiene 12% de respuesta. 92% de los que respondieron están satisfechos. ¿El principal problema?",
        "options": ["Datos cualitativos, no cuantitativos", "Sesgo de selección — los insatisfechos no respondieron", "Debió ser por teléfono", "Falta comparar con benchmarks"],
        "correct": 1,
        "explanation": "Con 12% de respuesta, la muestra no es representativa. Los satisfechos son más propensos a responder. El 88% restante podría opinar muy diferente."
      },
      {
        "question": "Un CEO dice en LinkedIn: ''En mi experiencia, empresas con trabajo remoto son 30% más productivas.'' Sin citar estudios. ¿Nivel de la pirámide?",
        "options": ["Nivel 1 — Evidencia experimental", "Nivel 3 — Estudio con metodología", "Nivel 4 — Reporte de terceros", "Nivel 5 — Opinión de experto"],
        "correct": 3,
        "explanation": "Sin importar cuán reconocido sea, una opinión sin datos ni metodología es nivel 5. Puede generar hipótesis pero no fundamentar decisiones."
      }
    ],
    "passing_score": 60,
    "exercise_type": "quiz",
    "difficulty": "beginner",
    "estimated_duration_minutes": 4
  }'::jsonb,
  3
)
ON CONFLICT (course_id, exercise_id) DO UPDATE SET
  exercise_data = EXCLUDED.exercise_data,
  lesson_id = EXCLUDED.lesson_id;

-- Quiz 4: Ciclo de decisión (Lección 2.1)
INSERT INTO course_exercises (id, course_id, module_id, lesson_id, exercise_id, exercise_type, exercise_data, order_index)
VALUES (
  gen_random_uuid(),
  'db000000-0000-0000-0000-000000000001',
  'db020000-0000-0000-0000-000000000001',
  'db020100-0000-0000-0000-000000000001',
  'db-ex-04',
  'quiz',
  '{
    "id": "db-ex-04",
    "title": "El ciclo de decisión en acción",
    "description": "Evalúa tu comprensión del ciclo de decisión basada en datos y detecta cuándo se saltan etapas críticas.",
    "questions": [
      {
        "question": "Un equipo dice: ''Ventas bajas, necesitamos más publicidad'' e inmediatamente lanzan campaña de $50K. ¿Qué etapa saltaron primero?",
        "options": ["Definir — no acotaron por qué ni dónde caen las ventas", "Recopilar — no buscaron información", "Evaluar — no midieron impacto", "Analizar — no compararon benchmarks"],
        "correct": 0,
        "explanation": "''Ventas bajas'' es un síntoma, no un problema definido. ¿Bajas respecto a qué? ¿En qué productos? ¿Desde cuándo? Sin definir, cualquier solución es un disparo al aire."
      },
      {
        "question": "Una empresa recopiló datos 6 meses sobre rotación. Llevan 3 meses analizando sin decidir. ¿Qué trampa experimentan?",
        "options": ["Sesgo de confirmación", "Parálisis por análisis", "Datos insuficientes", "Problema mal definido"],
        "correct": 1,
        "explanation": "Tienen datos suficientes pero no avanzan a decidir. El análisis se convirtió en sustituto de la acción."
      },
      {
        "question": "Un gerente define el problema como: ''Necesitamos mejorar la calidad.'' ¿Qué está mal?",
        "options": ["No es específica ni medible", "No incluye presupuesto", "Debería ser afirmación", "No menciona competidores"],
        "correct": 0,
        "explanation": "''Mejorar la calidad'' es vago. Mejor: ''Reducir tasa de defectos en línea X del 5% al 2% en 6 meses.'' Específico, medible, acotado."
      },
      {
        "question": "Un producto nuevo superó proyecciones 25%. El equipo celebra y pasa al siguiente proyecto sin revisión post-lanzamiento. ¿Qué etapa ignoraron?",
        "options": ["Definir", "Recopilar", "Analizar", "Evaluar — no analizaron por qué funcionó"],
        "correct": 3,
        "explanation": "La etapa más ignorada cuando las cosas salen bien. Sin entender POR QUÉ funcionó, no pueden replicar el éxito."
      },
      {
        "question": "¿Cuál es el orden correcto de las 5 etapas del ciclo de decisión?",
        "options": ["Definir → Recopilar → Analizar → Decidir → Evaluar", "Recopilar → Definir → Analizar → Evaluar → Decidir", "Analizar → Recopilar → Definir → Decidir → Evaluar", "Definir → Analizar → Recopilar → Decidir → Evaluar"],
        "correct": 0,
        "explanation": "Definir → Recopilar → Analizar → Decidir → Evaluar. Primero defines qué necesitas saber, luego buscas datos, analizas, decides y evalúas."
      }
    ],
    "passing_score": 60,
    "exercise_type": "quiz",
    "difficulty": "intermediate",
    "estimated_duration_minutes": 5
  }'::jsonb,
  4
)
ON CONFLICT (course_id, exercise_id) DO UPDATE SET
  exercise_data = EXCLUDED.exercise_data,
  lesson_id = EXCLUDED.lesson_id;

-- Quiz 5: Métrica accionable o decorativa (Lección 2.2)
INSERT INTO course_exercises (id, course_id, module_id, lesson_id, exercise_id, exercise_type, exercise_data, order_index)
VALUES (
  gen_random_uuid(),
  'db000000-0000-0000-0000-000000000001',
  'db020000-0000-0000-0000-000000000001',
  'db020200-0000-0000-0000-000000000001',
  'db-ex-05',
  'quiz',
  '{
    "id": "db-ex-05",
    "title": "¿Métrica accionable o decorativa?",
    "description": "Identifica si las métricas son accionables o decorativas según sus características.",
    "questions": [
      {
        "question": "''Seguidores en redes sociales'': se reporta mensualmente. Crece un poco cada mes. Sin objetivo ni acción.",
        "options": ["Accionable", "Decorativa"],
        "correct": 1,
        "explanation": "Vanity metric clásica: crece naturalmente, sin umbral ni acción. ¿Cuántos se convierten en clientes? Eso sí sería accionable."
      },
      {
        "question": "''Abandono de carrito > 70%'': activa revisión de UX por Product Manager. Semanal. Si > 75%, se pausan features para priorizar conversión.",
        "options": ["Accionable", "Decorativa"],
        "correct": 0,
        "explanation": "Umbral (70% y 75%), dueño (Product Manager), frecuencia (semanal) y acción definida. Es una métrica que cambia comportamiento."
      },
      {
        "question": "''Ingresos trimestrales'': se presenta en junta con gráficas de tendencia. Se compara con trimestre y año anterior.",
        "options": ["Accionable", "Decorativa"],
        "correct": 1,
        "explanation": "Indicador rezagado sin acción definida. Cuando ves los ingresos trimestrales, ya es tarde para cambiar ese trimestre."
      },
      {
        "question": "''Pipeline de ventas < $500K'': alerta automática al VP Ventas, quien activa prospección de 2 semanas. Se revisa diariamente.",
        "options": ["Accionable", "Decorativa"],
        "correct": 0,
        "explanation": "Indicador adelantado con umbral ($500K), dueño (VP Ventas), frecuencia (diaria) y acción definida (prospección 2 semanas)."
      },
      {
        "question": "''Horas de capacitación por empleado'': se reporta en informe anual de RRHH. 24 horas promedio. Sin objetivo definido.",
        "options": ["Accionable", "Decorativa"],
        "correct": 1,
        "explanation": "Sin objetivo, umbral ni acción. ¿24 horas es bueno o malo? ¿Quién decide? Es un número que se reporta por obligación."
      },
      {
        "question": "¿Cuál es la diferencia entre indicador adelantado (leading) y rezagado (lagging)?",
        "options": ["Adelantados son cuantitativos, rezagados cualitativos", "Adelantados predicen resultados futuros, rezagados miden resultados pasados", "Adelantados son más precisos", "Adelantados se usan en finanzas, rezagados en operaciones"],
        "correct": 1,
        "explanation": "Adelantados predicen y permiten actuar antes. Rezagados confirman lo que ya pasó. Ambos pueden ser cuantitativos y usarse en cualquier área."
      }
    ],
    "passing_score": 60,
    "exercise_type": "quiz",
    "difficulty": "intermediate",
    "estimated_duration_minutes": 5
  }'::jsonb,
  5
)
ON CONFLICT (course_id, exercise_id) DO UPDATE SET
  exercise_data = EXCLUDED.exercise_data,
  lesson_id = EXCLUDED.lesson_id;

-- Quiz 6: Costo-beneficio (Lección 2.3)
INSERT INTO course_exercises (id, course_id, module_id, lesson_id, exercise_id, exercise_type, exercise_data, order_index)
VALUES (
  gen_random_uuid(),
  'db000000-0000-0000-0000-000000000001',
  'db020000-0000-0000-0000-000000000001',
  'db020300-0000-0000-0000-000000000001',
  'db-ex-06',
  'quiz',
  '{
    "id": "db-ex-06",
    "title": "Evalúa la decisión con costo-beneficio",
    "description": "Aplica los conceptos de análisis costo-beneficio para evaluar decisiones.",
    "questions": [
      {
        "question": "Invirtieron $300K en un sistema que no funciona. Necesitan $100K para arreglarlo o $150K para uno nuevo. El gerente dice: ''Ya invertimos $300K, no podemos tirarlo.'' ¿Qué error?",
        "options": ["Ignora costo de oportunidad", "Falacia de costos hundidos", "No considera costos indirectos", "Sobreestima beneficios"],
        "correct": 1,
        "explanation": "Los $300K son irrecuperables. La decisión compara solo: ¿$100K para mediocre o $150K para uno que funciona? Los $300K no deberían influir."
      },
      {
        "question": "Evalúan automatizar un proceso. Solo cuentan software ($50K) y ahorro nómina ($80K/año). No incluyen capacitación ni productividad perdida. ¿Qué ignoran?",
        "options": ["Costos hundidos", "Costos indirectos", "Costo de oportunidad", "Costos directos"],
        "correct": 1,
        "explanation": "Capacitación, transición y productividad perdida son costos indirectos — no aparecen en la factura pero afectan el beneficio neto real."
      },
      {
        "question": "Un equipo evalúa 2 opciones sin incluir ''no hacer nada''. ¿Por qué es un error?",
        "options": ["No hacer nada siempre es mejor", "Sin status quo no sabes si alguna opción genera valor real", "Se necesitan mínimo 5 opciones", "El status quo elimina sesgos"],
        "correct": 1,
        "explanation": "El status quo es la línea base. Ambas opciones podrían ser peores que no hacer nada. Solo lo sabes si lo evalúas."
      },
      {
        "question": "Tienda: $20K para renovar local ($8K/año extra) o tienda online ($15K/año extra). Eligen renovar. ¿Costo de oportunidad?",
        "options": ["$20,000", "$15,000/año", "$8,000/año", "$7,000/año"],
        "correct": 1,
        "explanation": "El costo de oportunidad es el valor de la mejor alternativa sacrificada: $15K/año de la tienda online que no se creó."
      },
      {
        "question": "Escenarios: optimista $200K (30%), probable $50K (50%), pesimista -$80K (20%). ¿Valor esperado y decisión?",
        "options": ["$69K — proyecto viable", "$50K — usar escenario probable", "$69K, pero 20% de perder $80K requiere evaluar tolerancia al riesgo", "$56.67K — promedio simple"],
        "correct": 2,
        "explanation": "VE = ($200K×0.30) + ($50K×0.50) + (-$80K×0.20) = $69K. Positivo, pero un 20% de perder $80K puede ser inaceptable según el contexto."
      }
    ],
    "passing_score": 60,
    "exercise_type": "quiz",
    "difficulty": "intermediate",
    "estimated_duration_minutes": 5
  }'::jsonb,
  6
)
ON CONFLICT (course_id, exercise_id) DO UPDATE SET
  exercise_data = EXCLUDED.exercise_data,
  lesson_id = EXCLUDED.lesson_id;

-- Quiz 7: Caso expansión (Lección 3.1)
INSERT INTO course_exercises (id, course_id, module_id, lesson_id, exercise_id, exercise_type, exercise_data, order_index)
VALUES (
  gen_random_uuid(),
  'db000000-0000-0000-0000-000000000001',
  'db030000-0000-0000-0000-000000000001',
  'db030100-0000-0000-0000-000000000001',
  'db-ex-07',
  'quiz',
  '{
    "id": "db-ex-07",
    "title": "Caso: Análisis de expansión",
    "description": "Analiza el caso de Distribuidora del Istmo y toma decisiones basadas en evidencia.",
    "questions": [
      {
        "question": "El CEO visitó San Pedro Sula y concluyó que ''la competencia es débil''. Los datos: 6 competidores, 78% penetración. ¿Qué sesgo probablemente afectó al CEO?",
        "options": ["Sesgo de confirmación — buscó evidencia de oportunidad", "Efecto Dunning-Kruger — sobreestima su conocimiento del mercado", "Sesgo de anclaje", "Ambos A y B son probables"],
        "correct": 3,
        "explanation": "Buscó señales que confirmaran su deseo de expandir (confirmación) y con 2 días de visita sobreestimó su comprensión del mercado (Dunning-Kruger)."
      },
      {
        "question": "Ciudad C lleva 3 años sin equilibrio, NPS 45, rotación 28%. Si abren San Pedro Sula sin resolver C, ¿qué riesgo principal?",
        "options": ["San Pedro Sula más exitosa que C", "Diluyen recursos en dos operaciones problemáticas", "Competidores copien modelo", "CEO pierde credibilidad"],
        "correct": 1,
        "explanation": "Con Ciudad C sin equilibrio y equipo al límite, abrir otra operación diluye recursos entre dos frentes problemáticos."
      },
      {
        "question": "Escenario conservador: ingresos $35K/mes vs. costos $45K/mes. ¿Qué significa?",
        "options": ["Irrelevante — el optimista sí es rentable", "Pérdidas de $10K/mes — riesgo significativo", "Solo importa si probabilidad > 50%", "Hay que reducir costos operativos"],
        "correct": 1,
        "explanation": "Pérdidas de $10K/mes ($120K/año) es señal de alarma seria. No se puede ignorar porque el optimista compense."
      },
      {
        "question": "¿Por qué fortalecer Ciudad C ($200K) tiene mejor perfil que San Pedro Sula ($350K)?",
        "options": ["Es más barata", "Ciudad C ya tiene infraestructura, equipo y clientes — retorno más predecible", "Honduras es mercado más difícil", "El CEO prefiere esta opción"],
        "correct": 1,
        "explanation": "Ciudad C tiene activos existentes que reducen incertidumbre. Mejorar algo que existe es más predecible que crear desde cero."
      },
      {
        "question": "''Invertir en Ciudad C y reconsiderar San Pedro Sula en 12-18 meses.'' ¿Qué etapa del ciclo es?",
        "options": ["Recopilar datos", "Analizar evidencia", "Decidir y actuar, con fecha de reevaluación", "Evaluar resultados"],
        "correct": 2,
        "explanation": "Etapa 4 bien ejecutada: decisión clara, acción definida y fecha de revisión. Posponer con criterios es una decisión válida."
      }
    ],
    "passing_score": 60,
    "exercise_type": "quiz",
    "difficulty": "intermediate",
    "estimated_duration_minutes": 5
  }'::jsonb,
  7
)
ON CONFLICT (course_id, exercise_id) DO UPDATE SET
  exercise_data = EXCLUDED.exercise_data,
  lesson_id = EXCLUDED.lesson_id;

-- Quiz 8: Caso recursos (Lección 3.2)
INSERT INTO course_exercises (id, course_id, module_id, lesson_id, exercise_id, exercise_type, exercise_data, order_index)
VALUES (
  gen_random_uuid(),
  'db000000-0000-0000-0000-000000000001',
  'db030000-0000-0000-0000-000000000001',
  'db030200-0000-0000-0000-000000000001',
  'db-ex-08',
  'quiz',
  '{
    "id": "db-ex-08",
    "title": "Caso: Optimización de recursos",
    "description": "Analiza el caso de TechServ Panamá y evalúa opciones de reducción vs. reasignación.",
    "questions": [
      {
        "question": "Ventas tiene ratio 3.33 y pipeline de $400K. El líder pide 3 vendedores más. ¿Qué tipo de dato respalda esto?",
        "options": ["Cuantitativo primario — pipeline en CRM", "Cualitativo primario — opinión del líder", "Ambos — pipeline es cuantitativo, estimación de impacto es cualitativa", "Secundario — benchmarks del sector"],
        "correct": 2,
        "explanation": "El pipeline ($400K) es cuantitativo verificable en CRM. La estimación de que 3 vendedores lo cerrarían es cualitativa (juicio experto). Se complementan."
      },
      {
        "question": "Capacitación: utilización 45%, ratio ingreso/costo 0.56. ¿Qué significa para la decisión?",
        "options": ["Eliminar el departamento", "Capacidad ociosa que podría redirigirse a mayor valor", "Es eficiente — genera $0.56 por $1", "Necesitan más presupuesto"],
        "correct": 1,
        "explanation": "55% sin usar + ratio bajo = no se paga a sí mismo. Pero redirigir personas (presentación, formación) a ventas o soporte premium genera más valor que despedirlas."
      },
      {
        "question": "Despedir 12: ahorro $180K, liquidaciones $90K. ¿Ahorro neto real del primer año?",
        "options": ["$180,000", "$90,000", "Menos de $90K — también cae productividad de sobrevivientes", "$270,000"],
        "correct": 2,
        "explanation": "$180K - $90K = $90K. Pero productividad cae 15-20% por meses en los 73 restantes. El costo real en productividad puede superar el ahorro neto."
      },
      {
        "question": "Desarrollo: 92% utilización, 8 semanas de backlog. ¿Por qué despedir aquí sería especialmente dañino?",
        "options": ["Desarrolladores son más caros de reemplazar", "Menos personas = rechazar proyectos con ingresos", "Moral ya frágil (NPS 55)", "Las tres razones se refuerzan"],
        "correct": 3,
        "explanation": "Las tres se refuerzan: costo de reemplazo ($15K), pérdida de ingresos (92% + backlog) y moral frágil. Impacto triple."
      },
      {
        "question": "Despedir (ahorro $90K neto) vs. Reasignar (inversión $40K, ingreso +$300-500K). ¿Cuál aborda la causa raíz?",
        "options": ["Despedir — reduce costos", "Reasignar — el problema es ingresos, no costos", "Ninguna — necesitan financiamiento", "Ambas igualmente válidas"],
        "correct": 1,
        "explanation": "La causa raíz: ingresos estancados. Despedir trata el síntoma. Reasignar personas ociosas a áreas de ingreso ataca la causa y usa recursos existentes."
      }
    ],
    "passing_score": 60,
    "exercise_type": "quiz",
    "difficulty": "intermediate",
    "estimated_duration_minutes": 5
  }'::jsonb,
  8
)
ON CONFLICT (course_id, exercise_id) DO UPDATE SET
  exercise_data = EXCLUDED.exercise_data,
  lesson_id = EXCLUDED.lesson_id;

-- Quiz 9: Quiz final integrador (Lección 3.3)
INSERT INTO course_exercises (id, course_id, module_id, lesson_id, exercise_id, exercise_type, exercise_data, order_index)
VALUES (
  gen_random_uuid(),
  'db000000-0000-0000-0000-000000000001',
  'db030000-0000-0000-0000-000000000001',
  'db030300-0000-0000-0000-000000000001',
  'db-ex-09',
  'quiz',
  '{
    "id": "db-ex-09",
    "title": "Quiz final: Integración de conceptos",
    "description": "Demuestra tu dominio de todos los conceptos del curso: sesgos, ciclo de decisión, métricas, costo-beneficio y casos.",
    "questions": [
      {
        "question": "Un director presenta 50 páginas recomendando entrar a un mercado. No evaluó ''no entrar''. ¿Qué problemas combinados tiene?",
        "options": ["Sesgo de confirmación + omitir status quo en ACB", "Sesgo de anclaje + parálisis por análisis", "Sesgo de supervivencia + métricas decorativas", "Dunning-Kruger + costos hundidos"],
        "correct": 0,
        "explanation": "Solo evaluó la opción preferida (confirmación) y excluyó el status quo. Un buen ACB siempre incluye ''no hacer nada'' como referencia."
      },
      {
        "question": "Dashboard con: (1) Ingresos totales, (2) NPS trimestral, (3) Cycle time > 48h con alerta al Team Lead, (4) Seguidores en redes. ¿Cuántas accionables?",
        "options": ["1 — solo la 3", "2 — la 1 y 3", "3 — la 1, 2 y 3", "4 — todas"],
        "correct": 0,
        "explanation": "Solo la 3: umbral (> 48h), dueño (Team Lead), acción (investigar). Las demás son informativas sin umbral, dueño ni acción específica."
      },
      {
        "question": "Proyecto: optimista +$200K (30%), probable +$50K (50%), pesimista -$80K (20%). Inversión: $100K. ¿Valor esperado y decisión?",
        "options": ["$69K — viable", "$50K — usar escenario probable", "$69K, pero 20% de perder $80K requiere evaluar tolerancia al riesgo", "$56.67K — promedio simple"],
        "correct": 2,
        "explanation": "VE = $60K + $25K - $16K = $69K. Positivo, pero un 20% de perder $80K puede ser inaceptable. El VE informa, la tolerancia al riesgo decide."
      },
      {
        "question": "Invirtieron $400K en un producto. El mercado cambió. Necesitan $200K más para lanzar. ¿Decisión correcta?",
        "options": ["Continuar — ya invertimos $400K", "Evaluar si $200K adicionales generarán retorno, ignorando los $400K", "Pedir más presupuesto", "Pausar y recopilar 6 meses más"],
        "correct": 1,
        "explanation": "Los $400K son costos hundidos. La pregunta: ¿$200K más generarán retorno dado el mercado actual? Si no, parar — sin importar lo invertido."
      },
      {
        "question": "¿Qué distingue fundamentalmente una decisión basada en datos de una basada en intuición?",
        "options": ["Siempre usa estadística avanzada", "Es auditable, repetible y mejorable", "Nunca falla", "Toma más tiempo"],
        "correct": 1,
        "explanation": "La diferencia: puedes revisar cómo se decidió (auditable), otros pueden seguir el proceso (repetible) y aprendes de resultados (mejorable)."
      },
      {
        "question": "CEO: ''No necesitamos datos, conozco el negocio hace 20 años.'' ¿Mejor respuesta?",
        "options": ["Tiene razón — 20 años superan cualquier análisis", "Su experiencia es valiosa como hipótesis, debe validarse con datos actuales", "Está completamente equivocado", "Debería delegar a analistas"],
        "correct": 1,
        "explanation": "20 años son nivel 1 (opinión informada) — valiosa para hipótesis pero el mercado puede haber cambiado. Los datos verifican si la intuición sigue vigente."
      },
      {
        "question": "Orden correcto del framework de decisión:",
        "options": ["Clasificar → Definir → Recopilar → Verificar sesgos → Evaluar → Documentar → Revisar", "Definir → Recopilar → Verificar → Clasificar → Evaluar → Revisar → Documentar", "Recopilar → Clasificar → Definir → Evaluar → Verificar → Documentar → Revisar", "Verificar → Definir → Clasificar → Recopilar → Evaluar → Documentar → Revisar"],
        "correct": 0,
        "explanation": "Clasificar (tipo) → Definir (problema) → Recopilar (datos) → Verificar (sesgos) → Evaluar (opciones) → Documentar (decisión) → Revisar (resultados)."
      },
      {
        "question": "¿Qué es la ''regla del 70%'' y qué problema resuelve?",
        "options": ["70% de decisiones deben basarse en datos", "Decide con 70% de información — resuelve parálisis por análisis", "70% de proyectos fracasan", "70% de métricas son decorativas"],
        "correct": 1,
        "explanation": "Bezos: decide con ~70% de la información deseada. Si esperas al 90%, eres demasiado lento. Resuelve la parálisis por análisis."
      }
    ],
    "passing_score": 60,
    "exercise_type": "quiz",
    "difficulty": "advanced",
    "estimated_duration_minutes": 8
  }'::jsonb,
  9
)
ON CONFLICT (course_id, exercise_id) DO UPDATE SET
  exercise_data = EXCLUDED.exercise_data,
  lesson_id = EXCLUDED.lesson_id;

-- 5. Verificación
SELECT
    'Curso Decisiones Basadas en Datos creado' as status,
    (SELECT COUNT(*) FROM courses WHERE slug = 'decisiones-basadas-datos') as cursos,
    (SELECT COUNT(*) FROM modules WHERE course_id = 'db000000-0000-0000-0000-000000000001') as modulos,
    (SELECT COUNT(*) FROM lessons WHERE course_id = 'db000000-0000-0000-0000-000000000001') as lecciones,
    (SELECT COUNT(*) FROM course_exercises WHERE course_id = 'db000000-0000-0000-0000-000000000001') as ejercicios;
