## IA como sparring estratégico

### Tu mejor adversario no tiene ego

Los mejores estrategas no buscan validación — buscan que alguien desmonte sus ideas. En los equipos ejecutivos de alto rendimiento, esa función la cumple el "abogado del diablo": alguien que deliberadamente argumenta en contra de la propuesta para encontrar debilidades. El problema es que en la mayoría de las organizaciones, ese rol no existe o nadie quiere asumirlo.

La IA generativa no reemplaza al equipo estratégico, pero ofrece algo que pocos colegas pueden dar: **crítica sin política interna, disponibilidad inmediata y la capacidad de adoptar cualquier perspectiva que le pidas**. Davenport y Ronanki (2018) identificaron en Harvard Business Review que una de las aplicaciones más subvaloradas de la IA es precisamente esta: no como generadora de respuestas, sino como generadora de preguntas.

---

### Técnicas de sparring estratégico con IA

#### 1. Análisis FODA/SWOT asistido

El análisis FODA clásico funciona bien como framework, pero suele producir listas genéricas cuando lo hace un solo equipo con sus propios sesgos. La IA puede enriquecer cada cuadrante desde perspectivas que el equipo no consideró.

**Prompt efectivo:**

> *"Actúa como consultor estratégico para una empresa de logística de última milla en Argentina con 200 empleados. A partir de esta información [pegar contexto], genera un análisis FODA. Para cada punto, explica por qué lo clasificas ahí y qué evidencia lo soporta. Incluye al menos 2 amenazas que el equipo directivo probablemente no ha considerado."*

La instrucción final — "amenazas que probablemente no han considerado" — es la que genera valor real. Obliga al modelo a ir más allá de lo obvio.

#### 2. Planificación de escenarios

Pedir a la IA que construya 3 escenarios (optimista, base, pesimista) para una decisión estratégica, con supuestos explícitos para cada uno.

#### 3. Red teaming (argumentar en contra)

Pedir al modelo que actúe como un inversor escéptico, un competidor, o un regulador y argumente por qué tu plan va a fracasar.

#### 4. Pre-mortem

La técnica más poderosa. Desarrollada por Gary Klein (2007) y publicada en Harvard Business Review, consiste en imaginar que el proyecto ya fracasó y trabajar hacia atrás para identificar las causas.

---

### Caso: Pre-mortem de un lanzamiento de producto con Claude

**Contexto:** Una startup de foodtech en Chile va a lanzar un servicio de suscripción de comidas saludables para oficinas corporativas. El equipo está entusiasmado. Nadie ha cuestionado seriamente el plan.

**Prompt:**

> *"Imagina que es diciembre de 2026 y el servicio de suscripción de comidas saludables para oficinas corporativas que lanzamos en Chile fracasó completamente. La empresa perdió el 60% de su inversión inicial. Trabaja hacia atrás: genera 7 razones plausibles y específicas por las que fracasó. Para cada una, indica: (1) la causa raíz, (2) la señal de alerta temprana que ignoramos, y (3) qué podríamos haber hecho para prevenirlo. Sé brutal — necesito las críticas que mi equipo no se atreve a hacer."*

**Resultado típico de Claude:**

| Causa de fracaso | Señal ignorada | Prevención |
|---|---|---|
| Tasa de rotación de oficinas: las empresas cancelan cuando reducen personal | Tendencia de layoffs en sector tech Chile H2 2026 | Contratos mínimos de 6 meses con penalización |
| Logística de "última milla fría" subestimada: la cadena de frío para 50+ entregas diarias es 3x más costosa que la proyección | No se hizo piloto real de logística antes del lanzamiento | Piloto de 4 semanas con 10 oficinas antes de escalar |
| Competencia de apps de delivery con opción "saludable" a menor precio y sin suscripción | iFood y Rappi ya ofrecen filtros de comida saludable | Diferenciación clara: nutricionista dedicada, menú semanal personalizado |
| Desperdicio de alimentos superior al 20% por variabilidad de asistencia a oficinas | Datos de asistencia post-pandemia muestran 60-70%, no 90% | Modelo flexible basado en asistencia real, no en headcount |

