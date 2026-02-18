## IA como sparring estrategico

### Tu mejor adversario no tiene ego

Los mejores estrategas no buscan validacion — buscan que alguien desmonte sus ideas. En los equipos ejecutivos de alto rendimiento, esa funcion la cumple el "abogado del diablo": alguien que deliberadamente argumenta en contra de la propuesta para encontrar debilidades. El problema es que en la mayoria de las organizaciones, ese rol no existe o nadie quiere asumirlo.

La IA generativa no reemplaza al equipo estrategico, pero ofrece algo que pocos colegas pueden dar: **critica sin politica interna, disponibilidad inmediata y la capacidad de adoptar cualquier perspectiva que le pidas**. Davenport y Ronanki (2018) identificaron en Harvard Business Review que una de las aplicaciones mas subvaloradas de la IA es precisamente esta: no como generadora de respuestas, sino como generadora de preguntas.

---

### Tecnicas de sparring estrategico con IA

#### 1. Analisis FODA/SWOT asistido

El analisis FODA clasico funciona bien como framework, pero suele producir listas genericas cuando lo hace un solo equipo con sus propios sesgos. La IA puede enriquecer cada cuadrante desde perspectivas que el equipo no considero.

**Prompt efectivo:**

> *"Actua como consultor estrategico para una empresa de logistica de ultima milla en Argentina con 200 empleados. A partir de esta informacion [pegar contexto], genera un analisis FODA. Para cada punto, explica por que lo clasificas ahi y que evidencia lo soporta. Incluye al menos 2 amenazas que el equipo directivo probablemente no ha considerado."*

La instruccion final — "amenazas que probablemente no han considerado" — es la que genera valor real. Obliga al modelo a ir mas alla de lo obvio.

#### 2. Planificacion de escenarios

Pedir a la IA que construya 3 escenarios (optimista, base, pesimista) para una decision estrategica, con supuestos explicitos para cada uno.

#### 3. Red teaming (argumentar en contra)

Pedir al modelo que actue como un inversor esceptico, un competidor, o un regulador y argumente por que tu plan va a fracasar.

#### 4. Pre-mortem

La tecnica mas poderosa. Desarrollada por Gary Klein (2007) y publicada en Harvard Business Review, consiste en imaginar que el proyecto ya fracaso y trabajar hacia atras para identificar las causas.

---

### Caso: Pre-mortem de un lanzamiento de producto con Claude

**Contexto:** Una startup de foodtech en Chile va a lanzar un servicio de suscripcion de comidas saludables para oficinas corporativas. El equipo esta entusiasmado. Nadie ha cuestionado seriamente el plan.

**Prompt:**

> *"Imagina que es diciembre de 2026 y el servicio de suscripcion de comidas saludables para oficinas corporativas que lanzamos en Chile fracaso completamente. La empresa perdio el 60% de su inversion inicial. Trabaja hacia atras: genera 7 razones plausibles y especificas por las que fracaso. Para cada una, indica: (1) la causa raiz, (2) la senal de alerta temprana que ignoramos, y (3) que podriamos haber hecho para prevenirlo. Se brutal — necesito las criticas que mi equipo no se atreve a hacer."*

**Resultado tipico de Claude:**

| Causa de fracaso | Senal ignorada | Prevencion |
|---|---|---|
| Tasa de rotacion de oficinas: las empresas cancelan cuando reducen personal | Tendencia de layoffs en sector tech Chile H2 2026 | Contratos minimos de 6 meses con penalizacion |
| Logistica de "ultima milla fria" subestimada: la cadena de frio para 50+ entregas diarias es 3x mas costosa que la proyeccion | No se hizo piloto real de logistica antes del lanzamiento | Piloto de 4 semanas con 10 oficinas antes de escalar |
| Competencia de apps de delivery con opcion "saludable" a menor precio y sin suscripcion | iFood y Rappi ya ofrecen filtros de comida saludable | Diferenciacion clara: nutricionista dedicada, menu semanal personalizado |
| Desperdicio de alimentos superior al 20% por variabilidad de asistencia a oficinas | Datos de asistencia post-pandemia muestran 60-70%, no 90% | Modelo flexible basado en asistencia real, no en headcount |