Este tipo de análisis no reemplaza la investigación de mercado real. Pero en 10 minutos produce preguntas que le habrían tomado al equipo semanas descubrir — o que nunca habrían formulado por optimismo grupal.

---

### Caso: Análisis competitivo con DeepSeek

**Contexto:** Una cadena de farmacias en Centroamérica necesita analizar 15 competidores antes de definir su estrategia de expansión. El análisis requiere múltiples iteraciones.

**Por qué DeepSeek aquí:** El análisis competitivo iterativo implica muchas consultas sucesivas — refinar, pedir más detalle, explorar hipótesis. DeepSeek ofrece capacidad analítica competente a un costo significativamente menor que Claude o Gemini, lo que lo hace ideal para las fases exploratorias donde el volumen de interacción es alto y no necesitas máxima precisión en cada respuesta.

**Flujo recomendado:** Usa DeepSeek para las 10-15 iteraciones exploratorias. Cuando tengas las hipótesis consolidadas, pasa a Claude para el análisis final con mayor profundidad y matiz.

---

### Limitaciones críticas: lo que la IA NO puede hacer en estrategia

Esta es la sección más importante de esta lección. La IA como sparring estratégico tiene límites reales y peligrosos si no los reconoces.

**1. Alucinaciones en datos de mercado.** Los modelos pueden inventar estadísticas, participaciones de mercado, o datos de competidores con total confianza. Si Claude dice "el mercado de foodtech en Chile creció un 34% en 2025", verifica esa cifra. Puede ser real o completamente fabricada.

**2. Datos de entrenamiento desactualizados.** Los modelos tienen una fecha de corte en sus datos. No conocen tu mercado local en tiempo real, ni la última regulación de tu país, ni el movimiento reciente de tu competidor. Kaplan y Haenlein (2019) advierten que la IA es tan buena como los datos que la alimentan.

**3. Ausencia de contexto local.** Un modelo sabe que existe Perú, pero no conoce las dinámicas específicas de negociar con distribuidores en Arequipa vs. Lima. El contexto hiperlocal — relaciones, cultura organizacional, regulaciones municipales — es algo que solo tu equipo tiene.

**4. Sobreconfianza en las respuestas.** Los modelos generan texto con el mismo nivel de certeza independientemente de si están seguros o adivinando. No dicen "no sé" con la frecuencia que deberían. Esto es peligroso en contextos estratégicos donde la falsa precisión mata.

---

### Cómo mitigar las limitaciones

| Limitación | Mitigación práctica |
|---|---|
| Alucinaciones de datos | Usa IA para **estructura y preguntas**, no para datos fácticos. Toda cifra se verifica |
| Datos desactualizados | Alimenta al modelo con datos recientes: reportes, noticias, estados financieros públicos |
| Falta de contexto local | Incluye contexto relevante en cada prompt. La IA no adivina — necesita que le cuentes |
| Sobreconfianza | Pide explícitamente: "indica tu nivel de confianza en cada afirmación y señala donde estás especulando" |

---

### La ventaja humano + IA

La combinación óptima no es "IA decide" ni "humano decide solo". Es un ciclo:

1. **Humano** define la pregunta estratégica y aporta contexto real
2. **IA** genera estructura, escenarios, críticas y preguntas no consideradas
3. **Humano** evalúa, descarta lo irrelevante, verifica datos y aplica juicio
4. **IA** refina basándose en la retroalimentación humana
5. **Humano** toma la decisión final con mayor información y menos puntos ciegos

Davenport y Ronanki (2018) lo resumen así: la IA no toma mejores decisiones que los humanos — permite que los humanos tomen mejores decisiones al ampliar la superficie de lo que consideran.

---

### Tu turno

<!-- exercise:ia-ex-06 -->

---

**Referencias:**

- Kaplan, A. & Haenlein, M. (2019). "Siri, Siri, in my hand: Who's the fairest in the land?" *Business Horizons*, 62(1).
- Davenport, T.H. & Ronanki, R. (2018). "Artificial Intelligence for the Real World." *Harvard Business Review*, 96(1).
- Klein, G. (2007). "Performing a Project Premortem." *Harvard Business Review*, 85(9).
- Tetlock, P. & Gardner, D. (2015). *Superforecasting: The Art and Science of Prediction*. Crown.