Este tipo de analisis no reemplaza la investigacion de mercado real. Pero en 10 minutos produce preguntas que le habrian tomado al equipo semanas descubrir — o que nunca habrian formulado por optimismo grupal.

---

### Caso: Analisis competitivo con DeepSeek

**Contexto:** Una cadena de farmacias en Centroamerica necesita analizar 15 competidores antes de definir su estrategia de expansion. El analisis requiere multiples iteraciones.

**Por que DeepSeek aqui:** El analisis competitivo iterativo implica muchas consultas sucesivas — refinar, pedir mas detalle, explorar hipotesis. DeepSeek ofrece capacidad analitica competente a un costo significativamente menor que Claude o Gemini, lo que lo hace ideal para las fases exploratorias donde el volumen de interaccion es alto y no necesitas maxima precision en cada respuesta.

**Flujo recomendado:** Usa DeepSeek para las 10-15 iteraciones exploratorias. Cuando tengas las hipotesis consolidadas, pasa a Claude para el analisis final con mayor profundidad y matiz.

---

### Limitaciones criticas: lo que la IA NO puede hacer en estrategia

Esta es la seccion mas importante de esta leccion. La IA como sparring estrategico tiene limites reales y peligrosos si no los reconoces.

**1. Alucinaciones en datos de mercado.** Los modelos pueden inventar estadisticas, participaciones de mercado, o datos de competidores con total confianza. Si Claude dice "el mercado de foodtech en Chile crecio un 34% en 2025", verifica esa cifra. Puede ser real o completamente fabricada.

**2. Datos de entrenamiento desactualizados.** Los modelos tienen una fecha de corte en sus datos. No conocen tu mercado local en tiempo real, ni la ultima regulacion de tu pais, ni el movimiento reciente de tu competidor. Kaplan y Haenlein (2019) advierten que la IA es tan buena como los datos que la alimentan.

**3. Ausencia de contexto local.** Un modelo sabe que existe Peru, pero no conoce las dinamicas especificas de negociar con distribuidores en Arequipa vs. Lima. El contexto hiperlocal — relaciones, cultura organizacional, regulaciones municipales — es algo que solo tu equipo tiene.

**4. Sobreconfianza en las respuestas.** Los modelos generan texto con el mismo nivel de certeza independientemente de si estan seguros o adivinando. No dicen "no se" con la frecuencia que deberian. Esto es peligroso en contextos estrategicos donde la falsa precision mata.

---

### Como mitigar las limitaciones

| Limitacion | Mitigacion practica |
|---|---|
| Alucinaciones de datos | Usa IA para **estructura y preguntas**, no para datos facticos. Toda cifra se verifica |
| Datos desactualizados | Alimenta al modelo con datos recientes: reportes, noticias, estados financieros publicos |
| Falta de contexto local | Incluye contexto relevante en cada prompt. La IA no adivina — necesita que le cuentes |
| Sobreconfianza | Pide explicitamente: "indica tu nivel de confianza en cada afirmacion y senala donde estas especulando" |

---

### La ventaja humano + IA

La combinacion optima no es "IA decide" ni "humano decide solo". Es un ciclo:

1. **Humano** define la pregunta estrategica y aporta contexto real
2. **IA** genera estructura, escenarios, criticas y preguntas no consideradas
3. **Humano** evalua, descarta lo irrelevante, verifica datos y aplica juicio
4. **IA** refina basandose en la retroalimentacion humana
5. **Humano** toma la decision final con mayor informacion y menos puntos ciegos

Davenport y Ronanki (2018) lo resumen asi: la IA no toma mejores decisiones que los humanos — permite que los humanos tomen mejores decisiones al ampliar la superficie de lo que consideran.

---

### Tu turno

<!-- exercise:ia-ex-06 -->

---

**Referencias:**

- Kaplan, A. & Haenlein, M. (2019). "Siri, Siri, in my hand: Who's the fairest in the land?" *Business Horizons*, 62(1).
- Davenport, T.H. & Ronanki, R. (2018). "Artificial Intelligence for the Real World." *Harvard Business Review*, 96(1).
- Klein, G. (2007). "Performing a Project Premortem." *Harvard Business Review*, 85(9).
- Tetlock, P. & Gardner, D. (2015). *Superforecasting: The Art and Science of Prediction*. Crown.
